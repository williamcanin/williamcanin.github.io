---
layout: post
title: Instalando o Sublime Text 3 no Debian
date: 2015-01-26 17:13:27 -0300
comments: true
class: sublime
tags: ["editor","sublime-text", "debian"]
excerpted: |
    Se você está começando a usar Linux, provavelmente não sabéra certas coisas mesmo que elas sejam simples como instalar o Sublime Text. 
day_quote:
    title: "A Palavra:"
    content: |
        "Não se junte com descrentes para trabalhar com eles. Pois como é que o certo pode ter alguma coisa a ver com o errado? Como é que a luz e a escuridão podem viver juntas? Como podem Cristo e o Diabo estar de acordo? O que um cristão e um descrente têm em comum?" <br>
        (2 Coríntios 6:15:15 NTLH)
categories: blog
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

<img src="{{ "/assets/images/posts/sublime-text-logo.png" | prepend:site.baseurl | prepend:site.url }}" alt="Sublime Text 3" width="200" height="200" style="float: left;padding: 12px;" />

O [Sublime Text](http://www.sublimetext.com/){:target="_blank"} é um editor de textos, ou melhor, um "super editor de textos" que todos que atuam na área de desenvolvimento deveriam ter em suas máquinas. Alem de suportar várias sintaxe, o Sublime Text é baseado em plugins, ou seja, você pode customizar seu Sublime Text da maneira que lhe seja adaptável a sua usabilidade, como plugins para snippets, compactadores de css e muito mais.

Este belo editor, está presente em todos tipo de Sistemas Operacionais, porem, irei detalhar como se instalar o Sublime Text 3 na distribuição **Linux [Debian](http://debian.org){:target="_blank"}** e distribuições derivadas do mesmo, como o **[Ubuntu](http://ubuntu.com/){:target="_blank"}** ( `testado no Debian Wheezy e Ubuntu 14.10` ).
Para instalar a **ultima** versão de qualquer programa no seu Linux, é sempre recomendável que configure sua **sources.list** com repositórios oficiais da distribuição, e em seguida atualize sua distribuição, para isso, execute os seguintes comandos para este feito:

{% highlight shell linenos %}
will@linux:~$ sudo apt-get update && apt-get dist-upgrade
{% endhighlight %}

Após deixar sua distribuição atualizada, vamos para o processo de download e instalação do Sublime Text:

### Download

* Acesse a página de download do Sublime Text 3 [Aqui](http://www.sublimetext.com/3){:target="_blank"}.
* Baixe a ultima versão do pacote para Ubuntu de acordo com a arquitetura de seu computador (32 bit ou 64 bit).


### Instalação

Para instalar entre no diretório que se encontra o pacote baixado através do terminal e digite o comando do DPKG para a instalação:

Um Exemplo:

{% highlight bash linenos %}
will@linux:~$ cd Downloads
will@linux:~/Downloads$
will@linux:~$ sudo dpkg --install sublime-text_build-3065_amd64.deb
{% endhighlight %}

> Obs: Todos os comandos tem que ser com super-usuário (root) ou usar o sudo. Existe outras formas de instalar, por exemplo, por repositórios e por PPA, se você utilizar Ubuntu.

Aguarde a instalação terminar e pronto, você tem um dos melhores editores de texto instalado no Linux.
Até a próxima! :)