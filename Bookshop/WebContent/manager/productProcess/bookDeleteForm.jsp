<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String managerId = "";
try {
	managerId = (String)session.getAttribute("managerId");
	if(managerId == null || managerId.equals("")) {
		response.sendRedirect("../logon/managerLoginForm.jsp");
	} else {
		int 	book_id 	= Integer.parseInt(request.getParameter("book_id"));
		String	book_kind	= request.getParameter("book_kind");
		
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>책 삭제</title>
</head>
<body>

<h1>책 삭제</h1><hr>
<form method="post" name="delForm" 
	action="bookDeletePro.jsp?book_id=<%=book_id%>&book_kind=<%=book_kind%>">
	<table>
		<tr>
			<td>
				<a href="../managerMain.jsp">관리자 메인으로</a>&nbsp;&nbsp;
				<a href="bookList.jsp?book_kind=<%=book_kind%>">책목록</a>
			</td>
		</tr>
		<tr>
			<td>
				<input type="submit" value="삭제">
			</td>
		</tr>
	</table>
</form>


</body>
</html>


<%
		
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>
















