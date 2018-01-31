package com.nkang.kxmoment.controller;


import java.io.BufferedReader;
import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.json.JSONException;
import org.springframework.web.bind.annotation.*;
import com.nkang.kxmoment.baseobject.Appointment;
import com.nkang.kxmoment.baseobject.AppointmentList;
import com.nkang.kxmoment.baseobject.ArticleMessage;
import com.nkang.kxmoment.baseobject.ClientInformation;
import com.nkang.kxmoment.baseobject.ClientMeta;
import com.nkang.kxmoment.baseobject.GeoLocation;
import com.nkang.kxmoment.baseobject.QuoteVisit;
import com.nkang.kxmoment.baseobject.ShortNews;
import com.nkang.kxmoment.baseobject.Teamer;
import com.nkang.kxmoment.baseobject.VideoMessage;
import com.nkang.kxmoment.baseobject.Visited;
import com.nkang.kxmoment.baseobject.WeChatMDLUser;
import com.nkang.kxmoment.baseobject.WeChatUser;
import com.nkang.kxmoment.util.Constants;
import com.nkang.kxmoment.util.MongoDBBasic;
import com.nkang.kxmoment.util.RestUtils;
import com.nkang.kxmoment.util.StringUtils;
import com.nkang.kxmoment.util.SmsUtils.RestTest;


@RestController
public class MasterDataRestController {
	private static Logger log=Logger.getLogger(MasterDataRestController.class);
	
	
	@RequestMapping("/CallGetWeChatUserDistanceList")
	public static List<WeChatMDLUser> CallGetWeChatUserDistanceList(
			@RequestParam(value="openid", required=true) String openid
			){
		GeoLocation geol = MongoDBBasic.getDBUserGeoInfo(openid);
		String lat = geol.getLAT();
		String lng = geol.getLNG();
		String addr = geol.getFAddr();
		
		
		
		List<WeChatMDLUser> ret = new ArrayList<WeChatMDLUser>();
		try{
			ret = MongoDBBasic.getWeChatUserFromMongoDB(null);
		}		
		catch(Exception e){
			//ret.add(e.getMessage());
		}
		LinkedList<WeChatMDLUser> lList = new LinkedList<WeChatMDLUser>();
		for(WeChatMDLUser temp : ret){
			if(!StringUtils.isEmpty(temp.getLat())&&!StringUtils.isEmpty(temp.getLng())&&!openid.equals(temp.getOpenid())){
				temp.setDistance(RestUtils.GetDistance(Double.parseDouble(lng), Double.parseDouble(lat), Double.parseDouble( temp.getLng()),Double.parseDouble( temp.getLat())));
				int num=lList.size();
				if(num==0){
					lList.add(temp);
				}else{
					for(int i=0;i<lList.size();i++){
						if(temp.getDistance()<lList.get(i).getDistance()){
							lList.add(i, temp);
							break;
						}
					}
				}
				if(num==lList.size()){
					lList.add(temp);
				}
			}
		}
		return lList;
	}
	@RequestMapping("/getValidAccessKey")
	public String getValidAccessKey(@RequestParam(value="accessKey", required=false) String siteInstanceId){
		String AK="";
		try{
			AK = MongoDBBasic.getValidAccessKey();
		}
		catch(Exception e){
			AK = "failed";
		}
		return AK;
	}
	@RequestMapping("/getForwardMessage")
	public boolean getForwardMessage(@RequestParam(value="num", required=false) String num,@RequestParam(value="type", required=false) String type){
		if("video".equals(type)){
			List<VideoMessage>  list=MongoDBBasic.getVideoMessageByNum(num);
			VideoMessage mes=list.get(0);
			//微信
			List<WeChatMDLUser> allUser = MongoDBBasic.getWeChatUserFromMongoDB("");
	
			String content=mes.getContent();
			String title=mes.getTitle();
			String uri=mes.getWebUrl();
			content+="\n【更多消息请点击微信公众号菜单：\n      发现附近-->往期回顾-->视频消息】";
			for(int i=0;i<allUser.size();i++){
			//	if(allUser.get(i).getOpenid().equals("oqPI_xACjXB7pVPGi5KH9Nzqonj4")){
					log.info("getForwardMessage==========video================send to "+allUser.get(i).getOpenid());
					RestUtils.sendQuotationToUser(allUser.get(i).getOpenid(),content,"https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000EVbgB&oid=00D90000000pkXM","【"+allUser.get(i).getNickname()+"】"+title,uri);
			//	}
			}
			MongoDBBasic.updateVideoMessageByNum(num);
		}else{
			List<ArticleMessage>  list=MongoDBBasic.getArticleMessageByNum(num);
			ArticleMessage mes=list.get(0);
			//微信
			List<WeChatMDLUser> allUser = MongoDBBasic.getWeChatUserFromMongoDB("");
	
			String content=mes.getContent();
			content=content.replaceAll("(\r\n|\r|\n|\n\r|<br/>|<br />|<br>|<b>|</b>|\")", "");
			if(content.length()>200){
				content=content.substring(0,180);
			}
			content+="\n【更多消息请点击微信公众号菜单：\n      发现附近-->往期回顾-->图文消息】";
			String title=mes.getTitle();
			String picture="http://leshucq.bj.bcebos.com/standard/standard_reservationBigPic.jpg";
			if(mes.getPicture()!=null&&mes.getPicture()!=""){
				picture=mes.getPicture();
			}
			String uri="";
			for(int i=0;i<allUser.size();i++){
				uri="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constants.APP_ID+"&redirect_uri=http%3A%2F%2F"+Constants.baehost+"%2Fmdm%2FNotificationCenter.jsp?num="+num+"&response_type=code&scope=snsapi_userinfo&state="+allUser.get(i).getOpenid()+"#wechat_redirect";
				//if(allUser.get(i).getOpenid().equals("oqPI_xACjXB7pVPGi5KH9Nzqonj4")){
					log.info("getForwardMessage==========mes================send to "+allUser.get(i).getOpenid());
					log.info("=========picture:"+picture);
					log.info("=========uri:"+uri);
					RestUtils.sendQuotationToUser(allUser.get(i).getOpenid(),content,picture,"【"+allUser.get(i).getNickname()+"】"+title,uri);
				//}
			}
			MongoDBBasic.updateArticleMessageByNum(num);
		}
		return true;
	}

	@RequestMapping("/updateWechatUser")
	public String updateWechatUser(	@RequestParam(value="OpenID", required=false) String OpenID,
									@RequestParam(value="Lat", required=false) String Lat,
									@RequestParam(value="Lng", required=false) String Lng,
									@RequestParam(value="AccessKey", required=false) String AccessKey)
	{
		boolean result=false;
		try{
			WeChatUser wcu = RestUtils.getWeChatUserInfo(AccessKey, OpenID);
			result = MongoDBBasic.updateUser(OpenID, Lat, Lng, wcu);
		}
		catch(Exception e){
			result = false;
		}
		return String.valueOf(result);
	}
	@RequestMapping("/callUpdateClientMeta")
	public String callUpdateClientMeta(	@RequestParam(value="ClientCode", required=true) String ClientCode,
									@RequestParam(value="ClientLogo", required=false) String ClientLogo,
									@RequestParam(value="ClientName", required=false) String ClientName,
									@RequestParam(value="ClientSubName", required=false) String ClientSubName,
									@RequestParam(value="ClientCopyRight", required=false) String ClientCopyRight,
									@RequestParam(value="ClientThemeColor", required=false) String ClientThemeColor,
									@RequestParam(value="Slide1", required=false) String Slide1,
									@RequestParam(value="Slide2", required=false) String Slide2,
									@RequestParam(value="Slide3", required=false) String Slide3,
									@RequestParam(value="SmsSwitch", required=false) String SmsSwitch,
									@RequestParam(value="MetricsMapping", required=false) String metricsMapping
									)
	{
		boolean result=false;
		ClientMeta cm=new ClientMeta();
		cm.setClientStockCode(ClientCode);
		cm.setClientName(ClientName);
		cm.setClientLogo(ClientLogo);
		cm.setClientSubName(ClientSubName);
		cm.setClientCopyRight(ClientCopyRight);
		cm.setClientThemeColor(ClientThemeColor);
		cm.setSmsSwitch(SmsSwitch);
		cm.setMetricsMapping(metricsMapping);
		ArrayList<HashMap<String, String>> slideList=new ArrayList<HashMap<String, String>>();
		HashMap<String, String> a=new HashMap<String, String>();
		a.put("src", Slide1);
		slideList.add(a);
		a=new HashMap<String, String>();
		a.put("src", Slide2);
		slideList.add(a);
		a=new HashMap<String, String>();
		a.put("src", Slide3);
		slideList.add(a);
		cm.setSlide(slideList);
		try{
			result = MongoDBBasic.updateClientMeta(cm);
		}
		catch(Exception e){
			result = false;
		}
		return String.valueOf(result);
	}
	@RequestMapping("/ActivaeClientMeta")
	public String ActivaeClientMeta(	@RequestParam(value="clientCode", required=true) String clientCode)
	{
		boolean result=false;
		try{
			MongoDBBasic.ActivaeClientMeta(clientCode);
			result=true;
		}
		catch(Exception e){
			result = false;
		}
		return String.valueOf(result);
	}
	
	@RequestMapping("/getDBUserGeoInfo")
	public static GeoLocation callGetDBUserGeoInfo(@RequestParam(value="OpenID", required=false) String OpenID){
		GeoLocation geoLocation = new GeoLocation();
		try{
			geoLocation = MongoDBBasic.getDBUserGeoInfo(OpenID);
		}		
		catch(Exception e){
			geoLocation = null;
		}
		return geoLocation;
	}
	

	

	@RequestMapping("/getFilterSegmentAreaFromMongo")
	public static  List<String> callGetFilterSegmentAreaFromMongo(@RequestParam(value="state", required=false) String state){
		List<String> segmentArea = new ArrayList<String>();
		try{
			segmentArea = MongoDBBasic.getFilterSegmentArea(state);
		}		
		catch(Exception e){
			segmentArea.add("--2--" + e.getMessage().toString());
		}
		return segmentArea;
	}
	

	@RequestMapping("/getFilterRegionFromMongo")
	public static  List<String> callGetFilterRegionFromMongo(@RequestParam(value="state", required=false) String state){
		List<String> regions = new ArrayList<String>();
		try{
			regions = MongoDBBasic.getFilterRegionFromMongo(state);
		}		
		catch(Exception e){
			regions.add("--2--" + e.getMessage().toString());
		}
		return regions;
	}
	
	@RequestMapping("/getFilterNonLatinCityFromMongo")
	public static  List<String> callGetFilterNonLatinCityFromMongo(@RequestParam(value="state", required=false) String state){
		List<String> nonLatiCities = new ArrayList<String>();
		try{
			nonLatiCities = MongoDBBasic.getFilterNonLatinCitiesFromMongo(state);
		}		
		catch(Exception e){
			nonLatiCities.add("--2--" + e.getMessage().toString());
		}
		return nonLatiCities;
	}
	
	@RequestMapping("/getFilterStateFromMongo")
	public static  List<String> callGetFilterStateFromMongo(){
		List<String> states = new ArrayList<String>();
		try{
			states = MongoDBBasic.getFilterStateFromMongo();
		}		
		catch(Exception e){
			states.add("--2--" + e.getMessage().toString());
		}
		return states;
	}
	
	@RequestMapping("/getFilterCountOnCriteriaFromMongo")
	public static  String CallgetFilterCountOnCriteriaFromMongo(@RequestParam(value="industrySegmentNames", required=false) String industrySegmentNames,
																@RequestParam(value="nonlatinCity", required=false) String nonlatinCity,
																@RequestParam(value="state", required=false) String state,
																@RequestParam(value="cityRegion", required=false) String cityRegion
			){
		String ret = "error";
		try{
			ret = String.valueOf(MongoDBBasic.getFilterCountOnCriteriaFromMongo(industrySegmentNames,nonlatinCity,state,cityRegion)) ;
		}		
		catch(Exception e){
			ret = e.getMessage().toString();
		}
		return ret;
	}
	
	/*
	 * by chang-zheng
	 */
	@RequestMapping("/CallgetFilterCountOnCriteriaFromMongoBylistOfSegmentArea")
	public static   Map<String,String> CallgetFilterCountOnCriteriaFromMongoBylistOfSegmentArea(@RequestParam(value="industrySegmentNames", required=false) List<String> industrySegmentNames,
																@RequestParam(value="nonlatinCity", required=false) String nonlatinCity,
																@RequestParam(value="state", required=false) String state,
																@RequestParam(value="cityRegion", required=false) String cityRegion
			){
		Map<String,String> ret = null;
		try{
			ret = MongoDBBasic.CallgetFilterCountOnCriteriaFromMongoBylistOfSegmentArea(industrySegmentNames,nonlatinCity,state,cityRegion) ;
		}		
		catch(Exception e){
			ret = null;
		}
		return ret;
	}
	
	@RequestMapping("/getFilterTotalOPSIFromMongo")
	public static  String CallgetFilterTotalOPSIFromMongo(
																@RequestParam(value="state", required=false) String state,
																@RequestParam(value="nonlatinCity", required=false) String nonlatinCity,
																@RequestParam(value="cityRegion", required=false) String cityRegion){
		String ret = "error";
		try{
			ret = MongoDBBasic.getFilterTotalOPSIFromMongo(state, nonlatinCity, cityRegion);
		}		
		catch(Exception e){
			ret = e.getMessage().toString();
		}
		return ret;
	}
	
	@RequestMapping("/getFilterOnIndustryByAggregateFromMongo")
	public static  List<String> CallgetFilterOnIndustryByAggregateFromMongo(){
		List<String> ret = new ArrayList<String>();
		ret.add("--in rest service--");
		try{
			ret = MongoDBBasic.getFilterOnIndustryByAggregateFromMongo();
		}		
		catch(Exception e){
			ret.add("----" + e.getMessage());
		}
		return ret;
	}
	
	@RequestMapping("/setLocationtoMongoDB")
	public static  String CallsetLocationtoMongoDB(@RequestParam(value="state", required=false) String state){
		String ret;

		try{
			ret = MongoDBBasic.setLocationtoMongoDB(state);
		}		
		catch(Exception e){
			ret = "error occurs...";
		}
		return ret;
	}


	@RequestMapping("/CallGetWeChatUserFromMongoDB")
	public static List<WeChatMDLUser> CallGetWeChatUserFromMongoDB(
			@RequestParam(value="openid", required=false) String openid
			){
		List<WeChatMDLUser> ret = new ArrayList<WeChatMDLUser>();;
		try{
			ret = MongoDBBasic.getWeChatUserFromMongoDB(openid);
		}		
		catch(Exception e){
			//ret.add(e.getMessage());
		}
		return ret;
	}
	
	@RequestMapping("/CallRegisterUser")
	public static boolean CallRegisterUser(
			@RequestParam(value="openid", required=false) String openid,
		//	@RequestParam(value="suppovisor", required=false) String suppovisor,
			@RequestParam(value="registerDate", required=false) String registerDate,
		//	@RequestParam(value="role", required=false) String role,
			@RequestParam(value="selfIntro", required=false) String selfIntro,
			@RequestParam(value="email", required=false) String email,
			@RequestParam(value="phone", required=false) String phone,
		//	@RequestParam(value="group", required=false) String groupid,
			@RequestParam(value="name", required=false) String name
		//	@RequestParam(value="skill", required=false) String skill
			){
		boolean ret = false;
		Teamer teamer = new Teamer();
		teamer.setOpenid(openid);
		teamer.setSelfIntro(selfIntro);
	//	teamer.setSuppovisor(suppovisor);
		teamer.setRegisterDate(registerDate);
	//	teamer.setRole(role);
		teamer.setEmail(email);
		teamer.setPhone(phone);
	//	teamer.setGroupid(groupid);
		teamer.setRealName(name);
		ArrayList taglist=new ArrayList();
	//	String[] tagArr = skill.split(",");
	/*	for(int i=0;i<tagArr.length;i++){
			String[] tag=tagArr[i].split(":");
			if(tag.length==2){
				HashMap<String, String> temp=new HashMap<String, String>();
				temp.put("key", tag[0]);
				temp.put("value", tag[1]);
				taglist.add(temp);
			}
		}*/
		//teamer.setTag(taglist);
		try{
			ret = MongoDBBasic.registerUser(teamer);
		}		
		catch(Exception e){
			ret = false;
		}
		return ret;
	}
	
	@RequestMapping("/CallUpdateOpptLatLngIntoMongoDB")
	public static String CallUpdateOpptLatLngIntoMongoDB( 
			@RequestParam(value="state", required=false) String state
			){
		String ret = "";
		try{
			ret = MongoDBBasic.updateOpptLatLngIntoMongoDB(state);
		}		
		catch(Exception e){
			ret = e.getMessage().toString();
		}
		return ret;
	}
	
	


	@RequestMapping("/CallCommandOPSIIntoMongoDB")
	public static Boolean CallUpdateOpptLatLngIntoMongoDB( 
			@RequestParam(value="field", required=false) String field,
			@RequestParam(value="src", required=false) String src,
			@RequestParam(value="tgt", required=false) String tgt,
			@RequestParam(value="cmd", required=false) String cmd
			){
		Boolean ret = false;
		try{
			ret = MongoDBBasic.modifyOrgSiteInstance(field,src,tgt,cmd);
		}		
		catch(Exception e){
			ret = false;
		}
		return ret;
	}
	
	@RequestMapping("/QueryClientMeta")
	public static ClientMeta CallQueryClientMeta(){
		ClientMeta cm = new ClientMeta();
		try{
			cm = MongoDBBasic.QueryClientMeta();
		}		
		catch(Exception e){
			cm = null;
		}
		return cm;
	}
	@RequestMapping("/QueryLikeAreaOpenidList")
	public static ArrayList<String> callQueryLikeAreaOpenidList(@RequestParam(value="roleOrAreaId", required=true) String roleOrAreaId){
		ArrayList<String> result = new ArrayList<String>();
		try{
			result = MongoDBBasic.QueryLikeAreaOpenidList(roleOrAreaId);
		}		
		catch(Exception e){
			result = null;
		}
		return result;
	}	
	@RequestMapping("/QueryClientMetaByClientCode")
	public static String QueryClientMetaByClientCode(){
		ClientMeta cm = new ClientMeta();
		try{
			cm = MongoDBBasic.QueryClientMeta(Constants.clientCode);
		}		
		catch(Exception e){
			cm = null;
		}
		String message=cm.getMetricsMapping();
		if(message==null||message==""){
			message="no no no '''...";
		}
		return message;
	}
	@RequestMapping("/QueryShortNewsList")
	public static ArrayList<ShortNews> QueryShortNewsList(){
		ArrayList<ShortNews> cm = new ArrayList<ShortNews>();
		try{
			cm = MongoDBBasic.queryShortNews();
		}		
		catch(Exception e){
			cm = null;
		}
		return cm;
	}
	@RequestMapping("/QueryShortNewsList2")
	public static ArrayList<ShortNews> QueryShortNewsList2(@RequestParam(value="startNumber", required=false) int startNumber,@RequestParam(value="pageSize", required=false) int pageSize){
		ArrayList<ShortNews> cm = new ArrayList<ShortNews>();
		if(startNumber<1){
			startNumber=0;
		}
		if(pageSize<1){
			pageSize=5;
		}
		try{
			cm = MongoDBBasic.queryShortNews(startNumber,pageSize);
		}		
		catch(Exception e){
			cm = null;
		}
		return cm;
	}
	
	@RequestMapping("/QueryArticleMessage")
	public static ArrayList<ArticleMessage> QueryArticleMessage(@RequestParam(value="startNumber", required=false) int startNumber,@RequestParam(value="pageSize", required=false) int pageSize){
		ArrayList<ArticleMessage> am = new ArrayList<ArticleMessage>();
		if(startNumber<1){
			startNumber=0;
		}
		if(pageSize<1){
			pageSize=5;
		}
		try{
			am = MongoDBBasic.queryArticleMessage(startNumber,pageSize);
		}		
		catch(Exception e){
			am = null;
		}
		return am;
	}
	@RequestMapping("/QueryVideoMessage")
	public static ArrayList<VideoMessage> QueryVideoMessage(@RequestParam(value="startNumber", required=false) int startNumber,@RequestParam(value="pageSize", required=false) int pageSize){
		ArrayList<VideoMessage> vm = new ArrayList<VideoMessage>();
		if(startNumber<1){
			startNumber=0;
		}
		if(pageSize<1){
			pageSize=5;
		}
		try{
			vm = MongoDBBasic.queryVideoMessage(startNumber,pageSize);
		}		
		catch(Exception e){
			vm = null;
		}
		return vm;
	}
	@RequestMapping("/deleteShortNews")
	public static boolean deleteShortNewsbyID(@RequestParam(value="id", required=true) String id){
		return MongoDBBasic.deleteShortNews(id);
	}
	
	
	@RequestMapping("/CallCreateShortNews")
	public @ResponseBody String CallCreateShortNews(@RequestParam(value="content", required=true) String reqContent) throws JSONException{
		MongoDBBasic.createShortNews(reqContent);
	//	String url="http://"+Constants.baehost+"/mdm/DailyNewsToShare.jsp?UID=";
		String url="";
		String title="";
		String content="";
		if(reqContent.length()>100){
			title=reqContent.substring(0,90)+"..";
			if(reqContent.length()>200){
			content=reqContent.substring(0,180)+"...";
			}
		}
		else
		{
			title=reqContent;
			content=reqContent;
		}
		List<WeChatMDLUser> allUser = MongoDBBasic.getWeChatUserFromMongoDB("");
	//	List<WeChatMDLUser> allUser = new ArrayList<WeChatMDLUser>();
	//	WeChatMDLUser wcu=new WeChatMDLUser();
	//	wcu.setOpenid("oO8exv5qxR-KcrpaSezZJsAfrQF4");
	//	allUser.add(wcu);
		int realReceiver=0;
        String status="";
		 for(int i=0;i<allUser.size();i++){
			 url="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constants.APP_ID+"&redirect_uri=http%3A%2F%2F"+Constants.baehost+"%2Fmdm%2FDailyNews.jsp?UID="+allUser.get(i).getOpenid()+"&response_type=code&scope=snsapi_userinfo&state="+allUser.get(i).getOpenid()+"#wechat_redirect";
			 status= RestUtils.sendQuotationToUser(allUser.get(i).getOpenid(),content,"http://leshucq.bj.bcebos.com/standard/standard_ThanksLetter.jpg","【"+allUser.get(i).getNickname()+"】"+title,url);
			 if(RestUtils.getValueFromJson(status,"errcode").equals("0")){
          	   realReceiver++;
             }
		 }
		
		
		 return realReceiver+" of "+allUser.size()+"";
	}
	@RequestMapping("/QueryClientMetaList")
	public static ArrayList<ClientMeta> QueryClientMetaList(){
		ArrayList<ClientMeta> cm = new ArrayList<ClientMeta>();
		try{
			cm = MongoDBBasic.QueryClientMetaList();
		}		
		catch(Exception e){
			cm = null;
		}
		return cm;
	}
	@RequestMapping("/QueryVisitPage")
	public static ArrayList<Map> QueryVisitPage(){
		ArrayList<Map> result = new ArrayList<Map>();
		try{
			result = MongoDBBasic.QueryVisitPage();
		}		
		catch(Exception e){
			result = null;
		}
		return result;
	}
	@RequestMapping("/QueryVisitPageAttention")
	public static ArrayList<Map> QueryVisitPageAttention(){
		ArrayList<Map> result = new ArrayList<Map>();
		try{
			result = MongoDBBasic.QueryVisitPageAttention();
		}		
		catch(Exception e){
			result = null;
		}
		return result;
	}
	@RequestMapping("/CallUpdateUserWithSignature")
	public static boolean CallUpdateUserWithSignature(
			@RequestParam(value="openid", required=false) String openid,
			@RequestParam(value="svg", required=false) String svg
			){
		boolean ret = false;
		try{
			ret = MongoDBBasic.updateUserWithSignature(openid, svg);
		}		
		catch(Exception e){
			ret = false;
		}
		return ret;
	}
	@RequestMapping("/saveArticleMessageSignUp")
	public static boolean saveArticleMessageSignUp(@RequestParam(value="num", required=true) String num,@RequestParam(value="name", required=true) String name,@RequestParam(value="phone", required=true) String phone){
		boolean ret = false;
		try{
			ret =  MongoDBBasic.saveArticleMessageSignUp(num,name,phone);
		}		
		catch(Exception e){
			ret = false;
		}
		return ret;
	}
	@RequestMapping("/updateUserPoint")
	public static int updateUserPoint(@RequestParam(value="fromUserName", required=true) String fromUserName,@RequestParam(value="randomNum", required=true) int randomNum){
		int ret = 0;
		try{
			ret =  MongoDBBasic.updateUserPoint(fromUserName, randomNum);
		}		
		catch(Exception e){
		}
		return ret;
	}
	@RequestMapping("/updateVisitPage")
	public static boolean updateVisitPage(@RequestParam(value="realName", required=true) String realName,@RequestParam(value="flag", required=true) String flag){
		boolean ret = false;
		try{
			ret =  MongoDBBasic.updateVisitPage(realName,flag);
		}		
		catch(Exception e){
			ret = false;
		}
		return ret;
	}
	@RequestMapping("/CallGetUserWithSignature")
	public static String CallGetUserWithSignature(@RequestParam(value="openid", required=false) String openid){
		String ret = "{";
		try{
			ret = ret + MongoDBBasic.getUserWithSignature(openid);
			ret =  ret + "}";
		}		
		catch(Exception e){
			ret = e.getMessage();
		}
		return ret;
	}
	
	@RequestMapping("/visitedDetailByTime")
	public static Map<String,List> visitedDetailByTime(@RequestParam(value="t", required=true) String type,@RequestParam(value="dt", required=false) String dateTime){
		Map<String, List> result=new HashMap<String,List>();
		
		if("w".equals(type)){
			List<QuoteVisit> temp=new ArrayList<QuoteVisit>();
			List<QuoteVisit> finnal=new ArrayList<QuoteVisit>();
			int currentDate=Integer.parseInt(RestUtils.getWeekOfDate(new Date()));
			int index=currentDate*(-1)+1;
			System.out.println("dateIndex~~~"+index);
			for(int i=index;i<=0;i++){
				System.out.println("implement index processing...."+RestUtils.getFreeDate(i));
				temp.addAll(MongoDBBasic.getVisitedDetailByWeek(RestUtils.getFreeDate(i)));
				for(int j=0;j<temp.size();j++){
					System.out.println("detail["+RestUtils.getFreeDate(i)+"]~~~"+temp.get(j).getName()+"=="+temp.get(j).getTotalVisited());
				}
			}			
			MongoDBBasic.combVisitedDetail(temp, finnal);
			String time=RestUtils.getFreeDate(index)+"~"+RestUtils.getFreeDate(0);
			result.put(time, finnal);
			return result;
		}
		else if("m".equals(type))
		{
			System.out.println("dateTime----"+dateTime);
			List<QuoteVisit> qvs=MongoDBBasic.getVisitedDetailByMonth(dateTime);
			result.put(dateTime,qvs);
		}
		return result;
		
	}
	
	@RequestMapping("/CallGetUserWithESignature")
	public static String CallGetUserWithESignature(@RequestParam(value="openid", required=false) String openid){
		String ret = "";
		try{
			ret = MongoDBBasic.getUserWithSignature(openid);

		}		
		catch(Exception e){
			ret = e.getMessage();
		}
		return ret;
	}
	
	@RequestMapping("/CallGetUserWithFaceUrl")
	public static String CallGetUserWithFaceUrl(@RequestParam(value="openid", required=false) String openid){
		String ret = "";
		try{
			ret = MongoDBBasic.getUserWithFaceUrl(openid);

		}		
		catch(Exception e){
			ret = e.getMessage();
		}
		return ret;
	}
	
	/*
	 * chang-zheng
	 * FOR billOfSell
	 
	@RequestMapping("/saveBill")
	public static String saveBill(){
		String ret = "success !!";
		BillOfSellPoi bos = new BillOfSellPoi();
		List<BillOfSell> billOfSellList;
		try {
			billOfSellList = bos.readXls();
			
			if(billOfSellList!=null){
				try{
					MongoDBBasic.saveBillOfSell(billOfSellList);
				}catch(Exception e){
					ret = e.getMessage();
				}	
			}
			
		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		return ret;
		
	}*/
	
	@RequestMapping("/addNewAppointment")
	public @ResponseBody String addNewAppointment(@RequestParam(value="name")String name,
			@RequestParam(value="tel")String tel,
			@RequestParam(value="addr")String addr,
			@RequestParam(value="age")String age,
			@RequestParam(value="sex")String sex,
			@RequestParam(value="school")String school,
			@RequestParam(value="subject")String subject){
		Appointment app=new Appointment();
		app.setAddr(addr);
		app.setTel(tel);
		app.setName(name);
		app.setAge(age);
		app.setSex(sex);
		app.setSchool(school);
		app.setSubject(subject);
		String status=MongoDBBasic.addNewAppointment(app);
		return status;
	}
	
    @RequestMapping("/details/{page}")
    @ResponseBody
    public AppointmentList details(@PathVariable("page") String page) {
    
        return MongoDBBasic.getAppointmentList(Integer.parseInt(page));
    }
	
    @RequestMapping("/getDetails")
    @ResponseBody
    public AppointmentList getDetails(@RequestParam("page") String page) {
        return MongoDBBasic.getAppointmentList(Integer.parseInt(page));
    }
	
    
	@RequestMapping("/getVisitedDetail")
	public @ResponseBody List<Visited> getVisitedByDate(@RequestParam(value="dateIndex")String dateIndex,@RequestParam(value="pageName")String pageName){
		String pn="";
		ArrayList<Map> visitedPageList=MongoDBBasic.QueryVisitPage();
		for(int i=0;i<visitedPageList.size();i++){
			if(visitedPageList.get(i).get("descName").toString().equals(pageName)){
				pn=visitedPageList.get(i).get("realName").toString().trim();
			}
		}
		int index=Integer.parseInt(dateIndex);
		String date=MongoDBBasic.getLastestDate(-6).get(index);
		return MongoDBBasic.getVisitedDetail(date,pn); 
	}
	@RequestMapping("/getSharedDetail")
	public @ResponseBody List<String> getSharedDetail(@RequestParam(value="openid")String openid,@RequestParam(value="date")String date,
			@RequestParam(value="pageName")String pageName,@RequestParam(value="nickName")String nickName){
		return MongoDBBasic.getSharedDetail(openid,date,pageName,nickName); 
	}
	@RequestMapping("/sendValidateCode")
	public String sendValidateCode(@RequestParam(value="phone")String phone,@RequestParam(value="code")String code){
		
		RestTest.testTemplateSMS(true, Constants.ucpass_accountSid,Constants.ucpass_token,Constants.ucpass_appId, "154680",phone,code);
		return "OK";
	}

}