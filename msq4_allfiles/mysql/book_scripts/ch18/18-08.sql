REVOKE ALL, GRANT OPTION 
FROM jim;

REVOKE IF EXISTS ALL, GRANT OPTION 
FROM ap_user, anne@localhost
IGNORE UNKNOWN USER;

REVOKE INSERT, UPDATE
ON ap.vendors FROM joel@localhost