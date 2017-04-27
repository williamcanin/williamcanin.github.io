---
layout: post
title: Configurando PATH do RubyGems e Bundler no Linux
date: 2017-01-12 16:02:37 -0300
comments: true
class: rubygems
tags: ["ruby","gems","linux", "bundler"]
excerpted: |
    Se você  necessita configurar o PATH do RubyGems e do Bundler para seu usuário, continue essa leitura e veja que um simples arquivo configurado pode facilitar as coisas para você.
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

 Se você  necessita configurar o PATH do RubyGems e do Bundler para seu usuário, continue essa leitura e veja que um simples arquivo configurado pode facilitar as coisas para você.
 
[RubyGems](https://pt.wikipedia.org/wiki/RubyGems){:target="_blank"} é um gerenciador de pacotes do Ruby, e para utiliza-lo você precisa instalar o Ruby que já contem o mesmo. Ele é responsável por instalar Gems (bibliotecas ou programas) em nossa máquina que servirão de base (ou não) para projetos em que criamos ou projetos que utilizamos. 

Para instalar ou gerenciar pacotes com RubyGems, você pode usar o comando abaixo para um `help`.

{% highlight bash linenos %}
$ gem --help
{% endhighlight %}

Quando instalamos as Gems através do gerenciador **gem**, as mesmas são instaladas no diretório do usuário, porem ainda precisa configurar o reconhecimento de PATH, e isso é feito através do arquivo **~/.bashrc**, que veremos mais adiante.

O [Bundler](https://bundler.io/){:target="_blank"} também é um gerenciador de Gems e trabalha em cima do RubyGems, porem de uma forma mais conjulgal, isso porque ele utiliza um arquivo chamado `Gemfile` para alocar todas Gems que necessitamos em nossos projetos, assim, não precisamos instalar Gems uma à uma com o gerenciador RubyGems. Assim como o RubyGems, também é necessário configurar o PATH para o Bundler no **~/.bashrc** e no próprio arquivo de configuração contido no diretório raiz do usuário, o **~/.bundle/config**. Esse arquivo de configuração do Bundler é global, ou seja, todas as Gems instaladas com o Bundler, serão instaladas no diretório de acordo com que está no arquivo **~/.bundle/config**, a menos que, o seu projeto contenha um arquivo de configuração local. Exemplo: **myproject/.bundle/config**. Nesse caso as Gems seriam instaladas no local do projeto.

## Instalando Ruby e Bundler

Para instalar o Ruby no Linux e o gerenciador de pacotes RubyGems, você pode olhar a pŕópria documentação do Ruby [AQUI](https://www.ruby-lang.org/pt/documentation/installation/#package-management-systems){:target="_blank"}.

A instalação do Bundler, é através do gerenciador RubyGems, então para isso simplesmente execute o comando abaixo:

{% highlight bash linenos %}
$ gem install bundler
{% endhighlight %}

## Configurando PATH do RubyGems e Bundler no "~/.bashrc".

Depois da instalação do Ruby e Bundler, devemos configurar o PATH de ambos, para isso, precisamos editar o arquivo **~/.bashrc**, então abra o arquivo com um editor de sua preferência e adicione as seguintes linhas no mesmo:

{% highlight bash linenos %}
# RubyGems Path Config
GEM_PATH="$(ruby -e 'print "#{Gem.user_dir}"')"
GEM_HOME="$GEM_PATH"
GEM_BIN="$GEM_PATH/bin"
export PATH=$PATH:$GEM_PATH:$GEM_HOME:$GEM_BIN
# Bundler Path Config
BUNDLE_PATH="$HOME/.gem/bundle"
BUNDLE_HOME="$BUNDLE_PATH"
BUNDLE_BIN="$BUNDLE_PATH/bin"
export PATH=$PATH:$BUNDLE_PATH:$BUNDLE_HOME:$BUNDLE_BIN
{% endhighlight %}

Pronto, acabamos de informar o PATH para RubyGems e o Bundler em nosso **~/.bashrc**, porem, para que as configurações sejam levantadas, é necessário executar o comando abaixo:

{% highlight bash linenos %}
$ source ~/.bashrc
{% endhighlight %}

Ok! Agora as configurações de PATH estão atribuídas. Execute o comando abaixo para ver o diretório que será instalado as Gems a partir do gerenciador RubyGems e do Bundler:

{% highlight bash linenos %}
$ echo $GEM_PATH; echo $BUNDLE_PATH
{% endhighlight %}

## Configurando o Bundler no "~/.bundle/config".

Como dito antes, o arquivo de configuração global do Bundler, é o **"~/.bundle/config"**, nele você pode configurar como o Bundler irá se comportar.
Mas aqui, vamos configurar somente o diretório onde nossas Gems irão ser instaladas e o diretório *bin* das mesmas. 

Para isso, execute os comando abaixo:

{% highlight bash linenos %}
$ bundle config --global PATH $BUNDLE_PATH
$ bundle config --global BIN $BUNDLE_BIN
$ bundle config --global DISABLE_SHARED_GEMS true
{% endhighlight %}

Na `linha 1` atribuimos o PATH, o local raiz onde nossas Gems global irá ser instaladas.   
Na `linha 2` atribuimos o PATH para os executáveis das Gems.   
Na `linha 3` é opcional, onde desabilitamos o compartilhamento de Gems.

*Um exemplo*: Agora, todas as Gems que forem instaladas através do `bundle install`, serão instaladas nesses PATH's e apenas gerenciadas pelo Bundler (através ou não do arquivo *Gemfile* contendo essas Gems do seu projeto).

Também, algo legal é que não há encomodo em senha de superusuário para instalar Gems com Bundler. Algo que poderia acontecer se não configuracemos o local das Gems no **~/.bundle/config**.

## Conclusão

As Gems no PATH do Bundler poderão ser executadas somente através do próprio Bundler, com o comando `bundle exec <name_gem>`. Isso é uma forma de consistência para que seus projetos sempre executem a versão adequada contida no arquivo `Gemfile`.

Para ver mais detalhes sobre como está as configurações do `Gem Environment` na sua máquina, você pode executar o comando abaixo:

{% highlight bash linenos %}
$ gem env
{% endhighlight %}

Apenas compartilher algo básico de como configurar e usar o Ruby, RubyGems e Bundler, existe muito mais na documentação de ambos, o que pode lhe servir o que deseja:

* [Ruby Doc](https://www.ruby-lang.org/pt/documentation/){:target="_blank"}
* [RubyGems Doc](http://guides.rubygems.org/rubygems-basics/){:target="_blank"}
* [Bundler Doc](https://bundler.io/docs.html){:target="_blank"}

Finalizo por aqui, espero que estas linhas de alguma forma lhe sirva de ajuda. Obrigado por ler.
