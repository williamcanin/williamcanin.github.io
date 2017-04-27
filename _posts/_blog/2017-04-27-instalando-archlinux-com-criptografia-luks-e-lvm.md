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

## Preparando o básico

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

## fdisk

**Conhecendo o fdisk**

O `fdisk` é uma ferramenta indispensável para quem usa Archlinux. É com ela que criamos todas partições em nosso disco durante a instalação. O `fdisk` é baseado através de linhas de comandos, como isso, você pode achar um pouco complexo no começo, mas com tempo se acostuma. :laughing: Caso realmente não queira utilizar o `fdisk`, existe o cfdisk. 

O [cfdisk](https://en.wikipedia.org/wiki/Cfdisk){:target="_blank"}, é como se fosse um "fork" do `fdisk`, porem, baseado em uma interface usando as setas direcionais do teclado.

**Conhecendo a estrutura de partições**

Vamos começar a partir de agora, a trabalhar com o `fdisk` para a criação de partições. Mas antes de começar, devemos entender a estrutura de partições que devemos ou queremos ter na máquina.

Nessa instalação, vou usar a seguinte estrutura de 3(três) partições:

* Uma para Windows
* Uma para Linux Boot
* Uma para Linux LVM

Não sei quanto a você, mas eu uso Windows e outras distribuições Linux em outras partições na minha máquina, então já vou aproveitar e deixar essa intalação com esse tipo de ambiente. 

Caso você não utilize Windows e nem outras distribuições Linux, você simplemente deve realizar a criação da partição de **Linux Boot** e uma para **Linux LVM**.

Como vamos utilizar **LVM** na partição Linux, nessa mesma partição podemos expandir outros volumes lógicos, ou seja, outras distribuições Linux dentro dessa partição do tipo LVM, podem ser criadas (desde que exista espaço).

**Usando o fdisk**

Primeira coisa a se fazer antes de usar o o `fdisk`, é obter as informações de nosso disco rígido, listando o mesmo para ver se encontra partições ou se o mesmo está sendo reconhecido. Então, para isso, digite o comando abaixo para realizar a listagem:

{% highlight bash linenos %}
fdisk -l
{% endhighlight %}

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/fdisk_list.jpg|center %} 

Observe: Como estou utilizando o Virtualbox, repare que na listagem dos HD acima, só existe o `/dev/sda`, porem você pode ter mais de um HD/SSD, então cabe a você saber qual irá trabalhar. Neste caso iremos usar o `/dev/sda`.

Digite o comando abaixo para inicarmos o trabalho no disco `/dev/sda`.

{% highlight bash linenos %}
fdisk /dev/sda
{% endhighlight %}

Nesse momento o `fdisk` já está pronto para trabalhar no disco `/dev/sda`. Ele é bem intuitivo. Já diz para você digitar **m** para ver as opções. Faça isso.

Se você viu as opções, observou que a opção **n** é de **new**, ou seja, criar novas partições, e é justamente isso que precisamos nesse momento, criar nossas partições, então mãos a obra.

**Criando a partição de Boot com fdisk**

> Nota: A partição de boot deve ficar fora da partição criptografada com LUKS, 
> por isso devemos criar a mesma separada das demais.

A primeira partição que iremos criar é a partição de Boot, então...

> Digite: **n**

Depois irá perguntar para você o tipo de partição que você quer, primária ou extendida. Usamos a primeira opção, partição primária.

> Digite: **p**


Agora, o `fdisk` irá pedir o numero da partição, por padrão, está com **1**.

> Digite: **1** e dê Enter

Nesse momento o `fdisk` irá imprimir o setor incial para você escolher para essa nova partição, por padrão, ele já seleciona o setor incial, então...

> Apenas de **Enter**

Agora é a hora do `fdisk` definir o setor final, ou seja, nesse momento você terá que informar o tamanho que essa nova partição irá ter. Ele lhe dará a opção de definir a criação como Kbytes(K), MegaBytes(M) Gigabytes(G), etc. Vamos criar em MegaBytes (M). 

Algo **I M P O R T A N T E** que você precisa saber, é que a partição de **Boot** não usa mais de que **200MB**. Então:

> Digite: **+200M** e dê Enter

Pronto, a partição foi criada, e o tipo da mesma como 'Linux'(isso se você observou o print que o `fdisk` deixou na tela rs). 
A partição de Boot tem que ser do tipo Linux sim, para o grub reconhecer, mas alem de ser Linux, ela terá que ser bootável. Para isso usamos a opção **a** do `fdisk`, que deixa uma partição Ĺinux do tipo boot. Então:

> Digite: **a** e dê Enter

Certo, a nova partição obtevo o tipo Bootável, mas ainda está gravado em memória do `fdisk` essas mudanças, precisamos salvar essas mudanças fisicamente. Para isso usa-se a letra **w** de **write**. Então:

> Digite: w e dê Enter

Ao gravar, o `fdisk` irá se fechar automaticamente , isso pra que você possa verificar se realmente as mudanças (ou partições) foram concluídas. Para verficar, apenas de o comando abaixo: 

{% highlight bash linenos %}
fdisk -l
{% endhighlight %}

Veja na imagem que existe uma nova partição do disco `/dev/sda`, e essa partição é a `/dev/sda1`. Então nossa partição do tipo Boot foi criada com sucesso! Yuupii! :pray:

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/list_boot_partition.jpg|center %} 

**Criando partição do Windows com fdisk**

> Nota: A partição do Windows não suporta criptografia LUKS, isso porque, 
> o LUKS só encarrega de gerenciar partições Linux. Então a partição Windows 
> terá que ser independente.

Agora que você já sabe como criar partições com o `fdisk`, não tem o porque eu repetir todos passos para as outras duas partições que nos resta, a de **Windows** e a do **Linux**.

As únicas coisa **I M P O R T A N T E** que você precisa saber, é que toda vez que criamos uma partição nova, ela irá obter o tipo 'Linux' de inicio. Neste caso como é uma partição para Windows, e Windows utiliza **NTFS**, demos que editar o tipo dessa partição. 

Você pode digitar **m** novamente para ver a letra que se aplica para deixar a partição em modo de edição, mas como sou bonzinho vou dizer, é a letra **t**, de **type**.

> Digite: **t** e dê Enter

O `fdisk` deixará sua partição em modo de edição, agora basta você escolher o tipo que essa partição vai ter, utilizando a própria sugestão do `fdisk`, onde pede para digitar **L** (em maíusculo) para listar os tipos de partições disponíveis.

> Digite: **L** e dê Enter 

Nesse momento você verá a lista de tipos de partição, onde cada uma delas está sendo representada por um código, a partição de **NTFS** é o código **86**.

> Digite: **86** e dê Enter

Agora, simplesmente escreve essas mudaçãs como já vimos antes com a opção **w**.

> Digite: **w** e dê Enter

**Criando partição do Linux LVM com fdisk**

Como vamos trabalhar com LVM, o tipo da partição Linux, **O B R I G A T Ó R I A M E N T E**, tem que ser do tipo *'Linux LVM'*. Então crie essa nova partição com o código: **8e**.

## LUKS e LVM


























* A partição do **Windows** deve ser primária também, com tipo de partição **NTFS**.
* 
No menu do `fdisk`, a para altera o tipo de 
não usa mais de que **200MB**, e a mesma é do Linux mesmo, porem vale resaltar que ao criar você tem que  e a partição de Linux, você pode definir o tamanho que quiser. Não se esquecendo de escolher o tipo de cada uma dessas partição.

*'Partição de Boot:  




















e não é o que queremos, pois Windows utiliza NTFS, então temos que editar essa partição que acabamos de criar. Você pode digitar **m** novamente para ver a letra que se aplica para deixar a partição em modo de edição, mas eu sou bonzinho e vou dizer, é a letra **t**, de **type**.

> Digite: t

O `fdisk` deixou sua partição em modo de edição, agora basta você escolher o tipo que essa partição vai ter, utilizando a própria sugestão do `fdisk`, onde pede para digitar **L** para listar os tipos de partições disponíveis (Tem que em maíusculo).

> Digite: L


Nesse momento você verá uma lista de códigos numeros de cada tipo de partição, a partição de **NTFS** é o código **86**.

> Digite: 86 e dê Enter