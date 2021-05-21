<%@page import="com.onelogin.saml2.Auth"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<script>
	function loginOnRCA(user, hrefUrl) {
		xhr = new XMLHttpRequest();
		xhr.open('POST', 'http://localhost:8081/rest/api/getToken');
		xhr.setRequestHeader('Content-Type', 'application/json');
		xhr.setRequestHeader("Access-Control-Allow-Origin", "*");
		xhr.setRequestHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS");
		xhr.setRequestHeader("Access-Control-Allow-Headers", "*");
		xhr.setRequestHeader("Access-Control-Max-Age", "1728000");;
		xhr.onload = function() {
			if (xhr.status === 200 ) {
				var userInfo = JSON.parse(xhr.responseText);
				alert('gzoom-saml-web ' + userInfo.token);
				localStorage.setItem('auth-token', userInfo.token);
			}
			else if (xhr.status !== 200) {
				alert('Utente non autorizzato');
			}
			window.location.href = hrefUrl;
		};
		var bodyStr = JSON.stringify({
			uid: user,
			requestor: 'liferay'
		});
		xhr.send(bodyStr);
	};
</script>
<head>
	 <meta charset="utf-8">
	 <meta http-equiv="X-UA-Compatible" content="IE=edge">
     <meta name="viewport" content="width=device-width, initial-scale=1">
	 <title>IPC SAML Sample App</title>
	 <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
     <%
			String nameId = (String) session.getAttribute("upn");
            String returnUrl = (String) session.getAttribute("rcaReturnUrl");
	 %>
</head>
<body onload="loginOnRCA('<%=nameId%>', '<%=returnUrl%>');"></body>
</html>

