/*O script a seguir tem como objetivo as seguintes ações:
   1. Criação do usuário carlos, com autorização para criar bancos de dados, e usuários.
   2. O segundo objetivo é a criação de um banco de dados chamado uvv, tendo carlos como dono, codificado em UTF-8, 
      linguagem em português, usando o template0 do postgresql e permitindo conexões.
   3. Trocar de usuário sem desconectar do superuser postegres.
   4. Implementar o banco de dados recursos humanos (RH) no banco de dados uvv.
*/

-- função responsável pela criação do usúario dono do banco de dados (carlos).

CREATE USER carlos
WITH 
PASSWORD 'computacao@raiz'
CREATEDB
CREATEROLE
;
-- função de criação do banco de dados uvv, dono do banco estabelecido como carlos. 

CREATE DATABASE uvv                                   
WITH 
OWNER = carlos
ENCODING = "UTF8"
LC_COLLATE = 'pt_BR.UTF-8'
LC_CTYPE = 'pt_BR.UTF-8'
TEMPLATE = template0
ALLOW_CONNECTIONS = true
;

/*A partir desse ponto serão criados os esquemas (schemas) e todas as alterações necessarias como:
   1. Autorização para a criação de esquemas.
   2. Criação de esquemas.
   3. Mudança do esquema padrão.
*/

-- Troca de usuário postgres, para o usuário criado anteriormente (carlos).

\c "dbname=uvv user=carlos password=computacao@raiz"
 
-- Autorização para o usuário carlos criar esquemas.

CREATE SCHEMA hr  AUTHORIZATION carlos;

-- troca o esquema padrão, public para o esquema hr .

SET SEARCH_PATH TO hr, "$user", public;

ALTER USER carlos
SET SEARCH_PATH TO hr, "$user", public;

-- comando responsável pela criação da tabela regiões, e seus respectivos campos.

CREATE TABLE regioes (
                id_regiao INTEGER NOT NULL,  -- campo da tabela que atua como primary key e guarda dados a respeito do id de cada região.
                nome VARCHAR(25) NOT NULL,  -- Campo responsável por guardar dados à respeito do nome das regiões. 
                CONSTRAINT regioes_pk PRIMARY KEY (id_regiao) -- comando que define a primary key da tabela da tabela regioes.
);



CREATE UNIQUE INDEX regiao_ak -- Comando resposável pela criação do unique index da tabela regiões.
 ON regioes
 ( nome );

-- comando responsável pela criação da tabela países, e seus respectivos campos. 

CREATE TABLE paises (
                id_pais CHAR(2) NOT NULL,  -- campo da tabela que atua como primary key e guarda dados a respeito do identificador (id) de cada país.
                nome_ VARCHAR(50),  -- campo da tabela guarda dados a respeito do nome de cada país.
                id_regiao INTEGER NOT NULL,  -- campo da tabela que atua como foreign key da tabela e guarda dados a respeito do id de cada região da tabela regiões.
                CONSTRAINT paises_pk PRIMARY KEY (id_pais) -- comando que define a primary key da tabela paises.
);

/* Comando responsável por criar a tabela localizações.
   Observeção: Esse campo cria uma tabela a respeito da localização de cada departamento,
   e não sobre a localização e endereço do funcionário. */

CREATE TABLE localizacoes (
                id_localizacao INTEGER NOT NULL, -- Campo da tabela que atua como primary key e guarda dados a respeito do identificador (id) de cada localização.
                endereço VARCHAR(50), -- campo da tabela guarda dados a respeito do endereço de um departamento (bairro, rua, número, etc).
                cep VARCHAR(12), -- campo da tabela guarda dados a respeito do cep referente a localização de cada departamento.
                cidade VARCHAR(50) NOT NULL, -- campo da tabela guarda dados a respeito do nome de cada cidade referente a localização de cada departamento.
                uf VARCHAR(25), -- campo da tabela guarda dados a respeito do uf referente a localização de cada departamento.
                id_pais CHAR(2) NOT NULL, -- campo da tabela que atua como foreign key da tabela e guarda dados a respeito do identificador (id) de cada país
                CONSTRAINT localizacoes_pk PRIMARY KEY (id_localizacao) -- comando que define a primary key da tabela localizações.
);

-- comando responsável por criar a tabela departamentos, e seus respectivos campos.

CREATE TABLE departamentos (
                id_departamento INTEGER NOT NULL, -- Campo da tabela que atua como primary key e guarda dados a respeito do identificador (id) de cada departamento.
                nome VARCHAR(50) NOT NULL, -- campo da tabela guarda dados a respeito do nome de cada departamento.
                id_localizacao INTEGER NOT NULL, -- campo da tabela que atua como foreign key da tabela e guarda dados a respeito do identificador (id) da localização.
                id_supervisor INTEGER , -- campo da tabela que guarda dados a respeito do identificador (id) do supervisor desse departamento.
                CONSTRAINT departamentos_pk PRIMARY KEY (id_departamento) -- comando que define a primary key da tabela departamentos.
);


CREATE UNIQUE INDEX departamentos_ak -- comando responsável por criara o unique index da tabela departamentos. 
 ON departamentos
 ( nome );

-- comando responsável pela criação da tabela empregados, e seus respectivos campos.

CREATE TABLE empregados (
                id_empregado INTEGER NOT NULL, -- Campo da tabela que atua como primary key e guarda dados a respeito do identificador (id) de cada empregado.
                nome VARCHAR(75) NOT NULL, -- campo da tabela guarda dados a respeito do nome de cada empregado.
                email VARCHAR(35) NOT NULL, -- campo da tabela guarda dados a respeito do email de cada empregado (antes do @).
                telefone VARCHAR(20), -- campo da tabela guarda dados a respeito do número de telefone de cada empregado.
                data_contratacao DATE NOT NULL, -- campo da tabela guarda dados a respeito da data de contratçao de cada funcionário.
                id_cargos VARCHAR(10) NOT NULL, -- campo da tabela que atua como foreign key da tabela e guarda dados a respeito do identificador (id) de cada cargo.
                salario  NUMERIC(8,2) NOT NULL,  -- campo da tabela que guarda dados a respeito do salario de cada empregado.
                comissao DECIMAL(4,2),  -- campo da tabela que guarda dados a respeito da comissão de cada empregado.
                id_supervisor INTEGER, -- campo da tabela que atua como foreign key da tabela e guarda dados a respeito do identificador (id) de cada supervisor.
                id_departamento INTEGER,  -- campo da tabela que guarda dados a respeito do identificador (id) do departamento de cada empregado.
                CONSTRAINT empregados_pk PRIMARY KEY (id_empregado)  -- comando que define a primary key da tabela emrpegados.
);


CREATE UNIQUE INDEX empregados_ak -- comando responsável por criara o unique index da tabela empregados.
 ON empregados
 ( email );

 -- comando responsável pela criação da tabela cargos, e seus respectivos campos.

CREATE TABLE cargos (
                id_cargos VARCHAR(10) NOT NULL,  -- Campo da tabela que atua como primary key e guarda dados a respeito do identificador (id) de cada cargo.
                cargos VARCHAR(75) NOT NULL, -- campo da tabela que guarda dados a respeito do nome de cada cargo.
                salario_minimo DECIMAL(8,2), -- campo da tabela que guarda dados a respeito do salario mínimo de cada cargo.
                salario_maximo DECIMAL(8,2), -- campo da tabela que guarda dados a respeito do salario máximo de cada cargo.
                CONSTRAINT cargos_pk PRIMARY KEY (id_cargos) -- comando que define a primary key da tabela cargos.
);

 -- comando responsável pela criação da tabela cargos, e seus respectivos campos.

CREATE TABLE historico_cargos (
                id_departamento INTEGER NOT NULL,  -- Campo da tabela que atua como parte da composite key da tabela historico_cargos, guarda dados sobre o identificador (id) de cada departamento.
                id_cargos VARCHAR(10) NOT NULL,  -- Campo da tabela que atua como parte da composite key da tabela historico_cargos, guarda dados sobre o identificador (id) de cada cargo.
                id_empregado INTEGER NOT NULL,  -- Campo da tabela que atua como parta de composite key da tabela historico_cargos, guarda dados sobre o identificador (id) de cada empregados.
                data_final DATE NOT NULL, -- campo da tabela que guarda dados a respeito da data final do contrato, ou da data de demissão de cada empregado.
                data_inicial DATE NOT NULL,-- campo da tabela que guarda dados a respeito da data final do contrato, ou da data de demissão de cada empregado.
                CONSTRAINT historico_cargos_pk PRIMARY KEY (id_departamento, id_cargos, id_empregado) -- comando que define a primary key da tabela historico_cargos.
);

-- comando responsável pela criação da tabela empregados_departamentos, e seus respctivos campos.


CREATE TABLE empregados_departamentos (
                id_empregado INTEGER NOT NULL,  -- campo da tabela que atua como primary key e parte da chave composta, guarda dados a respeito do identificador (id) de cada empregado.
                id_departamento INTEGER NOT NULL,  -- campo da tabela que atua como primary key e parte da chave composta, guarda dados a respeito do identificador (id) de cada departamento.
                nome_empregados VARCHAR(50),  -- Campo da tabela que retém o nome de cada empregado.
                nome_departamentos VARCHAR(50), -- Campo da tabela que reteḿ os dados do nome de cada departamento.
                CONSTRAINT empregados_departamentos_pk PRIMARY KEY (id_empregado, id_departamento) -- comando que define a composite key da tabela empregados_departamentos.
);

/*Logo abaixo seguem os comandos de inserções de dados.
  (obs: esses dados vieram do banco de dados hr,
  disponibilizado pela oracle para estudos, por se tratar
  de um banco de dados em ingles os dados estão em inglês.*/

-- serie de comandos que irão inserir dados na tabela regiões (id_regiao e o nome da região).

INSERT INTO hr.regioes (id_regiao, nome) VALUES
(5, 'america do norte');
INSERT INTO hr.regioes (id_regiao, nome) VALUES
(1, 'Europe');
INSERT INTO hr.regioes (id_regiao, nome) VALUES
(2, 'Americas');
INSERT INTO hr.regioes (id_regiao, nome) VALUES
(3, 'Asia');
INSERT INTO hr.regioes (id_regiao, nome) VALUES
(4, 'Middle East and Africa');

-- serie de comandos que irão inserir dados na tabela paises (id_pais, nome do pais e id_região).

INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('AR', 'Argentina', 2);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('AU', 'Australia', 3);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('BE', 'Belgium', 1);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('BR', 'Brasil', 5);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('CA', 'Canada', 2);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('CH', 'Switzerland', 1);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('CN', 'China', 3);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('DE', 'Germany', 1);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('DK', 'Denmark', 1);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('EG', 'Egypt', 4);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('FR', 'France', 1);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('IL', 'Israel', 4);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('IN', 'India', 3);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('IT', 'Italy', 1);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('JP', 'Japan', 3);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('KW', 'Kuwait', 4);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('ML', 'Malaysia', 3);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('MX', 'Mexico', 2);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('NG', 'Nigeria', 4);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('NL', 'Netherlands', 1);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('SG', 'Singapore', 3);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('UK', 'United Kingdom', 1);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('US', 'United States of America', 2);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('ZM', 'Zambia', 4);
INSERT INTO hr.paises (id_pais, nome_, id_regiao) VALUES
('ZW', 'Zimbabwe', 4);

-- serie de comandos que irão inserir dados na tabela localizações (id_localizavao, endereço, cep, cidade, uf e id_pais).

INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(9999, 'null', 'null','vila velha','ES','BR');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(999, 'null', 'null','vila velha','ES','BR');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(1000, '1297 Via Cola di Rie', '00989','Roma','null','IT');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(1100, '93091 Calle della Testa', '10934','Venice','null','IT');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(1200, '2017 Shinjuku-ku', '1689','Tokyo','Tokyo Prefecture','JP');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(1300, '9450 Kamiya-cho', '6823','Hiroshima','null','JP');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(1400, '2014 Jabberwocky Rd', '26192','Southlake','Texas','US');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(1500, '2011 Interiors Blvd', '99236','South San Francisco','California','US');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(1600, '2007 Zagora St', '50090','South Brunswick','New Jersey','US');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(1700, '2004 Charade Rd', '98199','Seattle','Washington','US');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(1800, '147 Spadina Ave', 'M5V 2L7','Toronto','Ontario','CA');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(1900, '6092 Boxwood St', 'YSW 9T2','Whitehorse','Yukon','CA');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(2000, '40-5-12 Laogianggen', '190518','Beijing','null','CN');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(2100, '1298 Vileparle (E)', '490231','Bombay','Maharashtra','IN');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(2200, '12-98 Victoria Street', '2901','Sydney','New South Wales','AU');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(2300, '198 Clementi North', '540198','Singapore','null','SG');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(2400, '8204 Arthur St', 'null','London','null','UK');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB','Oxford','Oxford','UK');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(2600, '9702 Chester Road', '09629850293','Stretford','Manchester','UK');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(2700, 'Schwanthalerstr. 7031', '80925','Munich','Bavaria','DE');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(2800, 'Rua Frei Caneca 1360 ', '01307-002','Sao Paulo','Sao Paulo','BR');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(2900, '20 Rue des Corps-Saints', '1730','Geneva','Geneve','CH');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(3000, 'Murtenstrasse 921', '3095','Bern','BE','CH');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(3100, 'Pieter Breughelstraat 837', '3029SK','Utrecht','Utrecht','NL');
INSERT INTO hr.localizacoes (id_localizacao, endereço, cep, cidade, uf, id_pais) VALUES
(3200, 'Mariano Escobedo 9991', '11932','Mexico City','Distrito Federal,','MX');

-- serie de comandos que irão inserir dados na tabela departamentos (id_departamento, nome do departamento e id_localizacao).

INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(5555, 'educacional uvv', 9999,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(10, 'Administration', 1700,200);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(20, 'Marketing', 1800,201);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(30, 'Purchasing', 1700,114);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(40, 'Human Resources', 2400,203);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(50, 'Shipping', 1500,121);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(60, 'IT', 1400,103);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(70, 'Public Relations', 2700,204);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(80, 'Sales', 2500,145);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(90, 'Executive', 1700,100);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(100, 'Finance', 1700,108);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(110, 'Accounting', 1700,205);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(120, 'Treasury', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(130, 'Corporate Tax', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(140, 'Control And Credit', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(150, 'Shareholder Services', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(160, 'Benefits', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(170, 'Manufacturing', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(180, 'Construction', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(190, 'Contracting', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(200, 'Operations', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(210, 'IT Support', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(220, 'NOC', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(230, 'IT Helpdesk', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(240, 'Government Sales', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(250, 'Retail Sales', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(260, 'Recruiting', 1700,null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_supervisor) VALUES
(270, 'Payroll', 1700,null);

-- serie de comandos que irão inserir dados na tabela empregados (id_empregado, nome, email,telefone, data_contratacao, id_cargos, salario, comissao,id_supervisore id_departamento)

INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(100, 'Steven King', 'SKING', '515.123.4567', '2003-06-17', 'AD_PRES', 24000, null, null, 90);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(101, 'Neena Kochhar', 'NKOCHHAR', '515.123.4568', '2005-09-21', 'AD_VP', 17000, null, 100, 90);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(102, 'Lex De Haan', 'LDEHAAN', '515.123.4569', '2001-01-13', 'AD_VP', 17000, null, 100, 90);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(103, 'Alexander Hunold', 'AHUNOLD', '590.423.4567', '2006-01-03', 'IT_PROG', 9000, null, 102, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(104, 'Bruce Ernst', 'BERNST', '590.423.4568', '2007-05-21', 'IT_PROG', 6000, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(105, 'David Austin', 'DAUSTIN', '590.423.4569', '2005-06-25', 'IT_PROG', 4800, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(106, 'Valli Pataballa', 'VPATABAL', '590.423.4560', '2006-02-05', 'IT_PROG', 4800, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(107, 'Diana Lorentz', 'DLORENTZ', '590.423.5567', '2007-02-07', 'IT_PROG', 4200, null, 103, 60);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(108, 'Nancy Greenberg', 'NGREENBE', '515.124.4569', '2002-08-17', 'FI_MGR', 12008, null, 101, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(109, 'Daniel Faviet', 'DFAVIET', '515.124.4169', '2002-08-16', 'FI_ACCOUNT', 9000, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(110, 'John Chen', 'JCHEN', '515.124.4269', '2005-09-28', 'FI_ACCOUNT', 8200, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(111, 'Ismael Sciarra', 'ISCIARRA', '515.124.4369', '2005-09-30', 'FI_ACCOUNT', 7700, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(112, 'Jose Manuel Urman', 'JMURMAN', '515.124.4469', '2006-03-07', 'FI_ACCOUNT', 7800, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(113, 'Luis Popp', 'LPOPP', '515.124.4567', '2007-12-07', 'FI_ACCOUNT', 6900, null, 108, 100);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(114, 'Den Raphaely', 'DRAPHEAL', '515.127.4561', '2002-12-07', 'PU_MAN', 11000, null, 100, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(115, 'Alexander Khoo', 'AKHOO', '515.127.4562', '2003-05-18', 'PU_CLERK', 3100, null, 114, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(116, 'Shelli Baida', 'SBAIDA', '515.127.4563', '2005-12-24', 'PU_CLERK', 2900, null, 114, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(117, 'Sigal Tobias', 'STOBIAS', '515.127.4564', '2005-07-24', 'PU_CLERK', 2800, null, 114, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(118, 'Guy Himuro', 'GHIMURO', '515.127.4565', '2006-11-15', 'PU_CLERK', 2600, null, 114, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(119, 'Karen Colmenares', 'KCOLMENA', '515.127.4566', '2007-08-10', 'PU_CLERK', 2500, null, 114, 30);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(120, 'Matthew Weiss', 'MWEISS', '650.123.1234', '2004-07-18', 'ST_MAN', 8000, null, 100, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(121, 'Adam Fripp', 'AFRIPP', '650.123.2234', '2005-04-10', 'ST_MAN', 8200, null, 100, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(122, 'Payam Kaufling', 'PKAUFLIN', '650.123.3234', '2003-05-01', 'ST_MAN', 7900, null, 100, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(123, 'Shanta Vollman', 'SVOLLMAN', '650.123.4234', '2005-10-10', 'ST_MAN', 6500, null, 100, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(124, 'Kevin Mourgos', 'KMOURGOS', '650.123.5234', '2007-11-16', 'ST_MAN', 5800, null, 100, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(125, 'Julia Nayer', 'JNAYER', '650.124.1214', '2005-07-16', 'ST_CLERK', 3200, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(126, 'Irene Mikkilineni', 'IMIKKILI', '650.124.1224', '2006-09-28', 'ST_CLERK', 2700, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(127, 'James Landry', 'JLANDRY', '650.124.1334', '2007-01-14', 'ST_CLERK', 2400, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(128, 'Steven Markle', 'SMARKLE', '650.124.1434', '2008-03-08', 'ST_CLERK', 2200, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(129, 'Laura Bissot', 'LBISSOT', '650.124.5234', '2005-08-20', 'ST_CLERK', 3300, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(130, 'Mozhe Atkinson', 'MATKINSO', '650.124.6234', '2005-10-30', 'ST_CLERK', 2800, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(131, 'James Marlow', 'JAMRLOW', '650.124.7234', '2005-02-16', 'ST_CLERK', 2500, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(132, 'TJ Olson', 'TJOLSON', '650.124.8234', '2007-04-10', 'ST_CLERK', 2100, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(133, 'Jason Mallin', 'JMALLIN', '650.127.1934', '2004-06-14', 'ST_CLERK', 3300, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(134, 'Michael Rogers', 'MROGERS', '650.127.1834', '2006-08-26', 'ST_CLERK', 2900, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(135, 'Ki Gee', 'KGEE', '650.127.1734', '2007-12-12', 'ST_CLERK', 2400, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(136, 'Hazel Philtanker', 'HPHILTAN', '650.127.1634', '2008-02-06', 'ST_CLERK', 2200, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(137, 'Renske Ladwig', 'RLADWIG', '650.121.1234', '2003-07-14', 'ST_CLERK', 3600, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(138, 'Stephen Stiles', 'SSTILES', '650.121.2034', '2005-10-26', 'ST_CLERK', 3200, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(139, 'John Seo', 'JSEO', '650.121.2019', '2006-02-12', 'ST_CLERK', 2700, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(140, 'Joshua Patel', 'JPATEL', '650.121.1834', '2006-04-06', 'ST_CLERK', 2500, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(141, 'Trenna Rajs', 'TRAJS', '650.121.8009', '2003-10-17', 'ST_CLERK', 3500, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(142, 'Curtis Davies', 'CDAVIES', '650.121.2994', '2005-01-29', 'ST_CLERK', 3100, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(143, 'Randall Matos', 'RMATOS', '650.121.2874', '2006-03-15', 'ST_CLERK', 2600, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(144, 'Peter Vargas', 'PVARGAS', '650.121.2004', '2006-07-09', 'ST_CLERK', 2500, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(145, 'John Russell', 'JRUSSEL', '011.44.1344.429268', '2004-10-01', 'SA_MAN', 14000, .4, 100, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(146, 'Karen Partners', 'KPARTNER', '011.44.1344.467268', '2005-01-05', 'SA_MAN', 13500, .3, 100, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(147, 'Alberto Errazuriz', 'AERRAZUR', '011.44.1344.429278', '2005-03-10', 'SA_MAN', 12000, .3, 100, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(148, 'Gerald Cambrault', 'GCAMBRAU', '011.44.1344.619268', '2007-10-15', 'SA_MAN', 11000, .3, 100, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(149, 'Eleni Zlotkey', 'EZLOTKEY', '011.44.1344.429018', '2008-01-29', 'SA_MAN', 10500, .2, 100, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(150, 'Peter Tucker', 'PTUCKER', '011.44.1344.129268', '2005-01-30', 'SA_REP', 10000, .3, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(151, 'David Bernstein', 'DBERNSTE', '011.44.1344.345268', '2005-03-24', 'SA_REP', 9500, .25, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(152, 'Peter Hall', 'PHALL', '011.44.1344.478968', '2005-08-20', 'SA_REP', 9000, .25, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(153, 'Christopher Olsen', 'COLSEN', '011.44.1344.498718', '2006-03-30', 'SA_REP', 8000, .2, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(154, 'Nanette Cambrault', 'NCAMBRAU', '011.44.1344.987668', '2006-12-09', 'SA_REP', 7500, .2, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(155, 'Oliver Tuvault', 'OTUVAULT', '011.44.1344.486508', '2007-11-23', 'SA_REP', 7000, .15, 145, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(156, 'Janette King', 'JKING', '011.44.1345.429268', '2004-01-30', 'SA_REP', 10000, .35, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(157, 'Patrick Sully', 'PSULLY', '011.44.1345.929268', '2004-03-04', 'SA_REP', 9500, .35, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(158, 'Allan McEwen', 'AMCEWEN', '011.44.1345.829268', '2004-08-01', 'SA_REP', 9000, .35, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(159, 'Lindsey Smith', 'LSMITH', '011.44.1345.729268', '2005-03-10', 'SA_REP', 8000, .3, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(160, 'Louise Doran', 'LDORAN', '011.44.1345.629268', '2005-12-15', 'SA_REP', 7500, .3, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(161, 'Sarath Sewall', 'SSEWALL', '011.44.1345.529268', '2006-11-03', 'SA_REP', 7000, .25, 146, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(162, 'Clara Vishney', 'CVISHNEY', '011.44.1346.129268', '2005-11-11', 'SA_REP', 10500, .25, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(163, 'Danielle Greene', 'DGREENE', '011.44.1346.229268', '2007-03-19', 'SA_REP', 9500, .15, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(164, 'Mattea Marvins', 'MMARVINS', '011.44.1346.329268', '2008-01-24', 'SA_REP', 7200, .1, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(165, 'David Lee', 'DLEE', '011.44.1346.529268', '2008-02-23', 'SA_REP', 6800, .1, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(166, 'Sundar Ande', 'SANDE', '011.44.1346.629268', '2008-03-24', 'SA_REP', 6400, .1, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(167, 'Amit Banda', 'ABANDA', '011.44.1346.729268', '2008-04-21', 'SA_REP', 6200, .1, 147, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(168, 'Lisa Ozer', 'LOZER', '011.44.1343.929268', '2005-03-11', 'SA_REP', 11500, .25, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(169, 'Harrison Bloom', 'HBLOOM', '011.44.1343.829268', '2006-03-23', 'SA_REP', 10000, .2, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(170, 'Tayler Fox', 'TFOX', '011.44.1343.729268', '2006-01-24', 'SA_REP', 9600, .2, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(171, 'William Smith', 'WSMITH', '011.44.1343.629268', '2007-02-23', 'SA_REP', 7400, .15, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(172, 'Elizabeth Bates', 'EBATES', '011.44.1343.529268', '2007-03-24', 'SA_REP', 7300, .15, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(173, 'Sundita Kumar', 'SKUMAR', '011.44.1343.329268', '2008-04-21', 'SA_REP', 6100, .1, 148, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(174, 'Ellen Abel', 'EABEL', '011.44.1644.429267', '2004-05-11', 'SA_REP', 11000, .3, 149, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(175, 'Alyssa Hutton', 'AHUTTON', '011.44.1644.429266', '2005-03-19', 'SA_REP', 8800, .25, 149, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(176, 'Jonathon Taylor', 'JTAYLOR', '011.44.1644.429265', '2006-03-24', 'SA_REP', 8600, .2, 149, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(177, 'Jack Livingston', 'JLIVINGS', '011.44.1644.429264', '2006-04-23', 'SA_REP', 8400, .2, 149, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(178, 'Kimberely Grant', 'KGRANT', '011.44.1644.429263', '2007-05-24', 'SA_REP', 7000, .15, 149, null);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(179, 'Charles Johnson', 'CJOHNSON', '011.44.1644.429262', '2008-01-04', 'SA_REP', 6200, .1, 149, 80);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(180, 'Winston Taylor', 'WTAYLOR', '650.507.9876', '2006-01-24', 'SH_CLERK', 3200, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(181, 'Jean Fleaur', 'JFLEAUR', '650.507.9877', '2006-02-23', 'SH_CLERK', 3100, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(182, 'Martha Sullivan', 'MSULLIVA', '650.507.9878', '2007-06-21', 'SH_CLERK', 2500, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(183, 'Girard Geoni', 'GGEONI', '650.507.9879', '2008-02-03', 'SH_CLERK', 2800, null, 120, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(184, 'Nandita Sarchand', 'NSARCHAN', '650.509.1876', '2004-01-27', 'SH_CLERK', 4200, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(185, 'Alexis Bull', 'ABULL', '650.509.2876', '2005-02-20', 'SH_CLERK', 4100, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(186, 'Julia Dellinger', 'JDELLING', '650.509.3876', '2006-06-24', 'SH_CLERK', 3400, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(187, 'Anthony Cabrio', 'ACABRIO', '650.509.4876', '2007-02-07', 'SH_CLERK', 3000, null, 121, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(188, 'Kelly Chung', 'KCHUNG', '650.505.1876', '2005-06-14', 'SH_CLERK', 3800, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(189, 'Jennifer Dilly', 'JDILLY', '650.505.2876', '2005-08-13', 'SH_CLERK', 3600, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(190, 'Timothy Gates', 'TGATES', '650.505.3876', '2006-07-11', 'SH_CLERK', 2900, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(191, 'Randall Perkins', 'RPERKINS', '650.505.4876', '2007-12-19', 'SH_CLERK', 2500, null, 122, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(192, 'Sarah Bell', 'SBELL', '650.501.1876', '2004-02-04', 'SH_CLERK', 4000, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(193, 'Britney Everett', 'BEVERETT', '650.501.2876', '2005-03-03', 'SH_CLERK', 3900, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(194, 'Samuel McCain', 'SMCCAIN', '650.501.3876', '2006-07-01', 'SH_CLERK', 3200, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(195, 'Vance Jones', 'VJONES', '650.501.4876', '2007-03-17', 'SH_CLERK', 2800, null, 123, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(196, 'Alana Walsh', 'AWALSH', '650.507.9811', '2006-04-24', 'SH_CLERK', 3100, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(197, 'Kevin Feeney', 'KFEENEY', '650.507.9822', '2006-05-23', 'SH_CLERK', 3000, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(198, 'Donald OConnell', 'DOCONNEL', '650.507.9833', '2007-06-21', 'SH_CLERK', 2600, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(199, 'Douglas Grant', 'DGRANT', '650.507.9844', '2008-01-13', 'SH_CLERK', 2600, null, 124, 50);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(200, 'Jennifer Whalen', 'JWHALEN', '515.123.4444', '2003-09-17', 'AD_ASST', 4400, null, 101, 10);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(201, 'Michael Hartstein', 'MHARTSTE', '515.123.5555', '2004-02-17', 'MK_MAN', 13000, null, 100, 20);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(202, 'Pat Fay', 'PFAY', '603.123.6666', '2005-08-17', 'MK_REP', 6000, null, 201, 20);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(203, 'Susan Mavris', 'SMAVRIS', '515.123.7777', '2002-06-07', 'HR_REP', 6500, null, 101, 40);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(204, 'Hermann Baer', 'HBAER', '515.123.8888', '2002-06-07', 'PR_REP', 10000, null, 101, 70);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(205, 'Shelley Higgins', 'SHIGGINS', '515.123.8080', '2002-06-07', 'AC_MGR', 12008, null, 101, 110);
INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargos, salario, comissao,
id_supervisor, id_departamento) VALUES
(206, 'William Gietz', 'WGIETZ', '515.123.8181', '2002-06-07', 'AC_ACCOUNT', 8300, null, 205, 110);

-- serie de comandos que irão inserir dados na tabela cargos (id_cargos, cargos, salario_minimo e salario_maximo)

INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('AD_PRES', 'President', 20080,40000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('AD_VP', 'Administration Vice President', 15000,30000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('AD_ASST', 'Administration Assistant', 3000,6000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('FI_MGR', 'Finance Manager', 8200,16000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('FI_ACCOUNT', 'Accountant', 4200,9000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('AC_MGR', 'Accounting Manager', 8200,16000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('AC_ACCOUNT', 'Public Accountant', 4200,9000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('SA_MAN', 'Sales Manager', 10000,20080);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('SA_REP', 'Sales Representative', 6000,12008);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('PU_MAN', 'Purchasing Manager', 8000,15000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('PU_CLERK', 'Purchasing Clerk', 2500,5500);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('ST_MAN', 'Stock Manager', 5500,8500);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('ST_CLERK', 'Stock Clerk', 2008,5000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('SH_CLERK', 'Shipping Clerk', 2500,5500);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('IT_PROG', 'Programmer', 4000,10000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('MK_MAN', 'Marketing Manager', 9000,15000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('MK_REP', 'Marketing Representative', 4000,9000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('HR_REP', 'Human Resources Representative', 4000,9000);
INSERT INTO hr.cargos (id_cargos, cargos, salario_minimo, salario_maximo) VALUES
('PR_REP', 'Public Relations Representative', 4500,10500);

-- serie de comandos que irão inserir dados na tabela historico_cargos (id_departamentos, id_cargos, id_empregados, data_final e data_inicial).

INSERT INTO hr.historico_cargos (id_departamento,id_cargos,id_empregado, data_final, data_inicial) VALUES
(60, 'IT_PROG', 102,'2006-07-24','2001-01-13');
INSERT INTO hr.historico_cargos (id_departamento,id_cargos,id_empregado, data_final, data_inicial) VALUES
(110, 'AC_ACCOUNT', 101,'2001-10-27','1997-09-21');
INSERT INTO hr.historico_cargos (id_departamento,id_cargos,id_empregado, data_final, data_inicial) VALUES
(110, 'AC_MGR', 101,'2005-03-15','2001-10-28');
INSERT INTO hr.historico_cargos (id_departamento,id_cargos,id_empregado, data_final, data_inicial) VALUES
(20, 'MK_REP', 201,'2007-12-19','2004-02-17');
INSERT INTO hr.historico_cargos (id_departamento,id_cargos,id_empregado, data_final, data_inicial) VALUES
(50, 'ST_CLERK', 114,'2007-12-31','2006-03-24');
INSERT INTO hr.historico_cargos (id_departamento,id_cargos,id_empregado, data_final, data_inicial) VALUES
(50, 'ST_CLERK', 122,'2007-12-31','2007-01-01');
INSERT INTO hr.historico_cargos (id_departamento,id_cargos,id_empregado, data_final, data_inicial) VALUES
(90, 'AD_ASST', 200,'2001-06-17','1995-09-17');
INSERT INTO hr.historico_cargos (id_departamento,id_cargos,id_empregado, data_final, data_inicial) VALUES
(80, 'SA_REP', 176,'2006-12-31','2006-03-24');
INSERT INTO hr.historico_cargos (id_departamento,id_cargos,id_empregado, data_final, data_inicial) VALUES
(80, 'SA_MAN', 176,'2007-12-31','2007-01-01');
INSERT INTO hr.historico_cargos (id_departamento,id_cargos,id_empregado, data_final, data_inicial) VALUES
(90, 'AC_ACCOUNT', 200,'2006-12-31','2002-07-01');

--depattamentos_empregados

INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(200,10, 'Jennifer Whalen', 'Administration');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(201,20, 'Michael Hartstein', 'Marketing');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(202,20, 'Pat Fay', 'Marketing');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(114,30, 'Den Raphaely', 'Purchasing');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(115,30, 'Alexander Khoo', 'Purchasing');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(116,30, 'Shelli Baida', 'Purchasing');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(117,30, 'Sigal Tobias', 'Purchasing');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(118,30, 'Guy Himuro', 'Purchasing');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(119,30, 'Karen Colmenares', 'Purchasing');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(203,40, 'Susan Mavris', 'Human Resources');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(120,50, 'Matthew Weiss', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(121,50, 'Adam Fripp', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(122,50, 'Payam Kaufling', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(123,50, 'Shanta Vollman', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(124,50, 'Kevin Mourgos', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(125,50, 'Julia Nayer', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(126,50, 'Irene Mikkilineni', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(127,50, 'James Landry', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(128,50, 'Steven Markle', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(129,50, 'Laura Bissot', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(130,50, 'Mozhe Atkinson', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(131,50, 'James Marlow', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(132,50, 'TJ Olson', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(133,50, 'Jason Mallin', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(134,50, 'Michael Rogers', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(135,50, 'Ki Gee', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(136,50, 'Hazel Philtanker', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(137,50, 'Renske Ladwig', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(138,50, 'Stephen Stiles', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(139,50, 'John Seo', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(140,50, 'Joshua Patel', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(141,50, 'Trenna Rajs', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(142,50, 'Curtis Davies', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(143,50, 'Randall Matos', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(144,50, 'Peter Vargas', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(180,50, 'Winston Taylor', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(181,50, 'Jean Fleaur', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(182,50, 'Martha Sullivan', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(183,50, 'Girard Geoni', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(184,50, 'Nandita Sarchand', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(185,50, 'Alexis Bull', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(186,50, 'Julia Dellinger', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(187,50, 'Anthony Cabrio', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(188,50, 'Kelly Chung', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(189,50, 'Jennifer Dilly', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(190,50, 'Timothy Gates', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(191,50, 'Randall Perkins', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(192,50, 'Sarah Bell', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(193,50, 'Britney Everett', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(194,50, 'Samuel McCain', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(195,50, 'Vance Jones', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(196,50, 'Alana Walsh', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(197,50, 'Kevin Feeney', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(198,50, 'Donald OConnell', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(199,50, 'Douglas Grant', 'Shipping');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(103,60, 'Alexander Hunold', 'IT');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(104,60, 'Bruce Ernst', 'IT');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(105,60, 'David Austin', 'IT');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(106,60, 'Valli Pataballa', 'IT');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(107,60, 'Diana Lorentz', 'IT');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(204,70, 'Hermann Baer', 'Public Relations');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(145,80, 'John Russell', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(146,80, 'Karen Partners', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(147,80, 'Alberto Errazuriz', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(148,80, 'Gerald Cambrault', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(149,80, 'Eleni Zlotkey', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(150,80, 'Peter Tucker', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(151,80, 'David Bernstein', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(152,80, 'Peter Hall', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(153,80, 'Christopher Olsen', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(154,80, 'Nanette Cambrault', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(155,80, 'Oliver Tuvault', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(156,80, 'Janette King', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(157,80, 'Patrick Sully', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(158,80, 'Allan McEwen', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(159,80, 'Lindsey Smith', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(160,80, 'Louise Doran', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(161,80, 'Sarath Sewall', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(162,80, 'Clara Vishney', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(163,80, 'Danielle Greene', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(164,80, 'Mattea Marvins', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(165,80, 'David Lee', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(166,80, 'Sundar Ande', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(167,80, 'Amit Banda', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(168,80, 'Lisa Ozer', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(169,80, 'Harrison Bloom', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(170,80, 'Tayler Fox', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(171,80, 'William Smith', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(172,80, 'Elizabeth Bates', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(173,80, 'Sundita Kumar', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(174,80, 'Ellen Abel', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(175,80, 'Alyssa Hutton', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(176,80, 'Jonathon Taylor', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(177,80, 'Jack Livingston', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(179,80, 'Charles Johnson', 'Sales');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(100,90, 'Steven King', 'Executive');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(101,90, 'Neena Kochhar', 'Executive');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(102,90, 'Lex De Haan', 'Executive');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(108,100, 'Nancy Greenberg', 'Finance');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(109,100, 'Daniel Faviet', 'Finance');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(110,100, 'John Chen', 'Finance');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(111,100, 'Ismael Sciarra', 'Finance');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(112,100, 'Jose Manuel Urman', 'Finance');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(113,100, 'Luis Popp', 'Finance');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(205,110, 'Shelley Higgins', 'Accounting');
INSERT INTO empregados_departamentos (id_empregado, id_departamento, nome_empregados, nome_departamentos) VALUES
(206,110, 'William Gietz', 'Accounting');

/*A baixo seguem os comandos relativos a criação das foreing keys das tabelas e os relacionamentos entre elas.
  (obs: Note que teremos a criação de foreign keys e ao mesmo tempo*/


ALTER TABLE empregados_departamentos ADD CONSTRAINT empregados_empregados_departamentos_fk -- comando que estabelece a foreign key da tabela empregados_departamentos, relacionando-a tabela empregados.
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
NOT DEFERRABLE;

ALTER TABLE empregados_departamentos ADD CONSTRAINT departamentos_empregados_departamentos_fk -- comando que estabelece a foreign key da tabela empregados_departamentos, relacionando-a tabela departamentos.
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
NOT DEFERRABLE;

ALTER TABLE paises ADD CONSTRAINT regioes_paises_fk -- comando que estabelece a foreign key da tabela paises, relacionando-a tabela regiões.
FOREIGN KEY (id_regiao)
REFERENCES regioes (id_regiao)
NOT DEFERRABLE;

ALTER TABLE localizacoes ADD CONSTRAINT paises_localizacoes_fk -- comando que estabelece a foreign key da tabela localizações, relacionando-a tabela paises.
FOREIGN KEY (id_pais)
REFERENCES paises (id_pais)
NOT DEFERRABLE;

ALTER TABLE departamentos ADD CONSTRAINT localizacoes_departamentos_fk -- comando que estabelece a foreign key da tabela departamentis, relacionando-a tabela localizações.
FOREIGN KEY (id_localizacao)
REFERENCES localizacoes (id_localizacao)
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk -- comando que estabelece a foreign key da tabela historico_cargos, relacionando-a tabela departamentos (parte da composite key).
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
NOT DEFERRABLE;


ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk -- comando que estabelece a foreign key da tabela historico_cargos, relacionando-a tabela empregados (parte da composite key).
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
NOT DEFERRABLE;


ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk -- comando que estabelece a foreign key da tabela empregados, relacionando-a tabela empregados (note que será criado um auto_relacionamento.).
FOREIGN KEY (id_supervisor)
REFERENCES empregados (id_empregado)
NOT DEFERRABLE;

ALTER TABLE departamentos ADD CONSTRAINT supervisor_departamentos_fk  -- comando que estabelece a foreign key da tabela departamentos, relacionando-a tabela empregados.
FOREIGN KEY (id_supervisor)
REFERENCES empregados (id_empregado)
NOT DEFERRABLE;

ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk -- comando que estabelece a foreign key da tabela historico_cargos, relacionando-a tabela cargos (parte da composite key).
FOREIGN KEY (id_cargos)
REFERENCES cargos (id_cargos)
NOT DEFERRABLE;

ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk -- comando que estabelece a foreign key da tabela empregados, relacionando-a tabela cargos.
FOREIGN KEY (id_cargos)
REFERENCES cargos (id_cargos)
NOT DEFERRABLE;
