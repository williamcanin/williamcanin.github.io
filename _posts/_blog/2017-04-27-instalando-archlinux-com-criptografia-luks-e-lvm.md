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
* Espaço livre no HD(SSD) ou usar [VirtualBox](https://wiki.archlinux.org/index.php/VirtualBox){:target="_blank"} para realizar esse tutorial.
* Conexão com a Internet.

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

As únicas coisa **I M P O R T A N T E** que você precisa saber, é que toda vez que criamos uma partição nova, ela irá obter o tipo 'Linux' de inicio. Neste caso como é uma partição para Windows, e Windows utiliza **NTFS**, devemos editar o tipo dessa partição. 

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

Chegamos ao final de criação de partições com `fdisk`, veja uma imagem de exemplo ficou:

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/list_all_partitions.jpg|center %} 

Memorize bem as seguintes partições abaixo, pois iremos utilizar elas mais pra frente:

* Boot > /dev/sda1
* Linux > /dev/sda3

## LUKS

**Conceitos**

Existe várias formadas de criptografar partições com LUKS. Selecionei 2(duas) delas que achei interessante para explicar, veja:

- [x] Criptografar a partição inteira do Linux LVM, através de uma senha.
- [] Criptografar a partição **Home** apenas com senha.
- [] Criptografar apenas a partição **Home** com opção de keyfile e usar um pendrive com o Keyfile dentro para montar a partição **Home** no Linux.


A primeira opção, é a criptografia de todo os sistema Linux LVM, ela que iremos utilizar nesse tutorial.
A segunra opção também é interessante, deixamos todo sistema de arquivos sem criptografia, e quando o sistema for montar nossa partição **Home** , pedirá a senha. Porem, seus arquivos do sistema estarão expostos e existe muitas informações no sistema de arquivos que podem comprometer você. Então existe uma "brecha" de insegurança nessa opção.
A terceira opção é a que eu menos recomendo, apensar de ser interessante usar um pendrive para iniciar meus dados. Porem, se você criptografar somente a partição Home e perder o pendrive com a keyfile (ou o pendrive queimar), por exemplo, você pode não conseguir iniciar o sistema, por depender dessa keyfile que não está disponível. E amiguinho, vai te dar *"dor de cabeça"*.

> Nota: Não tem como criptografar a partição de sistema de arquivos inteira 
> com LUKS através de um keyfile no pendrive, isso porque você está mantendo o 
> arquivo **/etc/fstab** criptografado também, e para um pendrive ser 
> iniciado, ele necessita do **/etc/fstab**. Isso seria possível se ter uma 
> partição apenas para o **/etc** e não criptografar ela. Mas pode te dar 
> trabalho ao fazer isso, então vamos usar a primeira opção mesmo.


**iniciando a criptografia da partição Linux LVM**

Lembra qual é nossa partição de **Linux LVM**? É a **/dev/sda3**. Pois bem, com a nova partição de **Linux LVM** criada, chegou a hora de trabalhar ela. Para iniciarmos a criptografia na nossa partição de **Linux LVM**, usaremos o comando abaixo:

{% highlight bash linenos %}
cryptsetup -y -v luksFormat -c aes-xts-plain64 -s 512 /dev/sda3
{% endhighlight %}

O LUKS irá pedir pra que você confirme com um **yes** (em uppercase), ou seja, assim: **YES**. 

> Digite: **YES** e dê Enter

Após isso, irá pedir para informar a senha de criptografia e logo em seguida para confirmar. Então faça isso.

**A T E N Ç Ã O**: Nunca esqueça essa senha, pois é ela que você usará para iniciar no seu sistema futuramente.

Ok! Você já tem sua partição onde será instalada o Linux criptografado. 

Precisamos abrir a partição para poder trabalhar nela, isso faremos com o comando abaixo:

{% highlight bash linenos %}
cryptsetup open /dev/sda3 linux
{% endhighlight %}

**IMPORTANTE**: Observe que no final do comando tem a palavra **linux**.

Ao fazer um **open** na partição criptografada, criará um "Physical Volume (PV)" automaticamente. Então **linux** será de agora em diante o "ponteiro" para meu Physical Volume (PV). Terá um link simbólico em **/dev/mapper**. 
Então esse será meu o "Physical Volume (PV)": **/dev/mapper/linux**
(não necessáriamente precisa ser **linux**, você pode colocar outro nome).

## LVM

Para explicar resumidamente o LVM, ele trabalha com:

* Physical Volume (PV) - (volume físico)
* Volume Group (VG) - (grupo de volume)
* Logical Volume (LV) - (volume lógico)

O "Physical Volume (PV)" foi criado quando demos um **open** na partição criptografada. O "Grupo de Volume (VG)" é criado para armazenar nossos "Logical Volume (LV)". O "Logical Volume (LV)" serão nossas partições (de distribuições) Linux em si. 

Dê o comando abaixo para ver informações sobre o "Physical Volume (PV)" criado:

{% highlight bash linenos %}
pvs
{% endhighlight %}

Agora temos que criar um "Volume Group (VG)" para armazenar nossos "Logical Volume (LV)". A syntax é `vgcreate <name group> <path physical volume>`. Então usaremos o comando:

{% highlight bash linenos %}
vgcreate linux /dev/mapper/linux
{% endhighlight %}

Observe que foi criado um "Volume Group (VG)" com nome de **linux** apontando para meu "Physical Volume (PV)" (**/dev/mapper/linux**). 
Pode ficar tranquilo que não vai ter conflito de nome com o "Physical Volume (PV)", pois são elementos diferentes. Os únicos nomes que não podem ser iguais são nos "Logical Volume (LV)". Falando nisso, vamos a criação deles.

Vamos criar nosso primeiro "Logical Volume (LV)", que é de **swap**. A Syntax é `lvcreate -L <size |M|G> <name group> -n <name logical volume>`. Então, para isso faremos com o comando:

{% highlight bash linenos %}
lvcreate -L 1G linux -n swap
{% endhighlight %}

Observe que ao criar, foi informado o "Volume Group (VG)", que criamos anteriormente, que no caso é **linux**, e o nome do "Logical Volume (LV)" que nesse caso será **swap**. Com 1G de tamanho.

Dê o comando abaixo para ver como ficou nosso "Logical Volume (LV)":

{% highlight bash linenos %}
lvs
{% endhighlight %}

Repare que ao criamos nosso "Logical Volume (LV)", ele pertence ao "Volume Group (VG)" **linux**. Tudo ok!

Agora resta criarmos nosso outros 2(dois) "Logical Volume (LV)" restante, um para o **sistema de arquivos** e o outro será a partição **home**. Então faremos:

{% highlight bash linenos %}
lvcreate -L 8G linux -n archlinux
lvcreate -l +100%FREE linux -n home
{% endhighlight %}

Repare que ao criarmos nosso "Logical Volume (LV)" **home**, foi usado a opção **+100%FREE**, isso faz com que ele pegue todo restante de espaço livre dentro do meu "Volume Group (VG)" para o **home**.

Terminamos a criação de nossa estrutura LVM , agora vamos para o próximo passo que é formatar as mesmas com um determinado tipo de partição para cada uma.

## Formatando as partições

**Sistema de Arquivos e Home**

A formatação da partição de **Sistema de Arquivos** e **Home** nada mais é que a formatação do nosso "Logical Volume (LV)" criado, os:

* /dev/mapper/linux-archlinux
* /dev/mapper/linux-home

Vamos utilizar o **ext4** para nossa partição de **sistema de arquivos* e nossa partição **home**. Então faremos:

{% highlight bash linenos %}
mkfs -t ext4 /dev/mapper/linux-archlinux
mkfs -t ext4 /dev/mapper/linux-home 
{% endhighlight %}

> **NOTA:** Observe que tem o nome **linux** antes do nome de nossa partições 
> de "Logical Volume (LV)", esse nome é justamente o "Volume Group (VG)" que 
> criamos. Ou seja, quando criamos nossos "Logical Volume (LV)", 
> automáticamente é inserido o nome do  "Volume Group (VG)". 

Você pode rodar o comando abaixo para ver as informações:

{% highlight bash linenos %}
lsblk -f
{% endhighlight %}

> Aviso: Muito cuidado ao formatar a partição **home** , você já pode ter ela
> com dados dentro (o que não é nosso, pois criamos uma do zero). Ao executar 
> uma formatação, todos os dados (caso tenha) contido na mesma, serão apagados.

**Boot**

Como dito antes, diferente das demais partições, a partição de **Boot**, é independentes do LVM, porém, precisamos formata-la e dar um tipo de partição para a mesma. Nossa partição de Boot é a **/dev/sda1**. Também usaremos o **ext4** para o tipo dessa partição. Então faremos assim:

{% highlight bash linenos %}
mkfs -t ext4 /dev/sda1
{% endhighlight %}

**Swap**

A partição "Logical Volume (LV)" **swap**, também necessita de formatação e alem disso, necessita ser ativada, para isso, usamos o comando **mkswap** para formatar, e o **swapon** para ativa-la. Então faça:

{% highlight bash linenos %}
mkswap /dev/mapper/linux-swap
swapon /dev/mapper/linux-swap
{% endhighlight %}

## Montagem das partições

Como a formatação terminada, precisamos montar as mesmas para poder iniciar a instalação do Archlinux. Por padrão, montamos o **sistema de arquivos** no diretório **/mnt** e a partição **home** em um diretório que precisa ser criado para sua montagem, o **/mnt/home/** . Então vamos aos comandos para esse feito:

{% highlight bash linenos %}
mount /dev/mapper/linux-archlinux /mnt
mkdir /mnt/home
mount /dev/mapper/linux-home /mnt/home
{% endhighlight %}

O mesmo devemos fazer para a partição de **Boot**, criando o diretório da mesma e montando. Então faremos assim:

{% highlight bash linenos %}
mkdir /mnt/boot
mount /dev/sda2 /mnt/boot
{% endhighlight %}

Finalizamos aqui a criação das partições, as formatações e as montagens. Agora vamos dar inicio a instalação do sistema base do Archlinux.


## Instalando o sistema base do Archlinux

Até o momento não utilizamos internet para realizar todos esses passos, mas de agora em diante, você irá necessitar.

Se você está fazendo esse tutorial com VirtualBox, então automaticamente já terá internet para você. O mesmo vale se você não estiver em VirtualBox mas esta com internet cabeada na máquina.

Se você está utilizando internet via Wifi, execute o comando `wifi-menu` que irá abrir um utilitário bem intuitivo para você fazer sua conexão com a internet.







## Conclusão

Se você observou, não formatamos a partição de **NTFS** (do Windows) pelo fato que o próprio **Windows** faz isso ao instalar. Apenas criamos caso queremos instalar do sistema do senhor *Gates*. 

Lembrando que, se você instalar o Windows depois de ter instalado o Archlinux (ou qualquer outra distribuição), o gerenciado de Boot do Linux (nesse caso é o Grub), será sobrescrito pelo MBR do Windows, e o Grub não será iniciado. Se isso acontecer, você precisará reinstalar o Grub do Archlinux novamente com o DVD do Archlinux (ou um pendrive bootável do mesmo). 

Eu criei um **script shell** para a recuperação do Grub no Archlinux, no momento ele serve somente para Archlinux, talvez eu dê um upgrade para server em outras distribuições também, mas ainda estou com preguiça hahaha. Ele é o [Recover Grub](https://github.com/williamcanin/recover-grub){:target="_blank"}. Dê uma olhada, é bem fácil de usar.
