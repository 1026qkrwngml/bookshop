<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.CartDataBean" %>
<%@ page import="bookshop.shopping.CartDBBean" %>
<%@ page import="bookshop.shopping.BuyDBBean" %>
<%@ page import="bookshop.master.ShopBookDBBean" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.Timestamp" %>

<%
request.setCharacterEncoding("utf-8");

if(session.getAttribute("id") == null) {
	response.sendRedirect("shopMain.jsp");
} else {
	System.out.println(request.getParameter("account"));
	System.out.println(request.getParameter("deliveryName"));
	System.out.println(request.getParameter("deliveryTel"));
	System.out.println(request.getParameter("deliveryAddress"));
	System.out.println((String)session.getAttribute("id"));
	
	String	account			= request.getParameter("account");
	String	deliveryName	= request.getParameter("deliveryName");
	String	deliveryTel		= request.getParameter("deliveryTel");
	String	deliveryAddress	= request.getParameter("deliveryAddress");
	String	buyer			= (String)session.getAttribute("id");
	
	CartDBBean	cartProcess	= CartDBBean.getInstance();
	List<CartDataBean>	cartLists = cartProcess.getCart(buyer);
	
	BuyDBBean	buyProcess	= BuyDBBean.getInstance();
	buyProcess.insertBuy(cartLists, buyer, account, 
			deliveryName, deliveryTel, deliveryAddress);
	
	response.sendRedirect("buyList.jsp");
}
%>
























