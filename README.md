# Aplicação Oracle Forms 6i - CRUD de Clientes

Este repositório contém o projeto desenvolvido para a prova prática,
incluindo:

- Tela principal em Oracle Forms 6i (`CLIENTE.fmb`)
- Executável (`CLIENTE.fmx`)
- Scripts SQL: criação e remoção da tabela `TB_CLIENTE`
- Package `PKG_CLIENTE` (Specification e Body)
- Validações, inserção, atualização, exclusão e listagem

## Conteúdo
CLIENTE.fmb → Form principal
CLIENTE.fmx → Executável do Forms
Create.sql → Script de criação da tabela TB_CLIENTE
Drop.sql → Script para dropar a tabela
Package Spec.sql → Specification da package PKG_CLIENTE
Package Body.sql → Body da package PKG_CLIENTE

markdown
Copy code

## Como rodar

1. Executar `Drop.sql` (opcional).
2. Executar `Create.sql`.
3. Criar a package `PKG_CLIENTE` (Spec + Body).
4. Abrir o `CLIENTE.fmb` no Forms 6i e conectar ao schema.
5. Rodar a aplicação.

---

## ✔ Observações

- Aplicação compatível com Oracle Forms 6i (Developer 6i).
- Todos os CRUD e validações foram implementados seguindo a especificação.
