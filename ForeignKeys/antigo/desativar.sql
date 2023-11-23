USE projeto_financeiro_compras
DECLARE @chaveEstrangeira NVARCHAR(250)
DECLARE	@tabelaOrigem NVARCHAR(250)
		


DECLARE desativarChaves CURSOR FOR 
SELECT [Chave Estrangera], [Tabela Origem] FROM chaves_estrangeiras


OPEN desativarChaves


FETCH NEXT FROM desativarChaves INTO @chaveEstrangeira, @tabelaOrigem


WHILE @@FETCH_STATUS = 0
BEGIN

    DECLARE @sql NVARCHAR(250)
    SET @sql = 'ALTER TABLE ' + @tabelaOrigem + ' DROP CONSTRAINT ' + @chaveEstrangeira
    EXEC sp_executesql @sql

	update chaves_estrangeiras set Status = 'Desativa' where [Chave Estrangera] =  @chaveEstrangeira 

    FETCH NEXT FROM desativarChaves INTO @chaveEstrangeira, @tabelaOrigem
END


CLOSE desativarChaves


DEALLOCATE desativarChaves