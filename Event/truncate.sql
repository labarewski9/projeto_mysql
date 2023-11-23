use stage_compras;
SET GLOBAL event_scheduler = ON;

-- Criar um evento diário para chamar as stored procedures em um horário específico (por exemplo, às 15:30)
DELIMITER //
CREATE EVENT truncate_tables
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '13:26:00') -- Ajuste a hora conforme necessário
DO
BEGIN
  TRUNCATE TABLE stage_compras.COMPRAS;
  TRUNCATE TABLE stage_compras.PAGAMENTOS_EFETUADOS;
  TRUNCATE TABLE stage_compras.PAGAMENTOS_EFETUADOS;
  TRUNCATE TABLE stage_compras.TRATAMENTO_COMPRAS_FINAL;
  TRUNCATE TABLE stage_compras.TRATAMENTO_PAGAMENTOS_EFETUADOS;
  TRUNCATE TABLE stage_compras.TRATAMENTO_PAGAMENTOS_EFETUADOS1;
END;
//
DELIMITER ;

drop event truncate_tables