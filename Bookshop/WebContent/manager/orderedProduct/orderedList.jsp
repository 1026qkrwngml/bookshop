<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bookshop.shopping.BuyDataBean" %>
<%@ page import = "bookshop.shopping.BuyDBBean" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.text.NumberFormat" %>
<%
if((String)session.getAttribute("managerId") == null) {
	response.sendRedirect("../managerMain.jsp");
}
String managerId = (String)session.getAttribute("managerId");

List<BuyDataBean> 	buyLists 	= null;
BuyDataBean			buyList		= null;
int count = 0;

BuyDBBean buyProcess = BuyDBBean.getInstance();
//판매이력 건수를 구한다.
count = buyProcess.getListCount();

%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Manager Main</title>
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<script src="../../js/jquery-3.3.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
</head>
<body>

<%if(count == 0) { %>
<h3>판매목록</h3>
<table class="table">
	<tr>
		<td>판매 자료가 없습니다.</td>
	</tr>
</table>
<a href="../managerMain.jsp"> 관리자 메인으로</a>
<% } else { 
	buyLists = buyProcess.getBuyList();
%>

<h3>판매목록</h3>
<a href="../managerMain.jsp">관리자 메인으로</a>
<table class="table table-bordered table-striped nanum table-hover">
	<tr class="info">
		<td>판매번호</td>
		<td>구매자</td>
		<td>책 제목</td>
		<td>판매가격</td>
		<td>판매수량</td>
		<td>판매일자</td>
		<td>결재계좌</td>
		<td>배송자명</td>
		<td>배송지전화</td>
		<td>배송지주소</td>
		<td>배송 상황</td>
	</tr>
	<%
	for(int i = 0; i < buyLists.size(); i++) {
		buyList = (BuyDataBean)buyLists.get(i);
	%>
	<tr>
		<td><%=buyList.getBuy_id() %></td>
		<td><%=buyList.getBuyer() %></td>
		<td><%=buyList.getBook_title() %></td>
		<td><%=buyList.getBuy_price() %></td>
		<td><%=buyList.getBuy_count() %></td>
		<td><%=buyList.getBuy_date().toString() %></td>
		<td><%=buyList.getAccount() %></td>
		<td><%=buyList.getDeliveryName() %></td>
		<td><%=buyList.getDeliveryTel() %></td>
		<td><%=buyList.getDeliveryAddress() %></td>
		<td><%=buyList.getSanction() %></td>
	</tr>
	<% } %>
</table>
<% } %>
</body>
</html>






















