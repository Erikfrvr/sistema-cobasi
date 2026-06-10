-- Estrutura de Itens: Scripts de tb_item_venda 

CREATE DATABASE db_amigo_cobasi;
USE db_amigo_cobasi;

CREATE TABLE item_venda(
	id_item INT AUTO_INCREMENT PRIMARY KEY,
	id_venda INT NOT NULL,
	id_produto INT NOT NULL,
	quantidade INT NOT NULL,
	valor_unitario DECIMAL(10,2),
	subtotal DECIMAL(10,2),

	FOREIGN KEY(id_venda)
	REFERENCES tb_venda(id_venda),

	FOREIGN KEY(id_produto)
	REFERENCES tb_produto(id_produto)
);
