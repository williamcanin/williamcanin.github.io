---
layout: post
date: 2017-04-27 11:33:43
title: Instalando Archlinux com criptografia LUKS e LVM
tags: ['archlinux','encryption', 'luks', 'lvm']
published: true
comments: true
share: true
excerpted: |
          Este post, irá lhe informar como ter uma segurança forte para proteção do seu S.O Arch Linux. Iae, quer estar protegido?!
day_quote:
 title: "A Palavra: "
 description: |
    "Eu sou o Senhor, o Deus de vocês; eu os seguro pela mão e lhes digo: 'Não fiquem com medo, pois eu os ajudo.' <br> (Isaias 41:13)"
script_js: [post.js]
---

* Do not remove this line (it will not be displayed)
{: toc}

# Requerimentos

* Imagem do [Archlinux](https://www.archlinux.org/download/){:target="_blank"} queimada em DVD ou Pendrive Bootável.
* Espaço livre no HD(SSD) ou usar [VirtualBox](https://www.virtualbox.org/){:target="_blank"} para realizar esse tutorial.
* Conexão com a Internet.

> Nota: Não irei entrar em detalhe de como realizar o procedimento de gravação
> de imagem ou como usar VirtualBox, não é o foco do tutorial.

Se você for instalar o Archlinux em uma máquina mesmo, você vai precisar de um celular, tablet, notebook, ou até mesmo outro desktop para poder acompanhar esse tutorial. Isso porque você vai cair em uma "tela preta" de comandos, e realmente é só você e "ela". Não tem um ambiente desktop para você acessar o navegador e pesquisar enquando instala igual outras distribuições.

# Introdução

Uma das coisas mais temidas para quem usa um computador, pode se dizer que é os dados contido nele. Dependendo de qual informação você tem em sua máquina, isso pode comprometer (e muito) sua vida pessoal, no trabalho, etc.

Ter uma máquina com uma senha de login "forte", **N Ã O** irá manter seus dados seguros de alguém que tenha um conhecimento não leigo. Vou enfatizar melhor com o seguinte exemplo qual seria esse conhecimento:

*Imagine você com sua linda máquina onde seu(s) S.O estão instalados em partições (ou até mesmo em um HD/SSD completo) que não tem criptografia. Simplesmente a pessoa pega um S.O bootável (no pendrive ou DVD), inicia sua máquina com o mesmo, monta as partições e, "tcharamm"! Os dados de sua máquina estão expostos para esse indivíduo 'esperto'.*

Com base nesse pequeno exemplo acima, podemos pensar:

**E se você impedir que as partições sejam montadas através de um sistema bootável? E se para montar partições tivesse uma senha para isso?**

Bom, com o alocador de volumes LVM no Linux e criptografia LUKS, isso é possível! Eba :smirk:

[LVM](http://web.mit.edu/rhel-doc/3/rhel-sag-pt_br-3/ch-lvm-intro.html){:target="_blank"} permite a criação de partições com a possibilidade de redimencioná-las. O disco ou seu conjunto é alocado em um ou mais volumes. O LVM trabalha com volumes físcos que são combinados com grupos lógicos.

[Luks](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup){:target="_blank"} é uma especificação de criptografia de disco originalmente planejada para Linux.

Essa criptografia pode ser aplicada a qualquer distribuição Linux. Porem, os passos são diferentes de acordo com a instalação da distribuição. Mas o conceito é o mesmo.

Então, neste caso, para podermos utilizar esse conceito de criptografia e de alocamento de disco com o LVM, temos que passar pelo processo de instalação da distribuição. Então, vamos a instalação...

 *Archlinux! Eu escolho você!*

# Preparando o básico

Já com o Archlinux em boot na máquina...

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/start_archlinux_boot.jpg|center %}    

&nbsp;a primeira coisa a se fazer é carregar o layout do teclado, para isso você precisa saber qual é o seu [KEYMAP](https://wiki.archlinux.org/index.php/KEYMAP_(Portugu%C3%AAs)){:target="_blank"}.

Uma forma de fazer isso via console, é usando o comando abaixo para listar os layouts disponíveis:

{% highlight bash linenos %}
localectl list-keymaps
{% endhighlight %}

No meu caso é `br-abnt2`:

{% highlight bash linenos %}
loadkeys br-abnt2
{% endhighlight %}

> Nota: Essa configuração é temporária, isso porque ainda não estamos com
> o sistema Archlinux instalado para deixar permanente.

Agora iremos carregar alguns módulos **crypt**, que iremos usar para realizar toda criptografia:

{% highlight bash linenos %}
modprobe -a dm-mod dm-crypt
{% endhighlight %}

# O fdisk

## Conceitos

O `fdisk` é uma ferramenta indispensável para quem usa Archlinux. É com ela que criamos todas partições em nosso disco durante a instalação. O `fdisk` é baseado através de linhas de comandos, como isso, você pode achar um pouco complexo no começo, mas com tempo se acostuma. :laughing: Caso realmente não queira utilizar o `fdisk`, existe o cfdisk.

O [cfdisk](https://en.wikipedia.org/wiki/Cfdisk){:target="_blank"}, é como se fosse um "fork" do `fdisk`, porem, baseado em uma interface usando as setas direcionais do teclado.

## Conhecendo a estrutura de partições

Vamos começar a partir de agora, a trabalhar com o `fdisk` para a criação de partições. Mas antes de começar, devemos entender a estrutura de partições que devemos ou queremos ter na máquina.

Nessa instalação, vou usar a seguinte estrutura de 3(três) partições:

* Uma para Linux Boot
* Uma para Windows
* Uma para Linux LVM

Não sei quanto a você, mas eu uso [Windows](https://www.microsoft.com/pt-br/windows/){:target="_blank"} e outras distribuições Linux em outras partições na minha máquina, então já vou aproveitar e deixar essa intalação com esse tipo de ambiente.

Caso você não utilize Windows e nem outras distribuições Linux, você simplesmente deve realizar a criação da partição de **Linux Boot** e uma para **Linux LVM**.

Como vamos utilizar **LVM** na partição Linux, nessa mesma partição podemos expandir outros volumes lógicos, ou seja, outras distribuições Linux dentro dessa partição do tipo LVM podem ser criadas (desde que exista espaço).

## Usando o fdisk

Primeira coisa a se fazer antes de usar o o `fdisk`, é obter as informações de nosso disco rígido, listando o mesmo para ver se encontra partições ou se o mesmo está sendo reconhecido. Então, para isso, digite o comando abaixo para realizar a listagem:

{% highlight bash linenos %}
fdisk -l
{% endhighlight %}

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/fdisk_list.jpg|center %}

Observe: Como estou utilizando o VirtualBox, repare que na listagem dos HD acima, só existe o `/dev/sda`, porem você pode ter mais de um HD/SSD, então cabe a você saber qual irá trabalhar. Neste caso iremos usar o `/dev/sda`.

Digite o comando abaixo para inicarmos o trabalho no disco `/dev/sda`.

{% highlight bash linenos %}
fdisk /dev/sda
{% endhighlight %}

Nesse momento o `fdisk` já está pronto para trabalhar no disco `/dev/sda`. Ele é bem intuitivo. Já diz para você digitar **m** para ver as opções. Faça isso.

Se você viu as opções, observou que a opção **n** é de **new**, ou seja, criar novas partições, e é justamente isso que precisamos nesse momento, criar nossas partições, então mãos a obra.

## Criando a partição de Boot com fdisk

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

Pronto, a partição foi criada, e o tipo da mesma como 'Linux'(isso se você observou o print que o `fdisk` deixou na tela :D).
A partição de Boot tem que ser do tipo Linux, mas além de ser Linux, ela terá que ser bootável. Para isso usamos a opção **a** do `fdisk`, que deixa uma partição Ĺinux do tipo bootável. Então:

> Digite: **a** e dê Enter

Certo, a nova partição obtevo o tipo bootável, mas ainda está gravado em memória do `fdisk` essas mudanças, precisamos salvar essas mudanças fisicamente. Para isso usa-se a letra **w** de **write**. Então:

> Digite: **w** e dê Enter

Ao gravar, o `fdisk` irá se fechar automaticamente , isso pra que você possa verificar se realmente as mudanças (ou partições) foram concluídas. Para verficar, apenas de o comando abaixo:

{% highlight bash linenos %}
fdisk -l
{% endhighlight %}

Veja na imagem que existe uma nova partição do disco `/dev/sda`, e essa partição é a `/dev/sda1`. Então nossa partição do tipo Boot foi criada com sucesso! Yuupii! :pray:

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/list_boot_partition.jpg|center %}

> Lembrando que se você estiver usando um sistema com EFI, crie uma partição
> do tipo EFI!

## Criando partição do Windows com fdisk

> Nota: A partição do Windows não suporta criptografia LUKS, isso porque,
> o LUKS só encarrega de gerenciar partições Linux. Então a partição Windows
> terá que ser independente.

Agora que você já sabe como criar partições com o `fdisk`, os passoas anteriores não precisam ser repetidos para as duas partições que nos resta, a de **Windows** e a do **Linux**.

Porém, algo **I M P O R T A N T E** que você precisa saber, é que toda vez que criamos uma partição nova, ela irá obter o tipo 'Linux' de inicio. Neste caso como é uma partição para Windows, e Windows utiliza **NTFS**, devemos editar o tipo dessa partição.

Você pode digitar **m** novamente para ver a letra que se aplica para deixar a partição em modo de edição, mas como sou bonzinho vou dizer, é a letra **t**, de **type**.

> Digite: **t** e dê Enter

O `fdisk` deixará sua partição em modo de edição, agora basta você escolher o tipo que essa partição vai ter, utilizando a própria sugestão do `fdisk`, onde pede para digitar **L** (em maíusculo) para listar os tipos de partições disponíveis.

> Digite: **L** e dê Enter

Nesse momento você verá a lista de tipos de partição, onde cada uma delas está sendo representada por um código, a partição de **NTFS** é o código **86**.

> Digite: **86** e dê Enter

Agora, simplesmente escreve essas mudaçãs como já aprendemos anteriormente com a opção **w**.

> Digite: **w** e dê Enter

## Criando partição "Linux LVM" com fdisk

Como vamos trabalhar com LVM, o tipo da partição Linux, **O B R I G A T Ó R I A M E N T E**, tem que ser do tipo *'Linux LVM'*. Então crie essa nova partição com o código: **8e**.

Chegamos ao final de criação de partições com `fdisk`, veja uma imagem de exemplo ficou:

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/list_all_partitions.jpg|center %}

Memorize bem as seguintes partições abaixo, pois iremos utilizar elas mais pra frente:

* Boot > /dev/sda1
* Linux > /dev/sda3

# O LUKS

## Conceitos

Existe várias formadas de criptografar partições com LUKS. Selecionei 3(três) delas que achei interessante para levantar alguns conceitos, veja:

- Criptografar a partição **Home** apenas com senha.
- Criptografar a partição **Home** com opção de keyfile e usar um pendrive com o mesmo Keyfile dentro para montar a partição **Home** no Linux.
- Criptografar a partição "Linux LVM" inteira, através de uma senha.


**A primeira** é interessante, deixamos todo sistema de arquivos sem criptografia, e quando o sistema for montar nossa partição **Home** , pedirá a senha. Porem, seus arquivos do sistema estarão expostos e existe muitas informações no sistema de arquivos que podem comprometer você. Então existe uma "brecha" de insegurança nessa opção.   
**A segunda** opção é a que eu menos recomendo, apensar de também ser interessante usar um pendrive para montar a **home**. Porem, se você criptografar somente a partição **home** e perder o pendrive com a keyfile (ou o pendrive queimar), por exemplo, você pode não conseguir iniciar o sistema, por depender dessa keyfile que não está disponível. E amiguinho, vai te dar *"dor de cabeça"*.   
**A terceira** opção, é a criptografia de todo o sistema Linux LVM, ela que iremos utilizar nesse tutorial. Talvez em um outro tutorial, eu explique como fazer uma criptografia da **primeira** e **segunda** opção.   

> Nota: Não tem como criptografar a partição de sistema de arquivos inteira
> com LUKS através de um keyfile no pendrive, isso porque você está mantendo o
> arquivo **/etc/fstab** criptografado também, e para um pendrive ser
> iniciado, ele necessita do **/etc/fstab**. Isso seria possível se ter uma
> partição apenas para o **/etc** e não criptografar ela. Mas pode te dar
> trabalho ao fazer isso, então vamos usar a primeira opção mesmo.

## Criptografando a partição "Linux LVM"

Lembra qual é nossa partição de **Linux LVM**? É a **/dev/sda3**. Pois bem, com a nova partição de **Linux LVM** criada, chegou a hora de trabalhar ela. Para iniciarmos a criptografia na nossa partição de **Linux LVM**, usaremos o comando abaixo:

{% highlight bash linenos %}
cryptsetup -y -v luksFormat -c aes-xts-plain64 -s 512 /dev/sda3
{% endhighlight %}

O LUKS irá pedir pra que você confirme com um **yes** (em uppercase), ou seja, assim: **YES**.

> Digite: **YES** e dê Enter

Após isso, irá pedir para informar a senha de criptografia e logo em seguida para confirmar. Então faça isso.

**A T E N Ç Ã O**: Nunca esqueça essa senha, pois é ela que você usará para iniciar no seu sistema futuramente.

Ok! Você já tem sua partição onde será instalada o Linux criptografada.

Precisamos abrir a partição para poder trabalhar nela, isso faremos com o comando abaixo:

{% highlight bash linenos %}
cryptsetup open /dev/sda3 linux
{% endhighlight %}

**IMPORTANTE**: Observe que no final do comando tem a palavra **linux**.

Ao fazer um **open** na partição criptografada, criará um "Physical Volume (PV)" automaticamente. Então **linux** será de agora em diante o "ponteiro" para meu Physical Volume (PV). Terá um link simbólico em **/dev/mapper**.
Então esse será meu o "Physical Volume (PV)": **/dev/mapper/linux**
(não necessáriamente precisa ser **linux**, você pode colocar outro nome). Se não entendeu o que é um "Physical Volume (PV)", continue a leitura que é nosso próprio assunto.

# O LVM

## Conceitos

Exemplificando o básico e resumidamente o LVM, para que seja o suficiente para trabalharmos nessa instalação do Archlinux, iremos utilizar 3(três) componentes do LVM, esses são:

* Physical Volume (PV) - (volume físico)
* Volume Group (VG) - (grupo de volume)
* Logical Volume (LV) - (volume lógico)

"Physical Volume (PV)": A unidade do armazenamento Physical Volume (PV) subjacente de um volume lógico LVM.   
"Volume Group (VG)": É criado para termos grupos para nossos "Logical Volume (LV)".    
"Logical Volume (LV)": Serão nosso volume lógico, ou seja, nossas partições Linux que usaremos para o sistema.   

Lembrando que se você quer saber mais afundo sobre LVM, eu te recomendo esse manual [Logical Volume Manager Administration](https://access.redhat.com/documentation/pt-BR/Red_Hat_Enterprise_Linux/6/html-single/Logical_Volume_Manager_Administration/){:target="_blank"}, que é uma documentação da própria [Red Hat](https://www.redhat.com/pt-br){:target="_blank"} sobre administradores do LVM.

## Utilizando os componentes do LVM

### Criando Physical Volume (PV)

Iremos precisar apenas de 1(um) Physical Volume (PV), porem ele já foi criado automaticamente quando realizamos um **open** na partição criptografada(**/dev/sda3**) anteriormente, lembra?!

Dê o comando abaixo para ver informações sobre o "Physical Volume (PV)" criado:

{% highlight bash linenos %}
pvs
{% endhighlight %}

Caso contrário não esteja criado (o que não deve ser o caso), crie o mesmo com o comando abaixo:

{% highlight bash linenos %}
pvcreate /dev/mapper/linux
{% endhighlight %}

### Criando Volume Group (VG)

Agora temos que criar um "Volume Group (VG)" para manter nossos "Logical Volume (LV)". A syntax é `vgcreate <name group> <path physical volume>`. Então usaremos o comando:

{% highlight bash linenos %}
vgcreate linux /dev/mapper/linux
{% endhighlight %}

Observe no comando acima, que está sendo criado um "Volume Group (VG)" com nome de **linux** apontando para meu "Physical Volume (PV)" (**/dev/mapper/linux**).
Pode ficar tranquilo que não vai ter conflito de nome com o "Physical Volume (PV)", pois são elementos diferentes. Os únicos nomes que não podem ser iguais são nos "Logical Volume (LV)". Falando nisso, vamos a criação deles.

### Criando Logical Volume (LV)

Vamos criar nosso primeiro "Logical Volume (LV)", que é de **swap**. A Syntax é `lvcreate -L <size |M|G> <name group> -n <name logical volume>`. Então, para isso faremos com o comando:

{% highlight bash linenos %}
lvcreate -L 1G linux -n swap
{% endhighlight %}

Veja que no comando acima, foi informado o "Volume Group (VG)", que criamos anteriormente, que no caso é **linux**, e o nome do "Logical Volume (LV)" que nesse caso será **swap**. Com 1 Gigabyte de tamanho.

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

Repare que o comando para criar nosso "Logical Volume (LV)" **home**, foi usado a opção **+100%FREE**, isso faz com que ele pegue todo restante de espaço livre dentro do meu "Volume Group (VG)" para o **home**.

Terminamos a criação de nossa estrutura LVM , agora vamos para o próximo passo que é formatar as mesmas com um determinado tipo de partição para cada uma.

Repare como ficou:

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/list_lvs.jpg|center %}

# Formatando as partições

## Sistema de Arquivos e Home

A formatação da partição de **Sistema de Arquivos** e **Home** nada mais é que a formatação do nosso "Logical Volume (LV)" criado, os:

* /dev/mapper/linux-archlinux
* /dev/mapper/linux-home

> **NOTA:** Observe que tem o nome **linux** antes do nome de nossa partições
> de "Logical Volume (LV)", esse nome é justamente o "Volume Group (VG)" que
> criamos. Ou seja, quando criamos nossos "Logical Volume (LV)",
> automaticamente é inserido o nome do  "Volume Group (VG)".

Vamos utilizar o **ext4** para nossa partição de **sistema de arquivos** e nossa partição **home**. Então faremos:

> Aviso: Muito CUIDADO ao formatar a partição **home** , você já pode ter ela
> com dados dentro (o que não é nosso, pois criamos uma do zero). Ao executar
> uma formatação, todos os dados (caso tenha) contido na mesma, serão apagados.

Formatando:   
{% highlight bash linenos %}
mkfs -t ext4 /dev/mapper/linux-archlinux
mkfs -t ext4 /dev/mapper/linux-home
{% endhighlight %}

Você pode rodar o comando abaixo para ver as informações:

{% highlight bash linenos %}
lsblk -f
{% endhighlight %}

## Boot

Como dito antes, diferente das demais partições, a partição de **Boot**, é independentes do LVM, porém, precisamos formatar a mesma e dar um tipo de partição. Nossa partição de Boot é a **/dev/sda1**. Também usaremos o **ext4** para o tipo dessa partição. Então faremos assim:

{% highlight bash linenos %}
mkfs -t ext4 /dev/sda1
{% endhighlight %}

## Swap

A partição "Logical Volume (LV)" **swap**, também necessita de formatação e além disso, necessita ser ativada, para isso, usamos o comando **mkswap** para formatar, e o **swapon** para ativar. Então faça:

{% highlight bash linenos %}
mkswap /dev/mapper/linux-swap
swapon /dev/mapper/linux-swap
{% endhighlight %}


> Nota: Não há necessidade de formatar a partição de **NTFS** (do Windows)
> pelo fato que o próprio **Windows** faz isso ao instalar. Apenas cria-se
> caso queira instalar do sistema do senhor *Gates*.  Lembrando que, se você
> instalar o Windows depois de ter instalado o Archlinux (ou qualquer outra
> distribuição), o gerenciado de Boot do Linux (nesse caso é o Grub), será
> sobrescrito pelo MBR do Windows, e o Grub não será iniciado. Se isso
> acontecer, você precisará reinstalar o Grub do
> Archlinux novamente com o DVD do Archlinux (ou um pendrive bootável do
> mesmo).
> Eu criei um **script shell** para a recuperação do Grub no Archlinux, no
> momento ele serve somente para Archlinux, talvez eu dê um upgrade para
> servir em outras distribuições também, mas ainda estou com preguiça hahaha.
> Ele é o [Recover Grub](https://github.com/williamcanin/recover-grub). Dê uma
> olhada, é bem fácil de usar.

# Montagem das partições

Como a formatação terminada, precisamos montar as mesmas para poder iniciar a instalação do Archlinux. Por padrão, montamos o **sistema de arquivos** no diretório **/mnt** e a partição **home** em um diretório que precisa ser criado para sua montagem, o **/mnt/home** . Então vamos aos comandos para esse feito:

{% highlight bash linenos %}
mount /dev/mapper/linux-archlinux /mnt
mkdir /mnt/home
mount /dev/mapper/linux-home /mnt/home
{% endhighlight %}

O mesmo devemos fazer para a partição de **Boot**, criando o diretório da mesma e montando. Então faremos assim:

{% highlight bash linenos %}
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot
{% endhighlight %}

Finalizamos aqui a criação das partições, as formatações e as montagens. Agora vamos dar inicio a instalação do sistema base do Archlinux.

# Instalando e configurando o Archlinux

## Conceitos

Até o momento não utilizamos internet para realizar todos esses passos, mas de agora em diante, você irá necessitar.

Se você está fazendo esse tutorial com VirtualBox, então automaticamente já terá internet para você. O mesmo vale se você estiver com internet cabeada na máquina.

Se você está utilizando internet via Wifi, execute o comando `wifi-menu` que irá abrir um utilitário bem intuitivo para você fazer sua conexão com a internet.

## Instalando o sistema base

Para instalar o sistema base use o comando abaixo:

{% highlight bash linenos %}
pacstrap -i /mnt base base-devel
{% endhighlight %}

Agora vá tomar um :coffee: , são mais de 200MB de download. A menos que tenha uma internet veloz. :smile:

## Criando /etc/fstab

Após a instalação do sistema base do Archlinux, vamos criar o arquivo **/etc/fstab**, que é responsável por dar "arranque" ao nosso sistema e partições. Para criar, faça:

{% highlight bash linenos %}
genfstab -p /mnt >> /mnt/etc/fstab
{% endhighlight %}

## Entrando no sistema instalado

Já podemos entrar dentro do nosso sistema instalado e começar a configurar o mesmo. Para realizar esse feito, execute esse "comandinho":

{% highlight bash linenos %}
arch-chroot /mnt /bin/bash
{% endhighlight %}

## Configurando layout do teclado

Devemos carregar o layout de teclado, ai se pergunta:

*Eu ja fiz isso no começo!*   

Mas agora estavamos dentro do sistema base instalado, então, devemos carregar novamente para podermos ter o layout corretamente a máquina. Então, novamente:

{% highlight bash linenos %}
loadkeys br-abnt2
{% endhighlight %}

Essa configuração será perdida, então para manter no sistema faremos:

{% highlight bash linenos %}
echo "KEYMAP=br-abnt2" > /etc/vconsole.conf
{% endhighlight %}

Esse comando, certifica-se de manter as configurações do layout de teclado nos consoles.

## Criando um senha para usuário `root`

Umas das primeiras coisas ao entrar no sistema base recém instalado, e atribuir a senha para o usuário **root**, pois o mesmo ainda não tem. Isso é simples, baixo executar o comando abaixo, informar e confirmar a senha:

 {% highlight bash linenos %}
passwd
{% endhighlight %}

## Instalado pacotes necessários

O gerenciador de pacotes padrão do Archlinux é o **pacman**. Caso você não saíba como utilizar, te recomendo a leitura no [wiki](https://wiki.archlinux.org/){:target="_blank"} do Archlinux, é um local muito rico em informações sobre o Archlinux, programas e suas configurações. O wiki do Pacman você pode encontrar lá também, ou clicar [AQUI](https://wiki.archlinux.org/index.php/Pacman_(Portugu%C3%AAs)){:target="_blank"}. Vamos instalar alguns pacotes necessários com o **pacman**, com o comando abaixo:

{% highlight bash linenos %}
pacman -S bash-completion vim wireless_tools wpa_supplicant wpa_actiond ntfs-3g dialog --noconfirm
{% endhighlight %}

## Habilitando idiomas

Agora vamos habilitar alguns idiomas para nosso sistema e ativá-los. Eu sempre gosto de deixar o Inglês(US) e o Português (BR). Então, faremos assim:

{% highlight bash linenos %}
sed -i 's/#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen
sed -i 's/#pt_BR.UTF-8 UTF-8/pt_BR.UTF-8 UTF-8/g' /etc/locale.gen
{% endhighlight %}

Agora vamos ativar os mesmos com o comando abaixo:

{% highlight bash linenos %}
locale-gen
{% endhighlight %}

## Informando o idioma padrão para o sistema

Como já temos o idioma de **pt_BR** habilitado, você já pode setar o mesmo para nosso sistema Archlinux (caso queira pt_BR). Para isso faremos os comando abaixo:

{% highlight bash linenos %}
echo LANG=pt_BR.UTF-8 > /etc/locale.conf
export LANG=pt_BR.UTF-8
{% endhighlight %}

## Configurando localidade

Localidade é o fuso horário do sistema, com os comandos abaixo faremos isso:

{% highlight bash linenos %}
rm -f /etc/localtime
ln -s /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc --utc
{% endhighlight %}

> NOTA: Como estou em SP, configurei para essa localidade. Coloque de acordo
>  com a sua. Para isso pode listar as que estão disponiveis em com o comando :
>  `ls /usr/share/zoneinfo/`.

> **Importante:**   
> Caso você use dual boot com Windows, você deve deixar para ambos UTC ou
> LOCALTIME. Haverá conflito de hora se um S.O estiver um com UTC e outro com
> LOCALTIME.

Para deixar o Archlinux configurado como LOCALTIME, execute o comando abaixo:

{% highlight bash linenos %}
printf "0.0 0.0 0.0\n0\nLOCAL\n" > /etc/adjtime
{% endhighlight %}

O aquivo **/etc/adjtime** é responsável por carregar o tipo da nossa hora (UTC ou LOCAL) na máquina. Atribuindo esse comando, irá deixar configurado para LOCALTIME.


## Configurando hostname

{% highlight bash linenos %}
echo "archlinux" > /etc/hostname
{% endhighlight %}

Existe o comando `hostnamectl`, que você tambem pode alterar seu hostname futuramente. Dê um `hostnamectl --help` e veja as opções.

## Habilitando rede cabeada durante o boot

Se você utiliza rede cabeada, será necessário habilitar [DHCP durante o boot](https://wiki.archlinux.org/index.php/Network_configuration_(Portugu%C3%AAs)#DHCP_durante_o_boot){:target="_blank"} da máquina para que você não precise ficar habilitando o mesmo quando já estiver no sistema.

Por padrão, no diretório **/sys/class/net** existe links simbólicos das interfaces de rede. Apenas de o comando `ls /sys/class/net` para listar.

{% imager instalando-archlinux-com-criptografia-luks-e-lvm/list_iface_net.jpg|center %}

Toda interface que começa com `enp` será a sua rede cabeada. Nesse caso a listada foi `enp0s3`. Então será ela que devemos habilitar durante o boot. Para isso executamos o seguinte comando:

{% highlight bash linenos %}
systemctl enable dhcpcd@enp0s3
{% endhighlight %}

... ou simplesmente o comando:

{% highlight bash linenos %}
systemctl enable dhcpcd
{% endhighlight %}

Leia sobre o [Systemctl](https://wiki.archlinux.org/index.php/Systemd_(Portugu%C3%AAs)){:target="_blank"}, pois você pode utilizar muito ele em seu Archlinux.

## Criando um usuário padrão

Nunca é recomendável usar um sistema com o usuário **root**, pois pode comprometer a estrutura do seu **sistema de arquivos** fazendo com que o sistema fique inutilizável. O recomendável é ter um usuário padrão, então vamos criar um com o comando abaixo usando o [useradd](https://wiki.archlinux.org/index.php/users_and_groups#User_management){:target="_blank"}:

{% highlight bash linenos %}
useradd -m -g users -G wheel,games,power,optical,storage,scanner,lp,audio,video -s /bin/bash <NAMEUSER>
{% endhighlight %}

Vamos informar uma senha para este usuário agora:

{% highlight bash linenos %}
passwd <NAMEUSER>
{% endhighlight %}

> NOTA: Onde está '< NAMEUSER >' coloque o nome do usuário que você quer.


## Configurando o /etc/fstab

Lembra que criamos o **/etc/fstab** antes de iniciarmos no sistema base do Archlinux? Pois bem, agora precisamos fazer algumas alterações.

Por padrão o **/etc/fstab** já está funcional, mas vamos acrescentar algumas outras configurações. Essas são:

* Adicionar a partição Windows para ser montada no boot (caso tenha Windows).
* Adiciona o reconhecimento do dispositivo CD/DVD.

 Vou utilizar o **vim** para edição, pois instalei ele lá nos *pacotes necessários*, lembra?! Você pode usar outro, como o **nano**.

Abra o arquivo:

{% highlight bash linenos %}
vim /etc/fstab
{% endhighlight %}

Para deixar o arquivo em modo de edição no **vim**...

> Digite: **i**

Posicione o ponteiro no final do arquivo e adicione essas linhas:

> ######## CD/DVD   
> /dev/sr0  /media/cdrom0  udf,iso9660 user,noauto  0  0   
> ######## Windows   
> /dev/sda2 /mnt/windows  ntfs-3g defaults,user,rw,auto  0  0   

Saia do modo de edição com a tecla **Esc**, e ...

> Digite: **:wq**

Isso irá SALVAR e SAIR do **vim**.

Agora temos que criar a pasta e link simbólico onde será montados esses dispositivos. Para isso, execute os comandos:

{% highlight bash linenos %}
 mkdir /media/cdrom0
 ln -s /media/cdrom0 /media/cdrom
 mkdir /mnt/windows
{% endhighlight %}

Pronto! Terminamos toda edição do **/etc/fstab**. Na próxima reinicialização da máquina, esses dispositivos já estarão montados.

## Configurando o /etc/mkinitcpio.conf

O arquivo **/etc/mkinitcpio.conf** é responsável por configurar a imagem de boot. Dentro do **/etc/mkinitcpio.conf** você coloca valores que pode modificar a forma de como o Archlinux irá se comportar e carregar algumas funções.

Por padrão, quando instalamos o Archlinux, não precisamos alterar em nada neste arquivo, porem, como utilizamos LVM e criptografia, devemos fazer algumas mudanças.

Então, abra o arquivo com seu editor preferencial. Usarei o **vim** novamente:

{% highlight bash linenos %}
vim /etc/mkinitcpio.conf
{% endhighlight %}

Ok, agora procure a variável **HOOKS=".."**, vamos acrescentar alguns recursos a mais na mesma.

> Nota: Se você observar os comentários logo acima de **HOOKS="..."**, vai ver
> que já nos dá uma dica de como devemos deixa-lá caso usamos criptografia e
> LVM.

Então vamos deixar assim:

> **HOOKS**=**"**base udev autodetect keymap **encrypt lvm2** modconf block
>  filesystems keyboard fsck**"**

Se você reparou no arquivo original, viu que foi adicionado somente o **encrypt** e o **lvm2**.

**OBRIGATÓRIAMENTE** tem que ser nessa ordem, mais precisamente depois de **autodetect**.

*Já pode SALVAR e FECHAR o editor*.

Com o **/etc/mkinitcpio.conf** configurado, basta "subir" essas novas configurações, para isso, temos que executar o seguinte comando:

{% highlight bash linenos %}
mkinitcpio -p linux
{% endhighlight %}

OK! Concluímos toda instalação e configuração do Archlinux. Agora vamos para a etapa do gerenciamento de boot.

# O Grub

## Conceitos

O Grub ([English](https://wiki.archlinux.org/index.php/GRUB){:target="_blank"}/[Portuguese](https://wiki.archlinux.org/index.php/GRUB_(Portugu%C3%AAs)#Instala.C3.A7.C3.A3o){:target="_blank"}) é um dos gerenciador de boot do Linux. Vamos utilizar o mesmo para gerenciar nosso boot.

## Instalando o Grub no sistema

Para instalarmos fazemos assim:

{% highlight bash linenos %}
pacman -S grub --noconfirm
{% endhighlight %}

Se utilizar um sistema com [UEFI](https://wiki.archlinux.org/index.php/GRUB#UEFI_systems){:target="_blank"}, irá precisar de um pacote extra, o **efibootmgr**. Então instale assim:

{% highlight bash linenos %}
pacman -S grub efibootmgr --noconfirm
{% endhighlight %}

Caso não use UEFI, ignore o pacote **efibootmgr**.

Se utilizar o Windows como dual boot, vai precisar usar o pacote **os-prober**, então ficaria assim:

{% highlight bash linenos %}
pacman -S grub os-prober --noconfirm
{% endhighlight %}

Caso não utilize o Windows com dual boot, ignore o pacote **os-prober**.

## Configurando o Grub

Por padrão, quando instalamos o Archlinux sem criptografia e sem LVM, não necessitamos editar o arquivo de configuração Grub, porém, como utilizamos, iremos fazer algumas mudanças necessárias.

Novamente usando o **vim**, abra o arquivo **/etc/default/grub**:

{% highlight bash linenos %}
vim /etc/default/grub
{% endhighlight %}

Agora deixe a variável **GRUB_CMDLINE_LINUX=""** da seguinte forma:

{% highlight bash linenos %}
GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda3:linux root=/dev/mapper/linux-archlinux"
{% endhighlight %}

Observe que em **cryptdevice** utilizamos a partição **/dev/sda3** que é a nossa *Linux LVM*. Logo a frente informamos o "Volume Group (VG)", o **linux**. Em **root** informamos nosso "Logical Volume (LV)" do nosso **sistema de arquivos**, o **/dev/mapper/linux-archlinux**.

Agora adicione as seguintes linhas (ou configure-as caso já exista), assim:

{% highlight bash linenos %}
GRUB_PRELOAD_MODULES="lvm"
GRUB_ENABLE_CRYPTODISK=y
GRUB_DISABLE_SUBMENU=y
{% endhighlight %}

A linha *GRUB_DISABLE_SUBMENU=y*, é para caso você estiver utilizando o VirtualBox, pois é necessário ter para não dar erro de boot no Grub conforme alguns testes que fiz.

Pronto! SALVE as alterações e FECHE o editor de texto.

## Gerando as configurações

Com toda configuração realizada, vamos levantar as mesmas para nosso sistema. Execute o comando abaixo:

{% highlight bash linenos %}
grub-mkconfig -o /boot/grub/grub.cfg
{% endhighlight %}

No momento, o Grub está instalado apenas no sistema operacional, mas não na unidade, o que veremos logo a seguir.

## Instalando o Grub na unidade

Agora precisamos instalar de fato o Grub e toda configuração do mesmo que realizamos na unidade **/dev/sda**. Para isso usamos o comando:

{% highlight bash linenos %}
grub-install /dev/sda
{% endhighlight %}

Se possua um sistema [UEFI](https://wiki.archlinux.org/index.php/GRUB#UEFI_systems){:target="_blank"}, faça dessa maneira:

{% highlight bash linenos %}
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
{% endhighlight %}

Se não apresentar erros, concluímos toda nossa instalação do Arclinux criptografado com LVM.

# Reiniciando o sistema

Basta executar os comandos abaixo ordenadamente para sair do ambiente de instalação, desmontar as unidades e reiniciar o sistema:

{% highlight bash linenos %}
exit
umount -R /mnt
systemctl reboot
{% endhighlight %}

> Nota: Se estiver instalando com VirtualBox, não esquece de tirar a mídia do
> Archlinux, caso contrário em vez do Archlinux instalado iniciar, será a
> mídia que fará essa função.

Agora, toda vez que iniciar o sistema (antes mesmo do boot), a senha de criptografia irá ser requerida, com isso, é interessante deixar o login automático para não ter que digitar senha no mesmo também. Para isso, recomendo ler [Getty](https://wiki.archlinux.org/index.php/Getty){:target="_blank"} no wiki do Archlinux.


# Conclusão

Me esforcei para fazer bem detalhadamente, bem intuitivo, para pessoas que estão començando possam compreender facilmente. Não é complicado a instalação, pois a extensão desde tutorial é válido mais pelos comentários, mas os comandos são poucos.

Sempre é recomendável seguir a documentação de qualquer software ou sistema operacional. A maioria dos comandos também existe documentação, o chamado **man**. Para usar, simplesmente digite no console: `man <comando>` , exemplo: `man fdisk`.

Explorar e aprender nunca é exagero. Até a próxima! :)

**Ao som de:**

{% jektify spotify/track/36FaicbcQqoLXBBqTW76Zk/dark %}

{% endpost #9D9D9D %}
