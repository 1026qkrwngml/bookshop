<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bookshop.shopping.BuyDataBean"  %>
<%@ page import = "bookshop.shopping.BuyDBBean"  %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.text.NumberFormat" %>

<%
request.setCharacterEncoding("utf-8");
String managerId = "";
managerId = (String)session.getAttribute("managerId");

//세션 값이 없으면 처음 페이지로 돌려 보낸다.
if(managerId == null || managerId.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp");
}
List<BuyDataBean>	buyLists	= null;
BuyDataBean			buyList		= null;

int count = 0;

//구매 테이블에서 화면에 보여줄 정보의 개수를 가져온다.
BuyDBBean buyProcess = BuyDBBean.getInstance();
count = buyProcess.getListCount();
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>배송 목록</title>
	<link href="../../css/main.css" rel="stylesheet" type="text/css">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<script src="../../js/jquery-3.3.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
	<script>
	/* 파라미터 값으로 특수문자, 공백문자를 포함해서 넘길 때
	처리가 안되고 에러가 나는 것을 방지하기 위해서 encodeURI(sanction)로
	값을 감싸서 처리하면 된다.
	*/
	function openUser(buyId, sanction) {
		window.open('deliveryUpModalForm.jsp?buyId='+buyId+'&sanction='+encodeURI(sanction), '',
				'left=300, top=100, width=400, height=280, scrollbars=no, status=no, resizable=no, fullscreen=no, channelmode=no');
		return false;
	}
	</script>
</head>
<body>

<%
//보여줄 데이터가 없으면 메시지 처리를 한다.
if(count == 0) {
%>
	<h2>판매내역이 없습니다.</h2><hr>
	<a href="../managerMain.jsp">관리자 메인</a>
<%
} else {
	buyLists = buyProcess.getBuyList();
%>

	<center><h3>배송 목록</h3><br></center>
	<center><a href="../managerMain.jsp">관리자 메인</a><hr></center>
	<form class="form-horizontal" method="post" name="deliveryList" 
		action="deliveryList.jsp">
		<table class="table table-bordered table-striped table-hover">
			<tr class="info">
				<td>주문번호</td>
				<td>배송상황</td>
				<td>주문자</td>
				<td>제목</td>
				<td>주문가격</td>
				<td>주문수량</td>
				<td>주문일자</td>
				<td>결재계좌</td>
				<td>받는분</td>
				<td>배송지전화</td>
				<td>배송지주소</td>
			</tr>
			<%
			for(int i = 0; i < buyLists.size(); i++) {
				buyList = (BuyDataBean)buyLists.get(i);
			%>
			<tr>
				<td>
					<a href="#" onclick="return openUser('<%=buyList.getBuy_id()%>',
					'<%=buyList.getSanction()%>');"><%=buyList.getBuy_id()%></a>
					<input type="hidden" id="status" name="status" value="<%=buyList.getSanction()%>">
				</td>
				<td><%=buyList.getSanction() %></td>
				<td><%=buyList.getBuyer() %></td>
				<td><%=buyList.getBook_title() %></td>
				<td align="right"><%=buyList.getBuy_price() %>원</td>
				<td align="right"><%=buyList.getBuy_count() %>권</td>
				<td><%=buyList.getBuy_date().toString() %></td>
				<td><%=buyList.getAccount() %></td>
				<td><%=buyList.getDeliveryName() %></td>
				<td><%=buyList.getDeliveryTel() %></td>
				<td><%=buyList.getDeliveryAddress() %></td>
			</tr>
			<%
			}
			%>
		</table>
	
	</form>
	





<%	
}
%>


</body>
</html>



























