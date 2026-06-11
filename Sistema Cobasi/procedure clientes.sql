-- Procedure de Clientes: Script da sp_cadastrar_cliente (Responsável: Erik).

USE bd_cobasi;
DELIMITER //

DROP PROCEDURE IF EXISTS sp_cadastrar_cliente //

-- procedure para cadastrar os clientes com dados de entrada
create procedure sp_cadastrar_cliente(
    IN p_nome VARCHAR(100),
    IN p_cpf VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_telefone VARCHAR(15),
    IN p_senha VARCHAR(100)
)

 begin
-- se o nome ficar em banco trava o cadastro e exibe erro
 IF p_nome IS NULL OR p_nome = '' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'nome nao pode ficar vazio';
    END IF;
	
-- verificar se tem arroba no email para nao dar b.o
    IF p_email NOT LIKE '%@%' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'email invalido, precisa de um @ arroba';
    END IF;
		
-- Inserindo os dados na tabela e aplicando a criptografia
insert into tb_cliente(nome, cpf, email, telefone, senha)
   
    values(
        p_nome,
-- Escondendo o CPF no banco em formato binário
        AES_ENCRYPT(p_cpf, 'cobasi2026'), 
        p_email,
        p_telefone,
-- Criptografando a senha com a chave senha
        AES_ENCRYPT(p_senha, 'cobasi2026') 
    );
 
END //
 
DELIMITER ;