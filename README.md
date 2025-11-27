# modelagem_dados_ciclo_vendas_supermercado_sql
# 🛒 Projeto de Modelagem de Dados: Sistema de Vendas e Fidelização

## 🎯 Objetivo
Este projeto consiste na modelagem de um banco de dados relacional desenhado para suportar o ciclo de vendas completo de um supermercado, com um foco estratégico na **rastreabilidade das transações** e na **fidelização de clientes**.

A solução visa transformar os dados transacionais em insumos analíticos prontos para o programa de recompensas e ações de marketing do cliente.

## 💡 O Diagnóstico do Problema

O diagnóstico inicial identificou a necessidade de estruturar a base de dados para resolver dois problemas principais:
1.  **Falta de Rastreabilidade:** Inconsistência nos registros de vendas que dificultava a auditoria fiscal e a exatidão dos dados de estoque.
2.  **Impossibilidade de Análise de Fidelização:** Não existia uma conexão clara entre as vendas e os clientes cadastrados, impedindo a contagem de pontos e a segmentação para campanhas de fidelidade.

## 📋 Levantamento de Requisitos

O projeto foi guiado pelos seguintes requisitos de negócio:
* **Cadastro Completo:** Registro de clientes, produtos, colaboradores e fornecedores com endereço padronizado.
* **Venda Segura:** Registro de cada transação com data/hora exata e vinculação a um colaborador.
* **Detalhamento Fiscal:** Armazenamento do preço unitário e quantidade de cada item vendido (relação N:N entre Vendas e Produtos).
* **Mecanismo de Pontuação:** Capacidade de rastrear pontos e histórico de fidelidade de cada cliente.

---

### Mapeamento Detalhado: Perguntas de Negócio para Solução Técnica

Esta seção detalha como as perguntas de levantamento de requisitos foram traduzidas em decisões estruturais no modelo físico.

#### 1. Rastreabilidade e Transação Mínima (Foco em Vendas)

> **Pergunta:** Quais dados mínimos são necessários para validar e registrar uma transação no sistema, mesmo que o cliente não se identifique?
> **Resposta:** **O registro da venda é obrigatório.** Exigimos **Data, Hora, Valor Total, a Loja onde ocorreu e o Colaborador** responsável. O **Cliente é opcional** (pode ser NULL).

> **Pergunta:** Como o sistema lida com vendas que contêm vários produtos? E se o preço mudar?
> **Resposta:** É um relacionamento **Muitos para Muitos (N:N)**. Precisamos que o sistema capture o **preço unitário histórico** (o preço exato no momento da compra) e a quantidade de cada item vendido.

> **Pergunta:** É possível que o cliente divida o valor da venda usando, por exemplo, Pix e Cartão na mesma transação?
> **Resposta:** **Sim.** A venda pode ser dividida em múltiplas formas. Para cada parte, registramos o tipo, o valor pago e o detalhe da transação.

#### 2. Cadastro e Integridade de Dados (Identificação e Estrutura)

> **Pergunta:** Identificação do Cliente: Qual é o campo de identificação único do cliente? Ele pode ter mais de um telefone ou endereço?
> **Resposta:** O **CPF é o único identificador**. E sim, um cliente pode ter **vários endereços, telefones e e-mails**.

> **Pergunta:** Um colaborador pode trabalhar em mais de uma unidade de loja ao mesmo tempo ou ele está fixo em uma só?
> **Resposta:** O colaborador está sempre **fixo em uma única Loja**.

> **Pergunta:** Identificação do Fornecedor: Qual é o identificador principal e único do fornecedor?
> **Resposta:** O **CNPJ** é o identificador legal e deve ser **único** no sistema.

> **Pergunta:** As lojas e os fornecedores seguem a mesma regra dos clientes, podendo ter múltiplos endereços registrados?
> **Resposta:** **Sim**, tanto as Lojas quanto os Fornecedores podem ter múltiplos endereços (logística, faturamento, etc.).

> **Pergunta:** Qual é o principal código de rastreamento do produto? Que outros dados de estoque são críticos?
> **Resposta:** O **Código de Barras** é o identificador único. É vital rastrear o **Estoque Atual** e a **Unidade de Medida** ($\text{Kg}$, $\text{Und}$, etc.).

#### 3. Logística e Fidelização (Relacionamentos N:N Complexos)

> **Pergunta:** Qual o tipo de relacionamento entre um Cliente e um Programa de Fidelidade? Quais dados precisamos saber sobre essa adesão?
> **Resposta:** É **Muitos para Muitos (N:N)**. Precisamos da **data de adesão** e do **saldo de pontos**.

> **Pergunta:** Um produto pode ser comprado de diferentes fornecedores? E o custo e o prazo são sempre os mesmos?
> **Resposta:** É **N:N**. Não. O **preço de custo** e o **prazo de entrega** são **específicos de cada combinação** Produto-Fornecedor e devem ser registrados.

---

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

* [`ciclo_vendas_supermercado.sql`](ciclo_vendas_supermercado.sql): Script completo para criação do banco de dados.
* [`modelo_conceitual-supermercado1.png`](modelo_conceitual-supermercado1.png): Diagrama do Modelo Conceitual.
* [`modelo_logico_ciclo_vendas_supermercado.png`](modelo_logico_ciclo_vendas_supermercado.png): Diagrama do Modelo Lógico com chaves e tipos de dados.
