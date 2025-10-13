---
layout: post
title: "Counter-Strike:Global Offensive no Arch Linux"
description: "Configurando Arch Linux para jogar Counter-Strike:Global Offensive com nVIDIA"
author: "William Canin"
date: 2022-07-17 22:58:53 -0300
update_date: 2025-09-28 07:16:01 -0300
comments: true
tags: [nvidia,intel,csgo,game,archlinux,steam]
---

{% include toc selector=".post-content" max_level=3 title="TOC" btn_hidden="Esconder" btn_show="Mostrar" %}

# Introdução

Sempre realizei dual boot na minha máquina com **Windows** e **Linux**, para poder jogar decentemente [Counter-Strike:Global Offensive](https://store.steampowered.com/app/730/CounterStrike_Global_Offensive/){:target="_blank"}, isso porque o desempenho do jogo era muito nítido e melhor no **Windows** do que no **Linux**. Os problemas que eu tinha eram taxa de atualização de FPS e gargalos (stuttering).

Mesmo sabendo desses empecilhos eu não estava contente em ficar dual boot na máquina, isso porque eu tinha comprado um **SSD** e deixado meu **HDD** para dados (e todos sabemos que **SSD** é bem mais caro que **HDD**), com isso eu tinha pouco armazenamento e queria poupar espaço eliminando o Windows.

Esse dia chegou e finalmente eu fiquei só com [Arch Linux](https://archlinux.org/){:target="_blank"} na máquina, e as jornadas de desempenho ruins com [Counter-Strike:Global Offensive](https://store.steampowered.com/app/730/CounterStrike_Global_Offensive/){:target="_blank"} começaram, mas felizmente consegui resolver procurando por muitos dias soluções no [Github do CSGO](https://github.com/ValveSoftware/csgo-osx-linux/issues){:target="_blank"}, [Forum da nVIDIA](https://forums.developer.nvidia.com/){:target="_blank"}, vídeos no Youtube, e telegram do grupo [Arch Linux Brasil](https://t.me/archlinuxbr){:target="_blank"}. Vou deixar as fontes no final do post.

O *FPS* do "CS:GO" no meu hardware, realmente rodou melhor no **Windows**, tendo mais ganho. Usando o [FPS Benchmark](https://steamcommunity.com/sharedfiles/filedetails/?id=500334237){:target="_blank"}, teve uma diferença de 35 fps a mais para o **Windows** em comparação com o **Arch Linux**, porem isso não me incomodou porque o *FPS* estava acima da frequência máxima do meu monitor.

Hoje consumo jogos apenas da [Steam](https://store.steampowered.com/){:target="_blank"}, e jogos que não são compatível com Linux, enfio [Proton](https://en.wikipedia.org/wiki/Proton_(software)){:target="_blank"} neles hehe.

> Se você joga "CS:GO" em outros servidores que não seja da **ValvE**, tipo, [GamersClub](https://gamersclub.com.br){:target="_blank"}, [Faceit](https://faceit.com){:target="_blank"}, [Esea](https://play.esea.net/){:target="_blank"}, etc, você não irá conseguir jogar no **Linux** justamente porque essas plataformas não disponibilizam Anti-Cheat para **Linux** (pelo menos até a data desde post não), então, recomendo ficar com **Windows** no dual boot.

Antes de você achar que todos os problema de "**CS:GO**" e **Arch Linux** serão em "mil maravilhas" após realizar as etapas desse post, preciso lhe contar que nem tudo irá sair como "flores". Se você tiver problemas em questões de *FPS* e desempenho no **Windows**, então já é problema de hardware. No meu caso o **Counter-Strike:Global Offensive** estava com bom desempenho no **Windows** mas no **Arch Linux** não, o que me levou a pesquisar o motivo.


# Kernel

Vamos começar pelo núcleo, o kernel. Testei os 3 principais tipo de kernel disponível no repositório do **Arch Linux**, o **linux**, **linux-lts**, e **linux-zen**, e pra ser sincero não notei diferença entre eles, porem o **linux-zen** é um kernel mas