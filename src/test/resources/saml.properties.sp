rca.base.url=http://iportal-test.pizzarotti.it/rca
#If 'strict' is True, then the Java Toolkit will reject unsigned
#  or unencrypted messages if it expects them signed or encrypted
#  Also will reject the messages if not strictly follow the SAML
onelogin.saml2.strict =  false

# Enable debug mode (to print errors)
onelogin.saml2.debug =  true


#  Service Provider Data that we are deploying
#

#  Identifier of the SP entity  (must be a URI)
onelogin.saml2.sp.entityid = http://iportal-test.pizzarotti.it/IPC-saml-web/metadata.jsp

# Specifies info about where and how the <AuthnResponse> message MUST be
#  returned to the requester, in this case our SP.
# URL Location where the <Response> from the IdP will be returned
onelogin.saml2.sp.assertion_consumer_service.url = http://iportal-test.pizzarotti.it/IPC-saml-web/acs.jsp

# SAML protocol binding to be used when returning the <Response>
# message.  Onelogin Toolkit supports for this endpoint the
# HTTP-POST binding only
onelogin.saml2.sp.assertion_consumer_service.binding = urn:oasis:names:tc:SAML:2.0:bindings:HTTP-POST

# Specifies info about where and how the <Logout Response> message MUST be
# returned to the requester, in this case our SP.
onelogin.saml2.sp.single_logout_service.url = http://iportal-test.pizzarotti.it/IPC-saml-web/sls.jsp

# SAML protocol binding to be used when returning the <LogoutResponse> or sending the <LogoutRequest>
# message.  Onelogin Toolkit supports for this endpoint the
# HTTP-Redirect binding only
onelogin.saml2.sp.single_logout_service.binding = urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect

# Specifies constraints on the name identifier to be used to
# represent the requested subject.
# Take a look on lib/Saml2/Constants.php to see the NameIdFormat supported
onelogin.saml2.sp.nameidformat = urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified

# Usually x509cert and privateKey of the SP are provided by files placed at
# the certs folder. But we can also provide them with the following parameters

onelogin.saml2.sp.x509cert =MIIEITCCAwmgAwIBAgIJAPPcistm8bjwMA0GCSqGSIb3DQEBBQUAMIGmMQswCQYDVQQGEwJJVDEOMAwGA1UECAwFUGFybWExDjAMBgNVBAcMBVBhcm1hMRMwEQYDVQQKDApQaXp6YXJvdHRpMQ0wCwYDVQQLDARTZWRlMSMwIQYDVQQDDBppcG9ydGFsLXRlc3QucGl6emFyb3R0aS5pdDEuMCwGCSqGSIb3DQEJARYfc3VwcG9ydG9JUENAbWFwc2VuZ2luZWVyaW5nLmNvbTAeFw0xNzEwMjMxMDAyMTlaFw0zNzEwMTgxMDAyMTlaMIGmMQswCQYDVQQGEwJJVDEOMAwGA1UECAwFUGFybWExDjAMBgNVBAcMBVBhcm1hMRMwEQYDVQQKDApQaXp6YXJvdHRpMQ0wCwYDVQQLDARTZWRlMSMwIQYDVQQDDBppcG9ydGFsLXRlc3QucGl6emFyb3R0aS5pdDEuMCwGCSqGSIb3DQEJARYfc3VwcG9ydG9JUENAbWFwc2VuZ2luZWVyaW5nLmNvbTCCASIwDQYJKoZIhvcNAQEBBQADggEPADCCAQoCggEBANGP6u2XGeXzJRkRSlbJmesOsX/Vh8FOzEIxDBYe3NVtMYtpcXipvz3N3lwwLE1HBDydwZGJacN+s8FFyQJ8NlBLQZNrrDssfQZFqggIjChYHkUMZvDbFgIUW4SLhe3hf/zvA6JDCZL0hB4vfhuPZyqFjHpU/Cmcn6mJsiesOIp8PyHGWGehZsglCxHLeCmBjbHcffSJUTNXdKa2jAqT/84PSsjXvTgqxzL7uCGibXY3hsJf3cBqIOdWRiIKWTos0OW6Iz8VFHL+nG1ZgE/4z/pWnRY2N1xtcx/98XGoJ5Gs7KlnVnfIVwBx1Dv4WKc7ZkzxQZuVCkFDReVUuZ5VCg0CAwEAAaNQME4wHQYDVR0OBBYEFKU4OQ3fFybGcVw0Ivd4EnP6Jr8oMB8GA1UdIwQYMBaAFKU4OQ3fFybGcVw0Ivd4EnP6Jr8oMAwGA1UdEwQFMAMBAf8wDQYJKoZIhvcNAQEFBQADggEBAJ/0s539LngBv4KbQH3yY6zorKTgvOX47SqZdBGviGfa7Czbgy8HDRT13Mr/n3j5AVRZsOaqO+ocKOYYeYsnUWOxoknnQifORCms76u9MErOourNh5z7IT2zlOzLfvxANQh/hD/ig0fkbrHkmQDaJsIFdD5R+BYvFmJVWJWMaC3xEjw5HIfwaNoDpLg4BzZYwDFcpbFLUWS/rZy1TlCxLHz2uGws926fiZlYMLLYCnS8nF3SyNuP7DRQIgJJ1otQBDrYAJ+YDVvOzDzxh7Go9VbsRGAkqtqmIuzdCDsTNAqxyV0ZmnfnAvtas4RKE0Dq+rDHV5gb9hmSQPv3IBiNGpk=



# Requires Format PKCS#8   BEGIN PRIVATE KEY         
# If you have     PKCS#1   BEGIN RSA PRIVATE KEY  convert it by   openssl pkcs8 -topk8 -inform pem -nocrypt -in sp.rsa_key -outform pem -out sp.pem
onelogin.saml2.sp.privatekey =MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDRj+rtlxnl8yUZEUpWyZnrDrF/1YfBTsxCMQwWHtzVbTGLaXF4qb89zd5cMCxNRwQ8ncGRiWnDfrPBRckCfDZQS0GTa6w7LH0GRaoICIwoWB5FDGbw2xYCFFuEi4Xt4X/87wOiQwmS9IQeL34bj2cqhYx6VPwpnJ+pibInrDiKfD8hxlhnoWbIJQsRy3gpgY2x3H30iVEzV3SmtowKk//OD0rI1704Kscy+7ghom12N4bCX93AaiDnVkYiClk6LNDluiM/FRRy/pxtWYBP+M/6Vp0WNjdcbXMf/fFxqCeRrOypZ1Z3yFcAcdQ7+FinO2ZM8UGblQpBQ0XlVLmeVQoNAgMBAAECggEAaKef4mF4jI798uPgpTDvDiV7XWTs9Av/E/tcltt425k5ie7xvRnAqQPbzVw9c6ZIpmD+X0kpqXjoGlhYh0Yy9axvpki6bZ7NHUnDHVnvbOJ802zbJ+OxvP4fqjTngKICAfX3cZxa9qnoJQ8AwpC+K80gF6PDfqB6V/etIgTvA7EbU/thANZOm+E2Has1Z700N60z71KO7VTIkcRDzgwiOR8xVhj0RWjjj1W0xSXqszSbYBohTpHRU84GcrYi2alkY34Jkzlq1gqmsgErVzNe315kzpqdyFGPTFNtjhKP6KsSQPNQxBAvHMhxBcloDnksD9fB/qmjok9frYI8wbgeAQKBgQDzKDU13vZjJlooWTU500EBRQGTqlCiIvxz1cZZbobieFm+SddHc6BllUYZOsqSv/xmoWfi6aE8d5kxczceAG3m+qG9P1V1LHMXRq0npBNSGLfYwGfCukev/eViifBBzKdQr+U5zBT/VVLn1Lqpz0NMTgNSc41qPe/9fMPRLK12gQKBgQDcoXbgkCKrMnlT4U4ALWrjaZkVAi+/17BRAkWPebjHGOwyOusiiHPAyEINetORtb5c9BVK88t7bn//kOrzVD6AsUPtIGWVuLdVBrLf+GFfeuDuJIyZy5m1OhZqfZ9WUtrdG09Fv3V2dpHNy3VcHwFJuXEfc+d5n7rsAqYGWNpFjQKBgQDuMGbfXIey3HDYsXpIKL62xagjxGS0Tt1JgxGHrZOH6SjQFHlDzupCWBWQxVyGoHZY+qdPSljdaLKyFBDb3MPLzZv+TDokS+R52ovoFvuuIfSF6QQ7ZkqvBWFcQ48MhbMogQVktpui+yv5WRN5IETmTE1IyVSvy/h5MWyITOGnAQKBgEADnSFE0LpJV8iNm3sTsmqvLdpZmw8XfrHSbepWD9W8lnNwgt6vJp6tu/R7Sb2CNOx1aWQo3kY+5mZ5XqIhNE1UoXfAqZjKUm8aFXZEc8QnO/H8qsrItx1M8EoPjtaWDaiPju2WwncPqfhC6xdCa7Y/VuIgV+4C+VIW5qL6zsHVAoGBAJqIclLyp4fzU71lm6Gn4EL4UaJl61wWPfB9B/Gq8ssbWW5o6u1kK/1mZ6Mci8h6UArOI5IZuPf8arsiYZR5LDmWiMkHuue493H4+BzLRUujiXYJjDx548Tfenp2gbFrnqqPN5x4NhnT+/Z3v7Yfdb/7PA470Z+JYxZvnhc/oyCf

# Identity Provider Data that we want connect with our SP
#

# Identifier of the IdP entity  (must be a URI)
onelogin.saml2.idp.entityid =http://sts.pizzarotti.it/adfs/services/trust

# SSO endpoint info of the IdP. (Authentication Request protocol)
# URL Target of the IdP where the SP will send the Authentication Request Message
onelogin.saml2.idp.single_sign_on_service.url =https://sts.pizzarotti.it/adfs/ls/

# SAML protocol binding to be used when returning the <Response>
# message.  Onelogin Toolkit supports for this endpoint the
# HTTP-Redirect binding only
onelogin.saml2.idp.single_sign_on_service.binding = urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect

# SLO endpoint info of the IdP.
# URL Location of the IdP where the SP will send the SLO Request
onelogin.saml2.idp.single_logout_service.url =https://sts.pizzarotti.it/adfs/ls/

# Optional SLO Response endpoint info of the IdP.
# URL Location of the IdP where the SP will send the SLO Response. If left blank, same URL as onelogin.saml2.idp.single_logout_service.url will be used.
# Some IdPs use a separate URL for sending a logout request and response, use this property to set the separate response url
onelogin.saml2.idp.single_logout_service.response.url =https://sts.pizzarotti.it/adfs/ls/

# SAML protocol binding to be used when returning the <Response>
# message.  Onelogin Toolkit supports for this endpoint the
# HTTP-Redirect binding only
onelogin.saml2.idp.single_logout_service.binding = urn:oasis:names:tc:SAML:2.0:bindings:HTTP-Redirect

# Public x509 certificate of the IdP
onelogin.saml2.idp.x509cert =MIIC3jCCAcagAwIBAgIQOYIvZ1ZPWYlJcHscvkr5cDANBgkqhkiG9w0BAQsFADArMSkwJwYDVQQDEyBBREZTIFNpZ25pbmcgLSBzdHMucGl6emFyb3R0aS5pdDAeFw0xNzEwMTExMDUxMDFaFw0xODEwMTExMDUxMDFaMCsxKTAnBgNVBAMTIEFERlMgU2lnbmluZyAtIHN0cy5waXp6YXJvdHRpLml0MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwVoinq3aqMTO2peISCpdHKuitZ8G2I2rJP33xsWYRo1ZxTOrfC4ZVAORd5Fizo9JvceWvoThAdON3nRDSr8I7gvWqfAoYEP2pcJvzhNM23ed7AeamcI+k8NmqEoYs5sVCu9ZKkUKutBFFVpVHiHbpTY1KKISdLO9H5lQhyLqEHR2nlO2VRgKWMvA/Eh81c2eRpvpFIL/+g9rOf2zlhIyLMMD9m7Qfvki1/PPCKgUBIcHqNt8xBNcSGKUtNRslAjRezJVS2iXlMiekZraAVgtjQIRUpO9XIeIxotdRu2+cEu5tm6REhAEm3SWt5wvWmZiybzZNCVIi+pu2/6aVABwYQIDAQABMA0GCSqGSIb3DQEBCwUAA4IBAQCYhoWKjoQKymdnbroWzTulHiP6e8MjMUKpT/2/Nz7HFvKp4BOumSbk91puPnJf4LYtbo3vIQFTzQrX3QkHO5A2Ow8Ab5a9PaOLvK6yTjcmtNC4gFDGBkB4tH5zEGUHLol0/7mNJss8CWM+lg0Q8uXciN3CXSnl+ugNgX9PyqPzWnMzS7n7xNKrvb/IhuwurWd7LtfbughYWWM2caU57L2S4Y9DjE2/pEghgqm/7/VOMQH4kLgVQav0qUhMVvxNcksCfbALgBgINE2VEl3rdFLoftwAbMjNPtg7tK/KoitricwkoG5crLOKBNpIa0KSQkQ+1XuEnehR5isSMM8jmrOG

# Instead of use the whole x509cert you can use a fingerprint
# (openssl x509 -noout -fingerprint -in "idp.crt" to generate it,
# or add for example the -sha256 , -sha384 or -sha512 parameter)
#
# If a fingerprint is provided, then the certFingerprintAlgorithm is required in order to
# let the toolkit know which Algorithm was used. Possible values: sha1, sha256, sha384 or sha512
# 'sha1' is the default value.
# onelogin.saml2.idp.certfingerprint = 
# onelogin.saml2.idp.certfingerprint_algorithm = sha1


# Security settings
#

# Indicates that the nameID of the <samlp:logoutRequest> sent by this SP
# will be encrypted.
onelogin.saml2.security.nameid_encrypted = false

# Indicates whether the <samlp:AuthnRequest> messages sent by this SP
# will be signed.              [The Metadata of the SP will offer this info]
onelogin.saml2.security.authnrequest_signed = true

# Indicates whether the <samlp:logoutRequest> messages sent by this SP
# will be signed.
onelogin.saml2.security.logoutrequest_signed = true

# Indicates whether the <samlp:logoutResponse> messages sent by this SP
# will be signed.
onelogin.saml2.security.logoutresponse_signed = true

# Sign the Metadata
# Empty means no signature, or comma separate the keyFileName and the certFileName
onelogin.saml2.security.want_messages_signed = 
# Indicates a requirement for the <samlp:Response>, <samlp:LogoutRequest> and
# <samlp:LogoutResponse> elements received by this SP to be signed.
onelogin.saml2.security.want_assertions_signed = false

# Indicates a requirement for the Metadata of this SP to be signed.
# Right now supported null (in order to not sign) or true (sign using SP private key) 
onelogin.saml2.security.sign_metadata = 

# Indicates a requirement for the Assertions received by this SP to be encrypted
onelogin.saml2.security.want_assertions_encrypted = false

# Indicates a requirement for the NameID received by this SP to be encrypted
onelogin.saml2.security.want_nameid_encrypted = false

# Authentication context.
# Set Empty and no AuthContext will be sent in the AuthNRequest,
# Set comma separated values urn:oasis:names:tc:SAML:2.0:ac:classes:urn:oasis:names:tc:SAML:2.0:ac:classes:Password
onelogin.saml2.security.requested_authncontext = urn:oasis:names:tc:SAML:2.0:ac:classes:urn:oasis:names:tc:SAML:2.0:ac:classes:Password

# Allows the authn comparison parameter to be set, defaults to 'exact'
onelogin.saml2.security.requested_authncontextcomparison = exact


# Indicates if the SP will validate all received xmls.
# (In order to validate the xml, 'strict' and 'wantXMLValidation' must be true).
onelogin.saml2.security.want_xml_validation = true

# Algorithm that the toolkit will use on signing process. Options:
#  'http://www.w3.org/2000/09/xmldsig#rsa-sha1'
#  'http://www.w3.org/2000/09/xmldsig#dsa-sha1'
#  'http://www.w3.org/2001/04/xmldsig-more#rsa-sha256'
#  'http://www.w3.org/2001/04/xmldsig-more#rsa-sha384'
#  'http://www.w3.org/2001/04/xmldsig-more#rsa-sha512'
onelogin.saml2.security.signature_algorithm = http://www.w3.org/2000/09/xmldsig#rsa-sha1

# Organization
onelogin.saml2.organization.name = SP IPC 
onelogin.saml2.organization.displayname = Pizzarotti SP
onelogin.saml2.organization.url = http://www.pizzarotti.it/
onelogin.saml2.organization.lang = 

# Contacts
onelogin.saml2.contacts.technical.given_name = Supporto IPC
onelogin.saml2.contacts.technical.email_address = supportoIPC@mapsengineering.com
onelogin.saml2.contacts.support.given_name = Supporto IPC
onelogin.saml2.contacts.support.email_address = supportoIPC@mapsengineering.com

