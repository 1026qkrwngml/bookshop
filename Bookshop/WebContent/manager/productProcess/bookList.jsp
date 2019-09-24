<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bookshop.master.ShopBookDBBean" %>
<%@ page import = "bookshop.master.ShopBookDataBean" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.text.SimpleDateFormat" %>

<%
String managerId = "";
try {
	managerId = (String)session.getAttribute("managerId");
	if(managerId == null || managerId.equals("")) {
		response.sendRedirect("../logon/managerLoginForm.jsp");
	} else {
%>
<%! SimpleDateFormat sdf = new SimpleDateFormat("yyyy년MM월dd일 HH시mm분"); %>
<%
List<ShopBookDataBean> bookList = null;
int 	number = 0;
String	book_kind = "";

book_kind = request.getParameter("book_kind");

ShopBookDBBean bookProcess = ShopBookDBBean.getInstance();
int count = bookProcess.getBookCount();

if(count > 0) {
	bookList = bookProcess.getBooks(book_kind);
}
%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>책 목록</title>
	<link href="../../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<script src="../../js/jquery-3.3.1.min.js"></script>
	<script src="../../bootstrap/js/bootstrap.min.js"></script>
</head>
<body>

<%
String	book_kindName = "";
if(book_kind.equals("100")) 		{ 	book_kindName = "문학";
} else if(book_kind.equals("200")) 	{ 	book_kindName = "외국어";
} else if(book_kind.equals("300")) 	{ 	book_kindName = "컴퓨터";
} else if(book_kind.equals("all")) 	{ 	book_kindName = "전체";
}
%>

<a href="../managerMain.jsp">관리자 메인으로</a>&nbsp;
<p><%=book_kindName %> 분류의 목록:
<% if(book_kind.equals("all")) { %>
	<%=count %> 권
<% } else { %>
	<%=bookList.size() %> 권
<% } %>
</p>

<table class="table">
	<tr>
		<td align="right">
			<div>
				<a href="bookRegisterForm.jsp" 
					class="btn btn-primary btn-sm active">책 등록</a>
			</div>
		</td>
		<td>
			<div class="btn-group">
				<button type="button" class="btn btn-default dropdown-toggle"
				data-toggle="dropdown" aria-expanded="false">
					도서종류 <span class="caret"></span>
				</button>
				<ul class="dropdown-menu">
					<li><a href="bookList.jsp?book_kind=all">전체목록보기</a></li>
					<li><a href="bookList.jsp?book_kind=100">문학</a></li>
					<li><a href="bookList.jsp?book_kind=200">외국어</a></li>
					<li><a href="bookList.jsp?book_kind=300">컴퓨터</a></li>
				</ul>
			</div>
		</td>
	</tr>
</table>

<%
//검색된 책이 1권도 없다면 
if(count <= 0) {
	out.println("<table>");
	out.println("<tr>");
	out.println("<td align=center>등록된 책이 없습니다.</td>");
	out.println("</tr>");
	out.println("</table>");
} else { // 검색된 책이 있다면 화면에 보여준다.
%>

<table class="table table-boardered table-striped table-hover">
	<tr height="30" class="info">
		<td align="center" width="30">번호</td>
		<td align="center" width="34">책분류</td>
		<td align="center" width="99">제목</td>
		<td align="center" width="50">가격</td>
		<td align="center" width="50">수량</td>
		<td align="center" width="70">저자</td>
		<td align="center" width="70">출판사</td>
		<td align="center" width="50">출판일</td>
		<td align="center" width="50">책이미지</td>
		<td align="center" width="34">할인율</td>
		<td align="center" width="70">등록일</td>
		<td align="center" width="50">수정</td>
		<td align="center" width="50">삭제</td>
	</tr>

<% //검색된 데이터의 건 수 만큼 화면에 보여준다.
for(int i = 0; i < bookList.size(); i++) { 
	ShopBookDataBean book = (ShopBookDataBean)bookList.get(i);
%> 
	<tr>
		<td align="right"><%=++number %></td>
		<td><%= book.getBook_kind() %></td>
		<td><%= book.getBook_title() %></td>
		<td align="right"><%= book.getBook_price() %> 원</td>
		<%if(book.getBook_count() == 0) { %>
		<td><font color="red">일시품절</font></td>
		<% } else { %>
		<td align="right"><%= book.getBook_count() %> 권</td>
		<% } %>
		<td><%= book.getAuthor() %></td>
		<td><%= book.getPublishing_com() %></td>
		<td><%= book.getPublishing_date() %></td>
		<td><%= book.getBook_image() %></td>
		<td><%= book.getDiscount_rate() %> %</td>
		<td><%= sdf.format(book.getReg_date()) %></td>
		<td align="center">
			<a href="bookUpdateForm.jsp?book_id=<%=book.getBook_id()%>&book_kind=<%=book.getBook_kind()%>">수정</a>
		</td>
		<td align="center">
			<a href="bookDeleteForm.jsp?book_id=<%=book.getBook_id()%>&book_kind=<%=book.getBook_kind()%>">삭제</a>
		</td>
	</tr>
<% } // End - for %>
</table>
<%	
}
%>

<br>
<a href="../managerMain.jsp"> 관리자 메인으로</a>


</body>
</html>


<%
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>





























