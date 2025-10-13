---
layout: post
title: "Criptografando a partição HOME no Linux"
description: |
  Que tal esconder suas coisinhas da /home de possíveis pessoas "espertas"? Siga em frente neste post e descubra.
author: "William C. Canin"
date: 2017-10-16 03:51:44 -0300
update_date:
comments: true
tags: [crypt,linux,security]
---

{% include toc selector=".post-content" max_level=3 title="Índice" btn_hidden="Fechar" btn_show="Abrir" %}

Olá para você pessoa, como vai? Eu vou bem graças a Deus e obrigado por perguntar mentalmente hehe.
Esse é um post de segurança...é o que todos querem, não é?! hehe Então lá vai...

# Introdução

Todos usuários Linux sabem que o diretório **/home** é onde fica armazenado toda nossa "bancada" de arquivos importantes, ou seja, é onde tudo é salvo, e tudo acontece. Pensando nisto, pensei um fazer um post como proteger a **/home**, o que é muito legal. Então vamos lá.

Mesmo que você coloque uma senha muito difícil de login, você não está seguro de alguem pegar seus arquivos. Se alguém ligar sua máquina com um sistema bootável pendrive ou DVD, essa pessoa consegue montar a partição Linux e acessar seus arquivos.

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

Para dar continuidade a este tutorial, você precisa estar logar no sistema como ROOT. Se você não conseguir logar como ROOT, você pode fazer logout da sessão (caso esteja com usuário comum) e abrir um novo **tty** digitando `Ctrl + Alt + F4`, após isso, você faz o login com root. É necessário usar o usuário *root* para realizar as etapas, porque a home do usuário root não fica no **/home** no qual vamos configurar, e sim em **/root**.

Após logar com root, vamos carregar os módulos de criptografia, qual vamos usar executando no console:

{% highlight bash  %}
modprobe -a dm-mod dm-crypt
{% endhighlight %}

## Fazendo backup da nossa /home atual

A primeira coisa a se fazer é um backup da nossa **/home**. Se a partição raiz do sistema (**/**) tiver espaço suficiente, você pode fazer o backup para a pasta **/opt**, por exemplo, da seguinte maneira:

{% highlight bash  %}
mkdir -p /opt/backup
cp -rf /home /opt/backup
{% endhighlight %}

Caso não tenha, você pode estar usando um **HD/SSD** ou até mesmo um **pendrive**.

## Listando nossas partições

Dê o comando abaixo para listar nossas partições e identificar nossa partição **/home** atual:

{% highlight bash  %}
lsblk -f /dev/sda
{% endhighlight %}

## Criptografando a partição

Vamos imaginar que nossa partição **/home** seja a **/dev/sda2**, com isso vamos desmontar a mesma e logo em seguida criptografar através do **cryptsetup** da seguinte maneira:

> NOTA: LEMBRE-SE DE TER FEITO O BACKUP DE TODA SUA /home POIS ELA SERÁ DESTRUÍDA AGORA.

{% highlight bash  %}
umount /home
cryptsetup -y -v luksFormat -c aes-xts-plain64 -s 512 /dev/sda2
{% endhighlight %}

O LUKS irá pedir pra que você confirme com um **yes** (em uppercase), ou seja, assim: **YES**.

> Digite: **YES** e dê Enter

Após isso, irá pedir para informar a senha de criptografia e logo em seguida para confirmar. Então faça isso.

**A T E N Ç Ã O**: Nunca esqueça essa senha, pois é ela que você usará na inicialização do sistema para para montar a **/home** futuramente.

Ok! Você já tem sua partição **/home** criptografada

## Abrindo partição criptografada

Agora precisamos abrir a partição para poder trabalhar nela, isso faremos com o comando abaixo:

{% highlight bash  %}
cryptsetup luksOpen /dev/sda2 home
{% endhighlight %}

**IMPORTANTE**: Observe que no final do comando tem a palavra **home** (Não necessáriamente precisa ser **home**, você pode colocar outro nome).

Ao fazer um **open** na partição criptografada, criará um "ponteiro" para nossa **home** no diretório **/dev/mapper**, ou seja, será encontrado assim: **/dev/mapper/home**. Porem, esse ponteiro **/dev/mapper/home** será excluído após desmontarmos essa partição ou quando desligar/reiniciar a máquina, para essas configurações se manter usaremos 2(dois) arquivos para isso, onde veremos mais a seguinte, enquanto isso vamos seguir passo por passo.

*A senha que você colocou para criptografar irá ser requerida nesse momento, então informe-a para abrir nossa partição criptografada.*

## Formatando a partição criptografada

Com nossa partição criptografada já aberta, precisamos formatar a sua montagem (**/dev/mapper/home**) para o tipo ext4. Para isso faremos:

{% highlight bash  %}
mkfs -t ext4 /dev/mapper/home
{% endhighlight %}

## Montando a partição e restaurando backup

Agora, vamos montar essa partição formatada e fazer a restauração do nosso backup. Então, faremos essas etapas com os comandos abaixo:

{% highlight bash  %}
mkdir -p /mnt/home
mount -t ext4 /dev/mapper/home /mnt/home
cp -rf /opt/backup/home/* /mnt/home # Essa linha irá restaurar seu backup.
chown usuário:usuário -R /mnt/home/usuário
chmod 770 -R /mnt/home/usuário
{% endhighlight %}

> NOTA: Onde está **usuário** você deve colocar o nome do seu usuário, por exemplo: **william**.

## Fechando nossa partição criptografada

Pronto! Agora vamos fechar nossa partição criptografada com o seguinte comando abaixo:

{% highlight bash  %}
umount /mnt/home
cryptsetup close /dev/mapper/home
## Linha baixo apaga a pasta que criamos para montagem. Pasta vazia.
rm -rf /mnt/home
{% endhighlight %}

# Criando arquivos para montagem automática

Como foi mencionado acima, a partição que abrir com o cryptsetup **/dev/mapper/home** ela não fica permanente, então precisamos criar ou editar 2 (dois) arquivos no **/etc**.

## Crypttab

O arquivo **/etc/crypttab** é responsável por informar nosso sistema que existe um dispositivo criptografado. Caso ele não exista crie e adiciona as seguintes linhas:

{% highlight bash  %}
# <target name>	<source device>		<key file>	<options>
home UUID=00000000-0000-0000-0000-0000000000 none discard
{% endhighlight %}

O número de **UID** que está tudo zerado, coloquei para ilustrar. Esse número é o **UID**  que você terá que colocar no **/etc/crypttab** da partição criptografada. Porém, antes disso dê o comando abaixo para lhe retornar informações da partição criptografada e você saber o **UID** da mesma:

{% highlight bash  %}
lsblk -f | grep "cryp"
{% endhighlight %}

Vai lhe retornar um número extenso, é este que você tem que colocar. Por exemplo, a saída do comando em minha máquina foi essa:

{% highlight bash  %}
william at ubuntu in folder ~  ○
 ⇨ lsblk -f | grep "cryp"
  └─linux-home    crypto_LUKS                        824049e5-d6a1-4e91-a1fd-682456b6b500

  william at ubuntu in folder ~  ○
 ⇨
 {% endhighlight %}

Com isso meu arquivo **/etc/crypttab** deveria ficar assim:

{% highlight bash  %}
# <target name>	<source device>		<key file>	<options>
home UUID=824049e5-d6a1-4e91-a1fd-682456b6b500 none discard
{% endhighlight %}

Pronto! Terminamos toda configuração do arquivo **/etc/crypttab**.

## Fstab

O arquivo **/etc/fstab** é responsável por carregar todo dispositivo na inicialização de nossa máquina. Ao criamos (ou editarmos) o arquivo **/etc/crypttab**, precisamos informar o mesmo no arquivo **/etc/fstab** para que nossa máquina reconheça que existe um dispositivo criptografado a ser lançado na inicialização da máquina.

Para isso, vamos adicionar no **/etc/fstab** a seguinte linha abaixo:

{% highlight bash  %}
/dev/mapper/home /home ext4 rw,relatime,data=ordered 0 2
{% endhighlight %}

Feito, as configurações do arquivo **/etc/fstab** foram concluídas.

# Colocando partição para funcionar

Terminamos aqui toda configuração da partição **/home** criptografada e dos arquivos que a mesma partição necessita. Porém, antes de reiniciar, execute os comandos abaixo com o **grub-mkconfig** (ou *grub2-mkconfig* dependendo da distro que você usa) para criar novamente nossa imagem de boot:

{% highlight bash  %}
grub-mkconfig -o /boot/grub/grub.cfg && grub-install /dev/sda
{% endhighlight %}

Agora, basta você reiniciar sua máquina, e durante o boot, antes de montar sua **/home**, o sistema irá pedir a senha para descriptografar a **/home** e montar a mesma.

# Archlinux e derivados

Essas configurações são válidas para a maiorias das distribuições Linux, porem, se você usa [Archlinux](https://www.archlinux.org/){:target="_blank"} ou derivados, você precisa fazer algumas configurações a mais no arquivo **/etc/mkinitcpio.conf** e **/etc/default/grub**.

## Arquivo /etc/mkinitcpio.conf

No arquivo **/etc/mkinitcpio.conf**, você terá que adicionar em **HOOKS** a palavra **encrypt**. Se usar [Plymouth](https://aur.archlinux.org/packages/plymouth/){:target="_blank"}, você deve colocar **plymouth-encrypt**.

Agora você precisa gerar uma imagem nova do **mkinicipo** com o comando abaixo:

{% highlight bash  %}
mkinitcpio -p linux
{% endhighlight %}

## Arquivo /etc/default/grub

No arquivo **/etc/default/grub**, você deve deixar o **GRUB_CMDLINE_LINUX** da seguinte maneira:

{% highlight bash  %}
GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:home"
{% endhighlight %}

Vamos refazer a imagem de boot e instalar o grub com o comando:

{% highlight bash  %}
grub-mkconfig -o /boot/grub/grub.cfg && grub-install /dev/sda
{% endhighlight %}

# Conclusão

Esse foi um tutorial bem básico de como deixar nossa **/home** criptografada no Linux. É de certo que alguma distribuição Linux pode ter suas particularidades e você tem que configurar algo a mais na mesma, porem o principio parte dessa lógica desse tutorial. Espero que você goste e principalmente que suas dúvidas foram eliminadas, mas caso não foi, deixe aqui um comentário informando suas dúvidas. Abraço.

