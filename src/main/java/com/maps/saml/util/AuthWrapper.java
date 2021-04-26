package com.maps.saml.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.onelogin.saml2.Auth;
import com.onelogin.saml2.exception.Error;
import com.onelogin.saml2.exception.SettingsException;
import com.onelogin.saml2.settings.Saml2Settings;
import com.onelogin.saml2.settings.SettingsBuilder;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AuthWrapper   {
	private static Map<String,Saml2Settings> sp = new HashMap<String, Saml2Settings>();
	private static Map<String,Properties> properties = new HashMap<String, Properties>();
	public static Properties p = null;
	private static final Logger LOGGER = LoggerFactory.getLogger(AuthWrapper.class);


	private static synchronized void createSettings(String which) throws IOException {
		if (sp.get(which)==null) {
			String oneloginConf = System.getProperty("sp.conf");
			if (oneloginConf == null)
				oneloginConf =System.getProperty("user.home") + File.separator + "sp" + File.separator + "saml.properties";
			if (oneloginConf != null)   {
				FileInputStream propsf = new FileInputStream(oneloginConf+ "."+ which);
				if (propsf!=null) {
					p = new Properties();
					p.load(propsf);
					properties.put(which, p);
					sp.put(which, new SettingsBuilder().fromProperties(p).build());
				}
			} 
			 
		}

	}
	
	public static Properties getProperties(String which) throws IOException{
		if (which == null)
			which="gzoom";
		if (properties.get(which)==null) {
			createSettings(which);
		}
		return properties.get(which);
	}
	
	public static void reload() throws IOException {
		String[] mapContent = new String[sp.size()];
		int i  = 0;
		for (String k:sp.keySet()) {
			mapContent[i++]=k;
		}
		sp.clear();
		for (String k:mapContent)
			createSettings(k);
	}

	public static Auth getAuth(HttpServletRequest req, HttpServletResponse rsp) throws IOException, SettingsException, Error {
		String which = req.getParameter("req");
		if (which == null)
			which = (String) req.getAttribute("req");
		if (which == null) {
			LOGGER.info("Evaluating the request source...Intranet or Internet?");
			String onIntranet = req.getHeader("IntranetReq");
			if (onIntranet == null || (onIntranet!=null && !onIntranet.equals("TRUE"))) {
				LOGGER.info("The request is from the Internet");
				which = "gzoom";
			} else {
				LOGGER.info("The request is local");
				which = "gzoomintranet";
			}
		}
		if (sp.get(which)==null) {
			createSettings(which);
		}
		if (sp.get(which)==null) {
			return new Auth(req,rsp);
		}
		return new Auth (sp.get(which) , req,rsp);
	}
}
