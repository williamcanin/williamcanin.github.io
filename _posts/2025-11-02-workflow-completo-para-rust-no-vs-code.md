---
layout: post
author: "William C. Canin"
title: "Workflow Completo para Rust no VS Code"
description: "Tenha um ambiente de desenvolvimento completo para Rust no seu VS Code"
date: 2025-11-02 23:43:44 -0300
update_date:
comments: false
tags: [rust, workflow, vscode, dev]
---

# 🚀 Workflow Completo para Rust no VS Code

Este guia apresenta um **workflow completo, moderno e altamente produtivo para desenvolvimento em Rust utilizando o VS Code**, com extensões, configurações e ferramentas externas capazes de atingir (ou superar) a experiência do RustRover.

---

## 📦 1. Instalação das Ferramentas Base

### **1.1 Instalar o Rust**

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

Atualizar:

```bash
rustup update
```

Adicionar componentes essenciais:

```bash
rustup component add clippy rustfmt rust-analyzer
```

### **1.2 Instale o VS Code**

Disponível em: [https://code.visualstudio.com](https://code.visualstudio.com)

---

## 🔩 2. Extensões Essenciais (Nível RustRover)

### ⭐ **2.1 rust-analyzer (Obrigatória)**

Autocompletar, IntelliSense, análise, refactors.

### ⭐ **2.2 Even Better TOML**

Melhora o suporte ao `Cargo.toml`.

### ⭐ **2.3 crates**

Gerencia versões de dependências e inspeção de crates.

### ⭐ **2.4 CodeLLDB**

Debug avançado para Rust.

### ⭐ **2.5 Error Lens**

Mostra erros inline, estilo RustRover.

### ⭐ **2.6 One Dark Pro ou JetBrains Theme**

Temas semelhantes a IDEs JetBrains.

### ⭐ **2.7 GitLens**

Controle de versão completo.

### ⭐ **2.8 Tabnine ou CodeGPT (Opcional)**

Autocompletar preditivo.

### ⭐ **2.9 Better Comments**

Realce para TODO, FIXME, SAFETY, NOTE.

### ⭐ **2.10 vscode-icons ou Material Icons**

Melhores ícones para o projeto.

---

## 🔧 3. Configurações Recomendadas para o VS Code

Adicione ao `settings.json`:

```json
{
  "rust-analyzer.checkOnSave.command": "clippy",
  "rust-analyzer.cargo.loadOutDirsFromCheck": true,
  "rust-analyzer.procMacro.enable": true,
  "rust-analyzer.imports.granularity.group": "module",
  "rust-analyzer.lens.enable": true,
  "editor.formatOnSave": true,
  "[rust]": {
    "editor.defaultFormatter": "rust-lang.rust-analyzer"
  },
  "editor.inlayHints.enabled": "on",
  "errorLens.enabled": true
}
```

---

## 🏗️ 4. Ferramentas Externas Complementares

### **4.1 cargo-edit**

```bash
cargo install cargo-edit
```

Usos:

```bash
cargo add serde
cargo rm tokio
cargo upgrade
```

### **4.2 cargo-watch**

Execução automática em tempo real:

```bash
cargo install cargo-watch
```

```bash
cargo watch -x run
```

### **4.3 cargo-expand**

Expande macros — essencial para entender código gerado:

```bash
cargo install cargo-expand
```

### **4.4 mdBook (Opcional)**

```bash
cargo install mdbook
```

---

## 🐞 5. Debug Rust com VS Code

Com **CodeLLDB** instalado, crie um `launch.json`:

```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "type": "lldb",
      "request": "launch",
      "name": "Debug Rust",
      "program": "${workspaceFolder}/target/debug/${workspaceFolderBasename}",
      "args": [],
      "cwd": "${workspaceFolder}"
    }
  ]
}
```

---

## 🧪 6. Executando Testes

Rodar testes:

```bash
cargo test
```

Também é possível usar os botões "Run Test" adicionados pelo `rust-analyzer` acima de cada função de teste.

---

## 🚦 7. Fluxo de Desenvolvimento Ideal

### 🔹 1. Criar projeto

```bash
cargo new meu-projeto
```

### 🔹 2. Typechecking + Clippy + rustfmt automáticos

Habilitado pelas configs anteriores.

### 🔹 3. Live reload

```bash
cargo watch -x run
```

### 🔹 4. Testes com botões no editor

(rust-analyzer)

### 🔹 5. Debug com CodeLLDB

### 🔹 6. Gerenciar dependências

Plugin **crates** ou:

```bash
cargo upgrade
```

### 🔹 7. Expandir macros

```bash
cargo expand
```

### 🔹 8. Documentação do projeto

```bash
cargo doc --open
```

---

## 🥇 Resultado Final

Com este setup, o VS Code alcança o mesmo nível (ou superior) ao RustRover:

* ✔ Autocomplete inteligente
* ✔ Refactors avançados
* ✔ Inlay hints (tipos e lifetimes inline)
* ✔ Clippy e rustfmt automáticos
* ✔ Debug completo com LLDB
* ✔ Gerenciador visual de crates
* ✔ Expansão de macros
* ✔ Testes integrados
* ✔ Experiência visual polida semelhante ao JetBrains

Este workflow entrega um **ambiente Rust profissional, produtivo e totalmente otimizado no VS Code**.
