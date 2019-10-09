---
layout: post
title: Criando pendrive bootavel no Linux com dd
date: 2015-04-21 18:42:04 -0300
comments: true
tags: ["dd","linux","iso","pendrive"]
excerpted: |
   Não há nada mais precário que ficar comprando CD/DVD para gravar uma distribuição Linux, ou aquele outro sistema operacial no qual necessita de boot. Vamos aprenda a fazer isso no Linux com um comando poderoso.
day_quote:
    title: "A Palavra:"
    description: |
        "E nenhum de vocês pode encompridar a sua vida, por mais que se preocupe com isso." <br>
        (Mateus 6:27 NTLH)
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

Não há nada mais precário que ficar comprando CD/DVD para gravar uma distribuição Linux, ou aquele outro sistema operacial no qual necessita de boot. Vamos aprenda a fazer isso no Linux com um comando poderoso. :wink:

Já cansou de comprar CDs e DVDs para gravar aquela imagem ISO de um sistema operacional ou qualquer outro programa que necessite iniciar no boot de sua máquina? Creio que a resposta é Sim, e por isso existe programas para fazer um pendrive bootavel. Mas o que recém usuários Linux não sabe, é de um certo "malandro" que vem por padrão na maioria das distros, que pode fazer essa tarefa para você com uma simples linha de comando no terminal sem precisar instalar programas. Estou falando do camarada chamado **dd**. Com este brother aí, você pode fazer enumeras manipulações com imagem ISO e com unidades, porem, irei demonstrar como gravar uma imagem ISO no pendrive e o mesmo funcionar no boot de sua máquina(caso a imagem ISO seja bootavel). Separei 5 etapas importantes para fazer um pendrive bootavel. Siga abaixo:


* 1 - **Backup**
Primeiramente você tem que realizar um backup de seu pendrive caso tenha algo importante nele, pois ele terá que passar por uma formatação. Guarde tudo de importante pra você!

* 2 - **Requisitos**
Após realizar o backup de suas coisas, temos que verificar os programas que iremos utilizar, e esses são o **mkfs**(para a formatação do pendrive) e o **dd**(para a gravação da imagem ISO). Para verificar se os mesmo estão instalados na sua distro, use os seguintes comandos:
{% highlight bash  %}
mkfs --version
{% endhighlight %}
e
{% highlight bash  %}
dd --version
{% endhighlight %}

> Obs: Por padrão os dos programinhas já vem na maioria das distros.

* 3 - **Descobrir unidade do pendrive e seu ponto de montagem**

Se for realizar a formatação de qualquer dispositivo remóvel e partição no linux, o mesmo tem que estar desmontado. Se o pendrive montou e você quer saber onde ele foi montado, utilize o comando abaixo no terminal...

{% highlight bash  %}
mount
{% endhighlight %}

... irá retornar as todas unidade montadas em sua máquina e seus respectivos pontos de montagem. Veja como retornou em minha máquina:

{% gist a3672f19f0f2ac35810b %}

> NOTA: O comando "mount" pode retornar mais linhas, porem retirei boa parte
> para e deixei as principais.

Observe que meu pendrive está montado no diretório **/run/media/william/sandisk** e que sua partição/unidade para montagem é o **/dev/sdb**. Tendo essas informações você já pode desmontar e realizar a formatação da vítima hehehe.

* 4 - **Desmontar pendrive**

Para desmontar o querido pendrive, utilize o amigo **umount** e o ponto de montagem do pendrive que foi retornado no comando `mount`. Veja abaixo:

{% highlight bash  %}
umount /run/media/william/sandisk
{% endhighlight %}

* 5 - **Formatando pendrive**

Pendrive desmontado, vem a parte da formatação utilizando o **mkfs**. Veja e aprenda:
{% highlight bash %}
mkfs.vfat -I -n nome_para_o_pendrive /dev/sdb
{% endhighlight %}

Explicando:

> vfat: Significa que o pendrive será formatado para FAT.
> -I: Este é um parâmetro para indicar que seu pendrive seja reconhecido para o DOS.
> -n: Este outro parâmetro lhe da a oportunidade de colocar o nome no pendrive quando formatar.
> /dev/sdb: É a partição/unidade do pendrive que foi descoberta no comando mount.

* 6 - **Gravando ISO**
Pendrive formatado, iremos gravar a imagem ISO nele com o **dd**. Para gravar algo com o **dd**, o pendrive tem que estar **DESMONTADO** e estar utilizando o usuário **root** no terminal ou usar o **sudo**.
Suponhamos que a imagem ISO, está no diretório **Downloads**. Você pode entrar no diretório Downloads pelo terminal ou digitar o **Path** completo até chegar na imagem ISO, como eu fiz:

{% highlight bash  %}
sudo dd if=$HOME/Downloads/imagem.iso of=/dev/sdb
{% endhighlight %}

O atributo **if** será a verificação do **dd** para encontrar o arquivo gravável e jogar para o atributo **of**, que vai receber a unidade do pendrive, ou seja, local a ser gravado.

> Nota: Dependendo do tamanho da imagem ISO e da potência de sua máquina, o processo pode ser demorado. Não se assuste, pois o **dd** não mostra o que esta sendo gravado, vai dar impressão que está travado, mas não está. No final do processo, o **dd** informa o que que foi gravado.

Para saber mais sobre a documentação do **dd**, use os comandos no terminal:`man dd` e `dd --help`. Espero que você economize bastante CDs e DVDs agora ;)
Ate a próxima! Bye :hand:

{% endpost #9D9D9D %}

{% jektify spotify/track/0yhPEz5KxlDwckGJaMlZqM/dark %}
