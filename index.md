---
layout: home
text_center: true
published: true
permalink: / # do not change
---

{% assign age = site.time | date: '%Y' | minus: 1988 %}

**Hey, guy!**

Bem-vindo à casa de Internet de "William Canin". (Este sou eu!)

Me considero um praticante autodidata de algumas ferramentas de desenvolvimento/programação. Eu escrevo ocasionalmente no meu [weblog]({{site.url}}{{site.baseurl}}/blog/).

Confira meu último post, {% for last_post in site.posts limit:1 %}
"<a href="{{site.url}}{{site.baseurl}}{{last_post.url}}">{{last_post.title}}</a>". {% endfor %}

Meu sistema operacional é Linux, através da distribuição [Arch Linux](https://github.com/williamcanin/my-archlinux/blob/main/README.md){:target="_blank"}, porem, já provei o sabor de outras.

Tenho uma relação de idas e vindas com a maioria das linguagens de programação, mas eu encontrei casas felizes em [Python](https://python.org/){:target="_blank"} e [Rust](https://www.rust-lang.org/){:target="_blank"}.

Você pode ver uma lista de meus [projetos](https://github.com/williamcanin){:target="_blank"} na minha página do GitHub. É provável que alguns esteja `out-of-date` e eu deveria corrigir isso...algum dia talvez.

<!-- Mais alguma coisa...? Oh sim, se você quer saber minhas redes sociais ATIVAS, apenas digite o comando "**socials**" aqui. Até breve. -->
