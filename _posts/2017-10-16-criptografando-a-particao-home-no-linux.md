---
layout: post
title: "Criptografando a partição HOME no Linux"
date: 2017-10-16 03:51:44
tags: ['crypt','linux','security']
published: false
comments: false
excerpted: |
          Que tal esconder suas coisinhas de possiveis pessoas interesseiras? Siga em frente neste post.
day_quote:
 title: "Put here title quote of the day"
 description: |
          "Put here your quote of the day"

# Does not change and does not remove 'script' variable.
script: [post.js]
---

<!-- Write from here your post !!! -->


Olá para você pessoa, como vai? Eu vou bem graças a Deus e obrigado por perguntar mentalmente hehe.
Esse é um post de segurança...é o que todos querem, não é?! hehe Então lá vai...


# Introdução

Todos usuários Linux sabem que o diretório **/home** é onde fica armazenado toda nossa "bancada" de arquivos importantes, ou seja, é onde tudo é salvo, e tudo acontece. Pensando nisto, pensei um fazer um post como proteger a **/home**, o que é muito legal. Então vamos lá.

Mesmo que você coloque uma senha muito difícil de login, você não está seguro de alguem pegar seus arquivos. Se alguem ligar sua máquina com um sistema bootavémem pendrive ou DVD, essa pessoa consegue montar a partição Linux e acessar seus arquivos.

*Como me protejo disso?*

A resposta é: usar uma partição separada para **/home** e criptografar a mesma.

Então vamos lá manito :)

# Requisitos

Os seguintes requisitos baixo precisam existir em sua distribuição Linux:

* Pacote: cryptsetup
* A **/home** separada do sistema
* Ter acesso ao usuário root

# Preparando ambiente

> NOTA: FAÇA O BACKUP DE TODA SUA /home POIS ELA SERÁ DESTRUÍDA.

## Logar como Root

Para dar continuidade a este tutorial, você precisa estar logar no sistema como ROOT. Se você não conseguir logar como ROOT, você pode fazer logout da sessão (caso esteja com usuário comum) e abrir um novo tty digitando `Ctrl + Alt + F4`, após isso, você faz o login com root.

Após logar com root, vamos carregar os módulos de criptografia, qual vamos usar executando no console:

{% highlight bash linenos %}
modprobe -a dm-mod dm-crypt
{% endhighlight %}

## Criptografando e Formatando a partição /home

Dê o comando abaixo para listar nossas partições:

{% highlight bash linenos %}
fdisk -l /dev/sda
{% endhighlight %}

Vamos imaginar que nossa partição **/home** seja a **/dev/sda2**, com isso vamos criptografar a mesma com LUKS através do **cryptsetup** da seguinte maneira:

> NOTA: FAÇA O BACKUP DE TODA SUA /home POIS ELA SERÁ DESTRUÍDA.

## Criptografia

{% highlight bash linenos %}
cryptsetup -y -v luksFormat -c aes-xts-plain64 -s 512 /dev/sda2
{% endhighlight %}

O LUKS irá pedir pra que você confirme com um **yes** (em uppercase), ou seja, assim: **YES**.

> Digite: **YES** e dê Enter

Após isso, irá pedir para informar a senha de criptografia e logo em seguida para confirmar. Então faça isso.

**A T E N Ç Ã O**: Nunca esqueça essa senha, pois é ela que você usará para iniciar no seu sistema futuramente.

Ok! Você já tem sua partição onde será instalada o Linux criptografada.

## Abrindo partição criptografada

Precisamos abrir a partição para poder trabalhar nela, isso faremos com o comando abaixo:

{% highlight bash linenos %}
cryptsetup open /dev/sda2 home
{% endhighlight %}

**IMPORTANTE**: Observe que no final do comando tem a palavra **home**.

Ao fazer um **open** na partição criptografada, criará um "ponteiro" para nossa **home**. Terá um link simbólico em **/dev/mapper**, ou seja, será encontrado assim: **/dev/mapper/home**
(não necessáriamente precisa ser **home**, você pode colocar outro nome). Porem, esse ponteiro **/dev/mapper/home** será excluido após desmontarmos essa partição ou quando desligar/reiniciar a máquina, para essas configurações se manter usaremos 2(dois) arquivos para isso. Veremos mais a seguinte.

## Formatando a pratição criptografada

{% jektify spotify/track/5YaLFRpqpUzgLLDcukNn0H/dark %}
