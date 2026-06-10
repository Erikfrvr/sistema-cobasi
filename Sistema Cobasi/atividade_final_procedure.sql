CREATE DATABASE db_amigo_cobasi;
USE db_amigo_cobasi;

-- Procedure de Clientes: Script da sp_cadastrar_cliente

DELIMITER //

CREATE PROCEDURE sp_cadastrar_usuario(
IN p_nome VARCHAR(100),
IN p_cpf VARCHAR(14),
IN p_email VARCHAR(100),
IN p_telefone VARCHAR(20),
IN p_senha VARCHAR(100)
)
BEGIN

IF p_nome IS NULL OR p_nome = '' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Nome obrigatório';
END IF;

IF p_email NOT LIKE '%@%' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Email inválido';
END IF;

INSERT INTO cliente(
nome,
cpf,
email,
telefone,
senha
)
VALUES(
p_nome,
AES_ENCRYPT(p_cpf,'cobasi2026'),
p_email,
p_telefone,
AES_ENCRYPT(p_senha,'cobasi2026')
);

END//

DELIMITER ;

-- Procedure de Produtos: Script da sp_cadastrar_produto

DELIMITER //

CREATE PROCEDURE sp_cadastrar_produto(
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

INSERT INTO produto(
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