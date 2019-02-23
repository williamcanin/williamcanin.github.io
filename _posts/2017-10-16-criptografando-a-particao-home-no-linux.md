---
layout: post
title: "Criptografando a partição HOME no Linux"
date: 2017-10-16 03:51:44
tags: ['crypt','linux','security']
published: false
comments: true
excerpted: |
          Que tal esconder suas coisinhas da /home de possiveis pessoas "espertas"? Siga em frente neste post e descubra.
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

* indice
{: toc}

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

# Preparando a partição

## Logar como Root

Para dar continuidade a este tutorial, você precisa estar logar no sistema como ROOT. Se você não conseguir logar como ROOT, você pode fazer logout da sessão (caso esteja com usuário comum) e abrir um novo tty digitando `Ctrl + Alt + F4`, após isso, você faz o login com root. É necessário usar o usuário *root* para realizar as etapas, porque a home do usuário root não fica no **/home** no qual vamos configurar, e sim em **/root**.

Após logar com root, vamos carregar os módulos de criptografia, qual vamos usar executando no console:

{% highlight bash linenos %}
modprobe -a dm-mod dm-crypt
{% endhighlight %}

## Fazendo backup da nossa /home atual

A primeira coisa a se fazer é um backup da nossa **/home**. Se a partição raiz do sistema (**/**) tiver espaço suficiente, você pode fazer o backup para a pasta **/opt**, por exemplo, da seguinte maneira:

{% highlight bash linenos %}
mkdir -p /opt/backup
cp -rf /home /opt/backup
{% endhighlight %}

Caso não tenha, você pode estar usando um **HD/SSD** ou até mesmo um **pendrive**.

## Listando nossas partições

Dê o comando abaixo para listar nossas partições e identificar nossa partição /home atual:

{% highlight bash linenos %}
lsblk -f /dev/sda
{% endhighlight %}

## Criptografando a partição

Vamos imaginar que nossa partição **/home** seja a **/dev/sda2**, com isso vamos criptografar a mesma com criptografia LUKS através do **cryptsetup** da seguinte maneira:

> NOTA: LEMBRE-SE DE TER FEITO O BACKUP DE TODA SUA /home POIS ELA SERÁ DESTRUÍDA AGORA.

{% highlight bash linenos %}
cryptsetup -y -v luksFormat -c aes-xts-plain64 -s 512 /dev/sda2
{% endhighlight %}

O LUKS irá pedir pra que você confirme com um **yes** (em uppercase), ou seja, assim: **YES**.

> Digite: **YES** e dê Enter

Após isso, irá pedir para informar a senha de criptografia e logo em seguida para confirmar. Então faça isso.

**A T E N Ç Ã O**: Nunca esqueça essa senha, pois é ela que você usará na inicialização do sistema para para montar a **/home** futuramente.

Ok! Você já tem sua partição **/home** criptografada

## Abrindo partição criptografada

Agora precisamos abrir a partição para poder trabalhar nela, isso faremos com o comando abaixo:

{% highlight bash linenos %}
cryptsetup luksOpen /dev/sda2 home
{% endhighlight %}

**IMPORTANTE**: Observe que no final do comando tem a palavra **home** (Não necessáriamente precisa ser **home**, você pode colocar outro nome).

Ao fazer um **open** na partição criptografada, criará um "ponteiro" para nossa **home** no diretório **/dev/mapper**, ou seja, será encontrado assim: **/dev/mapper/home**. Porem, esse ponteiro **/dev/mapper/home** será excluido após desmontarmos essa partição ou quando desligar/reiniciar a máquina, para essas configurações se manter usaremos 2(dois) arquivos para isso, onde veremos mais a seguinte, enquanto isso vamos seguir passo por passo.

*A senha que você colocou para criptografar irá ser requerida nesse momento, então informe-a para abrir nossa partição criptografada.*

## Formatando a pratição criptografada

Com nossa partição criptografada já aberta, precisamos formatar a sua montagem (**/dev/mapper/home**) para o tipo ext4. Para isso faremos:

{% highlight bash linenos %}
mkfs -t ext4 /dev/mapper/home
{% endhighlight %}

## Montando a partição e restaurando backup

Agora, vamos montar essa partição formatada e fazer a restauração do nosso backup. Então, faremos essas etapas com os comandos abaixo:

{% highlight bash linenos %}
mkdir -p /mnt/home
mount -t ext4 /dev/mapper/home /mnt/home
cp -rf /opt/backup/home/* /mnt/home # Essa linha irá restaurar seu backup.
chown usuário -R /mnt/home/usuário
chmod 770 -R /mnt/home/usuário
{% endhighlight %}

> NOTA: Onde está **usuário** você deve colocar o nome do seu usuário, por exemplo: **william**.

## Fechando nossa partição criptografada

Pronto! Agora vamos fechar nossa partição criptografada com o seguinte comando abaixo:

{% highlight bash linenos %}
umount /mnt/home
cryptsetup close /dev/mapper/home
## Linha baixo apaga a pasta que criamos para montagem. Pasta vazia.
rm -rf /mnt/home
{% endhighlight %}

# Criando arquivos para montagem automática

{% jektify spotify/track/5YaLFRpqpUzgLLDcukNn0H/dark %}
