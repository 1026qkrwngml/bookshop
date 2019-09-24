<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.CartDataBean" %>
<%@ page import="bookshop.shopping.CartDBBean" %>
<%@ page import="bookshop.shopping.CustomerDataBean" %>
<%@ page import="bookshop.shopping.CustomerDBBean" %>
<%@ page import="bookshop.shopping.BuyDBBean" %>
<%@ page import="java.util.List" %>
<%@ page import= "java.text.NumberFormat" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>

<%
if(session.getAttribute("id") == null) {
	response.sendRedirect("shopMain.jsp");
} else {
	String 	book_kind	= request.getParameter("book_kind");
	String	buyer		= (String)session.getAttribute("id");

	List<CartDataBean>	cartLists		= null;
	List<String>		accountLists	= null;
	CartDataBean		cartList		= null;
	CustomerDataBean	member			= null;

	int 	number	= 0;
	int 	total	= 0;
	
	String	realFolder		= "";
	String	saveFolder		= "/imageFile";
	ServletContext context	= getServletContext();
	realFolder				= context.getRealPath(saveFolder);
	realFolder = "http://localhost:8080/BookShop/imageFile";

	CartDBBean		cartProcess		= CartDBBean.getInstance();
	cartLists		= cartProcess.getCart(buyer);
	
	CustomerDBBean	memberProcess	= CustomerDBBean.getInstance();
	member			= memberProcess.getMember(buyer);
	
	BuyDBBean		buyProcess		= BuyDBBean.getInstance();
	accountLists	= buyProcess.getAccount();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Book Shopping Mall</title>
	<link href="../css/main.css" rel="stylesheet" type="text/css">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<script src="../js/jquery-3.3.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
</head>
<body>

<jsp:include page="../module/top.jsp" flush="false"/>
<br><br><br>

<h3><b>구매 목록</b></h3>
<table class="table table-bordered table-striped nanum table-hover">
	<tr class="info">
		<td width= "50">번호</td>
		<td width="300">제목</td>
		<td width="100">판매가격</td>
		<td width= "50">수량</td>
		<td width="150">구매금액</td>
	</tr>
	<%
	for(int i = 0; i < cartLists.size(); i++) {
		cartList = cartLists.get(i);
	%>
	<tr>
		<td><%=++number %></td>
		<td align="left">
			<img src="<%=realFolder%>\<%=cartList.getBook_image()%>"
			border="0" width="30" height="50" align="middle">
			<%=cartList.getBook_title() %>
		</td>
		<td align="right"><%=NumberFormat.getInstance().format(cartList.getBuy_price())%> 원&nbsp;&nbsp;</td>
		<td align="right"><%=cartList.getBuy_count()%> 권</td>
		<td align="right">
			<%total += cartList.getBuy_count()*cartList.getBuy_price();%>
			<%=NumberFormat.getInstance().format(cartList.getBuy_count()*cartList.getBuy_price())%> 원&nbsp;&nbsp;
		</td>
	</tr>
	<% } %>
	<tr class="danger">
		<td colspan="5" align="right">
			<b>총 구매금액 : <%=NumberFormat.getInstance().format(total)%> 원&nbsp;&nbsp;</b>
		</td>
	</tr>
</table>

<form class="form-horizontal" method="post" name="buyinput" action="buyPro.jsp">
	<div class="form-group">
		<div class="col-sm-2"></div>
		<div class="col-sm-3">
			<h3 align="center">주문자 정보</h3>
		</div>
	</div>
	<div class="form-group">
		<label class="control-label col-sm-2">이 름</label>
		<div class="col-sm-3">
			<input type="text" class="form-control" id="name" name="name"
			value="<%=member.getName() %>" disabled>
		</div>
	</div>
	<div class="form-group">
		<label class="control-label col-sm-2">전화번호</label>
		<div class="col-sm-3">
			<input type="text" class="form-control" id="tel" name="tel"
			value="<%=member.getTel() %>" disabled>
		</div>
	</div>
	<div class="form-group">
		<label class="control-label col-sm-2">주  소</label>
		<div class="col-sm-6">
			<input type="text" class="form-control" id="address" name="address"
			value="<%=member.getAddress() %>" disabled>
		</div>
	</div>
	<div class="form-group">
		<label class="control-label col-sm-2">결재계좌</label>
		<div class="col-sm-3">
			<select class="form-control" id="account" name="account">
			<%
			for(int i = 0; i < accountLists.size(); i++) {
				String accountList = accountLists.get(i);
			%>
				<option value="<%=accountList%>"><%=accountList%></option>
			<% } %>
			</select>
		</div>
	</div>
	<div class="form-group">
		<div class="col-sm-2"></div>
		<div class="col-sm-3">
			<h3 align="center">배송지 정보</h3>
		</div>
	</div>
	<div class="form-group">
		<label class="control-label col-sm-2">이 름</label>
		<div class="col-sm-3">
			<input type="text" class="form-control" id="deliveryName" name="deliveryName"
			value="<%=member.getName() %>">
		</div>
	</div>
	<div class="form-group">
		<label class="control-label col-sm-2">전화번호</label>
		<div class="col-sm-3">
			<input type="text" class="form-control" id="deliveryTel" name="deliveryTel"
			value="<%=member.getTel() %>">
		</div>
	</div>
	<div class="form-group">
		<label class="control-label col-sm-2">주  소</label>
		<div class="col-sm-6">
			<input type="text" class="form-control" id="deliveryAddress" name="deliveryAddress"
			value="<%=member.getAddress() %>">
		</div>
	</div>
	<div class="form-group">
		<div class="col-sm-offset-2 col-sm-4">
			<input class="btn btn-primary btn-sm" type="submit" value="구매확인">&nbsp;&nbsp;
			<input class="btn btn-danger btn-sm" type="button" value="구매취소"
			onclick="javascript:window.location='cartList.jsp?book_kind=all'">
		</div>
	</div>
</form>
<hr>

<br><br>

</body>
</html>

<%
}
%>



































