---
layout: post
title: Criando um shortcut para o Eclipse no Linux
date: 2015-02-07 19:50:20 -0300
comments: true
main-class: eclipse
tags: ["eclipse","shortcut","linux"]
excerpted: |
    Nos dias de hoje, o Eclipse no momento não possui um instalador para Linux assim com tem para Windows, com isso não se cria um shortcut (Lançador) para a aplicação juntamento com outros programas já instalados.
day_quote:
    title: "A Palavra:"
    content: |
        "Não tenha inveja dos maus, nem procure ter amizade com eles. Eles só pensam em violências e, quando falam, é para ferir algém." <br>
        (Provérbios 24:1-2 NTLH)
categories: blog
published: true
---

<span class="fa fa-share" style="font-size: 80px; float: left; margin-right: 0.2em; border-radius: 100%; width: 80px; height: 80px; background-size: 80px; text-align: center; background-color: #F1F1F1;"></span>

Nos dias de hoje, o Eclipse no momento não possui um instalador para Linux assim com tem para Windows, com isso não se cria um shortcut (Lançador) para a aplicação juntamento com outros programas já instalados. 

Muitos que usam Eclipse no Linux, já sentiram a ausência e falta de um lançador(shortcut) para o Eclipse, não é verdade? Eu sou um desses "muitos". Isso acontece porque, o Eclipse não tem um instalador para criação do ícone, ele é uma IDE compactada e que na sua descompactação já está pronto para uso.

Existe várias formas de criar um shortcut, você pode fazer isso manualmente pelo terminal de seu Linux usando o próprio ícone (icon.xpm) do Eclipse que está presente na raiz da IDE. Mas para não ficar passando por vários comandos na console, entrando em diretório e saindo..etc, eu criei um Script Shell que facilita a criação do lançador para o Eclipse.

Dê uma olhada como ficou esse Script Shell:

{% highlight bash linenos %}
#!/bin/bash
# Script shell by: William C. Canin <http://github.com/williamcanin>
# License MIT
# Description: Create shortcut Eclipse

function directorys (){
    root=`pwd`
    root_icons="/usr/share/applications"
    shortcut="${root_icons}/eclipse.desktop"
    icon_eclipse="${root}/icon.xpm"
    execute_eclipse="${root}/eclipse"
    }

function create_icon(){
/bin/cat << EOF > ${shortcut}
[Desktop Entry]
Type=Application
Version=1.0
Name=Eclipse
GenericName=Eclipse-IDE-Luna
Comment=Desenvolvimento Java
Exec=${execute_eclipse}
Icon=${icon_eclipse}
Terminal=false
Categories=GTK;Development;IDE;
StartupNotify=true

EOF

}

if [ "$(id -u )" = "0" ]; then(
directorys
rm -f ${shortcut}
create_icon
echo "Creating shortcut Eclipse in category development. ....done"
)else(
    echo "use root"
)fi
{% endhighlight %}

Como podem ver, o Script Shell possui duas funções: Uma para armazenar as variáveis dos diretórios e variáveis de execução. E a outra função para a criação do lançador em si. Todos os lançadores no seu Linux, são armazenados basicamente no diretório **/usr/share/applications**.

##Usabilidade

Para usar este Script Shell, você deve salva-lo (com um nome qualquer) dentro da pasta raiz do Eclipse e entrar na mesma através do terminal, e logo em seguida dar os seguintes comandos para criação do lançador:

{% highlight bash linenos %}
$ sudo chmod +x install-shortcut.sh
$ sudo sh install-shortcut.sh
{% endhighlight %}

> Nota IMPORTANTE: Essas duas linhas devem ser executadas com super-usuário (root), ou através do **sudo**.

Clique [AQUI](https://github.com/williamcanin/install-shortcut-eclipse){:target="_blank"} para ter acesso ao Script Shell pronto.

Obrigado pela leitura, teia.