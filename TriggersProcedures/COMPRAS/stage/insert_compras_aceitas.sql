use stage_compras;
DELIMITER //

DROP PROCEDURE IF EXISTS sp_inserir_validacao_compras//
CREATE PROCEDURE sp_inserir_validacao_compras()
BEGIN
    -- Início da transação
    START TRANSACTION;

    -- Inserir dados na tabela VALIDACAO_COMPRAS
    INSERT INTO stage_compras.VALIDACAO_COMPRAS (DATA_PROCESSAMENTO, DATA_EMISAO, NUM_NF, CNPJ_FORNECEDOR)
    SELECT DISTINCT DATA_PROCESSAMENTO, DATA_EMISSAO, NUMERO_NF, CNPJ_FORNECEDOR
    FROM stage_compras.TRATAMENTO_COMPRAS_FINAL;

    -- Commit da transação
    COMMIT;
END//

DELIMITER ;

