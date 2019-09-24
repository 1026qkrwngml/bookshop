<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bookshop.shopping.BuyDBBean" %>
<%@ page import = "bookshop.shopping.BuyBookKindDataBean" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.text.NumberFormat" %>
<%
request.setCharacterEncoding("utf-8");
String managerId = "";
managerId = (String)session.getAttribute("managerId");

if(managerId == null || managerId.equals("")) {
	response.sendRedirect("../logon/managerLoginForm.jsp");
}

//보고자 하는 년도를 입력하는 변수
String year = request.getParameter("year");

BuyBookKindDataBean buyBookKindList = null;
BuyDBBean buyProcess = BuyDBBean.getInstance();
buyBookKindList = buyProcess.buyBookKindYear(year);
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>도서 종류별 판매 비율</title>
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="../../css/morris.css" rel="stylesheet">
	<script src="../../js/jquery-3.3.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
	<script src="../../js/morris.min.js"></script>
	<script src="http://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.2/raphael-min.js"></script>
</head>
<body>

<div class="container">
	<h4 align="center"><b>도서 종류별 판매 비율</b></h4>

	<form class="form-horizontal" method="post" name="bookKindStatsForm"
	action="bookKindStatsForm.jsp">
		<div class="form-group">
			<div class="col-sm-offset-4 col-sm-1">
				<h4><span class="label label-info">검색년도</span></h4>
			</div>
			<div class="col-sm-2">
				<input type="text" class="form-control" id="year" name="year"
				placeholder="Enter Year">
			</div>
			<div class="col-sm-2">
				<input class="btn btn-danger btn-sm" type="submit" value="검색하기"
				action="javascript:window.location='monthStatsForm.jsp'">
				<input class="btn btn-info btn-sm" type="button" value="메인으로"
				onclick="javascript:window.location='../managerMain.jsp'">				
			</div>
		</div>
		<table class="table table-bordered border="1" width="700"
			cellspacing="0" align="center">
			<thead>
				<tr class="info">
					<td align="center"><h3>문학</h3></td>
					<td align="center"><h3>외국어</h3></td>
					<td align="center"><h3>컴퓨터</h3></td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td align="center"><h3><%=buyBookKindList.getBookQty100()%></h3></td>
					<td align="center"><h3><%=buyBookKindList.getBookQty200()%></h3></td>
					<td align="center"><h3><%=buyBookKindList.getBookQty300()%></h3></td>
				</tr>
				<tr class="danger">
					<td align="right" colspan="12">
						<h4>
							<p class="bg-danger">총 판매 수량 : <%=buyBookKindList.getTotal()%>
						</h4>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>

<div id="mychart" style="height: 250px;"></div>

<script>
var q1 = Math.floor(Number(<%=buyBookKindList.getBookQty100()%>) * 100
		/ Number(<%=buyBookKindList.getTotal()%>) );
var q2 = Math.floor(Number(<%=buyBookKindList.getBookQty200()%>) * 100
		/ Number(<%=buyBookKindList.getTotal()%>) );
var q3 = Math.floor(Number(<%=buyBookKindList.getBookQty300()%>) * 100
		/ Number(<%=buyBookKindList.getTotal()%>) );

new Morris.Donut({
	element:	'mychart',
	data:	[
		{value: q1, label: '문학'},
		{value: q2, label: '외국어'},
		{value: q3, label: '컴퓨터'}
	],
	backgroundColor:	'#ccc',
	labelColor:			'#060',
	color:	[
		'#0BA462',
		'#39B580',
		'#67C69D'
	],
	formatter:	function(x) { return x + "%"}
});
</script>

</body>
</html>




























