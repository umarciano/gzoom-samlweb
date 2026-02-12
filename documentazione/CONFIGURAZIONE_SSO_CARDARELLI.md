# Configurazione SSO SAML - Ospedale Cardarelli

## Informazioni Provider IdP (Identity Provider)

### Endpoint e URL
- **Entity ID**: `https://identity.ospedalecardarelli.it/realms/aurora`
- **Metadata URL**: `https://identity.ospedalecardarelli.it/realms/aurora/protocol/saml/descriptor`
- **SSO URL** (Single Sign-On): `https://identity.ospedalecardarelli.it/realms/aurora/protocol/saml`
- **SLO URL** (Single Logout): `https://identity.ospedalecardarelli.it/realms/aurora/protocol/saml`
- **IDP Initiated SSO URL** (per test): `https://identity.ospedalecardarelli.it/realms/aurora/protocol/saml/clients/gzoomt`

### Configurazione SAML

#### NameID Format
- **Type**: `xs:string`
- **Format**: `urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified`
- **Contenuto**: Matricola dell'utente

#### Attributi SAML (SAML Attributes)

Tutti gli attributi usano il formato: `urn:oasis:names:tc:SAML:2.0:attrname-format:basic`

| Attributo | Tipo | Descrizione |
|-----------|------|-------------|
| `matricola` | `xs:string` | Numero di matricola dell'utente |
| `fiscalCode` | `xs:string` | Codice fiscale dell'utente |
| `email` | `xs:string` | Indirizzo email dell'utente |
| `displayName` | `xs:string` | Nome visualizzato dell'utente |

#### SAML Binding
- **Preferito**: HTTP-POST o HTTP-Redirect

#### Certificato X.509
- **Formato**: PEM
- **Disponibilità**: Scaricabile dai metadata all'URL sopra indicato

---

## Modifiche Implementate

### 1. File: `saml.properties.gzoom`

**Path**: `gzoom-samlweb/ext-conf/saml.properties.gzoom`

**Modifiche**:
- ✅ Aggiornato `onelogin.saml2.sp.nameidformat` a `urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified`
- ✅ Aggiornato `onelogin.saml2.idp.entityid` con Entity ID Cardarelli
- ✅ Aggiornato `onelogin.saml2.idp.single_sign_on_service.url` con SSO URL
- ✅ Aggiornato `onelogin.saml2.idp.single_logout_service.url` con SLO URL
- ✅ Aggiornato `onelogin.saml2.idp.single_logout_service.response.url` con SLO URL
- ⚠️ **TODO**: Scaricare il certificato X.509 dai metadata e aggiornare `onelogin.saml2.idp.x509cert`

**Come scaricare il certificato**:
```bash
# Opzione 1: Manualmente dal browser
# Aprire: https://identity.ospedalecardarelli.it/realms/aurora/protocol/saml/descriptor
# Cercare il tag <ds:X509Certificate> e copiare il contenuto

# Opzione 2: Da riga di comando (se accessibile)
curl -s "https://identity.ospedalecardarelli.it/realms/aurora/protocol/saml/descriptor" | grep -oP '(?<=<ds:X509Certificate>).*(?=</ds:X509Certificate>)'

# Il certificato va inserito in formato:
# onelogin.saml2.idp.x509cert = -----BEGIN CERTIFICATE-----<contenuto_base64>-----END CERTIFICATE-----
```

### 2. File: `SamlFilter.java`

**Path**: `gzoom-samlweb/src/main/java/com/maps/saml/util/SamlFilter.java`

**Modifiche**:
- ✅ Aggiornata la logica di estrazione della matricola per supportare:
  - Estrazione primaria dal `NameID` SAML
  - Fallback sull'attributo `matricola` se NameID è vuoto
  - Pulizia automatica del carattere `@` se presente
- ✅ Aggiunti log dettagliati per il debug
- ✅ Gestione errore se matricola non trovata
- ✅ Rimosso il riferimento ai claim Microsoft AD FS (non più necessario)

**Attributi SAML utilizzati**:
- `NameID` → matricola utente (prioritario)
- `matricola` → matricola utente (fallback)
- `fiscalCode` → codice fiscale (usato in soa.jsp)
- `email` → email utente (opzionale, disponibile per uso futuro)
- `displayName` → nome visualizzato (opzionale, disponibile per uso futuro)

### 3. File: `soa.jsp`

**Path**: `gzoom-samlweb/src/main/webapp/soa.jsp`

**Modifiche**:
- ✅ Aggiunta estrazione attributo `email` da SAML
- ✅ Aggiunta estrazione attributo `displayName` da SAML
- ✅ Migliorata gestione matricola con pulizia carattere `@`
- ✅ Aggiunti log dettagliati per debug (email, displayName)
- ✅ Commenti aggiornati con formato attributi Cardarelli

**Note**: Il form POST verso OFBiz legacy invia solo `saml_account` (matricola) e `saml_fiscalcode` (codice fiscale), ma email e displayName sono ora disponibili nella sessione se necessari per sviluppi futuri.

---

## Testing

### Prerequisiti
1. ⚠️ **CRITICO**: Scaricare e configurare il certificato X.509 in `saml.properties.gzoom`
2. Verificare che gli URL nel file `saml.properties.gzoom` siano corretti (entity IDs, endpoints)
3. Verificare la configurazione Service Provider (SP) nel provider Keycloak

### URL di Test
- **Frontend GZOOM2**: `http://localhost:4200` (o porta configurata in `gzoom2.base.url`)
- **Backend GZOOM Legacy**: `http://localhost:8080/gzoom`
- **SAML Web App**: `http://localhost:663/gzoom-saml-web` (o porta configurata)
- **IDP Initiated Login**: `https://identity.ospedalecardarelli.it/realms/aurora/protocol/saml/clients/gzoomt`

### Flusso di Test

#### Test 1: SP-Initiated Login (da GZOOM)
1. Navigare su: `http://localhost:4200` (o URL configurato)
2. Click su "Login con SSO"
3. Viene rediretto a: `https://identity.ospedalecardarelli.it/realms/aurora/protocol/saml`
4. Inserire credenziali sul provider Cardarelli
5. Dopo autenticazione, viene rediretto su `/gzoom-saml-web/acs.jsp`
6. Il sistema estrae matricola e fiscalCode dalla SAML Response
7. Viene rediretto su `/gzoom/control/samlLogin` (OFBiz) o API JWT (GZOOM2)

#### Test 2: IDP-Initiated Login
1. Navigare direttamente su: `https://identity.ospedalecardarelli.it/realms/aurora/protocol/saml/clients/gzoomt`
2. Autenticarsi con credenziali Cardarelli
3. Viene automaticamente rediretto su GZOOM con SAML Response

#### Test 3: Logout (SLO)
1. Dopo login, click su "Logout"
2. Viene chiamato l'endpoint `/gzoom-saml-web/sls.jsp`
3. Invia LogoutRequest a: `https://identity.ospedalecardarelli.it/realms/aurora/protocol/saml`
4. Provider Cardarelli invalida la sessione SSO
5. Ritorna LogoutResponse a GZOOM

### Attributi da Verificare nel Debug

Quando l'utente si autentica, verificare nei log che siano presenti:

```
soa.jsp - matricola: <MATRICOLA_UTENTE>
soa.jsp - fiscalCode: <CODICE_FISCALE>
soa.jsp - email: <EMAIL_UTENTE>
soa.jsp - displayName: <NOME_COGNOME>
soa.jsp - returnUrl: http://localhost:8080/gzoom/control/samlLogin
```

Nel SamlFilter.java:
```
Matricola estratta da NameID: <MATRICOLA_UTENTE>
GOT user matricola: <MATRICOLA_UTENTE>
```

---

## Troubleshooting

### Problema: "Matricola non trovata nella SAML Response"
**Causa**: Il NameID o l'attributo `matricola` non sono presenti nella SAML Response.
**Soluzione**: 
1. Verificare configurazione Keycloak lato provider
2. Controllare che il NameID Format sia corretto: `urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified`
3. Verificare che l'attributo `matricola` sia mappato correttamente

### Problema: "Certificate verification failed"
**Causa**: Il certificato X.509 nel file `saml.properties.gzoom` è mancante, errato o scaduto.
**Soluzione**: Scaricare il certificato aggiornato dai metadata e aggiornare la proprietà `onelogin.saml2.idp.x509cert`

### Problema: "Invalid SAML Response"
**Causa**: Gli endpoint (Entity ID, SSO URL, SLO URL) non corrispondono.
**Soluzione**: Verificare che tutti gli URL in `saml.properties.gzoom` corrispondano esattamente a quelli forniti dal provider.

### Problema: "fiscalCode è vuoto"
**Causa**: L'attributo `fiscalCode` non è presente nella SAML Response oppure ha un nome diverso.
**Soluzione**: 
1. Controllare i log per vedere quali attributi arrivano effettivamente
2. Verificare con il provider che l'attributo sia chiamato esattamente `fiscalCode` (case-sensitive)
3. Verificare mapping attributi in Keycloak

### Problema: Redirect loop infinito
**Causa**: Il SP non riesce a validare la SAML Response e continua a redirigere sull'IdP.
**Soluzione**:
1. Verificare il certificato X.509
2. Verificare che `onelogin.saml2.strict = true` sia configurato correttamente
3. Controllare i log in `SamlFilter.java` per errori di validazione

---

## Note Tecniche

### Differenze con configurazione precedente (Azure AD)
- **NameID Format**: Cambiato da `emailAddress` a `unspecified`
- **Entity ID**: Cambiato da Azure AD tenant-specific a Keycloak realm
- **Attributi**: Cambiati da claim Microsoft (`http://schemas.xmlsoap.org/...`) a attributi Keycloak semplici (`matricola`, `fiscalCode`, ecc.)
- **Provider**: Cambiato da Azure AD/ADFS a Keycloak (Ospedale Cardarelli)

### Security Settings Raccomandati
Nel file `saml.properties.gzoom`:
- `onelogin.saml2.strict = true` ✅ (già configurato)
- `onelogin.saml2.security.want_assertions_signed = false` (verificare con provider se supporta firma)
- `onelogin.saml2.security.signature_algorithm = http://www.w3.org/2001/04/xmldsig-more#rsa-sha256` ✅
- `onelogin.saml2.security.digest_algorithm = http://www.w3.org/2001/04/xmlenc#sha256` ✅

### Service Provider Metadata
Per condividere i metadata del SP (GZOOM) con il provider Cardarelli:
```
URL Metadata SP: http://localhost:663/gzoom-saml-web/metadata.jsp
```

Oppure generare manualmente i metadata basandosi su:
- Entity ID: `http://localhost:663/gzoom-saml-web/metadata.jsp` (o URL pubblico di produzione)
- ACS URL: `http://localhost:663/gzoom-saml-web/acs.jsp`
- SLS URL: `http://localhost:663/gzoom-saml-web/sls.jsp`

---

## Checklist Deployment

Prima di deployare in produzione:

- [ ] Scaricare e configurare certificato X.509 dai metadata
- [ ] Aggiornare tutti gli URL da `localhost` a URL pubblici di produzione
- [ ] Verificare configurazione SP su Keycloak lato Cardarelli
- [ ] Testare SP-Initiated Login
- [ ] Testare IDP-Initiated Login
- [ ] Testare Single Logout (SLO)
- [ ] Verificare presenza attributi: matricola, fiscalCode, email, displayName
- [ ] Testare con utenti reali del Cardarelli
- [ ] Configurare HTTPS/TLS sui domini pubblici
- [ ] Aggiornare firewall per permettere comunicazione SAML

---

## Riferimenti

- **OneLogin SAML Toolkit**: https://github.com/onelogin/java-saml
- **SAML 2.0 Specification**: http://docs.oasis-open.org/security/saml/Post2.0/sstc-saml-tech-overview-2.0.html
- **Keycloak SAML**: https://www.keycloak.org/docs/latest/server_admin/#_saml

---

**Data ultimo aggiornamento**: 11 Febbraio 2026  
**Provider**: Ospedale Cardarelli - Identity Provider (Keycloak)  
**Contatto tecnico**: (da specificare)
