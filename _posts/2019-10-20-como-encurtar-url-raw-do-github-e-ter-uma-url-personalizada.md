---
layout: post
title: "Como encurtar URL Raw do Github e ter uma url personalizada"
description: |
  Cansado de compartilhar URL Raw do Github compridas? Lendo essa postagem você vai contornar isso.
author: "William C. Canin"
date: 2019-10-20 13:49:01 -0300
update_date:
comments: true
tags: [github,git,url,shortener]
---


Olá, tudo joinha? nesse post vou demonstrar como você pode deixar as urls RAW no [**Github**](https://github.com){:target="_blank"} bem mais encurtadas e eficientes. Vamos lá.

Primeiro você precisa do [**curl**](https://curl.haxx.se/){:target="_blank"} na sua máquina, pois vamos precisar dele para realizar uma façanha. _

>  Nota: _O [**curl**](https://curl.haxx.se/){:target="_blank"} está disponível praticamente em todos sistemas operacionais. Sinta-se a vontade para instalar o mesmo da maneira que mais lhe convém.

Agora precisamos usar o serviço de encurtamento de url que a própria [**Github**](https://github.com){:target="_blank"} fornece, que é o [**Git.io**](https://git.io){:target="_blank"}. Se você encurtar suas URL's através do site, a URL encurtada terá um **code** de "*sopa de letrinhas*" automaticamente escolhida pelo serviço. Por exemplo:

```shell
git.io/abcdef123456
```

**Como faço para ter uma url personalizada com o git.io?**

*Essa é uma pergunta muito fácil, mande outra mais difícil*.

Ta bem, eu respondo... a resposta é: **curl**! No qual foi requisitado acima. Ele quem faz esse trabalho.

A sintaxe para o encurtamento de URL com nome personalizável é:

{% highlight bash  %}
$ curl -i https://git.io -F "url=**URL_ORIGINAL_RAW**" -F "code=**NOME_DESEJADO**"
{% endhighlight %}

- Onde em **URL_ORIGINAL_RAW** você deve colocar a URL original Raw completa, incluindo o http ou https.

- Onde em **NOME_DESEJADO** você deve escolher um nome/código para sua URL.

>  Nota: Em **NOME_DESEJADO**, o mesmo deve ser único, ou seja, você tem que escolher um nome/código que ninguem escolheu ainda. Para saber disso, simplesmente execute o comando, e veja se na saída obteve sucesso, ou não.

Vamos a um exemplo:

**Exemplo de encurtamento:**

{% highlight bash  %}
$ curl -i https://git.io -F "url=https://raw.githubusercontent.com/my_user/my_project/master/scriptizinho.py" -F "code=**scriptizinho**"
{% endhighlight %}

**Exemplo de saída do encurtamento:**

{% highlight bash linenos %}
HTTP/1.1 201 Created
Server: Cowboy
Connection: keep-alive
Date: Sun, 20 Oct 2019 14:20:01 GMT
Status: 201 Created
Content-Type: text/html;charset=utf-8
Location: https://git.io/scriptizinho
Content-Length: 94
X-Xss-Protection: 1; mode=block
X-Content-Type-Options: nosniff
X-Frame-Options: SAMEORIGIN
X-Runtime: 0.009777
X-Node: 836916c6-b665-4105-9926-2f6f6c1d3cc4
X-Revision: 392798d237fc1aa5cd55cada10d2945773e741a8
Strict-Transport-Security: max-age=31536000; includeSubDomains
Via: 1.1 vegur

https://raw.githubusercontent.com/my_user/my_project/master/scriptizinho.py
{% endhighlight %}

Caso de tudo certo, você terá uma saída parecida com essa acima, onde já na primeira linha o resultado é **Created**. Em **Location**, você pode ver sua **nova** URL personalizada.

```shell
https://git.io/scriptizinho
```

Você também pode ignorar a url personalizada e deixar que o serviço escolha um **code** automaticamente para você, para isso remova a opção **-F "code="** do comando.

Exemplo:

{% highlight bash  %}
$ curl -i https://git.io -F "url=https://raw.githubusercontent.com/my_user/my_project/master/scriptizinho.py"
{% endhighlight %}

Saida do comando:

```shell
HTTP/1.1 201 Created
...
Location: https://git.io/dfsds4r
...
```

Eu fico por aqui, espero que eu tenha te ajudado. Abraços
