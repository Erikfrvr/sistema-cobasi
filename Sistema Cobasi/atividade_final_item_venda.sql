-- Estrutura de Itens: Scripts de tb_item_venda 

CREATE DATABASE IF NOT EXISTS bd_cobasi;
USE bd_cobasi;

CREATE TABLE tb_item_venda(
	id_item INT AUTO_INCREMENT PRIMARY KEY,
	id_venda INT NOT NULL,
	id_produto INT NOT NULL,
	quantidade INT NOT NULL,
	valor_unitario DECIMAL(10,2),
	subtotal DECIMAL(10,2),

	FOREIGN KEY(id_venda)
	REFERENCES venda(id_venda),

	FOREIGN KEY(id_produto)
	REFERENCES produto(id_produto)
);
