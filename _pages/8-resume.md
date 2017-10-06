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
**Naturalidade:** Santo André/SP   
**Data Nasc.**: 25/04/1988   
**Estado Civil**: Solteiro   
<!-- **Filhos?** Não    -->
<!-- **Fumante?** Não    -->
<!-- **Endereço**: Rua, Floriano Peixoto, 1255 / Centro    -->
<!-- **CEP**: 16440-000    -->
<!-- **Cidade**: Sabino/SP    -->
**País**: Brasil   
**Fone:** +55 14 99795-9006   
**E-mail**: [{{ dbase.userdata.email }}](mailto:{{ dbase.userdata.email | encode_email }})   
**Website**: [https://williamcanin.me](http://williamcanin.github.io){:target="_blank"}   

<!-- ## Pretensão salarial -->

<!-- A Combinar -->

<!-- ## Objetico -->

<!-- Area de TI / Informática -->

## Biografia

Apaixonado por desafios, tecnologia, design, pessoas e melhoramento pessoal; onde tenho a convicção de que tudo é possível com dedicação e resiliência.

Sou graduado da [Centro Universitário de Lins](http://www.unilins.edu.br/){:target="_blank"} e codificador assíduo com comprometimento com as atividades que realizo. Autodidata e proficiente em algumas [linguagens de programação](#habilidades) e tarefas voltadas a computação. 

Diarimente, gosto de aprender novas linguagens de programação, onde as uso (ou não) regularmente. Eu aprendi a programar usando [Free Pascal](http://www.freepascal.org/){:target="_blank"} e [Delphi](https://www.embarcadero.com/products/delphi){:target="_blank"}, durante o período de faculdade.

Atualmente exerço mais o desenvolvimento Web ([Front-End](#front-end)), porém, também tenho facilidades em alguns desenvolvimento [Back-End](#back-end), ou seja, me considerando um desenvolvedor full-stack. Se tratando de [redes](#redes), me adaptei com os servidores Linux; no qual os conheço por usar o
sistema diariamente baseado no mesmo. Sou um defensor do código `open source`. Em questão de ferramentas fora do ciclo de programação, pode-se encontrar na seção de [Conhecimentos / Habilidades](#conhecimentos--habilidades) em [outras ferramentas](#outras-ferramentas).

No ano de 2008, conheci o Linux, e atualmente faz parte de minha máquina como Sistema Operacional principal, através da distribuição [Fedora](https://getfedora.org/pt_BR/){:target="_blank"}. Em todos esses anos de usuário, adquiri alguns conhecimentos em [Linux LPI](#linux-lpi).

Tenho uma [página na internet]({{ site.url }}{{ site.baseurl }}){:target="_blank"}, onde mantenho tudo sobre mim e meus conhecimentos com meu [weblog](https://williamcanin.me/blog/){:target="_blank"}.

## Educação

### Centro Universitário de Lins (Unilins)

*Lins, São Paulo - Curso Superior em Análise e Desenvolvimento de Sistemas*

Encetei na faculdade no ano de 2009, onde estudei grades como: *UML, Delphi, Java, Banco de Dados(Oracle)* e pouco de *Web Design*. Na conclusão de curso, foi realizado um sistema ERP (Beta) para uma loja de eletrodomésticos local. A jornada durou 4 anos, onde obtive a conclusão no final do ano 2013.


## Experiências

#### Linux LPI

**Linux Essentials - Conhecimentos básicos em open source e nas diferenças entre as várias distribuições Linux**

**LPIC-1 101 - Execução de tarefas de manutenção com a linha de comando, instalação e configuração de um computador rodando Linux e configuração  básica de rede**

* Arquitetura do Sistema
* Instalação e manutenção de pacotes linux
* Comandos GNU e Unix
* Devices, Linux Filesystems, Hieraquia Padrão dos Filesystem

**LPIC-1 102 - Execução de tarefas de manutenção com a linha de comando, instalação e configuração de um computador rodando Linux e configuração  básica de rede**

* Shell, Scripting e Gerenciamento de Dados
* Interfaces e Desktops
* Tarefas administrativas
* Serviços Essenciais do sistema

## Conhecimentos / Habilidades

Com o termino do *Curso Superior em Análise e Desenvolvimento de Sistemas*, no decorrer do tempo fui adquirindo novos conhecimentos em diversas linguagens de programação e softwares.

#### **Front-End:**

{% label HTML|16px %}
{% label Bootstrap|16px %}
{% label CSS3|16px %}
{% label JQuery|16px %}

#### **Back-End:**

{% label Ruby|16px %}
{% label UNIX / GNU via Bash|16px %}
{% label Delphi|16px %}

#### **Banco de Dados:**

{% label MySQL|16px %}
{% label Firebird|16px %}

#### **Automatizadores:**

{% label Git|16px %}
{% label Jekyll|16px %}
{% label Gulp|16px %}
{% label SASS|16px %}

#### **Metodologias:**

{% label Design Responsivo (Mobile First)|16px %}
{% label UML|16px %}
{% label OOP|16px %}
{% label PL/SQL|16px %}


#### **Redes:**

{% label Ubuntu Server|16px %}
{% label Red Hat Enterprise Linux Server|16px %}
{% label TCP/IP|16px %}
{% label IPTables|16px %}
{% label Squid|16px %}

#### **Sistemas Operacionais:**

{% label Linux|16px %}
{% label Windows|16px %}

#### **Outras ferramentas:**

{% label Gimp|16px %}
{% label Adobe Photoshop|16px %}
{% label LibreOffice|16px %}
{% label Microsoft Office|16px %}


## Projetos

Realiazo diversos projetos Open-Source e armazeno tudo com [git](https://git-scm.com/){:target="_blank"} no meu [GitHub](https://github.com/williamcanin){:target="_blank"}. Aqui está alguns:

* [Jekyll Spotify Plugin](http://williamcanin.github.io/jekyll-spotify-plugin){:target="_blank"} - Jekyll plug-in para gerar fragmentos de código HTML para incorporar música do Spotify em templates Jekyll.
* [Recover Grub](https://github.com/williamcanin/recover-grub){:target="_blank"} - Script via Shell para realizar a recuperação do Grub no Arch Linux.
* [iDisconnect ](http://williamcanin.github.io/idisconnect){:target="_blank"} - Um programa para Windows, com funções de agendar o desligamento, reinicialização e hibernação do computador.

Para ver todos meus projetos, acesse: [https://williamcanin.me/projects](https://williamcanin.me/projects/){:target="_blank"}.

<!-- ## Informações adicionais -->

<!-- CNH - AB -->

