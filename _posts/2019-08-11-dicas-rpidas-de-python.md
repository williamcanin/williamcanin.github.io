---
layout: post
title: "Dicas rápidas de Python"
date: 2019-08-11 16:58:27
tags: ['python','dicas']
published: false
comments: false
excerpted: |
          Put here your excerpt
day_quote:
 title: "Put here title quote of the day"
 description: |
          "Put here your quote of the day"

# Does not change and does not remove 'script' variable.
script: [post.js]
---

<!-- Write from here your post !!! -->

# Atualizando todas as bibliotecas instaladas com o Pip

{% highlight bash linenos %}
pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
{% endhighlight %}

Caso queira atualizar localmente (maquina virtual python), use o comando abaixo:

{% highlight bash linenos %}
pip freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install -U
{% endhighlight %}

# Transformar os valores de variáveis de um arquivo shellscript em dicionário Python

Suponha que você tenha dentro do arquivo `variaveis.sh` as seguintes variáveis:

{% highlight bash linenos %}
NAME="Maquina01"
ID="MAQ 15478"
VERSION=08
{% endhighlight %}

Agora terá que ler o arquivo `variaveis.sh` para assim realizar a conversão dos dados para dicionário em Python:

arq = open("variaveis.sh", 'r')
dados = arq.read()
resul = dict([ i.split('=') for i in dados.strip().split('\n')])
print(resul['NAME'])
print( resul['ID'])
print(resul['VERSION'])
