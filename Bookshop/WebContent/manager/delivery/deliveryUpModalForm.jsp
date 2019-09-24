<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bookshop.shopping.BuyDataBean"  %>
<%@ page import = "bookshop.shopping.BuyDBBean"  %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.text.NumberFormat" %>
<%
request.setCharacterEncoding("utf-8");
String	sanction	= request.getParameter("sanction");
String	buyId		= request.getParameter("buyId");
String	managerId	= "";
managerId = (String)session.getAttribute("managerId");

if(session.getAttribute("managerId") == null) {
	response.sendRedirect("../managerMain.jsp");
}
BuyDBBean buyProcess = BuyDBBean.getInstance();
int rtnVal = 0;
rtnVal = buyProcess.getDeliveryStatus(buyId);
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>배송 상태 수정</title>
	<link href="../../css/main.css" rel="stylesheet" type="text/css">
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<script src="../../js/jquery-3.3.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
</head>
<body>

<div class="container">
	<form class="form-horizontal" method="post" name="deliveryUpModalPro"
	action="deliveryUpModalPro.jsp">
		<div class="form-group">
			<div class="col-sm-2"></div>
			<div class="col-sm-6">
				<h2 align="center">배송 상태 수정</h2>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-6">
				<label class="radio-inline">
					<input type="radio" id="sanction" name="sanction" value="1" <%if(rtnVal == 1) {%>checked<%} %>>
					배송 준비 중
				</label>
				<label class="radio-inline">
					<input type="radio" id="sanction" name="sanction" value="2" <%if(rtnVal == 2) {%>checked<%} %>>
					배송 중
				</label>
				<label class="radio-inline">
					<input type="radio" id="sanction" name="sanction" value="3" <%if(rtnVal == 3) {%>checked<%} %>>
					배송 완료
				</label>
			</div>
		</div>
		<div class="form-group">
			<div class="col-sm-offset-2 col-sm-5">
				<input type="hidden" id="buyId" name="buyId" value="<%=buyId%>">
				<button type="submit" class="btn btn-primary">수정</button>
				<button type="reset" class="btn btn-danger">취소</button>
			</div>
		</div>
	</form>

</div>

</body>
</html>
































