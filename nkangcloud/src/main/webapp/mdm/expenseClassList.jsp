<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.OAuthUitl.SNSUserInfo,java.lang.*"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.classhourrecord.Classexpenserecord"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%

String uid = request.getParameter("UID"); 

String teacherID = request.getParameter("teacherID"); 
String classType= request.getParameter("classType");
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
List<Classexpenserecord> records=MongoDBBasic.autoExpenseClass(uid,classType);

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>课销记录</title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<script type="text/javascript" src="../nkang/jquery-1.8.0.js"></script>
<link rel="stylesheet" href="../nkang/jquery.mobile.min.css" />
<script type="text/javascript" src="../nkang/jquery.mobile.min.js"></script>
<style type="text/css">

.ui-body-c .ui-link:visited{
color:black!important;
font-weight:normal!important;}
.ui-body-c .ui-link{
color:black!important;
font-weight:normal!important;}
.ui-icon{
background:none!important;}
.ui-btn-hover-c{
background-image:none!important;}
.ui-li-has-arrow .ui-btn-inner a.ui-link-inherit, .ui-li-static.ui-li-has-arrow{
padding-right:0!important;}
.ui-listview, .ui-li{
border:none!important;
box-shadow:none!important;}
input.ui-input-text {
    width: 100%;
    border-style: none;
    border: 1px solid #20b672;
    height: 25px;
    border-radius: 5px;
    margin-left: -5px;
    padding-left: 10px;
}
.strong{
font-weight:bold;
}
.ui-btn-up-c{
background-image:none!important;
font-weight:0!important;}
*{margin:0;}
a,a:hover,a:visited{text-decoration:none;color:black;}

.expensePanel{
width:88%;
margin-left:4%;
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
	width:50%;
	line-height:38px;
	text-align:left;
	font-size:15px;
	float:left;
	}
	.value{
	height:100%;
	width:50%;
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
			src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" alt="Logo">
		<div
			style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
		<div style="position: absolute; top: 100px; overflow: hidden" data-role="page" style="padding-top:45px" data-theme="c">

		<ul id="Work_Mates_div" class="Work_Mates_div2" data-role="listview" data-autodividers="false" data-filter="true" data-filter-placeholder="输入关键字" data-inset="true" style="margin-top: 30px">
	
	<%for(int i=0;i<records.size();i++){ %>
	<li>
<div class="expensePanel">
<a target="_blank" href="expenseClassDetail.jsp?UID=<%=uid %>&&expenseID=<%=records.get(i).getExpenseID() %>&teacherID=<%=teacherID %>" >
<div class="item"><p class="title"><%=records.get(i).getExpenseOption() %>(<%=records.get(i).getExpenseClassCount() %>课时)</p><p class="value"><%=records.get(i).getExpenseDistrict() %></p></div>
<div class="item"><p class="title"><%=records.get(i).getExpenseTime() %></p><p class="value">
<%if(records.get(i).isParentConfirmExpense()) {%><span style="color:green;">已确认</span><%}else{ %><span style="color:red;">未确认</span><%} %>
</p></div>
</a></div>
</li>
<%} %>

</ul>
</body>
</html>