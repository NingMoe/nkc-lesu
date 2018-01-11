<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.alibaba.fastjson.JSONObject"%>

<%@ page
	import="com.nkang.kxmoment.baseobject.classhourrecord.StudentBasicInformation"%>
<%@ page import="java.util.*"%>
<%
	String uid = request.getParameter("UID");
	Date d = new Date();  
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");  
    String dateNowStr = sdf.format(d);  
    Map<String,StudentBasicInformation> sbis = MongoDBBasic.getClassTypeRecords(uid);
    Set<String> types=sbis.keySet();
    List<String> classTypes=new ArrayList<String>();
    List<String> classNameTypes=new ArrayList<String>();
    List<StudentBasicInformation> sbisList=new ArrayList<StudentBasicInformation>();
    for(String i : types){
    	classTypes.add(i);
    	classNameTypes.add(i);
    	sbisList.add(sbis.get(i));
    }
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
	String used=sbisList.get(0).getExpenseClass()+"";
	String left=sbisList.get(0).getLeftPayClass()+"";
	String gift=sbisList.get(0).getLeftSendClass()+"";
	String classType=sbisList.get(0).getClassType();
	String total=sbisList.get(0).getTotalClass()+"";
	if(classType.equals("zxs")){
		classType="珠心算";
	}
	if(classType.equals("yypy")){
		classType="丫丫拼音";
	}
	if(classType.equals("qwsx")){
		classType="趣味数学";
	}
	sbisList.remove(0);
	classTypes.remove(0);
	classNameTypes.remove(0);
	for(int i=0;i<classNameTypes.size();i++){
		if(classNameTypes.get(i).equals("zxs")){
			classNameTypes.set(i, "珠心算");
		}
		if(classNameTypes.get(0).equals("yypy")){
			classNameTypes.set(i,"丫丫拼音");
		}
		if(classNameTypes.get(0).equals("qwsx")){
			classNameTypes.set(i,"趣味数学");
		}
	}
    String resultJSON=JSONObject.toJSONString(sbisList);
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>我的课时</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<link rel="stylesheet" type="text/css"
	href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
<link href="../Jsp/JS/leshu/font-awesome/css/font-awesome.min.css"
	rel="stylesheet">
<script src="../Jsp/JS/leshu/custom.js"></script>
<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
<script src="../Jsp/JS/fusioncharts.js" type="text/javascript"></script>
<script src="../Jsp/JS/hulk-light.js" type="text/javascript"></script>
<script>
	var used = "<%=used%>";
	var left = "<%=left%>";
	var gift = "<%=gift%>";
	var records=eval('<%=resultJSON%>');
	function getClassRecord(obj){
		var ct=$(obj).find("option:selected").val();
		var totalClass=records[ct]==null?'':records[ct].totalClass;
		var expenseClass=records[ct]==null?'':records[ct].expenseClass;
		var leftPayClass=records[ct]==null?'':records[ct].leftPayClass;
		var leftSendClass=records[ct]==null?'':records[ct].leftSendClass;
		$("#total").text(totalClass);
		$("#used").text(expenseClass);
		$("#left").text(leftPayClass);
		$("#gift").text(leftSendClass);
		FusionCharts.ready(function() {
			var dietChart = new FusionCharts({
				type : 'pie3d',
				renderAt : 'chart-container',
				width : '100%',
				height : '230',
				dataFormat : 'json',
				dataSource : {
					"chart" : {
						"caption" : "",
						"showValues" : "1",
						"numberSuffix" : "",
						"theme" : "hulk-light",
						"enableMultiSlicing" : "1"

					},
					"data" : [ {
						"label" : "已用课时",
						"value" : expenseClass
					}, {
						"label" : "剩余课时",
						"value" : leftPayClass
					}, {
						"label" : "赠送课时",
						"value" : leftSendClass
					} ]
				}
			}).render();
		});
		
	}
	FusionCharts.ready(function() {
		var dietChart = new FusionCharts({
			type : 'pie3d',
			renderAt : 'chart-container',
			width : '100%',
			height : '230',
			dataFormat : 'json',
			dataSource : {
				"chart" : {
					"caption" : "",
					"showValues" : "1",
					"numberSuffix" : "",
					"theme" : "hulk-light",
					"enableMultiSlicing" : "1"

				},
				"data" : [ {
					"label" : "已用课时",
					"value" : used
				}, {
					"label" : "剩余课时",
					"value" : left
				}, {
					"label" : "赠送课时",
					"value" : gift
				} ]
			}
		}).render();
	});
</script>
<style type="text/css">
*{margin:0;}
body{
overflow:hidden;}
.classPanel{
position:relative;
top:20px;
width:94%;
margin-left:3%;
height:80px;
border-top:1px solid #CFCFCF;
border-bottom:1px solid #CFCFCF;
}
.classRow{
height:70px;
width:24.7%;
margin-top:5px;
margin-bottom:5px;
float:left;
border-left:1px solid #CFCFCF;}
.classRow p{
font-size:13px;
width:100%;
float:left;
height:35px;
line-height:35px;
text-align:center;
font-family:黑体;
}
#chart-container{
position:relative;
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
.classType{
width:100%;
text-align:center;
height:40px;
line-height:40px;
font-size:16px;
font-family:黑体;
position:absolute;
top:90px;
z-index:100000;
}
.time{

width:100%;
text-align:center;
height:40px;
line-height:40px;
font-size:14px;
font-family:黑体;
position:absolute;
top:300px;
z-index:100000;
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
	<div id="chart-container">FusionCharts will render here</div>
<select class="classType" onchange="getClassRecordByType(this)">
<option selected><%=classType %></option>
<%for(int i=0;i<classTypes.size();i++){ %>

<option value="<%=classTypes.get(i) %>"><%=classNameTypes.get(i) %></option>
<%} %>
</select>
<p class="time"><%=dateNowStr %></p>
	<div class="classPanel">
		<div class="classRow" style="border-left: none;">
			<p>课时总量</p>
			<p id="total"><%=total %></p>
		</div>
		<div class="classRow">
			<p>已用课时</p>
			<p id="used"><%=used %></p>
		</div>
		<div class="classRow" style="border-right: none;">
			<p>剩余课时</p>
			<p id="left"><%=left %></p>
		</div>
		<div class="classRow" style="border-right: none;">
			<p>赠送课时</p>
			<p id="gift"><%=gift %></p>
		</div>
	</div>
	<div id="footer">
		<span class="clientCopyRight"><nobr>©版权所有 | 重庆乐数艺术培训有限公司</nobr></span>
	</div>
</body>
</html>