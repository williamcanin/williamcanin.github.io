---
layout: post
title: "Preparando ambiente de desenvolvimento Python no Linux"
date: 2018-11-30 00:06:28
tags: ['vscode','code','python', 'config']
published: false
comments: false
excerpted: |
          Put here your excerpt
day_quote:
 title: "Put here title quote of the day"
 description: |
          "Put here your quote of the day"

# Does not change and does not remove 'script' variable.
script: [post.js]
---

<!-- Write from here your post !!! -->


* Do not remove this line (it will not be displayed)
{: toc}

# Introdução

Olá pessoas, tudo bem? Espero que sim.

Resolvi criar esses post para mostrar como configuro meu ambiente de desenvolvimento do [Python][py] no Linux. Então vamos lá.

O [Python][py] por padrão já vem instalado na maioria das distribuições Linux, porem atualmente (2019), está instalado a versão 2.x, e a versão atual do Python é a 3.x. Muitas coisas legais mudou da versão 2.x para a 3.x, então, sempre é bom usarmos a versão mais resente de qualquer linguagem de programação, assim conseguimos nos livrar de possível bugs e aderir novos recursos :)

Atualmente estou usando a distribuição [Ubuntu][ubu], caso a distribuição que você esteja usando seja derivada do Debian também, não irá ter alteração nos nomes dos pacotes desse post a seguir. Caso não seja, não se preocupe, também irei mencionar a instalação em outras distribuições ;)

# Instalando Python 3.x no Linux

## Debian/Ubuntu

{% highlight bash linenos %}
$ sudo apt install python3 python3-venv python3-pip python3-all-dev
{% endhighlight %}

## Archlinux/Manjaro

*Nota: Como o Archlinux (derivados) é Rolling Release, então o pacote 'python' já é a versão atual*

{% highlight bash linenos %}
$ sudo pacman -S python python-virtualenv python-pip
{% endhighlight %}

## Red Hat/Fedora

*Nota: No Fedora o Python 3.x já vem instalado*

{% highlight bash linenos %}
$ sudo dnf install python3 python3-pip python3-virtualenv
{% endhighlight %}

Depois de instalar, entre no terminal e execute o seguinte comando abaixo para verificar se está tudo Ok:

{% highlight bash linenos %}
$ python3 --version
$ pip3 -h
{% endhighlight %}

# Configurando variáveis de ambiente

Lembra que por padrão o comando `python` no terminal chama a versão 2.x do python, e para chamar a versão 3.x, precisamos digitar o comando `python3`, pois bem, vamos mudar isso, para que ao digitarmos `python podemos trabalhar com a versão 3.x.

No arquivo "~/.bashrc", adicione a seguinte linha.

~~~shell
alias python='/usr/bin/python3'
~~~

O que estamos fazendo é criando um **alias** para o comando `python`, usar a versão 3.x do Python no terminal. Assim você não precisa renomear links simbólicos.

*Nota: Se quiser pode fazer isso para o 'pip' também.*

# Instalando módulos no Python

Com o Python instaladinho, vamos instalar uns módulos bacana para nos auxiliar em um desenvolvimento mais fácil.

## Flake8



Mas cá entre nós, eu nem precisaria fazer um post sobre isso, pois a própria [documentação](https://code.visualstudio.com/docs/languages/python){:target="_blank"} do Visual Studio Code tem detalhadamente como se configura, mas, vou deixar uns extras.

Primeiramente vou partir que você já tenha o "VsCode" instalado no seu S.O.

[ubu]: (https://ubuntu.com){:target="_blank"} 
[vscode]: (https://code.visualstudio.com/){:target="_blank"} 
[py]: (https://www.python.org/){:target="_blank"} 