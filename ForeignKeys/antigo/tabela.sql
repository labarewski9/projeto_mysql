USE projeto_financeiro_compras
select
fk.name as 'Chave Estrangera',
fk.object_id as 'ID da chave estrangera',
t.name as 'Tabela Referenciada',
c.name as 'Coluna Tabela Referenciada',
t2.name as 'Tabela Origem',
c2.name as 'Coluna Tabela Origem',
case 
 when fk.is_disabled = 0 then 'Ativa'
 else 'Desativada'
end as 'Status'
into chaves_estrangeiras
from sys.foreign_keys as fk
inner join sys.tables as t on t.object_id = fk.referenced_object_id 
inner join sys.tables as t2 on t2.object_id =  fk.parent_object_id
inner join sys.foreign_key_columns as fkc on fkc.constraint_object_id = fk.object_id
inner join sys.columns as c on c.column_id = fkc.referenced_column_id and c.object_id = t.object_id
inner join sys.columns as c2 on c2.column_id = fkc.parent_column_id and c2.object_id = t2.object_id