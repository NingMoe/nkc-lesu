<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.OAuthUitl.SNSUserInfo,java.lang.*"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.classhourrecord.StudentBasicInformation"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%

String uid = request.getParameter("UID"); 
String mgtview = "老师课时视图";
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
String redirectUrl="../ClassRecord/getExpenseCounts";
String role=MongoDBBasic.queryAttrByOpenID("role", uid,true);
System.out.println("role is========"+role);
List<StudentBasicInformation> records;
if(role.equals("Role004")){
	records=MongoDBBasic.getClassTypeRecordsByTeacher("");
	mgtview = "主管课时视图";
	redirectUrl="../ClassRecord/governorGetExpenseCounts";
}
else if(role.equals("Role005")){
	records=MongoDBBasic.getClassTypeRecordsByTeacher("");
	mgtview = "校长课时视图";
	redirectUrl="../ClassRecord/headmasterGetExpenseCounts";
}else{
	records=MongoDBBasic.getClassTypeRecordsByTeacher(uid);
}
int studentCount=MongoDBBasic.getStudentsByTeacher(uid).size();
%><!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title><%= mgtview%></title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<script type="text/javascript" src="../nkang/jquery-1.8.0.js"></script>
<link rel="stylesheet" href="../nkang/jquery.mobile.min.css" />
<script type="text/javascript" src="../nkang/jquery.mobile.min.js"></script>
<style type="text/css">
*{margin:0;}
a,a:hover,a:visited{text-decoration:none;color:black;}
.classRow{
height:35px;
width:19.5%;
margin-top:5px;
margin-bottom:5px;
float:left;
border-left:1px solid #CFCFCF;}
.classRow2{height:40px;}
.classRow p{
font-size:13px;
width:100%;
float:left;
height:35px;
line-height:35px;
text-align:center;
font-family:黑体;
}
.classPanel{
position:relative;
top:20px;
width:94%;
margin-left:3%;
height:80px;
border-top:1px solid #CFCFCF;
}
.classPanel2{
height:50px!important;
}
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
.ui-body-c .ui-link:visited{
color:black!important;
font-weight:normal!important;}
.ui-body-c .ui-link{
color:black!important;
font-weight:normal!important;}
.ui-icon{
background:none!important;}
.ui-btn-hover-c{
background-image:none!important;}
.ui-li-has-arrow .ui-btn-inner a.ui-link-inherit, .ui-li-static.ui-li-has-arrow{
padding-right:0!important;}
.ui-listview, .ui-li{
border:none!important;
box-shadow:none!important;}
input.ui-input-text {
    width: 100%;
    border-style: none;
    border: 1px solid #20b672;
    height: 25px;
    border-radius: 5px;
    margin-left: -10px;
    padding-left: 10px;
}
.strong{
font-weight:bold;
}
.ui-btn-up-c{
background-image:none!important;
font-weight:0!important;}

#navi{
width: 100%;
height: 35px;
border-bottom: 1px solid #20b672;
overflow: hidden;
}
#allData{
width: 20%;
    padding: 10px 10px;
    float: left;
    text-align: center;
    margin-left: 10px;
    border: 1px solid #20b672;
    border-radius: 5px;
    color: white;
    font-size: 15px;
    background: #20b672;}
 #search{
 width: 20%;
    padding: 10px 10px;
    float: left;
    text-align: center;
    border: 1px solid #20b672;
    border-radius: 5px;
    font-size: 15px;}
.title{
    width: 25%;
    height: 40px;
    line-height: 46px;
    font-size: 15px;
    float: left;
    text-align: center;
}
.put{
    float: left;
    width: 60%;
    height: 40px;
}
.single{
    width: 98%;
    margin-left: 1%;
    height: 40px;
}
.put input,.put select{
    margin-top: 8px;
    border-radius: 5px;
    border-style: none;
    border: 1px solid #20b672;
    height: 28px;
    width: 80%;
    font-size: 15px;
    padding-left:5px;
}
#yes{
box-shadow:none;
width: 99。5%;
    height: 30px;
    line-height:30px;
    text-align:center;
    border-style: none;
    border: 1px solid #20b672;
    background: #20b672;
    color: white;
    font-size:15px;
    margin-top: 15px;
}

.resultPanel,.masterPanel{
display:none;
position:relative;
top:20px;
width:94%;
margin-left:3%;
height:auto;
border-top:1px solid #CFCFCF;
}
.classRowWidth{

width:33%;
}
.classRowResult{
height:70px;
width:24.7%;
margin-bottom:5px;
float:left;
border-left:1px solid #CFCFCF;}
.classRowResult p{
font-size:13px;
width:100%;
float:left;
height:35px;
border-bottom: 1px solid #cfcfcf;
line-height:35px;
text-align:center;
font-family:黑体;
}
</style>
<script>
var role='<%=role%>';
$(function(){
	$("#search").on("click",function(){
		$(this).css({"background":"#20b672","color":"white"});
		$("#allData").css({"background":"none","color":"black"});
		$("#completeView").hide();
		$("#searchView").show();
		
	});
	$("#allData").on("click",function(){
		$(this).css({"background":"#20b672","color":"white"});
		$("#search").css({"background":"none","color":"black"});
		$("#completeView").show();
		$("#searchView").hide();
		
	});
	$("#yes").on("click",function(){
		$(".new").remove();
		var datas=$("#searchForm").serialize();
		$.ajax({
			url:'<%=redirectUrl%>',
			data:datas,
			type:"POST",
			dataType:"json",
			contentType: "application/x-www-form-urlencoded; charset=UTF-8",
			cache:false,
			async:false,
			success:function(result) {
				if(role=="Role004"||role=="Role005"){ 

					var i=0;
					for(var key in result){
						if(i%2==0){
							$("#qishuName").append("<p class='new'>"+key+"</p>");
							if(i==result.length-1){
								$("#qishuValue").append("<p class='new'>"+result[key]+"</p>");
								}else{
								$("#qishuValue").append("<p class='new' style='border-right:1px solid #cfcfcf'>"+result[key]+"</p>");
								}
						}
						else{

							$("#oushuName").append("<p class='new'>"+key+"</p>");
							$("#oushuValue").append("<p class='new'>"+result[key]+"</p>");
						}
						i++;
					}

					$(".masterPanel").show();
				}else{
					$("#total").text(result);
					$("#type").text($("#expenseOption").find("option:selected").text());
					$("#district").text($("#districtSelect").find("option:selected").text());
					$(".resultPanel").show();
				}
				
			}
		});
	});
});
</script>
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
			src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" alt="Logo">
		<div
			style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>	
	<div id="navi"><p id="allData">智能搜索</p><p id="search">条件搜索</p></div>
	<div id="searchView" style="margin-top:10px;display:none;">
	<form id="searchForm">
	<%if(!role.equals("Role004")&&!role.equals("Role005")){ %>
	<input name="teacherOpenID" type="hidden" value="<%=uid %>" />
	<%} %>
	<div class="single"><p class="title">起始时间</p><p class="put"><input name="start" type="date" /></p></div>
	<div class="single"><p class="title">终止时间</p><p class="put"><input name="end" type="date" /></p></div>
	<div class="single"><p class="title">课时类型</p><p class="put">
	<select id="expenseOption" name="expenseOption">
	<%if(role.equals("Role004")||role.equals("Role005")){ %>
	<option>全部</option>
	<%} %>
	<option>珠心算</option><option>趣味数学</option><option>丫丫拼音</option></select>
	</p></div>
	<div class="single"><p class="title">任课校区</p><p class="put">
	<select id="districtSelect" name="expenseDistrict">
		<%if(role.equals("Role005")){ %>
	<option>全部</option>
	<%} %>
	<option>江北校区</option><option>南坪校区</option><option>杨家坪校区</option><option>李家沱校区</option></select>
	</p></div>
	<div class="single"><p id="yes">查询</p></div>
	</form>
	
	<div class="resultPanel">
		<div class="classRowResult" style="border-left: none;">
		<p>学生总数</p>
			<p ><%=studentCount %></p>
		</div>
		<div class="classRowResult">
			<p>课时类型</p>
			<p id="type"></p>
		</div>
		<div class="classRowResult" style="border-right: none;">
			<p>课时校区</p>
			<p id="district"></p>
		</div>
		<div class="classRowResult" style="border-right: none;">
			
			<p>上课总数</p>
			<p id="total"></p>
		</div>
	</div>
	
		<div class="masterPanel" style="height:auto;border-bottom:none;">
		<div id="qishuName" class="classRowResult" style="border-left: none;height:auto;">
		<p>老师姓名</p>
		</div>
		<div id="qishuValue" class="classRowResult" style="height:auto;">
			<p>上课总数</p>
		</div>
		<div  id="oushuName" class="classRowResult" style="border-right: none;height:auto;">
			<p>老师姓名</p>
		</div>
		<div  id="oushuValue" class="classRowResult" style="border-right: none;height:auto;">
			
			<p>上课总数</p>
		</div>
	</div>
	</div>
	<div id="completeView">	
	<div class="classPanel" style="height:45px;position:absolute;top:200px;">
	<div class="classRow" style="border-left: none;">
			<p class="strong">学员姓名</p>
		</div>
		<div class="classRow">
			<p class="strong">课时类型</p>
		</div>
		<div class="classRow">
			<p class="strong">已用课时</p>
		</div>
		<div class="classRow" style="border-right: none;">
			<p class="strong">剩余课时</p>
		</div>
		<div class="classRow" style="border-right: none;">
			<p class="strong">总课时/赠</p>
		</div>
	</div>
	<div style="position: absolute; top: 150px; overflow: hidden" data-role="page" style="padding-top:45px" data-theme="c">

		<ul id="Work_Mates_div" class="Work_Mates_div2" data-role="listview" data-autodividers="false" data-filter="true" data-filter-placeholder="输入关键字" data-inset="true" style="margin-top: 55px">

	<%if(records.size()>0){ %>
	<%for(int i=0;i<records.size();i++){ %>
	<li>
	<div class="classPanel classPanel2">
	<a target="_blank" href="MyClassDetail.jsp?UID=<%=records.get(i).getOpenID() %>&teacherID=<%=uid%>">
	<div class="classRow classRow2" style="border-left: none;">
			<p id="total"><%=records.get(i).getRealName() %></p>
		</div>
		<div class="classRow classRow2">
			<p id="total"><%=records.get(i).getClassType()%></p>
		</div>
		<div class="classRow classRow2">
			<p id="used"><%=records.get(i).getExpenseClass() %></p>
		</div>
		<div class="classRow classRow2" style="border-right: none;">
			<p id="left"><%=records.get(i).getLeftPayClass() %></p>
		</div>
		<div class="classRow classRow2" style="border-right: none;">
			<p id="gift"><%=records.get(i).getTotalClass() %>/<%=records.get(i).getLeftSendClass() %></p>
		</div>
		</a>
	</div>
	</li>
<%}}%>
		</ul>
	</div>
	</div>

</body>
</html>