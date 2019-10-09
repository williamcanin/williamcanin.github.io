---
layout: postlist
order: 1
title: Blog
posts_quantity:
  message: ['No total, são','post(s) separados por páginas.']
# Use icons of: https://fontawesome.com/icons
# E.g: fa-briefcase
icon: fa-edit
menu:
  enable: true
  local: [default, blog]
pagination:
  enabled: true
script: [postlist.js]
# NOTE: If you disable blog posting, you'll have to 
#       disable tags.md, feed.md and search.md too.
published: true
permalink: /blog/ # add permilink for page. E.g: /smallparty/
---

<!-- Do not delete this file! Put your text below. -->

{% include liquid/data %}

O que se segue neste weblog é uma lista de postagens desde {{ load_data.website.launch }}. Cada postagem tem seu próprio personagem, já que foram escritos com muitos dias de intervalo. Sinta-se à vontade para fazer quaisquer pensamento que você possa ter. Espero que contemple.