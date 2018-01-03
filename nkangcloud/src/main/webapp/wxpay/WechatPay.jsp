<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,org.json.JSONObject"%>
<%@ page import="com.nkang.kxmoment.baseobject.GeoLocation"%>
<%@ page import="com.nkang.kxmoment.util.*"%>
<%@ page import="com.nkang.kxmoment.util.MongoDBBasic"%>
<%@ page import="com.nkang.kxmoment.baseobject.WeChatUser"%>
<%@ page import="com.nkang.kxmoment.baseobject.ClientMeta"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
String uid = request.getParameter("UID");
String code = uid;
String price = request.getParameter("TOTALFEE");

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
%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <title>微信支付</title>
	<meta content="width=device-width, initial-scale=1.0" name="viewport" />
<script type="text/javascript" src="../Jsp/JS/jquery-1.8.0.js"></script>
	<style>
	*{padding:0;margin: 0;}
body{
  background: #FEFEFE;
  margin-bottom: 50px;
  height: auto;
}
a{
  text-decoration: none;
  color:black;
}
a:visited{
  color:black;
}
.infoPanel
{
  padding:0 2%;
  width: 96%;
}
.infoArea,.imgArea{
  width:100%;
  height:40px;
  border-bottom: 1px solid #EFEFEF;
}
.imgArea{
  background: white;
  height:90px;
  position: relative;
}
.imgContainer
{
  position: absolute;
  left:40%;
  top:10px;
  width:70px;
  height:70px;
  overflow: hidden;
  border-radius: 50%;
}
.imgContainer img
{
  width:100%;
  height: 100%;
}
.infoTitle
{
  width:29%;
  text-align: left;
  padding-left:1%;
  height: 100%;
  line-height: 45px;
  float: left;
  font-weight:bold;
}
.infoVal
{
  float: right;
  width:68%;
  text-align: right;
  padding-right:2%;
  height: 100%;
  line-height: 45px;
}
.pay{
    text-align: center;
    height:50px;
    line-height: 50px;
    background: #20b672;
    color: white;
    position:absolute;
    bottom:30px;}
.infoPay{
padding-top:20px;
height:70px;
/* border-bottom:1px solid #EFEFEF; */
}
.payTitle{
    text-align: left;
    line-height: 40px;
    color: black;
    padding-left: 10px;
    border: none;
    font-weight:bolder;
}
.infoItem{
width:30%;
margin-left:2%;
height:50px;
float:left;
border:1px solid #20b672;
color:#20b672;
border-radius:5px;
line-height:25px;
font-size:0.8rem;
text-align:center;
}
#footer {
    background: #DCD9D9;
    bottom: 0px;
    color: #757575;
    font-size: 12px;
    padding: 10px 1%;
    position: absolute;
    text-align: center;
    width: 100%;
    z-index: 1002;
    left: 0;
}
	</style>
	</head>
<body>
	
<script type="text/javascript">  
       var appId;
       var timeStamp;
       var nonceStr;
       var pg;
       var signType;
       var paySign;
       var totalfee;
      function onBridgeReady(){
    	  WeixinJSBridge.invoke(  
               'getBrandWCPayRequest', {  
                   "appId" : appId,     //公众号名称，由商户传入       
                   "timeStamp": timeStamp, //时间戳，自1970年以来的秒数       
                   "nonceStr" : nonceStr, //随机串       
                   "package" : pg,
                   "signType" : signType, //微信签名方式:       
                   "paySign" : paySign    //微信签名   
               },  
               function(res){       
                   if(res.err_msg == "get_brand_wcpay_request:ok" ) { 
                	   window.location.href = "http://nkctech.duapp.com/mdm/profile.jsp?UID=<%= code%>";
                       alert("感谢您的支持,支付成功!");  
                   }
                   else{
       	    	    alert('抱歉系统故障，支付失败！请联系商家'+res.err_msg);//这里一直返回getBrandWCPayRequest提示fail_invalid appid
        	       }   
               }  
           ); 
        }  
        function pay(){   
            send_request(function(value){  
                var json = eval("(" + value + ")");  
                if(json.length > 0){  
                    appId = json[0].appId;  
                    timeStamp = json[0].timeStamp;  
                    nonceStr = json[0].nonceStr;
                    pg = json[0].pg;  
                    signType = json[0].signType;  
                    paySign = json[0].paySign;
                    
                    if (typeof WeixinJSBridge == "undefined"){  
                       if( document.addEventListener ){
                           document.addEventListener('WeixinJSBridgeReady', onBridgeReady, false);  
                       }else if (document.attachEvent){  
                           document.attachEvent('WeixinJSBridgeReady', onBridgeReady);  
                           document.attachEvent('onWeixinJSBridgeReady', onBridgeReady);  
                       }  
                    }else{
                       onBridgeReady(); 
                    }   
                }  
            },"http://nkctech.duapp.com/pay/payparm?openId=<%= code%>&totalfee="+totalfee,true);  
        }  
function send_request(callback, urladdress,isReturnData){        
    var xmlhttp = getXMLHttpRequest();  
    xmlhttp.onreadystatechange = function(){      	
            if (xmlhttp.readyState == 4) {  
                    try{  
                    if(xmlhttp.status == 200){  
                        if(isReturnData && isReturnData==true){
/*                         	alert("responseText="+xmlhttp.responseText); */
                            callback(xmlhttp.responseText);  
                        }  
                    }else{  
                        callback("页面找不到！"+ urladdress +"");  
                    }  
                } catch(e){  
                    callback("请求发送失败，请重试！" + e);  
                }  
           }  
    } 
    xmlhttp.open("POST", urladdress, true);
    xmlhttp.send(null);  
}  
function getXMLHttpRequest() {  
    var xmlhttp;  
    if (window.XMLHttpRequest) {  
        try {  
            xmlhttp = new XMLHttpRequest();  
            xmlhttp.overrideMimeType("text/html;charset=UTF-8");  
        } catch (e) {}  
    } else if (window.ActiveXObject) {  
        try {  
            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");  
        } catch (e) {  
            try {  
                xmlhttp = new ActiveXObject("Msxml2.XMLHttp");  
            } catch (e) {  
                try {  
                    xmlhttp = new ActiveXObject("Msxml3.XMLHttp");  
                } catch (e) {}  
            }  
        }  
    }  
    return xmlhttp;  
}  
$(function(){
	$(".infoItem").on("click",function(){
		totalfee=$(this).children("span").text();
	});
});
    </script>
    	
	
	
	<div id="data_model_div" style="height: 100px">
	<i class="icon" style="position: absolute;top: 25px;z-index: 100;right: 20px;">
			<!-- <img class="exit" src="http://leshu.bj.bcebos.com/icon/EXIT1.png"
			style="width: 30px; height: 30px;"> -->
<div style="width: 30px;height: 30px;float: left;border-radius: 50%;overflow: hidden;">
<img class="exit" src="<%=headImgUrl %>" style="width: 30px; height: 30px;" />
</div>
<span style="position: relative;top: 8px;left: 5px;font-style:normal"><%=name %></span></i>
	<img style="position: absolute;top: 8px;left: 10px;z-index: 100;height: 60px;" class="HpLogo" src="http://leshu.bj.bcebos.com/standard/leshuLogo.png" alt="Logo">
		<div style="width: 100%; height: 80px; background: white; position: absolute; border-bottom: 4px solid #20b672;">
		</div>
	</div>
    <div class="infoPanel">
      <div class="infoArea">
        <p class="infoTitle">手机号码</p>
        <p class="infoVal"><%=phone %></p>
      </div>
    </div>
    <div class="infoPanel">
      <div class="infoPay">
	  <div class="infoItem"><span>2160</span>元<br>24次课</div>
	  <div class="infoItem"><span>3880</span>元<br>48次课</div>
	  <div class="infoItem"><span>6680</span>元<br>96次课</div>
     </div>
    </div>

<div class="infoPanel">
      <div class="infoArea">
        <p class="infoTitle">支付方式</p>
        <p class="infoVal"></p>
      </div>
    </div>
          <div class="infoPanel">
      <div class="infoPay">
	  <div class="infoItem" style="color:gray;border:1px solid gray;line-height:50px;">支付宝支付</div>
	  <div class="infoItem" style="line-height:50px;">微信支付</div>
     </div>
    </div>
      <div class="infoArea pay"><a href="javascript:pay();">立即支付</a></div>
    	<div id="footer">
		<span class="clientCopyRight"><nobr>©版权所有 | 重庆乐数艺术培训有限公司</nobr></span>
	</div>
	</body>
</html>
