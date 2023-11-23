USE projeto_financeiro_compras;
DELIMITER //
CREATE PROCEDURE sp_notas_fiscais_entrada()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE ID_FOR INT;
    DECLARE ID_COND INT;
    DECLARE NUM_NF INT;
    DECLARE DT_EMISSAO DATE;
    DECLARE NET DECIMAL(16, 2);
    DECLARE TRIBUTO DECIMAL(16, 2);
    DECLARE TOTAL DECIMAL(16, 2);
    DECLARE ITEM VARCHAR(100);
    DECLARE QTD INT;

    DECLARE cur_finished CURSOR FOR
        SELECT DISTINCT
            f.ID_FORNECEDOR,
            cond.ID_CONDICAO,
            c.NUMERO_NF,
            c.DATA_EMISSAO,
            c.VALOR_NET,
            c.VALOR_TRIBUTO,
            c.VALOR_TOTAL,
            c.NOME_ITEM,
            c.QTD_ITEM
        FROM stage_compras.TRATAMENTO_COMPRAS_FINAL c
        INNER JOIN projeto_financeiro_compras.FORNECEDORES f ON c.CNPJ_FORNECEDOR = f.CNPJ_FORNECEDOR
        INNER JOIN projeto_financeiro_compras.CONDICAO_PAGAMENTO cond ON c.ID_CONDICAO_PAGAMENTO = cond.ID_CONDICAO;

    -- Error handling
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Start transaction
    START TRANSACTION;

    OPEN cur_finished;

    read_loop: LOOP
        FETCH cur_finished INTO ID_FOR, ID_COND, NUM_NF, DT_EMISSAO, NET, TRIBUTO, TOTAL, ITEM, QTD;

        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Insert data into the MySQL table
        INSERT INTO projeto_financeiro_compras.NOTAS_FISCAIS_ENTRADA (ID_FORNECEDOR, ID_CONDICAO, NUMERO_NF, DATA_EMISSAO, VALOR_NET, VALOR_TRIBUTO, VALOR_TOTAL, NOME_ITEM, QTD_ITEM)
        VALUES (ID_FOR, ID_COND, NUM_NF, DT_EMISSAO, NET, TRIBUTO, TOTAL, ITEM, QTD);
    END LOOP;

    -- Close cursor
    CLOSE cur_finished;

    -- Commit transaction
    COMMIT;
END//
DELIMITER ;


