---
layout: post
author: "William C. Vanin"
title: "Nvidia auto-rebuild no Arch Linux com Wayland"
description: "Description of your post"
date: 2026-03-30 22:59:10 -0300
update_date: 
comments: false
tags: [nvidia, archlinux]
---

# NVIDIA `.run` auto-rebuild no boot — Arch Linux + Wayland (instalação manual)

Se você usa Arch Linux com Wayland e instala o driver da NVIDIA via `.run` oficial, já deve ter sofrido com a tela preta depois de uma atualização de kernel. O motivo é simples: o instalador `.run` da NVIDIA **não pode rodar com Wayland ou Xorg ativos**, e os hooks do pacman executam justamente nesse momento.

A solução é recompilar o driver **antes** do ambiente gráfico subir — ou seja, no boot, dentro do `sysinit.target` do systemd. Neste post vou mostrar como montar isso do zero, manualmente.

---

## Como funciona

O fluxo completo após a configuração:

```
pacman atualiza kernel
        ↓
hook marca /var/lib/nvidia-reinstall-required
        ↓
reboot
        ↓
systemd (sysinit.target)
        ↓
nvidia-rebuild.service
        ↓
nvidia-rebuild.sh
        ↓
.run --dkms recompila o módulo
        ↓
mkinitcpio -P
        ↓
Wayland inicia já com o driver correto
```

---

## Requisitos

- Arch Linux
- Kernel `linux-lts` e `linux-lts-headers` instalados
- Driver NVIDIA instalado via `.run` com suporte a `--dkms`

Nota: Eu uso o "`linux-lts`", se você usa outro kernel, faça baseado no que você usa.

---

## Passo 1 — Baixar o driver `.run` oficial

Crie um diretório organizado para o instalador:

```bash
sudo mkdir -p /opt/NVIDIA-Linux-x86_64-580.126.18
```

Baixe o driver oficial:

```bash
sudo curl -L "https://download.nvidia.com/XFree86/Linux-x86_64/NVIDIA-Linux-x86_64-580.126.18.run" \
  -o "/opt/NVIDIA-Linux-x86_64-580.126.18/NVIDIA-Linux-x86_64-580.126.18.run"
```

Torne-o executável:

```bash
sudo chmod +x /opt/NVIDIA-Linux-x86_64-580.126.18/NVIDIA-Linux-x86_64-580.126.18.run
```

> **Nota:** Para usar outra versão do driver, substitua `580.126.18` pela versão desejada em todos os passos a seguir.

---

## Passo 2 — Criar o hook do pacman

O hook é responsável por "marcar" que o driver precisa ser recompilado sempre que o kernel ou os headers forem atualizados.

Certifique-se de que o diretório existe:

```bash
sudo mkdir -p /etc/pacman.d/hooks
```

Crie o arquivo `/etc/pacman.d/hooks/nvidia-rebuild.hook`:

```ini
[Trigger]
Operation = Install
Operation = Upgrade
Type = Package
Target = linux-lts
Target = linux-lts-headers

[Action]
Description = Marcando reinstalação do driver NVIDIA (.run) após update do kernel
When = PostTransaction
Exec = /usr/bin/touch /var/lib/nvidia-reinstall-required
```

Ele apenas cria o arquivo de flag `/var/lib/nvidia-reinstall-required`. Nenhuma compilação acontece aqui.

---

## Passo 3 — Criar o script de rebuild

Este é o script que faz o trabalho pesado: descarrega os módulos da NVIDIA, roda o instalador `.run` com DKMS e recria o initramfs.

Crie o arquivo `/usr/local/bin/nvidia-rebuild.sh`:

```bash
#!/bin/bash
set -e

FLAG="/var/lib/nvidia-reinstall-required"
LOG="/var/log/nvidia-rebuild.log"
DRIVER="/opt/NVIDIA-Linux-x86_64-580.126.18/NVIDIA-Linux-x86_64-580.126.18.run"

# Só roda se o hook marcou
[ -f "$FLAG" ] || exit 0

echo "==== NVIDIA REBUILD $(date) ====" >> "$LOG"

# Garante que nada da nvidia está carregado (segurança)
modprobe -r nvidia_drm nvidia_modeset nvidia || true

echo "-> Instalando driver..." >> "$LOG"
$DRIVER -s --dkms --no-questions >> "$LOG" 2>&1

echo "-> Recriando initramfs..." >> "$LOG"
mkinitcpio -P >> "$LOG" 2>&1

rm -f "$FLAG"
echo "==== NVIDIA OK ====" >> "$LOG"
```

Torne-o executável:

```bash
sudo chmod +x /usr/local/bin/nvidia-rebuild.sh
```

---

## Passo 4 — Criar o serviço systemd

O serviço garante que o script rode **antes** do `sysinit.target` — ou seja, antes de qualquer coisa de vídeo ser inicializada.

Crie o arquivo `/etc/systemd/system/nvidia-rebuild.service`:

```ini
[Unit]
Description=Reinstalar NVIDIA driver se necessário
DefaultDependencies=no
After=local-fs.target
Before=sysinit.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/nvidia-rebuild.sh
TimeoutSec=900

[Install]
WantedBy=sysinit.target
```

Os pontos importantes aqui:

- `DefaultDependencies=no` — remove dependências padrão que poderiam atrasar a execução
- `After=local-fs.target` — garante que o sistema de arquivos local já está montado (o script precisa acessar `/opt` e `/var`)
- `Before=sysinit.target` — roda antes do Wayland/gráfico ter qualquer chance de subir
- `TimeoutSec=900` — 15 minutos de timeout, suficiente para compilações lentas

---

## Passo 5 — Habilitar o serviço

Recarregue o systemd e habilite o serviço:

```bash
sudo systemctl daemon-reload
sudo systemctl enable nvidia-rebuild.service
```

---

## Verificando a instalação

Confirme que os três arquivos estão no lugar:

```bash
ls -la /etc/pacman.d/hooks/nvidia-rebuild.hook
ls -la /etc/systemd/system/nvidia-rebuild.service
ls -lx /usr/local/bin/nvidia-rebuild.sh
```

Verifique se o serviço está habilitado:

```bash
systemctl is-enabled nvidia-rebuild.service
```

---

## Testando sem atualizar o kernel

Para simular o que o hook faria, basta criar o arquivo de flag manualmente e reiniciar:

```bash
sudo touch /var/lib/nvidia-reinstall-required
sudo reboot
```

Após o boot, verifique o log:

```bash
cat /var/log/nvidia-rebuild.log
```

Se tudo correu bem, você verá algo como:

```
==== NVIDIA REBUILD Sex Abr 12 08:23:41 BRT 2025 ====
-> Instalando driver...
-> Recriando initramfs...
==== NVIDIA OK ====
```

---

## Troubleshooting

**O serviço não executou no boot**

```bash
systemctl status nvidia-rebuild.service
journalctl -u nvidia-rebuild.service -b
```

**Erro de compilação DKMS**

Confirme que os headers estão instalados:

```bash
pacman -Qs linux-lts-headers
```

**O `.run` não foi encontrado**

Verifique se o caminho no script bate com onde o arquivo está:

```bash
ls -lh /opt/NVIDIA-Linux-x86_64-580.126.18/NVIDIA-Linux-x86_64-580.126.18.run
```

Edite a variável `DRIVER` em `/usr/local/bin/nvidia-rebuild.sh` se necessário.

**Wayland não sobe após atualização**

```bash
cat /var/log/nvidia-rebuild.log
```

Na grande maioria dos casos o problema é caminho incorreto do `.run` ou headers ausentes.

---

## Atualizando a versão do driver no futuro

Quando uma nova versão do driver sair, o processo é simples:

1. Baixe o novo `.run` para `/opt/NVIDIA-Linux-x86_64-<nova-versão>/`
2. Edite a variável `DRIVER` em `/usr/local/bin/nvidia-rebuild.sh`
3. Crie o flag e reinicie para testar:

```bash
sudo touch /var/lib/nvidia-reinstall-required
sudo reboot
```

---

## Removendo tudo

Caso queira desfazer a configuração:

```bash
sudo systemctl disable nvidia-rebuild.service
sudo rm -f /etc/pacman.d/hooks/nvidia-rebuild.hook
sudo rm -f /etc/systemd/system/nvidia-rebuild.service
sudo rm -f /usr/local/bin/nvidia-rebuild.sh
sudo rm -rf /opt/NVIDIA-Linux-x86_64-580.126.18
sudo systemctl daemon-reload
```

---

## Conclusão

Depois de configurado, o processo é totalmente transparente: o pacman atualiza o kernel, você reinicia, e o GNOME sobe com o driver correto — sem TTY, sem tela preta, sem intervenção manual.

Caso queira o processo automático, você pode ver no repositório [archlinux-nvidia-auto-rebuild](https://github.com/williamcanin/archlinux-nvidia-auto-rebuild){:target="_blank"}. Você terá um script (`init.sh`) que faz a instalação automática, sem precisar seguir esses passos manuais.

