-- Procedure de Clientes: Script da sp_cadastrar_cliente (Responsável: Erik).

USE bd_cobasi;
delimiter //
-- procedure para cadastrar os clientes com dados de entrada
create procedure sp_cadastrar_cliente(
	in p_nome VARCHAR(100),
	in p_cpf VARCHAR(100),
	in P_email VARCHAR(100),
	in p_telefone VARCHAR(15),
	in p_senha varchar(100)
	
);

DELIMITER ;

 begin
-- se o nome ficar em banco trava o cadastro e exibe erro
    if p_nome is null or p_nome = '' then
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'nome nao pode ficar vazio';
    end if;
	
-- verificar se tem o arroba no email para nao dar b.o
		if p_email not like '%@%' then
			signal SQLSTATE '45000' set MESSAGE_TEXT = 'email invalido, precisa de um @ arroba'
		end if;
		
