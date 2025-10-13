---
layout: post
title: "Transações com procedures no MySQL e Herança"
description: |
   Chega de ficar apenas aprendendo 'create table' no banco de dados MySQL, aprenda como se criar
   Procedures, View e Trigger e comunicação entre as mesmas nessa postagem.
author: "William C. Canin"
date: 2015-03-03 01:02:32 -0300
update_date:
comments: true
tags: [database,mysql,procedure,trigger]
---

{% include toc selector=".post-content" max_level=3 title="Índice" btn_hidden="Fechar" btn_show="Abrir" %}

# Introdução

Chega de ficar apenas aprendendo 'create table' no banco de dados MySQL, aprenda como se criar Procedures, View e Trigger e comunicação entre as mesmas nessa postagem.

Quando se cria uma aplicação que se necessita de uma comunicação com bando de dados, seja ela de qual linguagem de programação for, o acesso entre "Aplicação Banco" sempre é um dos principais fatores para uma boa otimização, ganha tempo e velocidade de processos. A maioria da estrutura e performasse de uma aplicação, está na própria aplicação, mas isso não quer dizer que você não possa melhorar o desempenho realizando boas praticas de código no seu banco de dados. Você consegue fazer várias tarefas que poderiam ser feitas na aplicação, apenas com códigos PL/SQL.

Neste post, será passado como se deve realizar transações no seu banco de dados utilizando as famosas PROCEDURES do [MySQL](http://dev.mysql.com/){:target="_blank"}, que é um dos mais conceituados banco de dados.

Para começar, utilize o script SQL abaixo com a opção de criar um `database` e uma `tabela` de Clientes no MySQL.

> ### Criando:  Database e Tables

{% highlight sql  %}
DELIMITER $$

DROP DATABASE IF EXISTS `TRANSACTIONS` $$

CREATE DATABASE `TRANSACTIONS` $$

USE `TRANSACTIONS` $$

DROP TABLE IF EXISTS `Clientes`$$

CREATE TABLE `Clientes` (
  `codCliente` int(11) NOT NULL AUTO_INCREMENT,
  `Nome` varchar(100) NOT NULL,
  `Endereco` varchar(100) NOT NULL,
  PRIMARY KEY (`codCliente`)
)$$

DROP TABLE IF EXISTS `Cliente_Fisico` $$

CREATE TABLE `Cliente_Fisico` (
  `codFisico` int(11) NOT NULL AUTO_INCREMENT,
  `idClienteF` int(11) NOT NULL,
  `CPF` varchar(20) NOT NULL,
  PRIMARY KEY (`codFisico`),
  KEY `idClienteF` (`idClienteF`),
  FOREIGN KEY (`idClienteF`) REFERENCES `Clientes` (`codCliente`)
)$$

DROP TABLE IF EXISTS `Cliente_Juridico` $$

CREATE TABLE `Cliente_Juridico` (
  `codJuridico` int(11) NOT NULL AUTO_INCREMENT,
  `idClienteJ` int(11) NOT NULL,
  `CNPJ` varchar(20) NOT NULL,
  PRIMARY KEY (`codJuridico`),
  KEY `idClienteJ` (`idClienteJ`),
 FOREIGN KEY (`idClienteJ`) REFERENCES `Clientes` (`codCliente`)
) $$
{% endhighlight %}

Como podem perceber a tabela de `Clientes` é uma tabela pai das tabelas `Cliente_Fisico` e `Cliente_Juridico`, ou seja, uma **Herança**.

Com a herança de tabelas criada, vamos criar uma **VIEW** para realizar o READ do **CRUD**, pois temos uma herança de tabelas e precisa-se fazer um **JOIN** dos registros de Cliente com Cliente Físico e Cliente Jurídico para listar todos os registros de nosso database.

> ### Criando: View de Clientes

{% highlight sql  %}
DELIMITER $$
DROP VIEW IF EXISTS `View_Cliente_Fisico_Juridico` $$
CREATE VIEW `View_Cliente_Fisico_Juridico` AS
SELECT * FROM `Clientes` `C`
LEFT JOIN `Cliente_Fisico` `F` ON (`C`.`codCliente` = `F`.`idClienteF`)
LEFT JOIN `Cliente_Juridico` `J` ON (`C`.`codCliente` = `J`.`idClienteJ`)
$$
{% endhighlight %}

Também precisa-se criar um **TRIGGER** (gatilho) com a função de deletar a herança de um determinado registro. Por exemplo: A tabela Cliente contem os registros padrão de um cliente, mas que pertence aos clientes físicos e clientes jurídicos também, então para realizar uma exclusão de um cliente, temos que remover os registros da tabela herdada (Cliente Físico e Jurídico) e posteriormente da tabela `Clientes`, dependendo de qual registro irá ser excluído.

> ### Criando: Trigger

{% highlight sql  %}
DELIMITER $$
DROP TRIGGER IF EXISTS `TRG_HERANCA_CLIENTE` $$
CREATE
TRIGGER `Trg_Delete_Cliente_Fisico_Juridico`
BEFORE DELETE ON `Clientes`
FOR EACH ROW
BEGIN
DELETE FROM Cliente_Fisico WHERE idClienteF = OLD.codCliente;
DELETE FROM Cliente_Juridico WHERE idClienteJ = OLD.codCliente;
END$$
{% endhighlight %}

Como podem ver, nessa TRIGGER, irá remover os dos da tabela `Clientes`, `Cliente Físico` e `Cliente Jurídico` atraves das chaves estrangeiras.
Exclui os "filhos" para depois excluir o "pai" de nossa herança.


Com a toda estrutura de `TABLES`, `VIEW` e `TRIGGER` criadas, vem a parte mais esperada (tan tan tan taaann), vamos criar a nossa "linda e bonita" procedure de transações, que será responsável por fazer todas as criações, leituras, alterações e remoções de registros, ou seja, uma procedure com capacidade de relizar o CRUD (Create, Read, Update e Delete) no banco de dados.

> ### Criando: Procedure

{% highlight sql  %}
DROP PROCEDURE IF EXISTS `TRANSACTION_CLIENTS` $$

CREATE PROCEDURE `TRANSACTION_CLIENTS`(

`@OPERACAO` VARCHAR(20),
`@TABELA` VARCHAR(50),

IN `@codCliente` INT ,
IN `@Nome` VARCHAR(100),
IN `@Endereco` VARCHAR(100),

IN `@codFisico` INT,
IN `@idCliF` INT,
IN `@CPF` VARCHAR(20),

IN `@codJuridico` INT,
IN `@idCliJ` INT,
IN `@CNPJ` VARCHAR(20)


)
 BEGIN

-- OPERAÇÕES DECLARADAS
DECLARE `OP1` VARCHAR(50) DEFAULT 'CREATE';
DECLARE `OP2` VARCHAR(50) DEFAULT 'DELETE';
DECLARE `OP3` VARCHAR(50) DEFAULT 'UPDATE';
DECLARE `OP4` VARCHAR(50) DEFAULT 'READ';
-- TABELAS DECLARADAS A SERÃO OPERADAS
DECLARE `TAB1` VARCHAR(50) DEFAULT 'CLIENTE_FISICO';
DECLARE `TAB2` VARCHAR(50) DEFAULT 'CLIENTE_JURIDICO';
DECLARE `TAB3` VARCHAR(50) DEFAULT 'CLIENTES';



DECLARE exception SMALLINT DEFAULT 0;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET exception = 1;

-- INSERT DA TABELA FISICO
IF (`@TABELA` = `TAB1`  AND `@OPERACAO` = `OP1` AND `@codCliente` IS NULL) THEN
   BEGIN -- B01
      IF ((`@Nome` <> "") AND (`@Endereco` <> "") AND(`@CPF` <> ""))THEN
          BEGIN
             START TRANSACTION;
             INSERT INTO Clientes VALUES(NULL,`@Nome`, `@Endereco`);
                IF exception = 1 THEN
                   SELECT 'Erro ao inserir na tabela Cliente' AS Msg;
                   ROLLBACK;
                ELSE
                   SELECT DISTINCT LAST_INSERT_ID() INTO @idClienteF FROM Clientes;
                END IF;
                     IF exception = 1 THEN
                        SELECT 'Erro ao selecionar o ultimo ID inserido' AS Msg;
                        ROLLBACK;
                     ELSE
                        INSERT INTO Cliente_Fisico VALUES(NULL,@idClienteF,`@CPF`);
                        SELECT 'Cadastro efetuado com sucesso' AS Msg;
                        COMMIT;
                     END IF;

           END;
        ELSE
           SELECT 'Parametros necessários para realizar a operação' AS Msg;

 END IF;
   END; -- LIMITE FISICO
ELSE
-- INSERT DA TABELA JURIDICO
IF (`@TABELA` = `TAB2`  AND `@OPERACAO` = `OP1` AND `@codCliente` IS NULL) THEN
   BEGIN -- B01
      IF ((`@Nome` <> "") AND (`@Endereco` <> "") AND(`@CNPJ` <> ""))THEN
          BEGIN
             START TRANSACTION;
             INSERT INTO Clientes VALUES(NULL,`@Nome`, `@Endereco`);
                IF exception = 1 THEN
                   SELECT 'Erro ao inserir na tabela Cliente' AS Msg;
                   ROLLBACK;
                ELSE
                   SELECT DISTINCT LAST_INSERT_ID() INTO @idClienteJ FROM Clientes;
                END IF;
                     IF exception = 1 THEN
                        SELECT 'Erro ao selecionar o ultimo ID inserido' AS Msg;
                        ROLLBACK;
                     ELSE
                        INSERT INTO Cliente_Juridico VALUES(NULL,@idClienteJ,`@CNPJ`);
                        SELECT 'Cadastro efetuado com sucesso' AS Msg;
                        COMMIT;
                     END IF;

           END;
        ELSE
           SELECT 'Parametros necessários para realizar a operação' AS Msg;

 END IF;
   END;
ELSE
-- UPDATE TABELA DE FISICO
IF (`@TABELA` = `TAB1`  AND `@OPERACAO` = `OP3`) THEN
   BEGIN
UPDATE Clientes SET `Nome` = `@Nome`, `Endereco` = `@Endereco` WHERE `codCliente` = `@codCliente`;
        IF exception = 1 THEN
            SELECT 'Erro ao atualizar tabela de Cliente' AS Msg;
            ROLLBACK;
        END IF;
UPDATE Cliente_Fisico SET `CPF` = `@CPF` WHERE `codFisico` = `@codFisico`;
        IF exception = 1 THEN
            SELECT 'Erro ao atualizar tabela de Cliente Físico' AS Msg;
            ROLLBACK;
        ELSE
            SELECT 'Atualização realizada com sucesso' AS Msg;

       END IF;
END;
ELSE
-- UPDATE TABELA DE JURIDICO
IF (`@TABELA` = `TAB2`  AND `@OPERACAO` = `OP3`) THEN
   BEGIN
UPDATE Clientes SET `Nome` = `@Nome`, `Endereco` = `@Endereco` WHERE `codCliente` = `@codCliente`;
        IF exception = 1 THEN
            SELECT 'Erro ao atualizar tabela de Cliente' AS Msg;
            ROLLBACK;
        END IF;
UPDATE Cliente_Juridico SET `CNPJ` = `@CNPJ` WHERE `codJuridico` = `@codJuridico`;
        IF exception = 1 THEN
            SELECT 'Erro ao atualizar tabela de Cliente Físico' AS Msg;
            ROLLBACK;
        ELSE
            SELECT 'Atualização realizada com sucesso' AS Msg;

       END IF;

END;
ELSE
-- DELETE TABELA DE FISICO
IF (`@TABELA` = `TAB1`  AND `@OPERACAO` = `OP2`) THEN
   BEGIN
        DELETE FROM Clientes WHERE `codCliente` = `@codCliente`;
        IF exception = 1 THEN
            SELECT 'Erro ao excluir o registro da tabela de Cliente' AS Msg;
            ROLLBACK;
        ELSE
            SELECT 'Registro excluído da tabela de Cliente com sucesso' AS Msg;
        END IF;

   END;
ELSE
-- DELETE TABELA DE JURIDICO
IF (`@TABELA` = `TAB2`  AND `@OPERACAO` = `OP2`) THEN
   BEGIN
        DELETE FROM Clientes WHERE `codCliente` = `@codCliente`;
        IF exception = 1 THEN
            SELECT 'Erro ao excluir o registro da tabela de Cliente' AS Msg;
            ROLLBACK;
        ELSE
            SELECT 'Registro excluído da tabela de Cliente com sucesso' AS Msg;
        END IF;
   END;
   ELSE
   -- SELECIONAR TODOS CLIENTES
IF (`@TABELA` = `TAB3`  AND `@OPERACAO` = `OP4`) THEN
   BEGIN
        SELECT * FROM TRANSACTIONS.View_Cliente_Fisico_Juridico;
   END;
ELSE
SELECT 'Parametros necessários para realizar a operação' AS Msg;

END IF;

END IF;

END IF;

END IF;

END IF;

END IF;


END IF;

END$$
{% endhighlight %}

Na parte de criação (Create) de registros através dessa procedure, foi utilizado a função LAST_INSERT_ID() do MySQL, como temos uma herança de tabelas, essa função nos da uma opção de resgatar o ultimo registro inserido na tabela `Clientes`, pegando seu ID (Primary Key) e incluindo na tabela `Cliente Físico` ou `Cliente Jurídico` no campo de Foreign Key, dependendo de qual cliente você vai inserir, claro. Também pode-se perceber, foi declarado uma variável "exception" , com um valor default igual a 0 (zero), e atribuindo um SQLEXCEPTION com o valor de 1(um) caso de erro na transação, uma mensagem de exceção será disparada. O restante da procedure é basicamente implicado com lógicas de IF e ELSE.

>  NOTA: Para relizar as transações com o procedure, utiliza-se o CALL no MySQL. Lembrando que todos os parâmetros que estão presente no procedure, devem ser especificados na execução da procedure com o CALL, mesmo esses parâmetros não tendo uma implicância significativa, eles devem ser carregados com **NULL **.

### Um exemplo:

{% highlight sql  %}
-- Criando um Cliente Físico
CALL TRANSACTION_CLIENT ('CREATE','CLIENTE_FISICO',null,'William C. Canin','Rua XYZ',null,null,'01-234-567-89',null,null,null);
-- Criando um Cliente Jurídico
CALL TRANSACTION_CLIENT ('CREATE','CLIENTE_JURIDICO',null,'William C. Canin','Rua YXZ',null,null,null,null,null,'88-124-3697/15');
-- Alterando um Cliente Físico
CALL TRANSACTION_CLIENT ('UPDATE','CLIENTE_FISICO',null,'William C. Canin','Rua ABC',null,null,'01-234-567-89',null,null,null);
-- Deletando um Cliente Físico
CALL TRANSACTION_CLIENT ('DELETE','CLIENTE_FISICO',1,null,null,null,null,null,null,null,null);
-- Selecionado todos os registros
CALL TRANSACTION_CLIENT ('READ','CLIENTES',null,null,null,null,null,null,null,null,null);
{% endhighlight %}

Como podem ver, ao criar (CREATE) um registro com CALL, dependendo de ser cliente físico ou jurídicos, os campos preenchidos são distintos. Já na parte de remoção de registros (DELETE), precisa-se apenas especificar a chave primária da tabela `Clientes`, que o trigger que criamos, será responsável por remover os dados da tabela "filho". No CALL de selecionar (READ) os registros, apenas é necessário informar os parâmetros de operação e parâmetros da tabela a ser realizada a transação, já que utilizamos uma `VIEW` contendo todos os campos para a listagem completa.

Bom, vou me despedindo por aqui, espero que você tenha entendido um pouco de transações com procedure através de tabelas com herança no MySQL. Um abraço. Morfei!

