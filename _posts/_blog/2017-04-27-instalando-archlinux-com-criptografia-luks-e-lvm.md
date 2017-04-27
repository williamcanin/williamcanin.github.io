---
layout: post
title: Instalando Archlinux com criptografia LUKS e LVM
date: 2017-04-27 11:33:43
categories: blog
tags: ['linux','criptografia', 'luks', 'lvm']
published: false
comments: true
excerpted: |
          Este post, irá lhe informar como ter uma segurança forte para proteção do seu S.O Arch Linux. Iae, quer estar protegido?!
day_quote:
 title: "A Palavra: "
 content: |
          "Put here your quote of the day"

# Does not change and does not remove 'script' variable.
script: [post.js]
---

## Requerimentos

* Imagem do [Archlinux](https://www.archlinux.org/download/){:target="_blank"} queimada em DVD ou Pendrive Bootável.
* Uma partição livre no HD(SSD) ou usar [VirtualBox](https://wiki.archlinux.org/index.php/VirtualBox){:target="_blank"} para realizar esse tutorial.

> Nota: Não irei entrar em detalhe de como realizar o procedimento de gravação
> de imagem ou como usar VirtualBox, não é o foco do tutorial.

## Introdução

Uma das coisas mais preocupantes para quem usa um computador, pode se dizer que é a segurança dos dados contido nele. Dependendo de qual informação você tem em sua máquina, isso pode comprometer (e muito) sua vida pessoal, no trabalho, etc. 

Ter uma máquina com uma senha de login "forte", **N Ã O** irá manter seus dados seguros de alguem que tenha um conhecimento em montagem de partições através do Linux. Vou enfatizar melhor com o seguinte exemplo:

*Imagine você com sua linda máquina onde seu(s) S.O estão instalados em partições (ou até mesmo em um HD/SSD completo) que não tem criptografia. Simplesmente a pessoa pega um S.O bootável (no pendrive ou DVD), inicia sua máquina com o mesmo, monta as partições e, "tcharamm"! Os dados de sua máquina estão expostos para esse indivíduo 'esperto'.*

Com base nesse pequeno exemplo acima, podemos pensar: 

**E se você impedir que as partições sejam montadas através de LiveCD's ou um sistema bootável? E se para montar partições tivesse uma senha para isso?**

Bom, com criptografia LUKS e o alocador de volumes LVM no Linux, isso é possível! Eba :smirk:

[Luks](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup){:target="_blank"} é uma especificação de criptografia de disco originalmente planejada para Linux. 

[LVM](http://web.mit.edu/rhel-doc/3/rhel-sag-pt_br-3/ch-lvm-intro.html){:target="_blank"} permite a criação de partições com a possibilidade de redimencioná-las. O disco ou seu conjunto é alocado em um ou mais volumes. O LVM trabalha com volumes físcos que são combinados com grupos lógicos.

Essa criptografia pode ser aplicada a qualquer distribuição Linux. Porem, os passos são diferentes de acordo com a instalação da distribuição. Mas o conceito é o mesmo.

Então, neste caso, para podermos utilizar esse conceito de criptografia e de alocamento de disco com o LVM, temos que passar pelo processo de instalação da distribuição. Então, vamos a instalação...

 *Archlinux! Eu escolho você!*

## Inicio da aventura

Já com o Archlinux em boot na máquina...

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/start_archlinux_boot.jpg|center %}    

&nbsp;a primeira coisa a se fazer é carregar o layout do teclado, para isso você precisa saber qual é o seu, no meu caso é `br-abnt2`, então:

{% highlight bash linenos %}
loadkeys br-abnt2
{% endhighlight %}

Agora iremos carregar alguns módulos **crypt**, que iremos usar para realizar toda criptografia:

{% highlight bash linenos %}
modprobe -a dm-mod dm-crypt
{% endhighlight %}

Certo, o proximo passo é relacionado a partição, ou seja, onde e como você irá instalar seu Archlinux. Vamos trabalhar com o `fdisk` para a criação de partições. Então, liste as partições que você tem na máquina com o comando abaixo para ter o entendimento o que fazer:

{% highlight bash linenos %}
fdisk -l
{% endhighlight %}

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/fdisk_list.jpg|center %} 

Como estou utilizando o Virtualbox, repare que na listagem dos HD acima, só existe o `/dev/sda`, porem você pode ter mais de um HD/SSD, então cabe a você saber qual irá trabalhar. Neste caso iremos usar o `/dev/sda`.

## Conhecendo o fdisk

O `fdisk` é uma ferramenta indispensável para quem usa Archlinux. É com ela que criamos todas partições em nosso disco durante a instalação. O `fdisk` é baseado através de linhas de comandos, como isso, você pode achar um pouco complexo no começo, mas com tempo se acostuma. :laughing: Caso realmente não queira utilizar o `fdisk`, existe o cfdisk. 

**Alternativa para o fdisk**

O [cfdisk](https://en.wikipedia.org/wiki/Cfdisk){:target="_blank"}, é como se fosse um "fork" do `fdisk`, porem, baseado em uma interface usando as setas direcionais do teclado.

## Iniciando o trabalho de partição de disco com fdisk e LVM

Nessa instalação, vou usar a opção de 3(três) partições:

* Uma para Windows
* Uma para Boot
* Uma para Linux

Não sei quanto a você, mas eu uso Windows e outras distribuições Linux em outras partições na minha máquina, então já vou aproveitar e deixar essa intalação com esse tipo de ambiente. Caso você não utilize Windows e nem outras distribuições Linux, você simplemente deve realizar a criação da partição de **Boot** e de Linux.

> Nota: A partição de boot deve ficar fora da criptografia LUKS e a partição 
> Windows também, pois o LUKS só se encarrega de gerenciar partições Linux (
> ext3,ext4, etc).

Como vamos utilizar LVM na partição Linux, nessa mesma partição podemos expandir outros volumes lógicos, ou seja, outras distribuições dentro dessa partição Linux (Está complicado?! Mas adiante irá entender, :ok_hand:).

**fdisk**

Digite o comando abaixo para inicarmos o trabalho no disco `/dev/sda`.

{% highlight bash linenos %}
fdisk /dev/sda
{% endhighlight %}

Nesse momento o `fdisk` já está pronto para trabalhar no disco `/dev/sda`. Ele é bem intuitivo. Já diz para você digitar **m** para ver as opções. Faça isso.

Se você viu as opções, observou que a opção **n** é de **new**, ou seja, criar novas partições, e é justamente isso que precisamos nesse momento, criar nossas partições, então mãos a obra.

A primeira partição que iremos criar é a partição do Windows, então...

> Digite: n

Depois irá perguntar para você o tipo de partição que você quer, primária ou extendida. Usamos a primeira opção, partição primária.

> Digite: p


Agora, o `fdisk` irá pedir o numero da partição, por padrão, está com **1**.

> Digite: 1 e dê Enter

Nesse momento o `fdisk` irá imprimir o setor incial para você escolher para essa nova partição, por padrão, ele já seleciona o setor incial, então...

> Apenas de Enter

Agora é a hora do `fdisk` definir o setor final, ou seja, nesse momento você terá que informar o tamanho que essa nova partição irá ter. Ele lhe dá a opção de definir a criação como Kbytes, MegaBytes, Gigabytes, etc. Vamos criar em Gigabytes (G). 

Neste como é um tutorial e estou no Virtualbox, caso vou colocar um tamanho de 2GB apenas. Mas, você tem que saber o tamanho da partição que você quer para Windows, certo colega?!

> Digite: +2G

Pront, a partição foi criada, mas o tipo ficou com 'Linux', e não é o que queremos, pois Windows utiliza NTFS, então temos que editar essa partição que acabamos de criar. Você pode digitar **m** novamente para ver a letra que se aplica para editar uma partição, mas eu sou bonzinho e vou dizer, é a letra **t**, de **type**.

> Digite: t