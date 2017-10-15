---
layout: post
title: Carregando Javascripts para diferentes posts no Jekyll
date: 2017-05-09 18:31:36
categories: blog
tags: ['tag1','tag2','tag3']
published: false
comments: true
excerpted: |
          Put here your excerpt
day_quote:
 title: "Put here title quote of the day"
 content: |
          "Put here your quote of the day"

# Does not change and does not remove 'script' variable.
script: [post.js]
---


Faaaala pessoa, tudo bem? Me desculpe pela demora de um novo post, mas é que tive alguns contratempos. Como diz o saudoso filósofo Serjão:

> "E com fé no Pai Eterno sempre aqui estou vou estar tô ae firme pro meu 
> berrante tocá". 

HAHA

Deixando de conversa fiada, vamos ao que interessa; o Post!


## Introdução

Essa é uma dica rápida pra você que utiliza [Jekyll](https://jekyllrb.com/){:target="_blank"} como gerador de sites estáticos. 

Colocar seus códigos Javascript tudo em apenas um arquivo .js, não é tão recomendável assim, independente de seu utilizat geradores de sistes estáticos ou ou html puro. Isso porque ao ser carregado pelo navegador, pode existir um trecho de código de uma determinada página, que não deveria ser carregado, assim irá carregar códigos extras sem necessidade. Isso 

A melhor forma de fazer isso, é cada página carregar seu próprio Javascript, isso irá otimizar muito a velocidade de carregamento seu site caso possua uma gama de códigos Javascript em seu carregamento.


## Requerimentos

O que você irá precisar para continuar com essa leitura:

| Requerido       | Como verificar      | Como instalar  |
| --------------- | ------------------- | -------------- | 
| Ruby            | `ruby -v`           | [Ruby](https://www.ruby-lang.org){:target="_blank"} |
| Gem             | `gem -v`            | **Ruby** contém **Gem** |
| Jekyll         | `bundler -v`        | `gem install jekyll` |

## O laço For

Você pode fazer isso com Jekyll e uma forma simples, usando um laço **for** no final do arquivo *layout/defaul.html*.

{% highlight html linenos %}
<!-- Specific for each pages. -->
{ % for script_page in page.script % }
   <script type="text/javascript" src="{ { '/assets/javascripts/' | prepend: site.baseurl | prepend: site.url  | append: script_page } }"></script>
{ % endfor % }
{% endhighlight %}

> NOTA: Sem espaços entre as chaves. 

### Entendendo o laço

Observe que o diretório de meus javascripts está apontando para */assets/javascripts/*, ou seja, você deve modificar esse PATH para o local onde esteja seus javascripts.

Na linha *{ % for script_page in page.script % }* , a variável **script_page** é responsável por amarzenar os valores do laço.
O **page.script** é uma variável que deve ser criado no arquivo .md dos arquivos de post ou page no Jekyll.





