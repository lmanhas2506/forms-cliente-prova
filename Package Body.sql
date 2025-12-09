CREATE OR REPLACE PACKAGE BODY PKG_CLIENTE AS

  FUNCTION UF_VALIDA(P_UF IN VARCHAR2) RETURN BOOLEAN IS
    V_UF VARCHAR2(2) := UPPER(TRIM(P_UF));
  BEGIN
    IF V_UF IS NULL THEN
      RETURN TRUE;
    END IF;
  
    IF V_UF IN ('AC',
                'AL',
                'AP',
                'AM',
                'BA',
                'CE',
                'DF',
                'ES',
                'GO',
                'MA',
                'MT',
                'MS',
                'MG',
                'PA',
                'PB',
                'PR',
                'PE',
                'PI',
                'RJ',
                'RN',
                'RS',
                'RO',
                'RR',
                'SC',
                'SP',
                'SE',
                'TO') THEN
      RETURN TRUE;
    ELSE
      RETURN FALSE;
    END IF;
  END UF_VALIDA;

  FUNCTION FN_VALIDAR_EMAIL(P_EMAIL IN VARCHAR2) RETURN NUMBER IS
    V_EMAIL VARCHAR2(320) := TRIM(P_EMAIL);
  BEGIN
    IF V_EMAIL IS NULL THEN
      RETURN 0;
    END IF;
  
    IF REGEXP_LIKE(V_EMAIL,
                   '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$') THEN
      RETURN 1;
    ELSE
      RETURN 0;
    END IF;
  END FN_VALIDAR_EMAIL;

  FUNCTION FN_NORMALIZAR_CEP(P_CEP IN VARCHAR2) RETURN VARCHAR2 IS
    V_CEP VARCHAR2(8);
  BEGIN
    IF P_CEP IS NULL THEN
      RETURN NULL;
    END IF;
  
    V_CEP := REGEXP_REPLACE(P_CEP, '[^0-9]', '');
  
    RETURN V_CEP;
  END FN_NORMALIZAR_CEP;

  PROCEDURE PRC_VALIDAR_DADOS(P_ID_CLIENTE IN TB_CLIENTE.ID_CLIENTE%TYPE,
                              P_NOME       IN TB_CLIENTE.NOME%TYPE,
                              P_EMAIL      IN TB_CLIENTE.EMAIL%TYPE,
                              P_CEP        IN TB_CLIENTE.CEP%TYPE,
                              P_LOGRADOURO IN TB_CLIENTE.LOGRADOURO%TYPE,
                              P_BAIRRO     IN TB_CLIENTE.BAIRRO%TYPE,
                              P_CIDADE     IN TB_CLIENTE.CIDADE%TYPE,
                              P_UF         IN TB_CLIENTE.UF%TYPE,
                              P_ATIVO      IN TB_CLIENTE.ATIVO%TYPE) IS
    V_NOME  TB_CLIENTE.NOME%TYPE := TRIM(P_NOME);
    V_EMAIL TB_CLIENTE.EMAIL%TYPE := TRIM(P_EMAIL);
    V_CEP   TB_CLIENTE.CEP%TYPE := FN_NORMALIZAR_CEP(P_CEP);
    V_UF    TB_CLIENTE.UF%TYPE := UPPER(TRIM(P_UF));
  BEGIN

    IF V_NOME IS NULL THEN
      RAISE_APPLICATION_ERROR(GC_ERRO_VALIDACAO,
                              'Nome do cliente é obrigatório.');
    END IF;
  
    IF FN_VALIDAR_EMAIL(V_EMAIL) = 0 THEN
      RAISE_APPLICATION_ERROR(GC_ERRO_VALIDACAO,
                              'E-mail do cliente é obrigatório e deve ser válido.');
    END IF;
  
    IF P_CEP IS NOT NULL THEN
      IF V_CEP IS NULL OR LENGTH(V_CEP) <> 8 THEN
        RAISE_APPLICATION_ERROR(GC_ERRO_VALIDACAO,
                                'CEP deve conter exatamente 8 dígitos numéricos.');
      END IF;
    END IF;
  
    IF NOT UF_VALIDA(V_UF) THEN
      RAISE_APPLICATION_ERROR(GC_ERRO_VALIDACAO,
                              'UF inválida. Informe uma UF brasileira válida (ex.: SP, RJ, MG).');
    END IF;
  
    IF P_ATIVO NOT IN (0, 1) THEN
      RAISE_APPLICATION_ERROR(GC_ERRO_VALIDACAO,
                              'Campo ATIVO deve ser 0 ou 1.');
    END IF;
  
    NULL;
  END PRC_VALIDAR_DADOS;

  PROCEDURE PRC_INSERIR_CLIENTE(P_NOME       IN TB_CLIENTE.NOME%TYPE,
                                P_EMAIL      IN TB_CLIENTE.EMAIL%TYPE,
                                P_CEP        IN TB_CLIENTE.CEP%TYPE,
                                P_LOGRADOURO IN TB_CLIENTE.LOGRADOURO%TYPE,
                                P_BAIRRO     IN TB_CLIENTE.BAIRRO%TYPE,
                                P_CIDADE     IN TB_CLIENTE.CIDADE%TYPE,
                                P_UF         IN TB_CLIENTE.UF%TYPE,
                                P_ATIVO      IN TB_CLIENTE.ATIVO%TYPE,
                                P_ID_OUT     OUT TB_CLIENTE.ID_CLIENTE%TYPE) IS
    V_CEP TB_CLIENTE.CEP%TYPE;
    V_UF  TB_CLIENTE.UF%TYPE;
  BEGIN

    PRC_VALIDAR_DADOS(P_ID_CLIENTE => NULL,
                      P_NOME       => P_NOME,
                      P_EMAIL      => P_EMAIL,
                      P_CEP        => P_CEP,
                      P_LOGRADOURO => P_LOGRADOURO,
                      P_BAIRRO     => P_BAIRRO,
                      P_CIDADE     => P_CIDADE,
                      P_UF         => P_UF,
                      P_ATIVO      => P_ATIVO);
  
    V_CEP := FN_NORMALIZAR_CEP(P_CEP);
    V_UF  := UPPER(TRIM(P_UF));
  
    INSERT INTO TB_CLIENTE
      (ID_CLIENTE,
       NOME,
       EMAIL,
       CEP,
       LOGRADOURO,
       BAIRRO,
       CIDADE,
       UF,
       ATIVO,
       DT_CRIACAO)
    VALUES
      (seq_cliente.Nextval,
       TRIM(P_NOME),
       TRIM(P_EMAIL),
       V_CEP,
       TRIM(P_LOGRADOURO),
       TRIM(P_BAIRRO),
       TRIM(P_CIDADE),
       V_UF,
       P_ATIVO,
       SYSTIMESTAMP)
    RETURNING ID_CLIENTE INTO P_ID_OUT;
  
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(GC_ERRO_UNICIDADE,
                              'Já existe um cliente cadastrado com o e-mail informado.');
  END PRC_INSERIR_CLIENTE;

  PROCEDURE PRC_ATUALIZAR_CLIENTE(P_ID_CLIENTE IN TB_CLIENTE.ID_CLIENTE%TYPE,
                                  P_NOME       IN TB_CLIENTE.NOME%TYPE,
                                  P_EMAIL      IN TB_CLIENTE.EMAIL%TYPE,
                                  P_CEP        IN TB_CLIENTE.CEP%TYPE,
                                  P_LOGRADOURO IN TB_CLIENTE.LOGRADOURO%TYPE,
                                  P_BAIRRO     IN TB_CLIENTE.BAIRRO%TYPE,
                                  P_CIDADE     IN TB_CLIENTE.CIDADE%TYPE,
                                  P_UF         IN TB_CLIENTE.UF%TYPE,
                                  P_ATIVO      IN TB_CLIENTE.ATIVO%TYPE) IS
    V_CEP TB_CLIENTE.CEP%TYPE;
    V_UF  TB_CLIENTE.UF%TYPE;
  BEGIN

    PRC_VALIDAR_DADOS(P_ID_CLIENTE => P_ID_CLIENTE,
                      P_NOME       => P_NOME,
                      P_EMAIL      => P_EMAIL,
                      P_CEP        => P_CEP,
                      P_LOGRADOURO => P_LOGRADOURO,
                      P_BAIRRO     => P_BAIRRO,
                      P_CIDADE     => P_CIDADE,
                      P_UF         => P_UF,
                      P_ATIVO      => P_ATIVO);
  
    V_CEP := FN_NORMALIZAR_CEP(P_CEP);
    V_UF  := UPPER(TRIM(P_UF));

    UPDATE TB_CLIENTE
       SET NOME           = TRIM(P_NOME),
           EMAIL          = TRIM(P_EMAIL),
           CEP            = V_CEP,
           LOGRADOURO     = TRIM(P_LOGRADOURO),
           BAIRRO         = TRIM(P_BAIRRO),
           CIDADE         = TRIM(P_CIDADE),
           UF             = V_UF,
           ATIVO          = P_ATIVO,
           DT_ATUALIZACAO = SYSTIMESTAMP
     WHERE ID_CLIENTE = P_ID_CLIENTE;
  
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(GC_ERRO_NAO_ENCONTRADO,
                              'Cliente não encontrado para atualização.');
    END IF;
  
  EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
      RAISE_APPLICATION_ERROR(GC_ERRO_UNICIDADE,
                              'Já existe um cliente cadastrado com o e-mail informado.');
  END PRC_ATUALIZAR_CLIENTE;

  PROCEDURE PRC_DELETAR_CLIENTE(P_ID_CLIENTE IN TB_CLIENTE.ID_CLIENTE%TYPE) IS
  BEGIN
    DELETE FROM TB_CLIENTE WHERE ID_CLIENTE = P_ID_CLIENTE;
  
    IF SQL%ROWCOUNT = 0 THEN
      RAISE_APPLICATION_ERROR(GC_ERRO_NAO_ENCONTRADO,
                              'Cliente não encontrado para exclusão.');
    END IF;
  END PRC_DELETAR_CLIENTE;

  PROCEDURE PRC_LISTAR_CLIENTES(P_NOME  IN TB_CLIENTE.NOME%TYPE,
                                P_EMAIL IN TB_CLIENTE.EMAIL%TYPE,
                                P_RC    OUT SYS_REFCURSOR) IS
  BEGIN
    OPEN P_RC FOR
      SELECT ID_CLIENTE,
             NOME,
             EMAIL,
             CEP,
             LOGRADOURO,
             BAIRRO,
             CIDADE,
             UF,
             ATIVO,
             DT_CRIACAO,
             DT_ATUALIZACAO
        FROM TB_CLIENTE
       WHERE (P_NOME IS NULL OR
             UPPER(NOME) LIKE '%' || UPPER(TRIM(P_NOME)) || '%')
         AND (P_EMAIL IS NULL OR
             UPPER(EMAIL) LIKE '%' || UPPER(TRIM(P_EMAIL)) || '%')
       ORDER BY NOME;
  END PRC_LISTAR_CLIENTES;

END PKG_CLIENTE;
/
