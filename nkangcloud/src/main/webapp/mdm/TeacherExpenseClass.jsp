<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.OAuthUitl.SNSUserInfo,java.lang.*"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.classhourrecord.Classexpenserecord"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%

String uid = request.getParameter("UID"); 

String name = "";
String headImgUrl ="";
String phone="";
HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(uid);
if(res!=null){
	if(res.get("HeadUrl")!=null){
		headImgUrl=res.get("HeadUrl");
	}
	if(res.get("NickName")!=null){
		name=res.get("NickName");
	}

	if(res.get("phone")!=null){
		phone=res.get("phone");
	}
}
List<Classexpenserecord> records=MongoDBBasic.getClassExpenseRecords("teacherOpenID",uid,"");
%><!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>课销记录</title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>

<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
<style type="text/css">
*{margin:0};
p{margin:0!important;}
a,a:hover,a:visited{text-decoration:none;color:black;}
.expensePanel{
width:88%;
margin-left:5%;
border:1px solid #20b672;
border-radius:5px;
margin-top:10px;
padding-left:2%;
padding-right:2%;}
	.item{
	height:35px;
	width:100%;}
	.title{
	height:100%;
	width:35%;
	line-height:38px;
	text-align:left;
	font-size:15px;
	float:left;
	}
	.value{
	height:100%;
	width:64%;
	line-height:38px;
	text-align:right;
	font-size:15px;
	float:left;
	}
	.
#footer {
    bottom: 0;
    color: #757575;
    font-size: 12px;
    padding: 10px 1%;
    position: fixed;
    text-align: center;
    width: 70%;
    z-index: 1002;
    left: 0;
}
</style>

</head>
<body>
	<div id="data_model_div" style="height: 100px">
		<i class="icon"
			style="position: absolute; top: 25px; z-index: 100; right: 20px;">
			<!-- <img class="exit" src="http://leshu.bj.bcebos.com/icon/EXIT1.png"
			style="width: 30px; height: 30px;"> -->
			<div
				style="width: 30px; height: 30px; float: left; border-radius: 50%; overflow: hidden;">
				<img class="exit" src="<%=headImgUrl%>"
					style="width: 30px; height: 30px;" />
			</div> <span
			style="position: relative; top: 8px; left: 5px; font-style: normal"><%=name%></span>
		</i> <img
			style="position: absolute; top: 8px; left: 10px; z-index: 100; height: 60px;"
			class="HpLogo"
			src="http://leshu.bj.bcebos.com/standard/leshuLogo.png" alt="Logo">
		<div
			style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
	<%for(int i=0;i<records.size();i++){ %>
<a href="expenseClassDetail.jsp?UID=<%=uid %>&&expenseID=<%=records.get(i).getExpenseID() %>" >
<div class="expensePanel">
<div class="item"><p class="title"><%=records.get(i).getExpenseOption() %>(<%=records.get(i).getExpenseClassCount() %>课时)</p><p class="value"><%=records.get(i).getExpenseDistrict() %></p></div>
<div class="item"><p class="title"><%=records.get(i).getExpenseTime() %></p><p class="value">
<%if(records.get(i).isParentConfirmExpense()) {%><span style="color:green;">已确认</span><%}else{ %><span style="color:red;">未确认</span><%} %>
</p></div>
</div></a>
<%} %>
</body>
</html>