---
layout: post
title: "Instalando Python automaticamente em qualquer sistema Linux."
date: 2018-06-21 18:54:14
tags: ['python','tarball','linux']
published: true
comments: true
excerpted: |
          Instale a ultima versão estável do Python em qualquer Linux com um simples script shell.
day_quote:
 title: "A Palavra"
 description: |
          "Eu, o Senhor , examino os pensamentos e ponho à prova os corações. Eu trato cada pessoa conforme a sua maneira de viver, de acordo com o que ela faz." </br>
          (Jeremias 17:10 NTLH)

# Does not change and does not remove 'script' variable.
script: [post.js]
---

<!-- Write from here your post !!! -->

Olá :hand:, essa é uma dica rápida para você que deseja instalar o Python :snake: compilado através do código fonte (tarball). Boa leitura.

* indice
{: toc}

# Introdução

Muitas vezes precisamos instalar um determinado programa para sistemas Linux e não temos o pacote de acordo com nossa distribuição, como por exemplo, distribuições derivadas do Debian usam pacotes .deb. Como isso, várias empresas de determinados softwares nos disponibiliza os pacotes `tarball`, onde podemos compilar o programa e assim instala-lo, ou seja, esses pacotes é o `source code` (código fonte) do software a ser compilado.

Geralmente, o padrão para a instalação de pacotes tarball, são apenas 3 comandos: 

* O de configurar;
* O de compilar;
* O de instalar;

Veremos abaixo, como instalar a ultima versão estável do [Python](https://www.python.org/){:target="_blank"} automaticamente com um script shell.

# Instalação

## Criando script de instalação automática

A - Abra seu editor de texto preferido e acrescente esses comando abaixo:

{% highlight bash linenos %}
#!/usr/bin/env bash
# Description: Install latest version Python (auto)
# Author: William Canin
# License: MIT

latest_version="$(curl -sL https://www.python.org | sed -nr 's/^<p>Latest:[^>]+>Python\s+([0-9]+(.[0-9]+)+).+/\1/p')"

url_download="https://www.python.org/ftp/python/${latest_version}/Python-${latest_version}.tar.xz"

cd $HOME && wget ${url_download}

sudo rm -rf /opt/Python-${latest_version}

sudo tar -xvf Python-${latest_version}.tar.xz -C /opt

sudo chmod 775 -R /opt/Python-${latest_version}

cd /opt/Python-${latest_version}

sudo ./configure

sudo make

sudo make install

# sudo make -n install # Opcional

printf "\nInstallation complete!\n"
{% endhighlight %}

## Entendendo o que cada comando do script faz

> Linha **3**: Responsável por capturar a ultima versão estável do Python no site oficial através de expressões regulares e armazenar em uma variável.

> Linha **5**: Uma variável que armazena a url completa do download do pacote tarball.

> Linha **7**: Entra no diretório HOME do usuário atual do terminal e realizar o download do pacote *tarball* no mesmo diretório.

> Linha **9**: Remove qualquer pasta que foi utilizada para instalação o Python da mesma versão atual do download.

> Linha **11**: Descompacta o pacote *tar.xz* para o diretório **/opt**.

> Linha **13**: Dá permissão 775 para pasta **Python-<VERSION>** e suas subpastas e arquivos.

> Linha **15**: Entrando no diretório **/opt/Python-<VERSION>** para realizar a *configuração*, *compilação* e *instalação* do Python.

> Linha **17**: Configurando o Python para compilação.

> Linha **19**: Compilando o Python

> Linha **21**: Instalando o Python em si.

> Linha **23**: Essa linha é opcional, por padrão está comentada, porém, esse comando serve para mostrar quais passos foram feitos e onde foi colocado cada arquivo/pasta da instalação.

> Linha **25**: Printa uma mensagem de "*Installation complete!*"

## Salvando o script, e executando-o para a instalação do Python

B - Salve o arquivo com o nome de "**pyinstaller.sh**".

C - Dê permissão de execução para o script com o comando abaixo:

{% highlight bash linenos %}
chmod +x pyinstaller.sh
{% endhighlight %}

D - Execute o script com o comando abaixo e aguarde a instalação da última versão estável do [Python](https://www.python.org/){:target="_blank"}:

> Nota 1: Você precisa ter privilégio de superusuário (root) ou sudo.
> Nota 2: Por padrão, a instalação do executável do Python é no diretório **/usr/local/bin/python<version>**, a não ser que seja mudado o PATH não configuração (sudo ./configure).

{% highlight bash linenos %}
bash pyinstaller.sh
{% endhighlight %}

Pronto! Se tudo deu certo, a instalação foi concluída.
Você pode verificar o executável no diretório **/usr/local/bin**.

# Desinstalação

Infelizmente, até o momento o pacote de source code do Python (tarball), não tem uma opção de comando para desinstalar, como por exemplo o comando **make uninstall**, isso porque, você pode ter várias versões do Python instalada através da compilação, e então não tem um desinstalador saber qual é que você queira remover.

Para resolver isso, o comando **make -n install** que está comentado no script que criamos, é justamente para lhe mostrar onde foi instalado os arquivos e pastas. Com base nessas informações, você deve remover a instalação manualmente apenas excluindo esses arquivos e pastas.

Para facilitar, criei um script que pode lhe poupar tempo de achar esses arquivos e pastas.

## Criando script de remoção automática.

A - Abra um editor de sua preferência e coloque as linhas seguintes:

{% highlight bash linenos %}
#!/usr/bin/env bash
# Description: Uninstall determined version Python (auto)
# Author: William Canin
# License: MIT

prefix='/usr/local/'

ls ${prefix}/bin

printf "[ Based on the list above, please tell us which version you wish to uninstall ]\n"
printf "> Type the version (E.g: 3.5): "
read -p pyver

sudo rm -rfv \
    ${prefix}bin/python${pyver} \
    ${prefix}bin/pip${pyver} \
    ${prefix}bin/pydoc \
    ${prefix}bin/include/python${pyver} \
    ${prefix}lib/libpython${pyver}.a \
    ${prefix}lib/python${pyver} \
    ${prefix}bin/python${pyver} \
    ${prefix}bin/pip${pyver} \
    ${prefix}bin/include/python${pyver} \
    ${prefix}lib/libpython${pyver}.a \
    ${prefix}lib/python${pyver} \
    ${prefix}lib/pkgconfig/python-${pyver}.pc \
    ${prefix}lib/libpython${pyver}m.a \
    ${prefix}bin/python${pyver}m \
    ${prefix}bin/2to3-${pyver} \
    ${prefix}bin/python${pyver}m-config \
    ${prefix}bin/idle${pyver} \
    ${prefix}bin/pydoc${pyver} \
    ${prefix}bin/pyvenv-${pyver} \
    ${prefix}share/man/man1/python${pyver}.1 \
    ${prefix}include/python${pyver}m
    # ${prefix}bin/pydoc ## WARN: skip if other pythons in local exist.
printf "\nRemoval has been completed!\n"
{% endhighlight %}

## Salvando o script, e executando-o para a remoção do Python

B - Salve o arquivo com o nome de “pyuninstaller.sh”.

C - Dê permissão de execução para o script com o comando abaixo:

{% highlight bash linenos %}
chmod +x pyuninstaller.sh
{% endhighlight %}

D - Execute o script com o comando abaixo e aguarde a desinstalação:

> Nota: Você precisa ter privilégio de superusuário (root) ou sudo.

{% highlight bash linenos %}
bash pyuninstaller.sh
{% endhighlight %}

# Conclusão

Esse tutorial pode ficar obsoleto com o tempo, então, lembre-se de ler o arquivo de **README.rst** que vem junto no pacote **tar.xz**, nele contém informações mais detalhadas de como instalar (ou até mesmo remover) o *Python* de uma maneira bem completa.

Eu fico por aqui, abraço pra você. :smile:

{% jektify spotify/track/1parffUcsk8pfGbyMtGnmW/dark %}
