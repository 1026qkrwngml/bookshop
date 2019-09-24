<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "java.sql.Timestamp" %>
<%@ page import = "bookshop.master.ShopBookDBBean" %>
<%@ page import = "bookshop.master.ShopBookDataBean" %>

<%
String managerId = "";
try {
	managerId = (String)session.getAttribute("managerId");
	if(managerId == null || managerId.equals("")) {
		response.sendRedirect("../logon/managerLoginForm.jsp");
	} else {
		int 	book_id 	= Integer.parseInt(request.getParameter("book_id"));
		String	book_kind	= request.getParameter("book_kind");
		
		//넘겨 받은 책id에 해당하는 상세정보를 가져온다.
		ShopBookDBBean bookProcess = ShopBookDBBean.getInstance();
		ShopBookDataBean book = bookProcess.getBook(book_id);
%>


<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>책 정보 수정</title>
	<script src="../../js/script.js" type="text/javascript"></script>
</head>
<body>

<p>
	<h2>책 정보 수정</h2>
</p><hr>

<form method="post" name="writeform" action="bookUpdatePro.jsp"
	enctype="multipart/form-data">
	<table>
		<tr>
			<td align="right" colspan="2">
				<a href="../managerMain.jsp"> 관리자 메인으로</a>&nbsp;&nbsp;
				<a href="bookList.jsp?book_kind=<%=book_kind %>">책목록</a>
			</td>
		</tr>
		<tr>
			<td width="100" bgcolor="#b3e6ff">분류 선택</td>
			<td width="400" align="left">
				<select name="book_kind">
					<option value="100"
					<%if(book.getBook_kind().equals("100")) {%>selected<%} %>
					>문학</option>
					<option value="200"
					<%if(book.getBook_kind().equals("200")) {%>selected<%} %>
					>외국어</option>
					<option value="300" 
					<%if(book.getBook_kind().equals("300")) {%>selected<%} %>
					>컴퓨터</option>
				</select>
			</td>
		</tr>
		<tr>
			<td width="100">제목</td>
			<td width="400" align="left">
				<input type="text" size="100" maxlength="100" name="book_title"
					value="<%=book.getBook_title() %>">
				<input type="hidden" name="book_id" value="<%=book_id%>">
			</td>
		</tr>
		<tr>
			<td>가격</td>
			<td>
				<input type="text" size="10" maxlength="8" name="book_price"
					value="<%=book.getBook_price() %>">원
			</td>
		</tr>
		<tr>
			<td>수량</td>
			<td>
				<input type="text" size="8" maxlength="6" name="book_count"
					value="<%=book.getBook_count() %>">권
			</td>
		</tr>
		<tr>
			<td>저자</td>
			<td>
				<input type="text" size="40" maxlength="40" name="author"
					value="<%=book.getAuthor() %>">
			</td>
		</tr>
		<tr>
			<td>출판사</td>
			<td>
				<input type="text" size="30" maxlength="30" name="publishing_com"
					value="<%=book.getPublishing_com() %>">
			</td>
		</tr>
		<tr>
			<td>출판일</td>
			<td>
				<select name="publishing_year">
				<%
				Timestamp nowTime = new Timestamp(System.currentTimeMillis());
				int lastYear = Integer.parseInt(nowTime.toString().substring(0,4));
				for(int i = lastYear; i >= 2010; i--) {
				%>
					<option value="<%=i %>"
					<%if(Integer.parseInt(book.getPublishing_date().substring(0,4))==i) {%>
					selected <%} %>><%=i %></option>
				<% } %>
				</select> 년
				<select name="publishing_month">
				<%
				for(int i = 1; i <= 12; i++) {
				%>
					<option value="<%= i %>"
					<%if(Integer.parseInt(book.getPublishing_date().substring(5,7))==i) {%>
					selected<% } %> ><%= i %></option>
				<% } %>
				</select> 월
				<select name="publishing_day">
				<%
				for(int i = 1; i <= 31; i++) {
				%>
					<option value="<%= i %>"
					<%if(Integer.parseInt(book.getPublishing_date().substring(8))==i) {%>
					selected<% } %> ><%= i %></option>
				<% } %>
				</select> 일
			</td> 
		</tr>
		<tr>
			<td>책표지</td>
			<td>
				<input type="file" name="book_image"><%=book.getBook_image() %>
			</td>
		</tr>
		<tr>
			<td>내용</td>
			<td>
				<textarea rows="10" cols="100" name="book_content">
				<%=book.getBook_content() %></textarea>
			</td>
		</tr>
		<tr>
			<td>할인율</td>
			<td>
				<input type="text" size="4" maxlength="2" name="discount_rate"
				value="<%=book.getDiscount_rate() %>"> %
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input type="button" value="수정" onclick="updateCheckForm(this.form)">
				<input type="reset"  value="다시작성">
			</td>
		</tr>
	
	</table>

</form>

</body>
</html>


<%
		
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>
































