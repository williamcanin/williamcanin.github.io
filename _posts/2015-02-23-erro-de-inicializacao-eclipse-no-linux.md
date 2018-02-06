---
layout: post
title: Eclipse Luna - Erro de inicialização no Linux
date: 2015-02-23 18:14:01 -0300
comments: true
tags: ["eclipse", "linux"]
excerpted: |
    Apesar do Eclipse ser uma IDE famosa e de ótimos recursos, ele (como qualquer outras aplicação) não está livre de bugs. Esse post é para uma correção de um bug no Eclipse Luna para o Linux.
day_quote:
    title: "A Palavra:"
    description: |
        "Preocupações roubam a felicidade da gente, mas as palavras amáveis nos alegram.""<br>
        (Provérbios 12:25 NTLH)
published: true

# Does not change and does not remove 'script' variables
script: [post.js]
---

Apesar do Eclipse ser uma IDE famosa e de ótimos recursos, ele (como qualquer outras aplicação) não está livre de bugs. Esse post é para uma correção de um bug no Eclipse Luna para o Linux.

Recentemente instalei o [Eclipse](https://eclipse.org){:target="_blank"} Luna (Version: Luna Release (4.4.0)) no meu [Debian](https://debian.org){:target="_blank"} Wheezy (7.8) e após inicia-lo me deparei que o Eclipse não carregava. Para um entendimento melhor, a tela de splash do Eclipse Luna carregava, só que depois a mesma desaparecia e o Eclipse não iniciava.

Resolvi iniciar o Eclipse Luna pelo terminal e obtive esta saída de informações e erro:

{% highlight bash linenos %}
org.eclipse.m2e.logback.configuration: The org.eclipse.m2e.logback.configuration bundle was activated before the state location was initialized.  Will retry after the state location is initialized.

(java:4348): GLib-GObject-WARNING **: cannot register existing type `GdkDisplayManager'

(java:4348): GLib-CRITICAL **: g_once_init_leave: assertion `result != 0' failed

(java:4348): GLib-GObject-CRITICAL **: g_object_new: assertion `G_TYPE_IS_OBJECT (object_type)' failed

(java:4348): GLib-GObject-WARNING **: invalid (NULL) pointer instance

(java:4348): GLib-GObject-CRITICAL **: g_signal_connect_data: assertion `G_TYPE_CHECK_INSTANCE (instance)' failed

(java:4348): GLib-GObject-WARNING **: invalid (NULL) pointer instance

(java:4348): GLib-GObject-CRITICAL **: g_signal_connect_data: assertion `G_TYPE_CHECK_INSTANCE (instance)' failed

(java:4348): GLib-GObject-WARNING **: cannot register existing type `GdkDisplay'

(java:4348): GLib-CRITICAL **: g_once_init_leave: assertion `result != 0' failed

(java:4348): GLib-GObject-CRITICAL **: g_type_register_static: assertion `parent_type > 0' failed

(java:4348): GLib-CRITICAL **: g_once_init_leave: assertion `result != 0' failed

(java:4348): GLib-GObject-CRITICAL **: g_object_new: assertion `G_TYPE_IS_OBJECT (object_type)' failed
#
# A fatal error has been detected by the Java Runtime Environment:
#
#  SIGSEGV (0xb) at pc=0x00007ff64d98073f, pid=4348, tid=140696239372032
#
# JRE version: 6.0_34-b34
# Java VM: OpenJDK 64-Bit Server VM (23.25-b01 mixed mode linux-amd64 compressed oops)
# Derivative: IcedTea6 1.13.6
# Distribution: Debian GNU/Linux 7.6 (wheezy), package 6b34-1.13.6-1~deb7u1
# Problematic frame:
# C  [libgdk-x11-2.0.so.0+0x5173f]  gdk_display_open+0x3f
#
# Failed to write core dump. Core dumps have been disabled. To enable core dumping, try "ulimit -c unlimited" before starting Java again
#
# An error report file with more information is saved as:
# /home/william/eclipse/hs_err_pid4348.log
#
# If you would like to submit a bug report, please include
# instructions how to reproduce the bug and visit:
#   http://icedtea.classpath.org/bugzilla
# The crash happened outside the Java Virtual Machine in native code.
# See problematic frame for where to report the bug.
#
{% endhighlight %}


Quando olhei essas informações percebi que tinha algo estranho com GTK, e com pesquisas e mais pesquisas no [Google](http://www.google.com.br){:target="_blank"}, descobri que para resolver o problema de inicialização do Eclipse Luna, bastava realizar umas configurações no arquivo **eclipse.ini** que está presente no diretório do Eclipse e também configurar o arquivo **~/.bashrc** no home d seu usuário no Linux.

As configurações que fiz foram as seguintes:

**Arquivo:** eclipse.ini

{% highlight ini linenos %}
-startup
plugins/org.eclipse.equinox.launcher_1.3.0.v20140415-2008.jar
--launcher.library
plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.1.200.v20140603-1326
-product
org.eclipse.epp.package.jee.product
--launcher.defaultAction
openFile
-showsplash
org.eclipse.platform
--launcher.XXMaxPermSize
256m
--launcher.defaultAction
openFile
--launcher.GTK_version
2
--launcher.appendVmargs
-vmargs
-Dosgi.requiredJavaVersion=1.6
-XX:MaxPermSize=256m
-Xms40m
-Xmx512m
{% endhighlight %}

A configurações realizadas no arquivo **eclipse.ini**, foram o acrescentamento de duas linhas:

{% highlight ini linenos %}
--launcher.GTK_version
2
{% endhighlight %}

Essas duas linhas faz com que o Eclipse Luna passa a usar o GTK versão 2. Essas linhas devem ser acrescentadas entre da linha **openFile** e a linha **--launcher.appendVmargs**.

**Arquivo:** ~/.bashrc

O arquivo **.bashrc** fica oculto na pasta de seu usuário no Linux. Para configura-lo faça:


* 1 - Abra o arquivo:
{% highlight bash linenos %}
$ vim ~/.bashrc
{% endhighlight %}
* 2 - Adicione a seguinte linha no final:
{% highlight bash %}
export SWT_GTK3=0
{% endhighlight %}


> Obs: Para abrir o arquivo **./bashrc**, utilizei o editor **vim**. Você pode usar um de sua preferência.

> Nota: Lembrando que tive esse problema com o Eclipse Luna foi no ambiente gráfico XFCE, não testei o Eclipse com outros ambientes gráficos como o KDE ou Gnome por exemplo.

Com essas configurações, executei o Eclipse Luna novamente e o mesmo iniciou sem problema algum. :wink: É isso aí, bons códigos.


{% jektify spotify/track/7ltu1Lz4mSKHsOjPK3bvNK/dark %}
