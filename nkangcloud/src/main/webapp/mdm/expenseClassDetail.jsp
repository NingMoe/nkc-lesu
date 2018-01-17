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
<title>课销详情</title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/bootstrap/css/bootstrap.min.css" />

<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
<script>
$(function(){
	$(".xk").on("click",function(){
		$.ajax({
			 url:'../ClassRecord/parentConfirmTime',
			 type:"GET",
			 data : {
				 expenseID:'<%=expenseID%>',
				 comment:""
			 },
			 success:function(data){
				 if(data){
						swal("确认成功!", "恭喜!", "success"); 
						window.location.href="http://leshucq.bceapp.com/mdm/expenseClassDetail.jsp?UID=<%=uid %>&&expenseID=<%=expenseID%>";
					}
					else{

						swal("确认失败!", "请填写正确的信息.", "error");
					}
				
				 
			}
		});
	});
})
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
	line-height:45px;
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
.xk{

    width: 100%;
    height: 35px;
    line-height: 35px;
    text-align: center;
    position: fixed;
    bottom: 0px;
    color: white;
    background: #20b672;}
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
<div class="item"><p class="title">确认状态</p><p class="value">
<%if(!record.isParentConfirmExpense()){ %>未确认<%}else{ %>已确认<%} %></p></div>
</div>
<div class="item"><p class="title">老师评语</p><p class="value"><%=record.getTeacherComment() %></p></div>

<%if(!record.isParentConfirmExpense()){ %>
<div class="xk">确认销课</div>
<%} %>
</body>
</html>