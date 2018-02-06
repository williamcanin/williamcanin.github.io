---
layout: post
title: "Linux Boot: A start job is running for dev-disk-by"
date: 2015-07-26 10:29:04 -0300
comments: true
tags: ["boot","swap","linux"]
excerpted: |
   Esperar hoje em dia não uma tarefa que agrada as pessoas, ainda mais se tratando de software.
day_quote:
    title: "A Palavra:"
    description: |
        "De tudo que foi dito, a conclusão é esta: tema a Deus e obedeça aos seus mandamentos porque foi para isso que fomos criados. Nós teremos de prestar contas a Deus de tudo o que fizemos e até daquilo que fizermos em segredo, seja bem ou o mal." <br>
        (Eclesiastes 12:13-14 NTLH)
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

## Introdução

Esperar hoje em dia não é uma tarefa que agrada as pessoas, ainda mais se tratando de software.
Pois bem, essa postagem vai te informar uma configuração errada que pode te deixar de "cabelos em pé" :triumph: e esperando meados 1m30s para o Linux sair do boot.

Muitas pessoas se preocupam muito com boot da máquina, até mesmo a Microsoft, que devo adimitir: "*Fizeram um ótimo trabalho no Windows 8/10 se comparando com o Windows 7 na inicialização do boot*". Mas vamos falar de Linux aqui, ok?!

Existem vários fatores para seu Linux demorar no boot, por exemplo:

* A grande quantidade de software e pacotes que se inicializa junta com o sistema...
* ... a falta de otimização do kernel deixando o boot sobrecarregado de modulos não utilizados...
* ... e até mesmo uma falta de reconhecimento de partição. Bingo! É disso que irei falar aqui: *Partição com erro de reconhecimento*.

## Entendendo a mensagem

> **A start job is running for dev-disk-by(...)**

Para o português: **Um trabalho inicial está sendo executado para dev-disk-by(...)**.

Essa mensagem é acompanhada com um monte de letras e números onde está (...). As letras e números representam um UUID de uma determinada partição que está com problema para ser reconhecida, ou seja, você irá encontrar algo parecido como isso:

{% highlight bash linenos %}
A start job is running for dev-disk-by\x2duuid-4aed3ea2\x2d5d85\x2d4bc2\x2d96e2\x2dabc6ad877640.device (44s / 1min 30s)
{% endhighlight %}

A única diferença, é que os números e letras irá mudar no seu caso, porém, vai ser exatamente parecido com isso, com uma contagem crescente no final e demorada, e enjoativa :sweat: .

## Decifrando a numeração

Se você observou bem a estrutura da numeração da mensagem, vai perceber que não são todos os números e letras que representa o UUID da partição.

Observe o conteúdo de todas essas letras e numeros do UUID:

{% highlight bash linenos %}
 \x2duuid-4aed3ea2\x2d5d85\x2d4bc2\x2d96e2\x2dabc6ad877640.device
{% endhighlight %}

Repare que o **"x2d"** está sendo repetido em cada bloco, e se você eliminar o **"x2d"**, deixando a estrutura assim:

{% highlight bash linenos %}
 \uuid-4aed3ea2\5d85\4bc2\96e2\abc6ad877640.device
{% endhighlight %}

> Elimine o "\uuid".

Se observa agora que com a eliminação dos **"x2d"**, você terá o UUID separado por casas através de barras, só que por padrão, as casas do UUID nas partições, é separado por "traços", dessa forma:

{% highlight bash linenos %}
4aed3ea2-5d85-4bc2-96e2-abc6ad877640
{% endhighlight %}

Pronto! Numeração do UUID decifrada. Esse pode ser o "danado" que causa problema de inicialiação.

*Mas como saber que esse UUID dessa partição existe ou não?*

A primeira coisa a se fazer é listar os UUID das partição que você tem em sua máquina, com o comando **lsblk -f**. Assim:

## Listando os UUID das partições

{% highlight bash linenos %}
$ lsblk -f
{% endhighlight %}

{% gist 24d4d0247fd1530a5db8 %}

Repare na saída, não tem nenhum UUID igual ao decifrado
(**4aed3ea2-5d85-4bc2-96e2-abc6ad877640**).

*Aí tu se pergunta:*

*Mas por que no boot ele está sendo mostrado?*

Para ter essa resposta, dê uma olhada no arquivo **/etc/fstab**.

> Obs: O **/etc/fstab** é responsável por iniciar(ou não) as partições e
> outros dispositivos na inicialização durante o boot.

## Verificando o /etc/fstab

{% highlight bash linenos %}
$ cat /etc/fstab
{% endhighlight %}

{% gist 05f78da4153625ad9d12 %}

Xeque-Mate! Repare que o **4aed3ea2-5d85-4bc2-96e2-abc6ad877640**, está configurado para a partição SWAP, porém na saída do comando **lsblk -f**, o UUID do SWAP não é este que está no arquivo **/etc/fstab**.

Por isso que o boot da máquina pode estar demorando, por tentar reconhecer a partição SWAP sendo que o UUID da mesma não estava configurado corretamente no arquivo **/etc/fstab**.

Agora coloque o UUID verdadeiro da partição swap no **/etc/fstab**, deixando assim:

{% highlight bash linenos %}
UUID=035b2802-752a-45b6-a87c-c4d466cdf53d none            swap    sw              0       0
{% endhighlight %}

No próximo boot, a mensagem **A start job is running for dev-disk-by()**  
não irá te encomodar mais.

## Dica

**Tirando o Splash do Ubuntu**

Se você usa Ubuntu (ou até mesmo outras que tenha Splash na inicialização), por padrão, não irá mostrar o que esta sendo inicializado (modo verbose). Caso queira desabilitar o Splash de boot do Ubuntu (15.04). Faça:

Abra o arquivo **/etc/default/grub** com um editor preferido.

{% highlight bash linenos %}
$ nano /etc/default/grub
{% endhighlight %}

Altere a linha ...

{% highlight bash linenos %}
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
{% endhighlight %}

... para

{% highlight bash linenos %}
GRUB_CMDLINE_LINUX_DEFAULT="quiet"
{% endhighlight %}

e salve e execute o comando abaixo:

{% highlight bash linenos %}
$ sudo update-grub
{% endhighlight %}

Na próxima inicialização do Ubuntu ele irá mostrar tudo que esta sendo carregado (modo verbose). Caso queira voltar como estava, faça o inverso, acrescente a palavra "splash" e atualize o Grub novamente.

> Nota: Agora, se não quer dar o trabalho de fazer a configuração no Grub,
> simplesmente aperte a tecla F11 quando o Splash do Ubuntu aparecer, que
> verá o modo verbose do mesmo jeito.


## Conclusão

*Por que isso acontece?*   
No meu caso, eu tinha instalado outra distribuição Linux e configurado a minha SWAP para essa outra distro, o que resultou na mudança de UUID. Fique esperto em fazer essas configurações também.

Espero que esse tutorial possa te ajudar se tiver esse problema. Até a próxima galera! :)


{% endpost #9D9D9D %}

{% jektify spotify/track/00bHVjPL7arXz9W59VKo5m/dark %}
