USE projeto_financeiro_compras;
DELIMITER //

CREATE PROCEDURE sp_update_endereco_fornecedores()
BEGIN
    -- Desabilita o modo de atualização segura temporariamente
    SET SQL_SAFE_UPDATES = 0;

    -- Inicia a transação
    START TRANSACTION;

    -- Atualiza as linhas na tabela ENDERECOS_FORNECEDORES usando uma junção
    UPDATE projeto_financeiro_compras.ENDERECOS_FORNECEDORES AS ef
    JOIN projeto_financeiro_compras.FORNECEDORES AS f
        ON ef.ID_FORNECEDOR = f.ID_FORNECEDOR
    JOIN stage_compras.TRATAMENTO_COMPRAS_FINAL AS c
        ON f.CNPJ_FORNECEDOR = c.CNPJ_FORNECEDOR
    SET
        ef.CEP = c.CEP,
        ef.COMPLEMENTO = c.COMPLEMENTO,
        ef.NUMERO = c.NUM_ENDERECO
    WHERE ef.CEP != c.CEP
        OR ef.COMPLEMENTO != c.COMPLEMENTO
        OR ef.NUMERO != c.NUM_ENDERECO;

    -- Comita a transação
    COMMIT;

    -- Restaura o modo de atualização segura
    SET SQL_SAFE_UPDATES = 1;
END //

DELIMITER ;

