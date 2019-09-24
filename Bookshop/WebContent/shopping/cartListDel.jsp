<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.CartDBBean" %>
<%
String	list		= request.getParameter("list");
String	buyer		= (String)session.getAttribute("id");
String	book_kind	= request.getParameter("book_kind");

if(session.getAttribute("id") == null) {
	response.sendRedirect("shopMain.jsp");
} else {
	CartDBBean cartProcess = CartDBBean.getInstance();
	
	if(list.equals("all")) { //장바구니 모두 비우기
		cartProcess.deleteAll(buyer);
	} else { //하나의 장바구니만 비우기
		cartProcess.deleteList(Integer.parseInt(list));
	}
	response.sendRedirect("cartList.jsp?book_kind=" + book_kind);
}
%>















