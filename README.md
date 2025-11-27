# modelagem_dados_ciclo_vendas_supermercado_sql
# 🛒 Projeto de Modelagem de Dados: Sistema de Vendas e Fidelização

## 🎯 Objetivo
Este projeto consiste na modelagem de um banco de dados relacional desenhado para suportar o ciclo de vendas completo de um supermercado, com um foco estratégico na **rastreabilidade das transações** e na **fidelização de clientes**.

A solução visa transformar os dados transacionais em insumos analíticos prontos para o programa de recompensas e ações de marketing do cliente.

## 💡 O Diagnóstico do Problema

O diagnóstico inicial identificou a necessidade de estruturar a base de dados para resolver dois problemas principais:
1.  **Falta de Rastreabilidade:** Inconsistência nos registros de vendas que dificultava a auditoria fiscal e a exatidão dos dados de estoque.
2.  **Impossibilidade de Análise de Fidelização:** Não existia uma conexão clara entre as vendas e os clientes cadastrados, impedindo a contagem de pontos e a segmentação para campanhas de fidelidade.

## 📋 Levantamento de Requisitos

O projeto foi guiado pelos seguintes requisitos de negócio:
* **Cadastro Completo:** Registro de clientes, produtos, colaboradores e fornecedores com endereço padronizado.
* **Venda Segura:** Registro de cada transação com data/hora exata e vinculação a um colaborador.
* **Detalhamento Fiscal:** Armazenamento do preço unitário e quantidade de cada item vendido (relação N:N entre Vendas e Produtos).
* **Mecanismo de Pontuação:** Capacidade de rastrear pontos e histórico de fidelidade de cada cliente.

## 🛠️ Decisões Chave de Modelagem

O modelo lógico foi construído priorizando a integridade dos dados e o desempenho em consultas de BI (Business Intelligence).

| Tópico | Decisão Implementada | Justificativa |
| :--- | :--- | :--- |
| **Identificadores (CPF/CNPJ)** | Uso do tipo de dado **`CHAR(11)`** para CPF e **`CHAR(14)`** para CNPJ. | Garante tamanho fixo para otimizar o desempenho em buscas e índices, padronizando a entrada de dados. |
| **Valores Monetários** | Uso do tipo de dado **`DECIMAL(10,2)`** (e não `FLOAT`). | Essencial para garantir a **precisão fiscal** e evitar erros de arredondamento inerentes ao ponto flutuante, crucial para transações financeiras. |
| **Auditoria e Tempo** | Campo `venda_data_hora` com **`DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP`**. | Assegura que o registro de data e hora seja feito de forma automática pelo SGBD no momento da inserção, garantindo a rastreabilidade e integridade temporal da venda. |
| **Relacionamento M:N** | Criação da tabela **`tbl_item_venda`** com uma **Chave Primária Composta** (`id_venda`, `id_produto`). | Resolve a relação N:N (uma Venda tem muitos Produtos; um Produto está em muitas Vendas), permitindo rastrear o preço e a quantidade de cada item na nota fiscal. |

## 📂 Estrutura das Tabelas Principais

O modelo é ancorado nas seguintes tabelas, que suportam o ciclo de vendas e fidelização:

| Tabela | Função | Destaque |
| :--- | :--- | :--- |
| **`tbl_vendas`** | Registro mestre de cada transação. | Possui `venda_data_hora` (para auditoria) e Chaves Estrangeiras para `tbl_colaborador` e `tbl_cliente`. |
| **`tbl_item_venda`** | Detalhe de cada item vendido. | Contém a Chave Composta e o `preco_unitario` no momento da venda (garantindo o histórico do preço). |
| **`tbl_cliente`** | Cadastro principal dos consumidores. | Informações cruciais para o programa de fidelidade. |
| **`tbl_cadastro_fidelidade`** | Gerencia os pontos e benefícios. | Tabela dedicada a armazenar `pontos_atuais` e ligar o cliente ao seu status no programa. |

## 🚀 Valor para o Negócio (Fidelização)

A arquitetura do banco de dados permite que a equipe de marketing realize consultas estratégicas, como:

* **Identificação de Clientes $\text{RFM}$:** Quais clientes com alto valor de fidelidade (`tbl_cadastro_fidelidade`) não fazem compras recentes.
* **Estratégias de Retenção:** Quais produtos devem ser oferecidos com desconto para um cliente específico com base em seu histórico de compras (`tbl_item_venda`).

---

### 📁 Arquivos do Repositório

* `(ciclo_vendas_supermercado.sql)`: Script completo para criação do banco de dados.
* `(modelo_conceitual-supermercado1.png)`: Diagrama do Modelo Conceitual.
* `(modelo_logico_ciclo_vendas_supermercado.png)`: Diagrama do Modelo Lógico com chaves e tipos de dados.
