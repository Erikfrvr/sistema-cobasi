--Transação: Script da finalização de compra com START TRANSACTION, COMMIT e ROLLBACK (Responsável: Erik).


USE bd_cobasi;

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

