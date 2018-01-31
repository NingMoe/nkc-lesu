<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%

	String teacherID = request.getParameter("UID");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>乐数启蒙-学生做题情况</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<link rel="stylesheet" type="text/css"
	href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
<link href="../Jsp/JS/leshu/font-awesome/css/font-awesome.min.css"
	rel="stylesheet">
<script src="../Jsp/JS/leshu/custom.js"></script>
<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
<style type="text/css">
#studentPanel{
    width: 80%;
    margin-left: 10%;
    height: 1000px;
    margin-top: 30px;
}
.student{	
	width: 80px;
    height: 120px;
    float: left;
    margin-left: 10px;
}
.headImg {
    width: 100%;
    float: left;
    height: 80px;
    border-radius: 50%;
    overflow: hidden;
}
.headImg img{
height:100%;
width:100%;}
.name {
    text-align: center;
    font-size: 15px;
    width: 100%;
    height: 20px;
    float: left;
    margin: 0;
    margin-top: 5px;
}
i{
color:#20B672;
}
.gk{
width:40%;
float:left!important;
margin-left:5%!important;
height:40px;
background:#20B672;
border-radius:5px;
line-height:40px!important;
color:white!important;}
</style>
<script>
var teacherID='<%=teacherID%>';
$(function(){
	getStudentsFromTeacher();
});
function redirectStudentslink(uid){
	window.location.href="http://leshucq.bceapp.com/mdm/NavigatorForBasic.jsp?UID="+uid;
}
function getStudentsFromTeacher(){
$.ajax({
	 url:'../userProfile/getUserByTeacherOpenid',
	 type:"POST",
	 data : {
		 teacherID : teacherID
	 },
	 success:function(result){
		 if(result){
			 var html="";
			 for(var i=0;i<result.length;i++){
				 html+="<div class='student' onclick='redirectStudentslink(\""+result[i].openid+"\")'><div class='headImg'><img src='"+result[i].headimgurl+"' alt=''></div><p class='name'>"+result[i].nickname+"</p></div>";
			 }
			 $("#studentPanel").html(html);
		 }
	 }
});
}
	 </script>
</head>
<body style="margin:0;">
	<div id="data_model_div" style="height: 80px">
		<i class="icon"
			style="position: absolute; top: 20px; left: 20px; z-index: 100;">
			<img class="exit" src="http://leshu.bj.bcebos.com/icon/EXIT1.png"
			style="width: 30px; height: 30px;">
		</i> <img
			style="position: absolute; top: 8px; right: 20px; z-index: 100; height: 60px;"
			class="HpLogo"
			src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" alt="Logo">
		<div
			style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
	<div id="studentPanel"></div>
</body>
</html>