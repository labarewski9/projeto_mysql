
use projeto_financeiro_compras;
SET GLOBAL event_scheduler = ON;

-- Criar um evento diário para chamar as stored procedures em um horário específico (por exemplo, às 15:30)
DELIMITER //
CREATE EVENT processar_projeto_financeiro_compras_diariamente
ON SCHEDULE EVERY 1 DAY
STARTS TIMESTAMP(CURRENT_DATE, '13:24:00') -- Ajuste a hora conforme necessário
DO
BEGIN
  CALL sp_add_fornecedores();
  CALL sp_update_fornecedores();
  CALL sp_add_endereco_fornecedores();
  CALL sp_update_endereco_fornecedores();
  CALL sp_notas_fiscais_entrada();
  CALL sp_tratamento_pagamentos_efetuados();
  CALL sp_update_programacao_pagamento();
  CALL sp_pagamentos_efetuados_rejeitados();
END;
//
DELIMITER ;
drop EVENT processar_projeto_financeiro_compras_diariamente