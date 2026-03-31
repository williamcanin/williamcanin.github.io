---
layout: post
author: "William C. Canin"
title: "Gerando de forma segura uma wallet para suas criptomoedas"
description: "Gerar sua seed universal para suas criptomoedas"
date: 2026-03-30 23:47:53 -0300
update_date: 
comments: false
tags: [seedctl, bitcoin, solana, ethereum, crypto, bip-39]
---

Gerar uma wallet de criptomoedas em um ambiente comprometido é um dos erros mais comuns e perigosos que um usuário pode cometer. Keyloggers, malwares e gravações de tela podem capturar sua seed phrase antes mesmo de você perceber. Neste post, vou mostrar como criar suas wallets com o máximo de segurança usando duas ferramentas: o **Tails OS** e o **SeedCTL**.

---

## O que é o Tails?

[Tails](https://tails.boum.org/) é um sistema operacional live focado em privacidade e segurança. Ele é executado diretamente de um pendrive, **sem deixar rastros no computador usado**, e não depende do sistema operacional instalado na máquina. Isso significa que mesmo em um computador potencialmente comprometido, você terá um ambiente limpo para operar.

Para o nosso objetivo, o Tails serve como o ambiente isolado e confiável exigido pelo SeedCTL.

### Por que o Tails é ideal para gerar wallets?

- Não usa o HD do computador, portanto não deixa arquivos temporários
- Toda sessão começa do zero (amnésica por padrão)
- Permite trabalhar completamente offline (air-gapped)
- Reduz drasticamente o risco de keyloggers e malwares presentes no computador host

---

## Passo 1 — Baixar e gravar o Tails em um pendrive

### Requisitos

- Um pendrive de **pelo menos 8 GB** (os dados serão apagados)
- Um computador com acesso à internet para o download inicial
- O aplicativo **Balena Etcher** (ou similar) para gravar a imagem

### Download

Acesse o site oficial: [https://tails.boum.org/install/](https://tails.boum.org/install/)

Siga o guia de instalação correspondente ao seu sistema operacional atual (Windows, macOS ou Linux). O próprio site do Tails oferece um passo a passo detalhado e interativo para cada plataforma.

> ⚠️ **Importante:** sempre baixe o Tails somente pelo site oficial e verifique a assinatura do arquivo para garantir sua autenticidade.

### Gravando no pendrive

1. Instale o [Balena Etcher](https://etcher.balena.io/)
2. Abra o Etcher e selecione a imagem `.img` do Tails baixada
3. Selecione o pendrive como destino
4. Clique em **Flash** e aguarde a conclusão

---

## Passo 2 — Inicializar o Tails

1. Insira o pendrive no computador
2. Reinicie a máquina e acesse o menu de boot (geralmente **F12**, **F2**, **ESC** ou **DEL** durante a inicialização — varia conforme o fabricante)
3. Selecione o pendrive como dispositivo de boot
4. O Tails irá carregar. Na tela de boas-vindas, você pode deixar as configurações padrão e clicar em **Start Tails**

> 💡 Após iniciar, **desconecte o cabo de rede ou desative o Wi-Fi**. Para gerar wallets, não precisamos de internet — e manter a máquina offline é parte fundamental da segurança.

---

## O que é o SeedCTL?

[SeedCTL](https://evolvbits.github.io/seedctl/) é um gerador de wallets multichain, determinístico e focado em operação offline. Ele roda via linha de comando (CLI) e permite gerar e recuperar wallets para **10 criptomoedas** de forma auditável e transparente.

### Criptomoedas suportadas

| Rede | Formato de endereço |
|------|-------------------|
| Bitcoin (BTC) | `bc1...` / `tb1...` |
| Ethereum (ETH) | `0x...` |
| BNB Smart Chain (BNB) | `0x...` |
| XRP Ledger (XRP) | `r...` |
| Tron (TRX) | `T...` |
| Solana (SOL) | base58 |
| Litecoin (LTC) | `ltc...` |
| Polygon (POL/MATIC) | `0x...` |
| Cardano (ADA) | `addr...` |
| Monero (XMR) | base58 |

### Principais características

- **Offline por design** — sem dependência de rede, sem transmissão de dados
- **Determinístico** — os mesmos inputs sempre geram os mesmos outputs (BIP-39)
- **Auditável** — derivation paths explícitos e visíveis
- **Sem persistência em disco** por intenção de design

---

## Passo 3 — Baixar o SeedCTL no Tails

> Neste passo, você precisará conectar brevemente à internet para baixar o binário. Após o download, desconecte novamente.

1. No Tails, abra o navegador Tor Browser
2. Acesse a página de releases do SeedCTL:  
   👉 [https://github.com/evolvbits/seedctl/releases](https://github.com/evolvbits/seedctl/releases)
3. Baixe o binário correspondente ao Linux x86_64 (ex: `seedctl-[VERSION]-linux-x86_64`)
4. Salve o arquivo na sua pasta pessoal do Tails

> 💡 Alternativamente, você pode baixar o SeedCTL **antes** de iniciar o Tails, salvar o binário em um segundo pendrive, e transferi-lo para o ambiente Tails sem precisar de conexão à internet.

---

## Passo 4 — Preparar e executar o SeedCTL

Abra o **Terminal** no Tails e navegue até onde o arquivo foi salvo. Em seguida, dê permissão de execução e rode o programa:

```bash
chmod +x seedctl-[VERSION]-linux-x86_64
./seedctl-[VERSION]-linux-x86_64
```

Substitua `[VERSION]` pelo número da versão que você baixou.

> ⚠️ Leia **todas** as recomendações iniciais apresentadas pelo SeedCTL antes de prosseguir.

---

## Passo 5 — Gerando sua wallet

Ao iniciar, o SeedCTL apresentará as opções:

- **Create new wallet** — para gerar uma nova wallet
- **Import existing wallet** — para importar uma seed que você já possui

### Escolhendo o modo de entropia

O SeedCTL oferece dois modos de entropia para geração da mnemônica:

**Modo Determinístico (Dice Manual)**  
Você insere uma sequência de dados manualmente. Nenhuma aleatoriedade do sistema é adicionada. Ideal para cerimônias auditáveis e reprodução exata futura.

**Modo Híbrido**  
Combina sua sequência de dados com a entropia do sistema (RNG). Recomendado para criar wallets novas com defesa em profundidade. Não permite replay exato.

> Para a maioria dos usuários que estão criando uma wallet nova, o **modo híbrido** oferece uma boa combinação de segurança e praticidade.

### Mnemônica BIP-39

Escolha entre **12 ou 24 palavras**. Wallets com 24 palavras oferecem entropia maior e são recomendadas para guardar valores mais altos.

Você também pode definir uma **passphrase** adicional (às vezes chamada de "25ª palavra"). Essa passphrase é separada da seed e adiciona uma camada extra de segurança — mas deve ser guardada com o mesmo cuidado da seed.

### Selecionando a rede e o derivation path

Após gerar a mnemônica, selecione a criptomoeda e o estilo de derivação desejado. O SeedCTL exibirá os paths explicitamente — anote-os junto com sua seed para garantir recuperação futura.

Para detalhes sobre os paths de cada rede, consulte a [documentação oficial](https://evolvbits.github.io/seedctl/documentation/#networks).

---

## Passo 6 — Outputs gerados

O SeedCTL exibirá:

- As palavras da mnemônica BIP-39 e seus índices
- O material de chave no nível de conta (onde aplicável)
- Os derivation paths utilizados
- As listas de endereços para o range de índices selecionado
- Opcionalmente, arquivos de exportação para watch-only wallets

> ⚠️ **Anote tudo em papel** neste momento. Nunca fotografe a tela, não salve em arquivos digitais não criptografados e jamais envie para a nuvem.

---

## Compatibilidade com carteiras populares

Após gerar sua seed, você pode importá-la nas seguintes carteiras:

| Rede | Carteiras compatíveis |
|------|----------------------|
| Bitcoin | Sparrow Wallet, Electrum, BlueWallet |
| Ethereum / BNB / Polygon | MetaMask, Ledger Live, Rabby |
| XRP | Xaman (XUMM), Ledger Live |
| Solana | Phantom, Solana CLI |
| Cardano | Eternl, Yoroi, Lace |
| Monero | Monero GUI, Feather Wallet |

---

## Recuperando sua wallet no futuro

O SeedCTL é determinístico: **os mesmos inputs sempre geram os mesmos outputs**. Para recuperar sua wallet, você precisará dos seguintes dados — guarde-os com segurança:

1. As palavras da mnemônica (12 ou 24)
2. A passphrase (ou explicitamente "vazia")
3. O modo de entropia e sequência de dados utilizados (se aplicável)
4. A criptomoeda / rede selecionada
5. O estilo e path de derivação
6. O range de índices gerado

Para detalhes completos sobre recuperação, veja o [Guia de Recuperação](https://evolvbits.github.io/seedctl/documentation/#recovery) e a seção de [Reprodutibilidade](https://evolvbits.github.io/seedctl/documentation/#reproducibility) na documentação.

---

## Boas práticas de segurança

- 🔒 Gere suas wallets **sempre offline**
- ✍️ Guarde sua seed em **papel físico** — considere gravar em metal para maior durabilidade
- 📵 Nunca digite sua seed em um dispositivo conectado à internet
- 🧪 **Teste a recuperação** com uma pequena quantia antes de mover valores altos
- 🗂️ Mantenha **backups em locais separados** (cofre, caixa de segurança, etc.)
- 👁️ Evite câmeras e outras pessoas no ambiente durante a geração

---

## Conclusão

Combinar o **Tails OS** com o **SeedCTL** é uma das abordagens mais sólidas disponíveis hoje para quem deseja gerar wallets de criptomoedas com segurança real. O Tails garante um ambiente limpo e sem rastros, enquanto o SeedCTL oferece derivação determinística, auditável e completamente offline.

Para explorar todos os recursos e detalhes técnicos do SeedCTL, acesse a [documentação completa](https://evolvbits.github.io/seedctl/documentation/).

---

*Use por sua conta e risco. Este post é apenas educacional. Sempre valide seus endereços antes de mover fundos.*

