
use stage_compras;
SET GLOBAL event_scheduler = ON;

-- Criar um evento diário para chamar as stored procedures em um horário específico (por exemplo, às 15:30)
DELIMITER //
CREATE EVENT processar_compras_diariamente
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '13:20:00') -- Ajuste a hora conforme necessário
DO
BEGIN
  CALL sp_tratamento_compras();
  CALL sp_inserir_validacao_compras();
  CALL sp_compras_rejeitadas();
END;
//
DELIMITER ;
SHOW EVENTS;


drop EVENT processar_compras_diariamente
