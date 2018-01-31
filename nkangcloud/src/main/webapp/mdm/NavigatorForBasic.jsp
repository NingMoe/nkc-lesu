<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.OAuthUitl.SNSUserInfo,java.lang.*"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%

String ticket=RestUtils.getTicket();
SNSUserInfo user = (SNSUserInfo)request.getAttribute("snsUserInfo"); 
System.out.println("snsUserInfo----"+user.getOpenId()+"---img---"+user.getHeadImgUrl());
String uid = request.getParameter("UID"); 
String originalUid = uid;
if(request.getParameter("UID")==null&&request.getParameter("UID")==""){
	originalUid=(String)request.getAttribute("state"); 
}
String name = "";
String headImgUrl ="";
String myuid="";
String openid="";
if(null != user) {
	openid=user.getOpenId();
	HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(user.getOpenId());
	if(res!=null){
		if(res.get("HeadUrl")!=null){
			myuid = user.getOpenId();
			headImgUrl=res.get("HeadUrl");
		}else{
			headImgUrl = user.getHeadImgUrl(); 
		}
		if(res.get("NickName")!=null){
			myuid = user.getOpenId();
			name=res.get("NickName");
			user.setNickname(name);
		}else{
			name = user.getNickname();
			headImgUrl = user.getHeadImgUrl(); 
			myuid="oO8exvz-DZOu8wc0f81v9EHYq2HE";
		}
	}else{
		name = user.getNickname();
		headImgUrl = user.getHeadImgUrl(); 
		//myuid="oO8exvz-DZOu8wc0f81v9EHYq2HE";
	}
	SimpleDateFormat  format = new SimpleDateFormat("yyyy-MM-dd"); 
	Date date=new Date();
	String currentDate = format.format(date);
	if(openid.equals(originalUid)){
		MongoDBBasic.updateVisited(user.getOpenId(),currentDate,"NavigatorForBasic",user.getHeadImgUrl(),name);
	}
	else
	{
		MongoDBBasic.updateVisited(user.getOpenId(),currentDate,"NavigatorForBasic",user.getHeadImgUrl(),name);
		HashMap<String, String> resOriginal=MongoDBBasic.getWeChatUserFromOpenID(originalUid);
		MongoDBBasic.updateShared(originalUid,currentDate,"NavigatorForBasic",user.getHeadImgUrl(),name,resOriginal.get("HeadUrl"),resOriginal.get("NickName"));
		}
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8" />
<title>乐数-练习参数</title>
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<link rel="stylesheet" type="text/css"
	href="../Jsp/JS/leshu/bootstrap.min.css" />
<link href="../Jsp/JS/leshu/font-awesome/css/font-awesome.min.css"
	rel="stylesheet">
<link rel="stylesheet" type="text/css"
	href="http://www.jq22.com/jquery/jquery-ui-1.11.0.css">
<link rel="stylesheet"
	href="../Jsp/JS/speedTab/jquery-ui-slider-pips.min.css" />
<script src="../Jsp/JS/speedTab/jquery-plus-ui.min.js"></script>
<script src="../Jsp/JS/speedTab/jquery-ui-slider-pips.js"></script>
<script src="../Jsp/JS/speedTab/examples.js"></script>
<link rel="stylesheet" href="../Jsp/JS/speedTab/app.min.css" />
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css" />
<script src="../MetroStyleFiles/sweetalert.min.js"></script>
<script src="http://www.jq22.com/jquery/jquery-1.10.2.js"></script>
<link rel="stylesheet" type="text/css" href="../Jsp/JS/leshu/custom.css" />
<link rel="stylesheet" type="text/css" href="../Jsp/JS/progressBar/number-pb.css">
<script type="text/javascript" src="../Jsp/JS/progressBar/jquery.velocity.min.js"></script>
<script type="text/javascript" src="../Jsp/JS/progressBar/number-pb.js"></script>
<script src="../Jsp/JS/leshu/custom.js"></script>
<link rel="stylesheet" type="text/css"
	href="../Jsp/JS/scrollMenu/funnyNewsTicker.css">
<script type="text/javascript"
	src="../Jsp/JS/scrollMenu/funnyNewsTicker.js"></script>
	<script type="text/javascript" src="../Jsp/JS/jquery.sha1.js"></script>
<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.2.0.js"></script>
<script type="text/javascript">
var url = window.location.href;
if(url.indexOf('#')!=-1){
	url=url.substr(0,(url.indexOf('#')-1));
}
var string1='jsapi_ticket=<%=ticket%>'
	+'&noncestr=Wm3WZYTPz0wzccnW&timestamp=1414587457&url='+url;
var signature=$.sha1(string1);
wx.config({
        debug: false,
        appId: '<%=Constants.APP_ID%>'+'',
        timestamp: 1414587457,
        nonceStr: 'Wm3WZYTPz0wzccnW'+'',
        signature: signature+'',
        jsApiList: [
            // 所有要调用的 API 都要加到这个列表中
            'checkJsApi',
            'onMenuShareTimeline',
            'onMenuShareAppMessage',
            'onMenuShareQQ',
            'onMenuShareWeibo'
          ]
    });
 wx.ready(function () {
	  wx.checkJsApi({
            jsApiList: [
                'getLocation',
                'onMenuShareTimeline',
                'onMenuShareAppMessage'
            ],
            success: function (res) {
               // alert(JSON.stringify(res));
            }
     }); 
	  var date = new Date();
	    var seperator1 = "-";
	    var month = date.getMonth() + 1;
	    var strDate = date.getDate();
	    if (month >= 1 && month <= 9) {
	        month = "0" + month;
	    }
	    if (strDate >= 0 && strDate <= 9) {
	        strDate = "0" + strDate;
	    }
	    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate;
	            
   //  var shareTitle="乐数在线测试("+currentdate+")";
    var shareTitle="乐数看听闪算擂台开擂了";
     var shareDesc="乐数小擂台欢迎来挑战！看算闪算听算随时恭候";
     var shareImgUrl="http://leshucq.bj.bcebos.com/standard/leshuLogo2.jpg";
	//----------“分享给朋友”
     wx.onMenuShareAppMessage({
         title: shareTitle, // 分享标题
         desc: shareDesc, // 分享描述
         link: url, // 分享链接
         imgUrl: shareImgUrl, // 分享图标
         type: '', // 分享类型,music、video或link，不填默认为link
         dataUrl: '', // 如果type是music或video，则要提供数据链接，默认为空
         success: function () { 
             // 用户确认分享后执行的回调函数、
             //alert("用户成功分享了该网页");
         },
         cancel: function () { 
             // 用户取消分享后执行的回调函数
             //alert("用户取消了分享");
         },
         fail: function (res) {
             alert(JSON.stringify(res));
         }
     });
     //------------"分享到朋友圈"
     wx.onMenuShareTimeline({
         title: shareTitle, // 分享标题
         link:url, // 分享链接
         imgUrl: shareImgUrl, // 分享图标
         success: function () { 
             // 用户确认分享后执行的回调函数
             //alert("用户成功分享了该网页");
         },
         cancel: function () { 
             // 用户取消分享后执行的回调函数
             //alert("用户取消了分享");
         },
         fail: function (res) {
             alert(JSON.stringify(res));
         }
     });
     wx.error(function(res){
         // config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
         alert("errorMSG:"+res);
     });
 });
</script>
	
<style type="text/css">
#show-bi-slider-result {
	height: 100px;
}

#show-bi-slider {
	margin-top: 100px;
}

.margin-left {
	margin-left: 100px;
}

.margin-right {
	margin-right: 10px;
}

#speedAjust,#menuPanel,#lengthCountPanel,#numCountPanel,#questionTypePanel
	{
	display: none;
}


li{
position: relative;
    width: 99%;
    margin-left: 1%;
    height: 45px!important;
    list-style: none;
    border-radius: 10px;
    background: rgba(34,178,111,1);
    margin-bottom: 10px;}
.gk{   
	width: 100%;
    height: 30px;
    line-height: 30px;
    font-size: 14px;
    color: white;
    text-align: left;
}

ul{
margin: 0!important;
    width: 95%;
    position: relative;
    left: 2%;
 margin-bottom: 5px;
 }
.hiddenLevel,.hiddenLevelNumber
{
display:none;
}

</style>
</head>
<body>
<div id="data_model_div" style="height: 100px">
		<i class="icon" style="position: absolute;top: 25px;z-index: 100;right: 20px;">
			<!-- <img class="exit" src="http://leshu.bj.bcebos.com/icon/EXIT1.png"
			style="width: 30px; height: 30px;"> -->
<div style="width: 30px;height: 30px;float: left;border-radius: 50%;overflow: hidden;">
<img class="exit" src="<%=user.getHeadImgUrl() %>" style="width: 30px; height: 30px;" />
</div>
<span style="position: relative;top: 8px;left: 5px;"><%=user.getNickname() %></span>
		</i> <img style="position: absolute;top: 8px;left: 10px;z-index: 100;height: 60px;" class="HpLogo" src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" alt="Logo">
		<div style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
	<section id="levelMenuPanel">
		<div class="selectPanel" style="padding: 0; height: 1000px;">
				<ul>
					<li>
						<div class="gk">【第一关】 1-5直加直减</div>
						<span class="hiddenLevel">第一关</span>
						<span class="hiddenLevelNumber">1</span>
						<div class="number-pb" id="process1">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第二关】1-9直加直减</div>
						<span class="hiddenLevel">第二关</span>
						<span class="hiddenLevelNumber">2</span>
						<div class="number-pb" id="process2">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第三关】1的满5破5</div>
						<span class="hiddenLevel">第三关</span>
						<span class="hiddenLevelNumber">3</span>
						<div class="number-pb" id="process3">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第四关】2的满5破5</div>
						<span class="hiddenLevel">第四关</span>
						<span class="hiddenLevelNumber">4</span>
						<div class="number-pb" id="process4">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第五关】3的满5破5</div>
						<span class="hiddenLevel">第五关</span>
						<span class="hiddenLevelNumber">5</span>
						<div class="number-pb" id="process5">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第六关】4的满5破5</div>
						<span class="hiddenLevel">第六关</span>
						<span class="hiddenLevelNumber">6</span>
						<div class="number-pb" id="process6">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第七关】 满5破5综合练习</div>
						<span class="hiddenLevel">第七关</span>
						<span class="hiddenLevelNumber">7</span>
						<div class="number-pb" id="process7">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第八关】 两位数直加直减</div>
						<span class="hiddenLevel">第八关</span>
						<span class="hiddenLevelNumber">8</span>
						<div class="number-pb" id="process8">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
			
					</li>
					<li>
						<div class="gk">【第九关】1的进退位</div>
						<span class="hiddenLevel">第九关</span>
						<span class="hiddenLevelNumber">9</span>
						<div class="number-pb" id="process9">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第十关】 2的进退位</div>
						<span class="hiddenLevel">第十关</span>
						<span class="hiddenLevelNumber">10</span>
						<div class="number-pb" id="process10">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
					
						<div class="gk">【第十一关】 3的进退位</div>
						<span class="hiddenLevel">第十一关</span>
						<span class="hiddenLevelNumber">11</span>
						<div class="number-pb" id="process11">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第十二关】4的进退位</div>
						<span class="hiddenLevel">第十二关</span>
						<span class="hiddenLevelNumber">12</span>
						<div class="number-pb" id="process12">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第十三关】 5的进退位</div>
						<span class="hiddenLevel">第十三关</span>
						<span class="hiddenLevelNumber">13</span>
						<div class="number-pb" id="process13">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第十四关】 6的进退位</div>
						<span class="hiddenLevel">第十四关</span>
						<span class="hiddenLevelNumber">14</span>
						<div class="number-pb" id="process14">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第十五关】 7的进退位</div>
						<span class="hiddenLevel">第十五关</span>
						<span class="hiddenLevelNumber">15</span>
						<div class="number-pb" id="process15">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第十六关】 8的进退位</div>
						<span class="hiddenLevel">第十六关</span>
						<span class="hiddenLevelNumber">16</span>
						<div class="number-pb" id="process16">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第十七关】 9的进退位</div>
						<span class="hiddenLevel">第十七关</span>
						<span class="hiddenLevelNumber">17</span>
						<div class="number-pb" id="process17">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第十八关】 一位数综合练习5笔</div>
						<span class="hiddenLevel">第十八关</span>
						<span class="hiddenLevelNumber">18</span>
						<div class="number-pb" id="process18">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第十九关】一位数综合练习8笔</div>
						<span class="hiddenLevel">第十九关</span>
						<span class="hiddenLevelNumber">19</span>
						<div class="number-pb" id="process19">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
					<li>
						<div class="gk">【第二十关】 一位数综合练习10笔</div>
						<span class="hiddenLevel">第二十关</span>
						<span class="hiddenLevelNumber">20</span>
						<div class="number-pb" id="process20">
							<div class="number-pb-shown"></div>
							<div class="number-pb-num" style="left: 85%;">0%</div>
						</div>
					</li>
				</ul>
		</div>

	</section>
	<section class="sub-block" id="speedAjust">

		<div class="tabs-content">
			<div class="cont" src/main/webapp/MetroStyleFiles"ent
				active" id="show-rest-slider-result">
				<div id="show-rest-slider"></div>
			</div>
			<i id="slowspeed" class="fa fa-bicycle fa-2x"
				style="float: left; margin-top: -60px; margin-left: 15px;"></i> <i
				id="fastspeed" class="fa fa-fighter-jet fa-2x"
				style="float: right; margin-top: -60px; margin-right: 15px;"></i>
		</div>

		<i id="backLM" class="fa fa-arrow-circle-left fa-5x margin-right"></i>
		<i id="toMenu" class="fa fa-arrow-circle-right fa-5x  margin-left"></i>
		<p style="line-height: 40px;">选择速度</p>
	</section>
	<section id="menuPanel">
		<div class="selectPanel">
			<div id="ks" class="circle">看算</div>
			<div id="ss" class="circle">闪算</div>
			<div id="ts" class="circle">听算</div>
		</div>
		<i id="backSpeed" class="fa fa-arrow-circle-left fa-5x"></i>
	</section>

	<script>
	var wrongCollection="";
	var speed=2;
	var category="第一关";
	var uid='<%=openid%>';
	var qt='question';
	var percent;
	var levelNumber = 1;
	var levelArray=new Array("第一关","第二关","第三关","第四关","第五关","第六关","第七关","第八关",
			"第九关","第十关","第十一关","第十二关","第十三关","第十四关","第十五关","第十六关",
			"第十七关","第十八关","第十九关","第二十关");
	
	function getAllLevelPercent(){
		for(var i=0;i<levelArray.length;i++){
			getLevelPercent(levelArray[i],i+1);
		}
	}
	$(document).ready(function(){
		getAllLevelPercent();

		
	$("#funnyNewsTicker1").funnyNewsTicker({width:"80%",timer:100000,titlecolor:"#FFF",itembgcolor:"#1faf6d",infobgcolor:"#1a935c",buttonstyle:"white",bordercolor:"#1a935c"});		


    $(".gk").on("click",function(){

    	category=$(this).parent("li").find(".hiddenLevel").text();
    	var text="";
    	var total=0;
    	$.ajax({
			type : "GET",
			url : "../AbacusQuiz/getAbacusQuizPoolBycategory",
			data : {
				category : category
			},
			cache : false,
			success : function(data) {
				if(data){
					total=data.length;

			    	$.ajax({
					type : "GET",
					url : "../AbacusQuiz/findHistoryQuizByOpenidAndCategory",
					data : {
						category : category,
						openid : uid
					},
					cache : false,
					success : function(data) {
						if(data&&data.questionSequence!=0&&data.questionSequence!=null){
							var answerArray=data.answers.split(",");
							var tempChar;
							var right=0;
							var wrong=0;
							var count=0;
							for(var i=0;i<answerArray.length;i++){
								if(answerArray[i]!='MISS'&&answerArray[i]!=""){
									count++;
									tempChar=answerArray[i].split("/");
									if(tempChar[2]!=0){
										right++;
									}
									else{
										wrong++;
									}
								}
							}
					    	text="<p style='width:40%;float:left;height:40px;line-height:40px;'><i class='fa fa-smile-o fa-3x' style='position: relative;bottom: 5px;'></i></p><input style='margin-top:0px;width:50%;height:35px;display:block;float:left;color: black;' type='text' value='"+right+"题' disabled='true'/>"
					        	+"<p style='width:40%;float:left;height:40px;line-height:40px;'><i onclick='wrongClick()' class='fa fa-frown-o fa-3x' style='position: relative;color: #F94082;bottom: 5px;'></i></p><input id='wrongQT' style='margin-top:0px;width:50%;height:35px;display:block;float:left;color: black;' type='text' value='"+wrong+"题' disabled='true'/>"
					        +"<p style='width:40%;float:left;height:40px;line-height:40px;'>总共完成：</p><input style='margin-top:0px;width:50%;height:35px;display:block;float:left;color: black;' type='text' value='"+count+"题' disabled='true'/>";

						}
						else
						{
							text="<p style='text-align:center;width:100%'>您还没开始做题呢~！</p>"
						}
					    swal({  
				            title:category+"【"+total+"题】",  
				            text:text,
				            html:"true",
				            showConfirmButton:true, 
				    		showCancelButton: true,   
				    		closeOnConfirm: false,  
				            confirmButtonText:"继续闯关",  
				            cancelButtonText:"我知道了",
				            animation:"slide-from-top"  
				          }, 
				    		function(inputValue){
				    			if (inputValue === false){
				    				return false;
				    			}
				    			else{

				    				$("#levelMenuPanel").hide();
				    				$("#speedAjust").show();
				    				$(".sweet-overlay").hide();
				    				$(".sweet-alert").hide();
				    			}});
					}
				});
				}
			}
		});


    });
	});	
	$("#backLM").on("click",function(){
	$("#levelMenuPanel").show();
	$("#speedAjust").hide();
	});

	  $(".exit").on("click",function(){
		  window.location.href="profile.jsp?UID="+uid;
	  });
	$("#toMenu").on("click",function(){
	$("#speedAjust").hide();
	$("#menuPanel").show();
	});
	$("#backSpeed").on("click",function(){
	$("#speedAjust").show();
	$("#menuPanel").hide();
	});
	$("#ss").on("click",function(){
		$(this).css("background-color","#22B26F");
	$(this).css("color","white");
	window.location.href="FlashNumberForBasic.jsp?category="+category+"&speed="+speed+"&UID="+uid+wrongCollection;
	});
	$("#ks").on("click",function(){
		$(this).css("background-color","#22B26F");
	$(this).css("color","white");
	window.location.href="ShowNumberForBasic.jsp?category="+category+"&speed="+speed+"&UID="+uid+wrongCollection;
	});
	$("#ts").on("click",function(){
		$(this).css("background-color","#22B26F");
	$(this).css("color","white");
	window.location.href="ListenNumberForBasic.jsp?category="+category+"&speed="+speed+"&UID="+uid+wrongCollection;
	});
	function wrongClick(){
		if($("#wrongQT").val()!="0题"){
		wrongCollection="&wrongCollection=yes";
		$("#levelMenuPanel").hide();
		$("#speedAjust").show();
		$(".sweet-overlay").hide();
		$(".sweet-alert").hide();
		}
	}
	window.wrongClick=wrongClick;
    function getLevelPercent(category,levelNumber){
    	var defaultTotal=0;
    	var complete=0;
    	$.ajax({
			type : "GET",
			url : "../AbacusQuiz/getAbacusQuizPoolBycategory",
			data : {
				category : category
			},
			cache : false,
			success : function(data) {
				if(data){
					defaultTotal=data.length;
			    	$.ajax({
					type : "GET",
					url : "../AbacusQuiz/findHistoryQuizByOpenidAndCategory",
					data : {
						category : category,
						openid : uid
					},
					cache : false,
					success : function(data) {

						if(data&&data.questionSequence!=0&&data.questionSequence!=null){
						var answerArray=data.answers.split(",");
						for(var i=0;i<answerArray.length;i++){
							if(answerArray[i]!='MISS'&&answerArray[i]!=""){
								complete++;
							}
						}
				    	percent=parseInt((complete/defaultTotal)*100);
				        var controlBar = $('#process'+levelNumber).NumberProgressBar({
				            duration: 5000,
				            percentage: percent
				          });   
					}
					}
			    	});
					
				}
			}
		});
    }
</script>
</body>
</html>