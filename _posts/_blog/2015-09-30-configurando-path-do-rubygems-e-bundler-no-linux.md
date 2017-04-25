---
layout: post
title: Configurando PATH do RubyGems e Bundler no Linux
date: 2015-09-30 16:02:37 -0300
comments: true
class: rubygems
tags: ["ruby","gems","linux", "bundler"]
excerpted: |
    Se você  necessita configurar o PATH do RubyGems para seu usuário, continue essa leitura e veja que um simples arquivo configurado pode facilitar as coisas para você.
day_quote:
    title: "A Palavra:"
    content: |
        "A pessoa que aceita e obedece aos meus mandamentos prova que me ama. E a pessoa que me ama será amado pelo meu Pai, e eu também a amarei e lhe mostrarei quem sou." <br>
        (João 14:21 NTLH)
categories: blog
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

## Requerimentos

O que você irá precisar para continuar com essa leitura:

| Requerido       | Como verificar      | Como instalar  |
| --------------- | ------------------- | -------------- | 
| Ruby            | `ruby -v`           | [Ruby](https://www.ruby-lang.org){:target="_blank"} |
| Gem             | `gem -v`            | **Ruby** contém **Gem** |
| Bundler         | `bundler -v`        | `gem install bundler` |

## Introdução

Se você  necessita configurar o do RubyGems para seu usuário, continue essa leitura e veja que alguns arquivos configurado pode facilitar as coisas para você.

Recentemente tive alguns encomodos de instalação de Gems(gemas) no meu Linux, e isso foi pelo fato de eu não ter uma configuração para a instalação de Gems adequada no meu usuário.

Instalar Gems no diretório **(/usr/lib/ruby)** utilizando root, futuramente essas Gems podem serem utilizadsa por todos usuários na sua máquina Linux, porém tem suas vantagens e desvantagens, isso vai depender da necessidde de cada um.

No meu caso, eu não queria ter que ficar colocando a senha no terminal toda vez que ao instalar as Gems através do [Bundler](https://bundler.io/){:target="_blank"} e (isso é muito pertubador (worry)), então resolvi pesquisar e driblar a utilização de senha. A saída é instalar as Gems no ambiente do seu usuário e não em **(/usr/lib/ruby)**, para isso precisa configurar o arquivo **~/.bashrc** no diretório do seu usuário, e o arquivo de configuração global do [Bundler](https://bundler.io/){:target="_blank"}.

## Mão na massa

Abra o arquivo **~/.bashrc** com um editor de texto preferencial e colocaque as seguintes linhas e salve.

{% highlight bash linenos %}
# RubyGems Path Config
GEM_PATH="$(ruby -e 'print Gem.user_dir')"
GEM_HOME="$GEM_PATH"
GEM_BIN="$GEM_PATH/bin"
export PATH=$PATH:$GEM_PATH:$GEM_HOME:$GEM_BIN
# Bundler Path Config
BUNDLE_PATH="$GEM_PATH"
BUNDLE_BIN="$GEM_PATH/bin"
export PATH=$PATH:$BUNDLE_PATH:$BUNDLE_BIN
{% endhighlight %}

Execute o comando abaixo para ver o diretório que será instalado as Gems a partir de agora:

{% highlight bash linenos %}
$ echo $GEM_PATH
{% endhighlight %}

> Nota: Observe que foi utilizado o mesmo PATH do RubyGems para o PATH do 
> Bundler. Irá entender isso adiante.

Pronto, os PATHS do RubyGems e Bundler aplicadas no **~/.bashrc**.
Fechar o terminal (caso esteja algum aberto), ou executar o comando abaixo para as configurações serem levantadas:

{% highlight bash linenos %}
$ source ~/.bashrc
{% endhighlight %}

Agora toda vem que for instalado uma Gem, através do gerenciador de pacote RubyGems (**gem install**), irá ser instalado no diretório **GEM_PATH**. 

Porem, as configurações realizadas no **~/.bashrc** irão servir no momento apenas para o gerenciador de pacotes RubyGems (**gem install**), enquanto as Gems são instaladas através do Bundler...

`bundle install`

...elas "Não" serão instaladas no diretório **GEM_PATH**. Para contornarmos isso, devemos criar (ou configurar) o arquivo de configuração global do próprio [Bundler](http://bundler.io/){:target="_blank"}. 

Para sabermos se existe um arquivo de configuração global do [Bundler](http://bundler.io/){:target="_blank"}, execute o comando abaixo no terminal e veja se a mesma existe:

{% highlight bash linenos %}
$ bundle config --global
{% endhighlight %}

Lembra que o PATH do Bundler que foi atribuido ao mesmo PATH para RubyGems? Pois bem, chegou de saber o porque.

> O [Bundler](http://bundler.io/){:target="_blank"} nada mais é que um 
> utilitário para instalar todas dependências de Gems do seu projeto através 
> do arquivo `Gemfile`. Com essa ideia, podemos pensar que o [Bundler](http://
> bundler.io/){:target="_blank"} é um "automatizador de instalação" de Gems. 
> Isso significa que o [Bundler](http://bundler.io/){:target="_blank"} 
> trabalha em cima do gerenciador de pacotes RubyGems. Se trabalha em cima do 
> RubyGems, devemos atribuir o mesmo PATH para ambos.

Agora vamos as configurações reais para o [Bundler](http://bundler.io/){:target="_blank"} instalar as Gems no mesmo PATH do RubyGems.

Execute as seguinte linhas de comando:

{% highlight bash linenos %}
$ bundle config --global PATH $BUNDLE_PATH
$ bundle config --global BIN $BUNDLE_BIN
{% endhighlight %}

Pronto, agora você pode instalar suas Gems através do RubyGems (**gem install**) e do **bundle install** sem se preocupar em inserir senha de superusuário.

Para ver mais detalhes sobre como está as configurações do `Gem Environment` na sua máquina, você pode executar o comando abaixo:

{% highlight bash linenos %}
$ gem env
{% endhighlight %}

Você também pode ver a documentação de configuração [Bundler](http://bundler.io/){:target="_blank"} [Aqui](http://bundler.io/v1.3/man/bundle-config.1.html){:target="_blank"}.

Fico por aqui, espero que esta postagem de alguma forma lhe sirva de ajuda. Obrigado por ler camarada.

{% endpost #636363 %}