#############################################
###############Tomcat conf per SP##########
#############################################
Due opzioni

#####Opzione 1
configuration file saml.properties.ipc nel folder ${folder}
System property sp.conf=${folder}/saml.properties

#####Opzione 2
posizionare il file saml.properties.ipc in ${user.home}/sp/
 		

#####Generazione chiavi in parsobtest /home/rca/sp

openssl req -x509 -nodes -days 7300 -newkey rsa:2048 -keyout sp_sso.key -out sp_sso.crt

Quindi rimuovere la password dalla chiave mediante:
openssl rsa -in sp_sso.key -out sp_sso_nopwd.key
openssl pkcs8 -topk8 -inform pem -nocrypt -in sp_sso_nopwd.key -outform pem -out sp_sso_nopwd.pem
 
Sp.x509cert -> contenuto del file  crt  privo di header e footer e messo su una riga
Sp.privateKey -> sp_sso_nopwd.pem

#############################################
#########################APACHE
#############################################
rewrite rule for https
RewriteRule ^/IPC-saml-web/acs.jsp http://%{HTTP_HOST}%{REQUEST_URI}?%{QUERY_STRING} [P,L]


ProxyPass /IPC-saml-web http://parsobtest.intranetpizzarotti.it:8080/IPC-saml-web
ProxyPassReverse /IPC-saml-web http://parsobtest.intranetpizzarotti.it:8080/IPC-saml-web
ProxyPassReverseCookieDomain parsobtest.intranetpizzarotti.it iportal-test.pizzarotti.it
ProxyPassReverseCookiePath /IPC-saml-web /IPC-saml-web
  

#############################################
#########################RCA
#############################################
MOdificata auth guard per recuperare url saml e condizione di abilitazione.
Aggiunto servizio per SAML info lato api
property che contiene l'url di redirect: 
rca.saml.sp.url=https://iportal.pizzarotti.it/IPC-saml-web/rcaDoLogin



#############################################
#########################SOA
#############################################

BaseConfig.enableOfbizSpnegoHttpFilter=false
BaseConfig.enableOfbizSamlHttpFilter=true
BaseConfig.ofbizSamlServiceProvider=https://iportal.pizzarotti.it/IPC-saml-web/soaDoLogin
security.security.login.http.servlet.remoteuserlogin.allow=true


 
 