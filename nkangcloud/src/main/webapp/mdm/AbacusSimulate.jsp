<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page
	import="com.nkang.kxmoment.baseobject.classhourrecord.StudentBasicInformation"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%
	String uid = request.getParameter("UID");
	Date d = new Date();  
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
    String dateNowStr = sdf.format(d);  
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
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>乐数珠心算算盘模拟器</title>
		<meta name="viewport" content="width=device-width, user-scalable=yes">
<!-- <link rel="stylesheet" type="text/css"href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
<link href="../Jsp/JS/leshu/font-awesome/css/font-awesome.min.css" rel="stylesheet">
<script src="../Jsp/JS/leshu/custom.js"></script>
<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script> -->
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style.css"/>
<script type="text/javascript" src="../Jsp/JS/leshu/abacus.js"></script>

<script type="text/javascript">
	function run() {
		var abacus2 = new Abacus("myAbacus2", 1);
		abacus2.init();
	}
	
	function pagereload(){
		window.location.reload();
	}
</script>

<style type="text/css">
*{margin:0;}
body{
overflow:hidden;
width:680px;
}

#footer {
    bottom: 0;
    color: #757575;
    font-size: 12px;
    padding: 10px 1%;
    position: fixed;
    text-align: center;
    width: 100%;
    z-index: 1002;
    left: 0;
}

</style>
</head>
<body onload="run();">
	<div id="data_model_div" style="height: 100px">
		<i class="icon" style="position: absolute; top: 25px; z-index: 100; right: 20px;">
			<div style="width: 30px; height: 30px; float: left; border-radius: 50%; overflow: hidden;">
				<img class="exit" src="<%= headImgUrl%>" style="width: 30px; height: 30px;" />
			</div> 
			<span style="position: relative; top: 8px; left: 5px; font-style: normal"><%= name%></span>
		</i> 
		<img style="position: absolute; top: 8px; left: 10px; z-index: 100; height: 60px;" class="HpLogo" src="http://leshu.bj.bcebos.com/standard/leshuLogo.png" alt="Logo" />
		<div
			style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
	<div id="myAbacus2" style="position:absolute;top:-10px;"> <canvas id="myAbacus2_Abacus"></canvas></div>
	<div style="text-align: center; width:100%; margin-top:50px;">
		<img alt="" src="http://leshucq.bj.bcebos.com/icon/reset-icon.png" style="margin: 0 auto;" onClick="pagereload();"/>
	</div>
	<div id="footer">
		<span class="clientCopyRight"><nobr>©版权所有 | 重庆乐数艺术培训有限公司</nobr></span>
	</div>
</body>
</html>