---
layout: post
author: "William C. Canin"
title: "Fazendo zero fill em HDD/SSD com Linux"
description: "Aprenda a fazer zero fill em seus HDD ou SSD usando Linux"
date: 2025-10-29 17:20:44 -0300
update_date:
comments: false
tags: [zerofill, linux, dd, badblocks]
---

MÉTODO RECOMENDADO: badblocks (seguro + verificação automática)
🔹 Comando:
sudo badblocks -wsv /dev/sdX


Substitua sdX pelo seu disco (ex: sdb).

🧩 Explicando:

-w → modo de escrita (write-mode), faz zero fill (e outros padrões);

-s → mostra o progresso;

-v → modo detalhado (verbose);

/dev/sdX → disco alvo, sem número de partição (ex: /dev/sdb, não /dev/sdb1).

Esse comando:

Escreve padrões de teste no disco (zeros, uns, padrões aleatórios);

Lê de volta e verifica se gravou corretamente;

É mais lento que dd, mas detecta setores defeituosos automaticamente.

🕐 Tempo estimado

Para um HDD de 500 GB via USB 3.0:

Leva de 2 a 4 horas normalmente;

Pode demorar mais se o disco tiver setores problemáticos.


MÉTODO ALTERNATIVO: dd (mais rápido, sem verificação)

Se você quer só zerar rápido, sem checar setores:

sudo dd if=/dev/zero of=/dev/sdX bs=8M status=progress oflag=direct


Explicando os extras:

bs=8M → blocos maiores → mais velocidade;

oflag=direct → grava direto no disco, evitando cache (mais rápido e confiável).

Esse método é rápido, mas não detecta problemas de leitura/gravação.


MÉTODO OPCIONAL: ferramenta da Seagate (via Linux ou Windows)

Se quiser usar ferramenta oficial da Seagate:

Baixe SeaTools Bootable (imagem ISO da Seagate);

Grave num pendrive (balenaEtcher ou Rufus);

Inicialize o PC por ele e use a opção:

“Erase Disk (Full Erase)” — faz exatamente o zero fill no hardware.

Link (pode abrir no navegador):
👉 https://www.seagate.com/support/downloads/seatools/

Essa opção é 100% segura e aprovada pelo fabricante.


Dica final

Depois que terminar:

sudo fdisk /dev/sdX


→ apague partições antigas e crie uma nova tabela (g → GPT ou o → MBR).

Ou use interface gráfica:

gnome-disks


→ Selecione o disco → “Formatar Disco…” → “Apagar” → “Zerar (lento, seguro)”.
