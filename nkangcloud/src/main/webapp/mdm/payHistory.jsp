<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.OAuthUitl.SNSUserInfo,java.lang.*"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.classhourrecord.Classpayrecord"%>
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
List<Classpayrecord> records=MongoDBBasic.getClasspayrecords("","");
%><!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>缴费记录_缴费人</title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<script type="text/javascript" src="../nkang/jquery-1.8.0.js"></script>
<link rel="stylesheet" href="../nkang/jquery.mobile.min.css" />
<script type="text/javascript" src="../nkang/jquery.mobile.min.js"></script>
<style type="text/css">
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
	width:55%;
	line-height:38px;
	text-align:left;
	font-size:14px;
	float:left;
	font-weight: normal;
	}
	.value{
	height:100%;
	width:45%;
	line-height:38px;
	text-align:right;
	font-size:14px;
	float:left;
	font-weight: normal;
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
    height: 30px;
    border-radius: 5px;
    margin-left: -10px;
    padding-left: 10px;   
     padding-right: 10px;
     font-size:14px;
     position: relative;
    z-index: 10000;
}

.ui-btn-up-c{
background-image:none!important;
font-weight:0!important;}
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
<div class="item"><p class="title"><%=records.get(i).getStudentName() %>(<%=records.get(i).getPhone() %>)</p><p class="value"><%=records.get(i).getPayOption() %></p></div>
<div class="item"><p class="title"><%=records.get(i).getPayTime() %></p><p class="value"><%=records.get(i).getPayMoney()%>元/<%=records.get(i).getClassCount() %><%if(records.get(i).getGiftClass()!=0){%>(+<%=records.get(i).getGiftClass()%>)<%} %>次课</p></div>
</div>
</li>
<%} %>

</ul>
</body>
</html>