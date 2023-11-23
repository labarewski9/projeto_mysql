USE projeto_financeiro_compras;
DELIMITER //

CREATE TRIGGER tr_inserir_parcelas_compras AFTER INSERT ON projeto_financeiro_compras.NOTAS_FISCAIS_ENTRADA
FOR EACH ROW
BEGIN
    CALL sp_gerador_parcelas(NEW.ID_NF_ENTRADA, NEW.DATA_EMISSAO, NEW.VALOR_TOTAL, NEW.ID_CONDICAO);
END //

DELIMITER ;

