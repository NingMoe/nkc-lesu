package com.nkang.kxmoment.util.WeixinPay.utils;

import java.io.BufferedOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.charset.Charset;
import java.security.KeyManagementException;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.UnrecoverableKeyException;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.apache.log4j.Logger;


import org.json.JSONException;
import org.json.JSONObject;

import com.nkang.kxmoment.util.Constants;
import com.nkang.kxmoment.util.WeixinPay.bean.PayQrCode;

public class PayUtil {
    private static Logger logger = Logger.getLogger(PayUtil.class); 
    /**
     * 根据code获取openid
     * @param code
     * @return
     * @throws IOException
     * @throws JSONException 
     */
     public static Map<String,Object> getOpenIdByCode(String code) throws IOException, JSONException {
        //请求该链接获取access_token
        HttpPost httppost = new HttpPost("https://api.weixin.qq.com/sns/oauth2/access_token");
        //组装请求参数
        String reqEntityStr = "appid=APPID&secret=SECRET&code=CODE&grant_type=authorization_code";
        reqEntityStr = reqEntityStr.replace("APPID", Constants.APP_ID);
        reqEntityStr = reqEntityStr.replace("SECRET", Constants.APPSECRET);
        reqEntityStr = reqEntityStr.replace("CODE", code);
        StringEntity reqEntity = new StringEntity(reqEntityStr);
        //设置参数
        httppost.setEntity(reqEntity);
        //设置浏览器
        CloseableHttpClient httpclient = HttpClients.createDefault();
        //发起请求
        CloseableHttpResponse response = httpclient.execute(httppost);
        //获得请求内容
        String strResult = EntityUtils.toString(response.getEntity(), Charset.forName("utf-8"));
        //获取openid
        JSONObject jsonObject = new JSONObject(strResult);
        Map<String,Object> map = new HashMap<String,Object>();
        map.put("openid",jsonObject.get("openid"));
        map.put("access_token",jsonObject.get("access_token"));
        map.put("refresh_token",jsonObject.get("refresh_token"));
        return map;
    }
    /**
     * 统一下单
     * @param body
     * @param out_trade_no
     * @param total_fee
     * @param IP
     * @param notify_url
     * @param openid
     * @return
     * @throws IOException
     */
    public static String unifiedOrder(String body,String out_trade_no,Integer total_fee,String IP,String openid)throws IOException {
        //设置访问路径
        HttpPost httppost = new HttpPost("https://api.mch.weixin.qq.com/pay/unifiedorder");

        String nonce_str = getNonceStr().toUpperCase();//随机
        //组装请求参数,按照ASCII排序
        String sign = "appid=" + Constants.APP_ID +
                        "&body=" + body +
                        "&mch_id=" + Constants.mcthID +
                        "&nonce_str=" + nonce_str +
                        "&notify_url=" + Constants.notifyURL +
                        "&openid=" + openid +
                        "&out_trade_no=" + out_trade_no +
                        "&spbill_create_ip=" + IP +
                        "&total_fee=" + total_fee.toString() +
                        "&trade_type=" + Constants.tradeType + 
                        "&key=" + Constants.partnerKey;//这个字段是用于之后MD5加密的，字段要按照ascii码顺序排序
        sign = MD5.MD5Encode(sign).toUpperCase();

        //组装包含openid用于请求统一下单返回结果的XML
        StringBuilder sb = new StringBuilder("");
        sb.append("<xml>");
        setXmlKV(sb,"appid",Constants.APP_ID);
        setXmlKV(sb,"body",body);
        setXmlKV(sb,"mch_id",Constants.mcthID);
        setXmlKV(sb,"nonce_str",nonce_str);
        setXmlKV(sb,"notify_url",Constants.notifyURL);
        setXmlKV(sb,"openid",openid);
        setXmlKV(sb,"out_trade_no",out_trade_no);
        setXmlKV(sb,"spbill_create_ip",IP);
        setXmlKV(sb,"total_fee",total_fee.toString());
        setXmlKV(sb,"trade_type",Constants.tradeType);
        setXmlKV(sb,"sign",sign);
        sb.append("</xml>");
        System.out.println("统一下单请求：" + sb);

        StringEntity reqEntity = new StringEntity(new String (sb.toString().getBytes("UTF-8"),"ISO8859-1"));//这个处理是为了防止传中文的时候出现签名错误
        httppost.setEntity(reqEntity);
        CloseableHttpClient httpclient = HttpClients.createDefault();
        CloseableHttpResponse response = httpclient.execute(httppost);
        String strResult = EntityUtils.toString(response.getEntity(), Charset.forName("utf-8"));
        System.out.println("统一下单返回xml：" + strResult);

        return strResult;
    }
    /**
     * 根据统一下单返回预支付订单的id和其他信息生成签名并拼装为map（调用微信支付）
     * @param prePayInfoXml
     * @return
     */
    public static Map<String,Object> getPayMap(String prePayInfoXml){
        Map<String,Object> map = new HashMap<String,Object>();

        String prepay_id = getXmlPara(prePayInfoXml,"prepay_id");//统一下单返回xml中prepay_id
        String timeStamp = String.valueOf((System.currentTimeMillis()/1000));//1970年到现在的秒数
        String nonceStr = getNonceStr().toUpperCase();//随机数据字符串
        String packageStr = "prepay_id=" + prepay_id;
        String signType = "MD5";
        String paySign =
                "appId=" + Constants.APP_ID +
                "&nonceStr=" + nonceStr +
                "&package=prepay_id=" + prepay_id +
                "&signType=" + signType +
                "&timeStamp=" + timeStamp +
                "&key="+ Constants.partnerKey;//注意这里的参数要根据ASCII码 排序
        paySign = MD5.MD5Encode(paySign).toUpperCase();//将数据MD5加密

        map.put("appId",Constants.APP_ID);
        map.put("timeStamp",timeStamp);
        map.put("nonceStr",nonceStr);
        map.put("packageStr",packageStr);
        map.put("signType",signType);
        map.put("paySign",paySign);
        map.put("prepay_id",prepay_id);
        return map;
    }
    /**
     * 修改订单状态，获取微信回调结果
     * @param request
     * @return
     * @throws IOException 
     * @throws KeyStoreException 
     * @throws NoSuchAlgorithmException 
     * @throws KeyManagementException 
     * @throws UnrecoverableKeyException 
     */
    public static String getNotifyResult(HttpServletRequest request, HttpServletResponse response) throws UnrecoverableKeyException, KeyManagementException, NoSuchAlgorithmException, KeyStoreException, IOException{
        String inputLine;  
        String notifyXml = "";
        String resXml = "";
           
        try {  
            while ((inputLine = request.getReader().readLine()) != null){  
                notifyXml += inputLine;  
            }  
            request.getReader().close();  
        } catch (Exception e) {  
            logger.info("xml received fail：" + e);
            e.printStackTrace();
        }
        logger.info("recevied xml result：" + notifyXml);  

        String appid = getXmlPara(notifyXml,"appid");;  
        String bank_type = getXmlPara(notifyXml,"bank_type");  
        String cash_fee = getXmlPara(notifyXml,"cash_fee");
        String device_info = getXmlPara(notifyXml,"device_info");
        String fee_type = getXmlPara(notifyXml,"fee_type");  
        String is_subscribe = getXmlPara(notifyXml,"is_subscribe");  
        String mch_id = getXmlPara(notifyXml,"mch_id");  
        String nonce_str = getXmlPara(notifyXml,"nonce_str");  
        String openid = getXmlPara(notifyXml,"openid");  
        String out_trade_no = getXmlPara(notifyXml,"out_trade_no");
        String result_code = getXmlPara(notifyXml,"result_code");
        String return_code = getXmlPara(notifyXml,"return_code");
        String sign = getXmlPara(notifyXml,"sign");
        String time_end = getXmlPara(notifyXml,"time_end");
        String total_fee = getXmlPara(notifyXml,"total_fee");
        String trade_type = getXmlPara(notifyXml,"trade_type");
        String transaction_id = getXmlPara(notifyXml,"transaction_id");

        //根据返回xml计算本地签名
        String localSign =
                "appid=" + appid +
                "&bank_type=" + bank_type +
                "&cash_fee=" + cash_fee +
                "&device_info=" + device_info +
                "&fee_type=" + fee_type +
                "&is_subscribe=" + is_subscribe +
                "&mch_id=" + mch_id +
                "&nonce_str=" + nonce_str +
                "&openid=" + openid +
                "&out_trade_no=" + out_trade_no +
                "&result_code=" + result_code +
                "&return_code=" + return_code +
                "&time_end=" + time_end +
                "&total_fee=" + total_fee +
                "&trade_type=" + trade_type +
                "&transaction_id=" + transaction_id +
                "&key=" + Constants.partnerKey;//注意这里的参数要根据ASCII码 排序
        localSign = MD5.MD5Encode(localSign).toUpperCase();//将数据MD5加密

        if(!localSign.equals(sign) || !"SUCCESS".equals(result_code) || !"SUCCESS".equals(return_code)){
            logger.info("Sign Validation Failure or returned incorrect code---result_code--" + result_code + "--return_code--" + return_code);
            resXml = "<xml>" + "<return_code><![CDATA[FAIL]]></return_code>" + "<return_msg><![CDATA[FAIL]]></return_msg>" + "</xml>";
            response.setContentType("text/xml"); 
            response.getWriter().print(resXml.toString());  
            response.getWriter().close();  
        }else{
			logger.info("Wechat pay success. out_trade_no is：" + out_trade_no);
			resXml = "<xml>" + "<return_code><![CDATA[SUCCESS]]></return_code>" + "<return_msg><![CDATA[OK]]></return_msg>" + "</xml>";
			response.setContentType("text/xml"); 
			response.getWriter().print(resXml.toString());  
			response.getWriter().close();  
        }

        return notifyXml;
    }
    /**
     * 获取32位随机字符串
     * @return
     */
    public static String getNonceStr(){
        String str = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        Random rd = new Random();
        for(int i = 0 ; i < 32 ; i ++ ){
            sb.append(str.charAt(rd.nextInt(str.length())));
        }
        return sb.toString();
    }
    /**
     * 插入XML标签
     * @param sb
     * @param Key
     * @param value
     * @return
     */
    public static StringBuilder setXmlKV(StringBuilder sb,String Key,String value){
        sb.append("<");
        sb.append(Key);
        sb.append(">");

        sb.append(value);

        sb.append("</");
        sb.append(Key);
        sb.append(">");

        return sb;
    }

    /**
     * 解析XML 获得名称为para的参数值
     * @param xml
     * @param para
     * @return
     */
    public static String getXmlPara(String xml,String para){
        int start = xml.indexOf("<"+para+">");
        int end = xml.indexOf("</"+para+">");

        if(start < 0 && end < 0){
            return null;
        }
        return xml.substring(start + ("<"+para+">").length(),end).replace("<![CDATA[","").replace("]]>","");
    }

    /**
     * 获取ip地址
     * @param request
     * @return
     */
    public static String getIpAddr(HttpServletRequest request) {  
        InetAddress addr = null;  
        try {  
            addr = InetAddress.getLocalHost();  
        } catch (UnknownHostException e) {  
            return request.getRemoteAddr();  
        }  
        byte[] ipAddr = addr.getAddress();  
        String ipAddrStr = "";  
        for (int i = 0; i < ipAddr.length; i++) {  
            if (i > 0) {  
                ipAddrStr += ".";  
            }  
            ipAddrStr += ipAddr[i] & 0xFF;  
        }  
        return ipAddrStr;  
    }
}