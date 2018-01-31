<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%
String uid = request.getParameter("UID");
MongoDBBasic.updateUser(uid);
%>
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Face Recognition</title>
  <meta name="description" content="Signature Pad - HTML5 canvas based smooth signature drawing using variable width spline interpolation.">
  <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1, user-scalable=no">
  
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/bootstrap/css/bootstrap.min.css"/>
  <link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/profile.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style.css"/>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style-responsive.css"/>
		<link rel="stylesheet" type="text/css" href="../mdm/uploadfile_css/demo.css" />
		<link rel="stylesheet" type="text/css" href="../mdm/uploadfile_css/component.css" />
  <script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
  
<script type="text/javascript" src="../nkang/jquery-form.js"></script>

<script	src="../MetroStyleFiles/sweetalert.min.js"></script>
  
<style>

.DetectedPerson{
	width:100%;
	padding:10px 0px;
	border-bottom:1px dashed #999;
}

.myfacevalue{
	float:left;
	width:52% !important;
	text-align:right;
}
.myfacevalue canvas{
	margin-top:50px;
	float:right;
	width:200px !important;
	height:200px !important;
}
.myfacevalueattribute{
	float:right;
	width:45%;
}
.clear{
	clear:both;
}
table tr td:nth-child(odd) {
	text-align: left;
}
table tr td:nth-child(even) {
	text-align: left;
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

.sk-circle {
  margin: 40px auto;
  width: 40px;
  height: 40px;
      position: absolute;
    top: 50%;
    left: 45%;
    display:none;
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
    background-color: #333;
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

    
    
</head>
<body style="padding:0px;margin:0px;">
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
<a href="profile.jsp?UID=<%=uid%>">
	<i class="icon" style="position:absolute;top:20px;left:20px;"><img class="exit"   src="http://leshucq.bj.bcebos.com/icon/icon_EXIT1.png" style="width: 30px; height: 30px;" /></i>
</a>	
<img style="position:absolute;top:8px;right:20px;" src="" alt="Logo" class="HpLogo">
<div style="width:100%;height:4px;position:absolute;top:70px;" class="clientTheme"></div>
<input id="uid" type="hidden" value="<%=uid %>" />
<!-- <div id="text" style="margin-top:150px;width:80%;margin-left:10%;text-align:center;">
</div> -->
<form id='submit_form' name='submit_form' action='../userProfile/uploadSelfie?openId=<%=uid%> ' enctype='multipart/form-data' method='post'>
		<div style="position:absolute;top:150px;right:28%;">
		
					<input type="file" name="file-5[]" style="display:none;" onchange='uploadPic(this)' id="file-5" class="inputfile inputfile-4" data-multiple-caption="{count} files selected" multiple />
					<label for="file-5" style="text-align:center;"><figure style="background-color:black"><svg style="fill:white;" xmlns="http://www.w3.org/2000/svg" width="20" height="17" viewBox="0 0 20 17"><path d="M10 0l-5.2 4.9h3.3v5.1h3.8v-5.1h3.3l-5.2-4.9zm9.3 11.5l-3.2-2.1h-2l3.4 2.6h-3.5c-.1 0-.2.1-.2.1l-.8 2.3h-6l-.8-2.2c-.1-.1-.1-.2-.2-.2h-3.6l3.4-2.6h-2l-3.2 2.1c-.4.3-.7 1-.6 1.5l.6 3.1c.1.5.7.9 1.2.9h16.3c.6 0 1.1-.4 1.3-.9l.6-3.1c.1-.5-.2-1.2-.7-1.5z"/></svg></figure> <span style="color:black">Choose a file&hellip;</span></label>
				</div>
				</form>
				<div id="text" style="text-align: center;position: absolute;top: 370px; width: 80%;left: 10%;"></div>
<!-- BEGIN FOOTER -->
	<div id="footer">
		<span class="clientCopyRight"><nobr></nobr></span>
	</div>
	<!-- END FOOTER -->
<script>
$(document).ajaxStart(function () {
	$(".sk-circle").show();
    }).ajaxStop(function () {
    	$(".sk-circle").hide();
    });
function uploadPic(obj){
	if($(obj).val()!='') {
		  $("#submit_form").ajaxSubmit(function(message) {
			  console.log("message is:"+message);
			  swal("恭喜！", "您的图片已上传成功!", "success"); 
			  	$.ajax({  
			        cache : false,  
			        type : "GET",
					url : "../uploadPicture", 
					async: false,  
					data : {openid:$('#uid').val()},
			        timeout: 2000, 
			        success: function(data){
			        	console.log("data length:"+data.length);
						$("#text").html("");
						var div="";
						if (data.length > 0) {
							for(var i=0;i<data.length;i++){
								var temp =  data[i];
								div+='<div class ="DetectedPerson">'
									+'	<div  class="myfacevalue">'
									+ '<img src="http://mdmdxc.gz.bcebos.com/'+$('#uid').val()+'.jpg" alt="" width="100%">'
									+'	</div>'
									+'	<div class="myfacevalueattribute">'
									+'		<table>'
									+'			<tr><td><span style="font-weight:bold;font-size: 18px;">Score</span></td><td><span style="font-weight:bold;font-size: 16px;">'+temp.levelNum+'</span></td></tr>'
									+'			<tr><td>Smile</td><td>'+temp.smile+'</td></tr>'
									+'			<tr><td>Age</td><td>'+temp.age+'</td></tr>'
									+'			<tr><td>Glasses</td><td>'+temp.glasses+'</td></tr>'
									+'			<tr><td>Gender</td><td>'+temp.gender+'</td></tr>'
									+'			<tr><td>MouStache</td><td>'+temp.moustache+'</td></tr>'
									+'			<tr><td>Beard</td><td>'+temp.beard+'</td></tr>'
									+'			<tr><td>Anger</td><td>'+temp.anger.substr(0,9)+'</td></tr>'
									+'			<tr><td>Contempt</td><td>'+temp.contempt.substr(0,9)+'</td></tr>'
									+'			<tr><td>Disgust</td><td>'+temp.disgust.substr(0,9)+'</td></tr>'
									+'			<tr><td>Fear</td><td>'+temp.fear.substr(0,9)+'</td></tr>'
									+'			<tr><td>Happiness</td><td>'+temp.happiness.substr(0,9)+'</td></tr>'
									+'			<tr><td>Sadness</td><td>'+temp.sadness.substr(0,9)+'</td></tr>'
									+'			<tr><td>Surprise</td><td>'+temp.surprise.substr(0,9)+'</td></tr>'
									+'		</table>'
									+'	</div>'
									+'	<div class="clear"></div>'
									+'</div>';
							}
						}else{
							div="you don't have one photo..";
						}
						$("#text").html(div);
			        }
			  	}); 
		  } );

	}
	return false;
}
	 jQuery.ajax({
		type : "GET",
		url : "../QueryClientMeta",
		data : {},
		cache : false,
		success : function(data) {
			var jsons = eval(data);
			$(document).attr("title",jsons.clientStockCode+" - "+$(document).attr("title"));//修改title值  
			$('img.HpLogo').attr('src',jsons.clientLogo);
			$('span.clientCopyRight').text('©'+jsons.clientCopyRight);
			$('.clientTheme').css('background-color',jsons.clientThemeColor);
			$('.icon > img.exit ').css('-webkit-filter','drop-shadow(30px 0 '+jsons.clientThemeColor+')');
		}
	});

  	</script>
  	
		 <script src="../mdm/uploadfile_js/custom-file-input.js"></script>
  <script type="text/javascript" src="../Jsp/JS/gauge.min.js"></script>
  
</body>
</html>
