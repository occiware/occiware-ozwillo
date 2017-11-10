<!doctype html>
<html>
<head>
<title>Roboconf webapp</title>
<%!
String message = "Hello from Roboconf webapp !";
%>
</head>
<body>
<h2><%= message%></h2>
<%= new java.util.Date() %> at <%= java.net.InetAddress.getLocalHost() %>
</body>
</html>

