-- Estrutura de Produtos: Scripts de tb_produto

CREATE DATABASE db_amigo_cobasi;
USE db_amigo_cobasi;

CREATE TABLE produto(
	id_produto INT AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	descricao VARCHAR(255),
	preco DECIMAL(10,2) NOT NULL,
	estoque INT NOT NULL,
	categoria VARCHAR(50),
	ativo BOOLEAN DEFAULT TRUE
);