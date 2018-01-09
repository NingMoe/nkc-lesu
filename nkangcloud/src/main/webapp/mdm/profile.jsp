﻿<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.baseobject.GeoLocation"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.WeChatUser"%>
<%@ page import="com.nkang.kxmoment.baseobject.ClientMeta"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
String AccessKey = RestUtils.callGetValidAccessKey();
String uid = request.getParameter("UID");
MongoDBBasic.updateUser(uid);
String curLoc=null;
String city=null;
WeChatUser wcu;
session.setAttribute("UID", uid);
if (session.getAttribute("location") == null) {
	GeoLocation loc = RestUtils.callGetDBUserGeoInfo(uid);
	wcu = RestUtils.getWeChatUserInfo(AccessKey, uid);
	String message = RestUtils.getUserCurLocStrWithLatLng(loc.getLAT(),loc.getLNG());
	 JSONObject demoJson = new JSONObject(message);
     if(demoJson.has("result")){
  	    JSONObject JsonFormatedLocation = demoJson.getJSONObject("result");
  	 	curLoc = JsonFormatedLocation.getString("formatted_address");
  	 	city = JsonFormatedLocation.getJSONObject("addressComponent").getString("city");
     }
	session.setAttribute("location", curLoc);
	session.setAttribute("city", city);
	session.setAttribute("wcu", wcu);
} else {
	wcu = (WeChatUser) session.getAttribute("wcu");
	curLoc = (String) session.getAttribute("location");
}
String role=MongoDBBasic.queryAttrByOpenID("role", uid,true);
System.out.println("role is========"+role);
boolean isTeacher=false;
if(role.equals("Role001")||role.equals("Role004")||role.equals("Role005")){
	isTeacher=true;
System.out.println("isTeacher is true");
}
boolean IsAuthenticated=MongoDBBasic.checkUserAuth(uid,"IsAuthenticated");
SimpleDateFormat  format = new SimpleDateFormat("yyyy-MM-dd"); 
Date date=new Date();
String currentDate = format.format(date);
HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(uid);
MongoDBBasic.updateVisited(uid,currentDate,"profile",res.get("HeadUrl"),res.get("NickName"));
String level=res.get("level");

System.out.println("isTeacher====="+isTeacher);
%>
<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<meta charset="utf-8" />
<title>我的主页</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<meta content="" name="description" />
<meta content="" name="hpe" />

<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/bootstrap/css/bootstrap-responsive.min.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/font-awesome/css/font-awesome.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/profile.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/icomoon/iconMoon.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style-responsive.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style-default.css"/>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css"/>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/CSS/sonhlab-base.css"/>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/CSS/openmes.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="../nkang/themes/icon.css">
<link rel="stylesheet" type="text/css" href="../nkang/demo.css">
<link rel="stylesheet" type="text/css" href="../nkang/animate.min.css">
<link rel="stylesheet" type="text/css" href="../nkang/autocomplete/jquery-ui.css">
<script type="text/javascript" src="../nkang/easyui/jquery.min.js"></script>
<script type="text/javascript">var $113 = $;</script>
<script type="text/javascript" src="../nkang/easyui/jquery.easyui.min.js"></script>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/CSS/animation-effects.css"/>
<!-- <link href="../nkang/editor/froala_editor.min.css" rel="stylesheet" type="text/css"> -->  <!-- do not need this one -->
<link href="../nkang/editor/font-awesome.min.css" rel="stylesheet" type="text/css"> 
<link rel="stylesheet" type="text/css" href="../Jsp/CSS/common.css">
<link rel="stylesheet" type="text/css" href="../Jsp/CSS/page.css">
<link rel="stylesheet" type="text/css" href="../Jsp/CSS/register.css">
<script type="text/javascript" src="../Jsp/JS/slides.js"></script>
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/bootstrap/css/bootstrap.min.css"/>
<link rel="stylesheet" type="text/css" href="../mdm/uploadfile_css/demo.css" />
<link rel="stylesheet" type="text/css" href="../mdm/uploadfile_css/component.css" />
<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
<script type="text/javascript" src="../nkang/jquery-form.js"></script>
<link rel="stylesheet" href="../nkang/jquery.mobile.min.css" />
<script src="../Jsp/JS/fusioncharts.js" type="text/javascript"></script>
<script src="../mdm/uploadfile_js/custom-file-input.js"></script>
<!-- <script src="../nkang/editor/jquery-1.11.1.min.js"></script> -->
<script type="text/javascript" src="../nkang/editor/froala_editor.min.js"></script>
<script type="text/javascript" src="../nkang/editor/colors.min.js"></script>
<script type="text/javascript" src="../nkang/editor/font_family.min.js"></script>
<script type="text/javascript" src="../nkang/editor/font_size.min.js"></script>
<script type="text/javascript" src="../nkang/editor/block_styles.min.js"></script>

<script>(function(e,t,n){var r=e.querySelectorAll("html")[0];r.className=r.className.replace(/(^|\s)no-js(\s|$)/,"$1js$2")})(document,window,0);</script>
<style>
 #return-top{position:fixed;bottom:40px;right:10px; text-align:center; display:none;z-index:998;} 
	.mySlides {display:none}
	.w3-left, .w3-right, .w3-badge {cursor:pointer}
	.w3-badge {height:13px;width:13px;padding:0}
.edit
{
	width: 60px;
    height: 100%;
    color: #fff;
    font-family:微软雅黑;
    text-align: center;
    position: absolute;
    top: 0px;
    right: -60px;
	font-size:14px;
    background: #438CD0;
    border-bottom: 1px solid #ccc;
}
.edit.km{
	right: -120px;
    background: orange;
}
.edit img {
    width:25px;height:auto;position:absolute;top:25px;margin-left: 2px;
}
.edit.km p{
	line-height:35px;
	padding-top:20px;
}
.edit p
{
	width:50%;
	height:100%;
	line-height:145px;
	margin-right:auto;
	margin-left:auto;
}
input#search{
	height:31px;
    width: 10px;
    box-sizing: border-box;
    border: 0px solid #ccc;
    border-radius: 4px;
    font-size: 16px;
    font-weight:bold;
    color:#fff !important;
    background-color:rgba(0, 0, 0, 0);
    background-image: url('../MetroStyleFiles/searchicon.png');
    background-position: 5px 5px; 
    background-repeat: no-repeat;
    padding: 12px 0px 12px 40px;
 /*    -webkit-transition: width 0.4s ease-in-out; */
    transition: width 0.4s ease-in-out;
    margin-top:3px;
    margin-bottom:8px;
    position: relative;
}

.PositionR {
    position: relative;
   /*  margin-top: -35px; */
}

input#search:focus {
    width: 100%;
    background-color:rgba(200, 200, 200, 1);
} 
.icon {
    display: inline-block;
    width: 30px; height: 30px;
    overflow: hidden;
    -overflow: hidden;
}
.icon > img.exit {
    position: relative;
    left: -30px;
    border-right: 30px solid transparent;
    -webkit-filter: drop-shadow(30px 0 #fff);
    filter: drop-shadow(20px 0);   
}
.edit
{
	width: 60px;
    height: 100%;
    color: #fff;
    font-family:微软雅黑;
    text-align: center;
    position: absolute;
    top: 0px;
    right: -60px;
	font-size:14px;
    background: #438CD0;
    border-bottom: 1px solid #ccc;
}
.edit.km{
	right: -120px;
    background: orange;
}
.edit img {
    width:25px;height:auto;position:absolute;top:25px;margin-left: 2px;
}
.edit.km p{
	line-height:35px;
	padding-top:20px;
}
.edit p
{
	width:50%;
	height:100%;
	line-height:145px;
	margin-right:auto;
	margin-left:auto;
}
.editBtn
{
	position: relative;
    left: -120px;
}

.imgSelect{
	height:50%;
	width:24%;
	position:relative;
	float:left;
}
.imgSelect img{
	width: 100%;height:100%;
}
.imgCB
{
	position: absolute;
	bottom: 2px;
	right: 2px;
	width: 15px;
	height: 15px;
}
/*ajax*/

.sk-circle {
	margin: 40px auto;
	width: 40px;
	height: 40px;
	position: absolute;
	top: 38%;
	left: 45%;
	display:none;
	z-index:100000;
}
.sk-circle .sk-child {
    width: 100%;
    height: 100%;
    position: absolute;
    left: 0;
    top: 0; 
}
.sk-circle .sk-child:before {
    content: '';
    display: block;
    margin: 0 auto;
    width: 15%;
    height: 15%;
    background-color: white;
    border-radius: 100%;
    -webkit-animation: sk-circleBounceDelay 1.2s infinite ease-in-out both;
            animation: sk-circleBounceDelay 1.2s infinite ease-in-out both; }
  .sk-circle .sk-circle2 {
    -webkit-transform: rotate(30deg);
        -ms-transform: rotate(30deg);
            transform: rotate(30deg); }
  .sk-circle .sk-circle3 {
    -webkit-transform: rotate(60deg);
        -ms-transform: rotate(60deg);
            transform: rotate(60deg); }
  .sk-circle .sk-circle4 {
    -webkit-transform: rotate(90deg);
        -ms-transform: rotate(90deg);
            transform: rotate(90deg); }
  .sk-circle .sk-circle5 {
    -webkit-transform: rotate(120deg);
        -ms-transform: rotate(120deg);
            transform: rotate(120deg); }
  .sk-circle .sk-circle6 {
    -webkit-transform: rotate(150deg);
        -ms-transform: rotate(150deg);
            transform: rotate(150deg); }
  .sk-circle .sk-circle7 {
    -webkit-transform: rotate(180deg);
        -ms-transform: rotate(180deg);
            transform: rotate(180deg); }
  .sk-circle .sk-circle8 {
    -webkit-transform: rotate(210deg);
        -ms-transform: rotate(210deg);
            transform: rotate(210deg); }
  .sk-circle .sk-circle9 {
    -webkit-transform: rotate(240deg);
        -ms-transform: rotate(240deg);
            transform: rotate(240deg); }
  .sk-circle .sk-circle10 {
    -webkit-transform: rotate(270deg);
        -ms-transform: rotate(270deg);
            transform: rotate(270deg); }
  .sk-circle .sk-circle11 {
    -webkit-transform: rotate(300deg);
        -ms-transform: rotate(300deg);
            transform: rotate(300deg); }
  .sk-circle .sk-circle12 {
    -webkit-transform: rotate(330deg);
        -ms-transform: rotate(330deg);
            transform: rotate(330deg); }
  .sk-circle .sk-circle2:before {
    -webkit-animation-delay: -1.1s;
            animation-delay: -1.1s; }
  .sk-circle .sk-circle3:before {
    -webkit-animation-delay: -1s;
            animation-delay: -1s; }
  .sk-circle .sk-circle4:before {
    -webkit-animation-delay: -0.9s;
            animation-delay: -0.9s; }
  .sk-circle .sk-circle5:before {
    -webkit-animation-delay: -0.8s;
            animation-delay: -0.8s; }
  .sk-circle .sk-circle6:before {
    -webkit-animation-delay: -0.7s;
            animation-delay: -0.7s; }
  .sk-circle .sk-circle7:before {
    -webkit-animation-delay: -0.6s;
            animation-delay: -0.6s; }
  .sk-circle .sk-circle8:before {
    -webkit-animation-delay: -0.5s;
            animation-delay: -0.5s; }
  .sk-circle .sk-circle9:before {
    -webkit-animation-delay: -0.4s;
            animation-delay: -0.4s; }
  .sk-circle .sk-circle10:before {
    -webkit-animation-delay: -0.3s;
            animation-delay: -0.3s; }
  .sk-circle .sk-circle11:before {
    -webkit-animation-delay: -0.2s;
            animation-delay: -0.2s; }
  .sk-circle .sk-circle12:before {
    -webkit-animation-delay: -0.1s;
            animation-delay: -0.1s; }

@-webkit-keyframes sk-circleBounceDelay {
  0%, 80%, 100% {
    -webkit-transform: scale(0);
            transform: scale(0); }
  40% {
    -webkit-transform: scale(1);
            transform: scale(1); } }

@keyframes sk-circleBounceDelay {
  0%, 80%, 100% {
    -webkit-transform: scale(0);
            transform: scale(0); }
  40% {
    -webkit-transform: scale(1);
            transform: scale(1); } }
</style>

<script src="../nkang/js_athena/jquery.circliful.min.js"></script>
<script src="../nkang/assets_athena/bootstrap/js/bootstrap.js"></script>
<script	src="../MetroStyleFiles/sweetalert.min.js"></script>
<script type="text/javascript" src="../MetroStyleFiles//JS/openmes.min.js"></script>
<script src="../Jsp/JS/modernizr.js"></script>
<script src="../Jsp/JS/jSignature.min.noconflict.js"></script>
<script type="text/javascript" src="../nkang/autocomplete/jquery-ui.js"></script>

<script>
var LastToLikeDate="",lastLikeTo="";
var HpLogoSrc="",copyRight="",clientThemeColor="";
var RoleList=[];
var RoleObj=new Object();
getLogo();
var selectedType="<option value='communication'>常规沟通</option>";

    $(function(){  
        $(window).scroll(function(){  
            if($(window).scrollTop()>200){  
                $('#return-top').fadeIn(200);  
                }  
                else{$('#return-top').fadeOut(200);}  
              
            });  
            $('#return-top').click(function(){  
                $('body,html').animate({scrollTop:0},200);  
                	return false;  
                });
        });
$(window).load(function() {

	$('head').append("<style>.naviArrow.is-selected::after{content: ''; display: block;width: 0;height: 0;border-left: .9em solid transparent;border-right: .9em solid transparent;border-top: .9em solid "+clientThemeColor+";position: relative;top: 0px;left: 50%;-webkit-transform: translateX(-50%); -ms-transform: translateX(-50%);transform: translateX(-50%);}</style>");
	$("#navSupport").on("click",function(){
		$("a").remove(".naviArrow");
		$(this).append("<a class='naviArrow is-selected'></a>").css("border-top","10px solid "+clientThemeColor);
		$(".naviArrow.is-selected::after").css("border-top",".9em solid "+clientThemeColor);
		$("#navApp").css("border-top","10px solid #B4B8BB");
		$("#navApp a").remove();
		$("#navMember").css("border-top","10px solid #B4B8BB");
		$("#navMember a").remove();
		$("#SocialElements").hide();
		$("#BoardContent").show();
		$("#WorkMates").hide();
	});
	$("#navApp").on("click",function(){
		$("a").remove(".naviArrow");
		$(this).append("<a class='naviArrow is-selected'></a>").css("border-top","10px solid "+clientThemeColor);
		$(".naviArrow.is-selected::after").css("border-top",".9em solid "+clientThemeColor);
		$("#navSupport").css("border-top","10px solid #B4B8BB");
		$("#navSupport a").remove();
		$("#navMember").css("border-top","10px solid #B4B8BB");
		$("#navMember a").remove();
		$("#SocialElements").show();
		$("#BoardContent").hide();
		$("#WorkMates").hide();
	});
	$("#navMember").on("click",function(){
		$("a").remove(".naviArrow");
		$(this).append("<a class='naviArrow is-selected'></a>").css("border-top","10px solid "+clientThemeColor);
		$("naviArrow is-selected::after").css("border-top",".9em solid "+clientThemeColor);
		$("#navSupport").css("border-top","10px solid #B4B8BB");
		$("#navSupport a").remove();
		$("#navApp").css("border-top","10px solid #B4B8BB");
		$("#navApp a").remove();
		$("#SocialElements").hide();
		$("#BoardContent").hide();
		$("#WorkMates").show();
	});
		$('input#search:focus').css('background-color',clientThemeColor);
		checkReg();
		getCompanyInfo();
		getRealName();
		getAllRegisterUsers();
		getRole();
		isRegister();
});
function getRole(){
	$.ajax({
		 url:'../roleOfAreaMap/findList',
		 type:"GET",
		 success:function(resData){
			 if(resData){
				 var m=0;
				 for(var i=0;i<resData.length;i++){
					 selectedType=selectedType+"<option value='"+resData[i].id+"'>"+resData[i].name+"</option>";
					 if(resData[i].flag=="Role")
					 {
						  RoleObj[resData[i].id]=resData[i].name;
  						  RoleList[m++]=resData[i];
					 }
				 }
			 }
			 getMDLUserLists();
		 }
	});
}
function getLogo(){
	jQuery.ajax({
		type : "GET",
		url : "../QueryClientMeta",
		data : {},
		cache : false,
		success : function(data) {
			var jsons = eval(data);
			HpLogoSrc=jsons.clientLogo;
			copyRight=jsons.clientCopyRight;
			clientThemeColor=jsons.clientThemeColor;
			skim(jsons.skimNum);
			$(document).attr("title",jsons.clientStockCode+" - "+$(document).attr("title"));//修改title值  
			$('img.HpLogo').attr('src',HpLogoSrc);
			$('span.clientCopyRight').text('©'+copyRight);
			$('span.clientSubName').text(jsons.clientSubName);
			$('h1.clientName').text(jsons.clientName);
			$('.clientTheme').css('background-color',clientThemeColor);
			$('.clientThemefont').css('color',clientThemeColor);
			$('ul#myTabs').css('border-color',clientThemeColor);
			$('ul#myTabs li a').css('border-right-color',clientThemeColor);
			$('ul#myTabs li a').css('border-top-color',clientThemeColor);
			$('ul#myTabs li a').css('border-left-color',clientThemeColor);
			$("#navApp").css("border-top","10px solid "+clientThemeColor);
			if(jsons.slide!=null){
				$("#bgstylec a img").attr("src",jsons.slide[0]);
				$("#bgstylea a img").attr("src",jsons.slide[1]);
				$("#bgstyleb a img").attr("src",jsons.slide[2]);
			}
		}
	});
}

function skim(jsons){
	var table="";
	var skimTotalNum=0,nowSkimTotalNum=0;
	if(jsons!=null&&jsons!='null'){
		table+="<tr><th>日期</th><th>访问量</th></tr>";
		for (var i = 0; i < jsons.length; i++) {
			var tr="<tr>";
			tr+="	<td width='50%' align='center'>"+jsons[i].date+"</td>";
			tr+="	<td width='50%' align='center'>"+jsons[i].num+"</td>";
			tr+="</tr>";
			table+=tr;
			skimTotalNum+=jsons[i].num;
		}
		nowSkimTotalNum=jsons[jsons.length-1].num;
	}
//	$("#skimHis").html(table);
	$("#skimTotalNum").html(skimTotalNum);
	$("#nowSkimTotalNum").html("今日访问量:"+nowSkimTotalNum);
}
function noAuth(){

		swal("您没有权限哦", "请联系管理员获取权限", "error");

}
function checkReg() {
	jQuery.ajax({
		type : "GET",
		url : "../userProfile/getMDLUserLists",
		data : {
			UID : $('#uid').val()
		},
		cache : false,
		success : function(users) {
			if (users.length > 0) {
				if(users[0].phone==null){
					swal("您还未注册哦", "未注册用户很多功能不能使用,建议点击头像立即注册！", "error");
				}
			}
		}
	});
}
function uploadPic(obj){
		if($(obj).val()!='') {
			  $("#submit_form").ajaxSubmit(function(message) {
				  console.log(message);
				  $("#hiddenPic").val(message);
				  $("#picName").text(message);
			  } );

		}
		return false;
}
function uploadGiftPic(obj){
	if($(obj).val()!='') {
		  $("#submit_gift").ajaxSubmit(function(message) {
			  console.log(message);
			  $("#hiddenGift").val(message);
			  $("#picName").text(message);
		  } );

	}
	return false;
}

function toLike(likeToName,ToOpenId){
	if(ToOpenId==$('#uid').val()){
		swal("不能给自己点赞哦!", "可别太自恋啦。。。", "error"); 
	}else if(LastToLikeDate!=""&&getNowFormatDate().indexOf(LastToLikeDate.substring(0,10))==0){
		swal("你今天已经给"+lastLikeTo+"点赞了!", "可不能太花心哦!", "error");
	}else{
		$.ajax({  
	        cache : false,  
	        url:"../userProfile/updateUserWithLike",
	        type: 'GET', 
	        contentType:'application/x-www-form-urlencoded; charset=UTF-8',
			data : {
				openid : $('#uid').val(),
				likeToName : likeToName,
				ToOpenId : ToOpenId
			},
	        timeout: 2000, 
	        success: function(data,textStatus){
	        	if(textStatus=='success'){
	        		swal("太好了！", "今天你成功给"+likeToName+"点赞了", "success"); 
	        		$("span.like").text(parseInt($("span.like").text())+1);
	        		getMDLUserLists();
	        	}else{
	        		swal("服务器繁忙！", "", "error"); 
	        	}
	        }
	  	});
	}
}

function getCompanyInfo(){
	$.ajax({
		type : "post",
		url : "../userProfile/getCompanyInfo",
		cache : false,
		success : function(data) {
		
		}
	});
}
function getRecognitionInfoByOpenID(){
	var uid=$("#uid").val();
	$.ajax({
		type : "post",
		url : "../userProfile/getRecognitionInfoByOpenID",
		data:{
			openID:uid
		},
		cache : false,
		success : function(data) {
		if(data)
			{
			var text="";
			for(var i=0;i<data.length;i++)
				{
				text=text+"<div class='rs' onclick='showRecognitionDetail(\""+data[i].from+"\",\""+data[i].to+"\",\""+data[i].point+"\",\""
				+data[i].type+"\",\""+data[i].comments+"\")'><p class='rfrom'>From:"+data[i].from+"</p><p class='rtype'>"+data[i].type
				+"</p><p class='rcomment'>"+data[i].comments+"</p><p class='rdate'>"+data[i].congratulateDate+"</p></div>";
				}
			$("#myRecognitionList").html(text);
			}
		}
	});
}
function getAllRegisterUsers(){
	$.ajax({
		type : "post",
		url : "../userProfile/getAllRegisterUsers",
		cache : false,
		success : function(data) {
			var text="";
		for(var i=0;i<data.length;i++)
			{
			text=text+"<option>"+data[i]+"</option>";
			}
		$("#hiddenSelect").html(text);
		}
	});
}
function getRealName(){
	var uid=$("#uid").val();
	$.ajax({
		type : "post",
		url : "../userProfile/getRealName",
		data:{
			openID:uid
		},
		cache : false,
		success : function(data) {
			if(data){
		$("#realName").val(data.toString());
		$("#username").text(data.toString());}
			else
				{$("#realName").val("");
				
				}
		}
	});
}
function showRecognitionDetail(from,to,point,type,coments)
{
	var text=coments.toString();
	$("body").append("<div id='recognitionCenter' style='width:100%;height:100%;'> <div style='height:90px;font-family: HP Simplified, Arial, Sans-Serif;border-bottom:5px solid #56B39D'><img style='position:absolute;top:20px;left:35px;' src='"+HpLogoSrc+"' alt='Logo' class='HpLogo'></div>"
			+"<div style='position:absolute;top:140px;width:80%;left:10%;font-size:16px;'>"
			+"<p style='float:left;width:110px;'>认可</p><p id='to' style='float:left;'>"+to+"</p><p style='float:left;'>!</p></div>"
			+"<div style='position:absolute;top:180px;width:80%;left:10%;height:auto;font-size:14px;font-family: HP Simplified, Arial, Sans-Serif;'>"
			+"<p style='line-height:22px;'>You must have done something amazing! "+from+" has recognized you in the Manager-to-Employee FY16 program for M2E: "+type+". <p>"
			+"<p style='width:100%;line-height:22px;font-size:16px;margin:15px 0px;'>Your award</p>"
			+"<p style='line-height:22px;'>"+point+" Points have been added to your <a href='https://login.ext.hpe.com/idp/startSSO.ping?PartnerSpId=hpe_biw_sp'>MyRecognition@hpe</a> account. Enjoy surfing the catalogue and finding something that is perfect just for you: merchandise, travel, gift cards or vouchers. <p>"
			+"<p style='width:100%;line-height:22px;font-size:16px;margin:15px 0px;'>Here’s what was said about you</p>"
			+"<p style='line-height:22px;'>Thanks <span id='to'>"+to+"</span> for "+text+"</p>"
			+"<img onclick='hideRecognitionCenter()' src='http://leshu.bj.bcebos.com/icon/EXIT1.png' style='width: 30px; height: 30px;position:relative;top:20px;left:250px;'></div></div>");
	$('#recognitionCenter').addClass('bounceInDown animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
	      $(this).removeClass("bounceInDown animated");
	    });
	}
function postRecognition(){
	var imgType="0";
	var img="";
	if($("#hiddenGift").val()!=""){
		img=$("#hiddenGift").val();
	    imgType="1";
	}
	var userImage=$("#userPic").val();
	console.log("img-------"+img);
	console.log("imgType-------"+imgType);
	var to = $("#to option:selected").val();
	swal({  
        title:"是否发送给所有人？",  
        text:"<input type='hidden'>",
        html:"true",
        showConfirmButton:"true", 
		showCancelButton: true,   
		closeOnConfirm: false,  
        confirmButtonText:"是",  
        cancelButtonText:"否",
        animation:"slide-from-top"  
      }, 
		function(inputValue){
			if (inputValue === false){
				$.ajax({
			        cache: false,
			        type: "POST",
			        url:"../userProfile/userCongratulate",
			        data:{
			        	openID:$("#openID").val(),
			        	isAll:"false",
			        	from:$("#from").text(),
			        	points:$("#points").val(),
			        	to:$("#to option:selected").val(),
			        	type:$("#type option:selected").val(),
			        	comments:$("#comments").val(),
			        	img:img,
			        	imgType:imgType,
			        	userImage:userImage
			        	
			        },
			        async: true,
			        error: function(request) {
			            alert("Connection error");
			        },
			        success: function(data) {
			        	swal("恭喜!", "给"+to+"的Recognition已发送成功，他已收到该消息！", "success");
			        	hideBouncePanel();
			        }
			    });
			 return false;}
			else{
				$.ajax({
			        cache: false,
			        type: "POST",
			        url:"../userProfile/userCongratulate",
			        data:{
			        	openID:$("#openID").val(),
			        	isAll:"true",
			        	from:$("#from").text(),
			        	points:$("#points").val(),
			        	to:$("#to option:selected").val(),
			        	type:$("#type option:selected").val(),
			        	comments:$("#comments").val(),
			        	img:img,
			        	imgType:imgType,
			        	userImage:userImage
			        	
			        },
			        async: true,
			        error: function(request) {
			            alert("Connection error");
			        },
			        success: function(data) {
			        	swal("恭喜!", "给"+to+"的Recognition已发送成功，有"+data+"个人已收到该消息！", "success");
			        	hideBouncePanel();
			        }
			    });
			}});



}
function postNotification(){
	var content=$(".froala-element.not-msie.f-basic").children("p").html();
	console.log("content:-----"+content);
 	var img=$(".imgSelect input[type='checkbox']:checked").siblings("img").attr("src");
	var imgType="0";
	var type=$("#notificationType option:selected").val();
	var typeName=$("#notificationType option:selected").text();
	if($("#hiddenPic").val()!=""){
		img=$("#hiddenPic").val();
	    imgType="1";
	}
	 
 	$.ajax({
        cache: false,
        type: "POST",
        url:"../userProfile/addNotification",
        data:{
        	openId:$("#uid").val(),
        	title:$("#notificationTitle").val(),
        	url:$("#notificationURL").val(),
        	type:type,
        	typeName:typeName,
        	img:img,
        	imgType:imgType,
        	content:content
        	
        },
        async: true,
        error: function(request) {
            alert("Connection error");
        },
        success: function(data) {
        	swal("恭喜！", data+"个人已收到您的Notification", "success");
        	hideBouncePanel();
        }
    });

}

function mesSend(){
	showCommonPanel();
	$("body").append("<div id='sendR'>"
			+"	<div class='rcommon' style='height:40px'><p class='bsLabel'>图文标题</p><input id='notificationTitle' style='height:35px;border:1px solid black' type='text' placeholder='请输入标题' class='input-xlarge bsBtn'></div>"
			+"	<div class='rcommon' style='height:40px'><p class='bsLabel'>主题图片</p><form id='submit_form' name='submit_form' action='../userProfile/uploadPicture' enctype='multipart/form-data' method='post'><input id='file-1' type='file' name='file-1'  onchange='uploadPic(this)' class='inputfile inputfile-1' data-multiple-caption='{count} files selected' multiple=''><label for='file-1' style='height: 15px;border-radius: 5px;line-height: 10px;text-align: center;width: 65%;'><svg xmlns='http://www.w3.org/2000/svg' width='20' height='17' viewBox='0 0 20 17'><path d='M10 0l-5.2 4.9h3.3v5.1h3.8v-5.1h3.3l-5.2-4.9zm9.3 11.5l-3.2-2.1h-2l3.4 2.6h-3.5c-.1 0-.2.1-.2.1l-.8 2.3h-6l-.8-2.2c-.1-.1-.1-.2-.2-.2h-3.6l3.4-2.6h-2l-3.2 2.1c-.4.3-.7 1-.6 1.5l.6 3.1c.1.5.7.9 1.2.9h16.3c.6 0 1.1-.4 1.3-.9l.6-3.1c.1-.5-.2-1.2-.7-1.5z'></path></svg> <span id='picName' style='color: white;font-size: 16px;'>Choose a file…</span></label></form><input id='hiddenPic' type='hidden' /></div>"
			+"  <div class='rcommon' style='height:160px;margin-bottom: 8px;'><div class='imgSelect'><input type='checkbox' class='imgCB' checked='true'><img src='https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000E9rG0&oid=00D90000000pkXM'></div><div class='imgSelect'><input type='checkbox' class='imgCB'><img src='https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490602305452&di=14b5b01aade695d780cf3dbf89cd7392&imgtype=0&src=http%3A%2F%2Fimg01.taopic.com%2F160907%2F318765-160ZFQ52837.jpg'></div><div class='imgSelect'><input type='checkbox' class='imgCB'><img src='https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490602293964&di=5b70b7f2c1dbf9aae98dba9143897e2d&imgtype=0&src=http%3A%2F%2Fimg01.taopic.com%2F160816%2F240437-160Q60A3119.jpg'></div><div class='imgSelect'><input type='checkbox' class='imgCB'><img src='https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490602432167&di=7e223d3ad19485014fb9a57c875c00f3&imgtype=0&src=http%3A%2F%2Fwww.taopic.com%2Fuploads%2Fallimg%2F110914%2F34250-11091410324328.jpg'></div><div class='imgSelect'><input type='checkbox' class='imgCB'><img src='https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490602512392&di=173870f13b3a95bfe9b71c9a2ab75b3c&imgtype=0&src=http%3A%2F%2Fwww.yc9y.com%2Fupfiles%2Farticle%2Fimage%2F20160802%2F20160802095320_22922.png'></div><div class='imgSelect'><input type='checkbox' class='imgCB'><img src='https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490602549485&di=af00ddd5cc0391d1616e8b4864502288&imgtype=0&src=http%3A%2F%2Fpic.qjimage.com%2Ftongro_rf004%2Fhigh%2Ftis067a1608.jpg'></div><div class='imgSelect'><input type='checkbox' class='imgCB'><img src='http://leshu.bj.bcebos.com/standard/reservationBigPic.jpg'></div><div class='imgSelect'><input type='checkbox' class='imgCB'><img src='https://ss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/u=428411870,2259267624&fm=23&gp=0.jpg'></div></div>"
			+"  <div id='commonPush' style='margin-top: 10px;'><div class='rcommon'><p class='bsLabel'>图文类型</p><select class='bsBtn' style='border:1px solid black' id='notificationType'>"+selectedType+"</select></div>"
			+"	<div class='rcommon'><p class='bsLabel'>网页链接</p><input id='notificationURL' type='text' style='width:75%;height:35px;border:1px solid black' placeholder='不想输入网络链接？那直接填内容吧'  class='input-xlarge bsBtn'></div>"
			+"	<div class='rcommon'><div id='content' style='height:200px;width:95%;line-height:20px;' placeholder='请输入内容' class='input-xlarge bsBtn'></div></div>"
			+"	<div class='rcommon' ><button style='margin-top:150px;width:95%;background:#20b672;text-shadow:none;color:white!important;' onclick='postNotification()' name='doublebutton-0' class='btn'>提交</button></div></div>"
			+"	</div>"
			+"<div id='footer'><span class='clientCopyRight'><nobr>"+copyRight+"</nobr></span></div>");

    $('#content').editable({inlineMode: false});
    $(".imgSelect input").on("click",function(){
		$(this).parent().siblings().find("input").attr("checked", false);
	});
	$('#sendR').addClass('form-horizontal bounceInDown animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
	      $(this).removeClass("bounceInDown animated");
	    });
}
function recognizationPanel(){
	var realName=$("#realName").val();
	var selectContent=$("#hiddenSelect").html();
	if(realName!="")
		{
		showCommonPanel();
		
		$("body").append("<div class='TAB2class bouncePart' id='recognizeForm'>"
				+"	<ul class='nav nav-tabs' id='myTabs'>"
				+"	<li id='aaElements' class='active'><a href='#aElements' data-toggle='tab'>对Ta点赞</a></li>"
				+"	<li id='bbElements'><a href='#bElements' onclick='getRecognitionInfoByOpenID()' data-toggle='tab'>Ta对我点赞</a></li></ul>"
				+"  <div class='tab-content' id='dvTabContent' style='border: 0px;'>"
				+"	<div class='tab-pane active' id='aElements'>"
				+"	<div id='sendRe' style='height:110%;width:108%;overflow:scroll;'>"
				+"	<div class='rcommon'><p class='bsLabel'>发送人</p><p class='bsBtn' id='from'>"+realName+"</p></div>"
				+"	<div class='rcommon'><p class='bsLabel'>接收人</p><select style='border:1px solid black;' class='bsBtn' id='to'>"+selectContent+"</select></div>"
				+"	<div class='rcommon' style='height:40px'><p class='bsLabel'>礼物图片</p><form id='submit_gift' name='submit_gift' action='../userProfile/uploadPicture' enctype='multipart/form-data' method='post'><input id='file-1' type='file' name='file-1'  onchange='uploadGiftPic(this)' class='inputfile inputfile-1' data-multiple-caption='{count} files selected' multiple=''><label for='file-1' style='height: 15px;border-radius: 5px;line-height: 10px;text-align: center;width: 65%;'><svg xmlns='http://www.w3.org/2000/svg' width='20' height='17' viewBox='0 0 20 17'><path d='M10 0l-5.2 4.9h3.3v5.1h3.8v-5.1h3.3l-5.2-4.9zm9.3 11.5l-3.2-2.1h-2l3.4 2.6h-3.5c-.1 0-.2.1-.2.1l-.8 2.3h-6l-.8-2.2c-.1-.1-.1-.2-.2-.2h-3.6l3.4-2.6h-2l-3.2 2.1c-.4.3-.7 1-.6 1.5l.6 3.1c.1.5.7.9 1.2.9h16.3c.6 0 1.1-.4 1.3-.9l.6-3.1c.1-.5-.2-1.2-.7-1.5z'></path></svg> <span id='picName' style='color: white;font-size: 16px;'>Choose a file…</span></label></form><input id='hiddenGift' type='hidden' /></div>"
				+"	<div class='rcommon'><p class='bsLabel'>类型</p><select class='bsBtn'  style='border:1px solid black;' id='type'><option>Bais For Action</option><option>Innovators at Heart</option><option>Partnership First</option></select></div>"
				+"	<div class='rcommon'><p class='bsLabel'>Points</p><input id='points' type='text' style='height:35px;border:1px solid black;' placeholder='请输入points' class='input-xlarge bsBtn'></div>"
				+"	<div class='rcommon'><textarea id='comments' style='height:130px;width:95%;line-height:20px;border:1px solid black;' placeholder='请输入感言' class='input-xlarge bsBtn'></textarea></div>"
				+"	<div class='rcommon' style='margin-top:100px'><button onclick='postRecognition()' style='height:35px;width:95%;background:#20b672;text-shadow:none;color:white!important;' name='doublebutton-0' class='btn'>提交</button><div style='position: relative;top: -25px;text-align:left;width:30%;' ></div></div>"
				+"	</div>"
				+"	</div>"
				+"  <div class='tab-pane' id='bElements'>"
				+"	<div id='myRecognitionList'>"
				+"  </div>"
				+"		</div>"
				+"	</div>"
				+"</div><div id='footer'><span class='clientCopyRight'><nobr>"+copyRight+"</nobr></span></div>");
		$('#recognizeForm').addClass('form-horizontal bounceInDown animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
		      $(this).removeClass("bounceInDown animated");
		    });
		}else
			{swal("Sorry", "you have no access to this page,please register", "error");}

}
function recognizationPanelByPerson(personName){
	var realName=$("#realName").val();
	var selectContent=$("#hiddenSelect").html();
	if(realName!=""){
		showCommonPanel();
		
		$("body").append("<div class='TAB2class bouncePart' id='recognizeForm'>"
				+"	<ul class='nav nav-tabs' id='myTabs'>"
				+"	<li id='aaElements' class='active'><a href='#aElements' data-toggle='tab'>对Ta点赞</a></li>"
				+"	<li id='bbElements'><a href='#bElements' onclick='getRecognitionInfoByOpenID()' data-toggle='tab'>Ta对我点赞</a></li></ul>"
				+"  <div class='tab-content' id='dvTabContent' style='border: 0px;'>"
				+"	<div class='tab-pane active' id='aElements'>"
				+"	<div id='sendRe' style='height:110%;width:108%;overflow:scroll;'>"
				+"	<div class='rcommon'><p class='bsLabel'>发送人</p><p class='bsBtn' id='from'>"+realName+"</p></div>"
				+"	<div class='rcommon'><p class='bsLabel'>接收人</p><select style='border:1px solid black;' class='bsBtn' id='to'>"+selectContent+"</select></div>"
				+"	<div class='rcommon' style='height:40px'><p class='bsLabel'>礼物图片</p><form id='submit_gift' name='submit_gift' action='../userProfile/uploadPicture' enctype='multipart/form-data' method='post'><input id='file-1' type='file' name='file-1'  onchange='uploadGiftPic(this)' class='inputfile inputfile-1' data-multiple-caption='{count} files selected' multiple=''><label for='file-1' style='height: 15px;border-radius: 5px;line-height: 10px;text-align: center;width: 65%;'><svg xmlns='http://www.w3.org/2000/svg' width='20' height='17' viewBox='0 0 20 17'><path d='M10 0l-5.2 4.9h3.3v5.1h3.8v-5.1h3.3l-5.2-4.9zm9.3 11.5l-3.2-2.1h-2l3.4 2.6h-3.5c-.1 0-.2.1-.2.1l-.8 2.3h-6l-.8-2.2c-.1-.1-.1-.2-.2-.2h-3.6l3.4-2.6h-2l-3.2 2.1c-.4.3-.7 1-.6 1.5l.6 3.1c.1.5.7.9 1.2.9h16.3c.6 0 1.1-.4 1.3-.9l.6-3.1c.1-.5-.2-1.2-.7-1.5z'></path></svg> <span id='picName' style='color: white;font-size: 16px;'>Choose a file…</span></label></form><input id='hiddenGift' type='hidden' /></div>"
				+"	<div class='rcommon'><p class='bsLabel'>类型</p><select class='bsBtn'  style='border:1px solid black;' id='type'><option>Bais For Action</option><option>Innovators at Heart</option><option>Partnership First</option></select></div>"
				+"	<div class='rcommon'><p class='bsLabel'>Points</p><input id='points' type='text' style='height:35px;border:1px solid black;' placeholder='请输入points' class='input-xlarge bsBtn'></div>"
				+"	<div class='rcommon'><textarea id='comments' style='height:130px;width:95%;line-height:20px;border:1px solid black;' placeholder='请输入感言' class='input-xlarge bsBtn'></textarea></div>"
				+"	<div class='rcommon' style='margin-top:100px'><button onclick='postRecognition()' style='height:35px;width:95%;background:#20b672;text-shadow:none;color:white!important;' name='doublebutton-0' class='btn'>提交</button><div style='position: relative;top: -25px;text-align:left;width:30%;' ></div></div>"
				+"	</div>"
				+"	</div>"
				+"  <div class='tab-pane' id='bElements'>"
				+"	<div id='myRecognitionList'>"
				+"  </div>"
				+"		</div>"
				+"	</div>"
				+"</div><div id='footer'><span class='clientCopyRight'><nobr>"+copyRight+"</nobr></span></div>");
		$('#recognizeForm').addClass('form-horizontal bounceInDown animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
		      $(this).removeClass("bounceInDown animated");
		    });}else
			{swal("Sorry", "you have no access to this page,please register", "error");}
	}
function showCommonPanel()
{
	$("body").append("<div  id='data_model_div' style='z-index:999;'  class='dataModelPanel'><i class='icon' style='position:absolute;top:20px;left:20px;z-index:100;'><img class='exit' onclick='hideBouncePanel()' src='http://leshu.bj.bcebos.com/icon/EXIT1.png' style='width: 30px; height: 30px; -webkit-filter: drop-shadow(30px 0 "+clientThemeColor+");' /></i>	<img style='position:absolute;top:8px;right:20px;z-index:100;' class='HpLogo' src='"+HpLogoSrc+"' alt='Logo' class='HpLogo'><div style='width:100%;height: 74px;background: white;position:absolute;border-bottom: 4px solid "+clientThemeColor+";'></div></div>");
	$('#data_model_div').removeClass().addClass('panelShowAnmitation').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
	      $(this).removeClass();
	    }); }
function hideBouncePanel()
{
	$("body").find(".bouncePart").remove();
	$("body").find("#data_model_div").remove();
	$("body").find("#sendR").remove();
	}
function hideRecognitionCenter()
{
	$("body").find("#recognitionCenter").remove();
	}

function isRegister()
{
	$.ajax({
		type : "GET",
		url : "../userProfile/getMDLUserLists",
		data : {
			UID : $('#uid').val()
		},
		cache : false,
		success : function(users) {
			if(users){
				if (users.length > 0) {
					if(users[0].phone ==null){
						 $(".registerArea").show();
					}
					
				}
				}
		}
	});
}
function register() {
	jQuery.ajax({
		type : "GET",
		url : "../userProfile/getMDLUserLists",
		data : {
			UID : $('#uid').val()
		},
		cache : false,
		success : function(users) {
			if (users.length > 0) {
				$("#info_tag tr").html("");
				if(users[0].role!=null){
					$("#info_interact").css("display","none");
					$("#info_interact2").css("display","none");
					$("#info_imgurl").attr("src",$('#userImage').attr('src'));
					$("#info_username span").html(users[0].realName+'<span style="font-size:13px;">&nbsp;&nbsp;&nbsp;&nbsp;['+users[0].role+']&nbsp;</span>'+'<img onclick="showRegister()" src="../MetroStyleFiles/edit.png" style="height: 20px; cursor: pointer;padding-left:5px;"/>');
					$("#info_all").css('display','table');
					$("#info_phone").html("&nbsp;&nbsp;&nbsp;&nbsp;"+users[0].phone);
					$("#info_email").html("&nbsp;&nbsp;&nbsp;&nbsp;"+users[0].email);
					$("#info_selfIntro").text(users[0].selfIntro);
					$('#UserInfo').modal('show');
				}else{
					$("#info_all").css('display','none');
					$("#info_selfIntro").text('');
					showRegister();
				}
			}else{
				$("#info_all").css('display','none');
				$("#info_selfIntro").text('');
				showRegister();
			}
		}
	});
	}
	
function showRegister(){
	$.ajax({
		type : "GET",
		url : "../userProfile/getMDLUserLists",
		data : {
			UID : $('#uid').val()
		},
		cache : false,
		success : function(users) {
			if(users){
				var realName="";
				var phone="";
				var email="";
				var selfIntro="";
				if (users.length > 0) {
					if(users[0].realName !=null){
						realName=users[0].realName;
						 $(".registerArea").show();
					}
					
					if(users[0].phone !=null){
						phone=users[0].phone;
					}
					if(users[0].email !=null){
						email=users[0].email;
					}
					 if(users[0].selfIntro !=null){
							selfIntro=users[0].selfIntro;
					    }
					
				}
				
				$("#realname").val(realName);
				$("#phone").val(phone);
				$("#email").val(email);
				$("#selfIntro").val(selfIntro);
			} 
			}
	});
}
function MathRand() 
{ 
var Num=""; 
for(var i=0;i<6;i++) 
{ 
Num+=Math.floor(Math.random()*10); 
} 
return Num;
} 
var code="";
function sendValidateCode(phone){
	var phone = $("#phone").val();
	 var phoneFilter = /^1[0-9]{10}/;
	if(""==phone||!phoneFilter.test(phone)){
		 swal("发送失败!", "请输入正确的号码信息", "error");
		 return;
	}else{
	code=MathRand();
	$.ajax({
        cache: false,
        type: "POST",
        url:"../sendValidateCode",
        data:{
        	phone:phone,
        	code:code	
        },
        async: true,
        error: function(request) {
            alert("Connection error");
        },
        success: function(data) {
        	if(data=="OK"){
        	swal("恭喜!", "已收到您的请求，请耐心等候", "success");
        	return false;
        	}
        }
    });}
	}
function returnRegisterBack()
{
	$(".registerArea").hide();
	}
	 function updateInfo(){
		 var display =$('#codePanel').css('display');
		var uid = $("#uid").val();
		var name = $("#realname").val();
		var phone = $("#phone").val();
		var email = $("#email").val();
		var validateCode = $("#validateCode").val();
		var selfIntro = $("#selfIntro").val();
		
		 var phoneFilter = /^1[0-9]{10}/;
		 if (name.replace(/(^ *)|( *$)/g,'')==''){
			 swal("注册失败!", "请输入正确的姓名信息！", "error");
		 }else if (!phoneFilter.test(phone)){
			 swal("注册失败!", "请输入正确的电话信息！", "error");
		 }else if(display!="none"){
			 if(validateCode==""||validateCode!=code){
				 swal("注册失败!", "请输入验证码或验证码不正确！", "error");
			 }else
				 {
				 $.ajax({
						url:"../regist",
						data:{uid:uid,name:name,telephone:phone,email:email,selfIntro:selfIntro},
						type:"POST",
						dataType:"json",
						contentType: "application/x-www-form-urlencoded; charset=UTF-8",
						cache:false,
						async:false,
						success:function(result) {
							if(result){
								$('#registerform').modal('hide');
								swal("注册成功!", "恭喜!", "success"); 
								$("#realName").val(name);
								returnRegisterBack();
							} else {
								swal("注册失败", "请输入正确的信息！", "error");
								return false;
							}
						}
					});
				 }
		 }else{
			$.ajax({
				url:"../regist",
				data:{uid:uid,name:name,telephone:phone,email:email,selfIntro:selfIntro},
				type:"POST",
				dataType:"json",
				contentType: "application/x-www-form-urlencoded; charset=UTF-8",
				cache:false,
				async:false,
				success:function(result) {
					if(result){
						$('#registerform').modal('hide');
						swal("注册成功!", "恭喜!", "success"); 
						$("#realName").val(name);
						returnRegisterBack();
					} else {
						swal("注册失败!", "请输入正确的个人信息", "error");
					}
				}
			});
		}
	};
	
function getReminderForMore(){
	swal("Opps!","更多应用正在开发中~","error");
}

function getReminderForNew(){
	swal("Opps!","该功能正在开发中~","error");
}
function getUserInfo(username, headimgurl, openId) {
			$("#info_interact").css("display","block");
			$("#info_interact2").css("display","block");
			$("#info_imgurl").attr("src",headimgurl);
			//$("#info_username span").html(username+'<img src="../MetroStyleFiles/edit.png" style="height: 20px; cursor: pointer;padding-left:5px;"/>');
		jQuery.ajax({
				type : "GET",
				url : "../userProfile/getMDLUserLists",
				data : {
					UID : openId
					
				},
				cache : false,
				success : function(users) {
					if (users.length > 0) {
						$("#info_tag tr").html("");
						$("#info_interact img.like").attr("onclick","toLike('"+username+"','"+users[0].openid+"')");
						$("#info_interact2 span.like").text(users[0].like.number==""?0:users[0].like.number);
						if(users[0].role!=null){
							$("#info_username span").html(users[0].realName);
							$("#info_interact img.zan").attr("onclick","recognizationPanelByPerson('"+users[0].realName+"')");
							$("#info_interact2 span.zan").text(users[0].CongratulateNum);
							$("#info_all").css('display','table');
							$("img.zan").css('display','block');
							$("span.zan").css('display','block');
							var role="";
							try{
							 	role=RoleObj[users[0].role];
							}catch(e){
							}
							$("#info_username span").html(username+'<span style="font-size:13px;">&nbsp;&nbsp;&nbsp;&nbsp;['+role+']</span>');
							$("#info_phone").html("&nbsp;&nbsp;&nbsp;&nbsp;"+users[0].phone);
							//$("#info_group").html("&nbsp;&nbsp;&nbsp;&nbsp;"+users[0].groupid);
							$("#info_email").html("&nbsp;&nbsp;&nbsp;&nbsp;<a style='color:#fff;' href='mailto:"+users[0].email+"'>"+users[0].email+"</a>");
							$("#info_selfIntro").text(users[0].selfIntro);
						}else{
							$("#info_username span").html('未注册');
							$("img.zan").css('display','none');
							$("span.zan").css('display','none');
							$("#info_all").css('display','none');
							$("#info_selfIntro").text('');
						}
						$('#UserInfo').modal('show');
					}
				}
			});
}

function getMDLUserLists() {
	jQuery.ajax({
				type : "GET",
				url : "../userProfile/getMDLUserLists",
				data : {},
				cache : false,
				success : function(users) {
					var ul = "",regNumber=0;
					var RoleNum=new Object(),noRoleNum=0;
					ul='';
					for (var i = 0; i < users.length; i++) {
						var temp = users[i];
						var selfIntro=temp.selfIntro;
						var workDay=temp.workDay;
						var tag=temp.tag;
						var phone=temp.phone;
						var tagHtml="";
						var congratulate="";
						var role;
						try{
						 	role=RoleObj[temp.role];
						 	if(RoleNum[temp.role]==null||RoleNum[temp.role]==undefined){
						 		RoleNum[temp.role]=1;
						 	}else{
						 		RoleNum[temp.role]++;
						 	}
						}catch(e){
							noRoleNum++;
						}
						if(temp.IsRegistered=='false'){
							continue;
						}
						if(temp.isActive=="true"||temp.isActive==true){
							role+='【乐数】';
						}else{
							role+='【看客】';
						}
						if(temp.openid==$('#uid').val()){
							LastToLikeDate=temp.like.lastLikeDate;
							lastLikeTo=temp.like.lastLikeTo;
						}

						
						
						if(selfIntro==null||selfIntro=='null'){
							selfIntro="nothing";
						}else{
							if(selfIntro.length>10){
								selfIntro=(selfIntro.substr(0,12)+'...');
							}
						}
						if(role==null||role=='null'){
							role="";
						}

						if(phone!=null&&phone!='null'&&phone!=''){
							 tagHtml+='													<div class="tag"><a href="tel:'+phone+'" style="color:#fff;">'
									+'TEL:'+phone
									+'													</a></div>';
						 }
						if(temp.congratulateNum==null||temp.congratulateNum=='null'||temp.congratulateNum==undefined||temp.congratulateNum==0){
							temp.congratulateNum=0;
						}
						if(temp.like.number==null||temp.like.number=='null'||temp.like.number==''||temp.like.number==undefined||temp.like.number==0){
							temp.like.number=0;
						}

						if(workDay==null||workDay=='null'||workDay==0){
							workDay="";
						}else{
							regNumber++;
							workDay='<div style="float:right;margin-top:-45px;background-color:#eee;color:#333;font-size:13px;padding:3px;">'+workDay+' Days</div>';
						}
						congratulate='<div style="float:right;">'
							+'&nbsp;&nbsp;'
						+'<img src="../MetroStyleFiles/reward.png" style="height:25px;"/>'
							+ '<span style="font-size:12px;color:#07090B;font-weight:normal;">'+temp.congratulateNum+'</span><div>';
						var lastUpdatedDate="暂无互动";
						if(temp.lastUpdatedDate!=null&&temp.lastUpdatedDate!='null'){
							lastUpdatedDate=temp.lastUpdatedDate.substring(0,10);
						}
						var li='	<li class="Work_Mates_div_list_div2">'
						    +'<span class="openid" style="display:none;">'+temp.openid+'</span><span class="name" style="display:none;">'+temp.nickname+'</span>'
							+'                                           	 	<div class="Work_Mates_img_div2"   style="margin-top:-10px;margin-bottom:-20px;">'
							+'                                        			 <img src="'
							+ temp.headimgurl
							+ '" alt="userImage" class="matesUserImage" alt="no_username"'
							/* +' onclick="getUserInfo(\''
							+ temp.nickname
							+ '\',\''
							+ temp.headimgurl
							+ '\',\''
							+ temp.openid
							+ '\');"' */
							+'/> '
							+'<p style="margin: 0 0 10px;font-size: 12px;text-align: center;color: #375FA7;margin-top: -5px;">'+lastUpdatedDate+'</p>'
							+'                                         		</div>'
							+'                                         		<div class="Work_Mates_text_div">'
							+'                                        			 <h2><span '
							/* +' onclick="getUserInfo(\''
							+ temp.nickname
							+ '\',\''
							+ temp.headimgurl
							+ '\',\''
							+ temp.openid
							+ '\');"' */
							+'>'
							+ temp.nickname
							+ '</span>'
							+'<span class="role">'
							+role+'</span>'
							+congratulate
							+'</h2>'
							+ '<div>'
							+tagHtml
							+'<br/>'
							+'													<span class="selfIntro">'+selfIntro+'</span>'
							+'												</div>'
							+'                                        		</div>'
							+workDay
							+'<div style="float:right;margin-right:5px;font-size: 13px;color: #2F78C3;margin-top:-18px;"><img onclick="toLike(\''+temp.nickname+'\',\''+temp.openid+'\')" style="height:14px;margin-right:5px;" class="like" src="../MetroStyleFiles/like.png"/>'
							+'<span style="font-size:12px;color:#07090B;font-weight:normal">'+temp.like.number+'</span></div>'
							+'                                                <div class="clear"></div>'
							+'                                          </li>';
						ul += li;
					}
				/* 	ul='<div class="Work_Mates_div_list_div2">'
					+'<span class="total_num"><img src="../MetroStyleFiles/role.png"/>总人数：'+ users.length
					+'&nbsp;&nbsp;&nbsp;已注册人数：'+regNumber
					+'</span><div class="clear"></div></div>'+ul; */
					$("#Work_Mates_div").html(ul);
					
					
					var data=[];
					noRoleNum=users.length;
					for(var i=0;i<RoleList.length;i++){
						data[i]=new Object();
						data[i]["value"] = (RoleNum[RoleList[i].id]==undefined?0:RoleNum[RoleList[i].id]) ;
						data[i]["label"]=RoleList[i].name +":"+data[i]["value"]+"人";
						noRoleNum=noRoleNum-data[i]["value"];
					}
					data[RoleList.length]=new Object();
					data[RoleList.length]["value"]=noRoleNum;
					data[RoleList.length]["label"]='未分类:'+noRoleNum+'人';
					
					FusionCharts.ready(function(){
					    var revenueChart = new FusionCharts({
					        type: 'doughnut2d',
					        renderAt: 'chart-container',
					        width: '350',
					        height: '400',
					        dataFormat: 'json',
					        dataSource: {
					            "chart": {
					                "caption": "",
					                "subCaption": "",
					                "numberSuffix": "人",
					                "paletteColors": "#8e0000,#8e7080,#0075c2,#1aaf5d,#f2c500,#f45b00",
					                "bgColor": "#ffffff",
					                "showBorder": "0",
					                "use3DLighting": "0",
					                "showShadow": "0",
					                "enableSmartLabels": "0",
					                "startingAngle": "310",
					                "showLabels": "0",
					                "showPercentValues": "1",
					                "showLegend": "1",
					                "legendShadow": "0",
					                "legendBorderAlpha": "0",
					                "defaultCenterLabel": "共"+users.length+"人",
					                "centerLabel": " $label",
					                "centerLabelBold": "1",
					                "showTooltip": "0",
					                "decimals": "0",
					                "captionFontSize": "14",
					                "subcaptionFontSize": "14",
					                "subcaptionFontBold": "0"
					            },
					            "data": data,
					            "events": { 
					                "beforeLinkedItemOpen": function(eventObj, dataObj) { 
					                    console.log(eventObj);
					                    console.log(dataObj);
					                }
					            }
					        }
					    }).render();
					});
					
				}
			});
}
function getLocation() {
	//$("#locationImg").attr("src","../MetroStyleFiles/setuplocation.png" );
	$("#locationImg").attr("src", "../MetroStyleFiles/loading.gif");
	jQuery.ajax({
		type : "GET",
		url : "../userProfile/getLocation",
		data : {
			uid : $("#uid").val()
		},
		cache : false,
		success : function(data) {
			if (data != "")
				$("#location").text(data);
			$("#locationImg").attr("src",
					"../MetroStyleFiles/setuplocation.png");
		}
	});
}

function getNowFormatDate() {
	var date = new Date();
	var seperator1 = "-";
	var seperator2 = ":";
	var month = date.getMonth() + 1;
	var strDate = date.getDate();
	var hour = date.getHours();
	var minute = date.getMinutes();
	if (month >= 1 && month <= 9) {
		month = "0" + month;
	}
	if (strDate >= 0 && strDate <= 9) {
		strDate = "0" + strDate;
	}
	if (hour >= 0 && hour <= 9) {
		hour = "0" + hour;
	}
	if (minute >= 0 && minute <= 9) {
		minute = "0" + minute;
	}
	var currentdate = date.getFullYear() + seperator1 + month + seperator1
			+ strDate + " " + hour + seperator2 + minute;
	//  + seperator2 + date.getSeconds();
	return currentdate;
}
</script>
</head>
<body style="margin: 0px !important;width:100%  !important; padding: 0px !important;">
  <div class="registerArea">
    <div class="register_title"><i class="fa fa-angle-left fa-lg return" onclick="returnRegisterBack()"></i>会员注册</div>
<div id="fillPanel">
<div class="i-base-form p-form" method="post" action="#" id="jp-form" conf-validate-id="validate1655828073">
<div class="t-flex-wrap">
              <div class="t-flex-item t-with-icon g-phone-wrap" id="jg-input-select-wrap">
                  <input type="text" id="realname" class="text J_pageValidateItem g-input g-country-phone-input jg-phone-input" autocomplete="off" name="mobile"  placeholder="请输入姓名" >
              </div>
              
          </div>
          <div class="t-flex-wrap">
              <div class="t-flex-item t-with-icon g-phone-wrap" id="jg-input-select-wrap">
                  <input type="text" id="phone" class="text J_pageValidateItem g-input g-country-phone-input jg-phone-input" autocomplete="off" name="mobile"  placeholder="请输入手机号" >
              </div>
              
          </div>
          
          <div class="t-flex-wrap">
              <div class="t-flex-item">
                  <input type="text" id="validateCode" name="msgCode" class="text code J_pageValidateItem" placeholder="手机验证码" data-regempty="请输入手机验证码">
              </div>
              <button class="i-base-btn p-get-code-btn"  onclick="sendValidateCode()">获取验证码</button>
              
          </div>
          
          <div class="p-btn-wrap">
              <button class="i-base-btn p-register-btn" onclick="updateInfo()">提交</button>
          </div>
          
      </div>
</div>
  </div>

	<input id="uid" type="hidden" value="<%=uid%>" />
	<input id="timer" type="hidden" value="" />
	<input id="realName" type="hidden" value="" />
	<input id="userPic" type="hidden" value="<%=wcu.getHeadimgurl() %>" />
	<select id="hiddenSelect" style="display:none" data-role="none">
	</select>
	<div class="navbar" style="width: 100%;">
		<div class="navbar-inner">
			<div class="container-fluid">
				<a href="../DQMenu?UID=<%=uid%>" style="float: left;padding-top:10px;"> 
					<img src=""
					alt="Logo" class="HpLogo" style="display:inline !important;height:55px;float:none;padding:0px;vertical-align:bottom;"/>
				</a>
				<div class="clear"></div>
				<ul class="nav pull-right top-menu" style="margin-top:-60px;">
					<li class="dropdown"><a href="#" class="dropdown-toggle"
						data-toggle="dropdown"
						style="font-size: 15px; margin: 0px; padding: 5px 0px;">
							欢迎您： <span class="username colorBlue" id="username">
						</span>
					</a> <span><a style="float: right;"> <img id="userImage"
								src="<%=wcu.getHeadimgurl() %>" alt="userImage"
								class="userImage" alt="no_username" onclick="showRegister()" />
						</a></span></li>
				</ul>
			</div>
		</div>
	</div>

	<!-- BEGIN CONTAINER -->
	<div id="container" class="row-fluid">
		<!-- BEGIN PAGE -->
		<div id="main-content">
			<div class="BDbg">
				<div class="clientTheme  BDheading">
					<div class="span12">
						<div id="divBoardName" style="dispaly: none" title='LBName'></div>
						<h2>
							<nobr>
								<%-- <span class="colorDarkBlue" id="location" style="float: left;padding-left:25px;"><%=curLoc%></span>  --%> 
								<img
									src="../MetroStyleFiles/setuplocation.png"
									onclick="getLocation();" id="locationImg"
									style="height: 21px;padding-top:4px;float:right; cursor: pointer; margin-top: -5px;z-index:10000;" />
							</nobr>
						</h2>
					</div>
				</div>
				 
		
		
				<div class="row-fluid mtop10">
					<div class="span12">
						<div class="PositionR">
						<form id="searchForm" method="get" action="https://www.bing.com/search"  style="padding:0px;" >
									<input type="text" id="search"  name="q" placeholder="Search.." style="margin-top:-64px;"> 
      						    </form>
					<!-- 	<input type="text" id="search" name="search" placeholder="Search.."> -->
								
							   <!-- slides show start -->
							   <div class="slide-main" id="touchMain" style="margin-top:-30px;">

        <a class="prev" style="display:none" href="javascript:;" stat="prev1001"><img src="../MetroStyleFiles/image/l-btn.png" /></a>

        <div class="slide-box" id="slideContent">

            <div class="slide" id="bgstylec">

            	<a stat="sslink-3" href="" target="_blank">

                	<div class="obj-e"><img style="width:100%;height:221px" src="../MetroStyleFiles/image/socialHPE.png" /></div>

            	</a>

            </div>

            <div class="slide" id="bgstylea">

            	<a stat="sslink-1" href="" target="_blank">

                	<div class="obj-e"><img style="width:100%;height:221px" src="../MetroStyleFiles/image/datalakedashboard.jpg" /></div>

            	</a>

            </div>

            <div class="slide" id="bgstyleb">

            	<a stat="sslink-2" href="" target="_blank">

                	<div class="obj-e"><img style="width:100%;height:221px" src="../MetroStyleFiles/image/datalakepure.jpg" /></div>

            	</a>

            </div>

        </div>

        <a class="next" style="display:none"  href="javascript:;" stat="next1002"><img width=100% height=100% src="../MetroStyleFiles/image/r-btn.png" /></a>

        <div class="item">

        	<a class="cur" stat="item1001" href="javascript:;"></a><a href="javascript:;" stat="item1002"></a><a href="javascript:;" stat="item1003"></a>

        </div>

    </div>
    <!-- slides show end -->
						</div>
					</div>
				</div>
				
				
				
				
				 	</div>
			<div class="container-fluid">
				<div class="row-fluid mtop20">
					<div class="span12">
						<div class="TABclass">
							<div class="naviPanel">
						<div id="navApp"  class="navi">
						<a class="naviArrow is-selected" ></a>
						<p class="naviText">微应用</p>
							</div>
							<div id="navSupport"   class="navi"><p class="naviText">微流量</p></div>
								<div id="navMember"  class="navi"><p class="naviText">微学员</p></div>
							</div>
							<div class="tab-content" id="dvTabContent" style="border: 0px;margin-top:-30px;padding-right:0px;padding-left:0.1px;overflow-x:hidden;">
								<div class="tab-pane" id="BoardContent">
									<div>
										<div class="panel-group" id="accordion">
											<div id="DivLearnings"
												style="text-align: center; padding: 0px;">

												<!-- <img src="../MetroStyleFiles/image/Maintenace.gif" /> -->
<svg id="fillgauge5" height="220" style="margin-left:auto;margin-right:auto;width:200px;"><g transform="translate(0,6.5)"><path d="M0,103.5A103.5,103.5 0 1,1 0,-103.5A103.5,103.5 0 1,1 0,103.5M0,87.975A87.975,87.975 0 1,0 0,-87.975A87.975,87.975 0 1,0 0,87.975Z" transform="translate(103.5,103.5)" style="fill: rgb(255, 255, 255);"></path><text class="liquidFillGaugeText" text-anchor="middle" font-size="38.8125px" transform="translate(103.5,73.071)" style="fill: rgb(0, 178, 135);">86%</text><defs><clipPath id="clipWavefillgauge5" transform="translate(-41.400000000000006,37.77336)"><path d="M0,178.227L1.449,178.227L2.898,178.227L4.3469999999999995,178.227L5.796,178.227L7.245,178.227L8.693999999999999,178.227L10.142999999999999,178.227L11.592,178.227L13.041,178.227L14.49,178.227L15.939000000000002,178.227L17.387999999999998,178.227L18.837,178.227L20.285999999999998,178.227L21.735,178.227L23.184,178.227L24.633,178.227L26.082,178.227L27.531,178.227L28.98,178.227L30.429000000000002,178.227L31.878000000000004,178.227L33.327,178.227L34.775999999999996,178.227L36.225,178.227L37.674,178.227L39.123000000000005,178.227L40.571999999999996,178.227L42.021,178.227L43.47,178.227L44.919000000000004,178.227L46.368,178.227L47.817,178.227L49.266,178.227L50.715,178.227L52.164,178.227L53.61300000000001,178.227L55.062,178.227L56.511,178.227L57.96,178.227L59.409,178.227L60.858000000000004,178.227L62.306999999999995,178.227L63.75600000000001,178.227L65.205,178.227L66.654,178.227L68.10300000000001,178.227L69.55199999999999,178.227L71.001,178.227L72.45,178.227L73.899,178.227L75.348,178.227L76.797,178.227L78.24600000000001,178.227L79.69500000000001,178.227L81.14399999999999,178.227L82.593,178.227L84.042,178.227L85.491,178.227L86.94,178.227L88.389,178.227L89.83800000000001,178.227L91.28699999999999,178.227L92.736,178.227L94.185,178.227L95.634,178.227L97.083,178.227L98.532,178.227L99.98100000000001,178.227L101.43,178.227L102.87899999999999,178.227L104.328,178.227L105.777,178.227L107.22600000000001,178.227L108.675,178.227L110.124,178.227L111.57300000000001,178.227L113.022,178.227L114.471,178.227L115.92,178.227L117.369,178.227L118.818,178.227L120.26700000000001,178.227L121.71600000000001,178.227L123.165,178.227L124.61399999999999,178.227L126.06299999999999,178.227L127.51200000000001,178.227L128.961,178.227L130.41,178.227L131.859,178.227L133.308,178.227L134.757,178.227L136.20600000000002,178.227L137.655,178.227L139.10399999999998,178.227L140.553,178.227L142.002,178.227L143.451,178.227L144.9,178.227L146.349,178.227L147.798,178.227L149.247,178.227L150.696,178.227L152.145,178.227L153.594,178.227L155.04299999999998,178.227L156.49200000000002,178.227L157.941,178.227L159.39000000000001,178.227L160.839,178.227L162.28799999999998,178.227L163.73700000000002,178.227L165.186,178.227L166.635,178.227L168.084,178.227L169.533,178.227L170.982,178.227L172.431,178.227L173.88,178.227L175.329,178.227L176.778,178.227L178.227,178.227L179.67600000000002,178.227L181.125,178.227L182.57399999999998,178.227L184.023,178.227L185.472,178.227L186.92100000000002,178.227L188.37,178.227L189.819,178.227L191.268,178.227L192.717,178.227L194.166,178.227L195.615,178.227L197.064,178.227L198.513,178.227L199.96200000000002,178.227L201.411,178.227L202.86,178.227L204.309,178.227L205.75799999999998,178.227L207.20700000000002,178.227L208.656,178.227L210.105,178.227L211.554,178.227L213.003,178.227L214.45200000000003,178.227L215.901,178.227L217.35,178.227L218.799,178.227L220.248,178.227L221.697,178.227L223.14600000000002,178.227L224.595,178.227L226.044,178.227L227.493,178.227L228.942,178.227L230.39100000000002,178.227L231.84,178.227L231.84,-4.347L230.39100000000002,-4.293481216567064L228.942,-4.134242676335035L227.493,-3.8732053606468293L226.044,-3.516796874547896L224.595,-3.0737931778179184L223.14600000000002,-2.555102491715386L221.697,-1.973496702367812L220.248,-1.343296874547895L218.799,-0.6800206195298782L217.35,9.318885071640953e-15L215.901,0.6800206195298814L214.45200000000003,1.3432968745478981L213.003,1.973496702367815L211.554,2.555102491715388L210.105,3.0737931778179206L208.656,3.5167968745478975L207.20700000000002,3.8732053606468306L205.75799999999998,4.1342426763350355L204.309,4.293481216567064L202.86,4.347L201.411,4.293481216567064L199.96200000000002,4.1342426763350355L198.513,3.8732053606468297L197.064,3.516796874547896L195.615,3.073793177817919L194.166,2.5551024917153864L192.717,1.9734967023678125L191.268,1.3432968745478955L189.819,0.6800206195298787L188.37,6.65711525369418e-15L186.92100000000002,-0.6800206195298809L185.472,-1.3432968745478975L184.023,-1.9734967023678145L182.57399999999998,-2.5551024917153877L181.125,-3.07379317781792L179.67600000000002,-3.5167968745478975L178.227,-3.8732053606468306L176.778,-4.1342426763350355L175.329,-4.293481216567064L173.88,-4.347L172.431,-4.293481216567064L170.982,-4.1342426763350355L169.533,-3.8732053606468297L168.084,-3.5167968745478966L166.635,-3.0737931778179193L165.186,-2.555102491715387L163.73700000000002,-1.973496702367813L162.28799999999998,-1.343296874547896L160.839,-0.6800206195298794L159.39000000000001,8.254177144462244e-15L157.941,0.6800206195298804L156.49200000000002,1.343296874547897L155.04299999999998,1.973496702367814L153.594,2.5551024917153877L152.145,3.07379317781792L150.696,3.516796874547897L149.247,3.87320536064683L147.798,4.1342426763350355L146.349,4.293481216567065L144.9,4.347L143.451,4.293481216567065L142.002,4.1342426763350355L140.553,3.8732053606468337L139.10399999999998,3.516796874547897L137.655,3.0737931778179197L136.20600000000002,2.555102491715381L134.757,1.9734967023678136L133.308,1.3432968745478893L131.859,0.6800206195298798L130.41,0L128.961,-0.6800206195298798L127.51200000000001,-1.3432968745478893L126.06299999999999,-1.9734967023678136L124.61399999999999,-2.555102491715381L123.165,-3.0737931778179197L121.71600000000001,-3.516796874547897L120.26700000000001,-3.8732053606468337L118.818,-4.1342426763350355L117.369,-4.293481216567065L115.92,-4.347L114.471,-4.293481216567065L113.022,-4.134242676335033L111.57300000000001,-3.8732053606468373L110.124,-3.516796874547897L108.675,-3.07379317781792L107.22600000000001,-2.5551024917153815L105.777,-1.973496702367807L104.328,-1.343296874547897L102.87899999999999,-0.6800206195298804L101.43,-5.323539635893545e-16L99.98100000000001,0.6800206195298794L98.532,1.343296874547896L97.083,1.973496702367806L95.634,2.5551024917153806L94.185,3.0737931778179193L92.736,3.5167968745478966L91.28699999999999,3.8732053606468373L89.83800000000001,4.134242676335033L88.389,4.293481216567065L86.94,4.347L85.491,4.293481216567065L84.042,4.134242676335033L82.593,3.8732053606468377L81.14399999999999,3.5167968745478975L79.69500000000001,3.07379317781792L78.24600000000001,2.555102491715382L76.797,1.9734967023678074L75.348,1.3432968745478975L73.899,0.6800206195298809L72.45,1.064707927178709e-15L71.001,-0.6800206195298787L69.55199999999999,-1.3432968745478955L68.10300000000001,-1.9734967023678092L66.654,-2.555102491715383L65.205,-3.0737931778179215L63.75600000000001,-3.516796874547894L62.306999999999995,-3.873205360646835L60.858000000000004,-4.134242676335033L59.409,-4.293481216567065L57.96,-4.347L56.511,-4.293481216567065L55.062,-4.134242676335033L53.61300000000001,-3.873205360646834L52.164,-3.5167968745478975L50.715,-3.073793177817926L49.266,-2.555102491715382L47.817,-1.973496702367808L46.368,-1.3432968745478981L44.919000000000004,-0.680020619529889L43.47,-1.5970618907680634e-15L42.021,0.6800206195298858L40.571999999999996,1.343296874547895L39.123000000000005,1.9734967023678052L37.674,2.5551024917153797L36.225,3.073793177817924L34.775999999999996,3.516796874547896L33.327,3.8732053606468364L31.878000000000004,4.134242676335032L30.429000000000002,4.293481216567065L28.98,4.347L27.531,4.293481216567065L26.082,4.134242676335034L24.633,3.8732053606468346L23.184,3.516796874547898L21.735,3.0737931778179264L20.285999999999998,2.5551024917153824L18.837,1.9734967023678085L17.387999999999998,1.3432968745478986L15.939000000000002,0.6800206195298896L14.49,2.129415854357418e-15L13.041,-0.6800206195298854L11.592,-1.3432968745478946L10.142999999999999,-1.9734967023678045L8.693999999999999,-2.555102491715379L7.245,-3.0737931778179237L5.796,-3.5167968745478952L4.3469999999999995,-3.873205360646833L2.898,-4.134242676335032L1.449,-4.293481216567065L0,-4.347Z" t="0.679" transform="translate(39.354839378356935,0)"></path></clipPath></defs><g clip-path="url(#clipWavefillgauge5)"><circle cx="103.5" cy="103.5" r="86.94" style="fill: rgb(32, 182, 114);"></circle><text class="liquidFillGaugeText" text-anchor="middle" font-size="38.8125px" transform="translate(100.5,112.071)" style="fill: rgb(252, 252, 252);" id="skimTotalNum"></text><text class="liquidFillGaugeText" text-anchor="middle" font-size="13px" transform="translate(100.5,135.071)" style="fill: rgb(252, 252, 252);" id="nowSkimTotalNum">今日访问量：</text></g></g></svg>
										
											</div>
										</div>
									</div>
								</div>
								<div class="tab-pane active" id="SocialElements">
									<!-- start -->
									<div id="WeatherDetails"  style="z-index: 10000;" class="modal hide fade" tabindex="-1"
										role="dialog" aria-labelledby="myModalLabel1"
										aria-hidden="true" data-backdrop="static">
										<div class="modal-header" style="text-align: center;">
											<img src="../MetroStyleFiles/index.png" style="height: 55px;" />
											<img src="../MetroStyleFiles/Close.png" data-dismiss="modal"
												aria-hidden="true"
												style="float: right; height: 25px; cursor: pointer;" />
										</div>
										<div class="modal-body readmoreHpop"
											style="white-space: pre-line; padding: 0px;">
											<table width="95%" align="center" id="weather_suggest"
												style="margin-top: -15px;">
											</table>
										</div>
										<!-- 
										<div class="modal-footer">
											<button class="btnAthena" data-dismiss="modal"
												aria-hidden="true">Cancel</button>
										</div>
										 -->
									</div>

									<div id="weather_div">
										<table class="Socialization_menu">
											<tr>
												<td>
													<a target="_self" href="https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=Constants.APP_ID%>&redirect_uri=http%3A%2F%2F<%=Constants.baehost%>%2Fmdm%2FDailyNews.jsp?UID=<%=uid %>&response_type=code&scope=snsapi_userinfo&state=<%=uid %>#wechat_redirect">
														<img src="http://leshu.bj.bcebos.com/icon/Notification.png" /><h4>乐数快讯</h4>
													</a>
												</td>
												<td>
												<a target="_self" <%if(IsAuthenticated==true) { %> href="http://leshucq.bceapp.com/mdm/DataVisualization.jsp?UID=<%=uid %>"  <%}else{ %>onclick="noAuth()"<%} %>
												><img src="http://leshu.bj.bcebos.com/icon/menu-stock.png" />
													<h4>乐数足迹</h4></a>
												</td>
												<td><img  <%if(IsAuthenticated==true) { %> onclick="mesSend()" <%}else{ %>onclick="noAuth()"<%} %> src="http://leshu.bj.bcebos.com/icon/menu-technology.png" />
													<h4>消息推送</h4></td>
													
												<td>		<img    <%if(IsAuthenticated==true) { %> onclick="recognizationPanel()" <%}else{ %>onclick="noAuth()"<%} %>
														src="http://leshu.bj.bcebos.com/icon/menu-recognition.png" />
														<h4>奖项管理</h4>
												</td>
											</tr>
											<tr>
												<%if(level!=null&&level.equals("basic")) { %>
												<td>
												 <a target="_self" href="https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=Constants.APP_ID%>&redirect_uri=http%3A%2F%2F<%=Constants.baehost%>%2Fmdm%2FNavigatorForBasic.jsp?UID=<%=uid %>&response_type=code&scope=snsapi_userinfo&state=<%=uid %>#wechat_redirect">
												 <img src="http://leshucq.bj.bcebos.com/standard/leshuTeacher.png" /></a>
													<h4>迷时师渡</h4>
												<%}else{ %>
												<td>
												<a target="_self" href="https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=Constants.APP_ID%>&redirect_uri=http%3A%2F%2F<%=Constants.baehost%>%2Fmdm%2FNavigator.jsp?UID=<%=uid %>&response_type=code&scope=snsapi_userinfo&state=<%=uid %>#wechat_redirect">
												 <img src="http://ww1.prweb.com/prfiles/2013/10/31/11293784/gI_134943_Icon%201024%20cropped.png" /></a>
													<h4>悟时自渡</h4> </td> 
												<% } %> 
													
													<%if(isTeacher==true) { %>
												<td>
												<a target="_self"  href="http://leshucq.bceapp.com/mdm/HomeWork.jsp?UID=<%=uid %>">
												<img src="http://leshucq.bj.bcebos.com/standard/techerview.png" />
													<h4>我的学员</h4></a>
												</td><% } %>
												
												<td>
													<a target="_self" onclick="getReminderForNew()">
														<img src="http://leshucq.bj.bcebos.com/standard/classunit2.png" /><h4>我的课时</h4>
													</a>
												</td>
											</tr>
										</table>
									</div>
								</div>

								<div id="UserInfo" class="modal hide fade" tabindex="-1"
									role="dialog" aria-labelledby="myModalLabel1"
									aria-hidden="true" data-backdrop="static">
									<div class="modal-body readmoreHpop"
										style="white-space: pre-line; padding: 0px;">
										<img src="../MetroStyleFiles/Close2.png" data-dismiss="modal"
											aria-hidden="true"
											style="float: right; height: 27px; cursor: pointer; margin-top: -15px; margin-right: 5px;" />
										<div id="userInfoDiv">
											<div id="info_interact"  style="position: absolute;width:100%;">
												<img class="like" src="../MetroStyleFiles/like.png"/>
												<img class="zan"  data-dismiss="modal" aria-hidden="true" onclick="recognizationPanel()" src="../MetroStyleFiles/zan.png"/>
											</div>
											<div id="info_interact2"
												style="position: absolute; width: 100%; display: block; margin-top: 45px;">
												<span class="like"
													style="float: left; margin-left: 25px; width: 40px; text-align: center;"></span>
												<span class="zan"
													style="float: right; margin-right: 30px; margin-top: -20px; width: 40px; text-align: center;"></span>
											</div>
											<img id="info_imgurl"
												src="http://wx.qlogo.cn/mmopen/soSX1MtHexV6ibXOvfzOoeEwjLFW3dyR80Mic1pzmg5b1qV0EFD4aegic9hic5iawRIDgJIImrY0XybC57j16ka4SabDCqy3TTtd2/0"
												alt="userImage" class="matesUserImage2" style="position: relative;">
											<div id="info_username" style="margin-top:-20px;">
												<span></span>
											</div>
											<table id="info_all">
												<!-- <tr>
													<td><img src="../MetroStyleFiles/group2.png"/></td>
													<td><div id="info_group"></div></td>
												</tr> -->
												<tr>
													<td><img src="../MetroStyleFiles/telephone2.png"/></td>
													<td><div id="info_phone"></div></td>
												</tr>
												<tr>
													<td><img src="../MetroStyleFiles/email2.png"/></td>
													<td><div id="info_email"></div></td>
												</tr>
											</table>
											<div id="info_selfIntro" style="margin-top:-10px;width:100%;text-align:center;"></div>
											<div style="width:100%; padding:0px;margin-top:-35px;margin-bottom:-40px;overflow-x: auto;">
												<table id="info_tag" style="margin-left:auto;margin-right:auto;">
													<tr>
													</tr>
												</table>											
											</div>
										</div>
									</div>
								</div>
								<div class="tab-pane" id="WorkMates">
								
								<div id="chart-container" style="margin-left:auto;margin-right:auto;text-align:center;"></div>
					
									<ul class="Work_Mates_div2" id="Work_Mates_div"  data-role="listview" data-autodividers="false" data-filter="true" data-filter-placeholder="输入关键字" data-inset="true" style="margin-top:15px">
									</ul>
<div id="return-top"><img class="scroll-top" src="http://leshu.bj.bcebos.com/icon/upgrade.png" alt="" width="50px"></div>  
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- END PAGE -->
	</div>

	<!-- Modal PAGE Start-->
	<div id="DivMyAlter" class="modal hide fade" tabindex="-1"
		role="dialog" aria-labelledby="myModalLabel1" aria-hidden="true">
		<div class="modal-header">
			<h3>Error Message</h3>
		</div>
		<div class="modal-body">
			<div class="span5 ml0" id="myAlterMessage"></div>
		</div>
		<div class="modal-footer">
			<button class="btnAthena EbtnLess" data-dismiss="modal"
				aria-hidden="true">OK</button>
		</div>
	</div>
		
		<!-- START MESSAGE STATION -->
	<div id="mes-station">		
</div>
<!-- END MESSAGE STATION -->

	<!-- BEGIN FOOTER -->
	<div id="footer">
		<span class="clientCopyRight"><nobr></nobr></span>
	</div>
	<!-- END FOOTER -->
		
</body>
</html>