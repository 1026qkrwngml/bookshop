<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import = "bookshop.master.ShopBookDBBean" %>
<%@ page import = "bookshop.master.ShopBookDataBean" %>
<%@ page import = "java.text.NumberFormat" %>

<%@ page import = "java.util.ArrayList" %>
<%@ page import = "java.util.HashMap" %>
<%@ page import = "java.util.List" %>
<%@ page import = "java.util.Map" %>

<%@ page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>

<%
String realFolder = "";//웹 어플리케이션상의 절대 경로
String filename ="";
MultipartRequest imageUp = null; 

String saveFolder = "/imageFile";//파일이 업로드되는 폴더를 지정한다.
String encType = "utf-8"; //엔코딩타입

//현재 jsp페이지의 웹 어플리케이션상의 절대 경로를 구한다
ServletContext context = getServletContext();
realFolder = context.getRealPath(saveFolder);  
//realFolder = saveFolder;  
realFolder = "http://localhost:8080/BookShop/imageFile";

%>

<style>
body {
  background: #f2f2f2;
  font-family: "proxima-nova-soft", sans-serif;
  font-size: 14px;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
.post-module {
  position: relative;
  z-index: 1;
  display: block;
  background: #FFFFFF;
  min-width: 270px;
  height: 470px;
  -webkit-box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.15);
  -moz-box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.15);
  box-shadow: 0px 1px 2px 0px rgba(0, 0, 0, 0.15);
  -webkit-transition: all 0.3s linear 0s;
  -moz-transition: all 0.3s linear 0s;
  -ms-transition: all 0.3s linear 0s;
  -o-transition: all 0.3s linear 0s;
  transition: all 0.3s linear 0s;
}
.post-module:hover,
.hover {
  -webkit-box-shadow: 0px 1px 35px 0px rgba(0, 0, 0, 0.3);
  -moz-box-shadow: 0px 1px 35px 0px rgba(0, 0, 0, 0.3);
  box-shadow: 0px 1px 35px 0px rgba(0, 0, 0, 0.3);
}
.post-module:hover .thumbnail img,
.hover .thumbnail img {
  -webkit-transform: scale(1.1);
  -moz-transform: scale(1.1);
  transform: scale(1.1);
  opacity: 0.6;
}
.post-module .thumbnail {
  background: #000000;
  height: 400px;
  overflow: hidden;
}
.post-module .thumbnail .date {
  position: absolute;
  top: 20px;
  right: 20px;
  z-index: 1;
  background: #e74c3c;
  width: 55px;
  height: 55px;
  padding: 12.5px 0;
  -webkit-border-radius: 100%;
  -moz-border-radius: 100%;
  border-radius: 100%;
  color: #FFFFFF;
  font-weight: 700;
  text-align: center;
  -webkti-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
}
.post-module .thumbnail .date .day {
  font-size: 18px;
}
.post-module .thumbnail .date .month {
  font-size: 12px;
  text-transform: uppercase;
}
.post-module .thumbnail img {
  display: block;
  width: 120%;
  -webkit-transition: all 0.3s linear 0s;
  -moz-transition: all 0.3s linear 0s;
  -ms-transition: all 0.3s linear 0s;
  -o-transition: all 0.3s linear 0s;
  transition: all 0.3s linear 0s;
}
.post-module .post-content {
  position: absolute;
  bottom: 0;
  background: #FFFFFF;
  width: 100%;
  padding: 30px;
  -webkti-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  -webkit-transition: all 0.3s cubic-bezier(0.37, 0.75, 0.61, 1.05) 0s;
  -moz-transition: all 0.3s cubic-bezier(0.37, 0.75, 0.61, 1.05) 0s;
  -ms-transition: all 0.3s cubic-bezier(0.37, 0.75, 0.61, 1.05) 0s;
  -o-transition: all 0.3s cubic-bezier(0.37, 0.75, 0.61, 1.05) 0s;
  transition: all 0.3s cubic-bezier(0.37, 0.75, 0.61, 1.05) 0s;
}
.post-module .post-content .category {
  position: absolute;
  top: -34px;
  left: 0;
  background: #e74c3c;
  padding: 10px 15px;
  color: #FFFFFF;
  font-size: 14px;
  font-weight: 600;
  text-transform: uppercase;
}
.post-module .post-content .title {
  margin: 0;
  padding: 0 0 10px;
  color: #333333;
  font-size: 26px;
  font-weight: 700;
}
.post-module .post-content .sub_title {
  margin: 0;
  padding: 0 0 20px;
  color: #e74c3c;
  font-size: 20px;
  font-weight: 400;
}
.post-module .post-content .description {
  display: none;
  color: #666666;
  font-size: 14px;
  line-height: 1.8em;
}
.post-module .post-content .post-meta {
  margin: 30px 0 0;
  color: #999999;
}
.post-module .post-content .post-meta .timestamp {
  margin: 0 16px 0 0;
}
.post-module .post-content .post-meta a {
  color: #999999;
  text-decoration: none;
}
.hover .post-content .description {
  display: block !important;
  height: auto !important;
  opacity: 1 !important;
}
.container {
  max-width: 800px;
  min-width: 640px;
  margin: 0 auto;
}
.container:before,
.container:after {
  content: "";
  display: block;
  clear: both;
}
.container .column {
  width: 50%;
  padding: 0 25px;
  -webkti-box-sizing: border-box;
  -moz-box-sizing: border-box;
  box-sizing: border-box;
  float: left;
}
.container .column .demo-title {
  margin: 0 0 15px;
  color: #666666;
  font-size: 18px;
  font-weight: bold;
  text-transform: uppercase;
}
.container .info {
  width: 300px;
  margin: 50px auto;
  text-align: center;
}
.container .info h1 {
  margin: 0 0 15px;
  padding: 0;
  font-size: 24px;
  font-weight: bold;
  color: #333333;
}
.container .info span {
  color: #666666;
  font-size: 12px;
}
.container .info span a {
  color: #000000;
  text-decoration: none;
}
.container .info span .fa {
  color: #e74c3c;
}

</style>


<html>


<head>
	<title>Book Shopping Mall</title>
	<link href="../etc/style.css" rel="stylesheet" type="text/css">
    <link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<script src="../js/jquery-2.2.0.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
</head>


<body>






<div style="width: 100%; height: 100px; line-height: 100px; text-align: center">

    <img src="image1.png" style="width:101%; height:500px;  vertical-align: middle" />
 
</div>



<div class="container" style=" width:1000px; padding-top: 400px;" >


  <div class="info">
    <h1>신간서적 안내</h1><span> 책에 모든 것, 이슈 & 트랜드를 읽다 <i class='fa fa-heart animated infinite pulse'></i>  </span>
  </div>
  <!-- Normal Demo-->
  <div class="column">
    <div class="demo-title">신간서적 안내 </div>
    <!-- Post-->
    <div class="post-module">
      <!-- Thumbnail-->
      <div class="thumbnail">
       <img src="book1.jpg"/>
      </div>
      <!-- Post Content-->
      <div class="post-content">
       
        <h1 class="title">당신을 믿어요</h1>
        <h2 class="sub_title">오늘도 함께하는 그대와 </h2>
        <p class="description">나는 당신이 상처보다 더 크고, 아픔보다 더 강한 사람임을 믿어요.</p>
        <div class="post-meta"><span class="timestamp"><i class="fa fa-clock-">o</i> 6 mins ago</span><span class="comments"><i class="fa fa-comments"></i><a href="#"> 39 comments</a></span></div>
      </div>
    </div>
  </div>
  <!-- Normal Demo-->
  <div class="column">
    <div class="demo-title">오늘의 책</div>
    <!-- Post-->
    <div class="post-module">
      <!-- Thumbnail-->
      <div class="thumbnail">
       <img src="book2.jpg"/>
      </div>
      <!-- Post Content-->
      <div class="post-content">
       
        <h1 class="title">넷플릭스의 시대</h1>
        <h2 class="sub_title">우리가 아는 방송은 더 이상 유효하지 않다!</h2>
        <p class="description">New York, the largest city in the U.S., is an architectural marvel with plenty of historic monuments, magnificent buildings and countless dazzling skyscrapers.</p>
        <div class="post-meta"><span class="timestamp"><i class="fa fa-clock-">o</i> 6 mins ago</span><span class="comments"><i class="fa fa-comments"></i><a href="#"> 39 comments</a></span></div>
      </div>
    </div>
  </div>
  
    <div class="column">
    
    <!-- Post-->
    <div class="post-module">
      <!-- Thumbnail-->
      <div class="thumbnail">
       <img src="book4.PNG "/>
      </div>
      <!-- Post Content-->
      <div class="post-content">
       
        <h1 class="title">곰돌이푸</h1>
        <h2 class="sub_title">행복한 일은 매일 있어</h2>
        <p class="description">New York, the largest city in the U.S., is an architectural marvel with plenty of historic monuments, magnificent buildings and countless dazzling skyscrapers.</p>
        <div class="post-meta"><span class="timestamp"><i class="fa fa-clock-">o</i> 6 mins ago</span><span class="comments"><i class="fa fa-comments"></i><a href="#"> 39 comments</a></span></div>
      </div>
    </div>
  </div>
  
   <div class="column">
    
    <!-- Post-->
    <div class="post-module">
      <!-- Thumbnail-->
      <div class="thumbnail">
       <img src="book3.PNG "/>
      </div>
      <!-- Post Content-->
      <div class="post-content">
       
        <h1 class="title">능력자들</h1>
        <h2 class="sub_title">어느날 그들이 나타났다.</h2>
        <p class="description">New York, the largest city in the U.S., is an architectural marvel with plenty of historic monuments, magnificent buildings and countless dazzling skyscrapers.</p>
        <div class="post-meta"><span class="timestamp"><i class="fa fa-clock-">o</i> 6 mins ago</span><span class="comments"><i class="fa fa-comments"></i><a href="#"> 39 comments</a></span></div>
      </div>
    </div>
  </div>
  
  
  
 
  

<%
ShopBookDataBean bookLists[] = null;
//bookLists = new ShopBookDataBean[3];
  int number =0;
  String book_kindName="";
  
  //int j = 0;
  ShopBookDBBean bookProcess = ShopBookDBBean.getInstance();
 // for (int j = 0; j < (bookLists[j] == null ? 0 : bookLists.length); j++) {	
  for(int i = 1; i <= 3; i++) {
	  bookLists = bookProcess.getBooks(i+"00", 3);
	  

		//System.out.println("Before NULL Check..");
	if(bookLists == null || bookLists.equals("") || bookLists.equals(null) || bookLists.equals("null")) {
		//System.out.println("NULL에 걸렸습니다..");
		//없는 값을 디스플레이하면 이곳에서 프로그램이 멈춘다.
		//System.out.println("넘어온 값이 없습니다. bookLists.length[" + bookLists.length + "]");
		continue;
	} else {
		//System.out.println("NULL이 아닙니다.");
	}

	  
     if( (bookLists[0].getBook_kind().equals("100")) ||
         (bookLists[0].getBook_kind().equals("200")) ||
	     (bookLists[0].getBook_kind().equals("300")) )
     {
	     if(bookLists[0].getBook_kind().equals("100")) {
		      book_kindName="문학";
	     }else if(bookLists[0].getBook_kind().equals("200")) {
		      book_kindName="외국어";  
	     }else if(bookLists[0].getBook_kind().equals("300")) {
		      book_kindName="컴퓨터";
	     } 
     
     //System.out.println("bookLists.length="+bookLists.length);
%>
  <br>
  <!-- 
  <font size="+1"><b><%=book_kindName%> 분류의 신간목록: 
  <a href="list.jsp?book_kind=<%=bookLists[0].getBook_kind()%>">더보기</a>
  </b></font>
	 -->
    <table> 
      <tr height="30"> 
        <td width="550">
        <font size="+1"><b><%=book_kindName%> 분류의 신간목록: 
  <a href="list.jsp?book_kind=<%=bookLists[0].getBook_kind()%>">더보기</a>
  </b></font>
        </td>
      </tr>
	</table>
<%             

int bookCount = bookProcess.getBookCount(bookLists[0].getBook_kind());
if(bookCount >= 3) bookCount = 3;

for (int j = 0; j < bookCount; j++) {	


%>
    <table> 
      <tr height="30" "> 
        <td rowspan="4"  width="100">
          <a href="bookContent.jsp?book_id=<%=bookLists[j].getBook_id()%>&book_kind=<%=bookLists[j].getBook_kind()%>">
	        <img src="<%=realFolder%>\<%=bookLists[j].getBook_image()%>" 
             border="0" width="60" height="90"></a></td> 
       <td width="350"><font size="+1"><b>
          <a href="bookContent.jsp?book_id=<%=bookLists[j].getBook_id()%>&book_kind=<%=bookLists[j].getBook_kind()%>">
              <%=bookLists[j].getBook_title() %></a></b></font></td> 
       <td rowspan="4" width="100">
          <%if(bookLists[j].getBook_count()==0){ %>
              <b>일시품절</b>
          <%}else{ %>
               &nbsp;
          <%} %>
       </td>
     </tr>        
     <tr height="30"> 
       <td width="350">출판사 : <%=bookLists[j].getPublishing_com()%></td> 
     </tr>
     <tr height="30"> 
       <td width="350">저자 : <%=bookLists[j].getAuthor()%></td>
     </tr>
     <tr height="30"> 
       <td width="350">정가 :<%=NumberFormat.getInstance().format(bookLists[j].getBook_price())%>원<br>
                판매가 : <b><font color="red">
       <%=NumberFormat.getInstance().format((int)(bookLists[j].getBook_price()*((double)(100-bookLists[j].getDiscount_rate())/100)))%>
            </font></b>원</td> 
     </tr> 
     </table>
     <br>
<%

}
//  }
%>

<%
     }
}
%>

</body>
</html>