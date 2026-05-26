CREATE DATABASE IF NOT exists Barbearia;
USE Barbearia;

CREATE TABLE IF NOT EXISTS Cargo (
    id_cargo INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome_cargo varchar(50) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE IF NOT EXISTS Pessoa (
    id_pessoa INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome_completo varchar(100) NOT NULL,
    cpf varchar(14) UNIQUE NOT NULL,
    telefone varchar(15) NOT NULL,
    email_pessoal varchar(65) NOT NULL
);

CREATE TABLE IF NOT EXISTS Funcionario (
    id_funcionario INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_pessoa INT UNSIGNED NOT NULL,
    id_cargo INT UNSIGNED NOT NULL,
    data_contratacao DATE NOT NULL,
    salario DECIMAL(10,2) UNSIGNED NOT NULL,
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa),
    FOREIGN KEY (id_cargo) REFERENCES Cargo(id_cargo)
);

CREATE TABLE IF NOT EXISTS Servico (
    id_servico INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome_servico VARCHAR(50) NOT NULL UNIQUE,
    preco DECIMAL(10,2) UNSIGNED NOT NULL,
    duracao_minutos TINYINT UNSIGNED NOT NULL
);

CREATE TABLE IF NOT EXISTS Agendamento (
    id_agendamento INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_pessoa INT UNSIGNED NOT NULL,      
    id_funcionario INT UNSIGNED NOT NULL,
    id_servico INT UNSIGNED NOT NULL,  
    data_agendamento DATE NOT NULL,
    horario_inicio TIME NOT NULL,
    status ENUM
    ('Pendente', 'Confirmado', 'Cancelado', 'Finalizado') 
    DEFAULT 'Pendente',
   
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa),
    FOREIGN KEY (id_funcionario) REFERENCES Funcionario(id_funcionario),
    FOREIGN KEY (id_servico) REFERENCES Servico(id_servico),
    CONSTRAINT unique_agenda_barbeiro UNIQUE (id_funcionario, data_agendamento, horario_inicio)
);

CREATE TABLE IF NOT EXISTS tipo_pagamento (
    id_tipo_pagamento INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome_tipo ENUM
    ('Dinheiro', 'Cartao_Credito', 'Cartao_Debito', 'Pix') NOT NULL
);

CREATE TABLE IF NOT EXISTS Pagamento (
    id_pagamento INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_agendamento INT UNSIGNED NOT NULL,
    id_tipo_pagamento INT UNSIGNED NOT NULL,
    data_pagamento DATE NOT NULL,
    valor DECIMAL (10,2) UNSIGNED NOT NULL,
    status_pagamento ENUM
    ('Pendente', 'Confirmado', 'Cancelado', 'Finalizado' ) DEFAULT 'Pendente',
  
    FOREIGN KEY (id_agendamento) REFERENCES Agendamento(id_agendamento),
    FOREIGN KEY (id_tipo_pagamento) REFERENCES tipo_pagamento(id_tipo_pagamento)
);

CREATE TABLE IF NOT EXISTS Fornecedor (
    id_fornecedor INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    nome_empresa VARCHAR(100) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    telefone VARCHAR(15)
);

CREATE TABLE IF NOT EXISTS Produto (
    id_produto INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_fornecedor INT UNSIGNED NOT NULL,
    nome_produto VARCHAR(100) NOT NULL,
    preco_venda DECIMAL(10,2) UNSIGNED NOT NULL,
    estoque_atual INT UNSIGNED NOT NULL DEFAULT 0,
    FOREIGN KEY (id_fornecedor) REFERENCES Fornecedor(id_fornecedor)
);

CREATE TABLE IF NOT EXISTS venda_produto_registros (
    id_venda INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_produto INT UNSIGNED NOT NULL,
    id_pessoa INT UNSIGNED NOT NULL,
    quantidade TINYINT UNSIGNED NOT NULL DEFAULT 1,
    data_venda TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_produto) REFERENCES Produto(id_produto),
    FOREIGN KEY (id_pessoa) REFERENCES Pessoa(id_pessoa)
);


CREATE TABLE IF NOT EXISTS caixa_da_loja (
    id_fluxo INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_movimentacao
    ENUM
    ('Entrada',
    'Saida') NOT NULL,
  
    valor DECIMAL(10,2) UNSIGNED NOT NULL,
    descricao VARCHAR(255) NOT NULL
);

INSERT INTO Cargo (nome_cargo, descricao) 
VALUES
  ('Barbeiro',      'Responsável por cortes e acabamentos'),
  ('Recepcionista', 'Atendimento ao cliente e agendamentos'),
  ('Caixa',         'Controle de pagamentos e caixa'),
  ('Gerente',       'Supervisão geral da barbearia');


INSERT INTO Pessoa (nome_completo, cpf, telefone, email_pessoal) 
VALUES
  ('Carlos Eduardo Silva', '123.456.789-00', '(11) 99001-2345', 'carlos.silva@email.com'),
  ('Marcos Antônio Lima',  '234.567.890-11', '(11) 98002-3456', 'marcos.lima@email.com'),
  ('Rodrigo Ferreira',     '345.678.901-22', '(11) 97003-4567', 'rodrigo.ferreira@email.com'),
  ('Fernanda Costa',       '456.789.012-33', '(11) 96004-5678', 'fernanda.costa@email.com'),
  ('João Pedro Souza',     '567.890.123-44', '(11) 95005-6789', 'joao.souza@email.com'),
  ('Lucas Mendes',         '678.901.234-55', '(11) 94006-7890', 'lucas.mendes@email.com'),
  ('Ana Paula Rocha',      '789.012.345-66', '(11) 93007-8901', 'ana.rocha@email.com'),
  ('Bruno Carvalho',       '890.123.456-77', '(11) 92008-9012', 'bruno.carvalho@email.com');

INSERT INTO Funcionario (id_pessoa, id_cargo, data_contratacao, salario)  
VALUES
  (1, 1, '2022-03-15', 2800.00),
  (2, 1, '2021-07-01', 3100.00),
  (3, 4, '2020-01-10', 5500.00),
  (4, 2, '2023-05-20', 1900.00);

INSERT INTO Servico (nome_servico, preco, duracao_minutos)
VALUES
  ('Corte Simples',         35.00,  30),
  ('Corte + Barba',         55.00,  50),
  ('Barba Completa',        30.00,  25),
  ('Hidratação Capilar',    45.00,  40),
  ('Progressiva Masculina', 120.00, 90);


INSERT INTO Agendamento (id_pessoa, id_funcionario, id_servico, data_agendamento, horario_inicio, status)
VALUES
  (5, 1, 1, '2025-06-02', '09:00:00', 'Confirmado'),
  (6, 1, 2, '2025-06-02', '10:00:00', 'Confirmado'),
  (7, 2, 3, '2025-06-02', '09:30:00', 'Pendente'),
  (8, 2, 4, '2025-06-03', '14:00:00', 'Pendente'),
  (5, 1, 5, '2025-06-04', '11:00:00', 'Finalizado');
 

INSERT INTO tipo_pagamento (nome_tipo)  
VALUES
  ('Dinheiro'),
  ('Cartao_Credito'),
  ('Cartao_Debito'),
  ('Pix');

INSERT INTO Pagamento (id_agendamento, id_tipo_pagamento, data_pagamento, valor, status_pagamento) 
VALUES
  (1, 4, '2025-06-02',  35.00, 'Confirmado'),
  (2, 2, '2025-06-02',  55.00, 'Confirmado'),
  (3, 1, '2025-06-02',  30.00, 'Pendente'),
  (5, 3, '2025-06-04', 120.00, 'Finalizado');

INSERT INTO Fornecedor (nome_empresa, cnpj, telefone) 
VALUES
  ('Distribuidora Barber Pro', '12.345.678/0001-90', '(11) 3001-2222'),
  ('Cosméticos Estilo Ltda',   '23.456.789/0001-01', '(11) 3002-3333'),
  ('Top Cut Importações',      '34.567.890/0001-12', '(11) 3003-4444');

INSERT INTO Produto (id_fornecedor, nome_produto, preco_venda, estoque_atual)
VALUES
  (1, 'Pomada Modeladora 150g',    38.00, 40),
  (1, 'Óleo para Barba 30ml',      29.00, 25),
  (2, 'Shampoo Anticaspa 300ml',   24.00, 30),
  (2, 'Condicionador Barba 200ml', 26.00, 20),
  (3, 'Cera Matte 100g',           42.00, 15);

INSERT INTO venda_produto_registros (id_produto, id_pessoa, quantidade, data_venda) 
VALUES
  (1, 5, 1, '2025-06-02 09:45:00'),
  (2, 6, 2, '2025-06-02 11:00:00'),
  (3, 7, 1, '2025-06-02 14:30:00'),
  (5, 8, 1, '2025-06-03 10:15:00'),
  (1, 5, 1, '2025-06-04 12:00:00');


INSERT INTO caixa_da_loja (tipo_movimentacao, valor, descricao) 
VALUES
  ('Entrada', 35.00,  'Pagamento agendamento #1 - Pix'),
  ('Entrada', 55.00,  'Pagamento agendamento #2 - Cartão crédito'),
  ('Entrada', 120.00, 'Pagamento agendamento #5 - Cartão débito'),
  ('Entrada', 38.00,  'Venda produto - Pomada Modeladora'),
  ('Saida',   150.00, 'Compra de insumos - Distribuidora Barber Pro'),
  ('Saida',   80.00,  'Manutenção de equipamentos');
  
  select * from cargo;
  
  select valor, descricao from caixa_da_loja
  where valor >= 40;
  
  select * from Servico
  where  duracao_minutos = 30;
  
  
  SELECT pessoa.nome_completo,
       agendamento.data_agendamento
FROM pessoa
JOIN agendamento
ON pessoa.id_pessoa = agendamento.id_pessoa;


SELECT pessoa.nome_completo,
       servico.nome_servico,
       agendamento.horario_inicio
FROM agendamento
JOIN pessoa
ON agendamento.id_pessoa = pessoa.id_pessoa
JOIN servico
ON agendamento.id_servico = servico.id_servico;


SELECT pessoa.nome_completo,
       servico.nome_servico,
       agendamento.status
FROM agendamento
JOIN pessoa
ON agendamento.id_pessoa = pessoa.id_pessoa
JOIN servico
ON agendamento.id_servico = servico.id_servico
WHERE agendamento.status = 'Confirmado';
  
  