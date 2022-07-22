---
layout: post
title: Bloqueando módulos durante o boot com o Modbl
category: blog
date: 2015-09-30 13:55:19 -0300
comments: true
tags: ["modprobe","boot","linux","shell","script"]
excerpted: |
   Essa é uma postagem que irá facilitar e otimizar seus comandos no terminal para bloquear módulos no Linux. Estou falando do Modbl, um script simples mas que lhe propoe um ganha tempo.
day_quote:
    title: "A Palavra:"
    description: |
        "A pessoa que aceita e obedece aos meus mandamentos prova que me ama. E a pessoa que me ama será amado pelo meu Pai, e eu também a amarei e lhe mostrarei quem sou." <br>
        (João 14:21 NTLH)
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

Essa é uma postagem que irá facilitar e otimizar seus comandos no terminal para bloquear módulos no Linux. Estou falando do [Modbl](https://github.com/williamcanin/modbl){:target="_blank"}, um script simples mas que lhe propoe um ganha tempo.

Se você habilita ou desabilita módulos de sua máquina durante o boot frequentemente no Linux, você precisa fazer isso de uma forma que lhe dê menos trabalho e mais praticidade. Pensando nisso, desenvolvi um simples script em Shell **(Modbl)**, que lhe possibilita esses recursos.

O **Modbl** (uma abreviação de ModBlackList), você faz adição e remoção desses módulos com apenas uma linha de comando no terminal, não vai ter o trabalho de criar e abrir um arquivo em **"/etc/modprobe.d"** manualmente e inseriando módulos.

Se você quer mais informações sobre o **"Modbl"** explicando como instalar e o seu funcionamento, pode acessá-lo no meu GitHub clicando [AQUI](https://github.com/williamcanin/modbl){:target="_blank"}, se quer apesar visualizar a ideia do script, veja o código fonte abaixo.

Código fonte:

{% gist e3768a9398370bb80fa8 %}

Você pode sugerir novas ideias acessando [Issues](https://github.com/williamcanin/modbl/issues){:target="_blank"}, vou estar atento a quanto isso. Espero que esse código lhe ajude. Obrigado pela leitura.

{% endpost #9D9D9D %}

{% jektify spotify/track/2zfFLgnzc9PspmqKMODS2g/dark %}
