-- Estrutura de Produtos: Scripts de tb_produto

CREATE DATABASE IF NOT EXISTS bd_cobasi;
USE bd_cobasi;

CREATE TABLE tb_produto(
	id_produto INT AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	descricao VARCHAR(255),
	preco DECIMAL(10,2) NOT NULL,
	estoque INT NOT NULL,
	categoria VARCHAR(50),
	ativo BOOLEAN DEFAULT TRUE
);