CREATE DATABASE db_amigo_cobasi;
USE db_amigo_cobasi;

CREATE VIEW relatorio_vendas AS
SELECT
v.id_venda,
u.nome AS usuario,
v.data_venda,
v.valor_total
FROM venda v
INNER JOIN usuario u
ON v.id_cliente = u.id_cliente;

CREATE VIEW usuario_ativos AS
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