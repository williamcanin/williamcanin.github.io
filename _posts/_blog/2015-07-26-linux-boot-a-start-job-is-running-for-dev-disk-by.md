---
layout: post
title: "Linux Boot: A start job is running for dev-disk-by"
date: 2015-07-26 10:29:04 -0300
comments: true
class: linux
tags: ["boot","swap","linux"]
excerpted: |
   Esperar hoje em dia não uma tarefa que agrada as pessoas, ainda mais se tratando de software.
day_quote:
    title: "A Palavra:"
    content: |
        "De tudo que foi dito, a conclusão é esta: tema a Deus e obedeça aos seus mandamentos porque foi para isso que fomos criados. Nós teremos de prestar contas a Deus de tudo o que fizemos e até daquilo que fizermos em segredo, seja bem ou o mal." <br>
        (Eclesiastes 12:13-14 NTLH)
categories: blog
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

Esperar hoje em dia não uma tarefa que agrada as pessoas, ainda mais se tratando de software.
Pois bem, essa postagem vai te informar uma configuração errada que pode te deixar de cabelos em pé :triumph: e esperando meados 1m 30s para o Linux dar o boot.

Vamos entrar em uma concordância: Não há nada mais chato que você ligar sua querida máquina, que contem o seu querido Linux, passando por uma terminável demora de boot, não é mesmo? Pois bem, se você concorda, esse artigo pode ser a saída para seu problema.

Muitas pessoas se preocupam muito com boot da máquina, até mesmo a Microsoft, que devo adimitir: "*Fizeram um ótimo trabalho no Windows 8 se comparando com o Windows 7 na inicialização do boot*". Mas vamos falar de Linux aqui, ok?!

Existem vários fatores para seu Linux demorar no boot, por exemplo: A grande quantidade de software e pacotes que se inicializa junta com o sistema, a falta de otimização do kernel (está sendo explicado no próximo post) deixando o boot sobrecarregado de modulos não utilizados e até mesmo uma falta de reconhecimento de partição. Bingo! É disso que irei falar aqui: *Partição com erro de reconhecimento*.

> **A start job is running for dev-disk-by(...)**

Para o português: **Um trabalho inicial está sendo executado para dev-disk-by(...)**.

Uma mensagem de boot que pode te irritar, fazendo seu Linux demorar para iniciar. Mas acalme-se! Já passei por isso, o que é bom para você, porque irei dizer a solução.

Essa mensagem é acompanhada com um monte de letras e numeros onde está (...), essas letras e numeros representam um UUID de uma determinada partição que está com problema para ser reconhecida, ou seja, você irá encontrar algo parecido como isso:

> **A start job is running for dev-disk-by\x2duuid-4aed3ea2\x2d5d85\x2d4bc2\x2d96e2\x2dabc6ad877640.device (44s / 1min 30s)**

A única diferença, é que os numeros e letras irá mudar no seu caso, mas irá ser exatamente parecido com isso, com uma contagem crescente no final e ligeramente demorada se realmente existir uma falha de carregamento da partição.

# Iniciando a correção

Esses numeros e letras representam o UUID da partição que esta sendo carregada no boot, ou seja, se estiver demorando para terminar esse processo, pode desconfiar, pois, um problema de inicialização nessa partição pode existir. Mas não são todos os numeros e letras que representa o UUID da partição. Então fiz o seguinte:

Observe o conteudo de todas essas letras e numeros do UUID:

```
> \x2duuid-4aed3ea2\x2d5d85\x2d4bc2\x2d96e2\x2dabc6ad877640.device
```

Repare que o "x2d" está sendo repetido em cada bloco, ele não interessa, então eliminei os "x2d", deixando assim:

```
> \uuid-4aed3ea2\5d85\4bc2\96e2\abc6ad877640.device
```

Enfim, consegui observar que eu tinha o seguinte UUID separado por casas com a barra, só que as casas do UUID das partições por padrão, é separado por "traços", ficando dessa forma:

```
> 4aed3ea2-5d85-4bc2-96e2-abc6ad877640
```

Esse é o "danado" que pode estar com problema de inicialiação. Mas como eu soube que esse UUID dessa partição existia ou não? A primeira coisa que fiz foi listar os UUID das partição que eu tinha em minha máquina, com o comando **lsblk -f**. Me retornando assim:

## Listando os UUID das partições

Comando:
{% highlight bash linenos %}
$ lsblk -f
{% endhighlight %}

{% gist 24d4d0247fd1530a5db8 %}

Reparei na saída, não tinha nenhum UUID igual o **4aed3ea2-5d85-4bc2-96e2-abc6ad877640**.
Aí me perguntei: Mas por que no boot ele está sendo mostrado?
E me respondi: Vou dar uma observada no arquivo **fstab** (/etc/fstab).

> Obs: O **fstab** é responsável por iniciar(ou não) as partições na inicialização durante o boot.

## Verifiquei o **fstab**

Comando:
{% highlight bash linenos %}
$ cat /etc/fstab
{% endhighlight %}

{% gist 05f78da4153625ad9d12 %}

Xeque-Mate! Reparei que o **4aed3ea2-5d85-4bc2-96e2-abc6ad877640**, está configurado para a minha partição SWAP, porem na saída do comando **lsblk -f**, o UUID do SWAP não é este que está no arquivo **fstab**.

Por isso que meu boot estava demorando, estava tentando reconhecer a partição SWAP sendo que o UUID da mesma não estava configurado corretamente no arquivo **/etc/fstab**.

Então o que fiz? Coloquei o UUID verdadeiro da partição swap no **fstab**, deixando assim:

```
UUID=035b2802-752a-45b6-a87c-c4d466cdf53d none            swap    sw              0       0
```


No próximo boot, a mensagem **A start job is running for dev-disk-by\x2duuid-4aed3ea2\x2d5d85\x2d4bc2\x2d96e2\x2dabc6ad877640.device (44s / 1min 30s)** que retardava a inicialização do sistema, desapareceu, "tomou doril", móóórreu.


## Causas do problema

No meu caso, eu tinha instalado outra distribuição linux e configurado a minha swap para essas outra distro, o que resultou na mudança de UUID. Fique de olho nessas mudanças!


## Dica - Tirando o Splash do Ubuntu

Se você usa Ubuntu(ou até mesmo outras que tenha Splash na inicialização), por padrão, ele apresenta um Splash em vez de mostrar o que esta sendo inicializado(modo verbose). Caso queira desabilitar o Splash de boot do Ubuntu (15.04), faça:

Abra o arquivo **/etc/default/grub** com um editor preferido (usei o nano).

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

e salve.

Rode o comando...

{% highlight bash linenos %}
$ sudo update-grub
{% endhighlight %}

... e na próxima inicialização do Ubuntu ele irá mostrar tudo que esta sendo carregado (modo verbose). Caso queira voltar como estava, faça o inverso, acrescente a palavra "splash" e atualizando o Grub. 

Nota: 

>  Agora, se você não quer dar o trabalho de fazer a configuração do Splash, 
>  simplesmente aperte a tecla F11 quando o Splash do Ubuntu aparecer, que verá o modo 
>  verbose.


---

Espero que esse meu relato possa ajuda-lo se você teve esse mesmo problema. Até a próxima! :)












