--Estrutura de Clientes e Vendas: Scripts de tb_cliente, tb_venda, tb_pagamento (Responsável: Erik).

USE bd_cobasi;

 -- Tabela de clientes com saldo pro programa Amigo Cobasi
create table tb_cliente (
	id_cliente Int PRIMARY KEY AUTO_INCREMENT,
	nome varchar(100) not null,
	cpf VARBINARY(150) not null unique,
	email varchar(100) not null unique,
	telefone varchar(15),
	senha varbinary(150) not null,
	saldo_pontos INT DEFAULT 0 check (saldo_pontos >= 0)
	data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP

);

-- Tabela principal para registrar vendas
create table tb_venda (
	


);