package com.maps.saml.test;

import java.io.IOException;

import com.onelogin.saml2.Auth;
import com.onelogin.saml2.exception.SettingsException;

public class RequestTest {

	public static void main(String[] args) {
		// TODO Auto-generated method stub
		try {
			Auth a = new Auth();
			
			a.login();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SettingsException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (com.onelogin.saml2.exception.Error e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		

	}

}
