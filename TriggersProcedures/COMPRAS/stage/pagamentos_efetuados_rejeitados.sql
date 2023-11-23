USE projeto_financeiro_compras;
-- PAGAMENTOS EFETUADOS QUE NÃO FORAM COMPUTADOS POR APRESENTAREM ERROS
DELIMITER //

CREATE PROCEDURE sp_pagamentos_efetuados_rejeitados()
BEGIN
    START TRANSACTION;

    -- Inserção na tabela de pagamentos efetuados rejeitados
    INSERT INTO stage_compras.PAGAMENTOS_EFETUADOS_REJEITADOS1
        SELECT
            ID_NF_ENTRADA,
            DATA_VENCIMENTO,
            DATA_PGT_EFETUADO,
            VALOR_PARCELA_PAGO,
            CASE
                WHEN ID_NF_ENTRADA NOT IN (SELECT ID_NF_ENTRADA FROM projeto_financeiro_compras.PROGRAMACAO_PAGAMENTO WHERE ID_NF_ENTRADA NOT LIKE 0)
                    AND DATA_VENCIMENTO NOT IN (SELECT DATA_VENCIMENTO FROM projeto_financeiro_compras.PROGRAMACAO_PAGAMENTO WHERE DATA_VENCIMENTO NOT LIKE '0000-00-00')
                THEN 'Pagamento não está condizente com nenhuma linha da programacao'
                ELSE 'Ok'
            END AS MOTIVO_INEXISTENCIA,
            CASE
                WHEN ID_NF_ENTRADA IS NULL
                    OR DATA_VENCIMENTO IS NULL
                    OR DATA_PGT_EFETUADO IS NULL OR DATA_PGT_EFETUADO LIKE '0000-00-00'
                    OR VALOR_PARCELA_PAGO IS NULL or VALOR_PARCELA_PAGO like 0.00
                THEN 'Favor verificar cada coluna da linha, existe(m) valor(es) nulo(s)'
                ELSE 'Ok'
            END AS MOTIVO_NULLS
        FROM stage_compras.PAGAMENTOS_EFETUADOS PE
        WHERE NOT EXISTS (
                SELECT 1
                FROM projeto_financeiro_compras.PROGRAMACAO_PAGAMENTO PP
                WHERE PE.ID_NF_ENTRADA = PP.ID_NF_ENTRADA
                    AND PE.DATA_VENCIMENTO = PP.DATA_VENCIMENTO
                    AND PP.STATUS_PAGAMENTO = 1
            );

    COMMIT;
    
    START TRANSACTION;
		insert into stage_compras.PAGAMENTOS_EFETUADOS_REJEITADOS
		select * from stage_compras.PAGAMENTOS_EFETUADOS_REJEITADOS1
		WHERE MOTIVO_NULL LIKE 'Favor verificar cada coluna da linha, existe(m) valor(es) nulo(s)'
        OR ID_NF_ENTRADA LIKE 0;
	COMMIT;

END //

DELIMITER ;


