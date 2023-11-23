-- Habilitar o agendamento de eventos (caso ainda não esteja habilitado)
SET GLOBAL event_scheduler = ON;

-- Criar um evento para inserir os valores na tabela CONDICAO_PAGAMENTO uma vez
DELIMITER //
CREATE EVENT insert_condicao_pagamento
ON SCHEDULE AT '2023-11-10 09:27:00' -- Ajuste a data e hora conforme necessário
DO
BEGIN
  INSERT INTO projeto_financeiro_compras.CONDICAO_PAGAMENTO (DESCRICAO, QTD_PARCELAS, ENTRADA)
  VALUES
    ('A vista', 1, 1),
    ('30 dias', 1, 0),
    ('30/60 dias', 2, 0),
    ('30/60/90 dias', 3, 0),
    ('Entrada/30 dias', 2, 1),
    ('Entrada/30/60 dias', 3, 1),
    ('Entrada/30/60/90 dias', 4, 1);
END;
//
DELIMITER ;

