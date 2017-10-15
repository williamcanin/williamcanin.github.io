---
layout: post
font: "https://access.redhat.com/solutions/230993" 
title: Adicionar um arquivo chave a um dispositivo LUKS existente
date: 2017-10-15 07:19:51
categories: blog
tags: ['luks','criptografia','segurança']
published: false
comments: true
excerpted: |
          Put here your excerpt
day_quote:
 title: "Put here title quote of the day"
 content: |
          "Put here your quote of the day"

# Does not change and does not remove 'script' variable.
script: [post.js]
---

* Do not remove this line (it will not be displayed)
{: toc}

# Introdução


# Requerimentos

Para saber se você tem o pacote de criptografia instalado no seu Linux, execute o comando abaixo na console:

{% highlight bash linenos %}
$ cryptsetup --version
{% endhighlight %}

Caso não esteja, instale o pacote de acordo com o gerenciador de pacotes de sua distro Linux, pois esse pacote está presente nativamente em todas distro.

{% highlight bash linenos %}
# apt install cryptsetup  [Debian/Ubuntu/Mint]
# dnf install cryptsetup [Fedora]
# pacman -S cryptsetup [Archlinux]
{% endhighlight %}