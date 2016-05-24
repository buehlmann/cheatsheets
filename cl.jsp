<% /* Place this file in the webapp directory of the war file whose Class Path you want to inspect */ %>

<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% String className = request.getParameter("className"); %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Class Loader Tester</title>
<style>
body {
	font-family: sans-serif;
	background-color: #eee;
}
.odd {
	background-color: #C00;
	color: white;
}
.even {
	background-color: #781F1C;
	color: white;
}
.label {
	font-family: monospace;
	text-align: center;
	font-size: 1.5em;
}
</style>
</head>
<body>
	<div
		style="width: 80%; margin-left: auto; margin-right: auto; text-align: center;">
		<h3></h3>
		<form action="cl.jsp">
			Fully qualified Class Name: <input type="text" name="className"><br><br>
			<input type="submit" value="Go for it!">
		</form>
	</div>
	<%
		if (className != null && !className.equals("")) {
			Class clazz = null;
			ClassLoader classLoader = null;
			String clazzName = "";
			String classLoaderName = "";
			String locationString = "";
			try {
				clazz = Class.forName(className);
				classLoader = clazz.getClassLoader();
				if (classLoader == null) {
					classLoaderName = "Null Class Loader. Probably its the Bootstrap Class Loader";
				} else {
					classLoaderName = classLoader.toString();
				}
	
				if (clazz.getProtectionDomain() != null && clazz.getProtectionDomain().getCodeSource() != null) {
					locationString = clazz.getProtectionDomain().getCodeSource().getLocation().toString();
				}
				clazzName = clazz.getName();
			} catch (ClassNotFoundException e) {
				clazzName = "Class not found in WAR Class Loader";
			} catch (SecurityException se) {
				classLoaderName = "Java secutity manager does not allow to access that Class Loader";
			}
	%>
	<br><br>
	<table>
		<tr class="odd">
			<td><b>Class Name:</b></td>
			<td class="label"><%=clazzName%></td>
		</tr>
		<tr class="even">
			<td><b>ClassLoader:</b></td>
			<td class="label"><%=classLoaderName%></td>
		</tr>
		<tr class="odd">
			<td><b>Location:</b></td>
			<td class="label"><%=locationString%></td>
		</tr>
	</table>
	<% } %>
</body>
</html>