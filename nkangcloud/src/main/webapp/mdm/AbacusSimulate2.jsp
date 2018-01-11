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


/* div#calculator {
	margin-left:-4%;
	margin-right:-4%;
} */
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




<style type="text/css">

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

</style>
</head>
<body>
	<div id="data_model_div" style="height: 100px">
		<i class="icon" style="position: absolute; top: 25px; z-index: 100; right: 20px;">
			<div style="width: 30px; height: 30px; float: left; border-radius: 50%; overflow: hidden;">
				<img class="exit" src="<%= headImgUrl%>" style="width: 30px; height: 30px;" />
			</div> 
			<span style="position: relative; top: 8px; left: 5px; font-style: normal"><%= name%></span>
		</i>
		
		<!-- http://pic1.nipic.com/2009-02-26/2009226111421860_2.jpg  -->
		<!-- http://leshu.bj.bcebos.com/standard/leshuLogo.png -->
		<img style="position: absolute; top: 8px; left: 10px; z-index: 100; height: 60px;" class="HpLogo" src="http://pic1.nipic.com/2009-02-26/2009226111421860_2.jpg" alt="Logo" />
		<div
			style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
<main>

<div id="calculator">
	<div>
		<script type="text/javascript">mysoroban.htmldraw(foo.columns)</script>
	
	<!-- <table cellpadding="0" cellspacing="0">
		<tbody>
			<tr style="line-height:6px;">
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_middlesep.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_middlesep.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_middlesep.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_middlesep.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_middlesep.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_middlesep.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_middlesep.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_middlesep.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_middlesep.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_middlesep.png"></td>
			</tr>
			<tr>
				<td><img name="B1-9-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_nobead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B1-8-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_nobead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B1-7-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_nobead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B1-6-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_nobead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B1-5-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_nobead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B1-4-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B1-3-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_nobead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B1-2-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B1-1-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_nobead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B1-0-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_nobead.png" onclick="mysoroban.v039(this.name)"></td>
			</tr>
			<tr>
				<td><img name="B2-9-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B2-8-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B2-7-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B2-6-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B2-5-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B2-4-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B2-3-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B2-2-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B2-1-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B2-0-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
			</tr>
			<tr>
				<td><img name="B3-9-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B3-8-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B3-7-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B3-6-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B3-5-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B3-4-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_nobead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B3-3-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B3-2-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B3-1-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B3-0-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
			</tr>
			<tr>
				<td><img name="B4-9-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B4-8-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B4-7-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B4-6-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B4-5-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B4-4-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B4-3-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B4-2-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_nobead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B4-1-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B4-0-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
			</tr>
			<tr>
				<td><img name="B5-9-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B5-8-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B5-7-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B5-6-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B5-5-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B5-4-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B5-3-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B5-2-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B5-1-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
				<td><img name="B5-0-mysoroban" src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bead.png" onclick="mysoroban.v039(this.name)"></td>
			</tr>
			<tr>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bottomborder.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bottomborder.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bottomborder.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bottomborder.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bottomborder.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bottomborder.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bottomborder.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bottomborder.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bottomborder.png"></td>
				<td><img src="http://leshucq.bj.bcebos.com/abacus/SmallSoroban_image_bottomborder.png"></td>
			</tr>
		</tbody>
	</table> -->
	
</div>
	
</div>
	<div id="footer">
		<span class="clientCopyRight"><nobr>©版权所有 | 重庆NKC科技有限公司</nobr></span>
	</div>
</main>

</body>
</html>