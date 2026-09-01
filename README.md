# 🛒 Modelagem de Dados — Sistema de Vendas e Fidelização

![SQL](https://img.shields.io/badge/SQL-Database-4479A1)
![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1)
![Data Modeling](https://img.shields.io/badge/Data%20Modeling-Relational-6A5ACD)
![Status](https://img.shields.io/badge/Status-Acadêmico%20%7C%20Em%20desenvolvimento-informational)

Projeto de **modelagem de banco de dados relacional** desenvolvido para representar o ciclo de vendas de um supermercado, contemplando **clientes, lojas, produtos, fornecedores, colaboradores, vendas, pagamentos, estoque e fidelização**.

O projeto foi desenvolvido com foco em **integridade referencial, normalização, rastreabilidade das transações e preparação dos dados para análises futuras de Business Intelligence (BI)**.

---

## 🎯 Objetivo

Projetar uma estrutura de banco de dados capaz de representar, de forma consistente, as principais operações de um supermercado:

* Cadastro de clientes;
* Cadastro de lojas;
* Cadastro de fornecedores;
* Cadastro de produtos;
* Controle de estoque;
* Registro de colaboradores;
* Registro de vendas;
* Detalhamento dos itens vendidos;
* Registro de pagamentos;
* Relacionamento entre produtos e fornecedores;
* Programa de fidelidade;
* Cadastro de múltiplos telefones, e-mails e endereços;
* Rastreabilidade de data e hora das vendas.

A modelagem procura separar adequadamente **entidades, atributos e relacionamentos**, reduzindo redundâncias e mantendo a consistência dos dados.

---

# 💡 Problema de negócio

Um sistema de vendas precisa registrar muito mais do que apenas o valor total de uma compra.

É necessário saber:

* Quem realizou a venda?
* Em qual loja ela ocorreu?
* Qual cliente foi identificado?
* Quais produtos foram vendidos?
* Qual era o preço de cada produto no momento da venda?
* Qual foi a quantidade vendida?
* Qual desconto foi aplicado?
* Como a venda foi paga?
* Qual fornecedor fornece determinado produto?
* Qual é o estoque atual?
* O cliente participa de um programa de fidelidade?
* Quantos pontos possui?

A modelagem foi construída para permitir que essas informações sejam armazenadas de maneira estruturada e relacionadas por meio de **chaves primárias e estrangeiras**.

---

# 🏗️ Arquitetura do modelo

O banco de dados é organizado em grupos de entidades:

```text
                    ┌──────────────────┐
                    │    CLIENTES      │
                    └────────┬─────────┘
                             │
                             │
                    ┌────────▼─────────┐
                    │     VENDAS       │
                    └──────┬─┬─────────┘
                           │ │
             ┌─────────────┘ └──────────────┐
             │                              │
      ┌──────▼──────┐                ┌──────▼──────────┐
      │ ITENS VENDA │                │    PAGAMENTO    │
      └──────┬──────┘                └─────────────────┘
             │
             │
      ┌──────▼──────┐
      │  PRODUTOS   │
      └──────┬──────┘
             │
             │
      ┌──────▼─────────────┐
      │ FORNECEDOR_PRODUTO │
      └──────────┬─────────┘
                 │
          ┌──────▼───────┐
          │ FORNECEDORES │
          └──────────────┘


      ┌──────────────┐
      │    LOJAS     │
      └──────┬───────┘
             │
      ┌──────▼────────────┐
      │  COLABORADORES    │
      └───────────────────┘


      ┌───────────────────────┐
      │ PROGRAMA FIDELIDADE   │
      └───────────┬───────────┘
                  │
          ┌───────▼──────────────┐
          │ CADASTRO_FIDELIDADE  │
          └───────────┬──────────┘
                      │
                  CLIENTES
```

---

# 🧩 Principais entidades

| Tabela                      | Responsabilidade                         |
| --------------------------- | ---------------------------------------- |
| `tbl_clientes`              | Cadastro dos clientes                    |
| `tbl_lojas`                 | Cadastro das unidades do supermercado    |
| `tbl_fornecedores`          | Cadastro dos fornecedores                |
| `tbl_produtos`              | Cadastro e informações dos produtos      |
| `tbl_colaboradores`         | Cadastro dos colaboradores               |
| `tbl_vendas`                | Registro das vendas                      |
| `tbl_item_venda`            | Detalhamento dos produtos vendidos       |
| `tbl_forma_pagamento`       | Formas e valores de pagamento            |
| `tbl_programa_fidelidade`   | Cadastro dos programas de fidelidade     |
| `tbl_cadastro_fidelidade`   | Associação entre clientes e programas    |
| `tbl_fornecedores_produtos` | Associação entre fornecedores e produtos |
| `tbl_clientes_telefone`     | Telefones dos clientes                   |
| `tbl_clientes_email`        | E-mails dos clientes                     |
| `tbl_clientes_endereco`     | Endereços dos clientes                   |
| `tbl_lojas_endereco`        | Endereços das lojas                      |
| `tbl_fornecedores_endereco` | Endereços dos fornecedores               |

---

# 🔗 Relacionamentos

O modelo utiliza diferentes tipos de relacionamento.

### Cliente → Venda

Um cliente pode possuir várias vendas.

```text
CLIENTE 1 ─────────── N VENDA
```

O cliente em uma venda é **opcional**, permitindo registrar vendas em que o consumidor não foi identificado.

---

### Venda → Item da venda

Uma venda pode possuir vários itens.

```text
VENDA 1 ─────────── N ITEM_VENDA
```

A tabela `tbl_item_venda` funciona como entidade associativa entre vendas e produtos.

---

### Produto → Item da venda

Um produto pode aparecer em várias vendas.

```text
PRODUTO 1 ─────────── N ITEM_VENDA
```

A combinação:

```text
id_venda + id_produto
```

forma uma **chave primária composta**.

---

### Fornecedor ↔ Produto

Um fornecedor pode fornecer diversos produtos e um produto pode ser fornecido por diferentes fornecedores.

```text
FORNECEDOR N ─── N PRODUTO
```

O relacionamento é resolvido pela tabela:

```text
tbl_fornecedores_produtos
```

Ela armazena informações específicas da relação, como:

* Preço de custo;
* Prazo de entrega;
* Código do produto no fornecedor;
* Data da última compra.

---

### Cliente ↔ Programa de Fidelidade

O relacionamento entre clientes e programas também é tratado por uma entidade associativa:

```text
CLIENTE N ─── N PROGRAMA_FIDELIDADE
```

A tabela:

```text
tbl_cadastro_fidelidade
```

armazena:

* Data de adesão;
* Pontos atuais;
* Cliente;
* Programa de fidelidade.

---

# 🔐 Integridade e regras de modelagem

O projeto utiliza mecanismos do SGBD para preservar a consistência dos dados.

## Chaves primárias

As entidades principais utilizam identificadores numéricos com `AUTO_INCREMENT`.

Exemplo:

```sql
id_cliente INT NOT NULL AUTO_INCREMENT
```

---

## Chaves estrangeiras

Os relacionamentos são implementados utilizando `FOREIGN KEY`.

Exemplo:

```sql
CONSTRAINT fk_vendas_clientes
FOREIGN KEY (id_cliente)
REFERENCES tbl_clientes (id_cliente)
```

Isso permite manter a integridade referencial entre as tabelas.

---

## Chaves compostas

O projeto utiliza chaves primárias compostas em relacionamentos N:N.

### Itens da venda

```sql
PRIMARY KEY (id_venda, id_produto)
```

### Fidelidade

```sql
PRIMARY KEY (id_cliente, id_programa_fidelidade)
```

### Fornecedor × Produto

```sql
PRIMARY KEY (id_fornecedor, id_produto)
```

Essas estruturas permitem representar relacionamentos muitos-para-muitos sem criar duplicidade na associação.

---

# 💰 Tratamento de valores monetários

Para valores financeiros, o projeto utiliza:

```sql
DECIMAL(10,2)
```

em vez de tipos de ponto flutuante.

Isso é adequado para valores monetários porque permite representar os valores com precisão decimal controlada.

Exemplos presentes no modelo:

```text
produto_preco_venda
venda_valor_total
venda_desconto
item_venda_preco_unitario
item_venda_subtotal
item_venda_desconto
item_venda_valor_liquido
fornecedor_produto_preco_custo
forma_pagamento_valor_pago
```

---

# 🕒 Rastreabilidade das vendas

A tabela `tbl_vendas` possui:

```sql
venda_data_hora DATETIME
NOT NULL
DEFAULT CURRENT_TIMESTAMP
```

Dessa forma, a data e a hora da criação do registro podem ser atribuídas automaticamente pelo SGBD.

A venda também está relacionada a:

* Cliente, quando identificado;
* Loja;
* Colaborador.

Isso cria uma estrutura adequada para rastreamento das transações.

---

# 🧾 Detalhamento da venda

A tabela `tbl_item_venda` registra informações específicas de cada produto dentro de uma venda:

```text
Quantidade
Preço unitário
Subtotal
Desconto
Valor líquido
```

Um ponto importante da modelagem é o armazenamento do:

```text
item_venda_preco_unitario
```

Isso permite preservar o preço praticado no momento da venda, independentemente de alterações posteriores no preço cadastrado do produto.

---

# 💳 Pagamentos

A tabela:

```text
tbl_forma_pagamento
```

permite associar múltiplos registros de pagamento a uma mesma venda.

Ela armazena:

* Tipo de pagamento;
* Valor pago;
* Detalhe da transação;
* Venda relacionada.

Isso permite representar situações em que uma venda utiliza mais de uma forma de pagamento.

---

# 📦 Produtos e fornecedores

A relação entre produtos e fornecedores é representada por:

```text
tbl_fornecedores_produtos
```

Além das chaves de relacionamento, a tabela possui atributos próprios da associação:

```text
fornecedor_produto_preco_custo
fornecedor_produto_prazo_entrega
fornecedor_produto_codigo_fornecedor
fornecedor_produto_data_ultima_compra
```

Essa abordagem evita colocar informações que pertencem à relação diretamente em `tbl_produtos` ou `tbl_fornecedores`.

---

# 👤 Cadastro de clientes

O cliente possui informações básicas em:

```text
tbl_clientes
```

e informações complementares em tabelas específicas.

### Telefones

```text
tbl_clientes_telefone
```

### E-mails

```text
tbl_clientes_email
```

### Endereços

```text
tbl_clientes_endereco
```

Essa separação permite que um cliente possua múltiplos registros de contato e endereço sem duplicar os dados principais do cadastro.

---

# 📊 Aplicações para análise de dados

A estrutura criada permite futuras consultas analíticas, por exemplo:

### Análise de vendas

* Faturamento por período;
* Faturamento por loja;
* Produtos mais vendidos;
* Ticket médio;
* Volume de vendas;
* Descontos aplicados.

### Análise de clientes

* Frequência de compras;
* Valor total comprado;
* Produtos preferidos;
* Clientes ativos e inativos;
* Segmentação de clientes.

### Fidelização

* Pontos acumulados;
* Adesão aos programas;
* Histórico de compras;
* Identificação de clientes com baixa frequência.

### Fornecedores

* Produtos fornecidos;
* Preço de custo;
* Prazo de entrega;
* Histórico de compras.

Essas possibilidades tornam o modelo uma base interessante para futuras soluções de **Data Analytics e Business Intelligence**.

---

# 🛠️ Tecnologias e conceitos

### Banco de dados

* MySQL
* SQL
* Banco de dados relacional
* DDL
* Chaves primárias
* Chaves estrangeiras
* Chaves compostas
* Constraints
* Integridade referencial
* `AUTO_INCREMENT`
* `DECIMAL`
* `DATETIME`

### Modelagem

* Entidades
* Atributos
* Relacionamentos
* Cardinalidade
* Relacionamentos 1:N
* Relacionamentos N:N
* Entidades associativas
* Normalização
* Integridade de dados

### Análise

* Levantamento de requisitos
* Regras de negócio
* Rastreabilidade
* Preparação para BI
* Análise de dados

---

# ▶️ Como executar

## 1. Pré-requisito

Tenha um servidor **MySQL** instalado ou disponível por meio de uma ferramenta compatível, como MySQL Workbench.

## 2. Clone o repositório

```bash
git clone https://github.com/Sponge1774/modelagem_dados_ciclo_vendas_supermercado_sql.git
```

## 3. Entre no diretório

```bash
cd modelagem_dados_ciclo_vendas_supermercado_sql
```

## 4. Execute o script

Abra:

```text
ciclo_vendas_supermercado.sql
```

e execute o script no MySQL.

O script cria o banco:

```text
ciclo_vendas_supermercado
```

> ⚠️ **Atenção:** o script contém `DROP DATABASE IF EXISTS`. Portanto, sua execução remove uma base existente com o mesmo nome antes de recriá-la. Utilize essa instrução somente em ambiente de desenvolvimento, estudo ou laboratório.

---

# 📁 Arquivos do projeto

* [`ciclo_vendas_supermercado.sql`](ciclo_vendas_supermercado.sql) — Script SQL para criação do banco e suas tabelas.
* [`modelo_conceitual-supermercado1.png`](modelo_conceitual-supermercado1.png) — Modelo conceitual.
* [`modelo_logico_ciclo_vendas_supermercado.png`](modelo_logico_ciclo_vendas_supermercado.png) — Modelo lógico.
* [`LICENSE`](LICENSE) — Licença do projeto.

---

# 🎓 Contexto acadêmico

Projeto desenvolvido como parte da formação em **Análise e Desenvolvimento de Sistemas**, com aplicação prática de conceitos de:

* Banco de dados;
* Modelagem de dados;
* SQL;
* Engenharia de requisitos;
* Integridade referencial;
* Relacionamentos entre entidades;
* Organização de informações para análise.

---

# 🚧 Próximas melhorias

Possíveis evoluções para o projeto:

* [ ] Criar script de `INSERT` com dados fictícios;
* [ ] Criar consultas SQL analíticas;
* [ ] Criar `VIEWs` para relatórios;
* [ ] Criar consultas de análise de vendas;
* [ ] Implementar consultas de análise RFM;
* [ ] Criar procedures;
* [ ] Criar triggers para regras de negócio;
* [ ] Adicionar testes de integridade;
* [ ] Criar dashboard de BI;
* [ ] Documentar o modelo físico;
* [ ] Adicionar exemplos de consultas SQL;
* [ ] Melhorar validações de dados.

---

# 📌 Status

**Projeto acadêmico — em desenvolvimento contínuo.**

O modelo atual representa uma base relacional estruturada para o ciclo de vendas e fidelização, podendo ser expandido para incorporar novas regras de negócio e análises.

---

# ⚖️ Licença

Este projeto está sob a licença **MIT**.

Consulte o arquivo [`LICENSE`](LICENSE) para obter mais informações.

---

# 🇬🇧 English Version

# 🛒 Data Modeling — Sales and Customer Loyalty System

![SQL](https://img.shields.io/badge/SQL-Database-4479A1)
![MySQL](https://img.shields.io/badge/MySQL-8.0%2B-4479A1)
![Data Modeling](https://img.shields.io/badge/Data%20Modeling-Relational-6A5ACD)
![Status](https://img.shields.io/badge/Status-Academic%20%7C%20In%20Development-informational)

Relational database modeling project designed to represent the sales cycle of a supermarket, including **customers, stores, products, suppliers, employees, sales, payments, inventory, and customer loyalty**.

The project focuses on **referential integrity, data modeling, transaction traceability, and future Business Intelligence (BI) analysis**.

---

## 🎯 Objective

The goal is to design a relational database capable of representing the main operations of a supermarket:

* Customer registration;
* Store registration;
* Supplier registration;
* Product registration;
* Inventory control;
* Employee registration;
* Sales registration;
* Sales item details;
* Payment records;
* Product-supplier relationships;
* Loyalty programs;
* Multiple customer phones, e-mails, and addresses;
* Sales date and time traceability.

---

# 🏗️ Model Architecture

The database is organized into groups of related entities:

```text
CUSTOMERS
    │
    ▼
  SALES
   │ │
   │ └──────────────► PAYMENTS
   │
   ▼
SALE_ITEMS
   │
   ▼
PRODUCTS
   │
   ▼
SUPPLIER_PRODUCTS
   │
   ▼
SUPPLIERS
```

Additional structures support stores, employees, customer contacts, addresses, and loyalty programs.

---

# 🧩 Main Entities

| Table                       | Responsibility                                 |
| --------------------------- | ---------------------------------------------- |
| `tbl_clientes`              | Customer registration                          |
| `tbl_lojas`                 | Store registration                             |
| `tbl_fornecedores`          | Supplier registration                          |
| `tbl_produtos`              | Product registration and inventory information |
| `tbl_colaboradores`         | Employee registration                          |
| `tbl_vendas`                | Sales registration                             |
| `tbl_item_venda`            | Details of products sold                       |
| `tbl_forma_pagamento`       | Payment records                                |
| `tbl_programa_fidelidade`   | Loyalty program registration                   |
| `tbl_cadastro_fidelidade`   | Customer-loyalty program association           |
| `tbl_fornecedores_produtos` | Supplier-product association                   |
| `tbl_clientes_telefone`     | Customer phone numbers                         |
| `tbl_clientes_email`        | Customer e-mail addresses                      |
| `tbl_clientes_endereco`     | Customer addresses                             |
| `tbl_lojas_endereco`        | Store addresses                                |
| `tbl_fornecedores_endereco` | Supplier addresses                             |

---

# 🔗 Relationships

The model implements 1:N and N:N relationships.

### Customer → Sale

```text
CUSTOMER 1 ─────────── N SALE
```

A customer may have multiple sales, while the customer identification in a sale is optional.

### Sale → Sale Item

```text
SALE 1 ─────────── N SALE_ITEM
```

### Product → Sale Item

```text
PRODUCT 1 ─────────── N SALE_ITEM
```

The association uses:

```text
id_venda + id_produto
```

as a composite primary key.

### Supplier ↔ Product

```text
SUPPLIER N ─── N PRODUCT
```

The relationship is resolved through:

```text
tbl_fornecedores_produtos
```

### Customer ↔ Loyalty Program

```text
CUSTOMER N ─── N LOYALTY_PROGRAM
```

The relationship is resolved through:

```text
tbl_cadastro_fidelidade
```

---

# 🔐 Data Integrity

The project uses:

* Primary keys;
* Foreign keys;
* Composite primary keys;
* Unique constraints;
* `NOT NULL`;
* `AUTO_INCREMENT`;
* Referential integrity.

Example:

```sql
CONSTRAINT fk_vendas_clientes
FOREIGN KEY (id_cliente)
REFERENCES tbl_clientes (id_cliente)
```

---

# 💰 Monetary Data

Financial values use:

```sql
DECIMAL(10,2)
```

instead of floating-point types.

This provides controlled decimal precision for monetary values.

---

# 🕒 Transaction Traceability

Sales include:

```sql
venda_data_hora DATETIME
NOT NULL
DEFAULT CURRENT_TIMESTAMP
```

The sale is also associated with:

* Customer, when identified;
* Store;
* Employee.

This provides a structured basis for transaction traceability.

---

# 💳 Payments

The `tbl_forma_pagamento` table supports multiple payment records for the same sale.

It stores:

* Payment type;
* Amount paid;
* Transaction details;
* Related sale.

This allows the model to represent split payments.

---

# 📊 Data Analytics Potential

The database structure supports future analytical queries such as:

* Sales by period;
* Sales by store;
* Best-selling products;
* Average ticket;
* Customer purchase frequency;
* Customer segmentation;
* Loyalty analysis;
* Supplier analysis;
* Product cost analysis.

The model can therefore serve as a foundation for future **Data Analytics and Business Intelligence solutions**.

---

# 🛠️ Technologies and Concepts

* MySQL
* SQL
* Relational databases
* DDL
* Primary keys
* Foreign keys
* Composite keys
* Constraints
* Referential integrity
* Data modeling
* Cardinality
* 1:N relationships
* N:N relationships
* Normalization
* Business requirements
* Data analysis
* Business Intelligence

---

# ▶️ How to Run

## Requirements

You need a **MySQL** server or compatible environment such as MySQL Workbench.

## Clone the repository

```bash
git clone https://github.com/Sponge1774/modelagem_dados_ciclo_vendas_supermercado_sql.git
```

## Enter the directory

```bash
cd modelagem_dados_ciclo_vendas_supermercado_sql
```

## Execute the SQL script

Open:

```text
ciclo_vendas_supermercado.sql
```

and execute it using MySQL.

The script creates:

```text
ciclo_vendas_supermercado
```

> ⚠️ **Warning:** the script contains `DROP DATABASE IF EXISTS`. Running it will delete an existing database with the same name before recreating it. Use it only in development, study, or laboratory environments.

---

# 📁 Repository Files

* [`ciclo_vendas_supermercado.sql`](ciclo_vendas_supermercado.sql) — SQL database creation script.
* [`modelo_conceitual-supermercado1.png`](modelo_conceitual-supermercado1.png) — Conceptual model.
* [`modelo_logico_ciclo_vendas_supermercado.png`](modelo_logico_ciclo_vendas_supermercado.png) — Logical model.
* [`LICENSE`](LICENSE) — Project license.

---

# 🎓 Academic Context

This project was developed as part of a **Systems Analysis and Development** academic program, applying concepts related to:

* Database systems;
* Data modeling;
* SQL;
* Requirements engineering;
* Referential integrity;
* Entity relationships;
* Data organization for analytics.

---

# 🚧 Future Improvements

Possible future developments include:

* [ ] Add sample data using `INSERT`;
* [ ] Add analytical SQL queries;
* [ ] Create reporting `VIEW`s;
* [ ] Add sales analysis queries;
* [ ] Implement RFM analysis queries;
* [ ] Add stored procedures;
* [ ] Add business-rule triggers;
* [ ] Add integrity tests;
* [ ] Create a BI dashboard;
* [ ] Document the physical model;
* [ ] Add SQL query examples;
* [ ] Improve data validation.

---

# 📌 Status

**Academic project — continuously evolving.**

The current model provides a structured relational foundation for supermarket sales and customer loyalty and can be expanded with additional business rules and analytical capabilities.

---

# ⚖️ License

This project is licensed under the **MIT License**.

See the [`LICENSE`](LICENSE) file for details.
