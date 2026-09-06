# 🛒 Modelagem de Dados — Sistema de Vendas e Fidelização

![SQL](https://img.shields.io/badge/SQL-Database-4479A1)
![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1)
![Data Modeling](https://img.shields.io/badge/Data%20Modeling-Relational-6A5ACD)

🇧🇷 **Português** | 🇺🇸 **English**

---

## 🇧🇷 Português

### 🎯 Sobre o projeto

Projeto de **modelagem de banco de dados relacional** desenvolvido para representar o ciclo de vendas de um supermercado, contemplando clientes, lojas, produtos, fornecedores, colaboradores, vendas, pagamentos, estoque e programa de fidelidade.

O projeto demonstra conhecimentos de **modelagem relacional, integridade referencial, relacionamentos entre entidades, organização de dados e SQL**.

### 🧩 Problema de negócio

O modelo foi desenvolvido para representar e organizar informações necessárias para operações como:

* cadastro de clientes;
* cadastro de produtos;
* controle de lojas;
* registro de vendas;
* registro dos itens vendidos;
* formas de pagamento;
* relacionamento com fornecedores;
* controle de estoque;
* programa de fidelidade.

### 🏗️ Principais entidades

| Entidade                    | Finalidade                               |
| --------------------------- | ---------------------------------------- |
| `tbl_clientes`              | Cadastro de clientes                     |
| `tbl_lojas`                 | Cadastro das lojas                       |
| `tbl_produtos`              | Cadastro de produtos                     |
| `tbl_fornecedores`          | Cadastro de fornecedores                 |
| `tbl_colaboradores`         | Cadastro de colaboradores                |
| `tbl_vendas`                | Registro das vendas                      |
| `tbl_item_venda`            | Itens associados às vendas               |
| `tbl_forma_pagamento`       | Formas de pagamento                      |
| `tbl_programa_fidelidade`   | Programas de fidelidade                  |
| `tbl_cadastro_fidelidade`   | Associação entre clientes e programas    |
| `tbl_fornecedores_produtos` | Associação entre fornecedores e produtos |

### 🔗 Relacionamentos principais

```text
CLIENTE 1 ───── N VENDA

VENDA 1 ─────── N ITEM_VENDA

PRODUTO 1 ───── N ITEM_VENDA

FORNECEDOR N ── N PRODUTO

CLIENTE N ───── N PROGRAMA_FIDELIDADE
```

### 🔐 Conceitos técnicos

* Chaves primárias;
* Chaves estrangeiras;
* Chaves compostas;
* Integridade referencial;
* Relacionamentos 1:N e N:N;
* `UNIQUE`;
* `AUTO_INCREMENT`;
* Tipos `DATE` e `DATETIME`;
* `DECIMAL` para valores monetários;
* Engine InnoDB;
* Organização de dados em modelo relacional.

### 📊 Possibilidades de análise

A estrutura pode servir como base para consultas e futuras soluções de análise de dados, incluindo:

* faturamento por período;
* vendas por loja;
* produtos mais vendidos;
* ticket médio;
* comportamento de clientes;
* desempenho de fornecedores;
* acompanhamento de estoque;
* indicadores de fidelização.

### 🗂️ Arquivos

* `ciclo_vendas_supermercado.sql` — script SQL do banco de dados.
* `modelo_conceitual-supermercado1.png` — modelo conceitual.
* `modelo_logico_ciclo_vendas_supermercado.png` — modelo lógico.
* `LICENSE` — licença do projeto.

### ▶️ Como executar

Requer **MySQL 8.0+** ou MySQL Workbench.

```bash
git clone https://github.com/Sponge1774/modelagem_dados_ciclo_vendas_supermercado_sql.git
cd modelagem_dados_ciclo_vendas_supermercado_sql
```

Depois, execute o arquivo:

```text
ciclo_vendas_supermercado.sql
```

no MySQL Workbench ou em outro cliente MySQL compatível.

> ⚠️ O script utiliza `DROP DATABASE IF EXISTS`. Recomenda-se executá-lo somente em ambiente de estudo ou desenvolvimento.

### 🎓 Contexto acadêmico

Projeto desenvolvido durante a formação em **Análise e Desenvolvimento de Sistemas — UniFECAF**.

**Autor:** Eduardo Souza Mattos
**R.A.:** 35984
**Ano:** 2026

---

## 🇺🇸 English

### 🎯 About the project

**Relational database modeling project** designed to represent a supermarket sales cycle, including customers, stores, products, suppliers, employees, sales, payments, inventory, and customer loyalty.

The project demonstrates knowledge of **relational modeling, referential integrity, entity relationships, data organization, and SQL**.

### 🧩 Business scenario

The model represents information required for:

* customer registration;
* product registration;
* store management;
* sales registration;
* sales items;
* payment methods;
* supplier relationships;
* inventory management;
* customer loyalty programs.

### 🔐 Technical concepts

* Primary keys;
* Foreign keys;
* Composite keys;
* Referential integrity;
* 1:N and N:N relationships;
* `UNIQUE`;
* `AUTO_INCREMENT`;
* `DATE` and `DATETIME`;
* `DECIMAL` for monetary values;
* InnoDB;
* Relational data organization.

### 📊 Analytics opportunities

The database can support future analysis of:

* revenue by period;
* sales by store;
* best-selling products;
* average ticket;
* customer behavior;
* supplier performance;
* inventory;
* loyalty indicators.

### ▶️ Run

Requires **MySQL 8.0+** or MySQL Workbench.

```bash
git clone https://github.com/Sponge1774/modelagem_dados_ciclo_vendas_supermercado_sql.git
cd modelagem_dados_ciclo_vendas_supermercado_sql
```

Run:

```text
ciclo_vendas_supermercado.sql
```

using MySQL Workbench or another compatible MySQL client.

> ⚠️ The script uses `DROP DATABASE IF EXISTS`. Run it only in a development or academic environment.

### 🎓 Academic context

Developed during the **Systems Analysis and Development** program at UniFECAF.

**Author:** Eduardo Souza Mattos
**Student ID:** 35984
**Year:** 2026
