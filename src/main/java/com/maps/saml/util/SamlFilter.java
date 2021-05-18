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
					manageSamlRequest(req, resp,"gzoom2.base.url", "rca");
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

					//Map<String, List<String>> attributes = auth.getAttributes();
					attributes = auth.getAttributes();
					//List<String> el  = attributes.get("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/upn");
					List<String> el  = attributes.get("http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name");
					if (el == null || el.isEmpty())
						throw new RuntimeException("UPN claim is empty");
					String name = el.get(0);
					if (name.indexOf("@")>0) 
						name = name.substring(0, name.indexOf("@"));
					LOGGER.info("GOT user principal " + name);
					 	req.getSession().setAttribute("upn", name); 
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
		returnUrl = URLDecoder.decode( returnUrl, "UTF-8" );
		LOGGER.info("HTTP REQUEST - return url decoded: "+ returnUrl);
		String baseUrl = AuthWrapper.getProperties("gzoom").getProperty(propertyName);
		if (returnUrl!=null) {
			if (!returnUrl.startsWith("/"))
				baseUrl=baseUrl+"/";
			baseUrl=baseUrl+returnUrl;
		    
		}
		req.getSession().setAttribute(from +"ReturnUrl", baseUrl);
		req.getSession().setAttribute("from", from);
		Auth auth = com.maps.saml.util.AuthWrapper.getAuth(req, resp);
		//Auth auth = new Auth("saml.properties.gzoom",req, resp);
		auth.login("/gzoom-saml-web/"+from+".jsp");
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
