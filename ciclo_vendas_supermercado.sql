-- SCRIPT FINAL OTIMIZADO (Incorporando PK Composta e Tipos de Dados Apropriados)
DROP DATABASE IF EXISTS `ciclo_vendas_supermercado`;
CREATE DATABASE `ciclo_vendas_supermercado`;
USE `ciclo_vendas_supermercado`;

-- TABELAS PRINCIPAIS
CREATE TABLE `tbl_clientes` (
  `id_cliente` INT NOT NULL AUTO_INCREMENT,
  `cliente_cpf` CHAR(11) NOT NULL, -- Uso de CHAR para CPF de tamanho fixo
  `cliente_nome` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id_cliente`),
  UNIQUE KEY `idx_unique_cpf` (`cliente_cpf`)
) ENGINE = InnoDB;

CREATE TABLE `tbl_lojas` (
  `id_loja` INT NOT NULL AUTO_INCREMENT,
  `loja_cnpj` CHAR(14) NOT NULL, -- Uso de CHAR para CNPJ de tamanho fixo
  `loja_nome_fantasia` VARCHAR(100) NOT NULL,
  `loja_data_abertura` DATE NOT NULL, -- CORREÇÃO: Usando tipo DATE
  PRIMARY KEY (`id_loja`),
  UNIQUE KEY `idx_unique_loja_cnpj` (`loja_cnpj`)
) ENGINE = InnoDB;

CREATE TABLE `tbl_fornecedores` (
  `id_fornecedor` INT NOT NULL AUTO_INCREMENT,
  `fornecedor_razao_social` VARCHAR(255) NOT NULL,
  `fornecedor_cnpj` CHAR(14) NOT NULL,
  PRIMARY KEY (`id_fornecedor`),
  UNIQUE KEY `idx_unique_forn_cnpj` (`fornecedor_cnpj`)
) ENGINE = InnoDB;

CREATE TABLE `tbl_produtos` (
  `id_produto` INT NOT NULL AUTO_INCREMENT,
  `produto_codigo_barras` VARCHAR(13) NOT NULL, -- CORREÇÃO: Usando VARCHAR
  `produto_nome` VARCHAR(100) NOT NULL,
  `produto_preco_venda` DECIMAL(10,2) NOT NULL, -- Uso de DECIMAL para precisão monetária
  `produto_estoque_atual` INT NULL,
  `produto_unidade_medida` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`id_produto`),
  UNIQUE KEY `idx_unique_cod_barras` (`produto_codigo_barras`)
) ENGINE = InnoDB;

CREATE TABLE `tbl_programa_fidelidade` (
  `id_programa_fidelidade` INT NOT NULL AUTO_INCREMENT,
  `programa_fidelidade_nome` VARCHAR(100) NOT NULL,
  `programa_fidelidade_descricao` TEXT NULL,
  PRIMARY KEY (`id_programa_fidelidade`)
) ENGINE = InnoDB;

CREATE TABLE `tbl_colaboradores` (
  `id_colaborador` INT NOT NULL AUTO_INCREMENT,
  `colaborador_cpf` CHAR(11) NOT NULL,
  `colaborador_nome` VARCHAR(100) NOT NULL,
  `colaborador_cargo` VARCHAR(50) NOT NULL,
  `id_loja` INT NOT NULL,
  PRIMARY KEY (`id_colaborador`),
  UNIQUE KEY `idx_unique_colab_cpf` (`colaborador_cpf`),
  CONSTRAINT `fk_colaboradores_lojas` FOREIGN KEY (`id_loja`) REFERENCES `tbl_lojas` (`id_loja`)
) ENGINE = InnoDB;

CREATE TABLE `tbl_vendas` (
  `id_venda` INT NOT NULL AUTO_INCREMENT,
  `venda_data_hora` DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP, -- Alterado para venda_data_hora
  `venda_valor_total` DECIMAL(10,2) NOT NULL,
  `venda_desconto` DECIMAL(10,2) NULL,
  `id_cliente` INT NULL, -- Opcional
  `id_loja` INT NOT NULL,
  `id_colaborador` INT NOT NULL,
  PRIMARY KEY (`id_venda`),
  CONSTRAINT `fk_vendas_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `tbl_clientes` (`id_cliente`),
  CONSTRAINT `fk_vendas_lojas` FOREIGN KEY (`id_loja`) REFERENCES `tbl_lojas` (`id_loja`),
  CONSTRAINT `fk_vendas_colaboradores` FOREIGN KEY (`id_colaborador`) REFERENCES `tbl_colaboradores` (`id_colaborador`)
) ENGINE = InnoDB;

-- TABELAS DE CONTATO

-- Tabela 1: Telefone de Clientes (1:N com tbl_clientes)
CREATE TABLE `tbl_clientes_telefone` (
  `id_cliente_telefone` INT NOT NULL AUTO_INCREMENT,
  `cliente_telefone_cod_pais` VARCHAR(5) NULL, 
  `cliente_telefone_ddd` VARCHAR(3) NOT NULL, 
  `cliente_telefone_numero` VARCHAR(10) NOT NULL, 
  `id_cliente` INT NOT NULL,
  PRIMARY KEY (`id_cliente_telefone`),
  UNIQUE KEY `idx_unique_tel_cliente` (`cliente_telefone_cod_pais`, `cliente_telefone_ddd`, `cliente_telefone_numero`),
  CONSTRAINT `fk_cliente_telefone` FOREIGN KEY (`id_cliente`) REFERENCES `tbl_clientes` (`id_cliente`)
) ENGINE = InnoDB;

-- Tabela 2: E-mail de Clientes (1:N com tbl_clientes)
CREATE TABLE `tbl_clientes_email` (
  `id_cliente_email` INT NOT NULL AUTO_INCREMENT,
  `cliente_email_endereco` VARCHAR(255) NOT NULL,
  `id_cliente` INT NOT NULL,
  PRIMARY KEY (`id_cliente_email`),
  UNIQUE KEY `idx_unique_email_cliente` (`cliente_email_endereco`),
  CONSTRAINT `fk_cliente_email` FOREIGN KEY (`id_cliente`) REFERENCES `tbl_clientes` (`id_cliente`)
) ENGINE = InnoDB;

-- TABELAS DE ENDEREÇO

-- 1. Endereço de Cliente (1:N com tbl_clientes)
CREATE TABLE `tbl_clientes_endereco` (
  `id_cliente_endereco` INT NOT NULL AUTO_INCREMENT,
  `cliente_endereco_logradouro` VARCHAR(100) NOT NULL,
  `cliente_endereco_numero` VARCHAR(10) NOT NULL,
  `cliente_endereco_complemento` VARCHAR(50) NULL,
  `cliente_endereco_cep` CHAR(8) NOT NULL,
  `cliente_endereco_cidade` VARCHAR(50) NOT NULL,
  `cliente_endereco_estado` CHAR(2) NOT NULL,
  `cliente_endereco_pais` VARCHAR(50) NOT NULL DEFAULT 'Brasil',
  `id_cliente` INT NOT NULL,
  PRIMARY KEY (`id_cliente_endereco`),
  CONSTRAINT `fk_cliente_endereco_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `tbl_clientes` (`id_cliente`)
) ENGINE = InnoDB;

-- 2. Endereço de Lojas (1:N com tbl_lojas)
CREATE TABLE `tbl_lojas_endereco` (
  `id_loja_endereco` INT NOT NULL AUTO_INCREMENT,
  `loja_endereco_logradouro` VARCHAR(100) NOT NULL, 
  `loja_endereco_numero` VARCHAR(10) NOT NULL,     
  `loja_endereco_complemento` VARCHAR(50) NULL,    
  `loja_endereco_cep` CHAR(8) NOT NULL,            
  `loja_endereco_cidade` VARCHAR(50) NOT NULL,     
  `loja_endereco_estado` CHAR(2) NOT NULL,         
  `loja_endereco_pais` VARCHAR(50) NOT NULL DEFAULT 'Brasil', 
  `id_loja` INT NOT NULL,
  PRIMARY KEY (`id_loja_endereco`),
  CONSTRAINT `fk_loja_endereco` FOREIGN KEY (`id_loja`) REFERENCES `tbl_lojas` (`id_loja`)
) ENGINE = InnoDB;

-- 3. Endereço de Fornecedores (1:N com tbl_fornecedores) - RENOMEADA E COLUNAS PADRONIZADAS
CREATE TABLE `tbl_fornecedores_endereco` (
  `id_fornecedor_endereco` INT NOT NULL AUTO_INCREMENT,
  `fornecedor_endereco_logradouro` VARCHAR(100) NOT NULL, -- Renomeado
  `fornecedor_endereco_numero` VARCHAR(10) NOT NULL, -- Renomeado
  `fornecedor_endereco_complemento` VARCHAR(50) NULL, -- Renomeado
  `fornecedor_endereco_cep` CHAR(8) NOT NULL, -- Renomeado
  `fornecedor_endereco_cidade` VARCHAR(50) NOT NULL, -- Renomeado
  `fornecedor_endereco_estado` CHAR(2) NOT NULL, -- Renomeado
  `fornecedor_endereco_pais` VARCHAR(50) NOT NULL DEFAULT 'Brasil', -- Renomeado
  `id_fornecedor` INT NOT NULL,
  PRIMARY KEY (`id_fornecedor_endereco`),
  CONSTRAINT `fk_fornecedor_endereco` FOREIGN KEY (`id_fornecedor`) REFERENCES `tbl_fornecedores` (`id_fornecedor`)
) ENGINE = InnoDB;

-- TABELAS DE LIGAÇÃO E DETALHE

-- N:N RESOLVIDO COM PK COMPOSTA (FIDELIDADE)
CREATE TABLE `tbl_cadastro_fidelidade` (
  `cadastro_fidelidade_data_adesao` DATE NOT NULL,
  `cadastro_fidelidade_pontos_atuais` INT DEFAULT 0,
  `id_programa_fidelidade` INT NOT NULL,
  `id_cliente` INT NOT NULL,
  PRIMARY KEY (`id_cliente`, `id_programa_fidelidade`), -- PK Composta
  CONSTRAINT `fk_cadastro_fidelidade_programa` FOREIGN KEY (`id_programa_fidelidade`) REFERENCES `tbl_programa_fidelidade` (`id_programa_fidelidade`),
  CONSTRAINT `fk_cadastro_fidelidade_clientes` FOREIGN KEY (`id_cliente`) REFERENCES `tbl_clientes` (`id_cliente`)
) ENGINE = InnoDB;

-- N:N RESOLVIDO COM PK COMPOSTA (FORNECEDOR-PRODUTO)
CREATE TABLE `tbl_fornecedores_produtos` (
  `fornecedor_produto_data_ultima_compra` DATE NULL,
  `fornecedor_produto_preco_custo` DECIMAL(10,2) NOT NULL,
  `fornecedor_produto_codigo_fornecedor` VARCHAR(50) NULL,
  `fornecedor_produto_prazo_entrega` INT NULL,
  `id_produto` INT NOT NULL,
  `id_fornecedor` INT NOT NULL,
  PRIMARY KEY (`id_fornecedor`, `id_produto`), -- PK Composta
  CONSTRAINT `fk_forn_prod_produtos` FOREIGN KEY (`id_produto`) REFERENCES `tbl_produtos` (`id_produto`),
  CONSTRAINT `fk_forn_prod_fornecedores` FOREIGN KEY (`id_fornecedor`) REFERENCES `tbl_fornecedores` (`id_fornecedor`)
) ENGINE = InnoDB;

-- N:N RESOLVIDO COM PK COMPOSTA (ITENS DA VENDA)
CREATE TABLE `tbl_item_venda` (
  `item_venda_quantidade` DECIMAL(10,2) NOT NULL,
  `item_venda_preco_unitario` DECIMAL(10,2) NOT NULL,
  `item_venda_subtotal` DECIMAL(10,2) NOT NULL,
  `item_venda_desconto` DECIMAL(10,2) DEFAULT 0.00,
  `item_venda_valor_liquido` DECIMAL(10,2) NOT NULL,
  `id_venda` INT NOT NULL,
  `id_produto` INT NOT NULL,
  PRIMARY KEY (`id_venda`, `id_produto`), -- PK Composta
  CONSTRAINT `fk_item_venda_vendas` FOREIGN KEY (`id_venda`) REFERENCES `tbl_vendas` (`id_venda`),
  CONSTRAINT `fk_item_venda_produtos` FOREIGN KEY (`id_produto`) REFERENCES `tbl_produtos` (`id_produto`)
) ENGINE = InnoDB;

-- DETALHE DA VENDA (PAGAMENTO)
CREATE TABLE `tbl_forma_pagamento` (
  `id_forma_pagamento` INT NOT NULL AUTO_INCREMENT,
  `forma_pagamento_tipo` VARCHAR(50) NOT NULL,
  `forma_pagamento_valor_pago` DECIMAL(10,2) NOT NULL,
  `forma_pagamento_detalhe_transacao` VARCHAR(100) NULL,
  `id_venda` INT NOT NULL,
  PRIMARY KEY (`id_forma_pagamento`),
  CONSTRAINT `fk_forma_pagamento_vendas` FOREIGN KEY (`id_venda`) REFERENCES `tbl_vendas` (`id_venda`)
) ENGINE = InnoDB;





