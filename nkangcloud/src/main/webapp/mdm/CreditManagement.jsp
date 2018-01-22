﻿<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.baseobject.GeoLocation"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.WeChatUser"%>
<%@ page import="com.nkang.kxmoment.baseobject.ClientMeta"%>
<%@ page import="com.nkang.kxmoment.util.Constants"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
String uid = request.getParameter("UID");
String code = uid;
String price = request.getParameter("TOTALFEE");
String notifyURL = Constants.notifyURL;
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
%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>积分管理</title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />

<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
	<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
	<style>
	*{padding:0;margin: 0;}
body{
  background: #FEFEFE;
  margin-bottom: 50px;
  height: auto;
}
a{
  text-decoration: none;
  color:black;
}
a:visited{
  color:black;
}
.infoPanel
{
  padding:0 2%;
  width: 96%;
}
.infoArea,.imgArea{
  width:100%;
  height:40px;
  border-bottom: 1px solid #EFEFEF;
}
.imgArea{
  background: white;
  height:90px;
  position: relative;
}
.imgContainer
{
  position: absolute;
  left:40%;
  top:10px;
  width:70px;
  height:70px;
  overflow: hidden;
  border-radius: 50%;
}
.imgContainer img
{
  width:100%;
  height: 100%;
}
.infoTitle
{
  width:29%;
  text-align: left;
  padding-left:1%;
  height: 100%;
  line-height: 45px;
  float: left;
  font-weight:bold;
}
.infoVal
{
  float: right;
  width:68%;
  text-align: right;
  padding-right:2%;
  height: 100%;
  line-height: 45px;
}
.pay{
    text-align: center;
    height:50px;
    line-height: 50px;
    background: #20b672;
    color: white;
    position:absolute;
    bottom:30px;}
.infoPay{
padding-top:20px;
height:70px;
/* border-bottom:1px solid #EFEFEF; */
}
.payTitle{
    text-align: left;
    line-height: 40px;
    color: black;
    padding-left: 10px;
    border: none;
    font-weight:bolder;
}
.infoItem{
width:30%;
margin-left:2%;
height:60px;
float:left;
border:1px solid #20b672;
color:#20b672;
border-radius:5px;
line-height:25px;
font-size:0.8rem;
text-align:center;
}
#footer {
    background: #DCD9D9;
    bottom: 0px;
    color: #757575;
    font-size: 12px;
    padding: 10px 1%;
    position: absolute;
    text-align: center;
    width: 100%;
    z-index: 1002;
    left: 0;
}
.default{
	color:white;
	background:#20b672;
}
	</style>
	</head>
<body>
	
<script type="text/javascript">  

var studentID;
function pay(){
	var currentTime=getNowFormatDate();
	var payMoney=$(".default").find(".priceText").text();
	var classCount=$(".default").find(".classText").text();
	$.ajax({
		 url:'../ClassRecord/addClasspayrecord',
		 type:"GET",
		 data : {
			 payOption:$("#classType").find("option:selected").val(),
			 payMoney:payMoney,
			 classCount:classCount,
			 payTime:currentTime,
			 studentName:$("#name").text(),
			 studentOpenID:studentID,
			 phone:$("#phone").val(),	
			 operatorOpenID:'<%=uid%>'
		 },
		 success:function(data){
			 if(data){
				 $("#name").text(data.realName);
				 studentID=data.openid;
					swal("提交成功!", "恭喜!", "success");

					 $("#name").text("");
					 $("#phone").val("");
			 }else{

					swal("提交失败!", "请填写正确的信息.", "error");
				}
		}
	});
	
}
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var hour=date.getHours();
    var minute=date.getMinutes();
    var second=date.getSeconds();
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (hour >= 1 && hour <= 9) {
        hour = "0" + hour;
    }
    if (minute >= 1 && minute <= 9) {
        minute = "0" + minute;
    }
    if (second >= 1 && second <= 9) {
        second = "0" + second;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + hour + seperator2 + minute
            + seperator2 + second;
    return currentdate;
}
$(function(){
	$(".price").on("click",function(){
		totalfee=$(this).children("span").text();
		$(this).addClass("default");
		$(this).siblings().removeClass("default");
		totalfee = totalfee+"00";
		totalfee = "1";
	});
	$("#phone").blur(function(){
		$.ajax({
			 url:'../userProfile/getNameByPhone',
			 type:"GET",
			 data : {
				 phone:$(this).val(),
			 },
			 success:function(data){
				 if(data){
					 $("#name").text(data.realName);
					 studentID=data.openid;
				 }
				 
			}
		});
		
	});
});
    </script>
    	
	
	<a href="http://leshucq.bceapp.com/mdm/payHistory.jsp?UID=<%=uid %>" style="position: absolute;bottom: 90px;right: 10px;font-size: 14px;text-decoration: underline;color: #20b672;">查看积分记录</a>
	<div id="data_model_div" style="height: 90px">
		<i class="icon" style="position: absolute;top: 25px;z-index: 100;right: 20px;">
			<div style="width: 30px;height: 30px;float: left;border-radius: 50%;overflow: hidden;">
				<img class="exit" src="<%=headImgUrl %>" style="width: 30px; height: 30px;" />
			</div>
			<span style="position: relative;top: 8px;left: 5px;font-style:normal"><%=name %></span>
		</i>
		<img style="position: absolute;top: 8px;left: 10px;z-index: 100;height: 60px;" class="HpLogo" src="http://leshu.bj.bcebos.com/standard/leshuLogo.png" alt="Logo">
		<div style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;"></div>
	</div>
    <div class="infoPanel">
      <div class="infoArea">
        <p class="infoTitle">手机号码</p>
        <p class="infoVal"><input id="phone" style="border:none;height:30px;text-align:right;font-size:15px;" type="text" value="" /></p>
      </div>
    </div>   
     <div class="infoPanel">
      <div class="infoArea">
        <p class="infoTitle">姓名</p>
        <p id="name" class="infoVal"></p>
      </div>
    </div>
    <div class="infoPanel">
      <div class="infoArea">
        <p class="infoTitle">积分变化说明</p>
        <p class="infoVal"><input id="ChangeJustification" style="border:none;height:30px;text-align:right;font-size:15px;" type="text" value="" /></p>
      </div>
    </div>   

    <div class="infoPanel">
      <div class="infoPay">
		  <div class="infoItem price default"><img src="http://leshucq.bj.bcebos.com/icon/minus_white.png" width="30px" height="30px"><br><span class="classText"></span>消费积分</div>
		  <div class="infoItem price default"><img src="http://leshucq.bj.bcebos.com/icon/plus_white.png" width="30px" height="30px"><br><span class="classText"></span>增加积分</div>
     </div>
    </div>



      <div class="infoArea pay"><a href="javascript:pay();" style="color:white;">提交请求</a></div>
    	<div id="footer">
		<span class="clientCopyRight"><nobr>©版权所有 | 重庆乐数珠心算</nobr></span>
	</div>
	</body>
</html>
