use projeto_financeiro_compras;
DELIMITER //

CREATE PROCEDURE sp_add_endereco_fornecedores()
BEGIN
    -- Iniciar transação
    START TRANSACTION;
    
		insert into projeto_financeiro_compras.ENDERECOS_FORNECEDORES (CEP, ID_FORNECEDOR, ID_TIPO_ENDERECO, NUMERO, COMPLEMENTO)
		select distinct
		cep.CEP,
		f.ID_FORNECEDOR,
		t.ID_TIPO_ENDERECO,
		c.NUM_ENDERECO,
		c.COMPLEMENTO
		from stage_compras.TRATAMENTO_COMPRAS_FINAL c
		inner join projeto_financeiro_compras.FORNECEDORES f
		on c.CNPJ_FORNECEDOR = f.CNPJ_FORNECEDOR
		inner join projeto_financeiro_compras.TIPO_ENDERECO t
		on c.TIPO_ENDERECO = t.DESCRICAO
		inner join projeto_financeiro_compras.CEP cep
		on c.CEP = cep.CEP
		where f.ID_FORNECEDOR not in (select ID_FORNECEDOR from projeto_financeiro_compras.ENDERECOS_FORNECEDORES);
		
		
		
    COMMIT;
END //

DELIMITER ;


