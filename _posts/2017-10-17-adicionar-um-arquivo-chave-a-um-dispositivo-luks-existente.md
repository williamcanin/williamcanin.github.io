---
layout: post
font: "https://access.redhat.com/solutions/230993"
title: Adicionar um arquivo chave a um dispositivo LUKS existente
date: 2017-10-17 07:19:51
tags: ['luks','encryption','security']
published: false
comments: true
excerpted: |
          Put here your excerpt
day_quote:
 title: "Put here title quote of the day"
 description: |
          "Put here your quote of the day"

# Does not change and does not remove 'script' variable.
script: [post.js]
---

<!-- Fontes: https://access.redhat.com/solutions/230993, http://ptcomputador.com/Sistemas/linux/205343.html -->

* Do not remove this line (it will not be displayed)
{: toc}

# Introdução



# Requerimentos

Para saber se você tem o pacote de criptografia instalado no seu Linux, execute o comando abaixo na console:

{% highlight bash  %}
$ cryptsetup --version
{% endhighlight %}

Caso não esteja, instale o pacote de acordo com o gerenciador de pacotes de sua distro Linux, pois esse pacote está presente nativamente em todas distro.

{% highlight bash  %}
# apt install cryptsetup  [Debian/Ubuntu/Mint]
# dnf install cryptsetup [Fedora]
# pacman -S cryptsetup [Archlinux]
{% endhighlight %}
