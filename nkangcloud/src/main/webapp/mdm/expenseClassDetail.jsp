<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.OAuthUitl.SNSUserInfo,java.lang.*"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.classhourrecord.Classexpenserecord"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%

String uid = request.getParameter("UID"); 

String expenseID = request.getParameter("expenseID"); 

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

Classexpenserecord record=MongoDBBasic.getexpenseRecord(expenseID);
%><!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>乐数-练习参数</title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<script src="fusioncharts.js"></script>
<script src="hulk-light.js"></script> 
<script>
var used="22";
var left="10";
var gift="2";
FusionCharts.ready(function() {
  var dietChart = new FusionCharts({
    type: 'pie3d',
    renderAt: 'chart-container',
    width: '100%',
    height: '200',
    dataFormat: 'json',
    dataSource: {
      "chart": {
        "caption": "",
        "showValues":"1",
        "numberSuffix": "",
        "theme": "hulk-light",
        "enableMultiSlicing":"1"

      },
      "data": [{
        "label": "已用课时",
        "value": used
      }, {
        "label": "剩余课时",
        "value": left
      }, {
        "label": "赠送课时",
        "value": gift
      }]
    }
  }).render();
});

</script>
<style type="text/css">
*{margin:0;}
.usedPanel{
width:86%;
margin-left:7%;}
	.item{
	height:35px;
	width:100%;}
	.title{
	height:100%;
	width:30%;
	line-height:55px;
	text-align:left;
	font-size:15px;
	float:left;
	}
	.value{
	height:100%;
	width:70%;
	line-height:45px;
	text-align:right;
	font-size:15px;
	float:left;
	}
	.
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
<div class="usedPanel">
<div class="item"><p class="title">学员姓名</p><p class="value"><%=name %></p></div>
<div class="item"><p class="title">消费项目</p><p class="value"><%=record.getExpenseOption() %></p></div>
<div class="item"><p class="title">消费时间</p><p class="value"><%=record.getExpenseTime() %></p></div>
<div class="item"><p class="title">消费课时</p><p class="value"><%=record.getExpenseClassCount() %></p></div>
<div class="item"><p class="title">任课老师</p><p class="value"><%=record.getTeacherName() %></p></div>
<div class="item"><p class="title">课消校区</p><p class="value"><%=record.getExpenseDistrict() %></p></div>
<div class="item"><p class="title">老师评语</p><p class="value"><%=record.getTeacherComment() %></p></div>
</div>
</body>
</html>