---
layout: post
title: Última versão do kernel linux através de um script
date: 2017-05-04 23:16:57
categories: blog
tags: ['shell-script','kernel','download', 'linux']
published: true
comments: true
excerpted: |
    Dica rápida - Download da última versão estável do Kernel Linux através de um Shell script. Ideal para quem está somente com um sistema "cru".
day_quote:
 title: "A Palavra: "
 content: |
    "Filho meu, guarda o mandamento de, teu pai, e não abandones a instrução de tua mãe; ata-os perpetuamente ao teu coração, e pendura-os ao teu pescoço. Quando caminhares, isso te guiará, quando te deitares, te guardará; quando acordares, falará contigo. Porque o mandamento é uma lâmpada, e a instrução uma luz; e as repreensões da disciplina são o caminho da vida, para te guardarem da mulher má e das lisonjas da língua da adúltera." <br> (Provérbios 6:20-24)

# Does not change and does not remove 'script' variable.
script: [post.js, ga_event.js]
---


Iae terráqueos, firmeza total? Espero que sim. 

Vou compartilhar com vocês um Shell script simples, mas que pode ser de bastante utilidade dependendo do caso. Esse script fará o download da última versão estável do [kernel](https://www.kernel.org/){:target="_blank"} Linux.

Ai tu se pergunta: 

*Mas porque raios eu deveria ter um script para realizar o donwload do kernel, se eu posso ir diretamente no navegador e baixar?*

Simples, talves você esteja usando uma distribuição como servidor (ou não) sem interface gráfica e necessita compilar o kernel. Nesse caso vai ser você e a "telinha preta" de amiguinhos. :smile:


Enfim ...

1) Crie um arquivo vazio:

{% highlight bash linenos %}
touch kerneldown
{% endhighlight %}

2) Abra esse arquivo vazio com um editor preferencial e copie o conteúdo abaixo do script:

{% highlight bash linenos %}
#!/bin/bash

# Type: Shell Script
# Description: Download latest version stable kernel Linux.
# Program Name: kerneldown
# Release Status: 0.0.1

# Author: William C. Canin
#   E-Mail: william.costa.canin@gmail.com
#   WebSite: http://williamcanin.github.io
#   GitHub: https://github.com/williamcanin

# Copyright © 2017 William C. Canin

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

# Dependencies:
  # curl, wget

# Usage:
  # bash kerneldown



#  Begin

# Variables global
CWD="$HOME/kernel"

# require Curl and WGet.
type curl >/dev/null 2>&1 || {
    echo >&2 "I require curl but it's not installed. Aborting."
    exit 0
}
type wget >/dev/null 2>&1 || {
    echo >&2 "I require wget but it's not installed. Aborting."
    exit 0
}

# Function download latest kernel (https://www.kernel.org/)
function _download_lastet_kernel()
  {

    # Prepare base download
   [ ! -d "$CWD" ] && mkdir $CWD && cd $CWD || cd $CWD

    printf "\n$(tput setaf 38)→ Downloading the latest version of Kernel. Wait ...$(tput sgr0)\n"

    # Capture latest version stable kernel
    latest_stable="$(curl -s https://www.kernel.org/releases.json | grep "version" | cut -d":" -f2 | cut -d"\"" -f2 | sed '2,900d')"

    # Capture full url package kernel
    url_source="$(echo https:$(curl -s https://www.kernel.org/releases.json | grep "source" | grep "${latest_stable}" | cut -d":" -f3 | cut -d"\"" -f1))"

    # Start download kernel
    wget -c $url_source

    # Message finish
    printf "\n$(tput setaf 76)✔ Download completed! Finished in: \"$CWD\"$(tput sgr0)\n"

}

# Start function '_download_lastet_kernel'
_download_lastet_kernel

# End
{% endhighlight %}


3) Dê permissão de execução para esse script:

{% highlight bash linenos %}
chmod +x kerneldown
{% endhighlight %}


Pronto! Execute o script para realizar o download do Kernel Linux.

**Dica:**

Você pode copiar esse script para o **/usr/bin**, assim você pode executar o mesmo em qualquer PATH do sistema operacional.

Eu fico por aqui, espero que gostem. Abraços! 

{% endpost #9D9D9D %}

{% spotify spotify/track/7kIunRqo3botlYCadX0IRM %}
