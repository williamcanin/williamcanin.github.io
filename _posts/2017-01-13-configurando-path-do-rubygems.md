---
layout: post
title: Configurando PATH do RubyGems e Bundler no Linux
category: blog
date: 2017-01-13 16:02:37 -0300
comments: false
tags: ["ruby","gems","linux", "bundler"]
excerpted: |
    Se você  necessita configurar o PATH do RubyGems e do Bundler para seu usuário, veja alguns simples arquivos configurado pode facilitar as coisas para você.
day_quote:
    title: "A Palavra:"
    description: |
        "A pessoa que aceita e obedece aos meus mandamentos prova que me ama. E a pessoa que me ama será amado pelo meu Pai, e eu também a amarei e lhe mostrarei quem sou." <br>
        (João 14:21 NTLH)
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

* indice
{: toc}


# Introdução

Nesse tutorial será realizado uma série de abstrações das estrutura de pasta do RubyGems e do Bundler no ato de uma instalação de gem. Para isso, é importante que você faça o backup de gems instaladas na pasta **~/.gem**, pois a mesma será altamente altera e removida. Também da pasta **~/bin** (caso ela existir) e dos arquivos **~/.gemrc** e **~/.bundle/config**.

# Limpando no ambiente de trabalho

Vamos limpar tudo que está realacionado no diretório onde as gems são instaladas e suas configurações com o comando abaixo:

{% highlight shell  %}
$ rm -rf ~/.gem ~/.bundle ~/.gemrc
{% endhighlight %}

# Requerimentos

| Requerido       | Versão      |  Como verificar    | Como instalar  |
| --------------- | ------------|------------------- | -------------- |
| Fedora          | 27          | lsb_release -a \| grep Release | [Fedora Download](https://getfedora.org/){:target="_blank"}    |
| Ruby            | 2.4.3p205   | `ruby -v`          | [Ruby](https://www.ruby-lang.org){:target="_blank"} |
| Gem             | 2.6.14      | `gem -v`           | **Ruby** contém **Gem** |

> Nota: Foi usado a distribuição Linux Fedora 27, mas a configuração pode ser compatível com outras distribuições também.

# RubyGems

[RubyGems](https://pt.wikipedia.org/wiki/RubyGems){:target="_blank"} é um gerenciador de pacotes do Ruby, e para utiliza-lo você precisa instalar o Ruby que já contém o mesmo. Para instalar o Ruby no Linux e o gerenciador de pacotes RubyGems, você pode olhar a pŕópria documentação do Ruby [AQUI](https://www.ruby-lang.org/pt/documentation/installation/#package-management-systems){:target="_blank"}, instalando de acordo com sua distribuição. RubyGems é responsável por instalar/gerenciar Gems (bibliotecas ou programas) em nossa máquina que servirão de base (ou não) para projetos em que criamos ou projetos que utilizamos.

Quando instalamos as Gems através do gerenciador **gem**, as mesmas são instaladas no diretório do usuário, caso precise mudar o algo onde será intalado, precisa configurar o reconhecimento de PATH (variáveis de ambiente), que é feito através do arquivo **~/.bashrc**. Também necessita criar um arquivo de configuração do "Gem Environment", o **~/.gemrc**.

## Diretórios padrão do RubyGems

Vamos entender a arquitetura de pastas das gems instalados com o gerenciador do RubyGems, para isso, vamos instalar a próprio **bundler** que mais para frente vamos configurar.

> NOTA: Dependendo da versão do ruby que você estiver usando, esses comportamento de pastas não serão igual a desse tutorial. Aqui está sendo utilizado a versão 2.4.3 do Ruby, porém, mesmo assim pode usar esse tutorial para ter uma noção de configuração.

{% highlight shell  %}
$ gem install bundler
{% endhighlight %}


A estrutura de pastas padrão criada foi a seguinte:

{% highlight text  %}
william
├── bin
│   ├── bundle
│   └── bundler
└── .gem
     ├── ruby
     │   ├── build_info
     │   ├── cache
     │   ├── doc
     │   ├── extensions
     │   ├── gems
     │   └── specifications
     └── specs  
{% endhighlight %}  

Repare que a gem **bundler** é instalado no diretório **~/.gem**, o que é conformidável, porém, algo que fica um pouco incomodo, é a criação da pasta **bin** na raiz do usuário para armazenar os executaveis das gems. Isso aconteceu algumas vezes comigo, não sei dizer se é comum esse ocorrido, porém, sei que é realmente incomodativo, pois o diretório **~/bin** por ser usado para outros eventuais executáveis, como por exemplo, executáveis **shell**.

Não queremos que isso aconteça! Então vamos desinstalar a gem **bundler** e remover a estrutura de pastas onde foi instalado a *gem*:

> Note: Digite "Y" quando pedir para desinstalar o **bundler**.

{% highlight shell  %}
$ gem uninstall bundler
$ rm -rf ~/.gem ~/bin
{% endhighlight %}

> NOTA: Se for remover o diretório **~/bin**, verifique se não tem outros scripts que você criou no mesmo.

## Variáveis de ambiente para RubyGems

Após ter a noção de estrutura de pastas padrão do "Gem Environment", vamos configurar nossas variáveis de ambiente no arquivo **~/.bashrc** para adiante mudarmos o local onde é instalado nossas gems.

Abra **~/.bashrc** com um editor de sua preferência, coloca as seguintes variáveis de ambiente abaixo e salve-o:

{% highlight shell  %}
# RubyGems environment variables
GEM_PATH="$(ruby -rubygems -e 'puts Gem.user_dir')"
GEM_HOME="$GEM_PATH"
GEM_BIN="$GEM_PATH/bin"
export PATH="$GEM_PATH:$GEM_HOME:$GEM_BIN:$PATH"
{% endhighlight %}

Na `linha 1`, está sendo definido o PATH das gems, que no caso é: `/home/USER/.gem/ruby`
Na `linha 2`, está sendo definido o diretório HOME das gems, que nã verdade é o mesmo do `$GEM_PATH`.
Na `linha 3`, é definido o PATH de onde irá ficar os executaveis de algumas gems, no caso é: `/home/USER/.gem/ruby/bin`
Na `linha 4`, é responsável por exportar essas configurações para o bash reconhecer os PATHS.

Feito isso, execute o comando abaixo para as altereções entrarem em vigor.

{% highlight shell  %}
source ~/.bashrc
{% endhighlight %}

Pronto, foi criado as variáveis de ambiente necessárias para o ambiente do RubyGems, porém, repare que a minha pasta **bin** na variável `$GEM_BIN`, está  apontando para um diretório que não é onde os executáveis das gems são instalados por padrão.


## Configuração do Environment do RubyGems

Para forçar os executáveis das gems, a serem instalados na nova configuração das variáveis de ambientes, necessita criar o arquivo "**~/.gemrc**" na raiz do usuário que modificará o "Gem Environment" do RubyGems. Para isso faça no terminal:

{% highlight shell  %}
cat << EOF > ~/.gemrc
gem: --user-install --no-document
:benchmark: false
:update_sources: true
:verbose: true
:backtrace: false
:sources:
- http://gems.rubyforge.org/
- http://rubygems.org/
:bulk_threshold: 1000
EOF
{% endhighlight %}

Com o novo ambiente RubyGems configurado, vamos instalar novamente o **bundler**:

{% highlight shell  %}
$ gem install bundler
{% endhighlight %}

Agora, dê o seguinte comando abaixo, e verás que os executáveis do **bundler** estão no diretório que foi configurado na variável de ambiente $GEM_BIN, e não mais no diretório **~/bin**:

{% highlight shell  %}
$ ls $GEM_BIN
{% endhighlight %}

Agora, você tem um ambiente do RubyGems configurado com uma estrutura de pasta um pouco mais organizada.

Para saber mais o que cada linha do arquivo "**~/.gemrc**" faz, dê uma olhada na [documentação](http://guides.rubygems.org/command-reference/){: target="_blank"} da própria RubyGems.

# Bundler

O [Bundler](https://bundler.io/){:target="_blank"} também é um gerenciador de Gems e trabalha junto com o RubyGems, porém de uma forma mais conjulgal, isso porque ele utiliza um arquivo chamado `Gemfile` para alocar todas Gems que necessitamos em nossos projetos, assim, não precisamos instalar Gems uma à uma com o gerenciador RubyGems.

A instalação das gems através do **bundler** com Gemfile, também jogará os executáveis das gems para o diretório **~/bin**. Então se pergunta: **Mas eu configurei meu "Gem Environment" tracando a estrutura de pastas onde são instaladas, por que o Bundler não obedece essa configuração?**

R:- Assim como o RubyGems, também é necessário configurar o PATH para o Bundler no **~/.bashrc** e no próprio arquivo de configuração contido no diretório raiz do usuário, o **~/.bundle/config**. Esse arquivo de configuração do Bundler é global, ou seja, todas as Gems instaladas com o Bundler, serão instaladas no diretório de acordo com que está no arquivo **~/.bundle/config**, a menos que, o seu projeto contenha um arquivo de configuração local. Exemplo: **myproject/.bundle/config**. Nesse caso as Gems seriam instaladas no local do projeto.


## Diretórios padrão do Bundler

Vamos entender melhor a estrutura de pastas criadas pelo **Bundler** quando instalamos GEMS com o arquivo **Gemfile**:

{% highlight text  %}
william
├── bin
│   ├── sass
│   ├── sass-convert
│   └── scss
└── .gem
     ├── ruby
     │   ├── bin
     │   ├── build_info
     │   ├── cache
     │   ├── doc
     │   ├── extensions
     │   ├── gems
     │   ├── ruby
     │   │   └── 2.4.0
     │   │        ├── bin
     │   │        ├── build_info
     │   │        ├── cache
     │   │        ├── doc
     │   │        ├── extensions
     │   │        ├── gems
     │   │        └── specifications
     │   └── specifications
     └── specs  
{% endhighlight %} 

Nesse caso, foi instalado o **Sass** com um arquivo **Gemfile**, e repare o Bundler criou uma pasta **ruby** dentro da pasta **ruby** do RubyGems, contendo uma subpasta com nome de **2.4.0** que é a versão atual do Ruby que está sendo usada.


## Variáveis de ambiente do Bundler

Vamos configurar as variáveis de ambiente para **Bundler**. No arquivo **~/.bashrc** adicione as seguintes variáveis e salve-o:

{% highlight shell  %}
# Bundler environment variables
BUNDLE_PATH="$HOME/.gem/bundle"
BUNDLE_HOME="$BUNDLE_PATH"
BUNDLE_BIN="$BUNDLE_HOME/bin"
export PATH="$BUNDLE_PATH:$BUNDLE_HOME:$BUNDLE_BIN:$PATH"
{% endhighlight %}


Feito isso, execute o comando abaixo para as altereções entrarem em vigor.

{% highlight shell  %}
source ~/.bashrc
{% endhighlight %}

## Configuração do Environment do Bundler

Dê os comandos abaixo, para criar o arquivo **~/.bundle/config**. Esse arquivo é as configurações global do Bundler.

{% highlight shell  %}
$ bundle config --global PATH $BUNDLE_PATH
$ bundle config --global BIN $BUNDLE_BIN
$ bundle config --global DISABLE_SHARED_GEMS true
{% endhighlight %}

Na `linha 1` atribuimos o PATH o local raiz onde nossas Gems global irá ser instaladas.
Na `linha 2` atribuimos o PATH para os executáveis das Gems.
Na `linha 3` é opcional, onde desabilitamos o compartilhamento de Gems.


Para ver mais detalhes sobre como está as configurações do `Gem Environment` na sua máquina, você pode executar o comando abaixo:

{% highlight bash  %}
$ gem env
{% endhighlight %}

# Conclusão

Apenas compartilhei algo básico de como configurar o RubyGems e Bundler. Existe muito mais na documentação de ambos, o que pode lhe servir o que deseja:

* [RubyGems Doc](http://guides.rubygems.org/rubygems-basics/){:target="_blank"}
* [Bundler Doc](https://bundler.io/docs.html){:target="_blank"}

Finalizo por aqui, espero que estas linhas de alguma forma lhe sirva de ajuda. Obrigado por ler. Fica com um sonzinho abaixo. :)


{% jektify spotify/track/6VRghJeP6I0w1KxkdWFfIh/dark %}
