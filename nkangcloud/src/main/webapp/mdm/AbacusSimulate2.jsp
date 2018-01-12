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
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<script type="text/javascript" src="../Jsp/JS/leshu/jquery.min.js.download"></script>
<script src="../Jsp/JS/leshu/abacuss.js" type="text/javascript"></script>
<script src="../Jsp/JS/leshu/soroban.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style.css"/>
<link rel="stylesheet" type="text/css" href="../Jsp/JS/leshu/custom.css"/>
<title>珠心算算盘模拟器</title>

<style>
	th,td,img {
		padding: 0px;
		margin: 0px;
		border: 0px;
		vertical-align: bottom;
	}
	
	td img {
		vertical-align: bottom;
		width: 100%;
		height: auto;
	}
	
	table {
		border-collapse: collapse;
		border-spacing: 0px;
		border: none;
		vertical-align: bottom;
	}
	
	.selectPanel {
	    padding: 20px 20px;
	    text-align: center;
	    margin-top: 5px;
	}


	/* div#calculator {
		margin-left:-4%;
		margin-right:-4%;
	} */
	#numberid{
		width:100px;
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
	.selectPanel {
	    padding: 20px 20px;
	    text-align: center;
	    margin-top: 5px;
	}
	.form_edit {    
		width: 95%;
		margin-left: 4%;
	}
	#endPanel{
		position: relative;
		top:-40px;
	}
	
	
</style>

<script>
var foo = {};
	switch(window.orientation) {
		case -90:
		case 90:
			foo.columns=7;
			break;
		default:
			foo.columns=10;
			break;
	}
</script>

</head>
<body>
	<div id="data_model_div" style="height: 100px">
		<i class="icon" style="position: absolute; top: 25px; z-index: 100; right: 20px;">
			<div style="width: 30px; height: 30px; float: left; border-radius: 50%; overflow: hidden;">
				<img class="exit" src="<%= headImgUrl%>" style="width: 30px; height: 30px;" />
			</div> 
			<span style="position: relative; top: 8px; left: 5px; font-style: normal"><%= name%></span>
		</i>
		
		<!-- http://leshucq.bj.bcebos.com/icon/sw.jpg  -->
		<!-- http://leshu.bj.bcebos.com/standard/leshuLogo.png -->
		<img style="position: absolute; top: 8px; left: 10px; z-index: 100; height: 60px;" class="HpLogo" src="http://leshu.bj.bcebos.com/standard/leshuLogo.png" alt="Logo" />
		<div
			style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
	
	
	

<script type="text/javascript">mysoroban.htmldraw(foo.columns);</script>
<script src="jquery-1.8.0.js" type="text/javascript"></script>

	<div id="footer">
		<span class="clientCopyRight"><nobr>©版权所有 | 重庆NKC科技有限公司</nobr></span>
	</div>
</main>

</body>
</html>