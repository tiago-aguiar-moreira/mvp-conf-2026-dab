-- 1. Quais produtos estão com estoque abaixo de 100 unidades?
SELECT nome, estoque FROM Produtos WHERE estoque < 100 ORDER BY estoque;

-- 2. Qual a média de valor dos pedidos, e quantos estão com status 'em_aberto'?
SELECT AVG(valor_total) AS media_valor,
       SUM(CASE WHEN status='em_aberto' THEN 1 ELSE 0 END) AS total_em_aberto
FROM Pedidos;

-- 3. Quais produtos o cliente Diego Martins Alves comprou?
SELECT p.nome, ip.quantidade, ip.preco_unitario
  FROM Clientes c
  JOIN Pedidos pe ON pe.cliente_id = c.id
  JOIN ItensPedido ip ON ip.pedido_id = pe.id
  JOIN Produtos p ON p.id = ip.produto_id
 WHERE c.nome = 'Diego Martins Alves';

-- 4. Algum cliente tem pedido cancelado recentemente? Quem, e qual o valor?
  SELECT c.nome, pe.id AS pedido, pe.data_pedido, pe.valor_total
    FROM Pedidos pe
    JOIN Clientes c ON c.id = pe.cliente_id
   WHERE pe.status = 'cancelado'
ORDER BY pe.data_pedido DESC;