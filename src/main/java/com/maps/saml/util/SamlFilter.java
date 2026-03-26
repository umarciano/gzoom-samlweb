package com.maps.saml.util;

import java.io.IOException;
import java.net.URISyntaxException;
import java.net.URLDecoder;
import java.util.List;
import java.util.Map;
import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import com.onelogin.saml2.Auth;
import com.onelogin.saml2.exception.Error;
import com.onelogin.saml2.exception.SettingsException;

public class SamlFilter implements Filter{
	private static final Logger LOGGER = LoggerFactory.getLogger(SamlFilter.class);

	@Override
	public void destroy() {
		LOGGER.info("DESTROY SAML Filter");

	}

	@Override
	public void doFilter(ServletRequest arg0, ServletResponse arg1, FilterChain chain) throws IOException, ServletException {
		HttpServletRequest  req = (HttpServletRequest)arg0;
		HttpServletResponse resp = (HttpServletResponse)arg1;
		try  {

			LOGGER.info("HTTP REQUEST - INCOMING REQUEST: "+   getRequestUrl(req));
			LOGGER.info("HTTP REQUEST - METHOD: "+   req.getMethod());
		 	if (req.getServletPath()!=null) {
				if (req.getServletPath().indexOf("gzoom2DoLogin")>0) {
					manageSamlRequest(req, resp,"gzoom2.base.url", "gzoom2");
				}
		 		else if(req.getServletPath().indexOf("gzoomDoLogin")>0) {
					manageSamlRequest(req, resp,"gzoom.base.url", "soa");
				}
				else if (req.getServletPath().indexOf("acs.jsp")>0) {
					Auth auth = com.maps.saml.util.AuthWrapper.getAuth(req,resp);
					//Auth authWrapper = com.maps.saml.util.AuthWrapper.getAuth(req,resp);
					//this.auth = new Auth("saml.properties.gzoom",req, resp);
					auth.processResponse();
					HttpSession session = req.getSession();
					Map<String, List<String>> attributes = auth.getAttributes();
					if(session.getAttribute("sessionIndex") == null){
						String nameId = auth.getNameId();
						String nameIdFormat = auth.getNameIdFormat();
						String sessionIndex = auth.getSessionIndex();
						//String nameidNameQualifier = auth.getNameIdNameQualifier();
						//String nameidSPNameQualifier = auth.getNameIdSPNameQualifier();
						session.setAttribute("attributes", attributes);
						session.setAttribute("nameId", nameId);
						session.setAttribute("nameIdFormat", nameIdFormat);
						session.setAttribute("sessionIndex", sessionIndex);
					}
					if (!auth.isAuthenticated()) {
						LOGGER.error("Not Authenticated!");
						List<String> errors = auth.getErrors();
						if (!errors.isEmpty()) {
							String errorReason = auth.getLastErrorReason();
							if (errorReason != null && !errorReason.isEmpty()) {
								LOGGER.error("Error reason is: "+ errorReason);
							}
						}
						req.getRequestDispatcher("error.jsp").forward(req, resp);
					}

					// Estrae la matricola (preferibilmente dal NameID, altrimenti dall'attributo matricola)
					// Formato attributi forniti dal provider Cardarelli:
					// - NameID: xs:string, urn:oasis:names:tc:SAML:1.1:nameid-format:unspecified
					// - matricola: xs:string, urn:oasis:names:tc:SAML:2.0:attrname-format:basic
					// - fiscalCode: xs:string, urn:oasis:names:tc:SAML:2.0:attrname-format:basic
					// - email: xs:string, urn:oasis:names:tc:SAML:2.0:attrname-format:basic
					// - displayName: xs:string, urn:oasis:names:tc:SAML:2.0:attrname-format:basic
					
					attributes = auth.getAttributes();
					String matricola = null;
					String nameId = auth.getNameId();
					
					// Prova prima a prendere la matricola dal NameID
					if (nameId != null && !nameId.trim().isEmpty()) {
						matricola = nameId.trim();
						LOGGER.info("Matricola estratta da NameID: " + matricola);
					}
					
					// Se NameID è vuoto, prova dall'attributo "matricola"
					if (matricola == null || matricola.isEmpty()) {
						List<String> matricolaAttr = attributes.get("matricola");
						if (matricolaAttr != null && !matricolaAttr.isEmpty()) {
							matricola = matricolaAttr.get(0);
							LOGGER.info("Matricola estratta dall'attributo 'matricola': " + matricola);
						}
					}
					
					// Se la matricola contiene "@", estraiamo solo la parte prima della @
					if (matricola != null && matricola.indexOf("@") > 0) {
						matricola = matricola.substring(0, matricola.indexOf("@"));
						LOGGER.info("Matricola pulita (rimossa @): " + matricola);
					}
					
					if (matricola == null || matricola.isEmpty()) {
						throw new RuntimeException("Matricola non trovata nella SAML Response (né in NameID né nell'attributo 'matricola')");
					}
					
					LOGGER.info("GOT user matricola: " + matricola);
					req.getSession().setAttribute("upn", matricola); 
					LOGGER.info("GOT return url for RCA " + req.getSession().getAttribute("rcaReturnUrl"));
					LOGGER.info("GOT return url for SOA " + req.getSession().getAttribute("soaReturnUrl"));
					resp.sendRedirect(req.getParameter("RelayState"));
				}  else {
					chain.doFilter(arg0,arg1);	
				}

			} else {
				chain.doFilter(arg0, arg1);
			}

		} catch (Exception e) {
			LOGGER.error("Unexpected error",e);
			req.getRequestDispatcher("error.jsp").forward(req, resp);
		}

	}

	private void manageSamlRequest(HttpServletRequest req, HttpServletResponse resp, String propertyName, String from)
			throws IOException, SettingsException, Error, URISyntaxException {
		String returnUrl = req.getParameter("returnUrl");
		LOGGER.info("HTTP REQUEST - return url: "+ returnUrl);
		String baseUrl = AuthWrapper.getProperties("gzoom").getProperty(propertyName);
		if (returnUrl != null) {
			returnUrl = URLDecoder.decode(returnUrl, "UTF-8");
			LOGGER.info("HTTP REQUEST - return url decoded: "+ returnUrl);
			if (!returnUrl.startsWith("/"))
				baseUrl = baseUrl + "/";
			baseUrl = baseUrl + returnUrl;
		}
		req.getSession().setAttribute(from +"ReturnUrl", baseUrl);
		req.getSession().setAttribute("from", from);

		// Configurazione per soa (OFBiz legacy) - redirect a /gzoom/control/samlLogin
		// L'URL OFBiz viene codificato nel RelayState come query parameter
		// cosi' sopravvive alla perdita di sessione durante il redirect a Keycloak
		String relayState;
		if ("soa".equals(from)) {
			String ofbizLoginUrl = AuthWrapper.getProperties("gzoom").getProperty("gzoom.base.url");
			if (!ofbizLoginUrl.endsWith("/")) {
				ofbizLoginUrl += "/";
			}
			ofbizLoginUrl += "gzoom/control/samlLogin";
			req.getSession().setAttribute("soaReturnUrl", ofbizLoginUrl);
			// Codifica l'URL OFBiz nel RelayState: /gzoom-saml-web/soa.jsp?ofbizUrl=<encoded>
			String encodedOfbizUrl = java.net.URLEncoder.encode(ofbizLoginUrl, "UTF-8");
			relayState = "/gzoom-saml-web/soa.jsp?ofbizUrl=" + encodedOfbizUrl;
			LOGGER.info("RelayState costruito con ofbizUrl: " + relayState);
		} else if ("gzoom2".equals(from)) {
			String gzoom2BaseUrl = AuthWrapper.getProperties("gzoom").getProperty("gzoom2.base.url");
			String gzoom2ApiGetTokenUrl = AuthWrapper.getProperties("gzoom").getProperty("gzoom2.api.getToken.url");
			String gzoom2ApiKey = AuthWrapper.getProperties("gzoom").getProperty("gzoom2.api.key");
			req.getSession().setAttribute("gzoom2ReturnUrl", gzoom2BaseUrl);
			req.getSession().setAttribute("gzoom2ApiGetTokenUrl", gzoom2ApiGetTokenUrl);
			req.getSession().setAttribute("gzoom2ApiKey", gzoom2ApiKey);
			// Codifica i parametri gzoom2 nel RelayState per sopravvivere alla perdita di sessione
			// durante il redirect a Keycloak (stesso pattern usato per soa)
			String encodedReturnUrl = java.net.URLEncoder.encode(gzoom2BaseUrl != null ? gzoom2BaseUrl : "", "UTF-8");
			String encodedApiGetTokenUrl = java.net.URLEncoder.encode(gzoom2ApiGetTokenUrl != null ? gzoom2ApiGetTokenUrl : "", "UTF-8");
			String encodedApiKey = java.net.URLEncoder.encode(gzoom2ApiKey != null ? gzoom2ApiKey : "", "UTF-8");
			relayState = "/gzoom-saml-web/" + from + ".jsp"
				+ "?returnUrl=" + encodedReturnUrl
				+ "&apiGetTokenUrl=" + encodedApiGetTokenUrl
				+ "&apiKey=" + encodedApiKey;
			LOGGER.info("RelayState gzoom2 costruito: " + relayState);
		} else {
			relayState = "/gzoom-saml-web/" + from + ".jsp";
		}
		
		Auth auth = com.maps.saml.util.AuthWrapper.getAuth(req, resp);
		auth.login(relayState);
	}

	@Override
	public void init(FilterConfig arg0) throws ServletException {
		LOGGER.info("INIT SAML Filter");
	}


	private String getRequestUrl(final HttpServletRequest req){
		final String scheme = req.getScheme();
		final int port = req.getServerPort();
		final StringBuilder url = new StringBuilder(256);
		url.append(scheme);
		url.append("://");
		url.append(req.getServerName());
		if(!(("http".equals(scheme) && (port == 0 || port == 80))
				|| ("https".equals(scheme) && port == 443))){
			url.append(':');
			url.append(port);
		}
		url.append(req.getRequestURI());
		final String qs = req.getQueryString();
		if(qs != null){
			url.append('?');
			url.append(qs);
		}
		final String result = url.toString();
		return result;
	}
}
