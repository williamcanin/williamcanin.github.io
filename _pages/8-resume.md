---
layout: resume
title: Currículo
sitemap:
  priority: 0.7
  changefreq: 'monthly'
  lastmod: 2017-05-04T12:49:30-05:00

# Enable / Disable events Google Analytics for this link page.
ga_event: true

# Icon feature uses Font Awesome
icon: fa-file-text-o
icon-size: inherit

# Enable / Disable this page in the main menu.
menu: true

# Enable / Disable button for print resume.
btnprint: true

excerpt: |
    Este é o resumo de minhas realizações. Pode ser imprimido usando o atalho do navegador (Ctrl + P) ou usando o botão 'Imprimir'.

tcontents:
  enable: true
  title: Índice
  links:
    - name: Dados Pessoais
      id: "#dados-pessoais"
    - name: Biografia
      id: "#biografia"
    - name: Objetivo
      id: "#objetivo"      
    - name: Educação
      id: "#educação"
    - name: Habilidades
      id: "#habilidades"
    - name: Projetos
      id: "#projetos"

published: true

# Does not change and does not remove 'script' variables
script: [resume.js]

permalink: /resume/
---

{% include dbase/dbase %}

#  William da Costa Canin
### Analista e Desenvolvedor de Sistemas

<br>

## Dados Pessoais

**Nacionalidade**: Brasileiro   
**Data Nasc.**: 25/04/1988  
**Estado Civil**: Solteiro   
**País**: Brasil   
**Província**: Lins/SP   
**E-mail**: [{{ dbase.userdata.email }}](mailto:{{ dbase.userdata.email | encode_email }})   
**Website**: [{{ site.url }}{{ site.baseurl }}]({{ site.url }}{{ site.baseurl }}){:target="_blank"}   


## Biografia

Sou graduado da [Centro Universitário de Lins](http://www.unilins.edu.br/){:target="_blank"} e codificador assíduo com comprometimento com as atividades que realizo. Autodidata e proficiente em [linguagens de programação](#habilidades) e tarefas voltadas a computação.

Diarimente, gosto de aprender novas linguagens de programação, onde as uso (ou não) regularmente. Eu aprendi a programar usando [Free Pascal](http://www.freepascal.org/){:target="_blank"} e [Delphi](https://www.embarcadero.com/products/delphi){:target="_blank"}, então eu diria que conheço bem suas lógicas. 

Hoje estou mais para desenvolvimento Web ([Front-End](#front-end)), porém, sempre utilizo desenvolvimento [Back-End](#back-end).  Sou um defensor do código `open source`. Em questão de ferramentas fora do ciclo de programação, pode-se encontrar na seção de [habilidades](#habilidades) em [outras ferramentas](#outras-ferramentas).

No ano de 2008, conheci o Linux, e atualmente faz parte de minha máquina como Sistema Operacional principal, através da distribuição [Arch Linux](https://www.archlinux.org/){:target="_blank"}.

Tenho uma [página na internet]({{ site.url }}{{ site.baseurl }}){:target="_blank"}, onde mantenho tudo sobre mim e meus conhecimentos com meu [weblog]({{ site.url }}{{ site.baseurl }}/blog/){:target="_blank"}.

## Objetivo

Encargo na área de TI.

## Educação

### Centro Universitário de Lins (Unilins)

*Lins, São Paulo - Análise e Desenvolvimento de Sistemas*

Encetei na faculdade no ano de 2009, onde estudei grades como: *UML, Delphi, Java, Banco de Dados* e pouco de *Web Design*. Na conclusão de curso, foi realizado um sistema ERP (Beta) para uma loja de eletrodomésticos local. A jornada durou 4 anos, onde obtive a conclusão no final do ano 2013.

## Habilidades

Com o termino do *Curso Superior em Análise e Desenvolvimento de Sistemas*, no decorrer do tempo fui adquirindo novas habilidades em diversas linguagens de programação e softwares.

#### **Front-End:**

{% label HTML|16px %}
{% label Bootstrap|16px %}
{% label CSS3|16px %}
{% label JQuery|16px %}

#### **Back-End:**

{% label Ruby|16px %}
{% label UNIX / GNU via Bash|16px %}
{% label Delphi|16px %}
{% label Java|16px %}

#### **Automatizadores:**

{% label Git|16px %}
{% label Jekyll|16px %}
{% label Gulp|16px %}
{% label SASS|16px %}

#### **Metodologias:**

{% label UML|16px %}
{% label OOP|16px %}
{% label PL/SQL|16px %}


#### **Redes:**

{% label IPTables|16px %}
{% label Squid|16px %}

#### **S.O:**

{% label Linux|16px %}
{% label Windows|16px %}

#### **Outras ferramentas:**

{% label Gimp|16px %}
{% label Adobe Photoshop|16px %}
{% label Sony Vegas|16px %}
{% label LibreOffice|16px %}
{% label Microsoft Office|16px %}


## Projetos

Realiazo diversos projetos Open-Source diariamente e armazeno tudo com [git](https://git-scm.com/){:target="_blank"} no meu [GitHub](https://github.com/williamcanin){:target="_blank"}. Aqui está alguns:

* [Jekyll Spotify Plugin](http://williamcanin.github.io/jekyll-spotify-plugin){:target="_blank"} - Jekyll plug-in para gerar fragmentos de código HTML para incorporar música do Spotify em templates Jekyll.
* [Recover Grub](https://github.com/williamcanin/recover-grub){:target="_blank"} - Script via Shell para realizar a recuperação do Grub no Arch Linux.
* [iDisconnect ](http://williamcanin.github.io/idisconnect){:target="_blank"} - Um programa para Windows, com funções de agendar o desligamento, reinicialização e hibernação do computador.

Para ver todos meus projetos, acesse: [{{site.url}}{{site.baseurl}}/projects/]({{site.url}}{{site.baseurl}}/projects/){:target="_blank"}.