---
layout: post
title: "Como encurtar URL Raw do Github e ter uma url personalizada"
description: |
  Cansado de compartilhar URL Raw do Github compridas? Lendo essa postagem você vai contornar isso.
author: "William C. Canin"
date: 2019-10-20 13:49:01 -0300
update_date: 2026-03-30 23:29:11 -0300
comments: false
tags: [kutt,url,shortener,shorter]
---


Olá, tudo joinha? Nesse post vou demonstrar como você pode deixar as URLs RAW do [**Github**](https://github.com){:target="_blank"} bem mais encurtadas e com um nome personalizado. Vamos lá.

> **Nota:** Este post foi atualizado. O serviço **git.io**, que era usado originalmente aqui, foi descontinuado pelo GitHub em 2022. O substituto recomendado é o [**kutt.to**](https://kutt.to){:target="_blank"} — open source, gratuito e com suporte a slugs personalizados via API.

---

## O que você vai precisar

- [**curl**](https://curl.se/){:target="_blank"} instalado na sua máquina
- Uma conta gratuita no [**kutt.to**](https://kutt.to){:target="_blank"} para obter a API key

> O curl está disponível em praticamente todos os sistemas operacionais. Sinta-se à vontade para instalá-lo da maneira que mais lhe convém.

---

## Obtendo sua API key no kutt.to

1. Acesse [kutt.to](https://kutt.to){:target="_blank"} e crie uma conta gratuita
2. Após o login, vá em **Settings** (configurações)
3. Na seção **API Keys**, gere uma nova chave
4. Copie e guarde sua chave — ela será usada em todos os comandos abaixo

---

## Encurtando com URL personalizada

A sintaxe para criar uma URL encurtada com nome personalizável é:

{% highlight bash %}
$ curl -X POST "https://kutt.to/api/v2/links" \
  -H "X-API-Key: SUA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"target": "URL_ORIGINAL_RAW", "customurl": "NOME_DESEJADO"}'
{% endhighlight %}

- Em **SUA_API_KEY** coloque a chave gerada no painel do kutt.to
- Em **URL_ORIGINAL_RAW** coloque a URL original completa, incluindo o `https://`
- Em **NOME_DESEJADO** escolha um slug único para sua URL

> **Nota:** O slug deve ser único no serviço. Se já estiver em uso, a API retorna um erro informando isso.

---

## Exemplo prático

**Comando:**

{% highlight bash %}
$ curl -X POST "https://kutt.to/api/v2/links" \
  -H "X-API-Key: abc123minha_chave" \
  -H "Content-Type: application/json" \
  -d '{"target": "https://raw.githubusercontent.com/my_user/my_project/master/scriptizinho.py", "customurl": "scriptizinho"}'
{% endhighlight %}

**Saída do comando:**

{% highlight json linenos %}
{
  "id": "d8f3a1b2c4",
  "target": "https://raw.githubusercontent.com/my_user/my_project/master/scriptizinho.py",
  "shortUrl": "https://kutt.to/scriptizinho",
  "customurl": "scriptizinho",
  "password": false,
  "reuse": false,
  "visit_count": 0,
  "created_at": "2025-10-29T17:20:44.000Z",
  "updated_at": "2025-10-29T17:20:44.000Z"
}
{% endhighlight %}

Se tudo correu bem, a resposta virá com o campo `shortUrl` contendo sua nova URL personalizada:

```
https://kutt.to/scriptizinho
```

---

## Encurtando sem slug personalizado

Se quiser deixar o serviço escolher o código automaticamente, basta remover o campo `customurl` do JSON:

{% highlight bash %}
$ curl -X POST "https://kutt.to/api/v2/links" \
  -H "X-API-Key: SUA_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"target": "https://raw.githubusercontent.com/my_user/my_project/master/scriptizinho.py"}'
{% endhighlight %}

A saída será semelhante, mas com um `shortUrl` gerado automaticamente:

```
https://kutt.to/dfsds4r
```

---

## Diferenças para o git.io (para quem usava antes)

| | git.io (descontinuado) | kutt.to |
|---|---|---|
| Autenticação | Nenhuma | API key obrigatória |
| Formato da requisição | `multipart/form-data` | JSON |
| Slug personalizado | `-F "code=NOME"` | `"customurl": "NOME"` |
| Resposta | Headers HTTP | JSON estruturado |
| Status | Desativado em 2022 | Ativo e open source |

---

Eu fico por aqui, espero que tenha te ajudado. Abraços!
