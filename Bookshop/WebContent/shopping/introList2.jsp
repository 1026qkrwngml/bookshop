<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bookshop.master.ShopBookDBBean" %>
<%@ page import = "bookshop.master.ShopBookDataBean" %>
<%@ page import = "java.text.NumberFormat" %>

<%@ page import = "java.util.*" %>

<%@ page import = "com.oreilly.servlet.MultipartRequest" %>
<%@ page import = "com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
    
<%
String	realFolder 	= ""; //웹 어플리케이션 상의 절대 경로
String	filename	= "";
MultipartRequest	imageUp = null;

String 	saveFolder	= "/imageFile"; //파일이 업로드되는 폴더를 지정
String	encType		= "utf-8"; 		//엔코딩 타입
int 	maxSize		= 5*1024*1024;	//최대 업로드될 파일 크기 5Mb

//현재 jsp페이지의 웹 어플리케이션 상의 절대 경로를 구한다.
ServletContext 	context	= getServletContext();
realFolder		= context.getRealPath(saveFolder);
%>

<h3 align="left">신간소개</h3>

<%
ShopBookDataBean bookLists[] = null;
int number = 0;
String book_kindName = "";

ShopBookDBBean bookProcess = ShopBookDBBean.getInstance();
//책 종류별로 신간 서적을 최대 3개를 가져온다.
for(int i = 1; i <= 3; i++)
{
	bookLists = bookProcess.getBooks(i+"00", 3);
	if(bookLists.equals("") || bookLists.equals(null)) {
		continue;
	}
	
	if( (bookLists[0].getBook_kind().equals("100")) ||
		(bookLists[0].getBook_kind().equals("200")) ||
		(bookLists[0].getBook_kind().equals("300")) 	)
	{
		if(bookLists[0].getBook_kind().equals("100")) 
			book_kindName = "문학";
		else if(bookLists[0].getBook_kind().equals("200")) 
			book_kindName = "외국어";
		else if(bookLists[0].getBook_kind().equals("300")) 
			book_kindName = "컴퓨터";
%>
	<table>
		<tr>
			<td width="550">
				<font size="+1"><b><%=book_kindName%> 분류의 신간목록:
				<a href="list.jsp?book_kind=<%=bookLists[0].getBook_kind()%>">더보기</a></b></font>
			</td>
		</tr>
	</table>
	
<%
	for(int j = 0; j < (bookLists[j] == null ? 0 : bookLists.length); j++) {
%>
	<table>
		<tr bgcolor="#b0e0e6">
			<td rowspan="4" width="100">
				<a href="bookContent.jsp?book_id=<%=bookLists[j].getBook_id()%>
				&book_kind=<%=bookLists[j].getBook_kind() %>">
					<img src="<%=realFolder%>\<%=bookLists[j].getBook_image()%>"
					border="0" width="60" height="90">
				</a>
			</td>
			<td width="350">
				<font size="+1"><b>
					<a href="bookContent.jsp?book_id=<%=bookLists[j].getBook_id()%>
					&book_kind=<%=bookLists[j].getBook_kind() %>">
					<%=bookLists[j].getBook_title() %></a>
				</b></font>
			</td>
			<td rowspan="4" width="100">
				<%
					if(bookLists[j].getBook_count() == 0) {
						out.println("<b>일시품절</b>");
					}
				%>
			</td>
		</tr>
		<tr>
			<td>출판사 : <%=bookLists[j].getPublishing_com() %></td>
		<tr>
		</tr>
			<td>저  자 : <%=bookLists[j].getAuthor() %></td>
		</tr>
		<tr>
			<td>정  가 : <%=NumberFormat.getInstance().format(bookLists[j].getBook_price())%>원<br>
			    판매가 : <b><font color="red">
			    <%=NumberFormat.getInstance().format((int)(bookLists[j].getBook_price()
			    		*((double)(100-bookLists[j].getDiscount_rate())/100))) %>
			    </font></b>원</td>
		</tr>
	</table>
<%	
	}
%>	
	
<%	
	} // End - if
} // End - for
%>



















































