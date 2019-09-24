<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bookshop.master.ShopBookDBBean" %>
<%@ page import = "bookshop.master.ShopBookDataBean" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.text.NumberFormat" %>
<% String book_kind = request.getParameter("book_kind"); %>

<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>도서 구매몰</title>
	<link href="../css/main.css" rel="stylesheet" type="text/css">
	<link href="../css/style.css" rel="stylesheet" type="text/css">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<script src="../js/jquery-3.3.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
</head>
<body bgcolor="#cceeff">

<jsp:include page="../module/top.jsp" flush="false" />
<br><br>

	<table class="table">
		<tr>
			<td width="150" valign="top">
				<jsp:include page="../module/left.jsp" flush="false"/>
			</td>
			<td width="700">
			<%
			List<ShopBookDataBean> 	bookLists = null;
			ShopBookDataBean 		bookList  = null;
			String book_kindName = "";
			
			String realFolder = ""; //웹 어플리케이션 상의 절대 경로
			String saveFolder = "/imageFile"; //파일이 업로드되는 폴더
			
			ServletContext context = getServletContext();
			realFolder = context.getRealPath(saveFolder);
			realFolder = "http://localhost:8080/BookShop/imageFile";
			
			ShopBookDBBean bookProcess = ShopBookDBBean.getInstance();
			//책 종류에 대한 모든 책의 자료를 가져온다.
			bookLists = bookProcess.getBooks(book_kind);
			
			if(book_kind.equals("100")) book_kindName = "문학";
			else if(book_kind.equals("200")) book_kindName = "외국어";
			else if(book_kind.equals("300")) book_kindName = "컴퓨터";
			else if(book_kind.equals("all")) book_kindName = "전체";
			%>

			<h3><b><%=book_kindName %> 분류의 목록</b></h3>
			<a href="shopMain.jsp">메인으로</a><hr>
			
			<%
			for(int i = 0; i < bookLists.size(); i++) {
				bookList = (ShopBookDataBean)bookLists.get(i);
			%>
			<table class="table">
				<tr>	
					<td rowspan="4" width="100">
						<a href="bookContent.jsp?book_id=<%=bookList.getBook_id()%>&book_kind=<%=book_kind%>">
						<img src="<%=realFolder%>\<%=bookList.getBook_image()%>" border="0" width="60" height="90">
						</a>
					</td>
					<td><font size="+1"><b>
						<a href="bookContent.jsp?book_id=<%=bookList.getBook_id()%>&book_kind=<%=book_kind%>">
						<%=bookList.getBook_title()%>
						</a></b></font>
					</td>
					<td rowspan="4" width="100" align="center" valign="middle"> 
						<%if(bookList.getBook_count() == 0) { out.println("<b>일시품절</b>"); } %>
					</td>
				</tr>
				<tr>
					<td width="350">출판사 : <%=bookList.getPublishing_com() %></td>
				</tr>
				<tr>
					<td width="350">저  자 : <%=bookList.getAuthor() %></td>
				</tr>
				<tr>
					<td width="350">
						정  가 : <%=NumberFormat.getInstance().format(bookList.getBook_price())%><br>
						판매가 : <b><font color="red">
						<%=NumberFormat.getInstance().format((int)(bookList.getBook_price()
							*((double)(100-bookList.getDiscount_rate())/100))) %>
						</font></b>

					</td>
				</tr>
			</table>	
				
			<% } // End - for%>
			</td>
		</tr>
	</table>
</body>
</html>



































