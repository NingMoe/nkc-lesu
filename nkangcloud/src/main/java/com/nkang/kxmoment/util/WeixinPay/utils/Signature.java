package com.nkang.kxmoment.util.WeixinPay.utils;

import java.util.Map;

import org.apache.log4j.Logger;

import com.nkang.kxmoment.service.CoreService;

/**
 * 
 * @author louiseliu
 *
 */
public class Signature {
	private static Logger log = Logger.getLogger(CoreService.class);
	public static String generateSign(Map<String, String> map){
    	Map<String, String> orderMap = MapUtil.order(map);
		
    	String result = MapUtil.mapJoin(orderMap,false,false);
        result += "&key=" + Configure.getKey();
        log.info("====:" + result);
        //result =  result.toUpperCase();
        result = MD5.MD5Encode(result).toUpperCase();
        
        return result;
    }
}

