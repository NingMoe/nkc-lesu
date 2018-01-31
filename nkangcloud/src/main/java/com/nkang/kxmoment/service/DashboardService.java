package com.nkang.kxmoment.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;
import org.bson.types.ObjectId;
import org.json.JSONArray;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.nkang.kxmoment.baseobject.ClientMeta;
import com.nkang.kxmoment.baseobject.DashboardStatus;
import com.nkang.kxmoment.baseobject.WeChatMDLUser;
import com.nkang.kxmoment.util.Constants;
import com.nkang.kxmoment.util.MongoDBBasic;
import com.nkang.kxmoment.util.RestUtils;
import com.nkang.kxmoment.util.SmsUtils.RestTest;
/**
 * Dashboard Service 
 * @author xue-ke.du
 *
 */
public class DashboardService {
	private static Logger logger = Logger.getLogger(DashboardService.class);
	private static DB db = MongoDBBasic.getMongoDB();
	private static DBCollection statusCollection = db.getCollection("DashboardStatus");
	private static Date lastsendtimestamp = new Date();
	/**
	 * Save or Update(if exists status of type)
	 * @param statusVo
	 * @return
	 */
	public static String saveStatus(DashboardStatus statusVo) {
		String status = "fail";
		try {
			if(statusVo==null||statusVo.equals("")){
				return status;
			}
			String statusStr = (String)statusVo.getStatus();
			statusStr = statusStr.replaceAll("\\\"", "\"");
			JSONArray obj = new JSONArray(statusStr);
			statusVo.setStatus(obj);
			DBObject dbObj = BasicDBObject.parse(statusVo.toString());
			DBObject query = new BasicDBObject();
			query.put("type", statusVo.getType());
			// insert or update
			statusCollection.update(query, dbObj, true, false);
			status = "success";
			int isDown=0;
			if(statusStr.toUpperCase().indexOf("DOWN")!=-1){
				isDown++;
			}
			//String codeAll="{\"map\":{\"status\":";	
			//String code404="{\"map\":{\"status\":\"404\"";
			//String code200="{\"map\":{\"status\":\"200\"";
			//String code405="{\"map\":{\"status\":\"405\",\"description\":\"Cleanse\"";		
			List<DashboardStatus> StrList = findAllStatusList();
			String str = StrList.toString();
			//int tatol=subCounter(str, codeAll);
			////int status404=subCounter(str, code404);
			//int status200=subCounter(str, code200);
			//int status405=subCounter(str, code405);
			//int ret=tatol-status200-status405;
			//logger.info("tatol:"+tatol+",status200:"+status200+",status405"+status405);
			//List<String> downList = new ArrayList<String>();
			String servers="";
			 //String regEx = "\\{\"map\":\\{\"status\":\"404\"(.*?),\"url\":\"(.*?)\"\\}";
			 String regEx = "\\{\"map\":\\{\"status\":\"404\"(.*?),\"url\":\"http://(.*?).houston.(.*?)\"\\}";
		        Pattern pat = Pattern.compile(regEx);
		        Matcher mat = pat.matcher(str);
		        String serverslistStr = "";
		        while(mat.find()){
		        	if(!servers.contains(mat.group(2))){
		        		servers+="【"+mat.group(2)+"】 ";
		        	}
		        	//downList.add(mat.group(2));
		        	//System.out.println(mat.group(2));
		        }
			
			Date dt = new Date();
			if(servers.length()>0 || isDown>0){
				if( dt.getTime() - lastsendtimestamp.getTime() > 1000*60*4){
					
					ClientMeta cm=MongoDBBasic.QueryClientMeta();
					String respContent = "MDM Production server abnormal notification SMS has been sent to:";
					logger.info("SmsSwitch:"+cm.getSmsSwitch());
					if(cm.getSmsSwitch()!=null&&"true".equals(cm.getSmsSwitch())){
						
						String templateId="62068";
						String para="";
						String to="";
						String userName="";
						ArrayList<HashMap> telList = MongoDBBasic.QuerySmsUser();

						//logger.info("telListSize:"+telList.size());
						/*List<String> telList = new ArrayList<String>();
						telList.add("15123944895");//Ning
						telList.add("13668046589");//Shok
						telList.add("15310898146");//Port
						telList.add("13661744205");//Garden*/
						
						for(HashMap T : telList){
							to = T.get("phone").toString();
							userName = T.get("realName").toString();
							respContent+=(userName+" ");
							if(to!=null && !"".equals(to)){
								RestTest.testTemplateSMS(true, Constants.ucpass_accountSid,Constants.ucpass_token,Constants.ucpass_appId, templateId,to,para);
							}
						}
						
						for(HashMap T : telList){
							List<String> toUser=new ArrayList<String>();
							toUser.add(T.get("OpenID").toString());
							RestUtils.sendTextMessageToUser(respContent,toUser);
						}
						//微信
						lastsendtimestamp = dt;
						 ArrayList<HashMap> smsUsers=MongoDBBasic.QuerySmsUser();
						
						String content="MDM Operation Team, Please immediately take actions to check and recover production environment. Please make sure the communication has been sent out timely! "+"Servers in exception as below:\n"+servers;
						String title=" MDM Production Environment is abnormal. Please urgently take actions!!!";
						for(int i=0;i<smsUsers.size();i++){
							String uri="https://open.weixin.qq.com/connect/oauth2/authorize?appid=wx19c8fd43a7b6525d&redirect_uri=http%3A%2F%2Fshenan.duapp.com%2Fmdm%2FDashboardStatus.jsp?UID="+smsUsers.get(i).get("OpenID").toString()+"&response_type=code&scope=snsapi_userinfo&state="+smsUsers.get(i).get("OpenID").toString()+"#wechat_redirect";
								RestUtils.sendQuotationToUser(smsUsers.get(i).get("OpenID").toString(),content,"https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000EBM2m&oid=00D90000000pkXM","【"+smsUsers.get(i).get("realName").toString()+"】"+title,uri);
						}

					}
				}
			}
			
		} catch (Exception e) {
			//logger.error("Save Status fail.", e);
			status = "fail";
		}
		return status;
	}
	
	//util
	
	public static int subCounter(String str1, String str2) {
		 
        int counter = 0;
        for (int i = 0; i <= str1.length() - str2.length(); i++) {
            if (str1.substring(i, i + str2.length()).equalsIgnoreCase(str2)) {
                counter++;
            }
        }
         return counter;
    }

	
	/**
	 * Get KM list
	 * @return
	 */
	public static List<DashboardStatus> findAllStatusList() {
		List<DashboardStatus> list = null;
		try {
			DBCursor cursor = statusCollection.find();
			if(cursor.length() > 0){
				list = new ArrayList<DashboardStatus>(cursor.size());
			}
			Iterator<DBObject> iterator = cursor.iterator();
			while (iterator.hasNext()) {
				DBObject dbObject = (DBObject) iterator.next();
				DashboardStatus statusVo =  DashboardStatus.gson.fromJson(dbObject.toString(), DashboardStatus.class);
				list.add(statusVo);
			}
		} catch (Exception e) {
			logger.error("Find KM List fail.", e);
			list = null;
		}
		return list;
	}

	/**
	 * get status detail
	 * @param type
	 * @return
	 */
	public static DashboardStatus getStatus(String type) {
		DashboardStatus statusVo = null;
		try {
			DBObject query = new BasicDBObject();
			query.put("type", new ObjectId(type));
			DBCursor cursor = statusCollection.find(query);
			Iterator<DBObject> iterator = cursor.iterator();
			if (iterator.hasNext()) {
				DBObject dbObject = (DBObject) iterator.next();
				statusVo = DashboardStatus.gson.fromJson(dbObject.toString(), DashboardStatus.class);
			}
		} catch (Exception e) {
			logger.error("Get status Detail fail.", e);
			statusVo = null;
		}
		return statusVo;
	}
}
