---
layout: post
title: "Transações no banco de dados através do Shell script"
date: 2018-08-28 05:23:33
tags: ['shell','postgresql','mysql']
published: true
comments: true
excerpted: |
          O Shell Script não é só uma linguagem para fazer automatização de tarefas no seu S.O, é muito mais!
day_quote:
 title: "A Palavra"
 description: |
          "Quem é fiel nas coisas pequenas também será nas grandes; e quem é desonesto nas coisas pequenas também será nas grandes." </br> (Lucas 16:10 NTLH)

# Does not change and does not remove 'script' variable.
script: [post.js]
---

<!-- Write from here your post !!! -->


Olá pessoas, vamos falar de Shell script, que é algo que gosto muito. :)

* indice
{: toc}

# Introdução

Bom, se você é usuário Linux sabe muito bem o que é [Shell Script](https://pt.wikipedia.org/wiki/Shell_script){:target="_blank"}, uma linguagem usuda em vários sistemas operativos, até aqui tudo bem, mas...o que muitos não sabem é dá para fazer transações no banco de dados através da mesma.

  - Você: Sério? 
  - Eu: Sério cara.

O que vamos ver neste post é exatamente isso, uma conexão com um banco de dados; criação de um database; e a criação de uma tabela. Não irei abordar um CRUD completo, pois com base na conexão e criação de uma tabela, você já será apto para navegar em sua mente e realizar as demais transações no banco de dados, tendo como requerimento apenas conhecimento de PL/SQL.

Os bancos de dados que irei abordar aqui serão o [PostgreSQL](https://www.postgresql.org){:target="_blank"} e o [MySQL](https://www.mysql.com){:target="_blank"}, então suponho que você já tenha um dos dois instalados em sua máquina; com as configurações de usuário e senha realizadas; e o serviço iniciado.

# Requerimentos

* PostgreSQL ou Mysql instalado.
* Conhecimento básico em PL/SQL.
* Força de vontade :D


# PostgreSQL

## Preparando ambiente

Por padrão, o PostgreSQL já cria um usuário e uma role com o nome **postgres**, você pode fazer um teste de conexão com o seguinte comando:

{% highlight bash  %}
$ psql -U postgres
{% endhighlight %}

ou

{% highlight bash  %}
$ sudo -u postgres psql
{% endhighlight %}

> NOTA: O usuário **postgres** tem permissão de SUPERUSER, então você pode criar outros usuários, databases, tabelas e outros respectivas permissões com ele.

### Criando um DATABASE no PostgreSQL

Uma vez que você já está conectado ao `psql` com usuário **postgres**, vamos criar um DATABASE onde vamos trabalhar nossas transações:

{% highlight bash  %}
postgres=# CREATE DATABASE my_db;
{% endhighlight %}

> NOTA: Mais adiante, criamos nossa DATABASE através de uma função em nosso projeto, porém, vale lembrar que o **CREATE DATABASE** no PostgreSQL não tem opção **IF NOT EXISTS** e só podemos executar uma única instrução do **CREATE DATABASE**, não conseguimos executa-lo dentro de um bloco de transação. Com essas informações, foi usado outras técnicas com Shell Script para verificar se DATABASE não existe e assim criar o mesmo.

## Iniciando projeto

## Criando pasta de ambiente do projeto

Vamos criar uma pasta para nosso projeto e entrar na mesma com o comando abaixo:

{% highlight bash  %}
mkdir ~/sh_postgresql; cd $_
{% endhighlight %}

## Criando arquivo de configuração

Para fins de boas normas de projeto, vamos criar o arquivo **config.conf** na base do nosso projeto, e armazenar nossas variáveis global.

Conteúdo do arquivo: **config.conf**

{% highlight bash  %}
DB="my_db"
HOST="localhost"
PORT="5432"
USER="postgres"
TABLE="films"
{% endhighlight %}

Essas variáveis vão ser responsáveis por qualquer tipo de transação no banco de dados.

## Criando bibliotecas para nosso projeto

Sempre que criamos um projeto, é interessante dividir partes do nosso código e fazer essas partes virarem bibliotecas, ou seja, pequenos trechos de código onde podemos importar a qualquer momento. Vamos criar nossas bibliotecas na pasta **libs**.

### Biblioteca **create_database.bash**

A primeira **lib** (biblioteca) que vamos criar é a **create_database.bash**. Essa biblioteca irá conter uma função para criar nossa DATABASE caso ela não exista.

Conteúdo do arquivo: **libs/create_database.bash** 

{% highlight bash  %}
function _create_database () {
	psql -h $HOST -p $PORT -U $USER -tc "SELECT 1 FROM pg_database WHERE datname = '$DB'" | grep -q 1 || psql -h $HOST -p $PORT -U $USER -c "CREATE DATABASE $DB"
}
{% endhighlight %}

Em [Criando um DATABASE no PostgreSQL](#criando-um-database-no-postgresql), criamos nosso DATABASE manualmente através do **psql**, mas caso não criassemos, essa função já seria responsável por criar.

### Biblioteca **create_table.bash**

Outra **lib** (biblioteca) que vamos criar é a **create_table.bash**. Essa bibliotea irá conter uma função para criar nossa TABLE. Você pode ser bem mais dinâmico ao criar suas "*libs*", como esse é um post para apenas lhe dar uma ideia, vou ser bem direto nessa biblioteca de criação de TABLE.

Conteúdo do arquivo: **libs/create_table.bash** 

{% highlight bash  %}
function _create_table () {
    psql -h $HOST -p $PORT -U $USER -d $DB << EOF

       \c DB
        
       CREATE TABLE IF NOT EXISTS $TABLE (
    		id          char(5) CONSTRAINT firstkey PRIMARY KEY,
    		title       varchar(40) NOT NULL,
    		did         integer NOT NULL,
    		date_prod   date,
    		kind        varchar(10),
    		len         interval hour to minute
	); 
EOF
}
{% endhighlight %}

## Criando o programa principal

Vamos agora criar um arquivo chamando **setup.bash**, nesse arquivo iremos carregar nosso arquivo de configuração (**config.conf**) e nossas *libs*. Ele também terá um menu de interação com o usuário.

Conteúdo do arquivo: **setup.bash**

{% highlight bash  %}
#!/usr/bin/env bash

source config.conf

libs="$(ls ./libs/*.bash)"
for lib in $libs; do
    source $lib
done

case $1 in
    createtb)
        _create_database
        _create_table
    ;;
    *)
       printf "Using: $0 { createtb }"
    ;;
esac
exit 0
}
{% endhighlight %}

## Estrutura do projeto para PostgreSQL

A árvore do nosso projeto ficou assim:

{% highlight bash  %}
.
├── config.conf
├── libs
│   ├── create_database.bash
│   └── create_table.bash
└── setup.bash
{% endhighlight %}

## Executando nosso programa

Depois de ter criado todos arquivos, chegou a hora de fazer nosso programa ser executado. Para isso faça:

{% highlight bash  %}
chmod +x setup.bash
bash setup.bash createtb
{% endhighlight %}

Se tudo ocorreu bem, a tabela ($DB) já foi criada no banco de dados. Você pode executar os comandos abaixo e verificar:

{% highlight bash  %}
source config.conf && psql -h $HOST -p $PORT -U $USER -d $DB
{% endhighlight %}

Dentro do psql, execute o comando **\dt** para listar as TABLES desse DATABASE:

{% highlight bash  %}
my_db=# \dt
            Lista de relações
 Esquema | Nome  |  Tipo  |   Dono   
---------+-------+--------+----------
 public  | films | tabela | postgres
(1 registro)
{% endhighlight %}

# MySQL

## Preparando ambiente

Antes de começar, precisamos verificar se temos acesso a conexão com o MySQL. Se você instalou e configurou normalmente, você pode executar o comando abaixo para logar informando a senha do MySQL configurada:

{% highlight bash  %}
$ mysql -u root -p
{% endhighlight %}

Se você se conectou, já podemos prosseguir com os passos seguintes.

## Iniciando projeto

## Criando pasta de ambiente do projeto

Vamos criar uma pasta para nosso projeto de **MySQL** e entrar na mesma com o comando abaixo:

{% highlight bash  %}
mkdir ~/sh_mysql; cd $_
{% endhighlight %}

## Criando arquivo de configuração

Como fizemos no projeto para o **PostgreSQL**, vamos criar p arquivo  **config.conf** na base do nosso projeto.

Conteúdo do arquivo: **config.conf**

{% highlight bash  %}
DB="my_db"
HOST="localhost"
PORT="3306"
USER="root"
PASSWORD=""
TABLE="cartoons"
{% endhighlight %}

## Criando bibliotecas para nosso projeto

Vamos repetir o mesmo conceito que fizemos para o PostgreSQL, criando nossas bibliotecas na pasta **libs** do projeto.

### Biblioteca **create_database.bash**

Diferente do PostgreSQL, o **MySQL** contem uma opção de **IF NOT EXISTS** para criação de DATABASES, com isso não precisamos fazer a verificação via Shell Script como fizemos com o projeto do PostgreSQL. Com a própria instrução SQL do MySQL, podemos fazer essa checagem.

Conteúdo do arquivo: **libs/create_database.bash** 

{% highlight bash  %}
function _create_database () {
    mysql --host=$HOST --port=$PORT --user=$USER --password=$PASSWORD << EOF
        CREATE DATABASE IF NOT EXISTS \`$DB\`;
EOF
}
{% endhighlight %}

### Biblioteca **create_table.bash**

Diferentemente do PostgreSQL também, com o MySQL você deve criar delimitadores para executar várias instruções SQL. Você define um delimitador com a palavra reservada **DELIMITER** e logo em seguida o delimitador que você quer. Aqui estou usando o **$$**. 

Conteúdo do arquivo: **libs/create_table.bash** 

{% highlight bash  %}
function _create_table () {
    mysql --host=$HOST --port=$PORT --user=$USER --password=$PASSWORD << EOF
       
        DELIMITER $$

        USE \`$DB\` $$

        CREATE TABLE IF NOT EXISTS \`$TABLE\`  (
            id        INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
            title     VARCHAR(40) NOT NULL,
            did       INTEGER NOT NULL,
            date      TIMESTAMP,
            kind      VARCHAR(10),
            designer  VARCHAR(30),
            
        )$$ 
EOF
}
{% endhighlight %}

## Criando o programa principal

Vamos carregar todas nossas bibliotecas no **setup.bash** e o arquivo de configuração **config.conf**. Na mesma ideia que fizemos no projeto do PostgreSQLm vamos fazer para o MySQL mais uma vez.

Conteúdo do arquivo: **setup.bash**

{% highlight bash  %}
#!/usr/bin/env bash

source config.conf

libs="$(ls ./libs/*.bash)"
for lib in $libs; do
    source $lib
done

case $1 in
    createtb)
        _create_database
        _create_table
    ;;
    *)
       printf "Using: $0 { createtb }"
    ;;
esac
exit 0
}
{% endhighlight %}

## Estrutura do projeto para MySQL

A árvore do nosso projeto ficou assim:

{% highlight bash  %}
.
├── config.conf
├── libs
│   ├── create_database.bash
│   └── create_table.bash
└── setup.bash
{% endhighlight %}

## Executando nosso programa

{% highlight bash  %}
chmod +x setup.bash
bash setup.bash createtb
{% endhighlight %}

Execute os comandos abaixo e verificar:

{% highlight bash  %}
source config.conf && mysql --host=$HOST --port=$PORT --user=$DB_USER --password=$DB_PASSWD
{% endhighlight %}

Dentro do console do mysql, execute o comando abaixo para listar o DATABASE criado:

{% highlight bash  %}
MySQL [(none)]> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| my_db              |
| mysql              |
| performance_schema |
+--------------------+
3 rows in set (0.001 sec)
{% endhighlight %}

# Conclusão

Como dito, foi um simples post para você tenha uma noção do que podemos fazer com Shell Script. Tanto os passos para PostgreSQL e para MySQL, existem trechos de código praticamente idênticos, mudando uma coisinha ou outra. Porém, apesar de realizarmos transações no banco de dados com Shell Script, não recomendo você tentar criar um sistema dessa maneira. Existem diversas linguagens de programação onde temos milhares de vantagens para realizar tudo que fizemos aqui.

Espero que você tenha aprendido algo com esse post. Eu fico por aqui, até a próxima.


{% jektify spotify/track/4z03oOSuvqMuHlkuwXqbSy/dark %}
