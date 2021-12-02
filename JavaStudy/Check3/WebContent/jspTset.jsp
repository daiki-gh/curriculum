<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width,initial-scale=1.0">
<title>Insert title here</title>
<link rel="stylesheet" href="<%=request.getContextPath() %>/css/style.css">
</head>
<body>
<%@ include file="header.jsp" %>
	<div id="form">
	<table>
		<tr><th>name</th><td><input type="text" id="name"></td></tr>
		<tr><th>id</th><td><input type="text" id="id"></td></tr>
	</table>
	</div>
<%@ include file="footer.jsp" %>
</body>
</html>