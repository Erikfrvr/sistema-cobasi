CREATE DATABASE IF NOT EXISTS bd_cobasi;
USE bd_cobasi;

CREATE TABLE tb_cliente (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(150) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    senha VARCHAR(150) NOT NULL,
    saldo_pontos INT DEFAULT 0,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE USER 'admin_cobasi'@'localhost'
IDENTIFIED BY 'Admin@123';

GRANT SELECT, INSERT, UPDATE
ON bd_cobasi.*
TO 'admin_cobasi'@'localhost';

FLUSH PRIVILEGES;

CREATE TABLE tb_produto(
	id_produto INT AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(100) NOT NULL,
	descricao VARCHAR(255),
	preco DECIMAL(10,2) NOT NULL,
	estoque INT NOT NULL,
	categoria VARCHAR(50),
	ativo BOOLEAN DEFAULT TRUE
);

CREATE TABLE tb_venda(
	id_venda INT AUTO_INCREMENT PRIMARY KEY,
	id_cliente INT NOT NULL,
	data_venda DATETIME DEFAULT CURRENT_TIMESTAMP,
	valor_total DECIMAL(10,2),
	pontos_gerados INT,

	FOREIGN KEY(id_cliente)
	REFERENCES tb_cliente(id_cliente)
);

CREATE TABLE tb_item_venda(
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

CREATE TABLE tb_pagamento(
	id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
	id_venda INT UNIQUE,
	tipo_pagamento VARCHAR(30),
	valor_pago DECIMAL(10,2),
	data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
	status_pagamento VARCHAR(20),

	FOREIGN KEY(id_venda)
	REFERENCES tb_venda(id_venda)
);

DELIMITER //

DROP PROCEDURE IF EXISTS sp_registrar_venda_completa //
 
create procedure sp_registrar_venda_completa(
    IN p_id_cliente INT,
    IN p_id_produto INT,
    IN p_quantidade INT,
    IN p_tipo_pagamento VARCHAR(30)
)
BEGIN
-- Variaveis que irao guardar os valores que serao calculados
    declare v_preco_produto DECIMAL(10,2);
    declare v_subtotal DECIMAL(10,2);
    declare v_id_venda INT;
    declare v_pontos_ganhos INT;
 
-- Se houver erro de banco o rollback desfaz tudo
    declare exit HANDLER for sqlexception 
    BEGIN
        rollback;
        SIGNAL sqlstate '45000' set MESSAGE_TEXT = 'Deu ruim, operacao cancelada.';
    END;
 
    start transaction;
 
-- Pega o preco do produto
    select preco into v_preco_produto from tb_produto WHERE id_produto = p_id_produto;
-- Calcula o subtotal e os pontos
    SET v_subtotal = v_preco_produto * p_quantidade;
    SET v_pontos_ganhos = FLOOR(v_subtotal);
 
-- Abre a venda principal
    INSERT INTO tb_venda (id_cliente, valor_total, pontos_gerados)
    values (p_id_cliente, v_subtotal, v_pontos_ganhos);
 
-- Captura o ID da venda gerado
    set v_id_venda = LAST_INSERT_ID();
 
-- Grava o item que o cliente comprou
    INSERT INTO tb_item_venda (id_venda, id_produto, quantidade, valor_unitario, subtotal)
    values (v_id_venda, p_id_produto, p_quantidade, v_preco_produto, v_subtotal);
 
-- Registra como ele pagou
    INSERT INTO tb_pagamento (id_venda, tipo_pagamento, valor_pago, status_pagamento)
    values (v_id_venda, p_tipo_pagamento, v_subtotal, 'Aprovado');
 
-- Tira do estoque
    update tb_produto 
    set estoque = estoque - p_quantidade 
    where id_produto = p_id_produto;
 
-- Adiciona os pontos ganhos
    update tb_cliente 
    set saldo_pontos = saldo_pontos + v_pontos_ganhos 
    where id_cliente = p_id_cliente;
 
-- Confirma a gravacao
    commit;
END //
 
DELIMITER ;

DELIMITER //

CREATE PROCEDURE sp_registrar_produto(
IN p_nome VARCHAR(100),
IN p_descricao VARCHAR(255),
IN p_preco DECIMAL(10,2),
IN p_estoque INT,
IN p_categoria VARCHAR(50)
)
BEGIN

IF p_preco <= 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Preço inválido';
END IF;

IF p_estoque < 0 THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Estoque inválido';
END IF;

INSERT INTO tb_produto(
nome,
descricao,
preco,
estoque,
categoria
)
VALUES(
p_nome,
p_descricao,
p_preco,
p_estoque,
p_categoria
);

END//

DELIMITER ;

CREATE VIEW relatorio_vendas AS
SELECT
v.id_venda,
c.nome AS cliente,
v.data_venda,
v.valor_total
FROM tb_venda v
INNER JOIN tb_cliente c
ON v.id_cliente = c.id_cliente;

CREATE VIEW clientes_ativos AS
SELECT
c.id_cliente,
c.nome,
COUNT(v.id_venda) AS total_compras
FROM tb_cliente c
INNER JOIN tb_venda v
ON c.id_cliente = v.id_cliente
GROUP BY c.id_cliente,c.nome;

CREATE VIEW produtos_mais_vendidos AS
SELECT
p.nome,
SUM(iv.quantidade) AS total_vendido
FROM tb_produto p
INNER JOIN tb_item_venda iv
ON p.id_produto = iv.id_produto
GROUP BY p.nome
ORDER BY total_vendido DESC;