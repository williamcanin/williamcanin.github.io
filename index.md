---
layout: hello
title: whoami
script: [hello.js]
---


{% assign age = site.time | date: '%Y' | minus: 1988 %}

Hey, guy! Bem-vindo à casa de Internet de William Canin. (Este sou eu!)

Me considero um desenvolvedor assíduo e autodidata. Eu escrevo ocasionalmente no meu [weblog]({{site.url}}{{site.baseurl}}/blog/).

Confira meu último post, {% for last_post in site.posts limit:1 %}
"<a href="{{site.url}}{{site.baseurl}}{{last_post.url}}">{{last_post.title}}</a>". {% endfor %}

Meu sistema operacional é Linux, através da distribuição [Archlinux](https://archlinux.org){:target="_blank"} / [Ubuntu](https://www.ubuntu.com/){:target="_blank"}.

Tenho uma relação de amor e "ódio" com a maioria das linguagens de programação, mas eu encontrei casas felizes em [Python](https://python.org/){:target="_blank"}, Shell script, [Ruby](https://www.ruby-lang.org){:target="_blank"}, e Frontend.

Você pode ver uma lista de meus projetos na minha página do [GitHub](https://github.com/williamcanin){:target="_blank"}. É provável que alguns esteja `out-of-date` e eu deveria corrigir isso... Algum dia.

Mais alguma coisa...? Oh, sim, aqui estão os demais lugares na internet que você pode me encontrar e descobrir alguns enigmas:

<!-- Add class 'markdown__listhome' for float: left -->

<!-- {: .markdown__listhome} -->
 [LinkedIn](https://www.linkedin.com/in/williamcostacanin/){:target="_blank"} |
 [GitHub](https://github.com/williamcanin){:target="_blank"} |
 [GitLab](https://gitlab.com/williamcanin){:target="_blank"} |
 [VivaOLinux](https://www.vivaolinux.com.br/~willnux){:target="_blank"} |
 [Archlinux - Fórum BR](https://forum.archlinux-br.org/profile.php?id=5539){:target="_blank"} |
 [StackOverflow](https://pt.stackoverflow.com/users/15113/williamcanin?tab=profile){:target="_blank"} |
 [Disqus](https://disqus.com/by/williamcanin/){:target="_blank"} |
 [Spotify](https://open.spotify.com/user/williamcanin){:target="_blank"} |
 <span style="color: red;">Facebook Error 404</span> | <span style="color: red;">Instagram Error 404</span>

<!-- *"O tolo não se interessa em aprender, mas só em dar as suas opiniões." [ Provébios 18:2 ]* -->
