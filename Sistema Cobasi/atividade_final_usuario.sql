-- Estrutura de Usuários: Scripts de tb_usuario

CREATE DATABASE db_amigo_cobasi;
USE db_amigo_cobasi;

-- Tabela de usuários
CREATE TABLE usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    telefone VARCHAR(20),
    senha VARCHAR(255) NOT NULL,
    saldo_pontos INT DEFAULT 0,
    data_cadastro DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Segurança do Banco: Controle de acesso, permissões e criptografia

-- Administrador
CREATE USER 'admin_cobasi'@'localhost'
IDENTIFIED BY 'Admin@123';

GRANT SELECT, INSERT, UPDATE
ON db_amigo_cobasi.*
TO 'admin_cobasi'@'localhost';

FLUSH PRIVILEGES;