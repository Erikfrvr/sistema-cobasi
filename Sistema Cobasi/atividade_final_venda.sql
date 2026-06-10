-- Estrutura de Vendas: Scripts de tb_venda

CREATE DATABASE db_amigo_cobasi;
USE db_amigo_cobasi;

CREATE TABLE venda(
	id_venda INT AUTO_INCREMENT PRIMARY KEY,
	id_cliente INT NOT NULL,
	data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
	valor_total DECIMAL(10,2),
	pontos_gerados INT,

	FOREIGN KEY(id_cliente)
	REFERENCES tb_cliente(id_cliente)
);