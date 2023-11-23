USE projeto_financeiro_compras
DECLARE @chaveEstrangeira NVARCHAR(250)
DECLARE	@tabelaOrigem NVARCHAR(250)
DECLARE	@tabelaReferencia NVARCHAR(250)
DECLARE	@ColunaOrigem NVARCHAR(250)
DECLARE	@ColunaReferencia NVARCHAR(250)




DECLARE ativarChaves CURSOR FOR
SELECT [Chave Estrangera], [Tabela Origem], [Tabela Referenciada], [Coluna Tabela Origem], [Coluna Tabela Referenciada] FROM chaves_estrangeiras


OPEN ativarChaves

FETCH NEXT FROM ativarChaves INTO @chaveEstrangeira, @tabelaOrigem, @tabelaReferencia, @ColunaOrigem, @ColunaReferencia

WHILE @@FETCH_STATUS = 0
BEGIN
	DECLARE @sql NVARCHAR(MAX)
    SET @sql = 'ALTER TABLE ' +@tabelaOrigem+ ' ADD CONSTRAINT '+@chaveEstrangeira+' FOREIGN KEY('+@ColunaOrigem+') REFERENCES ' + @tabelaReferencia+'('+@ColunaReferencia+')'
    EXEC sp_executesql @sql
	update chaves_estrangeiras set Status = 'Ativa' where [Chave Estrangera] =  @chaveEstrangeira 

    FETCH NEXT FROM ativarChaves INTO @chaveEstrangeira, @tabelaOrigem, @tabelaReferencia, @ColunaOrigem, @ColunaReferencia
END

CLOSE ativarChaves

DEALLOCATE ativarChaves