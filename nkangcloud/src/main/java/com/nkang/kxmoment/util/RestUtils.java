package com.nkang.kxmoment.util;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.tomcat.util.http.fileupload.FileItem;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.nkang.kxmoment.baseobject.AbacusQuizPool;
import com.nkang.kxmoment.baseobject.ArticleMessage;
import com.nkang.kxmoment.baseobject.ClientInformation;
import com.nkang.kxmoment.baseobject.ClientMeta;
import com.nkang.kxmoment.baseobject.CongratulateHistory;
import com.nkang.kxmoment.baseobject.GeoLocation;
import com.nkang.kxmoment.baseobject.Notification;
import com.nkang.kxmoment.baseobject.WeChatMDLUser;
import com.nkang.kxmoment.baseobject.WeChatUser;
import com.nkang.kxmoment.util.Constants;

public class RestUtils {
	private static Logger log = Logger.getLogger(RestUtils.class);
	private static final double EARTH_RADIUS = 6371000;
	private static String localInd = "N";

	public static String getAccessKey() {
		String url = "https://" + Constants.wechatapihost
				+ "/cgi-bin/token?grant_type=client_credential&appid="
				+ Constants.APP_ID + "&secret=" + Constants.APPSECRET;
		String expires_in = null;
		String accessToken = null;
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			String message = new String(jsonBytes, "UTF-8");
			JSONObject demoJson = new JSONObject(message);
			accessToken = demoJson.getString("access_token");
			expires_in = demoJson.getString("expires_in");
			// DBUtils.updateAccessKey(accessToken, expires_in);
			MongoDBBasic.updateAccessKey(accessToken, expires_in);
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return accessToken;
	}
	public static String getTicket() {
		String ticket = MongoDBBasic.getTicket();
		if(ticket!=null){
			return ticket;
		}else{
		String url = "https://" + Constants.wechatapihost
				+ "/cgi-bin/ticket/getticket?access_token="+MongoDBBasic.QueryAccessKey()
				+ "&type=jsapi";
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			String message = new String(jsonBytes, "UTF-8");
			JSONObject demoJson = new JSONObject(message);
			ticket = demoJson.getString("ticket");
			String expires_in = demoJson.getString("expires_in");
			// DBUtils.updateAccessKey(accessToken, expires_in);
			MongoDBBasic.updateTicket(ticket, expires_in);
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ticket;
		}
	}

	public static byte[] readStream(InputStream inStream) throws Exception {  
	    ByteArrayOutputStream outSteam = new ByteArrayOutputStream();  
	    byte[] buffer = new byte[1024];  
	    int len = -1;  
	    while ((len = inStream.read(buffer)) != -1) {  
	        outSteam.write(buffer, 0, len);  
	    }  
	    outSteam.close();  
	    inStream.close();  
	    return outSteam.toByteArray();  
	} 
	
	public static List<String> getWeChatUserListID(String akey) {
		List<String> listOfOpenID = new ArrayList<String>();
		String url = "https://" + Constants.wechatapihost
				+ "/cgi-bin/user/get?access_token=" + akey;
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type", "application/json");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			//System.out.println("444");
			//int size = readStream(is);
			byte[] jsonBytes = readStream(is);
			//System.out.println("333");
			//byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			String message = new String(jsonBytes, "UTF-8");
			JSONObject demoJson = new JSONObject(message);
			System.out.println("222");
			if (demoJson.has("data")) {
				System.out.println("111");
				JSONObject Resultdata = demoJson.getJSONObject("data");
				if (Resultdata.has("openid")) {
					String openIDs = Resultdata.getString("openid");
					String str = openIDs.substring(1, openIDs.length() - 1);
					String[] strArray = str.split(",");
					//int i = 0;
					for (String s : strArray) {
						listOfOpenID.add(s);
						//i = i + 1;
						//System.out.println(i+"===" + s);
					}
				}
			}
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("-----" + e.toString());
		}
		return listOfOpenID;
	}


	
	public static WeChatUser getWeChatUserInfo(String akey, String openID) {
		WeChatUser wcu = new WeChatUser();

		String url = "https://" + Constants.wechatapihost
				+ "/cgi-bin/user/info?access_token=" + akey + "&openid="
				+ openID;
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type", "application/json");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			String message = new String(jsonBytes, "UTF-8");
			JSONObject demoJson = new JSONObject(message);
			String subscribe = demoJson.getString("subscribe");
			String openid = demoJson.getString("openid");
			String nickname = demoJson.getString("nickname");
			String sex = demoJson.getString("sex");
			String city = demoJson.getString("city");
			String language = demoJson.getString("language");
			String province = demoJson.getString("province");
			String headimgurl = demoJson.getString("headimgurl");
			String subscribe_time = demoJson.getString("subscribe_time");
			String remark = demoJson.getString("remark");
			String groupid = demoJson.getString("groupid");
			wcu.setCity(city);
			wcu.setGroupid(groupid);
			wcu.setHeadimgurl(headimgurl);
			wcu.setLanguage(language);
			wcu.setNickname(nickname);
			wcu.setOpenid(openid);
			wcu.setProvince(province);
			wcu.setRemark(remark);
			wcu.setSex(sex);
			wcu.setSubscribe(subscribe);
			wcu.setSubscribe_time(subscribe_time);

			WeChatUser wcutmp = MongoDBBasic.queryWeChatUser(openID);
			wcu.setLat(wcutmp.getLat());
			wcu.setLng(wcutmp.getLng());

			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return wcu;
	}

	

	public static String getUserCurLocStrWithLatLng(String lat, String lng) {
		String ret = "";
		String url = "http://" + Constants.baiduapihost + "/geocoder/v2/?ak="
				+ Constants.BAIDU_APPKEY + "&location=" + lat + "," + lng
				+ "&output=json";
		String message = "";
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type", "application/json");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			message = new String(jsonBytes, "UTF-8");
			JSONObject demoJson = new JSONObject(message);
			if (demoJson.has("result")) {
				JSONObject JsonFormatedLocation = demoJson
						.getJSONObject("result");
				ret = JsonFormatedLocation.getString("formatted_address");
			}
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return message;
	}

	public static String getUserCurLocWithLatLng(String lat, String lng) {
		String ret = "";
		String url = "http://" + Constants.baiduapihost + "/geocoder/v2/?ak="
				+ Constants.BAIDU_APPKEY + "&location=" + lat + "," + lng
				+ "&output=json";
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type", "application/json");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			String message = new String(jsonBytes, "UTF-8");
			JSONObject demoJson = new JSONObject(message);
			if (demoJson.has("result")) {
				JSONObject JsonFormatedLocation = demoJson
						.getJSONObject("result");
				ret = JsonFormatedLocation.getString("formatted_address");
			}
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ret;
	}

	public static List<String> getUserCurLocWithLatLngV2(String lat, String lng) {
		List<String> ret = new ArrayList<String>();
		String url = "http://" + Constants.baiduapihost + "/geocoder/v2/?ak="
				+ Constants.BAIDU_APPKEY + "&location=" + lat + "," + lng
				+ "&output=json";
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type", "application/json");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			String message = new String(jsonBytes, "UTF-8");
			JSONObject demoJson = new JSONObject(message);
			if (demoJson.has("result")) {
				JSONObject JsonResult = demoJson.getJSONObject("result");

				if (JsonResult.has("addressComponent")) {
					JSONObject addressComponent = JsonResult
							.getJSONObject("addressComponent");
					if (addressComponent.has("country")) {
						ret.add(addressComponent.getString("country"));
					} else {
						ret.add("country");
					}
					if (addressComponent.has("country_code")) {
						ret.add(addressComponent.getString("country_code"));
					} else {
						ret.add("country_code");
					}
					if (addressComponent.has("province")) {
						ret.add(addressComponent.getString("province"));
					} else {
						ret.add("province");
					}

					if (addressComponent.has("city")) {
						ret.add(addressComponent.getString("city"));
					} else {
						ret.add("city");
					}
					if (addressComponent.has("district")) {
						ret.add(addressComponent.getString("district"));
					} else {
						ret.add("district");
					}
					if (addressComponent.has("street")) {
						ret.add(addressComponent.getString("street"));
					} else {
						ret.add("street");
					}
					if (addressComponent.has("street_number")) {
						ret.add(addressComponent.getString("street_number"));
					} else {
						ret.add("street_number");
					}
					if (addressComponent.has("direction")) {
						ret.add(addressComponent.getString("direction"));
					} else {
						ret.add("direction");
					}
					if (addressComponent.has("distance")) {
						ret.add(addressComponent.getString("distance"));
					} else {
						ret.add("distance");
					}
				}
				// ret = JsonFormatedLocation.getString("formatted_address");
			}
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return ret;
	}

	public static List<String> getUserCityInfoWithLatLng(String lat, String lng) {
		String ret = "";
		List<String> CityComponent = new ArrayList<String>();
		String url = "http://" + Constants.baiduapihost + "/geocoder/v2/?ak="
				+ Constants.BAIDU_APPKEY + "&location=" + lat + "," + lng
				+ "&output=json";
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type", "application/json");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			String message = new String(jsonBytes, "UTF-8");
			JSONObject demoJson = new JSONObject(message);
			if (demoJson.has("result")) {
				JSONObject JsonFormatedLocation = demoJson
						.getJSONObject("result");
				ret = JsonFormatedLocation.getString("formatted_address");
				JSONObject JsonAddressComponent = JsonFormatedLocation
						.getJSONObject("addressComponent");
				CityComponent.add(JsonAddressComponent.getString("province"));
				CityComponent.add(JsonAddressComponent.getString("city"));
				CityComponent.add(JsonAddressComponent.getString("district"));
			}
			is.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return CityComponent;
	}

	public static String createMenu(String access_token) {
		String menu = "{\"button\":[{\"name\":\"走进乐数\",\"sub_button\":[{\"type\":\"view\",\"name\":\"乐数主页\",\"url\":\"http://"+Constants.baehost+"/mdm/LeShuIntro.jsp\"},{\"type\":\"click\",\"name\":\"乐数导航\",\"key\":\"sitenavigator\"},{\"type\":\"click\",\"name\":\"乐数动态\",\"key\":\"nboppt\"},{\"type\":\"view\",\"name\":\"预约课程\",\"url\":\"http://"+Constants.baehost+"/at/yy/bespeak.html\"}]},{\"name\":\"我的乐数\",\"sub_button\":[{\"type\":\"click\",\"name\":\"我的课程\",\"key\":\"myleshuclass\"},{\"type\":\"click\",\"name\":\"我的优惠\",\"key\":\"mycoupen\"}]},{\"name\":\"乐数应用\",\"sub_button\":[{\"type\":\"click\",\"name\":\"自我修炼\",\"key\":\"SelfTraining\"},{\"type\":\"click\",\"name\":\"乐数应用\",\"key\":\"MYAPPS\"},{\"type\":\"view\",\"name\":\"育儿交流\",\"url\":\"http://mp.weixin.qq.com/s/EwgxfqfuzIuQgPss7jdNtQ\"},{\"type\":\"view\",\"name\":\"娱乐百分百\",\"url\":\"https://h5.07073.com/wap/?bf=&name=2048\"}]}]}";
		
		String action = "https://" + Constants.wechatapihost
				+ "/cgi-bin/menu/create?access_token=" + access_token;
		try {
			URL url = new URL(action);
			HttpURLConnection http = (HttpURLConnection) url.openConnection();
			http.setRequestMethod("POST");
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			OutputStream os = http.getOutputStream();
			os.write(menu.getBytes("UTF-8"));
			os.flush();
			os.close();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			String message = new String(jsonBytes, "UTF-8");
			return "Create Menu Success";
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "Create Menu Failed";
	}

	public static String deleteMenu(String access_token) {
		String action = "https://" + Constants.wechatapihost
				+ "/cgi-bin/menu/delete? access_token=" + access_token;
		try {
			URL url = new URL(action);
			HttpURLConnection http = (HttpURLConnection) url.openConnection();

			http.setRequestMethod("GET");
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");// ????30?
			System.setProperty("sun.net.client.defaultReadTimeout", "30000"); // ????30?
			http.connect();
			OutputStream os = http.getOutputStream();
			os.flush();
			os.close();

			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			String message = new String(jsonBytes, "UTF-8");
			return "deleteMenu:" + message;
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return "deleteMenu Failed";
	}

	private static double rad(double d) {
		return d * Math.PI / 180.0;
	}

	public static double GetDistance(double lon1, double lat1, double lon2,
			double lat2) {
		double radLat1 = rad(lat1);
		double radLat2 = rad(lat2);
		double a = radLat1 - radLat2;
		double b = rad(lon1) - rad(lon2);
		double s = 2 * Math.asin(Math.sqrt(Math.pow(Math.sin(a / 2), 2)
				+ Math.cos(radLat1) * Math.cos(radLat2)
				* Math.pow(Math.sin(b / 2), 2)));
		s = s * EARTH_RADIUS;
		s = Math.round(s * 10000) / 10000;
		return s / 1000;
	}

	public static String callGetValidAccessKey() {
		String url = "http://" + Constants.baehost + "/getValidAccessKey";
		String message = "error";
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			message = new String(jsonBytes, "UTF-8");
			is.close();

		} catch (Exception e) {
			log.info("error callGetValidAccessKey ---------" + e.getMessage());
			message = "failed with " + e.getMessage();
		}
		return message;
	}

	

	/*
	 * author chang-zheng
	 */
	public static List<String> getAllStates(String countryCode) {
		List<String> ret = new ArrayList<String>();
		// Set<String> ret = new HashSet<String>();
		String message = "false";
		if (localInd == "Y") {
			String url = "http://" + Constants.baehost + "/getCitys?country=";
			try {
				URL urlGet = new URL(url + countryCode);
				HttpURLConnection http = (HttpURLConnection) urlGet
						.openConnection();
				http.setRequestMethod("GET"); // must be get request
				http.setRequestProperty("Content-Type",
						"application/x-www-form-urlencoded");
				http.setDoOutput(true);
				http.setDoInput(true);
				if (localInd == "Y") {
					System.setProperty("http.proxyHost", Constants.proxyInfo);
					System.setProperty("http.proxyPort", "8080");
				}
				System.setProperty("sun.net.client.defaultConnectTimeout",
						"30000");
				System.setProperty("sun.net.client.defaultReadTimeout", "30000");
				http.connect();
				InputStream is = http.getInputStream();
				int size = is.available();
				byte[] jsonBytes = new byte[size];
				is.read(jsonBytes);
				message = new String(jsonBytes, "UTF-8");
				// String a = message.substring(1, message.length()-1);
				String[] sp = message.split("\",\"");
				int cnt = 0;
				for (String i : sp) {
					cnt = cnt + 1;

					if (cnt == 1) {
						String a = i.substring(2, i.length());
						if (!a.isEmpty()) {
							ret.add(a);
						}
					} else if (cnt == sp.length) {
						ret.add(i.substring(0, i.length() - 1));
					} else {
						ret.add(i.trim());
					}
				}
				is.close();
				// ret.add(e;)

			} catch (Exception e) {
				log.info("error http CallGetFilterNonLatinCityFromMongo ---------"
						+ e.getMessage());
				message = "failed with " + e.getMessage();
			}
		} else {
			try {
				ret = MongoDBBasic.getAllStates(countryCode);
			} catch (Exception e) {
				log.info("error DB CallGetFilterNonLatinCityFromMongo ---------"
						+ e.getMessage());
				message = "failed with " + e.getMessage();
			}
		}
		return ret;

	}

	

	public static GeoLocation callGetDBUserGeoInfo(String OpenId) {
		String url = "http://" + Constants.baehost
				+ "/getDBUserGeoInfo?OpenID=" + OpenId;
		String message = "error";
		GeoLocation geoLocation = new GeoLocation();
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			message = new String(jsonBytes, "UTF-8");
			JSONObject demoJson = new JSONObject(message);
			geoLocation.setFAddr(demoJson.getString("FAddr"));
			geoLocation.setLAT(demoJson.getString("LAT"));
			geoLocation.setLNG(demoJson.getString("LNG"));
			is.close();

		} catch (Exception e) {
			log.info("error callGetDBUserGeoInfo ---------" + e.getMessage());
			message = "failed with " + e.getMessage();
		}
		return geoLocation;
	}

	public static String getlatLngwithQuery(String Query, String Region)
			throws Exception {
		String latlng = "";
		String url = "http://" + Constants.baiduapihost
				+ "/place/v2/search?query=" + Query + "&region=" + Region
				+ "&output=json&ak=" + Constants.BAIDU_APPKEY;
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type", "application/json");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			String message = new String(jsonBytes, "UTF-8");
			JSONObject demoJson = new JSONObject(message);
			if (demoJson.has("results")) {
				JSONArray ResultJA = demoJson.getJSONArray("results");
				if (ResultJA.length() > 0) {
					JSONObject placeJO = ResultJA.getJSONObject(0);
					if (placeJO != null && placeJO.has("location")) {
						try {
							JSONObject locationJO = placeJO
									.getJSONObject("location");
							String lng = locationJO.getString("lng");
							String lat = locationJO.getString("lat");
							if (lng != "" && lat != "") {
								latlng = lat + "-" + lng;
							}
						} catch (Exception e) {
							latlng = "";
						}
					}
				}
			}
			is.close();
		} catch (Exception e) {
			latlng = "";
		}
		return latlng;
	}

	public static String CallGetJSFirstSegmentArea() {
		String url = "http://" + Constants.baehost + "/getFilterSegmentArea";
		String message = "error";

		List<String> listOfSegmentArea = new ArrayList<String>();
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			message = new String(jsonBytes, "UTF-8");
			String a = message.substring(1, message.length() - 1);
			String[] sp = a.split(",");
			for (String i : sp) {
				listOfSegmentArea.add(i.substring(1, i.length() - 1));
			}
			is.close();

		} catch (Exception e) {
			log.info("error callGetDBUserGeoInfo ---------" + e.getMessage());
			message = "failed with " + e.getMessage();
		}

		String RetStr = "";
		String RetStr2 = "";
		String Ret = "";
		for (int i = 0; i < 10; i++) {
			double num = Math.random();
			RetStr = RetStr + "{axis:\" " + listOfSegmentArea.get(i)
					+ " \",value:" + num + "},";
			RetStr2 = RetStr2 + "{axis:\" " + listOfSegmentArea.get(i)
					+ " \",value:" + (1 - num) + "},";
		}
		Ret = Ret + "[" + RetStr.substring(0, RetStr.length() - 1) + "], ["
				+ RetStr2.substring(0, RetStr2.length() - 1) + "]";
		return Ret;
	}

	public static List<String> CallGetJSFirstSegmentAreaFromMongo(
			String cntOfOPSI, String state) {
		String url = "http://" + Constants.baehost
				+ "/getFilterSegmentAreaFromMongo?state="
				+ URLEncoder.encode(state);
		String message = "error";
		List<String> listOfSegmentArea = new ArrayList<String>();

		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			message = new String(jsonBytes, "UTF-8");
			String a = message.substring(1, message.length() - 1);
			String[] sp = a.split("\",\"");
			int cnt = 0;
			for (String i : sp) {
				cnt = cnt + 1;
				if (cnt == 1) {
					listOfSegmentArea.add(i.substring(1, i.length()));
				} else if (cnt == sp.length) {
					listOfSegmentArea.add(i.substring(0, i.length() - 1));
				} else {
					listOfSegmentArea.add(i.trim());
				}
			}
			is.close();
		} catch (Exception e) {
			log.info("error http CallGetJSFirstSegmentAreaFromMongo ---------"
					+ e.getMessage());
			message = "failed with " + e.getMessage();
		}
		return listOfSegmentArea;
	}

	public static List<String> CallGetJSFirstSegmentAreaListFromMongo(
			String state) {
		String url = "http://" + Constants.baehost
				+ "/getFilterSegmentAreaFromMongo?state="
				+ URLEncoder.encode(state);
		;
		String message = "error";
		List<String> listOfSegmentArea = new ArrayList<String>();

		if (localInd == "Y") {
			try {
				URL urlGet = new URL(url);
				HttpURLConnection http = (HttpURLConnection) urlGet
						.openConnection();
				http.setRequestMethod("GET"); // must be get request
				http.setRequestProperty("Content-Type",
						"application/x-www-form-urlencoded");
				http.setDoOutput(true);
				http.setDoInput(true);
				if (localInd == "Y") {
					System.setProperty("http.proxyHost", Constants.proxyInfo);
					System.setProperty("http.proxyPort", "8080");
				}
				System.setProperty("sun.net.client.defaultConnectTimeout",
						"30000");
				System.setProperty("sun.net.client.defaultReadTimeout", "30000");
				http.connect();
				InputStream is = http.getInputStream();
				int size = is.available();
				byte[] jsonBytes = new byte[size];
				is.read(jsonBytes);
				message = new String(jsonBytes, "UTF-8");
				String a = message.substring(1, message.length() - 1);
				String[] sp = a.split("\",\"");
				int cnt = 0;
				for (String i : sp) {
					cnt = cnt + 1;
					if (cnt == 1) {
						listOfSegmentArea.add(i.substring(1, i.length()));
					} else if (cnt == sp.length) {
						listOfSegmentArea.add(i.substring(0, i.length() - 1));
					} else {
						listOfSegmentArea.add(i.trim());
					}
				}
				is.close();
			} catch (Exception e) {
				log.info("error http CallGetJSFirstSegmentAreaListFromMongo ---------"
						+ e.getMessage());
				message = "failed with " + e.getMessage();
			}
		} else {
			try {
				listOfSegmentArea = MongoDBBasic.getFilterSegmentArea(state);
			} catch (Exception e) {
				log.info("error DB CallGetJSFirstSegmentAreaListFromMongo ---------"
						+ e.getMessage());
				message = "failed with " + e.getMessage();
			}
		}
		return listOfSegmentArea;
	}

	public static String callgetFilterRegionFromMongo(String state) {
		String url = "http://" + Constants.baehost
				+ "/getFilterRegionFromMongo?state=" + state;
		String message = "false";
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			message = new String(jsonBytes, "UTF-8");
			is.close();

		} catch (Exception e) {
			log.info("error callInsertCommentsFromVisitor ---------"
					+ e.getMessage());
			message = "failed with " + e.getMessage();
		}
		return message;
	}

	public static String CallgetFilterTotalOPSIFromMongo(String state,
			String nonlatinCity, String cityRegion) {
		String message = "false";
		if (localInd == "Y") {
			String url = "http://" + Constants.baehost
					+ "/getFilterTotalOPSIFromMongo";

			if (state != "" && state != null && state.toLowerCase() != "null") {
				state = URLEncoder.encode(state);
				url = url + "?state=" + state;
			}
			if (nonlatinCity != "" && nonlatinCity != null
					&& nonlatinCity.toLowerCase() != "null") {
				nonlatinCity = URLEncoder.encode(nonlatinCity);
				url = url + "&nonlatinCity=" + nonlatinCity;
			}
			if (cityRegion != "" && cityRegion != null
					&& cityRegion.toLowerCase() != "null") {
				cityRegion = URLEncoder.encode(cityRegion);
				url = url + "&cityRegion=" + cityRegion;
			}

			try {
				URL urlGet = new URL(url);
				HttpURLConnection http = (HttpURLConnection) urlGet
						.openConnection();
				http.setRequestMethod("GET"); // must be get request
				http.setRequestProperty("Content-Type",
						"application/x-www-form-urlencoded");
				http.setDoOutput(true);
				http.setDoInput(true);
				if (localInd == "Y") {
					System.setProperty("http.proxyHost", Constants.proxyInfo);
					System.setProperty("http.proxyPort", "8080");
				}
				System.setProperty("sun.net.client.defaultConnectTimeout",
						"30000");
				System.setProperty("sun.net.client.defaultReadTimeout", "30000");
				http.connect();
				InputStream is = http.getInputStream();
				int size = is.available();
				byte[] jsonBytes = new byte[size];
				is.read(jsonBytes);
				message = new String(jsonBytes, "UTF-8");
				is.close();

			} catch (Exception e) {
				log.info("error CallgetFilterTotalOPSIFromMongo ---------"
						+ e.getMessage());
				message = "failed with " + e.getMessage();
			}
		} else {
			try {
				message = MongoDBBasic.getFilterTotalOPSIFromMongo(state,
						nonlatinCity, cityRegion);
			} catch (Exception e) {
				log.info("error CallgetFilterTotalOPSIFromMongo ---------"
						+ e.getMessage());
				message = "failed with " + e.getMessage();
			}
		}
		return message;
	}

	public static String CallgetFilterCountOnCriteriaFromMongo(
			String industrySegmentNames, String nonlatinCity, String state,
			String cityRegion) {
		String message = "0";
		// if(true){
		if (localInd == "Y") {
			// if(localInd == "Y"){
			String parStr = "industrySegmentNames="
					+ URLEncoder.encode(industrySegmentNames);
			parStr = parStr + "&state=" + URLEncoder.encode(state);
			String url = "http://" + Constants.baehost
					+ "/getFilterCountOnCriteriaFromMongo?" + parStr;
			try {
				URL urlGet = new URL(url);
				HttpURLConnection http = (HttpURLConnection) urlGet
						.openConnection();
				http.setRequestMethod("GET"); // must be get request
				http.setRequestProperty("Content-Type",
						"application/x-www-form-urlencoded");
				http.setDoOutput(true);
				http.setDoInput(true);
				if (localInd == "Y") {
					System.setProperty("http.proxyHost", Constants.proxyInfo);
					System.setProperty("http.proxyPort", "8080");
				}
				System.setProperty("sun.net.client.defaultConnectTimeout",
						"30000");
				System.setProperty("sun.net.client.defaultReadTimeout", "30000");
				http.connect();
				InputStream is = http.getInputStream();
				int size = is.available();
				byte[] jsonBytes = new byte[size];
				is.read(jsonBytes);
				message = new String(jsonBytes, "UTF-8");
				is.close();

			} catch (Exception e) {
				log.info("error http CallgetFilterCountOnCriteriaFromMongo ---------"
						+ e.getMessage());
				// message = "failed with " + e.getMessage();
			}
		} else {
			try {

				message = MongoDBBasic.getFilterCountOnCriteriaFromMongo(
						industrySegmentNames, "", state, "");
			} catch (Exception e) {
				log.info("error DB CallgetFilterCountOnCriteriaFromMongo ---------"
						+ e.getMessage());
				// message = "failed with " + e.getMessage();
			}
		}

		return message;
	}

	public static List<String> CallGetFilterNonLatinCityFromMongo(String state) {
		List<String> ret = new ArrayList<String>();
		String message = "false";
		if (localInd == "Y") {
			String parStr = "state=" + URLEncoder.encode(state);
			String url = "http://" + Constants.baehost
					+ "/getFilterNonLatinCityFromMongo?" + parStr;
			try {
				URL urlGet = new URL(url);
				HttpURLConnection http = (HttpURLConnection) urlGet
						.openConnection();
				http.setRequestMethod("GET"); // must be get request
				http.setRequestProperty("Content-Type",
						"application/x-www-form-urlencoded");
				http.setDoOutput(true);
				http.setDoInput(true);
				if (localInd == "Y") {
					System.setProperty("http.proxyHost", Constants.proxyInfo);
					System.setProperty("http.proxyPort", "8080");
				}
				System.setProperty("sun.net.client.defaultConnectTimeout",
						"30000");
				System.setProperty("sun.net.client.defaultReadTimeout", "30000");
				http.connect();
				InputStream is = http.getInputStream();
				int size = is.available();
				byte[] jsonBytes = new byte[size];
				is.read(jsonBytes);
				message = new String(jsonBytes, "UTF-8");
				// String a = message.substring(1, message.length()-1);
				String[] sp = message.split("\",\"");
				int cnt = 0;
				for (String i : sp) {
					cnt = cnt + 1;
					if (i.contains(state)) {
						i = i.replaceAll("\\s+", "");
						i = i.replaceAll(state, "");
					}
					if (cnt == 1) {
						String a = i.substring(2, i.length());
						if (!a.isEmpty()) {
							ret.add(a);
						}
					} else if (cnt == sp.length) {
						ret.add(i.substring(0, i.length() - 1));
					} else {
						ret.add(i.trim());
					}
				}
				is.close();
				// ret.add(e;)

			} catch (Exception e) {
				log.info("error http CallGetFilterNonLatinCityFromMongo ---------"
						+ e.getMessage());
				message = "failed with " + e.getMessage();
			}
		} else {
			try {
				ret = MongoDBBasic.getFilterNonLatinCitiesFromMongo(state);
			} catch (Exception e) {
				log.info("error DB CallGetFilterNonLatinCityFromMongo ---------"
						+ e.getMessage());
				message = "failed with " + e.getMessage();
			}
		}

		return ret;
	}


	public static String getMDLUserLists(String openid) {
		String urlStr = "http://" + Constants.baehost
				+ "/CallGetWeChatUserFromMongoDB";
		if (openid != null && !"".equals(openid)) {
			urlStr += "?openid=" + openid;
		}
		StringBuffer strBuf = new StringBuffer("");
		try {
			URL url = new URL(urlStr);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			URLConnection conn = url.openConnection();
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "utf-8"));// ???
			String line = null;
			while ((line = reader.readLine()) != null)
				strBuf.append(line + " ");
			reader.close();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return strBuf.toString();
	}

	public static String getCallUpdateUserWithSignature(String openid,
			String svg) {
		String urlStr = "http://" + Constants.baehost
				+ "/CallUpdateUserWithSignature";
		try {
			urlStr += "?openid=" + openid + "&svg="
					+ URLEncoder.encode(svg, "utf-8");
		} catch (UnsupportedEncodingException e1) {
		}
		StringBuffer strBuf = new StringBuffer("");
		try {
			URL url = new URL(urlStr);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			URLConnection conn = url.openConnection();
			BufferedReader reader = new BufferedReader(new InputStreamReader(
					conn.getInputStream(), "utf-8"));// ???
			String line = null;
			while ((line = reader.readLine()) != null)
				strBuf.append(line + " ");
			reader.close();
		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return strBuf.toString();
	}

	// Bit Add Start
	

	public static String regist(WeChatMDLUser user) {

		String urlStr = "http://" + Constants.baehost + "/CallRegisterUser";
		ArrayList<String> arr = new ArrayList<String>();
		if (user.getOpenid() != null && !"".equals(user.getOpenid())) {
			arr.add("openid=" + user.getOpenid());
		}
		if (user.getRealName() != null && !"".equals(user.getRealName())) {
			arr.add("name=" + user.getRealName());
		}
		if (user.getPhone() != null && !"".equals(user.getPhone())) {
			arr.add("phone=" + user.getPhone());
		}
		if (user.getEmail() != null && !"".equals(user.getOpenid())) {
			arr.add("email=" + user.getEmail());
		}
		if (user.getRegisterDate() != null
				&& !"".equals(user.getRegisterDate())) {
			arr.add("registerDate=" + user.getRegisterDate());
		}
		/*
		 * if(user.getRole()!=null&&!"".equals(user.getRole())){
		 * arr.add("role="+user.getRole()); }
		 * if(user.getGroupid()!=null&&!"".equals(user.getGroupid())){
		 * arr.add("group="+user.getGroupid()); }
		 */
		if (user.getSelfIntro() != null && !"".equals(user.getSelfIntro())) {
			arr.add("selfIntro=" + user.getSelfIntro());
		}
		// Skill = html:45,java:50
		// ArrayList list = user.getTag();
		String skill = "";
		// Map map = null;

		System.out.println(skill);

		String temp = "";
		for (int i = 0; i < arr.size(); i++) {
			if (i == 0)
				temp += "?";
			else
				temp += "&";
			temp += arr.get(i);
		}
		urlStr += temp;
		System.out.println(urlStr);
		String message = "error";
		try {

			URL urlGet = new URL(urlStr);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			message = new String(jsonBytes, "UTF-8");
			System.out.println("=============" + message);
			is.close();

		} catch (Exception e) {
			log.info("error callGetDataQualityReport ---------"
					+ e.getMessage());
			message = "failed with " + e.getMessage();
		}
		return message;
	}

	

	public static String sendTextMessageToUserOnlyByCustomInterface(
			String content, String toUser, String fromUsersOpenID) {
		List<String> dbUser = MongoDBBasic
				.getRegisterUserByOpenID(fromUsersOpenID);
		Date date = new Date();
		String json = "{" + "\"touser\":\"" + toUser + "\","
				+ "\"msgtype\":\"text\", " + "\"text\":{" + "\"content\":\""
				+ dbUser.get(0) + " " + date.getHours() + ":"
				+ date.getMinutes() + ":" + date.getSeconds()
				+ " 说：\n---------------\n" + content + "\"" + "}" + "}";

		System.out.println(json);

		String access_token = MongoDBBasic.getValidAccessKey();

		String action = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="
				+ access_token;

		String result = "";
		try {

			result = connectWeiXinInterface(action, json);

		} catch (Exception e) {

			e.printStackTrace();

		}
		return result;

	}

	public static List<String> sendImgMessageToUserOnlyByCustomInterface(
			String toUser, String media_id) {
		List<String> result = new ArrayList<String>();
		String json = "{" + "\"touser\":\"" + toUser + "\","
				+ "\"msgtype\":\"image\", " + "\"image\":{" + "\"media_id\":\""
				+ media_id + "\"" + "}" + "}";

		System.out.println(json);

		String access_token = MongoDBBasic.getValidAccessKey();

		String action = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="
				+ access_token;

		result.add(action);
		result.add(json);
		try {

			connectWeiXinInterface(action, json);

		} catch (Exception e) {

			e.printStackTrace();

		}
		return result;

	}

	public static String sendTextMessageToUser(String content,
			List<String> toUser) {
		String result = "";
		String text = "";
		if (toUser.size() != 1) {
			for (int i = 0; i < toUser.size(); i++) {

				if (i == toUser.size() - 1) {
					text = text + toUser.get(i);
				} else {
					text = text + toUser.get(i) + "\",\"";
				}
			}

		}

		// 获取access_token

		String json = "{\"touser\": [\"" + text
				+ "\"],\"msgtype\": \"text\", \"text\": {\"content\": \""
				+ content + "\"}}";
		String accessToken = MongoDBBasic.getValidAccessKey();
		/*
		 * String accessToken =
		 * "FsEa1w7lutsnI4usB6I_yareExnJ-l7_8-RKkpF47TIU4vjBF_XA6bArxARRf-6B1irPpkFFeZvmi1LAGP9iuTVIgfd38fE39izmQ30_eL4pPftP_bH4s41FWgrryVuvRZUcAEACKF"
		 * ;
		 */

		// 获取请求路径
		String action = "https://api.weixin.qq.com/cgi-bin/message/mass/send?access_token="
				+ accessToken;
		if (toUser.size() == 1) {
			json = "{\"touser\": \"" + toUser.get(0)
					+ "\",\"msgtype\": \"text\", \"text\": {\"content\": \""
					+ content + "\"}}";
			action = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="
					+ accessToken;
		}

		System.out.println("json:" + json);

		try {

			result = connectWeiXinInterface(action, json);

		} catch (Exception e) {

			e.printStackTrace();

		}
		return result;

	}

	public static String sendNotificationToUser(String openId, String toOpenId,
			Notification note) {
		String result = "";
		String str = "{\"title\":\""
				+ note.getTitle()
				+ "\",\"description\":\""
				+ "From "
				+ MongoDBBasic.getRegisterUserByOpenID(openId).get(0)
				+ ":"
				+ note.getContent()
				+ "\",\"url\":\"https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constants.APP_ID+"&redirect_uri=http%3A%2F%2F"+Constants.baehost+"%2Fmdm%2FNotificationCenter.jsp?num="+note.getNum()+"&response_type=code&scope=snsapi_userinfo&state="+toOpenId+"#wechat_redirect"
				+ "\",\"picurl\":"
				+ "\"https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000DlTWX&oid=00D90000000pkXM\"}";
		String json = "{\"touser\":\"" + toOpenId
				+ "\",\"msgtype\":\"news\",\"news\":" +

				"{\"articles\":[" + str + "]}" + "}";

		System.out.println(json);

		/*
		 * String access_token =
		 * "FsEa1w7lutsnI4usB6I_yareExnJ-l7_8-RKkpF47TIU4vjBF_XA6bArxARRf-6B1irPpkFFeZvmi1LAGP9iuTVIgfd38fE39izmQ30_eL4pPftP_bH4s41FWgrryVuvRZUcAEACKF"
		 * ;
		 */
		String access_token = MongoDBBasic.getValidAccessKey();

		String action = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="
				+ access_token;

		try {

			result = connectWeiXinInterface(action, json);

		} catch (Exception e) {

			e.printStackTrace();

		}
		return result;

	}

	public static String sendNotificationToUser(String openId, String toOpenId,
			String img, ArticleMessage am) {
		String result = "";
		String str = "";
		ClientMeta cm = MongoDBBasic.QueryClientMeta(Constants.clientCode);
		if ("".equals(am.getWebUrl()) || "" == am.getWebUrl()) {
			str = "{\"title\":\"" + am.getTitle() + "\",\"description\":\""
					+ "Publisher - " + cm.getClientName() + "\",\"url\":\"https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constants.APP_ID+"&redirect_uri=http%3A%2F%2F"+Constants.baehost+"%2Fmdm%2FNotificationCenter.jsp?num="+am.getNum()+"&response_type=code&scope=snsapi_userinfo&state="+toOpenId+"#wechat_redirect\",\"picurl\":" + "\"" + img + "\"}";
		} else {
			str = "{\"title\":\"" + am.getTitle() + "\",\"description\":\""
					+ cm.getClientName() + "\",\"url\":\"" + am.getWebUrl()
					+ "\",\"picurl\":" + "\"" + img + "\"}";
		}
		String json = "{\"touser\":\"" + toOpenId
				+ "\",\"msgtype\":\"news\",\"news\":" +

				"{\"articles\":[" + str + "]}" + "}";

		System.out.println(json);

		/*
		 * String access_token =
		 * "FsEa1w7lutsnI4usB6I_yareExnJ-l7_8-RKkpF47TIU4vjBF_XA6bArxARRf-6B1irPpkFFeZvmi1LAGP9iuTVIgfd38fE39izmQ30_eL4pPftP_bH4s41FWgrryVuvRZUcAEACKF"
		 * ;
		 */
		String access_token = MongoDBBasic.getValidAccessKey();

		String action = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="
				+ access_token;

		try {

			result = connectWeiXinInterface(action, json);

		} catch (Exception e) {

			e.printStackTrace();

		}
		return result;

	}

	public static String sendRecognitionToUser(String openId, String toOpenId,
			CongratulateHistory ch) {
		String result = "";
		String str = "{\"title\":\"恭喜您!! "
				+ ch.getTo()
				+ " \",\"description\":\""
				+ ch.getTo()
				+ " 一定做了了不起的事情，收到了来至"
				+ ch.getFrom() + " 的赞美与认可!!!\",\"url\":\"http://" + Constants.baehost
				+ "/mdm/RecognitionCenter.jsp?num=" + ch.getNum() + "&uid="
				+ openId + "\",\"picurl\":" + "\"http://leshucq.bj.bcebos.com/standard/standard_ThanksLetter.jpg\"}";
		String json = "{\"touser\":\"" + toOpenId
				+ "\",\"msgtype\":\"news\",\"news\":" +

				"{\"articles\":[" + str + "]}" + "}";

		System.out.println(json);

		/*
		 * String access_token =
		 * "FsEa1w7lutsnI4usB6I_yareExnJ-l7_8-RKkpF47TIU4vjBF_XA6bArxARRf-6B1irPpkFFeZvmi1LAGP9iuTVIgfd38fE39izmQ30_eL4pPftP_bH4s41FWgrryVuvRZUcAEACKF"
		 * ;
		 */
		String access_token = MongoDBBasic.getValidAccessKey();

		String action = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="
				+ access_token;

		try {

			result = connectWeiXinInterface(action, json);

		} catch (Exception e) {

			e.printStackTrace();

		}
		return result;

	}

	public static String connectWeiXinInterface(String action, String json) {

		URL url;
		String result = "";

		try {

			url = new URL(action);

			HttpURLConnection http = (HttpURLConnection) url.openConnection();

			http.setRequestMethod("POST");

			http.setRequestProperty("Content-Type",

			"application/x-www-form-urlencoded");

			http.setDoOutput(true);

			http.setDoInput(true);

			System.setProperty("sun.NET.client.defaultConnectTimeout", "30000");

			System.setProperty("sun.Net.client.defaultReadTimeout", "30000");

			http.connect();

			OutputStream os = http.getOutputStream();

			os.write(json.getBytes("UTF-8"));// 传入参数

			InputStream is = http.getInputStream();

			int size = is.available();

			byte[] jsonBytes = new byte[size];

			is.read(jsonBytes);

			result = new String(jsonBytes, "UTF-8");

			// System.out.println("请求返回结果:"+result);

			os.flush();

			os.close();

		} catch (Exception e) {

			e.printStackTrace();

		}
		return "status:" + result;

	}

	/*
     * 
     * 
     */
	public static String callQueryClientMetaByClientCode()
			throws UnsupportedEncodingException {
		String url = "http://" + Constants.baehost
				+ "/QueryClientMetaByClientCode";
		String message = "errorrrr";
		try {
			URL urlGet = new URL(url);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("PUT"); // must be get request
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);

			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			message = new String(jsonBytes, "UTF-8");
			// JSONObject demoJson = new JSONObject(message);
			is.close();
			// System.out.println(message + "- success http ---------" + url);
		} catch (Exception e) {
			return "failed";
		}
		return message;
	}

	public static String sendQuotationToUser(String openID,
			String content, String img, String title, String url) {
		String result = "";
		String str = "";

		str = "{\"title\":\"" + title + "\",\"description\":\"" + content
				+ "\",\"url\":\"" + url + openID
				+ "\",\"picurl\":" + "\"" + img + "\"}";
		String json = "{\"touser\":\"" + openID
				+ "\",\"msgtype\":\"news\",\"news\":" +

				"{\"articles\":[" + str + "]}" + "}";

		System.out.println(json);

		/*
		 * String access_token =
		 * "FsEa1w7lutsnI4usB6I_yareExnJ-l7_8-RKkpF47TIU4vjBF_XA6bArxARRf-6B1irPpkFFeZvmi1LAGP9iuTVIgfd38fE39izmQ30_eL4pPftP_bH4s41FWgrryVuvRZUcAEACKF"
		 * ;
		 */
		String access_token = MongoDBBasic.getValidAccessKey();

		String action = "https://api.weixin.qq.com/cgi-bin/message/custom/send?access_token="
				+ access_token;

		try {

			result = connectWeiXinInterface(action, json);

		} catch (Exception e) {

			e.printStackTrace();

		}
		return result;

	}

	public static String getValueFromJson(String originalMsg, String key)
			throws JSONException {
		System.out.println("originalMsg--------" + originalMsg);
		String newString = originalMsg.substring(7, originalMsg.length());
		JSONObject demoJson = new JSONObject(newString);
		System.out.println("status key--------" + demoJson.getString(key));
		return demoJson.getString(key);
	}

	public static String getFreeDate(int num) {
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);
		calendar.add(Calendar.DAY_OF_MONTH, num);
		date = calendar.getTime();
		return sdf.format(date).toString();
	}

	public static String getWeekOfDate(Date dt) {
		String[] weekDays = { "7", "1", "2", "3", "4", "5", "6" };
		Calendar cal = Calendar.getInstance();
		cal.setTime(dt);
		int w = cal.get(Calendar.DAY_OF_WEEK) - 1;
		if (w < 0)
			w = 0;
		return weekDays[w];
	}

	public static String connectHttpsByPost(String path, String KK,
			FileItem file) throws IOException {
		URL urlObj = new URL(path);
		// 连接
		HttpURLConnection con = (HttpURLConnection) urlObj.openConnection();
		String result = null;
		con.setDoInput(true);

		con.setDoOutput(true);

		con.setUseCaches(false); // post方式不能使用缓存

		// 设置请求头信息
		con.setRequestProperty("Connection", "Keep-Alive");
		con.setRequestProperty("Charset", "UTF-8");
		// 设置边界
		String BOUNDARY = "----------" + System.currentTimeMillis();
		con.setRequestProperty("Content-Type", "multipart/form-data; boundary="
				+ BOUNDARY);

		// 请求正文信息
		// 第一部分：
		StringBuilder sb = new StringBuilder();
		sb.append("--"); // 必须多两道线
		sb.append(BOUNDARY);
		sb.append("\r\n");
		sb.append("Content-Disposition: form-data;name=\"media\";filelength=\""
				+ file.getSize() + "\";filename=\""

				+ file.getName() + "\"\r\n");
		sb.append("Content-Type:application/octet-stream\r\n\r\n");
		byte[] head = sb.toString().getBytes("utf-8");
		// 获得输出流
		OutputStream out = new DataOutputStream(con.getOutputStream());
		// 输出表头
		out.write(head);

		// 文件正文部分
		// 把文件已流文件的方式 推入到url中
		DataInputStream in = new DataInputStream(file.getInputStream());
		int bytes = 0;
		byte[] bufferOut = new byte[1024];
		while ((bytes = in.read(bufferOut)) != -1) {
			out.write(bufferOut, 0, bytes);
		}
		in.close();
		// 结尾部分
		byte[] foot = ("\r\n--" + BOUNDARY + "--\r\n").getBytes("utf-8");// 定义最后数据分隔线
		out.write(foot);
		out.flush();
		out.close();
		StringBuffer buffer = new StringBuffer();
		BufferedReader reader = null;
		try {
			// 定义BufferedReader输入流来读取URL的响应
			reader = new BufferedReader(new InputStreamReader(
					con.getInputStream()));
			String line = null;
			while ((line = reader.readLine()) != null) {
				buffer.append(line);
			}
			if (result == null) {
				result = buffer.toString();
			}
		} catch (IOException e) {
			System.out.println("发送POST请求出现异常！" + e);
			e.printStackTrace();
		} finally {
			if (reader != null) {
				reader.close();
			}
		}
		return result;
	}

	public static String uploadNews(String mediaID, String title, String content,String url) {
		// public static String uploadNews(){

		String result = "";
		String str = "{\"articles\": [{\"thumb_media_id\":\"" + mediaID
				+ "\",\"author\":\"\",\"title\":\"" + title
				+ "\",\"content_source_url\":\""+url
				+"\",\"content\":\"" + content
				+ "\",\"digest\":\"\",\"show_cover_pic\":1}]}";
		// System.out.println(str);
		// str="{\"articles\": [{\"thumb_media_id\":\"IvZtXKL8uF5UzX8mSLO66rSHyrGxrmR0OiG4-FXb8v8eNbqVIkANc5Lv0oFJaUn5\",\"author\":\"panda\",\"title\":\"test\",\"content_source_url\":\"www.qq.com\",\"content\":\"test for send message\",\"digest\":\"test for..\",\"show_cover_pic\":1}]}";
	//	 String access_token ="YRJm7nuItwIjgXFjTUVRBZjw33Z4IVywsR4tLjQG2OFyvtMR1cF5hWyG4w2YmVSgsYUXNPmemrBBob169vmjtwxYUVScYpfTJ2q6xJOtxiDZRp4auQepY0SjEv7p7vu8GEYfAHAWUO";
		String access_token = MongoDBBasic.getValidAccessKey();

		String action = "https://api.weixin.qq.com/cgi-bin/media/uploadnews?access_token="
				+ access_token;

		try {

			result = connectWeiXinInterface(action, str);

		} catch (Exception e) {

			e.printStackTrace();

		}
		return result;

	}

	public static String sendMass(List<String> toUser,String articleID) {
		String userList = "";
			for (int i = 0; i < toUser.size(); i++) {

				if (i == toUser.size() - 1) {
					userList = userList + toUser.get(i);
				} else {
					userList = userList + toUser.get(i) + "\",\"";
				}
			}

		
		String result = "";
		String str = "{\"touser\":[\""+userList+"\"],\"mpnews\":{\"media_id\":\""+articleID+"\"},\"msgtype\":\"mpnews\",\"send_ignore_reprint\":0}";
	//	String access_token = "pf5FTC-pcwohGiVQQDdsZ317Hs2hmtsyQ21q-i5MTvRen-HTBNqobJt0Og9ibm-7UYlTladJiwr4adDPGRAMn4xMyhGOwF6CstUbUe35myGFqy6Ls4bxr_F5qbH81lOBZDLfAGAQUC";
		 String access_token = MongoDBBasic.getValidAccessKey(); 

		String action = "https://api.weixin.qq.com/cgi-bin/message/mass/send?access_token="
				+ access_token;

		try {

			result = connectWeiXinInterface(action, str);
			System.out.println("图文消息发送成功。。。");

		} catch (Exception e) {

			e.printStackTrace();

		}
		return result;

	}
	
	/*
	 * chang-zheng
	 */
	/*
	public static String addAbacusQuizPool(AbacusQuizPool abacusQuizPool) {

		String urlStr = "http://" + Constants.baehost + "/CallQuizController";
		ArrayList<String> arr = new ArrayList<String>();
			arr.add("answer="+abacusQuizPool.getAnswer()+"");
		
		if (abacusQuizPool.getCategory() != null && !"".equals(abacusQuizPool.getCategory())) {
			arr.add("category=" + abacusQuizPool.getCategory());
		}
		if (abacusQuizPool.getCheckpoint() != null && !"".equals(abacusQuizPool.getCheckpoint())) {
			arr.add("checkpoint=" + abacusQuizPool.getCheckpoint());
		}
		
		String temp = "";
		for (int i = 0; i < arr.size(); i++) {
			if (i == 0)
				temp += "?";
			else
				temp += "&";
			temp += arr.get(i);
		}
		urlStr += temp;
		System.out.println(urlStr);
		String message = "error";
		try {

			URL urlGet = new URL(urlStr);
			HttpURLConnection http = (HttpURLConnection) urlGet
					.openConnection();
			http.setRequestMethod("GET"); // must be get request
			http.setRequestProperty("Content-Type",
					"application/x-www-form-urlencoded");
			http.setDoOutput(true);
			http.setDoInput(true);
			if (localInd == "Y") {
				System.setProperty("http.proxyHost", Constants.proxyInfo);
				System.setProperty("http.proxyPort", "8080");
			}
			System.setProperty("sun.net.client.defaultConnectTimeout", "30000");
			System.setProperty("sun.net.client.defaultReadTimeout", "30000");
			http.connect();
			InputStream is = http.getInputStream();
			int size = is.available();
			byte[] jsonBytes = new byte[size];
			is.read(jsonBytes);
			message = new String(jsonBytes, "UTF-8");
			System.out.println("=============" + message);
			is.close();

		} catch (Exception e) {
			log.info("error callGetDataQualityReport ---------"
					+ e.getMessage());
			message = "failed with " + e.getMessage();
		}
		return message;
	}
	*/
    public static int differentDaysByMillisecond(Date date1,Date date2)
    {
        int days = (int) ((date2.getTime() - date1.getTime()) / (1000*3600*24));
        return days;
    }
}
