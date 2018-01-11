<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
String uid = request.getParameter("UID");
SimpleDateFormat  format = new SimpleDateFormat("yyyy-MM-dd"); 
Date date=new Date();
String currentDate = format.format(date);
HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(uid);
MongoDBBasic.updateVisited(uid,currentDate,"index",res.get("HeadUrl"),res.get("NickName"));
String hardcodeUID = "oO8exvz-DZOu8wc0f81v9EHYq2HE";
String hardcodeUID2 = "oI3krwbSD3toGOnt_bhuhXQ0TVyo";
if(MongoDBBasic.checkUserAuth(uid, "isAdmin")||hardcodeUID.equalsIgnoreCase(uid)||hardcodeUID2.equalsIgnoreCase(uid)){
}else{
	out.print("你没有查看该页面的权限！");
	return;
}
MongoDBBasic.updateUser(uid);

%>
<!DOCTYPE HTML>
<html>
<head>
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<meta content="" name="description" />
<meta content="" name="乐数" />

<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/bootstrap/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/bootstrap/css/bootstrap-responsive.min.css" />
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/font-awesome/css/font-awesome.css" />
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style.css" />
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/profile.css" />
<link rel="stylesheet" type="text/css" href="../nkang/assets_athena/icomoon/iconMoon.css" />
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style-responsive.css" />
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style-default.css" />
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css" />
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/CSS/sonhlab-base.css" />
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/CSS/openmes.css" />
<link rel="stylesheet" type="text/css" href="../nkang/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="../nkang/themes/icon.css">
<link rel="stylesheet" type="text/css" href="../nkang/demo.css">
<link rel="stylesheet" type="text/css" href="../nkang/animate.min.css">
<link rel="stylesheet" type="text/css" href="../nkang/admin/admin.css">
<link rel="stylesheet" type="text/css" href="../nkang/autocomplete/jquery-ui.css">

<script type="text/javascript" src="../nkang/easyui/jquery.min.js"></script>
<script type="text/javascript">
	var $113 = $;
</script>
<script type="text/javascript" src="../nkang/easyui/jquery.easyui.min.js"></script>
<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles//CSS/animation-effects.css" />
<link rel="stylesheet" type="text/css" href="../Jsp/CSS/common.css">
<script src="../nkang/js_athena/jquery.circliful.min.js"></script>
<script src="../nkang/assets_athena/bootstrap/js/bootstrap.js"></script>
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
<script type="text/javascript"
	src="../MetroStyleFiles//JS/openmes.min.js"></script>
<script src="../Jsp/JS/modernizr.js"></script>
<script src="../Jsp/JS/jSignature.min.noconflict.js"></script>
<script type="text/javascript" src="../nkang/autocomplete/jquery-ui.js"></script>
<script src="../Jsp/JS/fusioncharts.js" type="text/javascript"></script>
<link rel="stylesheet" href="../nkang/jquery.mobile.min.css" />
<script type="text/javascript" src="../nkang/jquery.mobile.min.js"></script>
<style>
 #return-top{position:fixed;bottom:40px;right:10px; text-align:center; display:none;z-index:998;} 
.edit
{
	width: 60px;
    height: 100%;
    color: #fff;
    font-family:微软雅黑;
    text-align: center;
    position: absolute;
    top: 0px;
    right: -60px;
	font-size:14px;
    background: #438CD0;
    border-bottom: 1px solid #ccc;
}
.edit.km{
	right: -120px;
    background: orange;
}
.edit img {
    width:25px;height:auto;position:absolute;top:13px;left: 20px;
}
.edit.km p{
	line-height:35px;
	padding-top:20px;
}
.edit p
{
	width:50%;
	height:100%;
	line-height:145px;
	margin-right:auto;
	margin-left:auto;
}
.editBtn
{
	position: relative;
    left: -120px;
}

.singleQuote .edit
{
	width: 60px;
    height: 100%;
    color: #fff;
    font-family:微软雅黑;
    text-align: center;
    position: absolute;
    top: 0px;
    right: -45px;
	font-size:14px;
    background: orange;
    border-bottom: 1px solid #ccc;
}
.singleQuote .edit img {
    width:25px;height:auto;position:absolute;top:8px;margin-left: 2px;
}
.singleQuote .edit p
{
	width:50%;
	height:100%;
	line-height:90px;
	margin-right:auto;
	margin-left:auto;
	font-weight:bold;
}
.singleQuote .edit.no{
background: #999;
}
.singleQuote .picClose
{
cursor:pointer;
}
.singleQuote  .edit.no p
{
	line-height:25px;
	padding-top:5px;
}
.singleQuote.editBtn
{
	position: relative;
    left: -60px;
}
ul li.singleQuote{
	font-size:18px;
	border-bottom:1px solid #ccc;
	padding:20px;
	color:#333;
	width:100%;
}
ul li.singleQuote .firstLayer.attention{
	color:#0761A5;
}
ul li.singleQuote .firstLayer .quoteTitle{
	float:left;
	cursor:pointer;
}
ul li.singleQuote .firstLayer .quoteTitle .tag2{
	font-size:11px;
	background-color:orange;
	color:#fff;
	padding:1px 5px;
	font-weight:normol;
	font-family:微软雅黑;
	margin-left:8px;
}
ul li.singleQuote .firstLayer .quotePrice{
	float:right;
	color:#333;
}
ul li.singleQuote .firstLayer .quotePrice.high,ul li.singleQuote .firstLayer  .change.high{
	color:red;
}
ul li.singleQuote .firstLayer .quotePrice.normal,ul li.singleQuote .firstLayer  .change.normal{
	color:#333;
}
ul li.singleQuote .firstLayer.attention .quotePrice.high,ul li.singleQuote .firstLayer.attention  .change.high{
	color:red;
}
ul li.singleQuote .firstLayer .quotePrice.low,ul li.singleQuote .firstLayer  .change.low{
	color:green;
}
ul li.singleQuote .firstLayer .quotePrice.lose,ul li.singleQuote .firstLayer  .change.lose{
	color:#bbb;
}
ul li.singleQuote .firstLayer  .change{
	font-size:10px;
	float:right;
	margin-top:-35px;
	position:relative;
	clear:both;
}
.clear{
	clear:both;
}
.editText{
    margin: 0;
    margin-top: 8px;
    width:80px;
}

.classText{
    margin: 0;
    margin-top: 8px;
    width:100px;
}
.editInput{
    height: 30px;
    padding-left: 10px;
    margin-top: 10px;
    border-radius: 5px!important;
    margin-left: 5px;
    line-height:30px;}
.radioInput{
	margin:0!important;
    margin-left: 20px!important;
    margin-right: 5px!important;}
.radioText{
    margin-top: 10px;
    display: inline-block;}
</style>
<script type="text/javascript">
$(function(){  
    $('#return-top').hide();  
    $(function(){  
        $(window).scroll(function(){  
            if($(window).scrollTop()>200){  
                $('#return-top').fadeIn(200);  
                }  
                else{$('#return-top').fadeOut(200);}  
              
            });  
            $('#return-top').click(function(){  
                $('body,html').animate({scrollTop:0},200);  
                	return false;  
                });
        });
    });
var clientThemeColor,HpLogoSrc,LogoData;
var RoleList,RoleObj=new Object();
var likePageNum=0;
$(window).load(function() {
	getVisitPage();
	findRoleList();
	getLogoLists();
	$("li.Work_Mates_div_list_div2").live("swiperight",function(){
		$(this).css("overflow","hidden");
		$(this).removeClass("editBtn");
		$(this).remove(".edit");
	}); 
	$("li.Work_Mates_div_list_div2").live("swipeleft",function(){
		$(this).css("overflow","visible");
		$(this).addClass("editBtn");
		var openid=$(this).find("span.openid").text();
		var name=$(this).find("span.name").text();
		$(this).append("<div class='edit' onclick='showUpdateUserPanel(\""+openid+"\",\""+name+"\")'><p><img src='../mdm/images/edit.png' alt='' /><p style='font-size: 14px;position: absolute;height: 60px;line-height: 20px;top: 48px;left:15px;'>信息编辑</p></p></div>");
		$(this).append("<div class='edit km' onclick='showClassPanel(\""+openid+"\",\""+name+"\")' ><p><img src='http://leshucq.bj.bcebos.com/standard/classunit.png' alt='' /><p style='font-size: 14px;position: absolute;height: 60px;line-height: 20px;top: 28px;left:15px;'>课时管理</p></p></div>");
		$(this).siblings().removeClass("editBtn");
		$(this).siblings().remove(".edit");
	});
	$(".singleQuote").live("swiperight",function(){
		$(this).css("overflow","hidden");
		$(this).removeClass("editBtn");
		$(this).find(".edit").remove();
	}); 
	$(".singleQuote").live("swipeleft",function(){
		$(this).siblings().removeClass("editBtn");
		$(this).siblings().find(".edit").remove();
		
		
		var priceNum=$(this).find('span.price').length;
		if(priceNum==0){
			$(this).css("overflow","visible");
			$(this).addClass("editBtn");
			var tagNum=$(this).find('span.tag2').length;
			var item=$(this).find('span.id').text();
			if(tagNum==0){
				$(this).append('<div class="edit"><p onclick="UpdateTag(\''+item+'\',\'add\',this)"><img src="../mdm/images/focus.png" />关注</p></div>');
			}else{
				$(this).append('<div class="edit no"><p onclick="UpdateTag(\''+item+'\',\'del\',this)">取消<br/>关注</p></div>');
			}
		}
	});
	$("#syncUser").click(function(){
		syncUser();
	});
	$("#refreshUser").click(function(){
		getMDLUserLists();
	});
});
function syncUser(){
	$("#syncUser").attr("src","../MetroStyleFiles/loading.gif");
	jQuery.ajax({
		type : "GET",
		url : "../userProfile/getWechatUserLists",
		data : {},
		cache : false,
		success : function(data) {
			swal("同步成功！", data, "success"); 
			$("#syncUser").attr("src","http://leshu.bj.bcebos.com/icon/sync.png");
			getMDLUserLists();
		}
	});
}
function UpdateTag(item,flag,obj){
	var tempObj=$(obj).parent().parent(".singleQuote");
	$(".singleQuote").removeClass("editBtn");
	$(".singleQuote").find(".edit").remove();
    if(likePageNum>=4&&flag=='add'){
		 swal("操作失败", "最多只能关注四个页面", "error");
	}else{ 
		$.ajax({
			 url:'../updateVisitPage',
			 type:"POST",
			 data : {
				 realName : item,
				 flag : flag
			 },
			 success:function(result){
				 if(result==true){
					 if(flag=='add'){
						 context='恭喜你成功关注该项';
						 if(RoleObj[item]!=null&&RoleObj[item].length>0){
							 var context='';
							 for(var i=0;i<RoleObj[item].length;i++){
								 if(context!='')context+='，';
								 context+=AreaObj[RoleObj[item][i]];
							 }
							 context='推荐您关注【'+context+'】技术领域';
						 }
						 swal("关注成功 ",context, "success");
						 likePageNum++;
						 tempObj.find(".firstLayer").addClass("attention");
						 tempObj.find(".firstLayer").find(".quoteTitle").append('<span class="tag2">已关注</span>');
					 }else  if(flag=='del'){
						 swal("取消成功","你取消了对该项的关注", "success");
						 likePageNum--;
						 tempObj.find(".firstLayer").removeClass("attention");
						 tempObj.find(".firstLayer").find(".quoteTitle").find(".tag2").remove();
					 }
				 }else{
					 swal("操作失败", "请刷新页面后重试", "error");
				 }
			 }
		});	
	 } 
}
function findRoleList(){
	$.ajax({
		 url:'../roleOfAreaMap/findList',
		 type:"GET",
		 data : {
			 flag : 'Role'
		 },
		 success:function(resData){
			 RoleList=resData;
			 for(var i=0;i<RoleList.length;i++){
				 RoleObj[RoleList[i].id]=RoleList[i].name;
			 }
			 getMDLUserLists();
			 
			 
			 
		}
	});
	
}
var teacherIds=new Array();
var teacherNames=new Array();
function findTeacherList(){
	$.ajax({
		 url:'../userProfile/findUsersByRole',
		 type:"GET",
		 data : {},
		 success:function(data){
			 if(data){
				 for(var i=0;i<data.length;i++){
					 teacherIds[i]=data[i].openid;
					 teacherNames[i]=data[i].nickname;
				 }
			 }
			 
		}
	});
	
}

var records;
var keyArrays;
var keyNameArrays;
function getClassRecord(obj){
	var ct=$(obj).find("option:selected").val()
	var realName=records[ct]==null?'':records[ct].realName;
	var enrolledTime=records[ct]==null?'':records[ct].enrolledTime;
	var enrolledWay=records[ct]==null?'':records[ct].enrolledWay;
	var district=records[ct]==null?'':records[ct].district;
	var totalClass=records[ct]==null?'':records[ct].totalClass;
	var expenseClass=records[ct]==null?'':records[ct].expenseClass;
	var leftPayClass=records[ct]==null?'':records[ct].leftPayClass;
	var leftSendClass=records[ct]==null?'':records[ct].leftSendClass;
	var classType=records[ct]==null?'':records[ct].classType;
	var districtList=new Array('jb','ljt','np','yjp');
	var districtNameList=new Array('江北校区','李家沱校区','南坪校区','杨家坪校区');
	var enrolledWayList=new Array('web','ad','ldx','other');
	var enrolledWayNameList=new Array('网络','广告','老带新','其他');
	var classTypeList=new Array('zxs','yypy','qwsx');
	var classTypeNameList=new Array('珠心算','丫丫拼音','趣味数学');
	var selectedDistrictName="";
	var selectedenrolledWayName="";
	var selectedClassTypeName="";
	if(district!=''){
		for(var q=0;q<districtList.length;q++){
			if(district==districtList[q]){
				districtList.splice(q,1);
				selectedDistrictName=districtNameList[q];
				districtNameList.splice(q,1);
				break;
			}
		}
	}
	if(enrolledWay!=''){
		for(var p=0;p<enrolledWayList.length;p++){
			if(enrolledWay==enrolledWayList[p]){
				enrolledWayList.splice(p,1);
				selectedenrolledWayName=enrolledWayNameList[p];
				enrolledWayNameList.splice(p,1);
				break;
			}
		}
	}
	if(classType!=''){
		for(var p=0;p<classTypeList.length;p++){
			if(classType==classTypeList[p]){
				classTypeList.splice(p,1);
				selectedClassTypeName=classTypeNameList[p];
				classTypeNameList.splice(p,1);
				break;
			}
		}
	}
	var districtSelect="<option selected='true' value='"+district+"'>"+selectedDistrictName+"</option>";
	for(var p=0;p<districtList.length;p++){
		districtSelect+="<option value='"+districtList[p]+"'>"+districtNameList[p]+"</option>";
	}

	var enrolledWaySelect="<option selected='true' value='"+enrolledWay+"'>"+selectedenrolledWayName+"</option>";
	for(var p=0;p<enrolledWayList.length;p++){
		enrolledWaySelect+="<option value='"+enrolledWayList[p]+"'>"+enrolledWayNameList[p]+"</option>";
	}
	var classTypeSelect="<option selected='true' value='"+classType+"'>"+selectedClassTypeName+"</option>";
	for(var p=0;p<classTypeList.length;p++){
		classTypeSelect+="<option value='"+classTypeList[p]+"'>"+classTypeNameList[p]+"</option>";
	}
	$("#UpdateClassPartDiv").html('<form id="updateClassForm">'
            +'												<input type="hidden" name="openID" id="atest_uid" value="'+openid+'"/>'
            +'												<table id="tableForm" style="margin-top:-10px;width:100%;">'
            +'												    <tr>'
            +'													    <td><p class="classText">报名时间</p></td>'
            +'													    <td align="left" class="tdText" >'
            +'													    	<input class="editInput"  name="enrolledTime" type="date" id="enrolledTime" required  value="'+enrolledTime+'">'
            +'													    </td>'
            +'												    </tr>'
            +'													<tr>'
            +'														<td><p class="classText">报名渠道</p></td>'
            +'														<td><select class="editInput"  name="enrolledWay"  id="enrolledWay">'
            +enrolledWaySelect
            +'													    </select></td>'
            +'													</tr>'
            +'													<tr>'
            +'														<td><p class="classText">报名校区</p></td>'
            +'														<td><select class="editInput"  name="district"  id="district">'
            +districtSelect
            +'													    </select></td>'
            +'													</tr>'	
            +'													<tr>'
            +'														<td><p class="classText">课时类型</p></td>'
            +'														<td><select class="editInput"  onchange="getClassRecord(this)  name="classType" id="classType">'
            +classTypeSelect
            +'													    </select></td>'
            +'													</tr>'			            
            +'													<tr>'
            +'														<td><p class="classText">总课时</p></td>'
            +'														<td><input class="editInput" type="text" name="totalClass" id="totalClass" value="'+totalClass+'"/></td>'
            +'													</tr>'
            +'													<tr>'
            +'														<td><p class="classText">已经消费课时</p></td>'
            +'														<td><input class="editInput" type="text" name="expenseClass" id="expenseClass" value="'+expenseClass+'"/></td>'
            +'													</tr>'
            +'													<tr>'
            +'														<td><p class="classText">剩余购买课时</p></td>'
            +'														<td><input class="editInput" type="text" name="leftPayClass" id="leftPayClass" value="'+leftPayClass+'"/></td>'
            +'													</tr>'
            +'													<tr>'
            +'														<td><p class="classText">剩余赠与课时</p></td>'
            +'														<td><input class="editInput" type="text" name="leftSendClass" id="leftSendClass" value="'+leftSendClass+'"/></td>'
            +'													</tr>'
            +'												 </table>'
            +'												 </form>'
            +'												 <button class="btnAthena EbtnLess" style="background-color:#20b672;margin-left: 90px;margin-top:15px;" id="updateClassBtn">确定</button>');

}
function showClassPanel(openid,name){
	showCommonPanel();
	//findTeacherList();
	$(".Work_Mates_div_list_div2").removeClass("editBtn");
	$(".Work_Mates_div_list_div2").remove(".edit");

    $('body,html').animate({scrollTop:0},200);  
	$("body").append('<div id="UpdateClassPart" class="bouncePart" style="position:absolute;z-index:999;top:90px;width:90%;margin-left:6%;"><legend>编辑【'+name+'】的课时信息</legend><div id="UpdateClassPartDiv" style="margin-top:0px;margin-bottom: -20px;background-color:#fff;">'
			+'<center>正在加载中...</center>'		
	+'						</div>');
	$('#UpdateClassPart').addClass('form-horizontal bounceInDown animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
	      $(this).removeClass("bounceInDown animated");
	 });
	 	jQuery.ajax({
		type : "GET",
		url : "../ClassRecord/getClassTypeRecords",
		data : {
			openID : openid
		},
		cache : false,
		success : function(data) {
			 	records=data;
				var keys="";
				for(var key in data){
					keys+=key+",";
					
				}
				keyArrays=keys.split(",");
				var index=keyArrays[0];
				
				var realName=data[index]==null?'':data[index].realName;
				var enrolledTime=data[index]==null?'':data[index].enrolledTime;
				var enrolledWay=data[index]==null?'':data[index].enrolledWay;
				var district=data[index]==null?'':data[index].district;
				var totalClass=data[index]==null?'':data[index].totalClass;
				var expenseClass=data[index]==null?'':data[index].expenseClass;
				var leftPayClass=data[index]==null?'':data[index].leftPayClass;
				var leftSendClass=data[index]==null?'':data[index].leftSendClass;
				var classType=data[index]==null?'':data[index].classType;
				var districtList=new Array('jb','ljt','np','yjp');
				var districtNameList=new Array('江北校区','李家沱校区','南坪校区','杨家坪校区');
				var enrolledWayList=new Array('web','ad','ldx','other');
				var enrolledWayNameList=new Array('网络','广告','老带新','其他');
				var classTypeList=new Array('zxs','yypy','qwsx');
				var classTypeNameList=new Array('珠心算','丫丫拼音','趣味数学');
				var selectedDistrictName="";
				var selectedenrolledWayName="";
				var selectedClassTypeName="";
				if(district!=''){
					for(var q=0;q<districtList.length;q++){
						if(district==districtList[q]){
							districtList.splice(q,1);
							selectedDistrictName=districtNameList[q];
							districtNameList.splice(q,1);
							break;
						}
					}
				}
				if(enrolledWay!=''){
					for(var p=0;p<enrolledWayList.length;p++){
						if(enrolledWay==enrolledWayList[p]){
							enrolledWayList.splice(p,1);
							selectedenrolledWayName=enrolledWayNameList[p];
							enrolledWayNameList.splice(p,1);
							break;
						}
					}
				}
				if(classType!=''){
					for(var p=0;p<classTypeList.length;p++){
						if(classType==classTypeList[p]){
							classTypeList.splice(p,1);
							selectedClassTypeName=classTypeNameList[p];
							classTypeNameList.splice(p,1);
							break;
						}
					}
				}
				var districtSelect="<option selected='true' value='"+district+"'>"+selectedDistrictName+"</option>";
				for(var p=0;p<districtList.length;p++){
					districtSelect+="<option value='"+districtList[p]+"'>"+districtNameList[p]+"</option>";
				}

				var enrolledWaySelect="<option selected='true' value='"+enrolledWay+"'>"+selectedenrolledWayName+"</option>";
				for(var p=0;p<enrolledWayList.length;p++){
					enrolledWaySelect+="<option value='"+enrolledWayList[p]+"'>"+enrolledWayNameList[p]+"</option>";
				}
				var classTypeSelect="<option selected='true' value='"+classType+"'>"+selectedClassTypeName+"</option>";
				for(var p=0;p<classTypeList.length;p++){
					classTypeSelect+="<option value='"+classTypeList[p]+"'>"+classTypeNameList[p]+"</option>";
				}
				$("#UpdateClassPartDiv").html('<form id="updateClassForm">'
			            +'												<input type="hidden" name="openID" id="atest_uid" value="'+openid+'"/>'
			            +'												<table id="tableForm" style="margin-top:-10px;width:100%;">'
			            +'												    <tr>'
			            +'													    <td><p class="classText">报名时间</p></td>'
			            +'													    <td align="left" class="tdText" >'
			            +'													    	<input class="editInput"  name="enrolledTime" type="date" id="enrolledTime" required  value="'+enrolledTime+'">'
			            +'													    </td>'
			            +'												    </tr>'
			            +'													<tr>'
			            +'														<td><p class="classText">报名渠道</p></td>'
			            +'														<td><select class="editInput"  name="enrolledWay"  id="enrolledWay">'
			            +enrolledWaySelect
			            +'													    </select></td>'
			            +'													</tr>'
			            +'													<tr>'
			            +'														<td><p class="classText">报名校区</p></td>'
			            +'														<td><select class="editInput"  name="district"  id="district">'
			            +districtSelect
			            +'													    </select></td>'
			            +'													</tr>'	
			            +'													<tr>'
			            +'														<td><p class="classText">课时类型</p></td>'
			            +'														<td><select class="editInput" onchange="getClassRecord(this)" name="classType" id="classType">'
			            +classTypeSelect
			            +'													    </select></td>'
			            +'													</tr>'			            
			            +'													<tr>'
			            +'														<td><p class="classText">总课时</p></td>'
			            +'														<td><input class="editInput" type="text" name="totalClass" id="totalClass" value="'+totalClass+'"/></td>'
			            +'													</tr>'
			            +'													<tr>'
			            +'														<td><p class="classText">已经消费课时</p></td>'
			            +'														<td><input class="editInput" type="text" name="expenseClass" id="expenseClass" value="'+expenseClass+'"/></td>'
			            +'													</tr>'
			            +'													<tr>'
			            +'														<td><p class="classText">剩余购买课时</p></td>'
			            +'														<td><input class="editInput" type="text" name="leftPayClass" id="leftPayClass" value="'+leftPayClass+'"/></td>'
			            +'													</tr>'
			            +'													<tr>'
			            +'														<td><p class="classText">剩余赠与课时</p></td>'
			            +'														<td><input class="editInput" type="text" name="leftSendClass" id="leftSendClass" value="'+leftSendClass+'"/></td>'
			            +'													</tr>'
			            +'												 </table>'
			            +'												 </form>'
			            +'												 <button class="btnAthena EbtnLess" style="background-color:#20b672;margin-left: 90px;margin-top:15px;" id="updateClassBtn">确定</button>');
				$("#updateClassBtn").click(function(){
					var datas=$("#updateClassForm").serialize();
 					$.ajax({
						url:"../ClassRecord/updateStudentBasicInfo",
						data:datas,
						type:"POST",
						dataType:"json",
						contentType: "application/x-www-form-urlencoded; charset=UTF-8",
						cache:false,
						async:false,
						success:function(result) {
							if(result){
								swal("更改成功!", "恭喜!", "success"); 
								hideBouncePanel();
								getMDLUserLists();
							} else {
								swal("更改失败!", "请填写正确的信息.", "error");
							}
						}
					}); 
				});
		}
	}); 
}

function showUpdateUserPanel(openid,name){
	showCommonPanel();
	findTeacherList();
	$(".Work_Mates_div_list_div2").removeClass("editBtn");
	$(".Work_Mates_div_list_div2").remove(".edit");
    $('body,html').animate({scrollTop:0},200);  
	$("body").append('<div id="UpdateUserPart" class="bouncePart" style="position:absolute;z-index:999;top:90px;width:86%;margin-left:7%;"><legend>编辑【'+name+'】的基本信息</legend><div id="UpdateUserPartDiv" style="margin-top:0px;margin-bottom: -20px;background-color:#fff;">'
			+'<center>正在加载中...</center>'		
	+'						</div>');
	$('#UpdateUserPart').addClass('form-horizontal bounceInDown animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
	      $(this).removeClass("bounceInDown animated");
	 });
	jQuery.ajax({
		type : "GET",
		url : "../CallGetWeChatUserFromMongoDB",
		data : {
			openid : openid
		},
		cache : false,
		success : function(data) {
			if (data.length > 0) {
				var IsRegistered=data[0].IsRegistered==null?'false':data[0].IsRegistered;
				var IsAuthenticated=data[0].IsAuthenticated==null?'false':data[0].IsAuthenticated;
				var IsActived=data[0].isActive==null?'false':data[0].isActive;
				var isAdmin=data[0].isAdmin==null?'false':data[0].isAdmin;
				var isSmsTeam=data[0].isSmsTeam==null?'false':data[0].isSmsTeam;
				var registerDate=data[0].registerDate==null?'':data[0].registerDate.replace(/\//g,"-");
				var realName=data[0].realName==null?'':data[0].realName;
				var phone=data[0].phone==null?'':data[0].phone;
				var email=data[0].email==null?'':data[0].email;
				var role=data[0].role==null?'':data[0].role;
				var levelList=new Array('basic','primary','middle','high');
				var levelNameList=new Array('启蒙','初级','中级','高级');
				var selectedName="";
				var selectedTeacherName="";
				var level=data[0].level==null?'':data[0].level;
				var teacher=data[0].teacher==null?'':data[0].teacher;
				if(level!=''){
					for(var q=0;q<levelList.length;q++){
						if(level==levelList[q]){
							levelList.splice(q,1);
							selectedName=levelNameList[q];
							levelNameList.splice(q,1);
							break;
						}
					}
				}
				if(teacher!=''){
					for(var p=0;p<teacherIds.length;p++){
						if(teacher==teacherIds[p]){
							teacherIds.splice(p,1);
							selectedTeacherName=teacherNames[p];
							teacherNames.splice(p,1);
							break;
						}
					}
				}
				var levelSelect="<option selected='true' value='"+level+"'>"+selectedName+"</option>";
				for(var p=0;p<levelList.length;p++){
					levelSelect+="<option value='"+levelList[p]+"'>"+levelNameList[p]+"</option>";
				}

				var teacherSelect="<option selected='true' value='"+teacher+"'>"+selectedTeacherName+"</option>";
				for(var p=0;p<teacherIds.length;p++){
					teacherSelect+="<option value='"+teacherIds[p]+"'>"+teacherNames[p]+"</option>";
				}
				var selfIntro=data[0].selfIntro==null?'':data[0].selfIntro;
				var roleSelect='														<option value="">-请选择-</option>';
				for(var i=0;i<RoleList.length;i++){
					if(role==RoleList[i].id){
						roleSelect+='														<option selected="true" value="'+RoleList[i].id+'">'+RoleList[i].name+'</option>';
					}else{
						roleSelect+='														<option value="'+RoleList[i].id+'">'+RoleList[i].name+'</option>';
					}
				}
				$("#UpdateUserPartDiv").html('<form id="atest">'
			            +'												<input type="hidden" name="uid" id="atest_uid" value="'+openid+'"/>'
			            +'												<table id="tableForm" style="margin-top:-10px;width:100%;">'
			            +'													<tr>'
			            +'														<td><p class="editText">真实姓名</p></td>'
			            +'														<td><input class="editInput" type="text" name="realName" value="'+realName+'"/></td>'
			            +'													</tr>'
			            +'													<tr>'
			            +'														<td><p class="editText">手机号码</p></td>'
			            +'														<td><input class="editInput" type="text" name="phone" value="'+phone+'"/></td>'
			            +'													</tr>'
			            /* +'													<tr>'
			            +'														<td>电子邮箱:</td>'
			            +'														<td><input type="text" name="email" value="'+email+'"/></td>'
			            +'													</tr>' */
			            +'													<tr>'
			            +'														<td><p class="editText">用户角色</p></td>'
			           /*  +'														<td><input type="text" name="role" value="'+role+'"/></td>' */
			            +'														<td><select class="editInput"  name="role">'
			            +roleSelect
			            +'													    </select></td>'
			            +'													</tr>'
			            +'													<tr>'
			            +'														<td><p class="editText">乐数老师</p></td>'
			           /*  +'														<td><input type="text" name="role" value="'+role+'"/></td>' */
			            +'														<td><select class="editInput" name="teacher">'
			            +teacherSelect
			            +'													    </select></td>'
			            +'													</tr>'
			            +'													<tr>'
			            +'														<td><p class="editText">学员级别</p></td>'
			            +'														<td><select class="editInput"  name="level">'
			            +levelSelect
			            +'													    </select></td>'
			            +'													</tr>'
			            +'												    <tr>'
			            +'													    <td><p class="editText">注册时间</p></td>'
			            +'													    <td align="left" class="tdText" >'
			            +'													    	<input class="editInput"  name="registerDate" type="date" id="registerDate" required  value="'+registerDate+'">'
			            +'													    </td>'
			            +'												    </tr>'
			            +'												    <tr>'
			            +'												        <td><p class="editText">确认注册</p></td>'
			            +'												        <td  align="left" class="tdText">'
			            +'												        	<input class="radioInput" type="radio" name="isRegistered" value="true"  '+(IsRegistered=="true"?'checked="checked"':'')+' /><span class="radioText">是</span><input class="radioInput" type="radio" name="isRegistered" '+(IsRegistered!="true"?'checked="checked"':'')+' value="false"/><span class="radioText">否</span>'
			            +'												        </td>'
			            +'												    </tr> '
			            +'												    <tr>'
			            +'												        <td><p class="editText">聊天组</p></td>'
			            +'												        <td  align="left" class="tdText">'
			            +'												        	<input class="radioInput" type="radio" name="isActived" value="true"  '+(IsActived=="true"?'checked="checked"':'')+' /><span class="radioText">是</span><input class="radioInput" type="radio" name="isActived" '+(IsActived!="true"?'checked="checked"':'')+' value="false"/>否'
			            +'												        </td>'
			            +'												    </tr> '
			            +'												    <tr>'
			            +'												        <td><p class="editText">消息推送</p></td>'
			            +'												        <td  align="left" class="tdText">'
			            +'												        	<input class="radioInput" type="radio" name="isAuthenticated" value="true"  '+(IsAuthenticated=="true"?'checked="checked"':'')+' /><span class="radioText">是</span><input class="radioInput" type="radio" name="isAuthenticated" '+(IsAuthenticated!="true"?'checked="checked"':'')+' value="false"/><span class="radioText">否</span>'
			            +'												        </td>'
			            +'												    </tr> '
			            +'												    <tr>'
			            +'												        <td><p class="editText">后台管理</p></td>'
			            +'												        <td  align="left" class="tdText">'
			            +'												        	<input class="radioInput" type="radio" name="isAdmin" value="true"  '+(isAdmin=="true"?'checked="checked"':'')+' /><span class="radioText">是</span><input class="radioInput" type="radio" name="isAdmin" '+(isAdmin!="true"?'checked="checked"':'')+' value="false"/><span class="radioText">否</span>'
			            +'												        </td>'
			            +'												    </tr> '
/* 			            +'												    <tr>'
			            +'												        <td><p class="editText">短讯组</p></td>'
			            +'												        <td  align="left" class="tdText">'
			            +'												        	<input class="radioInput" type="radio" name="isSmsTeam" value="true"  '+(isSmsTeam=="true"?'checked="checked"':'')+' /><span class="radioText">是</span><input class="radioInput" type="radio" name="isSmsTeam" '+(isSmsTeam!="true"?'checked="checked"':'')+' value="false"/><span class="radioText">否</span>'
			            +'												        </td>'
			            +'												    </tr> ' */
			            +'												 </table>'
			            +'												 </form>'
			            +'												 <button class="btnAthena EbtnLess" style="background-color:#20b672;margin-left: 90px;margin-top:15px;" id="updateUserInfoBtn">确定</button>');
				$("#updateUserInfoBtn").click(function(){
					var isRegistered = $("input[name='isRegistered']:checked").val();
					var registerDate = $("#registerDate").val();
					if(isRegistered==null || registerDate==null){
						swal("修改信息失败", "请输入正确的信息", "error");
					}
					var datas=$("#atest").serialize();
					$.ajax({
						url:"../updateUserInfo",
						data:datas,
						type:"POST",
						dataType:"json",
						contentType: "application/x-www-form-urlencoded; charset=UTF-8",
						cache:false,
						async:false,
						success:function(result) {
							if(result){
								swal("更改成功!", "恭喜!", "success"); 
								hideBouncePanel();
								getMDLUserLists();
							} else {
								swal("更改失败!", "请填写正确的信息.", "error");
							}
						}
					});
				});
			}
		}
	});
}
function showLogoPanel(index){
	showCommonPanel();
	var thisLogo=LogoData[index];
	var Slide1="",Slide2="",Slide3="";
	if(thisLogo.slide!=null){
		Slide1=thisLogo.slide[0];
		Slide2=thisLogo.slide[1];
		Slide3=thisLogo.slide[2];
	}
	$("body").append('<div id="LogoEditPart" class="bouncePart" style="position:fixed;z-index:999;top:100px;width:80%;margin-left:10%;"><legend>LOGO编辑</legend><div style="margin-top:0px;margin-bottom: -20px;background-color:#fff;">'
			+'<form id="callUpdateClientMeta" >'
			+'<table style="margin-left:auto;margin-right:auto; id="logoEdit">'
			+'	<tr>'
			+'		<td>Logo的url：<input name="ClientCode" type="hidden" value="'+thisLogo.clientStockCode+'"/></td>'
			+'		<td><input name="ClientLogo" type="text" style="width:150px;"  value="'+thisLogo.clientLogo+'"/></td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td>公司名称：</td>'
			+'		<td><input name="ClientName" type="text" style="width:150px;"  value="'+thisLogo.clientName+'"/></td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td>部门名称：</td>'
			+'		<td><input name="ClientSubName" type="text" style="width:150px;" value="'+thisLogo.clientSubName+'"/></td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td>版权归属：</td>'
			+'		<td><input name="ClientCopyRight" type="text" style="width:150px;" value="'+thisLogo.clientCopyRight+'"/></td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td>主题颜色：</td>'
			+'		<td><input name="ClientThemeColor" type="text" style="width:150px;" value="'+thisLogo.clientThemeColor+'"/></td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td>幻灯片url1：</td>'
			+'		<td><input name="Slide1" type="text" style="width:150px;" value="'+Slide1+'"/></td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td>幻灯片url2：</td>'
			+'		<td><input name="Slide2" type="text" style="width:150px;" value="'+Slide2+'"/></td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td>幻灯片url3：</td>'
			+'		<td><input name="Slide3" type="text" style="width:150px;" value="'+Slide3+'"/></td>'
			+'	</tr>'
			+'	<tr>'
			+'		<td>短讯通知：</td>'
            +'												        <td  align="left" class="tdText">'
            +'												        	<input type="radio" name="SmsSwitch" value="true"  '+(thisLogo.smsSwitch=="true"?'checked="checked"':'')+' />是&nbsp;&nbsp;&nbsp;<input type="radio" name="SmsSwitch" '+(thisLogo.smsSwitch!="true"?'checked="checked"':'')+' value="false"/>否'
            +'												        </td>'
            +'	</tr>'
			+'	<tr>'
			+'		<td colspan="2" style="text-align: center; padding: 0px;">	'
			+'			<button class="btnAthena EbtnLess" style="padding: 0px;margin-top:25px;background-color:'+clientThemeColor+';" id="submit_button" onclick="">保存</button>												'
			+'		</td>'
			+'	</tr>'
			+'</table>'
			+'</form>'
			+'							</div>');
	$('#submit_button').click(function(){
		jQuery.ajax({
			type : "GET",
			url : "../callUpdateClientMeta",
			data : $('#callUpdateClientMeta').serialize(),
			cache : false,
			success : function(data) {
				if(data=="true"){
					swal("恭喜！", "LOGO信息修改成功!", "success"); 
					window.location.reload();
				}
				else{
					swal("LOGO信息修改失败!", "服务器出异常了", "error"); 	
				}
			}
		});
	});
	$('#LogoEditPart').addClass('form-horizontal bounceInDown animated').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
	      $(this).removeClass("bounceInDown animated");
	    });
}
function showCommonPanel()
{
	$("body").append("<div  id='data_model_div' style='z-index:999;height:100000px'  class='dataModelPanel'><img onclick='hideBouncePanel()' src='http://leshu.bj.bcebos.com/icon/EXIT1.png' style='width: 30px; height: 30px;position:absolute;top:20px;left:20px;' />	<img style='position:absolute;top:8px;right:20px;' class='HpLogo' src='"+HpLogoSrc+"' alt='Logo' class='HpLogo'><div style='width:100%;height:4px;background:"+clientThemeColor+";position:absolute;top:70px;'></div></div>");
	$('#data_model_div').removeClass().addClass('panelShowAnmitation').one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
	      $(this).removeClass();
	    }); }
function hideBouncePanel()
{
	$("body").find(".bouncePart").remove();
	$("body").find("#data_model_div").remove();
	}
function getVisitPage() {
	jQuery.ajax({
		type : "GET",
		url : "../QueryVisitPage",
		data : {},
		cache : false,
		success : function(data) {
			var jsons = data;
			var ul="";
			likePageNum=0;
			for (var i = 0; i < jsons.length; i++) {
				var temp=jsons[i];
				 var priceColor="lose";
				 var tag='';
				 var attention='';
				 var priceStyle='';
				 var onclick='';
				 var unit='<span class="price2"></span><span class="unit"></span>';
				 if(temp.attention=="1"){
					 tag='<span class="tag2">已关注</span>';
					 attention='attention';
					 likePageNum++;
				 }
				 var li='<li class="singleQuote">'
					 +'	<div class="firstLayer '+attention+'">'
					 +'		<div class="quoteTitle"><span class="id" style="display:none;">'+temp.realName+'</span><span class="item2" '+onclick+'>'+temp.descName+'</span>'+tag+'</div>'
					 +'		<div class="quotePrice '+priceColor+'" '+priceStyle+'>'+unit+'</div>'
					 /*  +'		<span class="change high">+10</span>' */
					 +'		<span class="recommendArea" style="display:none;"></span>'
					 +'		<div class="clear"></div>'
					 +'	</div>'
					 +'</li>'; 
				if(tag==''){
					ul+=li;
				}else{
					ul=li+ul;
				}
			}
			 $("#visit_div").html(ul);
		}
	});
}
function getLogoLists() {
	jQuery.ajax({
				type : "GET",
				url : "../QueryClientMetaList",
				data : {},
				cache : false,
				success : function(data) {
					var jsons = data;
					var ul = "",regNumber=0;
					ul='<div class="Work_Mates_div_list_div2">'
						+'							<span class="total_num">总数：'+jsons.length+'</span>'
						+'							<div class="clear"></div>'
						+'						</div>';
					LogoData=jsons;
					for (var i = 0; i < jsons.length; i++) {
					var temp=jsons[i];
					var buttonText;
					if(temp.clientActive=='Y'){
						buttonText='							<div style="float: right; margin-top: -80px; background-color: #777; color: #fff; font-weight:bold; font-size: 13px; padding: 3px;width:50px;text-align:center;border-radius:6px;">'
							+'								应用中'
							+'							</div>';
						clientThemeColor=temp.clientThemeColor;
						$(document).attr("title",temp.clientStockCode+" - "+$(document).attr("title"));//修改title值  
						$('span.clientCopyRight').text('©'+temp.clientCopyRight);
						HpLogoSrc=temp.clientLogo;
					/* 	$('#logo_now').html('<img'
								+'				src="'+temp.clientLogo+'"'
								+'				alt="Logo" class="HpLogo"'
								+'				style="display: inline !important; height: 30px; float: none; padding: 0px; vertical-align: bottom;"><span'
								+'				class="clientSubName"'
								+'				style="font-size: 12px; padding-left: 7px; color: #333;">'+temp.clientSubName+'</span>'
								+'				<h1 style="color: #333; font-size: 18px;" class="clientName">'+temp.clientName+'</h1>');
						$('#logo_now_color').css('border-color',temp.clientThemeColor); */
					}else{
						buttonText='<div style="float: right; margin-top: -80px; background-color: #0197D6; color: #fff; font-weight:bold; font-size: 13px; padding: 3px;width:50px;text-align:center;border-radius:6px;" onclick="updateLogo(\''+temp.clientStockCode+'\')">'
							+'								应用'
							+'							</div>';
					}
						var li='<div class="Work_Mates_div_list_div2" style="padding-bottom:0px !important;">'
		+'							<img'
		+'								src="'+temp.clientLogo+'"'
		+'								alt="Logo" class="HpLogo"'
		+'								style="display: inline !important; height: 30px;padding-left:0px !important;margin-left:0px !important;vertical-align: bottom;"><span'
		+'								class="clientSubName"'
		+'								style="font-size: 12px; padding-left: 7px; color: #333;">'+temp.clientSubName+'</span>'
		+'							<h1 style="color: #333; font-size: 18px;padding-left:0px;" class="clientName">'+temp.clientName+'</h1>'
	//	+'<hr style="border:2px solid '+temp.clientThemeColor+';width:75%;padding:0px;margin-top:0px;">'
		+'							<p style="font-size:10px;margin-bottom:3px;margin-top:-3px;">©'+temp.clientCopyRight+'</p>'
		+buttonText
		+'							<div style="float: right; margin-top: -50px; background-color: #20b672; color: #fff; font-weight:bold; font-size: 13px; padding: 3px;width:50px;text-align:center;border-radius:6px;" onclick="showLogoPanel('+i+')">'
		+'								编辑'
		+'							</div>'
		+'							<div class="clear"></div>'
		+'						</div>';
		ul+=li;
					}
					$("#Logo_div").html(ul);
				}
			});
}
function updateLogo(id){
	jQuery.ajax({
		type : "GET",
		url : "../ActivaeClientMeta",
		data : {clientCode:id},
		cache : false,
		success : function(data) {
			if(data=="true"){
				swal("恭喜！", "网站LOGO替换成功!", "success"); 
				window.location.reload();
			}
			else{
				swal("网站LOGO替换失败!", "服务器出异常了", "error"); 	
			}
		}
	});
}
function getMDLUserLists() {
jQuery
	.ajax({
		type : "GET",
		url : "../userProfile/getMDLUserLists",
		data : {},
		cache : false,
		success : function(users) {
			var ul = "",regNumber=0;
			var RoleNum=new Object(),noRoleNum=0;
			for (var i = 0; i < users.length; i++) {
				var temp = users[i];
				var selfIntro=temp.selfIntro;
				var role;
				try{
				 	role=RoleObj[temp.role];
				 	if(RoleNum[temp.role]==null||RoleNum[temp.role]==undefined){
				 		RoleNum[temp.role]=1;
				 	}else{
				 		RoleNum[temp.role]++;
				 	}
				}catch(e){
					noRoleNum++;
				}
				var workDay=temp.workDay;
				var tag=temp.tag;
				var phone=temp.phone;
				var tagHtml="";
				var congratulate="";
				
				if(temp.openid==$('#uid').val()){
					LastToLikeDate=temp.like.lastLikeDate;
					lastLikeTo=temp.like.lastLikeTo;
				}

				
				
				if(selfIntro==null||selfIntro=='null'){
					selfIntro="nothing";
				}else{
					if(selfIntro.length>10){
						selfIntro=(selfIntro.substr(0,12)+'...');
					}
				}
				if(role==null||role=='null'){
					role="";
				}
				/* if(tag!=null&&tag!='null'){
					for(var j=0;j<tag.length&&j<4;j++){
						for (var key in tag[j]) { 
							tagHtml+='													<div class="tag">'
							+key
							+'													</div>';
						}
					}
				} */
				
				 if(phone!=null&&phone!='null'&&phone!=''){
					 tagHtml+='													<div class="tag"><a href="tel:'+phone+'" style="color:#fff;">'
							+'TEL:'+phone
							+'													</a></div>';
				 }
				if(workDay==null||workDay=='null'||workDay==0){
					workDay="";
				}else{
					regNumber++;
					workDay='<div style="float:right;margin-top:-45px;background-color:#eee;color:#333;font-size:13px;padding:3px;">'+workDay+' Days</div>';
					if(temp.IsRegistered!="true"){
						workDay='<div style="float:right;background-color:#eee;color:red;font-size:13px;padding:3px;margin-right:5px;position:relative;margin-top:-28px;opacity:0.85;">待审核</div>';
					}
				}
				var lastUpdatedDate="暂无互动";
				if(temp.lastUpdatedDate!=null&&temp.lastUpdatedDate!='null'){
					lastUpdatedDate=temp.lastUpdatedDate.substring(0,10);
				}
				
				if(temp.level!=null){
					var levelText;
					if(temp.level=='basic'){levelText='启蒙';}
					if(temp.level=='primary'){levelText='初级';}
					if(temp.level=='middle'){levelText='中级';}
					if(temp.level=='high'){levelText='高级';}
					congratulate='<div style="float:right;">'
						+ '<span style="font-size:12px;color:#07090B;font-weight:normal;">'+levelText+'</span><div>';
				}
				var li='	<li class="Work_Mates_div_list_div2">'
					+'                                           	 	<div class="Work_Mates_img_div2"  style="margin-top:-10px;margin-bottom:-20px;">'
					+'                                        			 <img src="'
					+ temp.headimgurl
					+ '" alt="userImage" class="matesUserImage" alt="no_username"/> '
					+'<p style="margin: 0 0 10px;font-size: 12px;text-align: center;color: #375FA7;margin-top: -5px;">'+lastUpdatedDate+'</p>'
					+'                                         		</div>'
					+'                                         		<div class="Work_Mates_text_div">'
					+'                                        			 <h2><span class="name">'
					+ temp.nickname
					+ '</span><span class="role">'
					+role+'</span><span style="display:none;" class="openid">'
					+temp.openid+'</span>'
					+congratulate
					+'</h2>'
					+ '<div>'
					+tagHtml
					+'<br/>'
					+'													<span class="selfIntro">'+selfIntro+'</span>'
					+'												</div>'
					+'                                        		</div>'
					+workDay
					+'                                                <div class="clear"></div>'
					+'                                          </li>';
				ul += li;
			}
			$("#Work_Mates_div").html(ul);
			
			var data=[];
			noRoleNum=users.length;
			for(var i=0;i<RoleList.length;i++){
				data[i]=new Object();
				data[i]["value"] = (RoleNum[RoleList[i].id]==undefined?0:RoleNum[RoleList[i].id]) ;
				data[i]["label"]=RoleList[i].name +":"+data[i]["value"]+"人";
				noRoleNum=noRoleNum-data[i]["value"];
			}
			data[RoleList.length]=new Object();
			data[RoleList.length]["value"]=noRoleNum;
			data[RoleList.length]["label"]='未分类:'+noRoleNum+'人';
			
			FusionCharts.ready(function(){
			    var revenueChart = new FusionCharts({
			        type: 'doughnut2d',
			        renderAt: 'chart-container',
			        width: '350',
			        height: '400',
			        dataFormat: 'json',
			        dataSource: {
			            "chart": {
			                "caption": "",
			                "subCaption": "",
			                "numberSuffix": "人",
			                "paletteColors": "#8e0000,#8e7080,#0075c2,#1aaf5d,#f2c500,#f45b00",
			                "bgColor": "#ffffff",
			                "showBorder": "0",
			                "use3DLighting": "0",
			                "showShadow": "0",
			                "enableSmartLabels": "0",
			                "startingAngle": "310",
			                "showLabels": "0",
			                "showPercentValues": "1",
			                "showLegend": "1",
			                "legendShadow": "0",
			                "legendBorderAlpha": "0",
			                "defaultCenterLabel": "共"+users.length+"人",
			                "centerLabel": " $label",
			                "centerLabelBold": "1",
			                "showTooltip": "0",
			                "decimals": "0",
			                "captionFontSize": "14",
			                "subcaptionFontSize": "14",
			                "subcaptionFontBold": "0"
			            },
			            "data": data,
			            "events": { 
			                "beforeLinkedItemOpen": function(eventObj, dataObj) { 
			                    console.log(eventObj);
			                    console.log(dataObj);
			                }
			            }
			        }
			    }).render();
			});
			
			
			
		}
	});
}

</script>
<title>微管理</title>
</head>
<body style="padding: 0px !important; margin: 0px;">
	<div class="navbar-inner" style="background-color: #fff !important;">
		<div class="container-fluid">
			<!-- <a style="float: left; padding-top: 10px;" id="logo_now"><img src="https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000E9IMj&amp;oid=00D90000000pkXM" alt="Logo" class="HpLogo" style="display: inline !important; height: 30px; float: none; padding: 0px; vertical-align: bottom;"><span class="clientSubName" style="font-size: 12px; padding-left: 7px; color: #333;">MDM China</span>				<h1 style="color: #333; font-size: 18px;" class="clientName">DXC Technology Coperation</h1></a>
			 -->
			 <a style="float: left; padding-top: 10px;" id="logo_now"><img src="http://leshu.bj.bcebos.com/standard/leshuLogo.png" alt="Logo" class="HpLogo" style="display: inline !important; height:50px; float: none; padding: 0px; vertical-align: bottom;">				</a>
			 <div class="clear"></div>
			<ul class="nav pull-right top-menu" style="margin-top: -70px;display:none;">
				<li class="dropdown"><a href="#" class="dropdown-toggle"
					data-toggle="dropdown"
					style="font-size: 15px; margin: 0px; padding: 5px 0px;">
						Welcome <span class="username colorBlue" id="username">
							青青～笑 </span>
				</a> <span><a style="float: right;"> <img id="userImage"
							src="http://wx.qlogo.cn/mmopen/3ial0wgAS7u1sBkjFnq8CKfTlENtrYZvREwEhPMmu5FvHbDrYITooGLlmXszwNTVppJTc1ZCeyibZAqpviasUOmYqg4cfLr7lX8/0"
							alt="userImage" class="userImage" onclick="register()">
					</a></span></li>
			</ul>
		</div>
	</div>
	<div class="TABclass">
		<div id="logo_now_color" style="border-top: 4px solid #20b672; padding: 5px 0px;">
			<ul class="nav nav-tabs" id="myTabs"
				style="border-color: #20b672;">
				<li  class="active"><a href="#WorkMates" data-toggle="tab"
					style="border-right-color: #20b672; border-top-color: #20b672; border-left-color: #20b672;">人员管理</a></li>
				<li><a href="#visitManage" data-toggle="tab"
					style="border-right-color: #20b672; border-top-color: #20b672; border-left-color: #20b672;">到访管理</a></li>
				<li><a href="#logoElements" data-toggle="tab"
					style="border-right-color: #20b672; border-top-color: #20b672; border-left-color: #20b672;">LOGO管理</a></li>
			</ul>
			<div class="tab-content" id="dvTabContent"
				style="border: 0px; padding-top: 0px;margin-top:0px;">
				<div class="tab-pane" id="logoElements">
					<!-- start logoElements-->
					<div class="Work_Mates_div2" id="Logo_div">
					</div>
					<!-- end logoElements-->
				</div>
				<div class="tab-pane" id="visitManage">
					<!-- start visitManage-->
					<ul id="visit_div" style="width:100%;margin-left:-15px;">
					</ul>
					<!-- end logoElements-->
				</div>
				<div class="tab-pane  active" id="WorkMates">
<!-- 				<img id="refreshUser"  src="http://leshu.bj.bcebos.com/icon/refresh2.png" style="height:25px;float:right;margin-top:8px;margin-left:15px;"/>
 -->					<img id="syncUser"  src="http://leshu.bj.bcebos.com/icon/sync.png" style="height:30px;float:right;margin-top:7px;"/>
					<div id="chart-container" style="margin-left:auto;margin-right:auto;text-align:center;"></div>
					
					
					<div  style="position: absolute; top: 540px;overflow:hidden" data-role="page" style="padding-top:45px" data-theme="c">
						<ul id="Work_Mates_div" class="Work_Mates_div2"  data-role="listview" data-autodividers="false" data-filter="true" data-filter-placeholder="输入关键字" data-inset="true" style="margin-top:15px">
						</ul>
					</div>
					<div id="return-top" style="display: block;"><img class="scroll-top"  src="http://leshu.bj.bcebos.com/icon/upgrade.png"  alt="" width="50px"></div>
				</div>
			</div>
		</div>
	</div>
	
<!-- BEGIN FOOTER -->
	<div id="footer">
		<span class="clientCopyRight"><nobr></nobr></span>
	</div>
	<!-- END FOOTER -->
</body>
</html>