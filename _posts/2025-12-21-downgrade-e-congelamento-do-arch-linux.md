---
layout: post
author: "William C. Canin"
title: "Downgrade e Congelamento do Arch Linux com Snapshot específico"
description: "Faça o downgrade e congelamento do Arch Linux para sua máquina antiga"
date: 2025-12-21 17:07:13 -0300
update_date: 
comments: false
tags: [nvidia, archlinux]
---


# Downgrade e Congelamento do Arch Linux com Snapshot específico

Este guia mostra **como voltar todo o sistema Arch Linux para o estado exato do dia 30/12/2024** usando o archive oficial e depois **congelar o sistema** para evitar novos conflitos de versões (especialmente com drivers NVIDIA, kernel e Xorg).

> ⚠️ Isso NÃO é apenas remover pacotes. Você vai alinhar o sistema inteiro ao estado daquele dia.

---

## ✅ 1) Ajustar o mirror para o snapshot antigo

Edite o arquivo de mirrors:

```bash
sudo nano /etc/pacman.d/mirrorlist
```

Apague TODO o conteúdo e deixe apenas:

```
Server = https://archive.archlinux.org/repos/2024/12/30/$repo/os/$arch
```

Salve e feche.

---

## ✅ 2) Limpar totalmente o cache do pacman

Isso é **obrigatório**. Seu cache tem pacotes mais novos (2025/2026) que causam conflitos.

```bash
sudo rm -rf /var/cache/pacman/pkg/*
```

---

## ✅ 3) Forçar sincronização com downgrade do sistema inteiro

Esse é o passo mais importante.

```bash
sudo pacman -Syyuu
```

O `uu` força o **downgrade** de tudo que estiver mais novo que 30/12/2024:

* kernel
* xorg
* bibliotecas
* glvnd
* systemd
* mesa
* tudo

Seu sistema vai literalmente "voltar no tempo".

> Durante esse processo, responda **S** para substituir pacotes quando perguntado.

---

## ✅ 4) Reinicie a máquina

```bash
sudo reboot
```

---

## ✅ 5) Verifique se o sistema está alinhado com a data

Após reiniciar:

```bash
uname -r
pacman -Q xorg-server
```

As versões agora devem ser de **final de 2024**.

---

## ✅ 6) Instalar o driver NVIDIA corretamente (já compatível)

Agora que tudo está alinhado:

```bash
sudo pacman -S nvidia nvidia-utils nvidia-settings
```

Sem baixar manualmente. Sem procurar versão. Vai funcionar porque o sistema inteiro é daquele dia.

---

## 🔒 7) Congelar o Arch (muito importante)

Se você rodar `pacman -Syu` com mirrors atuais, vai quebrar tudo de novo.

Para evitar isso:

Edite:

```bash
sudo nano /etc/pacman.conf
```

Adicione no final:

```
IgnorePkg = nvidia nvidia-utils xorg-server linux linux-headers mesa libglvnd systemd
```

---

## 🧊 8) Regra de ouro a partir de agora

Sempre que for atualizar, use **apenas** esse mirror congelado.

Nunca restaure os mirrors oficiais sem saber exatamente o que está fazendo.

---

## 🧠 O que esse processo resolve

Elimina o problema clássico de:

* kernel novo + xorg antigo
* libs novas + driver antigo
* partial upgrade (o maior inimigo do Arch)

Agora seu sistema é um **Arch estável congelado no tempo**.

---

## 📝 Resumo rápido

```bash
sudo nano /etc/pacman.d/mirrorlist
# colocar o server do archive

sudo rm -rf /var/cache/pacman/pkg/*

sudo pacman -Syyuu

sudo reboot

sudo pacman -S nvidia nvidia-utils nvidia-settings
```

Pronto. Sistema alinhado, funcional e congelado em 30/12/2024.
