<%@page import="com.onelogin.saml2.Auth"%>
<%@page import="java.util.Collection"%>
<%@page import="java.util.Enumeration"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.Base64"%>
<%@page import="org.apache.commons.lang3.StringUtils" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<script>
function loginOnSoa(user, hrefUrl) {
	var form = document.createElement("form");
	input = document.createElement("input");
	form.action = hrefUrl;
	form.method = "post"
	input.type = "hidden";
	input.name = "saml_account";
	input.value = user;
	form.appendChild(input);
	document.body.appendChild(form);
	form.submit();
};
</script>
<head>
	 <meta charset="utf-8">
	 <meta http-equiv="X-UA-Compatible" content="IE=edge">
     <meta name="viewport" content="width=device-width, initial-scale=1">
	 <title>GZOOM SAML App</title>
	 <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css">
     <%
		 	Base64.Encoder enc = Base64.getEncoder();
		 	String nameId = (String) session.getAttribute("upn");
		    nameId = enc.encodeToString(nameId.getBytes());
		    String returnUrl = (String) session.getAttribute("soaReturnUrl");
	 %>
</head>
<body onload="loginOnSoa('<%=nameId%>', '<%=returnUrl%>');"></body>
</html>

