---
layout: post
title: "Linux: Compilando e instalando o kernel em modo tradicional"
date: 2015-08-23 17:52:44 -0300
comments: true
class: kernel
tags: ["kernel","linux","instalar"]
excerpted: |
   Quando um usuário Linux já está em um nível de usabilidade Linux a tempos, algo que ele procura saber, é como compilar um kernel, e esse post falará exatamente sobre isso, mas uma compilação sem usar kernel-package, a tradicional.
day_quote:
    title: "A Palavra:"
    content: |
        "Eu afirmo a vocês que isto é verdade: quem ouve as minhas palavras e crê naquele que me enviou tem a vida eterna e não será julgado, mas já passou da morte para a vida." <br>
        (João 5:24 NTLH)
categories: blog
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

# Índice

* [Introdução](#introdução)
* [Pacotes necessários](#pacotes-necessários)
* [Criando base de trabalho](#criando-base-de-trabalho)
* [Download do kernel](#download-do-kernel)
* [Descompactando o kernel](#descompactando-o-kernel)
* [Limpando a base](#limpando-a-base)
* [Configurando o kernel](#configurando-o-kernel)
  * [Manualmente](#manualmente)
    * [Reconhecendo os módulos da máquina](#reconhecendo-os-módulos-da-máquina)
      * [Metodo 1](#método-1)
      * [Metodo 2](#método-2)
      * [Metodo 3](#método-3)
    * [Iniciando a configuração](#iniciando-a-configuração)
    * [Manuseio para o “make menuconfig”](#manuseio-para-o-make-menuconfig)
  * [Automaticamente](#automaticamente)
    * [Carregando ".config" genérico](#carregando-config-genérico)
    * [Entrando no menu do kernel](#entrando-no-menu-do-kernel)
    * [Carregando drivers a partir do lsmod](#carregando-drivers-a-partir-do-lsmod)
  * [Finalizando as configurações](#finalizando-as-configurações)
* [Compilando o Kernel](#compilando-o-kernel)
* [Instalando os módulos compilados](#instalando-os-módulos-compilados)
  * [Instalação normal](#instalação-normal)
  * [Instalação compactada](#instalação-compactada)
* [Copiando o kernel para o /boot](#copiando-o-kernel-para-o-boot)
* [Criando a RAMDISK](#criando-a-ramdisk)
* [Copiando o “System.map” e “.config” para o /boot](#copiando-o-systemmap-e-config-para-o-boot)
* [Atualizando o gerenciador de boot](#atualizando-o-gerenciador-de-boot)
* [Conclusão](#conclusão)

# Introdução

Quando um usuário Linux já está em um nível de usabilidade Linux a tempos, algo que ele procura saber, é como compilar um kernel, e esse post falará exatamente sobre isso, mas uma compilação sem usar kernel-package, a tradicional.

Ter uma máquina customizada para ter um melhor desempenho e reconhecimento dos hardwares, é a vontade de todos, independente de qual sistema operativo o indivíduo usa. Usuários linux, podem fazer essa customização através de uma "recompilação" no kernel Linux (se você não sabe o que é um Kernel de Linux, veja [aqui](https://www.kernel.org/category/about.html)).

Compilar o Kernel para sua máquina, pode lhe trazer melhorias, bom desempenho e deixando a inicialização mais veloz, porém, isso é notável quando se tem uma máquina de baixa potência, pois compilar o kernel e utiliza-lo em uma máquina "top" você pode não perceber as alterações de desempenho se comparando com o kernel genérico, por ela ter uma gama de potência e um kernel genérico não deixará ela lenta. Mas é sempre recomendado deixar nosso S.O de acordo com nossos hardwares.

Caso queira compilar e deixar o núcleo que o titio Linus Torvalds criou, enxuto na sua máquina, você precisará ter um bom conhecimento dos hardwares da mesma no qual vai compilar, pois se não habilitar algo que a máquina necessita, pode não carregar modulos, e sem driver expecífico de algo que você use, por exemplo um driver da placa wireless.

Primeiro, não tenha medo, pois se você não habilitar um módulo que deveria ser habilitado, o máximo que você vai perder é o tempo da compilação do kernel, que é bem demorado dependendo da potência de sua máquina. E outra, se de um *"Kernel Panic"* você pode iniciar seu Linux com o kernel genérico de instalação quando reiniciar a máquina na próxima vez, pois quando se instala um novo kernel, seja qual for seu gerenciador de boot (Grub ou Lilo), ele vai aparecer na inicialização juntamente com o Kernel genérico/padrão de instalação do Linux (desde que atualize o Grub/Lilo), então não se preocupe. Medo devemos ter apenas do bicho papão. :stuck_out_tongue_winking_eye:

Segundo, existe várias formas para se compilar um kernel do Linux, várias distribuição Linux tem um jeito, porem irei fazer da forma mais tradicional nessa postagem, que **SERVIRÁ** para várias distro. Mas enfim, vamos deixar de teoria e começar logo essa aventura né? "Sigam-me os interessados!"

> NOTA: Nessa postagem, observe bem os comandos que devem ser executados com
> root (superusuário) e com usuário normal. Para comandos a serem executados
> com root (superusuário), destaquei anúncio em vermelho.

# Pacotes necessários

Antes de começar precisamos verificar/instalar todos os pacotes necessários para a compilação do kernel. Então, instale esses pacotes de acordo com sua distro.

> Debian/Ubuntu:

`(Execute como root (superusuário))`

{% highlight bash linenos %}
apt-get install libncurses5-dev libqt3-mt-dev libgtk2.0-dev libglib2.0-dev libglade2-dev
{% endhighlight %}

> Fedora:

`(Execute como root (superusuário))`

{% highlight bash linenos %}
dnf install ncurses-devel qt3-devel libXi-devel gtk2-devel libglade2-devel
{% endhighlight %}

> Arch Linux:

*Não necessita instalar pacotes.*


# Criando base de trabalho

Após a instalação dos pacotes necessários, vamos criar uma pasta chamada **kernel** no $HOME de seu usúario e entrar nela. Essa pasta será a base onde realizaramos o download do kernel e realizar todos os processos.

> NOTA: Existe vários forma de configurar o kernel, uma delas é no diretório
> /usr/src, o que muitas pessoas aderem essa forma, mais eu particulamente
> prefiro fazer tudo no $HOME, pois assim eu não deixo sobrecarregado a minha
> partição do sistema (/) com os conteúdos compilados, mais isso é relativo,
> de gosto próprio.

{% highlight bash linenos %}
$ mkdir $HOME/kernel && cd $HOME/kernel
{% endhighlight %}

# Download do kernel

Agora teremos o privilégio de baixar o núcleo que o titio Linus Torvalds criou, no site: [kernel.org](https://www.kernel.org){:target="_blank"}

Utilizarei o gerenciador de download **wget**, que pra mim é o meio mais eficiente de realizar downloads no Linux, pois o mesmo te possibilita continuar o download com a opção **-c** caso a energia acabe...você cancele sem querer o download... a bateria do notebook exploda...ai já é demais né?! Vá se benzer! ¬¬'

Para utilizar o download  com o **wget**, faça no terminal:

{% highlight bash linenos %}
$ wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-{VERSÃO}.tar.xz
{% endhighlight %}

Onde {VERSÃO}, é a versão do kernel que você irá baixar. Vou supor que estaremos utilizando o kernel 4.1.6 de agora em diante nesse tutorial, que é o kernel estável mais recente no momento. Então ficaria assim:

{% highlight bash linenos %}
$ wget https://www.kernel.org/pub/linux/kernel/v4.x/linux-4.1.6.tar.xz
{% endhighlight %}

> DICA: Como peguei o link de download do arquivo .tar.xz?
> Simples, clique com o botão direito do mouse no botão "pequenino" de cor 
> amarela no site https://www.kernel.org, e copie o *Endereço de link*.

Para saber mais sobre outras versões de kernel, acesse: [kernel versões](https://www.kernel.org/pub/linux/kernel/){:target="_blank"}

# Descompactando o kernel

Download realizado dentro da base de trabalho, agora vamos descompactar nosso 'ouro' utilizando o **tar** e entrar dentro da pasta do nosso kernel:

{% highlight bash linenos %}
$ xz -cd linux-4.1.6.tar.xz | tar xvf - && cd linux-4.1.6
{% endhighlight %}


# Limpando a base

Esse comando irá remover qualquer arquivo compilado que contenha na nossa querida pasta do kernel e volta para o estado primitivo das configurações, o que não é no nosso caso, pois não compilamos nada ainda, mas é sempre bom executá-lo para prevenção.

{% highlight bash linenos %}
$ make mrproper && make clean
{% endhighlight %}


# Configurando o kernel

## Manualmente

### Reconhecendo os módulos da máquina

A aventura começa aqui! Vamos saber os módulos e driver que sua máquina necessita e posteriormente configurarmos esses módulos no kernel. Como foi dito no começo, recompilar o kernel exige um certo reconhecimento de hardware da máquina, mas existem meios para facilitar isso, então irei dizer em partes.

Quando instalamos o Linux, o kernel da instalação é um kernel genérico, ou seja, é um kernel que funciona na maioria das máquinas, isso porque, vários módulos de vários tipo de driver são incorporados. Então isso leva a entender que o kernel padrão da instalação do Linux tem módulos que não utilizamos. Esse é um dos motivos de muitos querer recompilar o kernel, deixa-lo adaptável para vossa máquina.

> Mas como deixar o kernel adaptável à máquina e saber os módulos necessários
> para a mesma?

R: Assim que instalamos o Linux e iniciamos o mesmo, os módulos que nossa máquina necessita são carregados no boot(ou não) para que o sistema funcione, correto? Com isso, existe 3 métodos (que pelo menos eu conheço) para sabermos os modulos que a máquina iniciou, necessita e está usando no momento.

#### **Método 1**

O primeiro método é usar o comando:

{% highlight bash linenos %}
$ lspci -k
{% endhighlight %}

O que irá retornar os drivers **PCI** de sua máquina no título "Kernel modules". Exemplo do meu retorno:

{% gist d3a83921422cb4a861c8 %}

Com isso, você já saberá alguns principais módulos que sua máquina necessita.

#### **Método 2**

Na verdade, esse segundo método é um complemento do primeiro para identificar os demais hardwares da máquina, porem este lista periféricos de USB.

{% highlight bash linenos %}
$ lsusb -t
{% endhighlight %}

Irá retornar os drivers e possíveis módulos de entrada **USB** na variável "Driver". Um exemplo:

{% gist 8016fb7cedf5377a67d3 %}

#### **Método 3**

Na terceira opção, para listar os drivers/módulos que sua máquina carregou, é usar o comando:

> NOTA: Terá que ter o programa **hwinfo**, instalado no linux.
> Instale de acordo com sua distro. Por exemplo:
> Debian/Ubuntu: # apt-get install hwinfo
> Fedora: # dnf install hwinfo
> Arch Linux: # pacman -S hwinfo

{% highlight bash linenos %}
$ hwinfo | grep -i module && hwinfo | grep -i snd
{% endhighlight %}

> NOTA: Observe que será executado dois comandos unidos por "&&", você pode
> executa-los separadamente, para ter um retorno separado.

Na saída desse comando, o que pertencer ao título **"Driver Modules"** e tudo que começar com **"snd_"** será um driver que sua máquina possivelmente estará usando, necessita ou teŕá que ser carregado no kernel.

Para mais informações de comandos, use: **$ man hwinfo**.

---

Tem ainda o **lshw** que também lista seu hardware:

{% highlight bash linenos %}
$ lshw | grep -i driver
{% endhighlight %}

Nesse retorno, o título que está como "driver" será o importante, pois nele conterá os drivers listados.
O pacote **lshw**, também te possibilita gravar em forma de HTML as informações de sua máquina.
Para salvar todas informações do seu hardware em HTML, use o comando:

{% highlight bash linenos %}
$ lshw -html > $HOME/harware-info.html
{% endhighlight %}

Para mais informações de comandos, use: **$ man lshw**.

Se não quiser instalar pacotes que faça esse retorno de harware para você, você pode utilizar os próprios pacotes/arquivos existentes que vem por padrão nas distros, que também lhe trás informações ricas do hardware. Executando os comandos abaixo terá muitas informações:

{% highlight bash linenos %}
$ lscpu
$ cat /proc/cpuinfo
# dmidecode
{% endhighlight %}

Sendo que o último, você deve instalar o pacote **dmidecode** e executá-lo como root/superusuário.

### Iniciando a configuração

Agora que já sabe 3 métodos, execute o comando abaixo para entrar no menu de configuração do kernel do Linux e saber como pesquisar os módulos para sua máquina de acordo com os métodos que você utilizou acima.

{% highlight bash linenos %}
$ make menuconfig
{% endhighlight %}

> NOTA: Existe outros tipo de layouts de menu, porem esse é o padrão e mais
> utilizado por todos. É menu bem intuitivo, fácil de manusear, onde as setas
> são as responsáveis por direcionar o foco. Mas se quiser tem o
> **make nconfig, make config, make > gconfig e make xconfig**.

### Manuseio para o "make menuconfig"

No menu de configuração kernel você irá se deparar com configurações desse tipo: [  ] , [ \* ], [ M ], < >, -\*-.

**Legenda:**

[ ] indica que o módulo(s) está desabilitado.

[ \* ] indica que o(s) módulo está habilitado para ser incorporado ao kernel na compilação.

[M] indica que o(s) módulo(s) ficará habilitado mas não incorporado ao kernel.

-\*- indica que o módulo dever ser incorporado ao kernel na compilação, essa opção não dá pra alterar.

Outro recurso importante é a pesquisa de módulos/driver no menu (menuconfig) de configuração do kernel, a qualquer lugar que esteje, você apertando a tecla de barra do seu teclado (/), irá abrir uma janela dialog de pesquisa.
Por exemplo:

{% imager search-kernel-linux.png|center %}

Nessa dialog, você coloca um módulo/driver que foi listado com os comandos dos Métodos 1, 2 ou 3, e assim vai pesquisando os drivers para sua máquina no kernel. No exemplo abaixo, pesquisei o driver *"r8169*" que listou no comando *$ lspci -k*. Veja:

{% imager search-kernel-linux-return.png|center %}

A primeira observação, é a instrução *"Symbol"*, que irá dizer o nome do módulo e no final irá dizer se o mesmo está como "M, y ou n" (sendo que "y", é o mesmo que asterisco[ \* ] no menu de configuração do kernel).
A segunda observação é *"Prompt"*, que será o nome do módulo que estará imprimido no terminal.
A terceira observação está em *"Location"*, é o local onde esse módulo se encontra no menu do kernel. Entre nesse diretório e configure o módulo para [M], [ \* ] ou [ ].

**Lembrando!** Se o módulo que você colocou na pesquisa obtido nos Métodos 1, 2 ou 3, retornou algum resultado diferente de *"No matches found"*, é bem provável que a máquina necessite desse módulo.

Agora é só salvar toda configuração no "botão" Save, e com isso irá criar um arquivo oculto chamado **.config**.

*Guarde esse arquivo oculto ...*

*...pois ele é o conteúdo de toda essa <strike>trabalhosa pesquisa e</strike> configuração que você teve que fazer no kernel para sua máquina.*


## Automaticamente

Esse é o mais rápido meio de configurar o kernel de acordo com os módulos que sua máquina necessita. Você não precisa fazer pesquisa de todos módulos que sua máquina precisa no menu de configuração do kernel.
Esse meio de configurar, irá usar *lsmod* para examinar quais módulos estão atualmente em uso, e, em seguida, configurar/criar o seu **".config"**. O resultado é um tempo de compilação mais curto e um kernel específico para o seu hardware. Porem, deve-se executar a partir de uma máquina que esteja usando um kernel genérico, para assim, trabalhar com os drivers para seu hardware carregados como módulos. Se não utilizar uma máquina iniciada com um kernel genérico, o *lsmod* não irá identificar os drivers embutidos no kernel. Então se estiver preparado, faça os seguintes procedimentos abaixo de acordo com sua distro Linux:

### Carregando .config genérico.

Fedora/Debian/Ubuntu:

`(Execute como root (superusuário))`

{% highlight bash linenos %}
cp /boot/config-$(uname -r) .config
{% endhighlight %}

Arch Linux:

`(Execute como root (superusuário))`

{% highlight bash linenos %}
zcat /proc/config.gz > .config
{% endhighlight %}

### Entrando no menu do kernel

{% highlight bash linenos %}
$ make menuconfig
{% endhighlight %}

Vá no botão de Salvar e salve. Sai do menu do kernel.

### Carregando drivers a partir do lsmod

{% highlight bash linenos %}
$ make localmodconfig
{% endhighlight %}

Pronto. Seu **'.config'** já foi criado após esse comando. Porém, se depois desse comando aparecer algo como...

{% highlight bash linenos %}
module btintel did not have configs CONFIG_BT_INTEL
{% endhighlight %}

...quer dizer que esse módulo/driver (btintel) não está configurado, então você deve configura-lo no kernel. Abra o menu do kernel (make menuconfig) e pesquisa por esse driver (como foi dito na forma manualmente lá em cima) e habilite-o. Faça isso para todos que aparecer com uma mensagem parecida com está. Depois habilite com [M] ou [ \* ], e salve.

Essa forma de configurar é mamão com açucar né?, porem, irei abrir um parenteses grande:

> **(Você deve plugar na entrada USB dispositivos como: pendrive, HD Externos,
> mouse ou impressora. Se usar algum programa de criptografia que faz montagem
> de dispositivos, também deve estar habilitado para reconhecer o driver de
> CRYPT. Se você usa Steam, inicie o aplicativo pois ele usa o driver HID.
> Antes de criar o arquivo ".config", o comando 'localmodconfig' verifica as
> entradas que está sendo utilizadas e possíveis programas que estão
> utilizando (ou necessitam) de um determinado driver para sua máquina. Essas
> foram algumas necessidades que precisei 'startar' no meu harware, porém,
> existem vários aplicativos que irá usar algo do seu harware, cabe a você
> saber quais irão usar, por isso, saber do seu harware e saber o que
> habilitar no kernel, é fundamental sim, mesmo utilizando a opção
> automatizada de configurar o ".config". Módulos de USB, não são habilitados
> por padrão no boot/inicialização, e sim apenas quando estão em uso)**.

Outra forma de configurar o ".config" com o **localmodconfig**, é usar um parâmetro para carregar um lsmod em arquivo, ou seja, primeiro você cria um arquivo com o comando:

`(Execute como root (superusuário))`

{% highlight bash linenos %}
lsmod > /tmp/lsmod
{% endhighlight %}

...irá inserir todos os módulos que sua máquina esta usando no arquivo **"/tmp/lsmod"** (porem, também deve-se plugar todos os tipos de periféricos que você usa (Pendrives, HD Externo, Impressora..etc)).

Após gerar o arquivo, já pode usar-lo com o **"localmodconfig"**:

{% highlight bash linenos %}
$ make LSMOD=/tmp/lsmod localmodconfig
{% endhighlight %}

A vantagem de usar um arquivo gerado com o **"lsmod"** para armazenar seus módulos carregados, é que você plugue os periféricos (Pendrives, Impressora..etc) apenas uma única vez, não necessitado de plugar toda vez que for usar o **"locamodconfig"**, ou seja, já terá seus módulos carregados em um arquivo. Apenas guarde-o!

> NOTA 1: O diretório para gerar o arquivo através do "lsmod", é opcional, não
> necessita ser em "/tmp".Deve usar "make LSMOD=" com letras maiusculas no
> LSMOD.

> NOTA 2: Se após executar o comando: $ make localmodconfig ou
> $ make LSMOD=/tmp/lsmod localmodconfig , e vir uma série de perguntas,
> apenas digite "Y"para todas elas caso você tenha dúvidas.

> Observação: O arquivo contendo os módulos, criado através do comando **
> lsmod**, serviu apenas para a distribuição que eu gerei ele. Exemplo: Criei
> o arquivo no Ubuntu, e não funcionou no Arch Linux quando o incorporei
> no **"make LSMOD"**.

---

Agora que já sabe os "macetes" de como listar os drivers necessários
para sua máquina e como configurar um kernel adaptando para a mesma, fica a seu critério qual utilizar, opção "manualmente" (através do menuconfig) ou a opção "automaticamente" (usando o localmodconfig).
Eu sempre usei a opção "automática" de configurar o kernel, nunca tive problemas. Agora se quer se aventurar e conhecer bem as opções no menu de configurações do kernel, faça a configuração "manualmente".

> NOTA: Existe outras formas de configurar o kernel, você pode saber lendo o
> arquivo "README" contido no kernel, na parte "CONFIGURING the kernel".


# Finalizando as configurações

Para terminar as configurações do kernel, seja qual forma você preferiu seguir, "manualmente" ou "automaticamente", você tem que fazer uma configuração recomendada, para que não aconteça "cagada" futuramente, porque se esquecer de fazer essa configuração, você pode substituir um kernel já existente por essa nova compilação. Essa configuração é nada mais e nada a menos que o *"sobrenome"* (vou chamar assim) que seu kernel compilado irá receber. Por padrão, o kernel já terá um "nome", que é a versão do mesmo após compilar, mas é bom colocar um "sobrenome" para o kernel, afinal, qual filho não tem sobrenome nesse mundo, hein?! KKK ;)

Esse passo é feito através do submenu **"Local version"** do kernel, que tem um significado de "corda extra para o final da sua versão". Para isso, entre no menu de configuração do kernel (caso não esteja nele) com o comando:

{% highlight bash linenos %}
$ make menuconfig
{% endhighlight %}

Com o menu aberto, entre no seguinte local [A tecla 'Enter' seleciona o local]:

{% highlight bash linenos %}
-> General setup
    -> Local version - append to kernel release
{% endhighlight %}

 Na nova janela de dialog utilize esse formato:

{% highlight bash linenos %}
-ARCH-RC[NÚMERO]
{% endhighlight %}

 Onde:

ARCH: Arquitetura do seu Linux (x86_64/i386, amd64..etc)
RC: De release candidate.
[NÚMERO]: O numero de vezes que a versão desse kernel foi compilado.

Você pode colocar o que quiser, porem eu acho essa forma mais compreensível de se entender. Um exemplo de como poderia ficar:

> -x86_64-RC1

Note que tem um traço no começo, será a separação da versão do kernel(nome) com a arquitetura e compilação (sobrenome), pois quando você digitar **uname -a** no terminal, irá aparecer algo parecido com isso:

> Linux 4.1.6-x86_64-RC1

Após fazer essa configuração, salve no botão 'Save' e saia do *menuconfig*.

# Compilando o Kernel

Agora é a tão sonada hora de todos! Após realizar a dedicada configuração do kernel (dedicada para quem fez a configuração manualmente, claro rs) você vai poder fazer aquele "descansinho"... dar uma longa caminhada, viajar para Fernando de Noronha (esse último descanso é mentira! :D), porque dependendo da sua máquina, esse processo demora entre 1 hora ou mais (e isso não é mentira :frowning:). Então amigo, execute o comando abaixo e vá procurar algo para se distrair:

{% highlight bash linenos %}
make -j[NUMERO DE NÚCLEO DO PROCESSADOR +1] && make -j[NUMERO DE NÚCLEO DO PROCESSADOR +1] modules
{% endhighlight %}

> **NOTA:** Onde está [NUMERO DE NÚCLEO DO PROCESSADOR +1] é o numero de 
> núcleos do processsador da máquina + 1. Por exemplo, se a máquina possui 
> 2(dois) núcleos de processadores então ficará 2+1=3. 
> Exemplo: **"make -j3 && make -j3 modules"**. Com isso, você fará sua máquina 
> compilar o kernel com mais potência, o que diminuirá o tempo de compilação 
> (e seu "descansinho" será mais rápido rs). Caso você não saíba sobre quantos 
> núcleos tem seu processador, execute o comando **lscpu** e veja algo como 
> Núcleos. Porém, recomendo que utilize o comando: 
> **$ make && make modules**, sem jobs(-j).

# Instalando os módulos compilados

Iae indivíduo! Já voltou do seu outro afazer? Vamos instalar esses módulos?
Pois de agora em diante os passos são "rapidinhos".

> NOTA: OS módulos serão instalados na pasta **"/lib/modules/{VERSÃO-DO-KERNEL}
> -ARCH-RC[NÚMERO]"** (Exemplo: /lib/modules/4.1.6-x86_64-RC1).
> Deve-se saber que os módulos por padrão, serão construídos nessa pasta
> com informações de depuração, o que acaba deixando a pasta com um tamanho de
> aproximadamente 2GB. Para reduzir esse tamanho, você pode usar a variável de
> ambiente **INSTALL_MOD_STRIP** com o valor de 1(um). Assim, a instalação dos
> módulos em **"/lib/modules/4.1.6-x86_64-RC1"**, será compactada. Porém, é
> algo opcional.

`IMPORTANTE! Os comandos do "Instalando os módulos compilados" deverão que ser executados como root (superusuário).`

## Instalação normal

**Usando núcleos do processador:**

{% highlight bash linenos %}
make -j[NUMERO DE NÚCLEO DO PROCESSADOR +1] modules_install
{% endhighlight %}

**NÃO usando núcleos do processador:**

{% highlight bash linenos %}
make modules_install
{% endhighlight %}

## Instalação compactada

**Usando núcleos do processador:**

{% highlight bash linenos %}
make -j[NUMERO DE NÚCLEO DO PROCESSADOR +1] INSTALL_MOD_STRIP=1 modules_install
{% endhighlight %}

**NÃO usando núcleos do processador:**

{% highlight bash linenos %}
make INSTALL_MOD_STRIP=1 modules_install
{% endhighlight %}

# Copiando o kernel para o /boot

Kernel compilado, módulos instalados... agora vamos copiar o **"bzImage"** gerado para a pasta de onde começa a iniciar todo o nosso sistema operativo Linux, que é a pasta **"/boot"**.

`IMPORTANTE! O comando do "Copiando o kernel para o /boot" deverão que ser executados como root (superusuário).`

{% highlight bash linenos %}
cp -v arch/x86/boot/bzImage /boot/vmlinuz-{VERSION}-{ARCH}-{RC}
{% endhighlight %}

Lembra do "nome", que é a versão do nosso kernel, e o "sobrenome" (arquitetura+numero da compilação) que foi inserido ao kernel em **"Local version"** no menuconfig? Então, use eles no *vmlinuz-{VERSION}-{ARCH}-{RC}*, por exemplo:


> vmlinuz-4.1.6-x86_64-RC1


# Criando a RAMDISK

Nesse passo vai depender de sua distribuição Linux. Use um dos comandos abaixo para criação da RAMDISK:

`IMPORTANTE! O comando do "Criando a RAMDISK" deverão que ser executados como root (superusuário)..`

Para você, usuário de [Arch Linux](https://www.archlinux.org/){:target="_blank"}

{% highlight bash linenos %}
mkinitcpio -k {VERSION}-{ARCH}-{RC} -c /etc/mkinitcpio.conf -g /boot/initramfs-{VERSION}-{ARCH}-{RC}.img
{% endhighlight %}


Se você usa [Debian](http://debian.org){:target="_blank"}/[Ubuntu](http://www.ubuntu.com/){:target="_blank"}, faça assim:

{% highlight bash linenos %}
mkinitramfs -o /boot/initrd-{VERSION}-{ARCH}-{RC}.img /lib/modules/{VERSION}-{ARCH}-{RC}
{% endhighlight %}

ou

{% highlight bash linenos %}
update-initramfs -c -k {VERSION}-{ARCH}-{RC}
{% endhighlight %}


Para usuário <strike>"Fedorendo" (haha brincadeira)</strike> [Fedora](https://getfedora.org/){:target="_blank"}, faça assim:

{% highlight bash linenos %}
dracut /boot/initramfs-{VERSION}-{ARCH}-{RC}.img /lib/modules/{VERSION}-{ARCH}-{RC}
{% endhighlight %}

# Copiando o "System.map" e ".config" para o /boot

`IMPORTANTE! O comando do "Copiando o "System.map" e ".config" para o /boot" deverão que ser executados como root (superusuário).`

O arquivo **System.map** não é necessário para inicialização do Linux. É um tipo de *"lista telefônica"* de funções em uma construção particular de um kernel. O **.config** também não é necessário para iniciar o Linux, mas mesmo assim iremos copiar ambos para a pasta **/boot** para fins de organização e possíveis informações futuras. Para isso faça:

{% highlight bash linenos %}
cp System.map /boot/System.map-{VERSION}-{ARCH}-{RC}
cp .config /boot/config-{VERSION}-{ARCH}-{RC}
{% endhighlight %}


# Atualizando o gerenciador de boot

`IMPORTANTE! O comando do "Atualizando o gerenciador de boot" deverão que ser executados como root (superusuário).`

Após todo o processo, nesse passo você terá que atualizar o gerenciador de boot, póis só assim, a nova imagem de boot do kernel compilado será reconheciada ao inciarmos a máquina. Suponho que seu gerenciador de boot seja Grub. Então faça assim para atualizar:

Debian/Ubuntu:

{% highlight bash linenos %}
update-grub && grub-install /dev/sda
{% endhighlight %}

Fedora:

{% highlight bash linenos %}
grub2-mkconfig -o /boot/grub2/grub.cfg && grub-install /dev/sda
{% endhighlight %}

Arch Linux

{% highlight bash linenos %}
grub-mkconfig -o /boot/grub/grub.cfg && grub-install /dev/sda
{% endhighlight %}


> NOTA: Se sua distribuição usa o LILO como gerenciador de boot, não faça os
> "Copiando o kernel para o /boot", "Criando a RAMDISK" e 
> "Atualizando o gerenciador de boot". Após compilar o kernel utilize o 
> comando abaixo para realizar a instalação através do próprio script de 
> instalação do kernel:

{% highlight bash linenos %}
\# make install
{% endhighlight %}


# Conclusão

Ufa! Terminou, e eu fico por aqui! :satisfied:. Espero que sua compilação do kernel tenha sido um sucesso,  mas caso não tenha, não desista, refaça os processos e procure saber sobre o problema e sobre o hardware da máquina se possível, pois o mundo Linux é muito prazeroso de se aprender. Até próxima leitor!


