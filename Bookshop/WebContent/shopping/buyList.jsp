<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="bookshop.shopping.BuyDataBean" %>
<%@ page import="bookshop.shopping.BuyDBBean" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>

<%
if(session.getAttribute("id") == null) {
	response.sendRedirect("shopMain.jsp");
}
String buyer = (String)session.getAttribute("id");

List<BuyDataBean>	buyLists	= null;
BuyDataBean			buyList		= null;
int		count		= 0;
int 	number		= 0;
int		total		= 0;
int		sum			= 0;
long	compareId	= 0;
long 	preId		= 0;

String	realFolder	= "";
String	saveFolder	= "/imageFile";
ServletContext context = getServletContext();
realFolder = context.getRealPath(saveFolder);
realFolder = "http://localhost:8080/BookShop/imageFile";

BuyDBBean buyProcess = BuyDBBean.getInstance();
//보여줄 자료가 있는 지 건수를 먼저 조사한다.
count = buyProcess.getListCount(buyer);

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

<%
//구매한 내역이 없는 경우
if(count == 0) {
%>
<table class="table table-bordered table-striped nanum table-hover">
	<tr class="info">
		<td align="center"><h2>구매하신 내역이 없습니다.</h2></td>
	</tr>
</table>
<% } else { //구매한 내역이 있는 경우
	buyLists = buyProcess.getBuyList(buyer);	
%>
<div class="col-sm-offset-1">
	<table class="table">
		<tr>
			<td>
				<h3><span class="label label-success">구 매 목 록</span></h3>
			</td>
		</tr>
		<tr class="info">
			<td width="150">번호</td>
			<td width="300">제 목</td>
			<td width="100">배송상태</td>
			<td width= "50">판매가격</td>
			<td width= "50">수량</td>
			<td width= "50">금액</td>
		</tr>	
		<%
		for(int i = 0; i < buyLists.size(); i++)
		{
			buyList = buyLists.get(i);

			//다음 buy_id를 구하는데, 현재 buy_id가 마지막 데이터면
			//다음 데이터를 구할 수 없으므로 -1일때까지만 구한다.
			if(i < buyLists.size() - 1)
			{
				BuyDataBean compare = buyLists.get(i+1);
				compareId = compare.getBuy_id();
				
				//BuyDataBean pre = buyLists.get(buyLists.size()-2);
				//preId = pre.getBuy_id();
			}
		%>
			
		<tr>
			<td align="center"><%=buyList.getBuy_id()%></td>
			<td align="left">
				<img src="<%=realFolder%>\<%=buyList.getBook_image()%>"
				border="0" width="30" height="50" align="middle">
				<%=buyList.getBook_title()%>
			</td>
			<td align="center">
				<%=buyList.getSanction() %>
			</td>
			<td align="right">
				<%=NumberFormat.getInstance().format(buyList.getBuy_price())%>원
			</td>
			<td align="right"><%=buyList.getBuy_count()%></td>
			<td align="right">
				<%total += buyList.getBuy_count()*buyList.getBuy_price();%>
				<%=NumberFormat.getInstance().format(buyList.getBuy_count()
										*buyList.getBuy_price())%>원&nbsp;
			</td>
		</tr>
		<%
		/*
		if( (buyList.getBuy_id() != compareId) ||
			((i == buyLists.size()-1) && preId != buyList.getBuy_id()) ||
			(i == buyLists.size()-1) )
		{
		*/				

		//현재 buy_id값과 다음 buy_id값이 다르거나,
		//현재 buy_id값이 마지막 데이터면 소계를 출력한다.
		if((buyList.getBuy_id() != compareId) || 
		   (i == buyLists.size()-1)  ) 
		{
		%>
		<tr class="danger">
			<td colspan="6" align="right">
				<%sum += total;%>
				<b>금 액 : <%=NumberFormat.getInstance().format(total)%>원&nbsp;</b>
				<%total = 0; compareId = buyList.getBuy_id(); %>
			</td>
		</tr>
			
		<%
		} // End -if
		
		} // End - for
		%>
		<tr class="primary">
			<td colspan="6" align="right">
				<h3>총 금액 : <%=NumberFormat.getInstance().format(sum)%>원&nbsp;</h3>
			</td>
		</tr>
	</table>

</div>




<% } %>
</body>
</html>





















