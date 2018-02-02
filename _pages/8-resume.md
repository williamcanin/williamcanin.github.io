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
      id: "#conhecimentos--habilidades"
    - name: Projetos
      id: "#projetos"

published: true

# Does not change and does not remove 'script' variables
script: [resume.js]

permalink: /resume/
---

{% include dbase/dbase %}

#  William da Costa Canin
### Desenvolvedor

<br>

## Dados Pessoais

**Nacionalidade**: Brasileiro   
**Naturalidade:** Santo André/SP   
**Data Nasc.**: 25/04/1988   
<!-- **Estado Civil**: Solteiro    -->
<!-- **Filhos?** Não    -->
<!-- **Fumante?** Não    -->
<!-- **Endereço**: Rua, Floriano Peixoto, 1255 / Centro    -->
<!-- **CEP**: 16440-000    -->
<!-- **Cidade**: Sabino/SP    -->
**País**: Brasil   
<!-- **Fone:** +55 14 99795-9006    -->
**E-mail**: [{{ dbase.userdata.email }}](mailto:{{ dbase.userdata.email | encode_email }})   
**Website**: [https://williamcanin.me](http://williamcanin.github.io){:target="_blank"}   

<!-- ## Pretensão salarial -->

<!-- A Combinar -->

<!-- ## Objetico -->

<!-- Area de TI / Informática -->

## Biografia

Apaixonado por desafios, tecnologia, design, pessoas e melhoramento pessoal; onde tenho a convicção de que tudo é possível com dedicação e resiliência.

Sou graduado da [Centro Universitário de Lins](http://www.unilins.edu.br/){:target="_blank"} e codificador assíduo com comprometimento com as atividades que realizo. Autodidata e proficiente em algumas [linguagens de programação e tarefas voltadas a computação](#conhecimentos--habilidades).

Diariamente, gosto de aprender novas linguagens de programação, onde as uso (ou não) regularmente. Eu aprendi a programar usando [Free Pascal](http://www.freepascal.org/){:target="_blank"} e [Delphi](https://www.embarcadero.com/products/delphi){:target="_blank"}, durante o período no ensino superior.

Atualmente exerço mais o aprendizado de "Web development" ([Front-End](#front-end)), porém, também tenho facilidades em alguns desenvolvimento com [Back-End](#back-end), ou seja, me considerando com aptdão a full-stack.

Sou um defensor do código `open source` desde 2008 quando conheci o Linux, e atualmente faz parte de minha máquina como Sistema Operacional principal, através da distribuição [Fedora](https://getfedora.org/pt_BR/){:target="_blank"}. Desde então, vou adquiri alguns conhecimentos em [Network](#networks) e [Linux LPI](#linux-lpi).

Tenho uma [página na internet]({{ site.url }}{{ site.baseurl }}){:target="_blank"}, onde mantenho tudo sobre mim e meus conhecimentos com meu [weblog](https://williamcanin.me/blog/){:target="_blank"}. Me considero leigo em tudo, e é por isso que me motiva estudar sempre.

## Educação

### Centro Universitário de Lins (Unilins)

*Lins, São Paulo - Curso Superior em Análise e Desenvolvimento de Sistemas*

Encetei na faculdade no ano de 2009, onde estudei grades como: *UML, Delphi, Java, Banco de Dados(Oracle)* e *Web development*. Na conclusão de curso, foi realizado um sistema ERP não aplicável para uma loja de eletrodomésticos local usando [Delphi](https://www.embarcadero.com/products/delphi){:target="_blank"}. A jornada durou 4 anos, onde obtive a conclusão do curso no final do ano 2013.


## Experiências

#### Linux LPI

**Linux Essentials - Conhecimentos básicos em open source e nas diferenças entre as várias distribuições Linux**

**Execução de tarefas de manutenção com a linha de comando, instalação e configuração de um computador rodando Linux e configuração  básica de rede**

**LPIC-1 101**

* Arquitetura do Sistema
* Instalação e manutenção de pacotes linux
* Comandos GNU e Unix
* Devices, Linux Filesystems, Hieraquia Padrão dos Filesystem

**LPIC-1 102**

* Shell, Scripting e Gerenciamento de Dados
* Interfaces e Desktops
* Tarefas administrativas
* Serviços Essenciais do sistema

## Conhecimentos / Habilidades

Com o termino do *Curso Superior em Análise e Desenvolvimento de Sistemas*, no decorrer do tempo fui adquirindo novos conhecimentos em diversas áreas:

#### **Front end**

{% label HTML5|16px %}
{% label CSS3|16px %}
{% label Bootstrap|16px %}
{% label Javascript/ES6|16px %}
{% label Responsive Web Design|16px %}
{% label BEM|16px %}
{% label SASS|16px %}
{% label Gulp|16px %}
{% label NPM|16px %}

#### **Back end**

{% label Ruby/RubyGems|16px %}
{% label Shell|16px %}
{% label Delphi|16px %}

#### **Version Control System**

{% label Git|16px %}

#### **SSG**

{% label Jekyll|16px %}

#### **Graphics**

{% label Gimp|16px %}
{% label Inkscape|16px %}
{% label Adobe Photoshop|16px %}

#### **Databases**

{% label MySQL|16px %}
{% label Firebird|16px %}

#### **Networks**

{% label Ubuntu Server|16px %}
{% label Red Hat Enterprise Linux Server|16px %}
{% label TCP/IP|16px %}
{% label IPTables|16px %}
{% label Squid|16px %}

#### **Operational systems**

{% label Linux|16px %}
{% label Windows|16px %}

## Certificados

* [NodeStudio - HTML5 & CSS3](https://www.nodestudio.com.br/certificado/58780178){:target="_blank"}
* [NodeStudio - Design Responsivo](https://www.nodestudio.com.br/certificado/58780174){:target="_blank"}

## Projetos

Realiazo diversos projetos Open-Source e armazeno tudo com [git](https://git-scm.com/){:target="_blank"} no meu [GitHub](https://github.com/williamcanin){:target="_blank"}. Aqui está alguns:

* [Recover Grub](https://github.com/williamcanin/recover-grub){:target="_blank"} - Script via Shell para realizar a recuperação do Grub no Arch Linux.
* [iDisconnect ](http://williamcanin.github.io/idisconnect){:target="_blank"} - Um programa para Windows, com funções de agendar o desligamento, reinicialização e hibernação do computador.

<!-- ## Informações adicionais -->

<!-- CNH - AB -->
