<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.text.SimpleDateFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
</head>
<body>
	<header>
	<div id="header">
 		<label class="login">login</label>
 		<label class="date">
  		<% Date date = new Date();
  	   	   SimpleDateFormat sdf = new SimpleDateFormat("yyyy/MM/dd");
  	       String formatDate = sdf.format(date); %>
  		<%= formatDate %>
  		</label>
  	</div>
	</header>
</body>
</html>