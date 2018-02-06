---
layout: post
title: Instalando o Sublime Text 3 no Debian
date: 2015-01-26 17:13:27 -0300
comments: true
tags: ["editor","sublime-text", "debian"]
excerpted: |
    Se você está começando a usar Linux, provavelmente não sabéra certas coisas mesmo que elas sejam simples como instalar o Sublime Text.
day_quote:
    title: "A Palavra:"
    description: |
        "Não se junte com descrentes para trabalhar com eles. Pois como é que o certo pode ter alguma coisa a ver com o errado? Como é que a luz e a escuridão podem viver juntas? Como podem Cristo e o Diabo estar de acordo? O que um cristão e um descrente têm em comum?" <br>
        (2 Coríntios 6:15:15 NTLH)
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

* Do not remove this line (it will not be displayed)
{: toc}

### Introdução

<img src="{{ "/assets/images/posts/sublime-text-logo.png" | prepend:site.baseurl | prepend:site.url }}" alt="Sublime Text 3" width="200" height="200" style="float: left;padding: 12px;" />

O [Sublime Text](http://www.sublimetext.com/){:target="_blank"} é um editor de textos, ou melhor, um "super editor de textos" que todos que atuam na área de desenvolvimento deveriam ter em suas máquinas. Além de suportar várias sintaxes, o Sublime Text é baseado em plugins, ou seja, você pode customizar seu Sublime Text da maneira que lhe seja adaptável a sua usabilidade, como plugins para snippets, compactadores e muito mais.

O Sublime Text pode ser instalado em qualquer Sistema Operacional e em qualquer distribuição Linux, isso porque além de ter pacotes pré compilados para determinadas distribuições, ele também tem o pacote **.tar.bz2** que te permite extrair e sair usando, porem tu irá ter que criar os atalhos e ícones para o mesmo manualmente, mas primeiro vamos saber como instalar na distribuição Linux [Debian](http://debian.org){:target="_blank"} e distribuições derivadas do mesmo, como o [Ubuntu](http://ubuntu.com/){:target="_blank"} ( `testado no Debian Wheezy e Ubuntu 15.10` ).

### Pre requisitos

Não necessáriamente é uma *obrigação*, mas recomendo quando for instalar a **ultima** versão de qualquer programa no Linux, é sempre recomendável que configure sua **sources.list** com repositórios oficiais da distribuição, e em seguida atualize a distribuição. Execute os comandos abaixo para o feito:

{% highlight bash linenos %}
$ sudo apt-get update && apt-get dist-upgrade
{% endhighlight %}

Após deixar a distribuição atualizada, vamos para o processo de download e instalação do Sublime Text:

### Download

* Acesse a página de download do Sublime Text 3 [Aqui](http://www.sublimetext.com/3){:target="_blank"}
* Baixe a ultima versão do pacote para Ubuntu de acordo com a arquitetura de seu computador (32 bit ou 64 bit).


### Instalação

Para instalar entre no diretório que se encontra o pacote baixado através do terminal e digite o comando do DPKG para a instalação:

Exemplo:

{% highlight bash linenos %}
$ cd Downloads
$ sudo dpkg --install sublime-text_build-{VERSION}_{ARCH}.deb
{% endhighlight %}

> Nota: Onde está **VERSION** é a versão do Sublime Text baixado e onde está
> **ARCH** é a arquitetura que você escolheu ao baixar o Sublime Text.

Aguarde a instalação terminar. Ao terminar você já terá o Sublime Text instalado em sua máquina. Procure o Sublime Text no menu de aplicativos de sua distribuição.

### Dica extra

Caso você não utilize o Debian, Ubuntu ou nenhuma outra distribuição que use pacotes **.deb**, pode instalar o Sublime Text através de um Script shell que criei. Esse script irá fazer o download da última versão do Sublime Text, instalar, criar um link simbólico do mesmo em **/usr/bin** e ainda criar atalhos com ícones no menu de aplicativos de sua distribuição.

Faça o download do script [AQUI](https://github.com/williamcanin/subl3){:target="_blank"}.

Isso é tudo pessoal. Até a próxima! :wave:

{% endpost #9D9D9D %}

{% jektify spotify/track/0sTU90RmUkBJwS4MmxvaFa/dark %}
