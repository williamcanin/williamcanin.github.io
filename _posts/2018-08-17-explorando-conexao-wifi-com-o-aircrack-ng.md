---
layout: post
title: "Explorando conexão WiFi com o aircrack-ng"
date: 2018-08-17 05:22:32
tags: ['hacking','pentest','aircrack-ng','rede']
published: false
comments: true
excerpted: |
        Será mesmo que esses tutorias que vocês veem na Internet fala a realidade do aircrack-ng?
        Nesse post irei tentar explicar algumas sobre o mesmo que muitos não fazem.
day_quote:
 title: "A Palavra"
 description: |
          "Put here your quote of the day"

# Does not change and does not remove 'script' variable.
script: [post.js]
---

Iae indivíduo, tudo bem? Comigo tá suave rs. A acredito que você leu o título e já ficou com os olhinhos empolgados por se tratar de uma aplicação bem interessante, relacionada com o mundo hacker, não é mesmo?! hehe. Mas vou logo alertando que meu intuito com essa postagem é levar apenas **CONHECIMENTO** as pessoas a modo que as mesmas fiquem atentas caso percebam algum detalhe em suas redes WiFi parecidos com o que esta nessa postagem.

O que você irá fazer com o conhecimento obtido nessa postagem, é de sua responsabilidade, ok?! Então vamos ao post.


* indice
{: toc}


# Introdução

Falar o que é seguro nos dias de hoje em termos de tecnologia é algo bem relativo, isso porque existem inúmeras brechas de segurança e fragilidades que aplicativos exploram de uma maneira muito simples. Esse post irei falar de uma dessas fragilidades em redes WiFi usando o pacote [aircrack-ng](https://www.aircrack-ng.org){:target="_blank"}. O pacote [aircrack-ng](){:target="_blank"} vem com [vários](https://www.aircrack-ng.org/doku.php?id=Main#documentation){:target="_blank"} recursos para explorarmos a fragilidade de uma conexão via WiFi, alguns desses recursos que irá abordar nessa postagem é ataques DoS e "quebra" de senha WiFi.


## Os preparativos

Bom, você certamente precisará do **aircrack-ng**, é possivel instalar ele em todas distribuições Linux, e tambem para Windows e Mac OS você o encontra. Eu não vou mostrar como se instala porque isso é "mamão com açucar", ok meu chapa?!. Simplesmente entre no site oficial do **aircrack-ng** e veja o que lhe oferecem de documentação da instalação.

Outra coisa que você precisará é de uma placa Wireless, se você não tem eu sinto muito. Continue lendo e aprenda apenas da teoria. 

O **aircrack-ng** não usa Internet para fazer o seu trabalho! Assustou? Mas é isso mesmo. Você precisa apenas do **aircrack-ng** e uma placa de rede WiFi. Então você se pergunta: Mas como isso é possível? Isso porque o **aircrack-ng** trabalha na placa WiFi de modo monitor conseguindo capturar todos MAC de dispositos mobile e redes WiFi no alcance próximo.


> Nota: `Todos os comandos do **aircrack-ng** devem ser executados como root (superusuário)`

### Placa WiFi em modo monitor

Primeiro veja se sua placa esta ativa com o comando abaixo:

{% highlight bash linenos %}
$ ifconfig
{% endhighlight %}

> Saida do comando:

{% highlight bash linenos %}
lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 6824  bytes 8092210 (7.7 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 6824  bytes 8092210 (7.7 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

wlp7s0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether 00:00:00:00:00:00  txqueuelen 1000  (Ethernet)
        RX packets 0  bytes 0 (0.0 B)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 0  bytes 0 (0.0 B)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
{% endhighlight %}


Agora utilizando o recurso *airmon-ng* do **aircrack-ng** para listar a(s) placa(s) WiFi disponíveis:

{% highlight bash linenos %}
# airmon-ng
{% endhighlight %}

> Saida do comando:

{% highlight bash linenos %}
 PHY	Interface	Driver		Chipset

 phy0	wlp7s0	ath9k		Qualcomm Atheros AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
{% endhighlight %}


Repare que tem uma *Interface* wireless chamada **wlp7s0**. Esse nome é relativo, pode ser diferente, caso a saida do comando não obter resultado(s), então a máquina não possui uma placa de rede WiFi, ou não está ativada.

Com a placa listada, o que precisa ser feito agora é deixar a mesma em modo monitor, para que seja possível do **aircrack-ng** trabalhar. Para isso faça:

{% highlight bash linenos %}
# airmon-ng start wlp7s0
{% endhighlight %}

Agora execute o comando abaixo novamente para ver o se a placa entrou em modo monitor:

{% highlight bash linenos %}
# airmon-ng
{% endhighlight %}

> Saida do comando:

{% highlight bash linenos %}
 PHY	Interface	Driver		Chipset

 phy0	wlp7s0mon	ath9k		Qualcomm Atheros AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
{% endhighlight %}

Repare que a placa obteve um novo nome, o **wlp7s0mon**, ou seja, a placa já está em modo monitor e pronta para trabalhar.

Para tirar do modo monitor, digite o comando abaixo:

{% highlight bash linenos %}
# airmon-ng stop wlp7s0mon
{% endhighlight %}


## Monitorando redes


## DoS 

O ataque DoS (Denial of Service), para o português "Negação de Serviço", é bem usado em servidores web para tornar as páginas hospedadas indisponível na web, porém o **aircrack-ng** possibilita fazer esse ataque em uma rede WiFi através da Deauthentication. Essa possibilidade é de deixa uma rede WiFi inativa, derrubando todos que tiverem conectados e impossibilitando a conectividade até que o ataque seja interrompido. Esse ataque envia vários pacotes por segundos na rede WiFi a ponto de fazer a mesma se perder com tamanho conteúdo de dados e não possibilitando uma conexão com a Internet através de um dispositivo mobile, seja um smarthphone, tablet ou até mesmo notebook através da Wireless. 

O objetivo principal do **aircrack-ng** não é fazer um ataque DoS em rede WiFi, mas sim capturar dados da mesma, o que a  própria descrição do **aircrack-ng** diz: `Key cracker for the 802.11 WEP and WPA-PSK protocols`.


## Handshake

Outro recurso do **aircrack-ng**, é fazer uma captura de uma handshake criptografada, que nada mais é que os dados da conexão WiFi, ou seja, essa handshake contem a senha da conexão WiFi. Muito interessante, não é mesmo?! Mas apesar do **aircrack-ng** fazer essa captura da handshake, não é simples fazer a quebra da mesma.

O que vê na internet é varios posts e vídeos de pessoas mostrando como fazer a captura e quebra (falsa) de uma handshake. O processo de fazer a captura é muito simples e fácil (o que geralmente se é mostrado nos tutoriais), mas a maioria não falam os termos necessários para que essa ação de descriptografia da handshake seja concluída. 

Vamos pensar o seguinte: Vocês acham mesmo que fazer uma quebra de uma handshake criptografada no aircrack-ng (ou outro programa) é algo tão fácil e simples? Você não concordam que se fosse fácil muitas pessoas estavam usando internet WiFi roubada e nem compraria planos absurdos que temos no Brasil? Não! Não é fácil, é complexo e vou explicar o porque.

Vamos para a prática para que você entenda de uma você.
### A ficção

Quando alguem lhe mostra fazendo uma quebra de uma handshake em um tutorial, seja em texto ou vídeo, não se iluda, pois o mesmo personagem já sabia a senha da rede WiFi e colocou dentro da wordlist. Assim, quando o aircrack-ng foi realizar a quebra da handshake, ele fez rapidamente por a password da rede WiFi já esta contida manualmente no wordlist pelo autor.



Fontes: 

https://www.aircrack-ng.org/doku.php?id=deauthentication