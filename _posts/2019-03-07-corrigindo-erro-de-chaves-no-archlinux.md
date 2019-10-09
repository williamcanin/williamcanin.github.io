---
layout: post
title: "Corrigindo erro de chaves no Archlinux"
date: 2019-03-07 09:13:17
tags: ['archlinux','keys','dicas']
published: true
comments: true
excerpted: |
          Você já deve ter se deparado com problemas de chaves públicas ao instalar um pacote
          no Archlinux, certo? Pois esse post de dica rápida pode ajudar a você a 
          resolver isso.
day_quote:
 title: "A Palavra"
 description: |
          "Todos neste mundo devem ser sábios. Ter sabedoria é tão bom como receber uma herança. A sabedoria é melhor do que o dinheiro. A vantagem da sabedoria é que ela conserva a vida da gente." </br>
          (Eclesiastes 7:11-12 NTLH)

# Does not change and does not remove 'script' variable.
script: [post.js]
---

<!-- Write from here your post !!! -->

Se alguma vez você se deparou com erro de chaves públicas ao instalar um pacote no Archlinux e não soube como resolver,então talvez essa dica abaixo pode te ajudar.

Abaixo você pode perceber que tentei instalar o pacote [spotify](https://aur.archlinux.org/packages/spotify){:target="_blank"} no meu [Archlinux](https://archlinux.org){:target="_blank"} através do repositório AUR com o [yay](https://aur.archlinux.org/packages/yay/){:target="_blank"}, e me retornou um erro de chave pública.

{% highlight bash  %}
  william at archlinux in folder ~ (python-3.7.4) ○ 
 ⇨ yay -S spotify --nodiffmenu --noeditmenu --noupgrademenu
:: There are 5 providers available for spotify:
:: Repository AUR
    1) spotify 2) spotify-dev 3) spotify-legacy 4) spotify094 5) spotio 

Enter a number (default=1): 1
:: Checking for conflicts...
:: Checking for inner conflicts...
[Aur: 1]  spotify-1:1.1.10.546-1

  1 spotify                                  (Build Files Exist)
==> Packages to cleanBuild?
==> [N]one [A]ll [Ab]ort [I]nstalled [No]tInstalled or (1 2 3, 1-3, ^4)
==> N
:: PKGBUILD up to date, Skipping (1/1): spotify
:: Parsing SRCINFO (1/1): spotify
==> Criando o pacote: spotify 1:1.1.10.546-1 (dom 11 ago 2019 11:11:33 -03)
==> Obtendo fontes...
  -> Encontrado spotify.protocol
  -> Encontrado LICENSE
  -> Encontrado spotify-1.1.10.546-Release
  -> Encontrado spotify-1.1.10.546-Release.sig
  -> Encontrado spotify-1.1.10.546-x86_64.deb
  -> Encontrado spotify-1.1.10.546-x86_64-Packages
==> Validando source arquivos com sha512sums...
    spotify.protocol ... Passou
    LICENSE ... Passou
    spotify-1.1.10.546-Release ... Ignorada
    spotify-1.1.10.546-Release.sig ... Ignorada
==> Validando source_x86_64 arquivos com sha512sums...
    spotify-1.1.10.546-x86_64.deb ... Passou
    spotify-1.1.10.546-x86_64-Packages ... Passou
==> Verificando assinatura de arquivo fonte com gpg...
    spotify-1.1.10.546-Release ... FALHOU (chave pública inválida 2EBF997C15BDA244B6EBF5D84773BD5E130D1D45)
==> ERRO: Uma ou mais assinaturas PGP não puderam ser verificadas!
Error downloading sources: spotify

  william at archlinux in folder ~ (python-3.7.4) ○ 
 ⇨ 
{% endhighlight %}

Observe que ao final do comando me retornou a chave que está dando problema, nesse caso é a chave **2EBF997C15BDA244B6EBF5D84773BD5E130D1D45**. É essa chave que vamos adicionar.

Para corrigir erros de chave no Archlinux, você usará o comando `pacman-key`. Veja abaixo como adicionar uma chave no ficheiro do seu Archlinux.

{% highlight bash  %}
sudo pacman-key -r 2EBF997C15BDA244B6EBF5D84773BD5E130D1D45
sudo pacman-key --lsign-key 2EBF997C15BDA244B6EBF5D84773BD5E130D1D45
sudo pacman-key --refresh-keys
{% endhighlight %}

Após executar todos comando acima, você deve repetir o processo de instalação do pacote novamente com o seguinte comando no `yay`:

{% highlight bash  %}
yay -S spotify --nodiffmenu --noeditmenu
{% endhighlight %}

Caso o erro de chave persista mesmo você fazendo os passos acima, dê uma olhada nos comentários da página do pacote para ver se o erro é do desenvolvedor. Nesse caso, você pode instalar qualquer pacote do AUR com erros de chaves ignorando a assinatura PGP com o comando abaixo:

{% highlight bash  %}
yay -S --mflags --skipinteg spotify
{% endhighlight %}


Até a próxima ;)

{% endpost #9D9D9D %}

{% jektify spotify/track/3iC3Numiy9P3AkF7iioKmx/dark %}