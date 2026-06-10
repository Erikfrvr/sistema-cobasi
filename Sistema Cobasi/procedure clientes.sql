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

DELIMITER //

 