---
layout: post
title: "Criando pendrive bootavel no Linux com dd"
description: |
    Não há nada mais precário que ficar comprando CD/DVD para gravar uma distribuição Linux, ou
    aquele outro sistema operacial no qual necessita de boot. Vamos aprenda a fazer isso no Linux
    com um comando poderoso.
author: "William C. Canin"
date: 2015-04-21 18:42:04 -0300
update_date:
comments: true
tags: [dd,linux,iso,pendrive]
---


# Gravando uma ISO no pendrive com `dd` (forma correta, rápida e segura)

Esqueça CDs, DVDs e até muitos programas gráficos. No Linux, você já tem uma ferramenta poderosa instalada por padrão que faz isso de forma direta, confiável e muito mais rápida: **`dd`**.

Este guia mostra a **maneira correta** de gravar uma imagem ISO em um pendrive para que ele seja inicializável (bootável), explicando as *flags* que realmente fazem diferença — inclusive as que quase nenhum tutorial comenta.

---

## ⚠️ Antes de começar (leia isso!)

- **Todo o conteúdo do pendrive será apagado.** Faça backup se necessário.
- Você **não precisa formatar** o pendrive antes. A ISO já contém tabela de partições e sistema de arquivos próprios.
- Um erro no dispositivo (`/dev/sdX`) pode apagar seu HD. **Confirme com cuidado.**

{% include details summary="Se você já viu tutoriais mandando usar `mkfs` antes: isso é desnecessário para ISOs bootáveis e pode até atrapalhar." %}

Uma ISO bootável moderna **não é um “arquivo para copiar dentro de um pendrive”** — ela já é **uma imagem completa de disco**.

Ferramentas como `dd` não “copiam arquivos”. Elas **clonam byte a byte** a estrutura que já está dentro da ISO para o dispositivo.

Muitas ISOs (como a do Arch Linux, Ubuntu, Debian, Fedora) são do tipo **isohybrid**. Isso significa que a ISO já contém:

- Tabela de partições (MBR e/ou GPT)
- Sistema de arquivos (geralmente ISO9660 + El Torito + às vezes FAT para UEFI)
- Estrutura de boot BIOS e UEFI
- Layout exato de setores que o firmware espera

Quando você roda `mkfs` antes, você escreve **outra** tabela de partições e **outro** sistema de arquivos no pendrive.

**O que acontece então?**

1 - `mkfs` grava:

  - Nova tabela de partições
  - Novo filesystem (FAT, por exemplo)

2 - Depois o `dd` grava a ISO por cima, setor a setor.

O resultado é:

* A ISO **destrói** o que o `mkfs` fez
* Mas o kernel, o udisks, e até o firmware podem ter **metadados em cache** daquela formatação anterior
* Isso pode gerar:
  - Pendrive que “some” depois da gravação
  - Tabela de partições “*fantasma*” aparecendo no `lsblk`
  - Mensagens tipo “*device contains a valid partition table*” conflitantes
  - Sistemas que se recusam a montar depois
  - UEFI não reconhecendo corretamente em alguns firmwares mais chatos

Ou seja: você cria **lixo estrutural temporário** que a ISO vai sobrescrever logo depois — mas o sistema já “viu” aquilo.

**O ponto principal**

`mkfs` é para preparar um dispositivo para armazenar arquivos.

`dd` com ISO é para transformar o dispositivo **na própria mídia original**.

São objetivos opostos.

É como:

> formatar um HD para depois clonar uma imagem de outro HD por cima — a formatação não só é inútil, como pode confundir ferramentas do sistema.

Regra prática

* Vai usar pendrive como armazenamento? → `mkfs`
* Vai transformar pendrive em mídia de instalação? → NUNCA `mkfs`

{% include enddetails %}


---

## 1) Descobrir qual é o dispositivo do pendrive

Conecte o pendrive e rode:

```bash
lsblk
```

Você verá algo assim:

```
sda      500G
└─sda1
sdd       16G
└─sdd1
```

O pendrive costuma ser o menor dispositivo. No exemplo acima, é o **`/dev/sdd`**.

> Use sempre o **dispositivo inteiro** (`/dev/sdd`), **não** a partição (`/dev/sdd1`).

---

## 2) Desmontar o pendrive

Se o sistema montou automaticamente:

```bash
sudo umount /dev/sdd*
```

---

## 3) O comando correto com `dd`

Aqui está a forma recomendada:

```bash
sudo dd if=~/Downloads/archlinux-x86_64.iso of=/dev/sdd bs=16M oflag=direct status=progress && sync
```

Substitua `arch.iso` pelo nome da sua imagem.

---

## Entendendo as flags importantes

### `bs=16M`

Define o tamanho do bloco que o `dd` lê/escreve por operação.

- Padrão do `dd`: **512 bytes** (muito lento)
- `16M`: escreve 16 megabytes por vez

Resultado: gravação **muito mais rápida** com menos overhead do sistema.

Valores entre **4M e 32M** funcionam bem. `16M` é um ótimo equilíbrio.

---

### `oflag=direct` (o segredo que quase ninguém usa)

Sem essa flag, o Linux usa cache em RAM:

```
dd → RAM → kernel grava depois no pendrive
```

O `dd` pode terminar… mas o pendrive **ainda está sendo gravado** em segundo plano.

Com `oflag=direct`:

```
dd → pendrive diretamente (sem cache)
```

Isso garante que:

- A gravação é **real**
- O progresso mostrado é verdadeiro
- Quando termina, terminou mesmo

---

### `status=progress`

Mostra o andamento em tempo real.

---

### `sync` no final

Garante que qualquer dado pendente seja finalizado antes de remover o pendrive.

---

## O que você NÃO deve fazer (erro comum)

Muitos tutoriais ensinam a **formatar o pendrive com `mkfs` antes**. Isso está **errado** para ISOs bootáveis.

A ISO já possui:

- Tabela de partições
- Sistema de arquivos
- Estrutura de boot

Formatar antes é desnecessário e pode até causar problemas.

---

## Resumo do comando ideal

```bash
sudo dd if=imagem.iso of=/dev/sdX bs=16M oflag=direct status=progress && sync
```

Troque apenas:

- `imagem.iso`
- `/dev/sdX`

---

## Quer saber mais?

```bash
man dd
dd --help
```

---

Agora você pode gravar qualquer ISO bootável no pendrive **da forma correta, rápida e segura**, usando apenas o que já vem no seu Linux.



