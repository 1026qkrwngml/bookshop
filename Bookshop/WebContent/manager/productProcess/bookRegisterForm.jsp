<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.Timestamp" %>

<%
String managerId = "";
try {
	managerId = (String)session.getAttribute("managerId");
	if(managerId == null || managerId.equals("")) {
		response.sendRedirect("../logon/managerLoginForm.jsp");
	} else {

%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>책 등록</title>
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<script src="../../js/jquery-3.3.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
	<link href="../../css/style.css" rel="stylesheet" type="text/css">
	<script src="../../js/script.js"></script>
</head>
<body>

<div class="container">
	<form method="post" name="writeform" action="bookRegisterPro.jsp"
		enctype="multipart/form-data">
		<h2>책 등록</h2>
		<table class="table table-bordered table-striped nanum table-hover">
			<colgroup>
				<col class="col-sm-1">
				<col class="col-sm-3">
			</colgroup>
			<tr class="success">
				<td align="right" colspan="2">
					<a href="../managerMain.jsp">관리자 메인으로</a>
				</td>
			</tr>
			<tr>
				<td>분류 선택</td>
				<td align="left">
					<select name="book_kind">
						<option value="100">문학</option>
						<option value="200">외국어</option>
						<option value="300">컴퓨터</option>
					</select>
				</td>
			</tr>
			<tr>
				<td>제 목</td>
				<td align="left">
					<input type="text" size="100" maxlength="100" name="book_title">
				</td>
			</tr>
			<tr>
				<td>가격</td>
				<td align="left">
					<input type="text" size="8" maxlength="8" name="book_price">원
				</td>
			</tr>
			<tr>
				<td>수량</td>
				<td align="left">
					<input type="text" size="6" maxlength="6" name="book_count">권
				</td>
			</tr>
			<tr>
				<td>저자</td>
				<td align="left">
					<input type="text" size="40" maxlength="40" name="author">
				</td>
			</tr>
			<tr>
				<td>출판사</td>
				<td align="left">
					<input type="text" size="30" maxlength="30" name="publishing_com">
				</td>
			</tr>
			<tr>
				<td width="100">출판일</td>
				<td width="400" align="left">
					<select name="publishing_year">
					<%
					Timestamp nowTime = new Timestamp(System.currentTimeMillis());
					int lastYear = Integer.parseInt(nowTime.toString().substring(0, 4));
					for(int i = lastYear; i >= 2010; i--) {
					%>
						<option value="<%=i%>"><%=i%></option>
					<% } %>
					</select>년
					<select name="publishing_month">
					<%
					for(int i = 1; i <= 12; i++) {
					%>
						<option value="<%=i%>"><%=i%></option>
					<% } %>
					</select>월
					<select name="publishing_day">
					<%
					for(int i = 1; i <= 31; i++) {
					%>
						<option value="<%=i%>"><%=i%></option>
					<% } %>
					</select>일
				</td>
			</tr>
			<tr>
				<td>책 표지</td>
				<td align="left">
					<input type="file" name="book_image">
				</td>
			</tr>
			<tr>
				<td>내 용</td>
				<td align="left">
					<textarea rows="10" cols="100" name="book_content"></textarea>
				</td>
			</tr>
			<tr>
				<td>할인율</td>
				<td align="left">
					<input type="text" size="4" maxlength="2" name="discount_rate" value="0">%
				</td>
			</tr>
			<tr class="info">
				<td colspan="2" align="center">
					<input type="button" class="btn btn-primary" value="책등록"
						onclick="checkForm(this.form)">
					<input type="reset" class="btn btn-warning" value="다시작성">
				</td>
			</tr>
		</table>
	</form>


</div>

</body>
</html>

<%
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>














