<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.OAuthUitl.SNSUserInfo,java.lang.*"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.classhourrecord.StudentBasicInformation"%>
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
List<StudentBasicInformation> records=MongoDBBasic.getClassTypeRecordsByTeacher(uid);
%><!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>缴费记录_缴费人</title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<style type="text/css">
*{margin:0;}
a,a:hover,a:visited{text-decoration:none;color:black;}
.classRow{
height:70px;
width:19.5%;
margin-top:5px;
margin-bottom:5px;
float:left;
border-left:1px solid #CFCFCF;}
.classRow2{height:40px;}
.classRow p{
font-size:13px;
width:100%;
float:left;
height:35px;
line-height:35px;
text-align:center;
font-family:黑体;
}
.classPanel{
position:relative;
top:20px;
width:94%;
margin-left:3%;
height:80px;
border-top:1px solid #CFCFCF;
}
.classPane2{

height:50px!important;
}
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
	<%if(records.size()>0){ %>
		<a href="MyClassDetail.jsp?UID=<%=records.get(0).getOpenID() %>">
	<div class="classPanel">
	<div class="classRow" style="border-left: none;">
			<p>学员姓名</p>
			<p id="total"><%=records.get(0).getRealName() %></p>
		</div>
		<div class="classRow">
			<p>课时总量</p>
			<p id="total"><%=records.get(0).getTotalClass() %></p>
		</div>
		<div class="classRow">
			<p>已用课时</p>
			<p id="used"><%=records.get(0).getExpenseClass() %></p>
		</div>
		<div class="classRow" style="border-right: none;">
			<p>剩余课时</p>
			<p id="left"><%=records.get(0).getLeftPayClass() %></p>
		</div>
		<div class="classRow" style="border-right: none;">
			<p>赠送课时</p>
			<p id="gift"><%=records.get(0).getLeftSendClass() %></p>
		</div>
	</div>
	</a>
	<%} %>
	<%if(records.size()>1){ %>
	<%for(int i=1;i<records.size();i++){ %>
	<a href="MyClassDetail.jsp?UID=<%=records.get(i).getOpenID() %>">
	<div class="classPanel classPanel2">
	<div class="classRow classRow2" style="border-left: none;">
			<p id="total"><%=records.get(i).getRealName() %></p>
		</div>
		<div class="classRow classRow2">
			<p id="total"><%=records.get(i).getTotalClass() %></p>
		</div>
		<div class="classRow classRow2">
			<p id="used"><%=records.get(i).getExpenseClass() %></p>
		</div>
		<div class="classRow classRow2" style="border-right: none;">
			<p id="left"><%=records.get(i).getLeftPayClass() %></p>
		</div>
		<div class="classRow classRow2" style="border-right: none;">
			<p id="gift"><%=records.get(i).getLeftSendClass() %></p>
		</div>
	</div>
	</a>
<%}}%>
</body>
</html>