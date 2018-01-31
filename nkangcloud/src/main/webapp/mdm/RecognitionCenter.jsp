<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.OAuthUitl.SNSUserInfo,java.lang.*"%>
<%@ page import="com.nkang.kxmoment.baseobject.CongratulateHistory"%>
<%@ page import="com.nkang.kxmoment.util.RestUtils"%>
<%@ page import="java.util.*,com.nkang.kxmoment.util.*"%>
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
String uid2 = request.getParameter("uid");
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
			MongoDBBasic.updateVisited(user.getOpenId(),currentDate,"RecognitionCenter",user.getHeadImgUrl(),name);
		}
		else
		{
			MongoDBBasic.updateVisited(user.getOpenId(),currentDate,"RecognitionCenter",user.getHeadImgUrl(),name);
			if(!"STATE".equals(originalUid)){
			HashMap<String, String> resOriginal=MongoDBBasic.getWeChatUserFromOpenID(originalUid);
			MongoDBBasic.updateShared(originalUid,currentDate,"RecognitionCenter",user.getHeadImgUrl(),name,resOriginal.get("HeadUrl"),resOriginal.get("NickName"));
			}
		}
		
	}
}

String num = request.getParameter("num");
List<CongratulateHistory> chList=MongoDBBasic.getRecognitionInfoByOpenID(uid2,num);
CongratulateHistory ch=new CongratulateHistory();
if(!chList.isEmpty()){
	ch=chList.get(0);
	System.out.println("picture:-----"+ch.getGiftImg());
}
/*
CongratulateHistory ch=new CongratulateHistory();
ch.setComments("thanks");
ch.setGiftImg("http://wonderfulcq.bj.bcebos.com/IMG_0287.JPG");
ch.setPoint("200");
ch.setFrom("panda");
ch.setTo("潘嗒嗒");
ch.setUserImg("http://wx.qlogo.cn/mmopen/soSX1MtHexV6ibXOvfzOoePPqRib4AiaVIT1oCZZ7j0oVfacOT4xibmjF2sqHltyu1sXPPfqkwpXxoWDibQxnaX7FupTpHRNj2S8k/0");
ch.setType(" Bais For Action.");*/
%>
<!DOCTYPE HTML>
<html xmlns="http://www.w3.org/1999/xhtml" lang="en"><head>
<meta charset="utf-8">
<meta content="width=device-width, initial-scale=1.0" name="viewport">
<meta content="" name="description">
<meta content="" name="hpe">
<title><%=ch.getTo() %> must have done something amazing and has been recognized by <%=ch.getFrom() %></title>
<link rel="stylesheet" type="text/css" href="../nkang/css_athena/style.css"/>
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
     var shareTitle="<%=ch.getTo() %> must have done something amazing and has been recognized by <%=ch.getFrom() %>";
     var shareDesc="<%=ch.getTo() %> must have done something amazing and has been recognized by <%=ch.getFrom() %>";
     var shareImgUrl="http://<%=Constants.baehost %>/MetroStyleFiles/RecognitionImage.jpg";
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
 $(function(){ 
	// var giftImg=$("#giftImg").attr("src");
	 $("#giftImg").on("click",function(){
		 var shadowHeight=$("#zoomOutPic").css("height");
		 var giftHeight=$("#giftImg").css("height");
		 var top=(shadowHeight-giftHeight)/2;
		 $("#giftImg").css("top",top);
		 $("#zoomOutPic").show();
	 })
	  $("#zoomOutPic").on("click",function(){
		 $("#zoomOutPic").hide();
	 })
 });
 
</script>
  </head>
<body style="margin:0;">
<div id="zoomOutPic" style="width:100%;display:none;height: 100%;background: rgba(0,0,0,0.8);position: fixed;top:0px;left:0px;z-index: 1000;"><div style="width: 80%;height: auto;position:absolute;left: 10%;"><img src="<%=ch.getGiftImg() %>" width="100%" height="100%" alt=""></div></div>
            <div style="position: absolute;top: 0px;right: 0px;"><p style="margin-right: 10px;margin-top: 5px;">欢迎您：<span class="username colorBlue" id="username" style="color:#2489ce;"><%=name %></span></p><img src="<%=headImgUrl %>" alt="" style="border-radius: 25px;height: 35px;width: 35px;position: absolute;right: 8px;top: 25px;"></div>
            <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;border-spacing:0;display:table;">
             <tbody>
              <tr>
               <td width="270" valign="top" style="width:202.5pt;padding:0in 7.5pt 0in 15.0pt;padding-left:0px;">
                <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;border-spacing:0">
                 <tbody>
                  <tr>
                   <td valign="top" style="width:60%"><p class="MsoNormal" style="/* line-height:14.0pt */"><span style="font-size:11.0pt;font-family:&quot;Arial&quot;,sans-serif;color:black"><b><img id="_x0000_i1025" src="http://leshucq.bj.bcebos.com/standard/leshuLogo.png" style="
    width: 140%;
"></b>
                      <o:p></o:p></span></p></td>
                  </tr>
                 </tbody>
                </table></td>
               <td width="270" valign="bottom" style="width:202.5pt;padding:0in 15.0pt 0in 7.5pt;">
                <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;border-spacing:0;">
                 <tbody>
                  <tr>
                   <td valign="top" style="padding:0in 0in 0in 0in"><h1 align="right" style="margin:0in;margin-bottom:.0001pt;text-align:right;margin-bottom:0!important;color:inherit;margin-bottom: 24px!important;word-wrap:normal;"><span style="font-size: 12px;font-family:&quot;Arial&quot;,sans-serif;color:black;">
                      <o:p></o:p></span></h1></td>
                  </tr>
                 </tbody>
                </table></td>
              </tr>
             </tbody>
            </table>
            
            <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;/* border-collapse:collapse; *//* display:table; *//* border-spacing: 0; */">
             <tbody>
              <tr>
               <td width="588" valign="top" style="width:441.0pt;/* padding:0in 0in 0in 0in */">
                <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;/* border-collapse:collapse; */padding-bottom:0!important;">
                 <tbody>
                  <tr>
                   <td valign="top"><p class="MsoNormal" style="margin-top:0px;"><span style="font-size:11.0pt;font-family:&quot;Arial&quot;,sans-serif;color:black"><img id="_x0000_i1026" src="https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000EVPEF&oid=00D90000000pkXM" style="
    width: 100%;
">
                      <o:p></o:p></span></p></td>
                   <td width="0" valign="top" style="width:.3pt;padding:0in 0in 0in 0in"><p class="MsoNormal" style="line-height:14.0pt"><span style="font-size:11.0pt;font-family:&quot;Arial&quot;,sans-serif;color:black">&nbsp;
                      <o:p></o:p></span></p></td>
                  </tr>
                 </tbody>
                </table></td>
              </tr>
             </tbody>
            </table>
            <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;display:table;border-spacing: 0;height: 100px;">
             <tbody>
              <tr>
               <td width="274" style="width: 50%;background:#F2F2F1;padding:0in 6.0pt 0in 12.0pt;-moz-hyphens: auto;-webkit-hyphens: auto;border-collapse:collapse!important;hyphens: auto;word-wrap: break-word;">
                <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;padding-bottom:0!important">
                 <tbody>
                  <tr>
                   <td valign="top" style="padding:0in 0in 0in 0in">
                    <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;border-spacing: 0">
                     <tbody>
                      <tr>
                       <td width="40%" valign="top" style="width: 40%;padding:0in 7.5pt 0in 7.5pt;"><p class="MsoNormal" align="center" style="text-align:center"><span style="font-size: 30px;font-family:&quot;Arial&quot;,sans-serif;color:black;display: block;margin-top: 40px;"><%=ch.getPoint() %>
                          <o:p></o:p></span></p></td>
                       <td width="60%" valign="top" style="width: 60.0%;-moz-hyphens: auto;border-collapse:collapse!important;"><p class="MsoNormal" style="line-height:14.0pt;"><strong><span style="font-size: 22px;font-family:&quot;Arial&quot;,sans-serif;color:black;display: block;">Points</span></strong><span style="font-size: 13px;font-family:&quot;Arial&quot;,sans-serif;color:black;display: block;line-height: 15px;"><br>have been deposited into your account for immediate use
                          <o:p></o:p></span></p></td>
                      </tr>
                     </tbody>
                    </table></td>
                  </tr>
                 </tbody>
                </table></td>
               <td width="274" style="width: 50%;background:#464646;padding:0in 12.0pt 0in 6.0pt;">
                <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="text-align:center;width:100.0%;border-collapse:collapse;border-spacing: 0">
                 <tbody>
                  <tr>
                   <td valign="top" style="padding:0in 0in 0in 0in"><p class="MsoNormal" style="line-height:14.0pt;text-align:center;position:relative;">
                   <img src="../Jsp/PIC/gift.png" alt="" style="position: absolute;left: 3%;top: 0px;width: 40px;">
                   <span style="font-size:11.0pt;font-family:&quot;Arial&quot;,sans-serif;color:black;   display: block;margin-left: 30px;">
                   <b><span style="text-decoration:none"><img id="giftImg" border="0" id="_x0000_i1027" src="<%=ch.getGiftImg() %>" style="
    width: 50%;
"></span></b>
                      <o:p></o:p></span></p></td>
                  </tr>
                 </tbody>
                </table></td>
              </tr>
             </tbody>
            </table>
            <p style="margin: 20px;line-height:14.0pt;"><strong><span style="font-size:11.0pt;font-family:&quot;Arial&quot;,sans-serif;color:black">恭喜您, <%=ch.getTo() %>!</span></strong><span style="font-size:11.0pt;font-family:&quot;Arial&quot;,sans-serif;color:black">
              <o:p></o:p></span></p><p style="margin: 20px;line-height:14.0pt;"><span style="font-size:13px;font-family:&quot;Arial&quot;,sans-serif;color:black"><%=ch.getFrom() %> recognized you because of: <b><%=ch.getType() %></b>.
              <o:p></o:p></span></p>
            <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;display:table;border-spacing: 0;">
             <tbody>
              <tr>
               <td width="588" valign="top" style="width: 100%;/* padding:0in 0in 15.0pt 0in; */-moz-hyphens: auto;/* border-collapse:collapse!important; *//* word-wrap: break-word; */">
                <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;/* border-collapse:collapse; *//* border-spacing: 0; */">
                 <tbody>
                  <tr>
                   <td valign="top" style="padding:0in 0in 0in 0in;width: 100%;">
                    <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;border-spacing: 0">
                     <tbody>
                      <tr>
                       <td width="100%" valign="top" style="width:100.0%;border:none;border-top:solid #A6A6A6 1.0pt;padding:0in 0in 0in 0in"></td>
                      </tr>
                     </tbody>
                    </table></td>
                   <td width="0" style="width:10%;/* padding:0in 0in 0in 0in */"><p class="MsoNormal" style="line-height:14.0pt"><span style="font-size:11.0pt;font-family:&quot;Arial&quot;,sans-serif;color:black"><o:p></o:p></span></p></td>
                  </tr>
                 </tbody>
                </table></td>
              </tr>
             </tbody>
            </table><p style="margin: 10px;line-height:14.0pt;"><span style="font-size: 15px;font-family:&quot;Arial&quot;,sans-serif;color:black;">Below shows the impact you made to Leshu:
              <o:p></o:p></span></p>
            <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;display:table;border-spacing: 0">
             <tbody>
              <tr>
               <td width="0" style="width: 10%;padding:0in 0in 15.0pt 0in;">
                <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;padding-right:10px!important;">
                 <tbody>
                  <tr>
                   <td valign="top" style="text-align: left;padding:0in 0in 0in 15.0pt;"><p class="MsoNormal" style="line-height: 1px;"><span style="font-size: 1PX;font-family:&quot;Arial&quot;,sans-serif;color:black;"><img border="0" id="_x0000_i1028" src="https://myrecognition.int.hpe.com/hpenterprise/images/designtheme/hp2/1/lquote.png" style="
    width: 110%;
">
                      <o:p></o:p></span></p></td>
                  </tr>
                 </tbody>
                </table></td>
               <td width="193" style="width:145.0pt;padding:0in 0in 15.0pt 0in">
                <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;border-spacing: 0">
                 <tbody>
                  <tr>
                   <td valign="top" style="padding:0in 0in 0in 0in"><p class="font-size-16" style="margin:0in;margin-bottom:.0001pt;line-height:14.0pt;margin-bottom:0!important"><span style="font-size: 14px;font-family:&quot;Arial&quot;,sans-serif;color:black;display: block;margin: 10px;margin-left: 15px;"> <%=ch.getComments() %>
                      <o:p></o:p></span></p></td>
                  </tr>
                 </tbody>
                </table></td>
               <td width="0" style="width: 8%;padding:0in 0in 15.0pt 0in;">
                <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;border-spacing: 0">
                 <tbody>
                  <tr>
                   <td valign="top" style="padding:0in 0in 0in 0in"><p class="MsoNormal" style="line-height:14.0pt"><span style="font-size:11.0pt;font-family:&quot;Arial&quot;,sans-serif;color:black"><img border="0" id="_x0000_i1029" src="https://myrecognition.int.hpe.com/hpenterprise/images/designtheme/hp2/1/rquote.png" style="
    width: 60%;
">
                      <o:p></o:p></span></p></td>
                  </tr>
                 </tbody>
                </table></td>
              </tr>
             </tbody>
            </table><p style="margin: 10px;margin-bottom: 20px;line-height:14.0pt;"><span style="font-size: 14px;font-family:&quot;Arial&quot;,sans-serif;color:black;">Thank you for putting Leshu values into action! A copy of this recognition was sent to your manager.
              <o:p></o:p></span></p>
            <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;display:table;border-spacing: 0">
             <tbody>
              <tr>
               <td width="588" valign="top" style="width:441.0pt;padding:0in 0in 15.0pt 0in;-moz-hyphens: auto;-webkit-hyphens: auto;border-collapse:collapse!important;hyphens: auto;word-wrap: break-word">
                <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;border-spacing: 0">
                 <tbody>
                  <tr>
                   <td valign="top" style="padding:0in 0in 0in 0in">
                    <table class="MsoNormalTable" border="0" cellspacing="0" cellpadding="0" width="100%" style="width:100.0%;border-collapse:collapse;border-spacing: 0">
                     <tbody>
                      <tr>
                       <td width="100%" valign="top" style="width:100.0%;border:none;border-top:solid #A6A6A6 1.0pt;padding:0in 0in 0in 0in"><p class="MsoNormal" style="line-height:14.0pt"><span style="font-size:11.0pt;font-family:&quot;Arial&quot;,sans-serif;color:black">&nbsp;
                          <o:p></o:p></span></p></td>
                      </tr>
                     </tbody>
                    </table></td>
                   <td width="0" style="width:.3pt;padding:0in 0in 0in 0in"><p class="MsoNormal" style="line-height:14.0pt"><span style="font-size:11.0pt;font-family:&quot;Arial&quot;,sans-serif;color:black">&nbsp;
                      <o:p></o:p></span></p></td>
                  </tr>
                 </tbody>
                </table></td>
              </tr>
             </tbody>
            </table>
            
            
   <div>
   
   </div>
  
<img style="position:relative;top:10px;" src="http://leshucq.bj.bcebos.com/standard/standard_leshuQRCode.jpg" alt="" width="100%" /> 

	<div id="footer">
		<span class="clientCopyRight"><nobr></nobr></span>
	</div>
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
