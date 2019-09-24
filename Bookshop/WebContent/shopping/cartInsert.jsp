<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bookshop.master.ShopBookDBBean" %>
<%@ page import="bookshop.shopping.CartDBBean" %>

<%
request.setCharacterEncoding("utf-8");

String	book_kind	= request.getParameter("book_kind");
String	book_id		= request.getParameter("book_id");
String	book_title	= request.getParameter("book_title");
String	book_image	= request.getParameter("book_image");
String	buy_price	= request.getParameter("buy_price");
String	buyer		= (String)session.getAttribute("id");

System.out.println("book_kind : " + book_kind);
System.out.println("book_id :" + book_id);
System.out.println("book_title :" + book_title);
System.out.println("book_image :" + book_image);
System.out.println("buy_price :" + buy_price);
System.out.println("buyer :" + buyer);


//새로 바구니에 담으려는 수량
String	buy_count	= request.getParameter("buy_count");
%>

<jsp:useBean id="cart" scope="page"
	class="bookshop.shopping.CartDataBean">
</jsp:useBean>

<%
//재고 수량보다 주문 수량이 더 많으면 않된다.

//현재 책방에 있는 재고 수량을 구한다.
int rtnBookCount = 0;
ShopBookDBBean bookCountProcess = ShopBookDBBean.getInstance();
rtnBookCount = bookCountProcess.getBookIdCount(Integer.parseInt(book_id));

//장바구니에 담겨있는 책의 재고 수량을 구한다.
byte cartBookCount = 0;
CartDBBean cartProcess = CartDBBean.getInstance();
cartBookCount = cartProcess.getBookIdCount(buyer, Integer.parseInt(book_id));

if(rtnBookCount < 1) {
	%><script>alert('현재 재고가 없습니다.'); history.go(-1);</script><%
} else if(Integer.parseInt(buy_count) < 1) {
	%><script>alert('주문은 최소 1권 이상하셔야 합니다.'); history.go(-1);</script><%
} else if(Integer.parseInt(buy_count) > rtnBookCount) {
	%><script>alert('주문하신 수량이 재고수량보다 많습니다.'); history.go(-1);</script><%
} else if(cartBookCount > rtnBookCount) {
	%><script>alert('장바구니에 담겨져있는 수량이 재고수량보다 많습니다.'); history.go(-1);</script><%
} else if((Integer.parseInt(buy_count) + cartBookCount) > rtnBookCount) {
	%><script>alert('장바구니에 담겨져있는 수량 + 구매수량이 재고수량보다 많습니다.\n\n수량을 확인하신 후에 장바구니에 담아 주십시오.'); history.go(-1);</script><%
} else {
	cart.setBook_id(Integer.parseInt(book_id));
	cart.setBook_image(book_image);
	cart.setBook_title(book_title);
	cart.setBuy_count(Byte.parseByte(buy_count));
	cart.setBuy_price(Integer.parseInt(buy_price));
	cart.setBuyer(buyer);
	
	//CartDBBean bookProcess = CartDBBean.getInstance();
	cartProcess.insertCart(cart);
	response.sendRedirect("cartList.jsp?book_kind="+book_kind);
}

%>






















