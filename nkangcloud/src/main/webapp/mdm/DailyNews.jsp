<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.OAuthUitl.SNSUserInfo,java.lang.*"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.ShortNews"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.nkang.kxmoment.util.Constants"%>
<%
//获取由OAuthServlet中传入的参数
SNSUserInfo user = (SNSUserInfo)request.getAttribute("snsUserInfo"); 
String originalUid=request.getParameter("UID");
if(request.getParameter("UID")==null&&request.getParameter("UID")==""){
	originalUid=(String)request.getAttribute("state"); 
}
String name = "";
String headImgUrl ="";
String uid="";
String openid="";
if(null != user) {
	openid=user.getOpenId();
	HashMap<String, String> res=MongoDBBasic.getWeChatUserFromOpenID(user.getOpenId());
	if(res!=null){
		if(res.get("HeadUrl")!=null){
			uid = user.getOpenId();
			headImgUrl=res.get("HeadUrl");
		}else{
			headImgUrl = user.getHeadImgUrl(); 
		}
		if(res.get("NickName")!=null){
			uid = user.getOpenId();
			name=res.get("NickName");
		}else{
			name = user.getNickname();
			headImgUrl = user.getHeadImgUrl(); 
			uid=Constants.devOpenID;
		}
	}else{
		name = user.getNickname();
		headImgUrl = user.getHeadImgUrl(); 
		uid=Constants.devOpenID;
	}
	SimpleDateFormat  format = new SimpleDateFormat("yyyy-MM-dd"); 
	Date date=new Date();
	String currentDate = format.format(date);
	if(openid.equals(originalUid)){
		MongoDBBasic.updateVisited(user.getOpenId(),currentDate,"DailyNews",user.getHeadImgUrl(),name);
	}
	else
	{
		MongoDBBasic.updateVisited(user.getOpenId(),currentDate,"DailyNews",user.getHeadImgUrl(),name);
		HashMap<String, String> resOriginal=MongoDBBasic.getWeChatUserFromOpenID(originalUid);
		MongoDBBasic.updateShared(originalUid,currentDate,"DailyNews",user.getHeadImgUrl(),name,resOriginal.get("HeadUrl"),resOriginal.get("NickName"));
		}
}




ArrayList<ShortNews> shortNews=MongoDBBasic.queryShortNews();
int size=5;
int realSize=shortNews.size();
if(shortNews.size()<=5){size=shortNews.size();}
boolean IsAuthenticated=false;
if(uid.equals(openid)){
	IsAuthenticated=MongoDBBasic.checkUserAuth(uid,"IsAuthenticated");
	MongoDBBasic.updateUser(openid);
}
%>
<!DOCTYPE html>
<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <title>新闻快讯</title>
			 <script src="../mdm/uploadfile_js/jquery-1.11.2.min.js"></script>
			 <script src="../Jsp/JS/iscroll.js"></script>
			  <script src="../Jsp/JS/avgrund.js"></script>
<link rel="stylesheet" href="../Jsp/CSS/about.css">

<script	src="../MetroStyleFiles/sweetalert.min.js"></script>
<link rel="stylesheet" type="text/css" href="../MetroStyleFiles/sweetalert.css"/>
<style>
#footer {
	background: #DCD9D9;
	bottom: 0;
	color: #757575;
	font-size: 12px;
	padding: 10px 1%;
	position: fixed;
	text-align: center;
	width: 100%;
	z-index: 1002;
	left:0;
}
</style>
</head>
<body style="margin:0px">
<%if(IsAuthenticated==true) { %>

<img onClick="javascript:publishNews();" style='width:45px;cursor:pointer;position: fixed;bottom: 50px;z-index: 1002;' src='http://leshu.bj.bcebos.com/icon/speaker.png'>
<a href="uploadArticle.jsp?UID=<%=uid%>"><img style="width: 45px;cursor:pointer;position: fixed;bottom: 50px;right: 0px;z-index: 1002;" src="http://leshu.bj.bcebos.com/icon/broadcast.png"></a>
<% } %>
		<aside style="margin-top:50px;height:400px;position:absolute;width:80%;left:5%;top:80px;" id="default-popup" class="avgrund-popup">

			<h2 id="title" style="margin-bottom:10px;"></h2>

			<p style="margin-top:20px;" id="content">
			
			</p>

			<button style="position:absolute;bottom:20px;right:20px;padding:4px 8px;" onClick="javascript:closeDialog();">关闭</button>

		</aside>

<div style="padding-left: 10px;height: 70px;border-bottom: 4px solid #20b672;padding-top: 10px;">
<img src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" alt="Logo" class="HpLogo" style="display: inline !important; height:50px; float: none; padding: 0px; vertical-align: bottom;">
<div style="width:100%;text-align:right;margin-top:-60px;">
<ul class="nav pull-right top-menu" style="list-style: none;">
					<li class="dropdown"><a href="#" class="dropdown-toggle ui-link" data-toggle="dropdown" style="padding:3px;
    text-decoration: none;
    text-shadow: 0 1px 0 #fff;display: block;color:#777;font-weight:700;">
					欢迎您：<span class="username colorBlue" id="username" style="color:#2489ce;"><%=name %></span>
					</a> <span><a style="float: right;" class="ui-link"> <img id="userImage" src="<%=headImgUrl %>" alt="userImage" class="userImage" style="
    border-radius: 25px;
    height: 35px;
    width: 35px;">
						</a></span></li>
				</ul>
</div>
</div>
<div id="wrapper">
<div class="box scroller">

	<ul class="event_list">

<%for(int i=0;i<size;i++){ %>
		<li><span><%=shortNews.get(i).getDate() %><br></span><%if(IsAuthenticated==true) { %><button style="position:absolute;top:65px;left:70px;background: white;border-style: none;border: 1px solid #20b672;border-radius: 5px;" onclick="javascript:deleteNews('<%=shortNews.get(i).getMongoID() %>');">删除新闻</button><% } %><p><span onClick="javascript:openDialog(this);"><%=shortNews.get(i).getContent() %> </span></p></li>
<%} %>
	</ul>
	<div class="more"><i class="pull_icon"></i><span>上拉加载...</span></div>
	</div>
	</div>
<script>
$(function(){
	function openDialog(obj) {
		var content=$(obj).text();
		var title=$(obj).parent().siblings("span").text();
		$("#content").text(content);
		$("#title").text(title);
		Avgrund.show( "#default-popup" );

	}

	function closeDialog() {

		Avgrund.hide();

	}
	function deleteNews(obj) {
  	  $.ajax({
			type : "post",
			url : "../deleteShortNews",
			data:{
				id:obj
			},
			cache : false,
			success : function(data) {
				swal("恭喜!", "删除成功", "success");
				var html="";
				$.ajax({
	    			url : "../QueryShortNewsList",
					type:'post',
					success:function(data){
						var temp=5;
						if(data.length<=5){
							temp=data.length;
						}
						for (var i = 0; i < temp; i++) {
							html+="<li><span>"+data[i].date+"</span><button style='position:absolute;top:65px;left:70px;background: white;border-style: none;border: 1px solid black;border-radius: 5px;' onclick=\"javascript:deleteNews(\'"+data[i].mongoID+"\');\">删除新闻</button><p><span onClick='javascript:openDialog(this);'>"+data[i].content+" </span></p></li>";
						
						}
						realSize=data.length;
						size=temp;
						$('.scroller ul').html(html);
					},
					error:function(){
						console.log('error');
					}
				});
			}
			});

	}
	function publishNews() {
		var formText="<textarea style='height: 200px;font-size:14px;line-height:25px;width: 80%;margin-left: 10px;' id='news'></textarea>";
		swal({  
	        title:"发布乐数快讯",  
	        text:formText,
	        html:"true",
	        showConfirmButton:true, 
			showCancelButton: true,   
			closeOnConfirm: false,  
	        cancelButtonText:"关闭",
	        confirmButtonText:"确定", 
	        animation:"slide-from-top"  
	      }, 
			function(inputValue){
	    	  if (inputValue === false){ return false; }
	    	  $.ajax({
	    			type : "post",
	    			url : "../CallCreateShortNews",
	    			data:{
	    				content:$("#news").val()
	    			},
	    			cache : false,
	    			success : function(data) {
	    				swal("恭喜!", data +"个人已收到您的推送", "success");
	    				var html="";
	    				$.ajax({
	    	    			url : "../QueryShortNewsList",
	    					type:'post',
	    					success:function(data){
	    						var temp=5;
	    						if(data.length<=5){
	    							temp=data.length;
	    						}
	    						for (var i = 0; i < temp; i++) {
	    							html+="<li><span>"+data[i].date+"</span><p><span onClick='javascript:openDialog(this);'>"+data[i].content+" </span></p></li>";
	    						
	    						}
	    						realSize=data.length;
	    						size=temp;
	    						$('.scroller ul').html(html);
	    					},
	    					error:function(){
	    						console.log('error');
	    					}
	    				});
	    			}
	    			});
	      });

	}
	window.openDialog=openDialog;
	window.closeDialog=closeDialog;
	window.publishNews=publishNews;
	window.deleteNews=deleteNews;
});

var realSize=<%=realSize %>;
var size=<%=size %>;
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
			setTimeout(function(){
		 		$.ajax({
	    			url : "../QueryShortNewsList2",
					type:'post',
					data:{
						startNumber:size,
						pageSize:5
					},
					success:function(data){
						for (var i = 0; i < data.length; i++) {
							$('.scroller ul').append("<li><span>"+data[i].date+"</span><p><span onClick='javascript:openDialog(this);'>"+data[i].content+" </span></p></li>");
						}
						size=size+data.length;
						myscroll.refresh();
					},
					error:function(){
						console.log('error');
					},
				}); 
			
		<%-- 		<%for(int i=size ;i<shortNews.size();i++){%>
				$('.scroller ul').append("<li><span>"+"<%=shortNews.get(i).getDate()%>"+"</span><p><span onClick='javascript:openDialog(this);'>"+"<%=shortNews.get(i).getContent()%>"+" </span></p></li>");
				<%}%>
				 --%>
				myscroll.refresh();
			}, 1000)
		}
		if ($('.scroller').height()<$('#wrapper').height()) {
			$('.more').hide();
			myscroll.destroy();
		}

	</script>
	<!-- BEGIN FOOTER -->
	<div id="footer">
		<span class="clientCopyRight"><nobr></nobr></span>
	</div>
	<!-- END FOOTER -->
	<script>
         jQuery.ajax({
     		type : "GET",
     		url : "../QueryClientMeta",
     		data : {},
     		cache : false,
     		success : function(data) {
     			if(data){
     			var jsons = eval(data);
     			//$('img.HpLogo').attr('src',jsons.clientLogo);
				$(document).attr("title",jsons.clientStockCode+" - "+$(document).attr("title"));//修改title值  
     			$('span.clientCopyRight').text('©'+jsons.clientCopyRight);
     			}
     		}
     	});
 </script> 
</body></html>