USE projeto_financeiro_compras
SELECT name as nome
INTO todasTabelas
FROM sys.tables where name != 'todasTabelas' and name != 'chaves_estrangeiras'