<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bookshop.shopping.CustomerDBBean" %>
<%
request.setCharacterEncoding("utf-8");

String	id		= request.getParameter("id");
String	passwd	= request.getParameter("passwd");

CustomerDBBean member = CustomerDBBean.getInstance();
int check = member.userCheck(id, passwd);

//인증된 결과에 대해서 처리를 한다.
if(check == 1) {
	session.setAttribute("id", id);
	response.sendRedirect("shopMain.jsp");
} else if(check == 0) { //비밀번호가 틀린 경우 %>
	<script>
		alert("비밀번호가 맞지 않습니다."); history.go(-1);
	</script>
<% } else { //아이디가 존재하지 않는 경우 %>
	<script>
		alert("아이디가 맞지 않습니다."); history.go(-1);
	</script>
<% } %>

















