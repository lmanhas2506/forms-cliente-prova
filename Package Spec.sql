CREATE OR REPLACE PACKAGE PKG_CLIENTE AS

  GC_ERRO_VALIDACAO      CONSTANT PLS_INTEGER := -20001;
  GC_ERRO_UNICIDADE      CONSTANT PLS_INTEGER := -20002;
  GC_ERRO_NAO_ENCONTRADO CONSTANT PLS_INTEGER := -20003;

  FUNCTION FN_VALIDAR_EMAIL(P_EMAIL IN VARCHAR2) RETURN NUMBER;

  FUNCTION FN_NORMALIZAR_CEP(P_CEP IN VARCHAR2) RETURN VARCHAR2;

  PROCEDURE PRC_VALIDAR_DADOS(P_ID_CLIENTE IN TB_CLIENTE.ID_CLIENTE%TYPE,
                              P_NOME       IN TB_CLIENTE.NOME%TYPE,
                              P_EMAIL      IN TB_CLIENTE.EMAIL%TYPE,
                              P_CEP        IN TB_CLIENTE.CEP%TYPE,
                              P_LOGRADOURO IN TB_CLIENTE.LOGRADOURO%TYPE,
                              P_BAIRRO     IN TB_CLIENTE.BAIRRO%TYPE,
                              P_CIDADE     IN TB_CLIENTE.CIDADE%TYPE,
                              P_UF         IN TB_CLIENTE.UF%TYPE,
                              P_ATIVO      IN TB_CLIENTE.ATIVO%TYPE);

  PROCEDURE PRC_INSERIR_CLIENTE(P_NOME       IN TB_CLIENTE.NOME%TYPE,
                                P_EMAIL      IN TB_CLIENTE.EMAIL%TYPE,
                                P_CEP        IN TB_CLIENTE.CEP%TYPE,
                                P_LOGRADOURO IN TB_CLIENTE.LOGRADOURO%TYPE,
                                P_BAIRRO     IN TB_CLIENTE.BAIRRO%TYPE,
                                P_CIDADE     IN TB_CLIENTE.CIDADE%TYPE,
                                P_UF         IN TB_CLIENTE.UF%TYPE,
                                P_ATIVO      IN TB_CLIENTE.ATIVO%TYPE,
                                P_ID_OUT     OUT TB_CLIENTE.ID_CLIENTE%TYPE);

  PROCEDURE PRC_ATUALIZAR_CLIENTE(P_ID_CLIENTE IN TB_CLIENTE.ID_CLIENTE%TYPE,
                                  P_NOME       IN TB_CLIENTE.NOME%TYPE,
                                  P_EMAIL      IN TB_CLIENTE.EMAIL%TYPE,
                                  P_CEP        IN TB_CLIENTE.CEP%TYPE,
                                  P_LOGRADOURO IN TB_CLIENTE.LOGRADOURO%TYPE,
                                  P_BAIRRO     IN TB_CLIENTE.BAIRRO%TYPE,
                                  P_CIDADE     IN TB_CLIENTE.CIDADE%TYPE,
                                  P_UF         IN TB_CLIENTE.UF%TYPE,
                                  P_ATIVO      IN TB_CLIENTE.ATIVO%TYPE);

  PROCEDURE PRC_DELETAR_CLIENTE(P_ID_CLIENTE IN TB_CLIENTE.ID_CLIENTE%TYPE);

  PROCEDURE PRC_LISTAR_CLIENTES(P_NOME  IN TB_CLIENTE.NOME%TYPE,
                                P_EMAIL IN TB_CLIENTE.EMAIL%TYPE,
                                P_RC    OUT SYS_REFCURSOR);

END PKG_CLIENTE;
/
