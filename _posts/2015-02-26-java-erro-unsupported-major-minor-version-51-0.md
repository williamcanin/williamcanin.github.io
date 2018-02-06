---
layout: post
title: "Java - Erro: Unsupported major.minor version 51.0"
date: 2015-02-26 18:07:00 -0300
comments: true
tags: ["java","major","unsupported"]
excerpted: |
    Este é a correção de um Erro no Java, ou melhor, um erro humano, pois esse erro só é dispertado se você realizar a execução de um programa em Java que não suporta a versão no qual o programa foi compilado.
day_quote:
    title: "A Palavra:"
    description: |
        "Preocupações roubam a felicidade da gente, mas as palavras amáveis nos alegram." <br>
        (Provérbios 12:25 NTLH)
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

Este é a correção de um Erro no Java, ou melhor, um erro humano, pois esse erro só é dispertado se você realizar a execução de um programa em Java que não suporta a versão no qual o programa foi compilado.

Provavelmente muitos que desenvolvem com Java já passaram por erros, uns sabem como resolver e outros não sabem pelo fato de se depararem pela primeira vez com o tal erro.

Um erro comum, é o **Unsupported major.minor version 51.0**. Este erro, expecifica que você está tentando executar o seu programa com uma versão de Java que não suporta a versão em que o código foi compilado. Então, basicamente, você deve ter compilado o
código com uma versão superior e tentar executá-lo usando uma versão inferior.

Como você está recebendo...

`Unsupported major.minor version 51.0`

...isso significa que a "version 51.0" corresponde a J2SE 7 você provavelmente compilado seu código em Java 7 e tentar executá-lo usando uma versão inferior. Confira o que o comando `java -version` em seu terminal/console lhe retorna.
Deve ser a versão do Java 7. Ou fazer as alterações necessárias no PATH "/JAVA_HOME".
Ou você pode compilar com a mesma versão que você está tentando executar o código.

No linux, se as configurações estão confundindo você, sempre pode dar absoluto caminho no path onde se encontra o JAVA.

Exemplo:

/home/user/jdk1.7.0_11/bin/javac

/home/user/jdk1.7.0_11/bin/java.

{% endpost #9D9D9D %}

{% jektify spotify/track/2T79cwJ9xFcBC7vwH2xniy/dark %}
