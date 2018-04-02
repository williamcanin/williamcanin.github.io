---
layout: hello
title: William Canin
script: [hello.js]
---


{% assign age = site.time | date: '%Y' | minus: 1988 %}

Hey, guy! Bem-vindo à casa de Internet de William Canin. (Este sou eu!)

Me considero um desenvolvedor assíduo e autodidata. Eu escrevo ocasionalmente no meu [weblog]({{site.url}}{{site.baseurl}}/blog/).

Confira meu último post, {% for last_post in site.posts limit:1 %}
"<a href="{{site.url}}{{site.baseurl}}{{last_post.url}}">{{last_post.title}}</a>". {% endfor %}

Meu sistema operativo favorito para ambiente de trabalho é Linux.

Tenho uma relação de amor e "ódio" com a maioria das linguagens de programação, mas eu encontrei casas felizes em Ruby, Shell e Front end.

Você pode ver uma lista de meus projetos na minha página do [GitHub](https://github.com/williamcanin){:target="_blank"}. É provável que alguns esteja `out-of-date` e eu deveria corrigir isso... Algum dia.

Mais alguma coisa...? Oh, sim, aqui estão os demais lugares na internet que você pode me encontrar e descobrir alguns enigmas:

* [GitHub](https://github.com/williamcanin){:target="_blank"}
* [Google Plus](https://plus.google.com/+WilliamCanin){:target="_blank"}
* [VivaOLinux](https://www.vivaolinux.com.br/~willnux){:target="_blank"}
