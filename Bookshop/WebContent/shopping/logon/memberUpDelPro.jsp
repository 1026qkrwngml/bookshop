<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.CustomerDBBean" %>
<%@ page import="java.sql.Timestamp" %>   
<%
request.setCharacterEncoding("utf-8");

String	mode	= request.getParameter("mode");
String	id		= request.getParameter("id");
String	passwd	= request.getParameter("passwd");
String	name	= request.getParameter("name");
String	tel		= request.getParameter("tel");
String	address	= request.getParameter("address");
%>

<jsp:useBean id="customer" scope="page"
	class="bookshop.shopping.CustomerDataBean">
</jsp:useBean>

<%
customer.setId(id);
customer.setPasswd(passwd);
customer.setName(name);
customer.setTel(tel);
customer.setAddress(address);
customer.setReg_date(new Timestamp(System.currentTimeMillis()));

CustomerDBBean customerProcess = CustomerDBBean.getInstance();

if(mode.equals("UP")) {
	customerProcess.updateMember(customer);
} else if(mode.equals("DEL")) {
	customerProcess.deleteMember(id, passwd);
} else {
	response.sendRedirect("../shopMain.jsp");
}
response.sendRedirect("../shopMain.jsp");
%>


























