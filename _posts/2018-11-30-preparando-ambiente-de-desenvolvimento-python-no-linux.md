---
layout: post
title: "Preparando ambiente de desenvolvimento Python no Linux"
date: 2018-11-30 00:06:28
tags: ['vscode','code','python', 'config', 'virtualenv']
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

Resolvi criar esses post para mostrar como configurar o ambiente básico para um desenvolvimento em [Python][py] no Linux. Então vamos lá.

O [Python][py] por padrão já vem instalado na maioria das distribuições Linux, porem atualmente (2019), está instalado a versão 2.x, e a versão atual do Python é a 3.x. Muitas coisas legais mudou da versão 2.x para a 3.x, então, sempre é bom usarmos a versão mais resente de qualquer linguagem de programação, assim conseguimos nos livrar de possível bugs e aderir novos recursos :)

Atualmente estou usando a distribuição [Ubuntu][ubu], caso a distribuição que você esteja usando seja derivada do Debian também, não irá ter alteração nos nomes dos pacotes desse post a seguir. Caso não seja, não se preocupe, também irei mencionar a instalação em outras distribuições ;)

# Instalando Python 3.x no Linux

## Debian/Ubuntu

{% highlight bash linenos %}
$ sudo apt install python3 python3-venv python3-pip python3-all-dev
{% endhighlight %}

## Archlinux/Manjaro

> Nota: Como o Archlinux (derivados) é Rolling Release, então o pacote 'python' já é a versão atual

{% highlight bash linenos %}
$ sudo pacman -S python python-virtualenv python-pip
{% endhighlight %}

## Red Hat/Fedora

> Nota: No Fedora o Python 3.x já vem instalado

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

Com o Python instaladinho, vamos instalar uns módulos bacana para nos auxiliar em um desenvolvimento mais amigável.

## Linter

Usar um linter ajuda bastante a gente enxergar erros que dificilmente perceberiamos em nosso código caso não houvesse um, por isso um linter para Python que gosto é o [Flake8](http://flake8.pycqa.org/en/latest/){:target="_blank"}.

O **Flake8** é uma ferramenta para aplicação de guia de estilo. Irá auxiliar na procura de problemas de identação ou outros erros mais no nosso código.

### Flake8

{% highlight bash linenos %}
$ python -m pip3 install flake8 --user
{% endhighlight %}

> Nota: Ao expecificar a flag '--user', o módulo irá instalar no direttório do usuário, ou seja,
> **~/.local/lib/python3.x/site-packages**.

O arquivo de configuração do Flake8 no Linux, fica em "**~/.config/flake8**", caso esse arquivo não existe você pode estar criando o mesmo (sem extensão nenhuma) e aplicando suas configurações.

Uma configuração que gosto de utilizar é o **max-line-length**, para ampliar o espaço da linha quando for escrever o código. O valor que deixo é de **120**, você pode configurar a seu gosto. Assim que a linha atingir mais de 120 caracteres, o Flake8 irá lhe mostrar uma Warning pedindo para que você faça uma quebra de linha no código. Confira a configuração do arquivo:

{% highlight text linenos %}
[flake8]
max-line-length = 120
{% endhighlight %}

## Máquinas virtuais

Criar nossos projetos com máquinas virtuais é uma técnica essencial para não comprometermos as versões globais de módulos já instaladas em nossa máquina e não ficarmos com módulos globais instalados e não usar depois. Sempre que criamos uma máquina virtual para nossos projetos, podemos instalar qualquer versão de qualquer módulo. Vamos ver dois pacotes que nos possibilita criar máquinas virtuais para nossos códigos em Pythom, o **Venv** (Virtualenv) e o **Pipenv**.

### Virtualenv

O **Virtualenv** (Virtualenv) já instalamos através dos pacotes que distribuição Linux nos disponibiliza. Caso a distribuição não tenha o pacotes **python{x}-virtualenv**, então podemos instalar pelo **pip** da seguinte maneira:

{% highlight text linenos %}
$ python -m pip install virtualenv --user
{% endhighlight %}

> Nota: Ao expecificar a flag '--user', o módulo irá instalar no direttório do usuário, ou seja,
> **~/.local/lib/python3.x/site-packages**

Quando criamos máquinas virtuais com o **Virtualenv**, suas configurações são armarzenadas em uma pasta no projeto que vocẽ esta desenvolvendo.

#### Usando o Virtualenv

"Não vou reenventar a roda!". Como já existe a própria documentação do **Virtualenv**, então você pode ir conferir como usa-la clicando [aqui](https://virtualenv.pypa.io/en/latest/userguide/){:target="_blank"}

### Pipenv

Eu particulamento não uso o **Pipenv**, prefiro o **Virtualenv**, acho que o conceito do **Pipenv** armarzenar os módulos instalados para a máquina virtual fora da máquina virtual, é algo que incomoda muito. Quando criamos uma máquina virtual com **Pipenv**, as configurações e módulos instalados vão para o diretório padrão: **~/.local/share/virtualenvs/**.

> Nota: Ao expecificar a flag '--user', o módulo irá instalar no direttório do usuário, ou seja,
> **~/.local/lib/python3.x/site-packages**.

#### Usando o Pipenv

O **Pipenv** também tem sua própria documentação, então saia um minutinho dessa leitura e confere clicando [aqui](https://pipenv.readthedocs.io/en/latest/){:target="_blank"}

[ubu]: (https://ubuntu.com){:target="_blank"}
[vscode]: (https://code.visualstudio.com/){:target="_blank"}
[py]: (https://www.python.org/){:target="_blank"}
