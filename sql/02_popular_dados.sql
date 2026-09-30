-- ============================================================
-- Demo Data API Builder — E-commerce
-- Script 2/2: massa de dados para a demo
-- ============================================================

USE DabDemoEcommerce;
GO

-- ------------------------------------------------------------
-- Clientes
-- ------------------------------------------------------------
INSERT INTO dbo.Clientes (nome, email, telefone, cpf, endereco) VALUES
    (N'Ana Beatriz Souza',   'ana.souza@exemplo.com',    '(11) 98888-1010', '11122233344', N'Rua das Palmeiras, 120 - São Paulo/SP'),
    (N'Bruno Carvalho Lima', 'bruno.lima@exemplo.com',   '(21) 97777-2020', '22233344455', N'Av. Atlântica, 500 - Rio de Janeiro/RJ'),
    (N'Camila Ferreira Dias','camila.dias@exemplo.com',  '(31) 96666-3030', '33344455566', N'Rua Bahia, 88 - Belo Horizonte/MG'),
    (N'Diego Martins Alves', 'diego.alves@exemplo.com',  '(41) 95555-4040', '44455566677', N'Rua XV de Novembro, 300 - Curitiba/PR'),
    (N'Elisa Nogueira Rocha','elisa.rocha@exemplo.com',  '(51) 94444-5050', '55566677788', N'Av. Ipiranga, 700 - Porto Alegre/RS');
GO

-- ------------------------------------------------------------
-- Produtos
-- ------------------------------------------------------------
INSERT INTO dbo.Produtos (nome, categoria, preco, estoque) VALUES
    (N'Fone de Ouvido Bluetooth',      N'Eletrônicos', 189.90,  120),
    (N'Teclado Mecânico Compacto',     N'Eletrônicos', 349.00,   45),
    (N'Mouse Sem Fio Ergonômico',      N'Eletrônicos',  99.90,  200),
    (N'Cafeteira Elétrica 1,5L',       N'Casa',        219.50,   60),
    (N'Garrafa Térmica 1L',            N'Casa',         79.90,  150),
    (N'Tênis Corrida Performance',     N'Esporte',     429.00,   80),
    (N'Mochila Notebook 15.6"',        N'Acessórios',  159.90,   95),
    (N'Luminária de Mesa LED',         N'Casa',         89.90,  110);
GO

-- ------------------------------------------------------------
-- Pedidos (cada um vinculado a um cliente)
-- ------------------------------------------------------------
INSERT INTO dbo.Pedidos (cliente_id, data_pedido, status, valor_total) VALUES
    (1, DATEADD(DAY, -6, SYSUTCDATETIME()), 'entregue',   289.80),
    (1, DATEADD(DAY, -1, SYSUTCDATETIME()), 'em_aberto',  349.00),
    (2, DATEADD(DAY, -3, SYSUTCDATETIME()), 'enviado',     99.90),
    (3, DATEADD(DAY, -9, SYSUTCDATETIME()), 'entregue',   299.40),
    (4, DATEADD(DAY, -2, SYSUTCDATETIME()), 'em_aberto',  429.00),
    (5, DATEADD(DAY, -4, SYSUTCDATETIME()), 'cancelado',   79.90);
GO

-- ------------------------------------------------------------
-- Itens de cada pedido
-- ------------------------------------------------------------
-- valor_total em Pedidos é um campo independente (não somado automaticamente
-- a partir dos itens) — mantido simples de propósito para a demo
INSERT INTO dbo.ItensPedido (pedido_id, produto_id, quantidade, preco_unitario) VALUES
    (1, 1, 1, 189.90),
    (1, 5, 1,  79.90),
    (2, 2, 1, 349.00),
    (3, 3, 1,  99.90),
    (4, 7, 1, 159.90),
    (4, 8, 1,  89.90),
    (4, 3, 1,  99.90),
    (5, 6, 1, 429.00),
    (6, 5, 1,  79.90);
GO

PRINT 'Dados inseridos com sucesso.';
GO
