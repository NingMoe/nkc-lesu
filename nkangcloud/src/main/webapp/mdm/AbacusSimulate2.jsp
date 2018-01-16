<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="java.text.SimpleDateFormat"%>
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
	String ticket=RestUtils.getTicket();
%>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">
<title>珠心算算盘模拟器</title>
<script type="text/javascript" src="../Jsp/JS/leshu/jquery.min.js.download"></script>
<script src="../Jsp/JS/leshu/abacuss.js" type="text/javascript"></script>
<script src="../Jsp/JS/leshu/soroban.js" type="text/javascript"></script>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style.css"/>
<link rel="stylesheet" type="text/css" href="../Jsp/JS/leshu/custom.css" />
<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
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
     var shareTitle='乐数珠心算虚拟算盘练习';
     var shareDesc='快来看，快来看，乐数有虚拟算盘帮助小朋友练习珠算互译';
     var shareImgUrl='http://leshu.bj.bcebos.com/standard/leshuLogo.png';
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
            // alert("用户成功分享了该网页");
         },
         cancel: function () { 
             // 用户取消分享后执行的回调函数
           //  alert("用户取消了分享");
         },
         fail: function (res) {
          //   alert(JSON.stringify(res));
         }
     });
     //------------"分享到朋友圈"
     wx.onMenuShareTimeline({
         title: shareTitle, // 分享标题
         link:url, // 分享链接
         imgUrl: shareImgUrl, // 分享图标
         success: function () { 
             // 用户确认分享后执行的回调函数
          //   alert("用户成功分享了该网页");
         },
         cancel: function () { 
             // 用户取消分享后执行的回调函数
         //    alert("用户取消了分享");
         },
         fail: function (res) {
          //   alert(JSON.stringify(res));
         }
     });
     wx.error(function(res){
         // config信息验证失败会执行error函数，如签名过期导致验证失败，具体错误信息可以打开config的debug模式查看，也可以在返回的res参数中查看，对于SPA可以在这里更新签名。
         alert("errorMSG:"+res);
     });
 });


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


.selectPanel {
    padding: 20px 20px;
    text-align: center;
    margin-top: 5px;
}

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

.form_edit {    
	width: 100%;
	margin-left: 4%;
}

#endPanel{
	position: relative;
	top:-40px;
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
		<img style="position: absolute; top: 8px; left: 10px; z-index: 100; height: 60px;" class="HpLogo" src="http://leshu.bj.bcebos.com/standard/leshuLogo.png" alt="Logo" />
		<div
			style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
<main>
	<script type="text/javascript">mysoroban.htmldraw(foo.columns);</script>
	<div id="footer">
		<span class="clientCopyRight"><nobr>©版权所有 | 重庆NKC科技有限公司</nobr></span>
	</div>
</main>

</body>
</html>