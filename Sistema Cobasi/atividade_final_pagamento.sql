-- Estrutura de Pagamentos: Scripts de tb_pagamento

CREATE DATABASE db_amigo_cobasi;
USE db_amigo_cobasi;

CREATE TABLE pagamento(
	id_pagamento INT AUTO_INCREMENT PRIMARY KEY,
	id_venda INT UNIQUE,
	tipo_pagamento VARCHAR(30),
	valor_pago DECIMAL(10,2),
	data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
	status_pagamento VARCHAR(20),

	FOREIGN KEY(id_venda)
	REFERENCES tb_venda(id_venda)
);