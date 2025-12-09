CREATE TABLE tb_cliente (
    id_cliente      NUMBER(10)        NOT NULL,
    nome            VARCHAR2(100)     NOT NULL,
    email           VARCHAR2(150),
    cep             VARCHAR2(8),
    logradouro      VARCHAR2(150),
    bairro          VARCHAR2(100),
    cidade          VARCHAR2(100),
    uf              CHAR(2),
    ativo           NUMBER(1)         DEFAULT 1 NOT NULL,
    dt_criacao      TIMESTAMP         DEFAULT SYSTIMESTAMP NOT NULL,
    dt_atualizacao  TIMESTAMP
);

ALTER TABLE tb_cliente
  ADD CONSTRAINT pk_tb_cliente
  PRIMARY KEY (id_cliente);

ALTER TABLE tb_cliente
  ADD CONSTRAINT uq_tb_cliente_email
  UNIQUE (email);

ALTER TABLE tb_cliente
  ADD CONSTRAINT ck_tb_cliente_ativo
  CHECK (ativo IN (0,1));

ALTER TABLE tb_cliente
  ADD CONSTRAINT ck_tb_cliente_uf
  CHECK (uf IN (
    'AC','AL','AP','AM','BA','CE','DF','ES','GO',
    'MA','MT','MS','MG','PA','PB','PR','PE','PI',
    'RJ','RN','RS','RO','RR','SC','SP','SE','TO'
  ));

CREATE SEQUENCE seq_cliente
  START WITH 1
  INCREMENT BY 1
  NOCACHE;

CREATE OR REPLACE TRIGGER trg_cliente_bi
BEFORE INSERT ON tb_cliente
FOR EACH ROW
BEGIN
   IF :NEW.id_cliente IS NULL THEN
      :NEW.id_cliente := seq_cliente.NEXTVAL;
   END IF;

   IF :NEW.dt_criacao IS NULL THEN
      :NEW.dt_criacao := SYSTIMESTAMP;
   END IF;
END;
/

CREATE TABLE tb_log_erro (
   id_log        NUMBER(10),
   dt_evento     TIMESTAMP      DEFAULT SYSTIMESTAMP,
   usuario       VARCHAR2(50),
   origem        VARCHAR2(100),
   mensagem      VARCHAR2(4000)
);
