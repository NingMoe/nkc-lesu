<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.OAuthUitl.SNSUserInfo,java.lang.*"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.baseobject.ArticleMessage"%>
<%@ page import="com.nkang.kxmoment.baseobject.VideoMessage"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
String ticket=RestUtils.getTicket();
//获取由OAuthServlet中传入的参数
SNSUserInfo user = (SNSUserInfo)request.getAttribute("snsUserInfo"); 
String originalUid=request.getParameter("UID");
if(request.getParameter("UID")==null&&request.getParameter("UID")==""){
	originalUid=(String)request.getAttribute("state"); 
}
String name = "";
String phone = "";
String headImgUrl ="";
boolean isFollow=false;
String uid ="";
if(null != user) {
	//String uid = request.getParameter("UID");
	uid = user.getOpenId();
	name = user.getNickname();
	headImgUrl = user.getHeadImgUrl();
	HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(uid);
	if(res!=null){
		isFollow=true;
		if(res.get("HeadUrl")!=null){
			headImgUrl=res.get("HeadUrl");
		}
		if(res.get("NickName")!=null){
			name=res.get("NickName");
		}
		if(res.get("phone")!=null){
			phone=res.get("phone");
		}

		MongoDBBasic.updateUser(uid);
		
		SimpleDateFormat  format = new SimpleDateFormat("yyyy-MM-dd"); 
		Date date=new Date();
		String currentDate = format.format(date);
		if(uid.equals(originalUid)){
			MongoDBBasic.updateVisited(user.getOpenId(),currentDate,"MesPushHistory",user.getHeadImgUrl(),name);
		}
		else
		{
			MongoDBBasic.updateVisited(user.getOpenId(),currentDate,"MesPushHistory",user.getHeadImgUrl(),name);
			if(!"STATE".equals(originalUid)){
			HashMap<String, String> resOriginal=MongoDBBasic.getWeChatUserFromOpenID(originalUid);
			MongoDBBasic.updateShared(originalUid,currentDate,"MesPushHistory",user.getHeadImgUrl(),name,resOriginal.get("HeadUrl"),resOriginal.get("NickName"));
			}
		}
		
	}
}
boolean IsAuthenticated=MongoDBBasic.checkUserAuth(uid,"IsAuthenticated");
List<ArticleMessage> ams=MongoDBBasic.getArticleMessageByNum("");
String uid2=request.getParameter("UID");
int size=5;
int size2=5;
int realSize=ams.size();
if(ams.size()<=5){size=ams.size();}
List<VideoMessage> vms=MongoDBBasic.getVideoMessageByNum("");
int realSize2=vms.size();
System.out.println("realSize2:===="+realSize2);
if(vms.size()<=5){size2=vms.size();}
System.out.println("Size2:===="+size2);
for(int c=0;c<vms.size();c++)
{
	System.out.println("isRepeint:++"+vms.get(c).getIsReprint());
	}

%>
<!DOCTYPE html>
<html lang="en" class="csstransforms csstransforms3d csstransitions">
<head>
<title>往期回顾</title>
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">
			 <script src="../mdm/uploadfile_js/jquery-1.11.2.min.js"></script>
			 <script src="../Jsp/JS/iscroll.js"></script>
			 <link rel="stylesheet" href="../Jsp/CSS/about.css">
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
	/*  wx.checkJsApi({
            jsApiList: [
                'getLocation',
                'onMenuShareTimeline',
                'onMenuShareAppMessage'
            ],
            success: function (res) {
                alert(JSON.stringify(res));
            }
     }); */
     var shareTitle="更多精彩分享，您可关注该公众号点击发现乐数->往期回顾。";
     var shareDesc="<%=ams.get(0).getTitle()%>";
     var shareImgUrl="http://leshucq.bj.bcebos.com/standard/standard_reservationBigPic.jpg";
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
            // alert(JSON.stringify(res));
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
            // alert("用户取消了分享");
         },
         fail: function (res) {
            // alert(JSON.stringify(res));
         }
     });
     wx.error(function(res){
         // config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
         alert("errorMSG:"+res);
     });
 });
 function forward(num,type){
		alert("正在发送中，请耐心等待！");
	 $.ajax({
			url : "../getForwardMessage",
			type:'post',
			data:{
				num :num,
				type:type
			},
			success:function(data){
				alert("发送成功！");
			}
	 });
 }
 </script>
<style>
*{
margin:0;}
.topPic
{
position:relative;
height:180px;
background:blue;
width:100%;
}
.topPic img
{
width:100%;
height:100%;
}
.topPic_title
{
    position: absolute;
    left: 0;
    right: 0;
    bottom: 0;
    height: 1.4em;
    font-size: 16px;
    padding: 20px 50px 12px 13px;
    background-image: -webkit-linear-gradient(top,rgba(0,0,0,0) 0,rgba(0,0,0,.7) 100%);
    background-image: linear-gradient(to bottom,rgba(0,0,0,0) 0,rgba(0,0,0,.7) 100%);
    color: #fff;
    text-shadow: 0 1px 0 rgba(0,0,0,.5);
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    word-wrap: normal;
}
.navi{
height:45px;
width:100%;
background:#f2f2f2;
}
.navi p{
line-height:45px;
text-align:center;
width:50%;
float:left;
font-size:15px;
}
.singleMes{
height: 70px;
margin: 3%;
margin-top:16px;
margin-right:0px;
width: 94%;
border-bottom: 1px solid #f2f2f2;
}
.mesImg
{
    float: left;
    margin-right: 10px;
}
.mesImg img
{
    display: block;
    width: 80px;
    height: 60px;
}
.mesImg video
{
    display: block;
    width: 80px;
    height: 60px;
}
.mesContent{
overflow:hidden;
}
.mesTitle{
font-size: 16px;
    color: #000;
    width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
    word-wrap: normal;
}
.mesIntro{
margin-top:10px;
    font-size: 13px;
    color: #999;
    overflow: hidden;
    text-overflow: ellipsis;
    display: -webkit-box;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
    line-height: 1.3;
}
a{ text-decoration:none;
}
#articleMes{
font-weight:bolder;
}
</style>
</head>
<body>
<div id="zoomOutPic" style="width:100%;display:none;height: 100%;background: rgba(0,0,0,0.8);position: fixed;top:0px;left:0px;z-index: 1000;"><div id="videoContainer" style="width: 80%;height: auto;position:absolute;left: 10%;"><video src=""  width="320" height="240" controls="controls">
Your browser does not support the video tag.
</video></div></div>
  
 <div style="position: absolute;top: 0px;right: 0px;"><p style="margin-right: 10px;margin-top: 5px;">欢迎您：<span class="username colorBlue" id="username" style="color:#2489ce;"><%=name %></span></p><img src="<%=headImgUrl %>" alt="" style="border-radius: 25px;height: 35px;width: 35px;position: absolute;right: 8px;top: 25px;"></div>
<div style="padding-left: 10px;height: 60px;padding-top: 10px;">
<img src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" alt="Logo" class="HpLogo" style="display: inline !important; height:50px; float: none; padding: 0px; vertical-align: bottom;">
</div>
<div class="topPic"><img src="http://leshucq.bj.bcebos.com/standard/standard_reservationBigPic.jpg" />
<div class="topPic_title">【乐数】，乐在其中，心中有数</div></div>
<div class="navi"><p id="articleMes">乐数图文</p><p id="videoMes">乐数视频</p></div>
	<div id="wrapper" style="top:290px;">
		<div class="scroller">
<div id="mesPushPanel">
<% if(size!=0){for(int i=0;i<size;i++){ %>
<a href="https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=Constants.APP_ID%>&redirect_uri=http%3A%2F%2F<%=Constants.baehost%>%2Fmdm%2FNotificationCenter.jsp?num=<%=ams.get(i).getNum()%>&response_type=code&scope=snsapi_userinfo&state=<%=uid2 %>#wechat_redirect">
<div class="singleMes">
<div class="mesImg">
<%
if(ams.get(i).getPicture()!=null&&ams.get(i).getPicture()!=""){ %>
<img src="<%=ams.get(i).getPicture() %>" />
<% }else{%>
<img src="http://leshucq.bj.bcebos.com/standard/standard_reservationBigPic.jpg" />
<%} %></div>
<div class="mesContent">
<h2 class="mesTitle">
<%if(IsAuthenticated==true){ %>
<img
 <% if("0".equals(ams.get(i).isForward)){ %>
 src='images/forward.png'
 <%}else{ %>
 src='images/forward2.png'
 <%} %>
  onclick="javascript:forward('<%=ams.get(i).getNum() %>','mes');return false;" style='height:20px;vertical-align:bottom;padding-bottom:3px;'/>
 <%} %>
  <%=ams.get(i).getTitle() %></h2>
<p class="mesIntro"><%=ams.get(i).getContent() %></p>
</div>
</div></a>
<%}} %>
</div>
	<div id="videoPanel" style="display:none">
<%-- 	<% if(size2!=0){for(int i=0;i<size2;i++){ %>
	<div class="singleMes">
<div class="mesImg">
<%if(vms.get(i).getIsReprint().equals("1")){ %>
<a href="<%=vms.get(i).getWebUrl() %>"><img src="https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000EVbgB&oid=00D90000000pkXM" /></a>
<% }else{%>
<video src="<%=vms.get(i).getWebUrl() %>"  width="320" height="240"  >
Your browser does not support the video tag.
</video><%}%>

</div>
<div class="mesContent">
<h2 class="mesTitle"><img 
<% if("0".equals(vms.get(i).isForward)){ %>
 src='images/forward.png'
 <%}else{ %>
 src='images/forward2.png'
 <%} %>
 onclick="javascript:forward('<%=vms.get(i).getNum() %>','video');return false;" style='height:20px;vertical-align:bottom;padding-bottom:3px;'/><%=vms.get(i).getTitle() %></h2>
<p class="mesIntro"><%=vms.get(i).getContent() %></p>
</div>
</div>
<%}} %> --%>
	</div>
<div class="more"><i class="pull_icon"></i><span>上拉加载...</span></div>
		</div>
	</div>

	<script type="text/javascript">

	var realSize=<%=realSize %>;
	var size=<%=size %>;
	var flag=false;
	$(function(){
		$("#videoMes").on("click",function(){
			flag=true;
			realSize=<%=realSize2 %>;
			size=<%=size2 %>;
			$("#articleMes").css("font-weight","normal");
			$(this).css("font-weight","bolder");
			$("#mesPushPanel").css("display","none");
			$("#videoPanel").css("display","block");
			var img="";
	 		$.ajax({
    			url : "../QueryVideoMessage",
				type:'post',
				data:{
					startNumber:0,
					pageSize:<%=realSize2%>
				},
				success:function(data){
					for (var i = 0; i < data.length; i++) {
						console.log("isReprint++"+data[i].isReprint);
						if(data[i].isReprint=="1"){
							img="<a href='"+data[i].webUrl+"'><img src='https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000EVbgB&oid=00D90000000pkXM'/></a>";
						}
						else{
							img="<video src='"+data[i].webUrl+"' width='320' height='240'><img src='https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000EVbgB&oid=00D90000000pkXM'/></video>";
						}
						var isForward="2";
						if("0"==data[i].isForward){
							isForward="";
						}
						<%if(IsAuthenticated==true){ %>
							$('#videoPanel').append("<a href='"+data[i].webUrl+"'><div class='singleMes'><div class='mesImg'>"+img+"</div><div class='mesContent'><h2 class='mesTitle'><img src='images/forward"+isForward+".png' onclick='javascript:forward(\""+data[i].num+"\",\"video\");return false;'  style='height:20px;vertical-align:bottom;padding-bottom:3px;'/>"+data[i].title+"</h2><p class='mesIntro'>"+data[i].content+"</p></div></div></a>");
						<%}else{%>
						$('#videoPanel').append("<a href='"+data[i].webUrl+"'><div class='singleMes'><div class='mesImg'>"+img+"</div><div class='mesContent'><h2 class='mesTitle'>"+data[i].title+"</h2><p class='mesIntro'>"+data[i].content+"</p></div></div></a>");
						<%}%>
					}
					size=size+data.length;
					myscroll.refresh();
				},
				error:function(){
					console.log('error');
				},
			}); 
		});
		
		$("#articleMes").on("click",function(){
			flag=false;
			realSize=<%=realSize %>;
			size=<%=size%>
			$("#videoMes").css("font-weight","normal");
			$(this).css("font-weight","bolder");
			$("#videoPanel").css("display","none");
			$("#mesPushPanel").css("display","block");
		})
		$(".mesImg video").on("click",function(){
			
			$("#videoContainer video").attr("src","");
			var src=$(this).attr("src");
			if(!$("#videoContainer video").attr("src")){

				$("#videoContainer video").attr("src",src);
			}
		 $("#zoomOutPic").show();
	 })
	  $("#zoomOutPic").on("click",function(){
		  $("#videoContainer video").attr("src","");
		 $("#zoomOutPic").hide();
	 })
	});


			var myscroll = new iScroll("wrapper",{
				onScrollMove:function(){
					if (this.y<(this.maxScrollY)) {
						$('.pull_icon').addClass('flip');
						$('.pull_icon').removeClass('loading');
						$('.more span').text('释放加载...');
					}else{
						$('.pull_icon').removeClass('flip loading');
						$('.more span').text('上拉加载...');
					}
				},
				onScrollEnd:function(){
					
					if ($('.pull_icon').hasClass('flip')) {
						if(size<realSize){
						$('.pull_icon').addClass('loading');
						$('.more span').text('加载中...');
						pullUpAction();}
						else
							{
							$('.more span').text('我是有底线的...');
							}
					}
					
				},
				onRefresh:function(){
					$('.more').removeClass('flip');
					$('.more span').text('上拉加载...');
				}
				
			});
			
			function pullUpAction(){
				var img="";
				if(flag){
					setTimeout(function(){
				 		$.ajax({
			    			url : "../QueryVideoMessage",
							type:'post',
							data:{
								startNumber:<%=size2%>,
								pageSize:5
							},
							success:function(data){
								for (var i = 0; i < data.length; i++) {
									if(data[i].isReprint=="1"){
										img="<a href='"+data[i].webUrl+"'><img src='https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000EVbgB&oid=00D90000000pkXM'/></a>";
									}
									else{
										img="<video src='"+data[i].webUrl+"' width='320' height='240'><img src='https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000EVbgB&oid=00D90000000pkXM'/></video>";
									}
									var isForward="2";
						if("0"==data[i].isForward){
							isForward="";
						}
									<%if(IsAuthenticated==true){ %>
									
									$('#videoPanel').append("<a href='"+data[i].webUrl+"'><div class='singleMes'><div class='mesImg'>"+img+"</div><div class='mesContent'><h2 class='mesTitle'><img src='images/forward"+isForward+".png' onclick='javascript:forward(\""+data[i].num+"\",\"video\");return false;'  style='height:20px;vertical-align:bottom;padding-bottom:3px;'/>"+data[i].title+"</h2><p class='mesIntro'>"+data[i].content+"</p></div></div></a>");
									<%}else{%>
									$('#videoPanel').append("<a href='"+data[i].webUrl+"'><div class='singleMes'><div class='mesImg'>"+img+"</div><div class='mesContent'><h2 class='mesTitle'>"+data[i].title+"</h2><p class='mesIntro'>"+data[i].content+"</p></div></div></a>");
									<%}%>
								}
								size2=size2+data.length;
								myscroll.refresh();
							},
							error:function(){
								console.log('error');
							},
						}); 
					
						myscroll.refresh();
					}, 1000)
				}else{
				
				setTimeout(function(){
			 		$.ajax({
		    			url : "../QueryArticleMessage",
						type:'post',
						data:{
							startNumber:<%=size%>,
							pageSize:5
						},
						success:function(data){
							for (var i = 0; i < data.length; i++) {
								if(data[i].picture!=null&&data[i].picture!=""){
									img="<img src='"+data[i].picture+"'/>";
								}
								else{
									img="<img src='http://leshucq.bj.bcebos.com/standard/standard_reservationBigPic.jpg' />";
								}
								var isForward="2";
						if("0"==data[i].isForward){
							isForward="";
						}
								<%if(IsAuthenticated==true){ %>
								$('#mesPushPanel').append("<a href='https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=Constants.APP_ID%>&redirect_uri=http%3A%2F%2F<%=Constants.baehost%>%2Fmdm%2FNotificationCenter.jsp?num="+data[i].num+"&response_type=code&scope=snsapi_userinfo&state=<%=uid%>#wechat_redirect'><div class='singleMes'><div class='mesImg'>"+img+"</div><div class='mesContent'><h2 class='mesTitle'><img src='images/forward"+isForward+".png' onclick='javascript:forward(\""+data[i].num+"\",\"mes\");return false;'  style='height:20px;vertical-align:bottom;padding-bottom:3px;'/>"+data[i].title+"</h2><p class='mesIntro'>"+data[i].content+"</p></div></div></a>");
								
								<%}else{%>
								
								$('#mesPushPanel').append("<a href='https://open.weixin.qq.com/connect/oauth2/authorize?appid=<%=Constants.APP_ID%>&redirect_uri=http%3A%2F%2F<%=Constants.baehost%>%2Fmdm%2FNotificationCenter.jsp?num="+data[i].num+"&response_type=code&scope=snsapi_userinfo&state=<%=uid%>#wechat_redirect'><div class='singleMes'><div class='mesImg'>"+img+"</div><div class='mesContent'><h2 class='mesTitle'>"+data[i].title+"</h2><p class='mesIntro'>"+data[i].content+"</p></div></div></a>");
								<%}%>
							}
							size=size+data.length;
							myscroll.refresh();
						},
						error:function(){
							console.log('error');
						},
					}); 
				
					myscroll.refresh();
				}, 1000)
				}
			}
			if ($('.scroller').height()<$('#wrapper').height()) {
				$('.more').hide();
				myscroll.destroy();
			}
		</script>
</body>
</html>
