<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%> 
<%  
String code = request.getParameter("UID");
String price = request.getParameter("TOTALFEE");
 %> 
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">  
<html>  
<head>  
<meta charset="utf-8" />  
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0" />  
<meta name="apple-mobile-web-app-capable" content="yes" />  
<meta name="apple-mobile-web-app-status-bar-style" content="black" />  
<meta name="format-detection" content="telephone=no" />  
<title>微信支付</title>   
</head>  
<body>  
    <div class="index_box">  
            <a href="javascript:pay();" class="btn_1"><img src="http://nkctech.gz.bcebos.com/wechatpay.png" style="height:150px;width:150px;margin-left:130px;margin-top:170px;"></a> 
        </div>  
  
    <script type="text/javascript">  
       var appId;
       var timeStamp;
       var nonceStr;
       var pg;
       var signType;
       var paySign;
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
                	   window.location.href = "http://nkctech.duapp.com/mdm/AddQuestions.jsp";
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
            },"http://nkctech.duapp.com/pay/payparm?openId=<%= code%>&totalfee=<%= price%>",true);  
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
    </script>  
</body>  
</html> 