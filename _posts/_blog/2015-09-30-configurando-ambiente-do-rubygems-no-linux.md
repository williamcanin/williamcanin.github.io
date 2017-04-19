---
layout: post
title: Configurando ambiente do RubyGems no Linux
date: 2015-09-30 16:02:37 -0300
comments: true
class: rubygems
tags: ["ruby","gems","linux"]
excerpted: |
    Se você  necessita configurar o ambiente RubyGems para seu usuário local, continue essa leitura e veja que um simples arquivo configurado pode facilitar as coisas para você.
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

Se você  necessita configurar o ambiente RubyGems para seu usuário local, continue essa leitura e veja que um simples arquivo configurado pode facilitar as coisas para você.

Recentemente tive alguns encomodos com execuções de gems(gemas) do **RubyGems** em meu Linux, e isso foi pelo fato de eu não ter uma configuração do RubyGems adequada para meu usuário.

Instalar Gems no diretório **(/usr/lib/ruby)** utilizando root pode ser utilizads por todos usuário no Linux, porém tem suas vantagens e desvantagens, isso vai depender da necessidde de cada um.

No meu caso, eu não queria instalar as "gems" e ter que ficar colocando a senha no terminal (isso é muito pertubador (worry)), então resolvi pesquisar e driblar a utilização de senha. A saída é instalar as "gems" no ambiente do seu usuário e não em **(/usr/lib/ruby)**, para isso precisa-se configurar/criar um arquivo de configuração do RubyGems no **HOME** do seu usuário apontando para um novo diretório de instalação das "gems". Vou deixar de teoria e partir para o prático:

NOTA: Vou levar em consideração que você já tenha o RubyGems environment instalado em sua máquina.

### Criando o arquivo de configuração

Você deve criar um arquivo com o nome de **.gemrc**(arquivo realmente necessita ter o nome **.gemrc**, com este nome ele ficará oculto) no diretório HOME de seu usuário no Linux. Utilize um editor de sua preferência, utilizarei o vim.

{% highlight bash linenos %}
$ vim ~/.gemrc
{% endhighlight %}

### Inserindo as configurações no arquivo .gemrc.

Um exemplo de como o arquivo **.gemrc** ficaria, pode ser observado no código abaixo:

{% highlight bash linenos %}
---
gem: --no-ri --no-rdoc
gemhome: HOME_DO_USUARIO/.gems
gempath:
- HOME_DO_USUARIO/.gems
:benchmark: false
:update_sources: true
:verbose: false
:backtrace: false
:sources:
- https://rubygems.org
:bulk_threshold: 1000
{% endhighlight %}

Note que, onde está **HOME_DO_USUARIO** você deve substituir pelo diretório HOME de seu usuário no Linux. Execute o comando **echo $HOME** no terminal que você verá o diretório completo e substitua-o. Feito as alterações salve e saia do Vim, digitando**:wq** [Vim Doc](http://vimdoc.sourceforge.net/htmldoc/editing.html#save-file){:target="_blank"}.

Após a configuração do **.gemrc**, você precisa configurar o PATH **bin** das gems para que o terminal reconheça.
Para isso, abra o arquivo **~/.bashrc** (localizado ocultamente no HOME do usuário Linux) com um editor de sua preferência, e insira as seguintes linhas abaixo no final do arquivo e salve:

{% highlight bash linenos %}
PATH=$HOME/.gems/bin:$PATH
GEM_HOME=$HOME/.gems
GEM_SPEC_CACHE=$GEM_HOME/specs
GEM_PATH=$HOME/.gems
export PATH GEM_HOME GEM_PATH GEM_SPEC_CACHE
{% endhighlight %}

Logo em seguida, execute o comando abaixo no terminal para ativar o PATH:

{% highlight bash linenos %}
$ source ~/.bashrc
{% endhighlight %}

Pronto, agora você instalar suas gems sem se preocupar em inserir senha de superusuário.
As "gems" vão ser instaladas na pasta **.gems** oculta no diretório **HOME** de seu usuário no Linux. Porém essas "gems" serão utilizadas apenas para esse determinado usuário.

Para ver mais detalhes sobre como está as configurações do RubyGems na sua máquina, você pode executar o comando abaixo:

{% highlight bash linenos %}
$ gem env
{% endhighlight %}

Fico por aqui, espero que este post de alguma forma lhe sirva de ajuda. Obrigado por ler.

