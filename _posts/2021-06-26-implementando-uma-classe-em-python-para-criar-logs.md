---
layout: post
title: "Implementando uma classe em Python para criar logs"
date: 2021-06-26 20:37:43
tags: ['python','logs']
published: true
comments: true
excerpted: |
        Como criar logs utilizando Python? Talvez foi isso que você procurou na internet, e se está lendo, talvez você possa ter encontrado o que pesquisou .
day_quote:
 title: "A Palavra do Dia"
 description: |
        "- Quando somos corrigidos isso nos momento nos parece motivo de tristeza e não de alegria. Porém, mas tarde os que foram corridos recebem como recompensa uma vida correta e de paz. <br> (Hebreus 12:11 NTLH)"

# Does not change and does not remove 'script' variable.
script: [post.js]
---


* indice
{: toc}

Olá <img src="https://media.giphy.com/media/hvRJCLFzcasrR4ia7z/giphy.gif" width="25px">, bem vindo a mais um post no meu weblog. Vamos começar a leitura?!


# Introdução

Conforme você vai avançando na programação, você vai se desafiando, e como isso criando aplicações mais complexas e com necessidade de armazenar logs. Pensando nisso, resolvi criar esse post não só pra quem vai fazer um software mais avançado, mas também serve para todos tipos de níveis de aplicação dependendo o que a mesma irá exigir.

Neste post você vai aprender de forma básica como criar seus logs e ainda vamos implementar de uma forma que você possa usar como módulo para outros recursos, e um extra de colorir`*` as mensagens de logs.

**E por quê eu digo aprender de forma simples?**

R:- Porque dependendo do que você tem em mente, criar um registro de log e onde irá armazenar esses logs, pode exigir que você tenha que lhe dar com permissões de usuário no diretório a ser gravado os logs (o que não é no caso que iremos abordar neste post). No Linux por exemplo, muitas aplicações registram seus logs no diretório `/var/logs`, porem, isso é uma convenção e não necessariamente você precisa registra-los nesse diretório, ou seja, vai de programador para programador.

Agora vamos de fato "codar" e sair dos avisos. Voilá!

> `*` O modo de colorir os logs deste post, só será possível se você estiver em um sistema Unix, ou seja, não é compatível com sistema Windows.

# Requisitos

| Softwares | Versão | Onde obter? |
|-----------|--------|-------------|
| Python    | >= 3.5 | [Python Downloads](https://www.python.org/downloads/){:target="_blank"} |


E o mais importante, toda sua mega master atenção de leitura. Que eu sei que você. :D

# Criando o módulo

Bom, um módulo em Python nada mais é que um arquivo contendo seu código então vamos criar um arquivo chamado **logger.py**:

{% highlight shell %}
touch logger.py
{% endhighlight %}

# Implementando o código

## Imports

Com o arquivo **logger.py** criado; tudo começa com os `imports`, então vamos fazer os imports que são 2 (dois) apenas que iremos trabalhar:

{% highlight python linenos %}
import logging
from sys import platform
{% endhighlight %}

O primeiro *import* é o de fato o mais importante que é o módulo **logging**, um módulo de logs nativo do Python.
O segundo, o [**platform**](https://docs.python.org/pt-br/3.9/library/sys.html?highlight=platform#sys.platform){:target="_blank"} também é um módulo nativo do Python, mas que tem uma função chamada **startswith**, que retorna um valor booleano através do parâmetro passado nela para verificar o tipo de plataforma do S.O.


## Função para verificar Sistema Operacional

Como dito antes, iremos trabalhar com cor ANSI nos logs, mas precisamos verificar se estamos de fato em um sistema operacional que suporte isso, então vamos criar uma função "verificadora".

{% highlight python linenos %}

def unix_color(value):
    if platform.startswith("win"):
        return ""
    return value

{% endhighlight %}


Uma função simples, que retorna uma string vazia caso o sistema operacional seja Windows, caso contrário, me retorna o próprio valor passado no parâmetro. Este valor passado por parâmetro será nosso código ANSI de cores, que iremos implementar mais adiante.

## Criando classe `Colors` para armazenar cores ANSI

Agora chegou a hora de criarmos uma classe que irá armazenar nossas cores ANSI, essa classe terá apenas variáveis de classe:

> Criei um vídeo no **YouTube**, explicando como podemos criar um módulo para imprimir mensagens coloridas com Python. Se você não visualizou vale a pena olhar, pois este código é um pequeno trecho que tirei deste vídeo. Você pode acessa-ló [clicando aqui](https://www.youtube.com/watch?v=VW-UphhjJ3E&feature=emb_imp_woyt){:target="_blank"}

{% highlight python linenos %}

class Colors:
    NONE = unix_color("\x1b[0m")
    BLACK = unix_color("\x1b[30m")
    MAGENTA = unix_color("\x1b[95m")
    BLUE = unix_color("\x1b[94m")
    GREEN = unix_color("\x1b[92m")
    RED = unix_color("\x1b[91m")
    YELLOW = unix_color("\x1b[93m")
    CYAN = unix_color("\x1b[96m")
    WHITE = unix_color("\x1b[97m")

{% endhighlight %}

Repare que criei variáveis de classe, e os valores que elas estão recebendo está sendo atribuindo pela função **unix_color** que criamos assim, ou seja, se o sistema operacional for UNIX, irá retornar o parâmetro passado na função, nas variáveis de classe.

Criei apenas alguns opções de cores e estilos ANSI, mas você pode implementar mais acessando este [documento](https://en.wikipedia.org/wiki/ANSI_escape_code){:target="_blank"} que contem explicações mais detalhas sobre cores ANSI.


> NOTA: Tem como utilizar cores para Windows como a biblioteca **coloranma** por exemplo, porem, está forma é reconhecida apenas por sistemas baseado em UNIX (Linux e OS X).

## Criando classe de logs

Vamos começar de fato a criar nossa classe de **logs**, onde será uma classe que irá herdar da classe **Colors**:

{% highlight python linenos %}

class Logs(Colors):

    FILENAME = "app.log"
    DATE_FORMAT = "%m/%d/%Y %I:%M:%S %p"

{% endhighlight %}

Repare que temos 2 (duas) variáveis de classe, a **FILENAME**, que recebe o nome com path (neste caso sem nenhum path) do arquivo de log que irá ser criado, e o **DATE_FORMAT**, que será o formato da data a ser gravada nos logs. Você irá entender mais dessas duas variáveis de classe a seguir no método **dander init** (`__init__`).

## Método inicializador ("construtor")

No método **dander init** (`__init__`), vamos implementar a base do formato do nosso registrador de logs. Então, o método será assim:

{% highlight python linenos %}

def __init__(self, filename=FILENAME, datefmt=DATE_FORMAT):
        self.filename = filename
        self.date_format = datefmt
        self.formated = "%(levelname)s:[%(asctime)s]: %(message)s"

        self.levels = {
            "exception": logging.exception,
            "info": logging.info,
            "warning": logging.warning,
            "error": logging.error,
            "debug": logging.debug,
            "critical": logging.critical
        }

{% endhighlight %}

Analisando nosso `__init__`, temos 2 (dois) parâmetros no mesmo, o `filename` e `datefmt`. O `filaname` está recebendo por padrão, o valor da  variável de classe **FILENAME**, assim como o `datefmt` também. Implementamos essas parâmetros justamente para o programador mudar o local de onde o registro de logs será salvo e caso queira mudar o formato da data conforme a localidade em que está.

O `self.formated`, está recebendo um [formato](https://docs.python.org/pt-br/3.9/library/logging.html?highlight=logging#formatter-objects){:target="_blank"} em que o módulo `logging` do Python suporta. Ele pode ter outras opções, mas neste nosso caso implementamos 3, que são:

* levelname - Registra o level do log.
* asctime - Registra a data e hora do log.
* message - Registra uma mensagem que será passada por parâmetro.

O `self.levels` é um dicionário que está carregando os levels de log do módulo `logging`, é muito importante observar que estamos carregando os levels sem ser **Callable**.

## Método de registrar os logs

Agora começa a nossa brincadeira, esté método que será responsável por armazenar toda nossa lógica para registrar os logs.


Vou implementar ele, e abaixo dele vou explicar o que cada condição e lógica faz:

{% highlight python linenos %}

def record(self, msg, *args, exc_info=True, type="exception", colorize=False,
          **kwargs):
        for item in self.levels.keys():
            if item == type:
                if not colorize:
                    formated = self.formated
                else:
                    if item == "warning":
                        formated = (
                            f"{self.YELLOW}%(levelname)s:{self.GREEN}[%(asctime)s]"
                            f"{self.NONE}: %(message)s"
                        )
                    elif item == "error" or item == "exception":
                        formated = (
                            f"{self.RED}%(levelname)s:{self.GREEN}[%(asctime)s]"
                            f"{self.NONE}: %(message)s"
                        )
                    else:
                        formated = (
                            f"{self.CYAN}%(levelname)s:{self.GREEN}[%(asctime)s]"
                            f"{self.NONE}: %(message)s"
                        )
                logging.basicConfig(filename=self.filename, format=formated,
                                    datefmt=self.date_format, level=logging.INFO)
                if item == "exception":
                    return self.levels[item](msg, *args, exc_info=exc_info,
                                             **kwargs)
                else:
                    return self.levels[item](msg, *args, **kwargs)
        raise ValueError(
            f'Error implementing the method "{self.record.__name__}" in class Logs.'
            )

{% endhighlight %}

### Na linha `1` à `2`

Podemos observar que temos alguns parâmetros no método `record`, eles são:

* message - Este parâmetro é obrigatório, é nele que iremos colocar nossa mensagem de log.
* type - Este parâmetro nomeado está como padrão o valor de uma string **exception**, isso significa que quando formos criar um log, se não especificarmos o level que queremos de acordo com nosso dicionário `self.levels`, irá ser registrado no level `exception`.
* colorize - Parâmetro booleano que se estiver `True`, nossos logs serão coloridos.

> NOTA: O log só será mostrado colorido se carregarmos o arquivo de log pelo terminal, então, tenha em mente que se usar cores, será chato ler esse arquivo em um editor de texto, por exemplo.

Os parâmetros **exc_info**, **\*args** e **\*\*kwargs**, estão sendo implementados porque as funções de level do módulo `logging`, **exception** e **error**, contem esses parâmetro também, e como nosso método `record` está sendo implementado em cima dessas funções de level, é necessário atribuir os mesmos argumentos.

### Na linha `3` à `4`

Fazemos um `for` e nele contendo nossa primeira condição de `if`, que faz uma atribuição de igualdade do tipo de level que irá ser usado através do parâmetro `type`.

### Na linha `5` à `22`

Fazemos outra condição `if`, porem booleana. Se o parâmetro `colorize` for **False**, então carregamos o formado padrão do nosso log especificado no método `__init__`, ou seja, carregamos o `self.formated`. Caso a condição seja `else`, carregamos outra condição de igualdade para verificar os levels e atribuir cores diferentes para cada um deles. Por exemplo, o level de **Warning** receberá a cor *amarela*, o de **Error** e **Exception**, a cor *vermelha*, já o de **Debug**, **Info** e demais, receberão a cor *cyan*.

### Na linha `23` à `24`

Aqui estamos aplicando as configuração básicas para nosso registro de logs através da função `basicConfig` do módulo `logging`. Repara que temos o parâmetro `level` e estamos passando o level `INFO`. Precisamos passando algum level para este parâmetro, senão não conseguimos criar nossos registros de log.

### Na linha `25` à `29`

Nessas linhas estamos pegando os levels do meu dicionário e aplicando um *Callable* com os parâmetros necessários. Estamos atribuindo uma condição e, se for do level **exception**, irá carregar um parâmetro a mais, o `exc_info`.

### Na linha `30` à `32`

Caso aconteça de não cair em nenhum retorno (`return`) irá disparar uma **raise** que imprimirá uma mensagem ao usuário de erro de implementação do método.

## Código completo

Depois de destrinchar nosso código por partes, obtemos o seguinte resultado do mesmo completo:

{% highlight python linenos %}

import logging
from sys import platform


def unix_color(value):
    if platform.startswith("win"):
        return ""
    return value


class Colors:
    NONE = unix_color("\x1b[0m")
    BLACK = unix_color("\x1b[30m")
    MAGENTA = unix_color("\x1b[95m")
    BLUE = unix_color("\x1b[94m")
    GREEN = unix_color("\x1b[92m")
    RED = unix_color("\x1b[91m")
    YELLOW = unix_color("\x1b[93m")
    CYAN = unix_color("\x1b[96m")
    WHITE = unix_color("\x1b[97m")


class Logs(Colors):

    FILENAME = "mylogs.log"
    DATE_FORMAT = "%m/%d/%Y %I:%M:%S %p"

    def __init__(self, filename=FILENAME, datefmt=DATE_FORMAT):
        self.filename = filename
        self.date_format = datefmt
        self.formated = "%(levelname)s:[%(asctime)s]: %(message)s"

        self.levels = {
            "exception": logging.exception,
            "info": logging.info,
            "warning": logging.warning,
            "error": logging.error,
            "debug": logging.debug,
            "critical": logging.critical
        }

    def record(self, msg, *args, exc_info=True, type="exception", colorize=False,
               **kwargs):
        for item in self.levels.keys():
            if item == type:
                if not colorize:
                    formated = self.formated
                else:
                    if item == "warning":
                        formated = (
                            f"{self.YELLOW}%(levelname)s:{self.GREEN}[%(asctime)s]"
                            f"{self.NONE}: %(message)s"
                        )
                    elif item == "error" or item == "exception":
                        formated = (
                            f"{self.RED}%(levelname)s:{self.GREEN}[%(asctime)s]"
                            f"{self.NONE}: %(message)s"
                        )
                    else:
                        formated = (
                            f"{self.CYAN}%(levelname)s:{self.GREEN}[%(asctime)s]"
                            f"{self.NONE}: %(message)s"
                        )
                logging.basicConfig(filename=self.filename, format=formated,
                                    datefmt=self.date_format, level=logging.INFO)
                if item == "exception":
                    return self.levels[item](msg, *args, exc_info=exc_info,
                                             **kwargs)
                else:
                    return self.levels[item](msg, *args, **kwargs)
        raise ValueError(
            f'Error implementing the method "{self.record.__name__}" in class Logs.'
        )


{% endhighlight %}


## Como usar?

Para fazer o uso é muito fácil, apenas instancie a classe e passe os parâmetros necessários, e chamando a criação de logs através de **try/except**.

Vamos fazer isso em um arquivo externo, criando com o nome de **setup.py** no mesmo diretório do **logger.py**:

{% highlight shell %}

touch setup.py

{% endhighlight %}

Agora vamos popular esse arquivo com o seguinte código:

{% highlight python linenos %}

from logger import Logs

if __name__ == "__main__":
    logs = Logs(filename="calcs.log")
    try:
        n1 = int(input("Digite o dividendo: "))
        n2 = int(input("Digite o divisor: "))
        result = f"O quociente é: {n1 / n2}"
        logs.record(result, type="info", colorize=True)
        print(result)
    except ZeroDivisionError as text:
        logs.record(text, colorize=True)
        raise

{% endhighlight %}


Observe que está sendo atribuindo o registro de logs no **try** e no **except** porem, cada um deles com suas características.

No **try**, está sendo registrado um log apenas de informação, passando o valor **info** para parâmetro `type`, onde a mensagem gravada é o resultado da divisão.

No **exception**, não temos o parâmetro `type` porque será registrado uma exceção de erro, e o valor de `type` por padrão é uma *exception*. Esta sendo gravado o texto de erro por divisão por zero (que não existe). Também usamos a palavrão `raise`, para estourar o erro na tela também. Se tirarmos, apenas registrará o log.


## Conclusão


Esse foi um simples post com intuito de te dar um base de orientação sobre gravar registros de logs com Python. Lembre-se que isso não é tudo, você pode ver mais detalhes na documentação. Você pode acessar nos links abaixo que vou deixar. Espero que tenha gostado e até a próxima. :)

> Nota: Sempre veja a versão da documentação antes de estudar.

**Documentação:**

* [https://docs.python.org/pt-br/3/library/logging.html](https://docs.python.org/pt-br/3/library/logging.html)


**Ao som de:**

{% jektify spotify/track/7ECZGiOoEPSxnPBU25Tc3f/dark %}

{% endpost #9D9D9D %}
