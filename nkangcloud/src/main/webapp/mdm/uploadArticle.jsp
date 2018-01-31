﻿<%@ page language="java" pageEncoding="UTF-8"%>
<%
String uid = request.getParameter("UID");
%>
<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en">
<head>
<meta charset="utf-8" />
<title>上传图文</title>
<!-- <meta name="viewport" content="width=device-width,height=device-height,initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no">
	 -->

<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<meta content="" name="description" />
<meta content="" name="hpe" />



<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/bootstrap/css/bootstrap-responsive.min.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/font-awesome/css/font-awesome.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/profile.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/icomoon/iconMoon.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style-responsive.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/font-awesome.css">
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style-default.css"/>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css"/>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/CSS/sonhlab-base.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/animate.min.css">
<script type="text/javascript" src="../nkang/easyui/jquery.min.js"></script>
<script type="text/javascript">var $113 = $;</script>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles//CSS/animation-effects.css"/>
<link rel="stylesheet" type="text/css" href="../Jsp/CSS/common.css">
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/bootstrap/css/bootstrap.min.css"/>
		<link rel="stylesheet" type="text/css" href="../mdm/uploadfile_css/demo.css" />
		<link rel="stylesheet" type="text/css" href="../mdm/uploadfile_css/component.css" />
<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
<script type="text/javascript" src="../nkang/jquery-form.js"></script>

<!--[if IE]>
		<script src="http://libs.useso.com/js/html5shiv/3.7/html5shiv.min.js"></script>
	<![endif]-->
	<!-- remove this if you use Modernizr -->
		<script>(function(e,t,n){var r=e.querySelectorAll("html")[0];r.className=r.className.replace(/(^|\s)no-js(\s|$)/,"$1js$2")})(document,window,0);</script>

<!-- <link rel="stylesheet" href="../Jsp/CSS/w3.css"> -->
<style>
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
    top: 0; }
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

<script>
$(document).ajaxStart(function () {
	$(".sk-circle").show();
	$("#shadow").show();
    }).ajaxStop(function () {
    	$(".sk-circle").hide();
    	$("#shadow").hide();
    });
  
$(function(){ 
      
    });
function uploadNews(){
	var title=$("#title").val();
	var url=$("#url").val();
	var content=$("#content").val();
	var mediaID=$("#hiddenMediaID").val();
	var articleID="";
	$.ajax({
        cache: false,
        type: "POST",
        url:"../fileUpload/uploadNews",
        data:{
        	title:title,
        	url:url,
        	content:content,
        	mediaID:mediaID
        },
        async: true,
        error: function(request) {
            alert("Connection error");
        },
        success: function(data) {
        	if(data){
        		$.ajax({
        	        cache: false,
        	        type: "POST",
        	        url:"../fileUpload/sendMass",
        	        data:{
        	        	articleID:data
        	        },
        	        async: true,
        	        error: function(request) {
        	            alert("Connection error");
        	        },
        	        success: function(newData) {
        	        	swal("恭喜！", newData+"个人已收到您的通知", "success");
        	        }
        	    });
        	}
        }
    });

}
function uploadPic(obj){
		if($(obj).val()!='') {
			  $("#submit_form").ajaxSubmit(function(message) {
				  console.log(message);
				  $("#hiddenMediaID").val(message);
			  } );

		}
		return false;
}
</script>
</head>
<body style="margin: 0px !important;width:100%  !important; padding: 0px !important;">
  
<div id="shadow" style="display:none;width:100%;height:100%;position:absolute;z-index:99999;top:0px;left:0px;opacity:0.4;background:#20b672;"></div>
 <div class="sk-circle">
      <div class="sk-circle1 sk-child"></div>
      <div class="sk-circle2 sk-child"></div>
      <div class="sk-circle3 sk-child"></div>
      <div class="sk-circle4 sk-child"></div>
      <div class="sk-circle5 sk-child"></div>
      <div class="sk-circle6 sk-child"></div>
      <div class="sk-circle7 sk-child"></div>
      <div class="sk-circle8 sk-child"></div>
      <div class="sk-circle9 sk-child"></div>
      <div class="sk-circle10 sk-child"></div>
      <div class="sk-circle11 sk-child"></div>
      <div class="sk-circle12 sk-child"></div>
    </div>
<div id="data_model_div" style="z-index:999;" class=""><a href="http://leshucq.bceapp.com/mdm/profile.jsp?UID=<%=uid%>"><i class="icon" style="position:absolute;top:20px;left:20px;z-index:100;"><img class="exit" src="http://leshu.bj.bcebos.com/icon/EXIT1.png" style="width: 30px; height: 30px; "></i></a>	<img style="position:absolute;top:8px;right:20px;z-index:100;" class="HpLogo" src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" alt="Logo"><div style="width:100%;height: 74px;background: white;position:absolute;border-bottom: 4px solid #20b672;"></div></div>
<div id='sendR'>
<div class='rcommon' style='height:45px'>
<p class='bsLabel'>图文标题</p>
<input id='title' style='height:35px;border:1px solid black;padding-left:10px;' type='text' placeholder='请输入标题' class='input-xlarge bsBtn' />
</div>
<div class='rcommon' style='height:45px'>
<p class='bsLabel'>主题图片</p>
<form id='submit_form' name='submit_form' action='../fileUpload/uploadImg' enctype='multipart/form-data' method='post'><input id='file-1' type='file' name='file-1'  onchange='uploadPic(this)' class='inputfile inputfile-1' data-multiple-caption='{count} files selected' multiple=''>
<label for='file-1' style='height: 15px;border-radius: 5px;line-height: 10px;text-align: center;width: 64%;'><svg xmlns='http://www.w3.org/2000/svg' width='20' height='17' viewBox='0 0 20 17'><path d='M10 0l-5.2 4.9h3.3v5.1h3.8v-5.1h3.3l-5.2-4.9zm9.3 11.5l-3.2-2.1h-2l3.4 2.6h-3.5c-.1 0-.2.1-.2.1l-.8 2.3h-6l-.8-2.2c-.1-.1-.1-.2-.2-.2h-3.6l3.4-2.6h-2l-3.2 2.1c-.4.3-.7 1-.6 1.5l.6 3.1c.1.5.7.9 1.2.9h16.3c.6 0 1.1-.4 1.3-.9l.6-3.1c.1-.5-.2-1.2-.7-1.5z'></path></svg> <span id='picName' style='color: white;font-size: 16px;'>Choose a file…</span></label></form>
<input id='hiddenMediaID' type='hidden' />
</div> 
<div class="rcommon" style="height:45px">
<p class="bsLabel">链接地址</p>
<input id="url" style="height:35px;border:1px solid black;padding-left:10px;" type="text" placeholder="请输入链接地址" class="input-xlarge bsBtn">
</div>
<div class="rcommon"><textarea id="content" style="height:180px;width:95%;line-height:20px;border:1px solid black" placeholder="请输入内容" class="input-xlarge bsBtn"></textarea></div>
<div class='rcommon' >
<button style='margin-top:20px;width:95%;background:#20b672;text-shadow:none;color:white!important;' onclick='uploadNews()' name='doublebutton-0' class='btn'>提交</button>
</div>
</div>
<div id='footer'><span class='clientCopyRight'><nobr></nobr></span></div>
	
		 <script src="../mdm/uploadfile_js/custom-file-input.js"></script>
</body>
</html>