CREATE DATABASE IF NOT EXISTS bd_cobasi;
USE bd_cobasi;

-- Procedure de Clientes: Script da sp_cadastrar_cliente

DELIMITER //

CREATE PROCEDURE sp_cadastrar_cliente(
IN c_nome VARCHAR(100),
IN c_cpf VARCHAR(14),
IN c_email VARCHAR(100),
IN c_telefone VARCHAR(20),
IN c_senha VARCHAR(100)
)
BEGIN

IF u_nome IS NULL OR u_nome = '' THEN
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT='Nome obrigatório';
END IF;

IF c_email NOT LIKE '%@%' THEN
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
c_nome,
AES_ENCRYPT(c_cpf,'cobasi2026'),
c_email,
c_telefone,
AES_ENCRYPT(c_senha,'cobasi2026')
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