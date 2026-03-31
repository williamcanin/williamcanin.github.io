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

Antes de vender, descartar ou reutilizar um disco, apagar os arquivos não é suficiente — os dados continuam lá e podem ser recuperados. O zero fill resolve isso: ele sobrescreve todo o disco com zeros (ou padrões de bits), tornando a recuperação inviável sem equipamento especializado. Neste post vou mostrar os principais métodos para fazer isso no Linux, do mais seguro ao mais rápido, cobrindo HDD, SSD e NVMe.

---

## Antes de começar — identificando o disco certo

Nunca rode zero fill no disco errado. Use esses comandos para identificar o alvo:

```bash
lsblk
```

ou com mais detalhes:

```bash
sudo fdisk -l
```

Procure pelo tamanho e modelo. O disco alvo vai aparecer como `/dev/sdb`, `/dev/sdc`, `/dev/nvme0n1`, etc. **Nunca use o disco onde o sistema está rodando.**

---

## Método 1 — `badblocks` (recomendado: seguro + verificação automática)

O `badblocks` é a opção mais completa para HDDs. Além de zerar, ele verifica se o disco consegue ler e gravar corretamente em cada setor.

```bash
sudo badblocks -wsv /dev/sdX
```

Substitua `sdX` pelo seu disco (ex: `sdb`).

**Explicando os parâmetros:**

| Parâmetro | Função |
|-----------|--------|
| `-w` | Modo de escrita — faz o zero fill (e outros padrões de teste) |
| `-s` | Mostra o progresso em tempo real |
| `-v` | Modo detalhado (verbose) |
| `/dev/sdX` | Disco alvo, **sem** número de partição (ex: `/dev/sdb`, não `/dev/sdb1`) |

**O que esse comando faz na prática:**

1. Escreve padrões de teste no disco (zeros, uns, padrões alternados)
2. Lê cada setor de volta e verifica se gravou corretamente
3. Reporta setores defeituosos encontrados

É mais lento que o `dd`, mas é o método mais confiável para saber a saúde real do disco antes de reutilizá-lo.

**Tempo estimado:**

Para um HDD de 500 GB via USB 3.0, espere entre 2 e 4 horas. Discos com setores problemáticos podem demorar mais, pois o `badblocks` tenta cada setor com falha várias vezes antes de desistir.

---

## Método 2 — `dd` (rápido, sem verificação)

Se o objetivo é só zerar o disco com velocidade, sem checar setores:

```bash
sudo dd if=/dev/zero of=/dev/sdX bs=8M status=progress oflag=direct
```

**Explicando os parâmetros:**

| Parâmetro | Função |
|-----------|--------|
| `if=/dev/zero` | Fonte de zeros infinitos |
| `of=/dev/sdX` | Disco de destino |
| `bs=8M` | Blocos de 8 MB — mais velocidade que o padrão de 512 bytes |
| `status=progress` | Mostra velocidade e progresso em tempo real |
| `oflag=direct` | Grava direto no disco, ignorando o cache do sistema — mais rápido e confiável |

Esse método não detecta problemas de leitura/gravação. Use quando precisar de velocidade e já souber que o disco está saudável.

---

## Método 3 — `shred` (múltiplas passagens, ideal para descarte seguro)

O `shred` é a melhor escolha quando o disco vai ser descartado ou vendido e você quer garantir que os dados não sejam recuperáveis. Ele sobrescreve o disco com múltiplas passagens de dados aleatórios.

```bash
sudo shred -vfz -n 3 /dev/sdX
```

**Explicando os parâmetros:**

| Parâmetro | Função |
|-----------|--------|
| `-v` | Mostra o progresso |
| `-f` | Força a permissão de escrita se necessário |
| `-z` | Adiciona uma passagem final de zeros (oculta que o shred foi usado) |
| `-n 3` | Número de passagens com dados aleatórios (padrão: 3) |

> **Atenção para SSDs:** O `shred` e o `badblocks` **não são eficazes em SSDs e NVMe** da mesma forma que em HDDs. Por causa do wear leveling (nivelamento de desgaste), o controlador do SSD pode redirecionar gravações para outros blocos, deixando dados antigos intactos em setores não mapeados. Veja o método específico para SSDs abaixo.

---

## Método 4 — SSDs e NVMe: `nvme sanitize` ou `blkdiscard`

Para SSDs SATA e NVMe, o método correto é usar comandos que falam diretamente com o controlador do disco.

### NVMe — `nvme sanitize` (recomendado)

```bash
sudo nvme sanitize /dev/nvme0n1 -a 2
```

O `-a 2` indica "Block Erase" — apagamento a nível de bloco de flash, o mais seguro para NVMe. Verifique o progresso com:

```bash
sudo nvme sanitize-log /dev/nvme0n1
```

### SSD SATA — `hdparm` com Secure Erase

Primeiro verifique se o disco suporta o recurso:

```bash
sudo hdparm -I /dev/sdX | grep -i erase
```

Se aparecer "supported", defina uma senha temporária e execute o apagamento seguro:

```bash
sudo hdparm --user-master u --security-set-pass senha123 /dev/sdX
sudo hdparm --user-master u --security-erase senha123 /dev/sdX
```

Isso envia um comando direto ao firmware do SSD para apagar todos os blocos, incluindo os realocados pelo wear leveling.

### Alternativa rápida — `blkdiscard`

```bash
sudo blkdiscard /dev/sdX
```

Envia um comando TRIM para todo o disco, marcando todos os blocos como livres. É instantâneo, mas o nível de segurança depende da implementação do firmware de cada fabricante.

---

## Método 5 — Ferramenta oficial da Seagate (SeaTools Bootable)

Para quem prefere usar a ferramenta do fabricante:

1. Baixe o SeaTools Bootable (imagem ISO) em: [seagate.com/support/downloads/seatools](https://www.seagate.com/support/downloads/seatools/)
2. Grave num pendrive com balenaEtcher ou Rufus
3. Inicialize o PC pelo pendrive
4. Use a opção **"Erase Disk (Full Erase)"**

Essa opção faz o zero fill diretamente via firmware, sem depender do sistema operacional. É 100% segura e aprovada pelo fabricante. Útil quando você quer um laudo visual do processo ou não tem confiança em linha de comando.

---

## Após o zero fill — recriando a tabela de partições

Depois que o processo terminar, o disco estará completamente zerado, sem partições ou sistema de arquivos. Para reutilizá-lo, crie uma nova tabela de partições.

**Via terminal com `fdisk`:**

```bash
sudo fdisk /dev/sdX
```

Dentro do `fdisk`:
- `g` → cria tabela GPT (recomendado para discos modernos e > 2 TB)
- `o` → cria tabela MBR (para compatibilidade com sistemas mais antigos)
- `n` → cria nova partição
- `w` → grava as alterações

**Via interface gráfica com `gnome-disks`:**

```bash
gnome-disks
```

Selecione o disco → **"Formatar Disco…"** → **"Apagar"** → **"Zerar (lento, seguro)"** ou apenas criar nova tabela de partições diretamente.

---

## Comparativo rápido dos métodos

| Método | Velocidade | Verifica setores | Eficaz em SSD/NVMe | Ideal para |
|--------|-----------|-----------------|-------------------|------------|
| `badblocks -wsv` | Lento | ✅ Sim | ❌ Não | HDDs com suspeita de defeitos |
| `dd` | Rápido | ❌ Não | ❌ Parcial | Zeragem rápida de HDDs |
| `shred` | Lento | ❌ Não | ❌ Não | Descarte seguro de HDDs |
| `nvme sanitize` | Rápido | ✅ Firmware | ✅ Sim | NVMe |
| `hdparm secure-erase` | Rápido | ✅ Firmware | ✅ Sim | SSDs SATA |
| `blkdiscard` | Instantâneo | ❌ Não | ✅ Sim | Reutilização rápida de SSDs |
| SeaTools | Variável | ✅ Sim | ⚠️ Depende | Discos Seagate, uso visual |

---

Escolha o método de acordo com o destino do disco: para reutilização interna, `dd` ou `blkdiscard` resolvem rápido; para venda ou descarte, prefira `shred`, `nvme sanitize` ou `hdparm secure-erase`; para diagnóstico de saúde do disco, o `badblocks` ainda é o mais completo.
