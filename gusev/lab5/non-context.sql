--code for oracle
CREATE USER default_user IDENTIFIED BY pass;
GRANT CREATE SESSION TO default_user;
GRANT SELECT ON gusev.users TO default_user;
 
CREATE OR REPLACE FUNCTION GUSEV.MY_SECURITY_FUNCTION
(P_SCHEMA IN VARCHAR2, P_OBJECT IN VARCHAR2)
RETURN VARCHAR2
    AS
    BEGIN
      IF (USER = P_SCHEMA)  THEN
        RETURN '';
      ELSE
        RETURN 'username = (select user from dual)';
      END IF;
    END;
   
BEGIN
  DBMS_RLS.ADD_POLICY
   (OBJECT_SCHEMA   => 'GUSEV',
    OBJECT_NAME     => 'USERS',
    POLICY_NAME     => 'GUSEV_USERS',
    FUNCTION_SCHEMA => 'GUSEV',
    POLICY_FUNCTION => 'MY_SECURITY_FUNCTION',
    STATEMENT_TYPES => 'SELECT, INSERT, UPDATE, DELETE',
    UPDATE_CHECK    => TRUE,
    ENABLE  => TRUE);
END;
