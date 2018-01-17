<%@ page language="java" pageEncoding="UTF-8"%>
<%@ page import="com.nkang.kxmoment.util.WeixinPay.utils.PayUtil"%>
<%@ page import="com.nkang.kxmoment.util.Constants"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.text.Format"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.DecimalFormat"%>
<%@ page import="java.io.BufferedOutputStream"%>
<%
String notifyXML = "";
String resXml = "<xml><return_code><![CDATA[SUCCESS]]></return_code><return_msg><![CDATA[OK]]></return_msg></xml>";
String openID = Constants.devOpenID;
String notifyXML2 = "<xml><appid><![CDATA[wx022b55e5bdea4c51]]></appid><bank_type><![CDATA[CFT]]></bank_type><cash_fee><![CDATA[1]]></cash_fee><device_info><![CDATA[WEB]]></device_info><fee_type><![CDATA[CNY]]></fee_type><is_subscribe><![CDATA[Y]]></is_subscribe><mch_id><![CDATA[1469932302]]></mch_id><nonce_str><![CDATA[123]]></nonce_str><openid><![CDATA[oI3krwR_gGNsz38r1bdB1_SkcoNw]]></openid><out_trade_no><![CDATA[NKC1515997814882]]></out_trade_no><result_code><![CDATA[SUCCESS]]></result_code><return_code><![CDATA[SUCCESS]]></return_code><sign><![CDATA[7B53540F235ADC710CF8A7C6E5C0A0FD]]></sign><time_end><![CDATA[20180115143022]]></time_end><total_fee>1</total_fee><trade_type><![CDATA[JSAPI]]></trade_type><transaction_id><![CDATA[4200000056201801154446651635]]></transaction_id></xml>";

try{
	notifyXML = PayUtil.getNotifyResult(request, response);
	System.out.println("wechat payment callback notifyxml-" + notifyXML);  
	if(notifyXML==null || notifyXML.isEmpty()){
		notifyXML=notifyXML2;
		System.out.println("Start talk to wechat pay with Error"); 
	}
	else{
		System.out.println("Start talk to wechat pay with success"); 
	}
}	
catch(Exception e){
		System.out.println("Error" + e.getMessage().toString()); 
		//out.println("ERROR:" + e.getMessage().toString());
}

String uid = PayUtil.getXmlPara(notifyXML,"openid");
String transaction_id =  PayUtil.getXmlPara(notifyXML,"transaction_id");
String total_fee =  PayUtil.getXmlPara(notifyXML,"total_fee");

float num= (float)Float.valueOf(total_fee)/100; 
DecimalFormat df = new DecimalFormat("0.00"); 
String fee = df.format(num);

String notifyURL = Constants.notifyURL;
String bank_type = PayUtil.getXmlPara(notifyXML,"bank_type");
String out_trade_no = PayUtil.getXmlPara(notifyXML,"out_trade_no");
Date date = new Date();
Format format = new SimpleDateFormat("yyyy MM dd HH:mm:ss");


%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<meta name="viewport" content="initial-scale=1.0, width=device-width, user-scalable=no" />
	<title>微信支付成功</title>
	<link rel="stylesheet" type="text/css" href="../Jsp/CSS/lanren.css" />
</head>
<body>
<div class="header">
	  <div class="all_w" style="position:relative; z-index:1;">
		    <div class="ttwenz" style=" text-align:center; width:100%;">
		      <h4>交易详情</h4>
		      <h5>微信安全支付</h5>
		    </div>
		    <a href="http://<%= Constants.baehost%>/mdm/profile.jsp?UID=<%= uid%>" class="fh_but">返回</a> 
	  </div>
</div>

<div class="zfcg_box ">
	<div class="all_w"><img src="http://nkctech.gz.bcebos.com/cg_03.jpg" /> 支付成功 </div>
</div>
<div class="cgzf_info">
	<div class="wenx_xx">
	  <div class="mz"><%= Constants.clientCNName %></div>
	  <div class="wxzf_price">￥<%= fee%></div>
	</div>
	
	<div class="spxx_shop">
		 <div class=" mlr_pm">
			 <table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tbody><tr>
				    <td>商品编码</td>
				    <td align="right"><%= out_trade_no%></td>
				  </tr>
				   <tr>
				    <td>交易时间</td>
				    <td align="right"><%= format.format(date)%></td>
				  </tr>
				   <tr>
				    <td>支付方式</td>
				    <td align="right"><%= bank_type%></td>
				  </tr>
				   <tr>
				    <td>交易单号</td>
				    <td align="right"><%= transaction_id%></td>
				  </tr>
				</tbody>
			</table>
		 </div>
	</div>
</div>


<div class="wzxfcgde_tb"><img src="http://nkctech.gz.bcebos.com/cg_07.jpg" /></div>

</body>

</html>