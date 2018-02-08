---
layout: post
title: Carregando Javascripts para diferentes posts e pages no Jekyll
date: 2017-10-09 18:31:36
tags: ['jekyll','javascripts','liquid']
published: true
comments: true
excerpted: |
        Será que seu projeto em Jekyll está carregados códigos desnecessário?
        Esse post te ensinará como otimizar o carregamento de javascripts no projeto.
day_quote:
 title: "A Palavra:"
 description: |
          "Quem bebe demais fica barulhento e caçoa dos outros; o escravo da bebida nunca será sábio." <br> Provérbios 20:1 NTLH

# Does not change and does not remove 'script' variable.
script: [post.js]
---


Faaaala pessoa, tudo bem? Me desculpe pela demora de um novo post, mas é que tive alguns contratempos. Como diz o saudoso filósofo Serjão do Youtube:

> "E com fé no Pai Eterno sempre aqui estou vou estar tô ae firme pro meu
> berrante tocá".

:wink:

Deixando as desculpas de lado, vamos ao que interessa; o Post!

* Do not remove this line (it will not be displayed)
{: toc}

## Introdução

Essa é uma dica rápida pra você que utiliza [Jekyll](https://jekyllrb.com/){:target="_blank"} como gerador de sites estáticos.

Colocar seus códigos Javascript tudo em apenas um arquivo .js, não é tão recomendável assim, independente de utilizar geradores de sites estáticos ou não. Isso porque ao ser carregado pelo navegador, pode existir um trecho de código de uma determinada página, que não deveria ser carregado, assim irá carregar códigos extras sem necessidade.

A melhor forma de fazer isso, é cada página carregar seu próprio Javascript, isso irá otimizar muito a velocidade de carregamento seu website, caso possua uma gama de códigos javascript em seu carregamento.


## Requerimentos

O que você irá precisar para continuar com essa leitura:

| Requerido       | Como verificar      | Como instalar  |
| --------------- | ------------------- | -------------- |
| Ruby            | `ruby -v`           | [Ruby](https://www.ruby-lang.org){:target="_blank"} |
| Gem             | `gem -v`            | **Ruby** contém **Gem** |
| Jekyll         | `jekyll -v`        | `gem install jekyll` |

Instale conforme o seu sistema operacional.

## O laço 'For' no layout/default.html

Você pode fazer essa otimização de carregamento de javascripts com [Jekyll](https://jekyllrb.com/){:target="_blank"} de uma forma simples, usando um laço **for** no final do arquivo *layout/default.html*. Veja:

{% highlight html linenos %}
<!-- Specific for each pages. -->
{ % for script_page in page.script % }
   <script type="text/javascript" src="{ { '/assets/javascripts/' | prepend: site.baseurl | prepend: site.url  | append: script_page } }"></script>
{ % endfor % }
{% endhighlight %}

> NOTA: Sem espaços entre as chaves.

### Entendendo o 'For'

Observe que o diretório de meus javascripts está com PATH para */assets/javascripts/*, ou seja, você deve modificar esse PATH para o local onde esteja seus javascripts.

Na linha *{ % for script_page in page.script % }*, a variável **script_page** é responsável por amarzenar os valores do laço.
A variável **page** é uma variável padrão do Jekyll, que carrega os arquivos de posts e pages, e a variável **script** temos que criar nos arquivos de post e page.

## O arquivo de postagem

Como dito antes, temos que criar a variável de **script** dentro do cabeçalho de nossos arquivos de post e page. Dentro de um arquivo no diretório **_posts/mypost.md** por exemplo, adicionaremos:


{% highlight html linenos %}
# Does not change and does not remove 'script' variable.
script: [post.js]
{% endhighlight %}

Nesse casso, você deve colocar essa linha para todos arquivos dentro de **_posts** . Para os arquivos de páginas, você deve colocar também, porém deves mudar o nome do valor da variável **script** para **pages.js**, assim:

{% highlight html linenos %}
# Does not change and does not remove 'script' variable.
script: [pages.js]
{% endhighlight %}

### Exemplo para arquivos de posts

{% highlight text linenos %}
---
layout: post
title: My Post 1
date: 2017-05-09 18:31:36
# Does not change and does not remove 'script' variable.
script: [post.js]
---
{% endhighlight %}

### Exemplo para arquivos de pages

{% highlight text linenos %}
---
layout: page
title: My Page 1
date: 2017-05-09 18:31:36
# Does not change and does not remove 'script' variable.
script: [page1.js]
---
{% endhighlight %}


Nesse caso todos os posts irá carregar o código javascript contido no arquivo
**/assets/javascripts/post.js**, ou seja, será um arquivo global para todos os posts, mas você pode especificar um para cada post se quiser também. Os arquivos de páginas, segue o mesmo raciocínio. Nesse exemplo está carregando o
**/assets/javascripts/page1.js**, mas também pode ter um glogal para todas as páginas.


## Conclusão

Fazendo dessa forma, você tem maior controle de qual página ou qual post deve carregar um determinado javascript para si próprio. Otimização de código é um marco importante para um bom desenvolvedor. Eu fico por aqui, espero que você possa ter entendido como otimizar o carregamento de javascripts no [Jekyll](https://jekyllrb.com/){:target="_blank"}. Abraço pessoa, :punch:.

{% endpost #9D9D9D %}

{% jektify spotify/track/0QQIc8RRZADy75CjvBLsiZ/dark %}
