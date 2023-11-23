#!/bin/bash

mysql -u root -p 1789-h localhost -e "CALL stage_compras.sp_tratamento_compras();"

