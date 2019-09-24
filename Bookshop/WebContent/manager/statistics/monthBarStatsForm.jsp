<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bookshop.shopping.BuyDBBean" %>
<%@ page import = "bookshop.shopping.BuyMonthDataBean" %>
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

BuyMonthDataBean buyMonthList = null;
BuyDBBean buyProcess = BuyDBBean.getInstance();
buyMonthList = buyProcess.buyMonth(year);
%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>월별 판매 리스트(막대)</title>
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<link href="../../css/morris.css" rel="stylesheet">
	<script src="../../js/jquery-3.3.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
	<script src="../../js/morris.min.js"></script>
	<script src="http://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.2/raphael-min.js"></script>
</head>
<body>

<div class="container">
	<h4 align="center"><b>월별 판매 리스트</b></h4>

	<form class="form-horizontal" method="post" name="monthBarStatsForm"
	action="monthBarStatsForm.jsp">
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
					<td align="center">1월</td>
					<td align="center">2월</td>
					<td align="center">3월</td>
					<td align="center">4월</td>
					<td align="center">5월</td>
					<td align="center">6월</td>
					<td align="center">7월</td>
					<td align="center">8월</td>
					<td align="center">9월</td>
					<td align="center">10월</td>
					<td align="center">11월</td>
					<td align="center">12월</td>
				</tr>
			</thead>
			<tbody>
				<tr>
					<td align="right"><%=buyMonthList.getMonth01()%></td>
					<td align="right"><%=buyMonthList.getMonth02()%></td>
					<td align="right"><%=buyMonthList.getMonth03()%></td>
					<td align="right"><%=buyMonthList.getMonth04()%></td>
					<td align="right"><%=buyMonthList.getMonth05()%></td>
					<td align="right"><%=buyMonthList.getMonth06()%></td>
					<td align="right"><%=buyMonthList.getMonth07()%></td>
					<td align="right"><%=buyMonthList.getMonth08()%></td>
					<td align="right"><%=buyMonthList.getMonth09()%></td>
					<td align="right"><%=buyMonthList.getMonth10()%></td>
					<td align="right"><%=buyMonthList.getMonth11()%></td>
					<td align="right"><%=buyMonthList.getMonth12()%></td>
				</tr>
				<tr class="danger">
					<td align="right" colspan="12">
						<h4>
							<p class="bg-danger">총 판매 수량 : <%=buyMonthList.getTotal()%>
						</h4>
					</td>
				</tr>
			</tbody>
		</table>
	</form>
</div>

<div id="mychart" style="height: 250px;"></div>

<script>
new Morris.Bar({
	//그래프를 표시하기 위한 객체의 ID
	element:	'mychart',
	//그래프 데이터. 각 요소가 하나의 그래프 상의 값에 해당된다.
	data:	[
		{x:	'1월',	y:	<%=buyMonthList.getMonth01()%> },
		{x:	'2월',	y:	<%=buyMonthList.getMonth02()%> },
		{x:	'3월',	y:	<%=buyMonthList.getMonth03()%> },
		{x:	'4월',	y:	<%=buyMonthList.getMonth04()%> },
		{x:	'5월',	y:	<%=buyMonthList.getMonth05()%> },
		{x:	'6월',	y:	<%=buyMonthList.getMonth06()%> },
		{x:	'7월',	y:	<%=buyMonthList.getMonth07()%> },
		{x:	'8월',	y:	<%=buyMonthList.getMonth08()%> },
		{x:	'9월',	y:	<%=buyMonthList.getMonth09()%> },
		{x:	'10월',	y:	<%=buyMonthList.getMonth10()%> },
		{x:	'11월',	y:	<%=buyMonthList.getMonth11()%> },
		{x:	'12월',	y:	<%=buyMonthList.getMonth12()%> },
	],
	//그래프 데이터에서 x축에 해당하는 값의 이름
	xkey: 'x',
	//그래프 데이터에서 y축에 해당하는 값의 이름
	ykeys: ['y'],
	//레이블
	labels:	['Qty'],
	//막대 그래프의 색상
	barColors:	function(row, series, type) {
		if(type == 'bar') {
			var red = Math.ceil(255 * row.y / this.ymax);
			return 'rgb(' + red + ', 0, 0)';
		} else {
			return '#000';
		}
	}
});

</script>

</body>
</html>




























