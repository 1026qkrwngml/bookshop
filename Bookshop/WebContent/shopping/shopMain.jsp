<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Book Shopping Mall</title>
	<link href="../css/main.css" rel="stylesheet" type="text/css">
	<link href="../bootstrap/css/bootstrap.min.css" rel="stylesheet">
	<script src="../js/jquery-3.3.1.min.js"></script>
	<script src="../bootstrap/js/bootstrap.min.js"></script>
</head>
<body>

	<jsp:include page="../module/top.jsp" flush="false"/>
	
	
	
	
	<div class="container-fluid">
		<div class="row">
			<%-- <div class="col-sm-3 col-md-2 sidebar">
				<ul class="nav nav-sidebar">
					<jsp:include page="../module/left.jsp" flush="false"/>
				</ul>
			</div> --%>
			<div class=" main">
				<jsp:include page="introList.jsp" flush="false"/>
			</div>
		</div>
	</div>
	
	
	<!-- /////////////////////////////////////////////////////////////// -->
	


</body>
</html>


























