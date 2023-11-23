USE projeto_financeiro_compras
DECLARE @nomeTabela NVARCHAR(250)


DECLARE trucateTables CURSOR FOR 
SELECT nome FROM  todasTabelas


OPEN trucateTables


FETCH NEXT FROM trucateTables INTO @nomeTabela


WHILE @@FETCH_STATUS = 0
BEGIN

    DECLARE @sql NVARCHAR(250)
    SET @sql = 'TRUNCATE TABLE ' + @nomeTabela
    EXEC sp_executesql @sql


    FETCH NEXT FROM trucateTables INTO @nomeTabela
END


CLOSE trucateTables


DEALLOCATE trucateTables
