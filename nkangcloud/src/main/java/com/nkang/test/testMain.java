package com.nkang.test;


import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSession;

import org.joda.time.DateTime;
import org.joda.time.Instant;
import org.joda.time.LocalDateTime;

import com.nkang.kxmoment.util.Constants;












import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.Timestamp;
import java.text.Format;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.TimeZone;

public class testMain {

    public static void main(String[] args) throws Exception {
    	
    	String timeStamps = String.valueOf((System.currentTimeMillis()/1000));//1970年到现在的秒数
/*    	String b = PayUtils.generateMchPayNativeRequestURL("1482792242");
    	HttpsRequest req =  new HttpsRequest();
    	String a = req.sendPost("https://api.mch.weixin.qq.com/pay/unifiedorder", b); //POST发送到统一支付接口*/
    	System.out.println(timeStamps);
    	
    	Date a = new Date();
    	System.out.println(a+"----"+a.getTime());
    	
    	
    	System.out.println(convertTime(a.getTime()));
        
    }
    
    public static String convertTime(long time){
        Date date = new Date(time);
        Format format = new SimpleDateFormat("yyyy MM dd HH:mm:ss");
        return format.format(date);
    }

}