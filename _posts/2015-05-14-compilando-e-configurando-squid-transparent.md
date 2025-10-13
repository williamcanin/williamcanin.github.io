---
layout: post
title: "Compilando e configurando Squid"
description: |
    Quer aprender Proxy Squid? Essa postagem irá te dar uma noção de como configurar o Squid em
    modo Intercept e bloquear palavras e urls através do mesmo em uma navegação web.
author: "William C. Canin"
date: 2015-05-14 09:13:57 -0300
update_date:
comments: true
tags: ["squid","proxy","linux","server"]
---


{% include toc selector=".post-content" max_level=3 title="Índice" btn_hidden="Fechar" btn_show="Abrir" %}

Quer aprender Proxy Squid? Essa postagem irá te dar uma noção de como configurar o Squid em modo Intercept e bloquear palavras e urls através do mesmo em uma navegação web.

-------------

> Nota: A partir da versão 3.1 do Squid Proxy, a palavra `transparent` onde é
> adotada para redirecionar todas requisições da porta 80 para a porta (3128)
> do Squid, e assim forçando os usuários a utilizarem o proxy, ficou obsoleto,
> deve-se substituir por **intercept**.

-------------

*Sistema Operacional usado nesse artigo: [Ubuntu 14.04 LTS](http://releases.ubuntu.com/14.04/)*

Se você tem uma rede de computadores ou até mesmo apenas uma maquina onde gostaria de gerenciar o acesso de conteúdo acessado pelo navegador, esta no artigo certo.

Existem programas que lhe permite fazer esse gerenciamento, mais a grande maioria são versões pagas, é nesse momento que você pensa em fazer pesquisas repetidas na web a procura de uma solução gratuita, prática e profissional. E nesse meio de pesquisas se você não encontrar o Squid Proxy, lhe aconselho a mudar para Marte (hehehe).

[Squid Proxy](http://www.squid-cache.org/) é um servidor proxy bastante conhecido especialmente para sistema GNU/Linux, e será esse camarada que vamos (se me acompanhar até o final desse artigo) instalar e configurar de uma maneira onde realize o gerenciamento via HTTP com <strike>Transparent</strike> **Intercept**, onde o usuário não conseguirá *"driblar"* o proxy.

Vamos la, primeiramente temos que instalar os pacotes que o Squid Proxy necessita para sua compilação.

* ### Dependências de compilação

`Executar comando como root (superusuário)`

{% highlight bash  %}
apt-get install gcc gcc cmake make g++ libssl-dev libcap-dev gawk c++ g++ gcc-multilib libc6 libc6-dev libpam-modules libpam-chroot libpam0g libpam0g-dev && apt-get install openssl*
{% endhighlight %}

Após a instalação, realizaremos o download do source do Squid proxy, no site oficial do mesmo, porem a versão que você terá que baixar tem que ser suportada pela versão de sua distribuição Linux, ou seja, não pode ser versão muita antiga (se sua distro for atual) e nem um muito nova (se sua distro for antiga). Comparando com a versão do meu **Ubuntu**, vou utilizar a versão [3.3.8](http://www.squid-cache.org/Versions/v3/3.3/squid-3.3.8.tar.gz), então fazemos o seguinte procedimento:

* ### Download do source Squid proxy

`Executar comando como root (superusuário)`

{% highlight bash  %}
cd /opt
wget http://www.squid-cache.org/Versions/v3/3.3/squid-3.3.8.tar.gz
{% endhighlight %}

* ### Descompactando

`Executar comando como root (superusuário)`

{% highlight bash  %}
tar zxvf squid-3.3.8.tar.gz
{% endhighlight %}

* ### Entrando na pasta para configuração, compilação e instalação

`Executar comando como root (superusuário)`

{% highlight bash  %}
cd squid-3.3.8
{% endhighlight %}

* ### Configurando a instalação do Squid Proxy

`Executar comando como root (superusuário)`

{% highlight bash linenos %}
./configure --prefix=/usr --includedir=/usr/include --mandir=/usr/share/man --infodir=/usr/share/info --sysconfdir=/etc --localstatedir=/var --libexecdir=/usr/lib/squid --srcdir=. --datadir=/usr/share/squid --sysconfdir=/etc/squid --mandir=/usr/share/man --with-logdir=/var/log/squid --with-pidfile=/var/run/squid.pid --with-filedescriptors=65536 --with-large-files --with-default-user=proxy --enable-ssl
{% endhighlight %}

> Nota: Você simplesmente pode configurar o Squid Proxy com o comando
> **./configure**, porem a instalação sera realizada no diretório padrão do
> Squid. Com essas configurações acima, estamos mantendo uma estrutura de
> organização de instalação melhor para o Squid Proxy. Também estou usando o
> **--enable-ssl** e o **--enable-ssl-crtd**, onde dará suporte para
> SSL (HTTPS), caso queira utilizar o Squid com SSL futuramente. O que **não**
> vou fazer nesse artigo.
> Lembre-se: Em alguma distro, a variável **--with-default-user** pode ser
> squid ou proxy, ai depende de sua distro Linux.

Se não tiver nenhuma mensagem relatando erro no final da configuração, pode realizar a compilação do Squid Proxy. A compilação demora em torno de 7 a 10 minutos, porem isso é relevante, dependerá da potência de sua máquina. A minha demorou em torno de 7 minutos com um processador Intel Core i3 segunda geração :)

* ### Compilando Squid Proxy

`Executar comando como root (superusuário)`

{% highlight bash  %}
make
{% endhighlight %}

* ### Instalando Squid Proxy

`Executar comando como root (superusuário)`

{% highlight bash  %}
make install
{% endhighlight %}

* ### Permissões para o usuário padrão do Squid

Por padrão, nessa instalação, usamos o usuário **proxy**, que é o usuário responsável pelos diretórios de instalação de cache, log e execução do Squid, porem ainda NÃO foi realizado essa permissão para esse usuário, para isso faça:

`Executar comando como root (superusuário)`

{% highlight bash  %}
chown proxy. -R /var/log/squid
chown proxy. -R /var/cache/squid
{% endhighlight %}

> Lembrete: Que o usuário padrão do Squid somente é **proxy** por que nas
> configurações de instalação do Squid, na variável **--with-default-user**, à
> coloquei como proxy, porem isso é relevante, em algumas distribuições, o
> usuário de execução do Squid pode ser outro, como o usuário **squid**.


* ### Criando uma lista de bloqueio

Uma lista de bloqueio será especificamente para o Squid fazer a leitura da mesma e bloquear (ou liberar, dependendo das configurações) os respectivos sites ou palavras que se encontra na lista.
Vamos cria-la no diretório `/etc/squid` com o nome de **blacklist** e coloque no seu conteúdo as palavras ou sites (sem o http), que queira bloquear, por exemplo assim:

**Arquivo:** `/etc/squid/blacklist`

{% highlight text  %}
papajogos.com.br
clickjogos
{% endhighlight %}

> IMPORTANTE! Você não conseguirá bloquear sites que usam **https**, como por
> exemplo o **[Facebook](https://facebook.com)**, pois essas configurações não
> suporta SSL. Se você quiser bloquear sites com HTTPS, terá que se
> submeter a configurações diferentes a essas no Squid, gerando chaves SSL e
> importando para o navegador.

* ### Configurando o Squid Proxy (arquivo squid.conf)

Depois da instalação e demais, tem que realizar algumas configurações no arquivo responsável pela execução e monitoramento do Squid, que será no arquivo **squid.conf**. Utilizaremos uma configuração no arquivo **squid.conf** para rodar nosso Squid com opção de <strike>`transparent`</strike>`intercept`.

> Com as configurações de instalação que foi feito no Squid, o arquivo **squid.
> conf** se encontra no diretório: `/etc/squid/squid.conf`, abra-o com um
> editor de sua preferência (usei o vim).

**Arquivo:** `/etc/squid/squid.conf`

{% highlight bash linenos %}
#
# Recommended minimum configuration:
#

# Example rule allowing access from your local networks.
# Adapt to list your (internal) IP networks from where browsing
# should be allowed
acl localnet src 10.0.0.0/8 # RFC1918 possible internal network
acl localnet src 172.16.0.0/12  # RFC1918 possible internal network
acl localnet src 192.168.0.0/16 # RFC1918 possible internal network
acl localnet src fc00::/7       # RFC 4193 local private network range
acl localnet src fe80::/10      # RFC 4291 link-local (directly plugged) machines

acl SSL_ports port 443
acl Safe_ports port 80      # http
acl Safe_ports port 21      # ftp
acl Safe_ports port 443     # https
acl Safe_ports port 70      # gopher
acl Safe_ports port 210     # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280     # http-mgmt
acl Safe_ports port 488     # gss-http
acl Safe_ports port 591     # filemaker
acl Safe_ports port 777     # multiling http
acl CONNECT method CONNECT

# Minha lista de bloqueios
acl acl_blacklist url_regex -i "/etc/squid/blacklist"
http_access deny acl_blacklist

#
# Recommended minimum Access Permission configuration:
#
# Deny requests to certain unsafe ports
http_access deny !Safe_ports

# Deny CONNECT to other than secure SSL ports
http_access deny CONNECT !SSL_ports

# Only allow cachemgr access from localhost
http_access allow localhost manager
http_access deny manager

# We strongly recommend the following be uncommented to protect innocent
# web applications running on the proxy server who think the only
# one who can access services on "localhost" is a local user
#http_access deny to_localhost

#
# INSERT YOUR OWN RULE(S) HERE TO ALLOW ACCESS FROM YOUR CLIENTS
#

# Example rule allowing access from your local networks.
# Adapt localnet in the ACL section to list your (internal) IP networks
# from where browsing should be allowed
http_access allow localnet
http_access allow localhost

# And finally deny all other access to this proxy
http_access deny all

# Squid normally listens to port 3128
http_port 3128 intercept

cache_effective_user proxy

# Uncomment and adjust the following to add a disk cache directory.
cache_dir ufs var/cache/squid 100 16 256

# Leave coredumps in the first cache dir
coredump_dir var/cache/squid

#
# Add any of your own refresh_pattern entries above these.
#
refresh_pattern ^ftp:       1440    20% 10080
refresh_pattern ^gopher:    1440    0%  1440
refresh_pattern -i (/cgi-bin/|\?) 0 0%  0
refresh_pattern .       0   20% 4320
{% endhighlight %}


**Algumas observações no arquivo `squid.conf`:**

> * 1 - Observe as acls  **localnet**. Essas
> ACLs são de sua rede local, se você usa DHCP em sua rede, provavelmente um
> desses IP será da sua rede local, agora se você usa um IP Estático, você deve
> obter a rede local dele. A rede local sempre termina com o **0(zero)** no
> final.
> * 2 - As linhas:
>  * **acl acl_blacklist url_regex -i "/etc/squid/blacklist"**
>  * **http_access deny acl_blacklist**
> ..devem existir caso você já criou sua lista de bloqueio. Saiba que a
> palavra **deny**, é responsável por bloqueio e a palava **allow**,
> responsável por permissão.
> * 3 - Na linha **http_port 3128 intercept** terá que ter a palavra
> **intercept** (dependendo da versão do seu Squid).


* ### Criando cache, executando e parando o Squid Proxy

Precisamos criar o cache do Squid Proxy, faça no terminal:

`Executar o comando como root (superusuário)`

{% highlight bash  %}
squid -z
{% endhighlight %}

> Caso não ocorreu nenhuma mensagem de erro(ERROR) ou alerta (WARNING), o
> cache do Squid já está criado.

Nosso Squid praticamente está funcional, pois, basta ativa-lo. Para isso, façamos o seguinte no terminal:

{% highlight bash  %}
squid
{% endhighlight %}

> Nota: Toda vez que alterar o arquivo **squid.conf** ou suas listas de bloqueio e permissão, rode o comando ...

{% highlight bash  %}
squid -k reconfigure
{% endhighlight %}

... para reativas as novas configurações feitas. Caso queira parar o Squid, use o comando:

{% highlight text  %}
squid -k kill
{% endhighlight %}

* ### Redirecionado a porta 80 para a porta 3128 do Squid Proxy

Para o Squid funcionar com a opção <strike> `transparent`</strike>`intercept`, precisamos redirecionar a porta de acesso a internet, que é porta **80**, para a porta padrão do Squid, que é a porta **3128**. Isso pode ser feito com o **IPTables**, que por padrão vem na maioria das distro Linux.

O **IPTables** fornece ao sistema operacional Linux as funções de firewall, pois o mesmo é uma ferramenta para criar e administrar regras e assim filtrar pacotes de redes.

> Sugiro que leia a documentação do **IPaTbles** ( pode-se encontrar [aqui](
> http://www.guiafoca.org/cgs/guia/avancado/ch-fw-iptables.html) ) para ter
> uma noção de seu funcionamento.

Vamos fazer o redirecionamento das portas com as duas linhas abaixo:

{% highlight text  %}
iptables -t nat -A PREROUTING  -p tcp  -i eth0 --dport 80 -j REDIRECT --to-port 3128
{% endhighlight %}

Sendo que **eth0** deve ser a interface da placa de rede no qual irá redirecionar a porta. Caso sua placa de rede que tem o acesso a internet seja diferente dessa, troque-a. Para saber, digite no terminal: `ifconfig`.

Caso queira que o Squid entre em vigor na maquina servidor, execute as seguintes linhas no terminal para o IPTables:

> Nessa ordem, pois o IPTables lê de cima para baixo

{% highlight text  %}
iptables -t nat -A OUTPUT -m multiport -p tcp --dports 80,3128 -m owner --uid-owner 13 -j ACCEPT

iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-port 3128
{% endhighlight %}

> OBS: Na primeira linha, no parâmetro **--uid-owner**, 13 é o UID do usuário
> **proxy** que é o usuário de execução do Squid.


Com essas configurações, todo acesso a internet através do navegador será monitoriado pelo Squid. Lembre-se que esse artigo é apenas uma base de que você pode fazer com o servidor de proxy Squid.

Vou me despedindo aqui pessoal, espero que essa leitura foi útil para seu conhecimento. Até a próxima.

