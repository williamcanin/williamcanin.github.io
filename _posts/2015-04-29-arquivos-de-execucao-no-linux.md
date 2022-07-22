---
layout: post
title: Arquivos de execução no Linux
category: blog
date: 2015-04-29 12:29:32 -0300
comments: true
tags: ["linux","shell","script"]
excerpted: |
    Essa postagem você irá entender melhor como são os arquivos executáveis no Linux, como se cria um com código aberto ou fechado, como dar permissão no Linux para um executável ter a permissão de execução e outras informações considerável.
day_quote:
    title: "A Palavra:"
    description: |
        "E a paz de Deus, que ninguém consegue entender, guardará o coração e a mente de vocês, pois vocês estão unidos com Cristo Jesus." <br>
        (Filipenses 4:6-7 NTLH)
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---


## Introdução

Essa postagem você irá entender melhor como são os arquivos executáveis no Linux, como se cria um com código aberto ou fechado, como dar permissão no Linux para um executável ter a permissão de execução e outras informações considerável.

Bem, la vem eu novamente a dizer sobre Linux(me amarro!)...porem o tema agora será sobre arquivos de execução.
Arquivos de execução no Linux pode ser criado de diversas formas, por exemplo, um arquivo de texto com a extensão **.sh** e com comandos shell(ou não) em seu conteúdo, já pode ser chamado de um arquivo de execução, que tem como tipo **application/x-shellscript**(script do shell).
Alem dos scripts executáveis(script do shell), existe outro tipo de arquivo de execução no Linux que vou dizer aqui, se trata do **application/x-executable**, que, diferente dos scripts executáveis, não dá pra ver seu conteúdo de código, que é uma atenção redobrada que tem que ter, pois pode conter qualquer tipo de código em seu interior.
Diferente dos scripts executaveis(**application/x-shellscript**), os arquivos de execução do tipo **application/x-executable** só podem ser criados com o auxilio de uma linguagem de programação, como por exemplo a Linguagem C.
Agora que já fiz um resumo básico sobre esses dois tipos arquivos de execução, vamos ir no ponto da prática.

# Application/x-shellscript

Para criar um `script executável`(**application/x-shellscript**), não precisa necessariamente colocar a extensão **.sh** no final do arquivo.
Acrescentando a linha...

{% highlight bash  %}
#!/bin/bash
{% endhighlight %}

... na primeira linha no arquivo, ele já se tornará um **application/x-shellscript**, lhe poupando de colocar a extensão **.sh** no final do arquivo.Isso porque, o Linux faz uma leitura dessa linha, e interpreta que o arquivo irá ser executado pelo **bash** do Linux, porem existe uma pequena barreira para o **application/x-shellscript** realmente executar, vamos entender essa "barreira":

Toda vez que é criado um arquivo do tipo **application/x-shellscript** no Linux, nenhum usuário tem a permissão de executa-lo após sua criação, isso é uma segurança do sistema GNU/Linux, ou seja, nada no Linux é auto-executável, diferentemente do Windows que o auto-executável é bem comum, e consequência disso pode ser um vírus, já que os vírus adoram dar um de auto-executável no sistema do titio *Gates*.
Voltando ao foco...para executar um **application/x-shellscript**, terá que atribuir a permissão de execução manualmente via comando terminal, fazendo isso, o Linux reconhecerá o **application/x-shellscript**, como um arquivo de execução de "confiança". Para atribuir essa permissão após a sua criação, faça:

{% highlight bash  %}
$ chmod -x seu_script
{% endhighlight %}

O comando **chmod** no Linux, tem um responsabilidade de configurar, atribuir, remover..etc, permissões de arquivos e pastas no sistema.

Um exemplo de **application/x-shellscript**, é:

{% highlight bash  %}
#!/bin/bash

if [ ! -e "./file.txt" ]; then(
    touch file.txt
)else(
    echo "O Arquivo ja existe!"
)fi
{% endhighlight %}

Repare que a primeira linha está configurada para ser um **application/x-shellscript**. Com isso, pode salvar o arquivo sem nenhuma extensão, dar a permissão de execução, e executá-lo com o comando abaixo no terminal para ver sua ação:

{% highlight bash  %}
$ sh seu_script
{% endhighlight %}

> O script irá criar um arquivo chamado **file.txt**, caso tente rodar o script novamente e o arquivo já existe, irá retornar uma mensagem.

# Application/x-executable

Suponho que esteja curioso(a) para criar um arquivo do tipo **application/x-executable** em seu Linux, correto? Vamos la então...

Primeiramente, se você deseja criar arquivos do tipo **application/x-executable**, vai ter que se submeter ao entendimento de alguma linguagem de programação para a criação desse tipo de executável. Na maioria das distros Linux, por padrão, já vem uma linguagem que faz esse serviço, é a linguagem C.

> Se você não tem domínio sobre a linguagem C, existem outras linguagem que
> também faz um **application/x-executable**, como por exemplo o: C++, Pascal/
> Lazarus e outros mais.

* 1 - Abra um editor de texto de sua preferencia, recomendo o [Sublime Text](http://www.sublimetext.com/){:target="_blank"}.

> Nota: Não esqueça de mudar a "syntax" no editor de texto para a linguagem C.

Adicione as seguinte linhas:

{% highlight c  %}
#include <stdio.h>

int main(){
    puts("Meu primeiro script em C");
    return 0;
}
{% endhighlight %}

* 2 - Salve o arquivo com um nome qualquer mais com a extensão **.c**. Abra o terminal no diretório onde o script esteja, e execute o seguinte comando:

{% highlight bash  %}
$ gcc -o myprog nome_script.c
{% endhighlight %}

O **gcc** é um compilador de scripts para a linguagem C, e com essa linha de comando, o compilador está criando um arquivo do tipo **application/x-executable** através do script em C.
Para executar o arquivo do tipo **application/x-executable**, faça assim no terminal:

{% highlight bash  %}
$ ./myprog
{% endhighlight %}

Este arquivo do tipo **application/x-executable**, vai retornar a seguinte mensagem no terminal: `Meu primeiro script em C`.

> Nota: Lembrando que um arquivo do tipo **application/x-executable**, não precisa ser necessariamente executado no terminal, dependendo de seu conteúdo e qual linguagem foi compilado, com um duplo clique ele já entrará em ação.


Se você chegou até aqui, então é hora de eu me despedir :(
Espero que você tenha entendido um pouco sobre arquivos **application/x-shellscript** e **application/x-executable** no Linux.
Até a próxima!

{% endpost #9D9D9D %}

{% jektify spotify/track/5vS7DxElLuVKeZxfXf4lfZ/dark %}
