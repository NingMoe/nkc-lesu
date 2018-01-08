package com.nkang.kxmoment.util;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.ResourceBundle;
import java.util.regex.Pattern;

import org.apache.log4j.Logger;
import org.bson.types.ObjectId;

import com.mongodb.AggregationOutput;
import com.mongodb.BasicDBList;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.MongoClientOptions;
import com.mongodb.MongoCredential;
import com.mongodb.ServerAddress;
import com.mongodb.WriteResult;
import com.nkang.kxmoment.baseobject.AbacusQuizPool;
import com.nkang.kxmoment.baseobject.AbacusRank;
import com.nkang.kxmoment.baseobject.Appointment;
import com.nkang.kxmoment.baseobject.ArticleMessage;
import com.nkang.kxmoment.baseobject.ClientMeta;
import com.nkang.kxmoment.baseobject.CongratulateHistory;
import com.nkang.kxmoment.baseobject.GeoLocation;
import com.nkang.kxmoment.baseobject.HistoryQuiz;
import com.nkang.kxmoment.baseobject.MongoClientCollection;
import com.nkang.kxmoment.baseobject.Notification;
import com.nkang.kxmoment.baseobject.Quiz;
import com.nkang.kxmoment.baseobject.QuoteVisit;
import com.nkang.kxmoment.baseobject.RoleOfAreaMap;
import com.nkang.kxmoment.baseobject.ShortNews;
import com.nkang.kxmoment.baseobject.Teamer;
import com.nkang.kxmoment.baseobject.VideoMessage;
import com.nkang.kxmoment.baseobject.Visited;
import com.nkang.kxmoment.baseobject.WeChatAccessKey;
import com.nkang.kxmoment.baseobject.WeChatMDLUser;
import com.nkang.kxmoment.baseobject.WeChatUser;
import com.nkang.kxmoment.baseobject.classhourrecord.Classexpenserecord;
import com.nkang.kxmoment.baseobject.classhourrecord.Classpayrecord;
import com.nkang.kxmoment.baseobject.classhourrecord.StudentBasicInformation;
import com.nkang.kxmoment.util.Constants;
import com.nkang.kxmoment.util.SmsUtils.RestTest;

public class MongoDBBasic {
	private static Logger log = Logger.getLogger(MongoDBBasic.class);
	private static DB mongoDB = null;
	private static String collectionMasterDataName = "masterdata";
	private static String access_key = "Access_Key";
	private static String wechat_user = "Wechat_User";
	private static String short_news = "ShortNews";
	private static String Article_Message = "Article_Message";
	private static String APPOINTMENT = "Appointment";
	private static String Quiz_Pool = "QuizPool";
	private static String Video_Message = "Video_Message";
	private static String ClientMeta = "Client_Meta";
	private static String collectionAbacusQuizPool = "AbacusQuizPool";
	private static String role_area = "RoleOfAreaMap";
	private static String collectionVisited = "Visited";
	private static String collectionHistoryAbacus = "HistoryAbacus";
	private static String collectionAbacusRank="AbacusRank";
	private static String collectionClassPayRecord="ClassPayRecord";
	private static String collectionClassExpenseRecord="ClassExpenseRecord";
	
	public static DB getMongoDB() {
		if (mongoDB != null) {
			return mongoDB;
		}
		MongoClientCollection mongoClientCollection = new MongoClientCollection();
		ResourceBundle resourceBundle = ResourceBundle.getBundle("database_info");
		String databaseName = resourceBundle.getString("databaseName");
		String hostm = resourceBundle.getString("hostm");
		String portm = resourceBundle.getString("portm");
		String usrname = resourceBundle.getString("usrname");
		String passwrd = resourceBundle.getString("passwrd");
		String serverName = hostm + ":" + portm;

		MongoClient mongoClient = new MongoClient(
				new ServerAddress(serverName),
				// createMongoCRCredential / createScramSha1Credential
				Arrays.asList(MongoCredential.createMongoCRCredential(usrname, databaseName, passwrd.toCharArray())),
				new MongoClientOptions.Builder().cursorFinalizerEnabled(false).build());
		mongoClientCollection.setMongoClient(mongoClient);

		mongoDB = mongoClient.getDB(databaseName);
		// mongoDB.addUser(usrname, passwrd.toCharArray());

		return mongoDB;
	}

	public static String getValidAccessKey() {
		String AccessKey = QueryAccessKey();
		log.info("getValidAccessKey ------>"+AccessKey);
		if (AccessKey == null) {
			AccessKey = RestUtils.getAccessKey();
			log.info("RestUtils.getAccessKey ------>"+AccessKey);
		}
		
		return AccessKey;
	}

	public static void updateAccessKey(String key, String expiresIn) {
		try {
			mongoDB = getMongoDB();
			DBObject dbo = new BasicDBObject();
			dbo.put("WeChatAccessKey.AKey",key);
			dbo.put("WeChatAccessKey.ExpiresIn",Integer.valueOf(expiresIn));
			java.sql.Timestamp cursqlTS = new java.sql.Timestamp(new java.util.Date().getTime());
			dbo.put("WeChatAccessKey.LastUpdated", DateUtil.timestamp2Str(cursqlTS));
			BasicDBObject doc = new BasicDBObject();
			doc.put("$set", dbo);
			mongoDB.getCollection(ClientMeta).update(new BasicDBObject().append("ClientCode",Constants.clientCode), doc);
			log.info("updateAccessKey end");
		} catch (Exception e) {
			log.info("updateAccessKey--" + e.getMessage());
		}
	}
	public static String getTicket() {
		String Ticket=null;
		try {
			mongoDB = getMongoDB();
			DBObject queryresult = mongoDB.getCollection(ClientMeta).findOne(new BasicDBObject().append("ClientCode", Constants.clientCode));
			if (queryresult != null) {
				Object WeChatTicket = queryresult.get("WeChatTicket");
				DBObject o = new BasicDBObject();
				o = (DBObject) WeChatTicket;
				if (o != null) {
					if (o.get("LastUpdated") != null) {
						long nowDate=new java.util.Date().getTime();
						long startDate=Long.parseLong(o.get("LastUpdated").toString());
						if(nowDate-startDate<(7100*1000)){
							Ticket=o.get("Ticket").toString();
						}else{
							Ticket=null;
						}
					}
				}
			}
			log.info("getTicket end---" + Ticket);
		} catch (Exception e) {
			log.info("getTicket--" + e.getMessage());
		}
		return Ticket;
	}
	public static void updateTicket(String ticket, String expiresIn) {
		try {
			mongoDB = getMongoDB();
			DBObject dbo = new BasicDBObject();
			dbo.put("WeChatTicket.Ticket",ticket);
			dbo.put("WeChatTicket.ExpiresIn",Integer.valueOf(expiresIn));
			dbo.put("WeChatTicket.LastUpdated",new java.util.Date().getTime());
			BasicDBObject doc = new BasicDBObject();
			doc.put("$set", dbo);
			mongoDB.getCollection(ClientMeta).update(new BasicDBObject().append("ClientCode",Constants.clientCode), doc);
			log.info("updateTicket end");
		} catch (Exception e) {
			log.info("updateTicket--" + e.getMessage());
		}
	}
	

	public static String QueryAccessKey() {
		String validKey = null;
		mongoDB = getMongoDB();
		java.sql.Timestamp sqlTS = null;
		java.sql.Timestamp cursqlTS = new java.sql.Timestamp(
				new java.util.Date().getTime());
		WeChatAccessKey wcak = new WeChatAccessKey();
		try {
			DBCursor dbcur = mongoDB.getCollection(ClientMeta).find(new BasicDBObject().append("ClientCode", Constants.clientCode));
			if (null != dbcur) {
				
				while (dbcur.hasNext()) {
					DBObject DBObj = dbcur.next();
					Object obj = DBObj.get("WeChatAccessKey");
					if (obj == null) {
						return null;
					}
					DBObject o = new BasicDBObject();
					o = (DBObject) obj;
					wcak.setAKey((String) o.get("AKey"));
					wcak.setExpiresIn((Integer) o.get("ExpiresIn"));
					wcak.setLastUpdated((String) o.get("LastUpdated"));
				}

			validKey = wcak.getAKey();
			String timehere = wcak.getLastUpdated();
			sqlTS = DateUtil.str2Timestamp(timehere);
			int diff = (int) ((cursqlTS.getTime() - sqlTS.getTime()) / 1000);
			if ((7200 - diff) > 0) {
			} else {
				log.info(diff
						+ " is close to 7200. and is to re-generate the key");
				validKey = null;
			}
			}

		} catch (Exception e) {
			log.info("QueryAccessKey--" + e.getMessage());
		}
		log.info("QueryAccessKey--> "+validKey);
		return validKey;
	}
	
	
	public static boolean checkUserAuth(String OpenID, String RoleName) {
		mongoDB = getMongoDB();
		try {
			DBObject query = new BasicDBObject();
			query.put("OpenID", OpenID);
			query.put(RoleName, "true");
			DBObject queryresult = mongoDB.getCollection(wechat_user).findOne(
					query);
			if (queryresult != null) {
				return true;
			}
		} catch (Exception e) {
			log.info("queryEmail--" + e.getMessage());
		}
		return false;
	}

	public static boolean createShortNews(String content) {
		mongoDB = getMongoDB();
		Boolean ret = false;
		try {
			Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			String dateNowStr = sdf.format(d);

			DBObject insert = new BasicDBObject();
			insert.put("date", dateNowStr);
			insert.put("content", content);
			mongoDB.getCollection(short_news).insert(insert);
			ret = true;
		} catch (Exception e) {
			log.info("createRoleOfAreaMap--" + e.getMessage());
		}
		return ret;
	}

	public static ArrayList<ShortNews> queryShortNews() {
		mongoDB = getMongoDB();
		ArrayList<ShortNews> result = new ArrayList<ShortNews>();
		BasicDBObject sort = new BasicDBObject();
		sort.put("date", -1);
		DBCursor dbcur = mongoDB.getCollection(short_news).find().sort(sort);
		StringBuilder tempStr;
		if (null != dbcur) {
			while (dbcur.hasNext()) {
				DBObject o = dbcur.next();
				ShortNews temp = new ShortNews();
				if (o.get("date") != null) {
					tempStr = new StringBuilder(o.get("date").toString());
					tempStr.insert(tempStr.length() - 9, "<br/>");
					temp.setDate(tempStr.toString());
				}
				if (o.get("content") != null) {
					temp.setContent(o.get("content").toString());
				}
				temp.setMongoID(o.get("_id").toString());
				result.add(temp);
			}
		}
		return result;
	}

	public static ArrayList<ShortNews> queryShortNews(int startNumber,
			int pageSize) {
		mongoDB = getMongoDB();
		ArrayList<ShortNews> result = new ArrayList<ShortNews>();
		BasicDBObject sort = new BasicDBObject();
		sort.put("date", -1);
		DBCursor dbcur = mongoDB.getCollection(short_news).find().sort(sort)
				.skip(startNumber).limit(pageSize);
		StringBuilder tempStr;
		if (null != dbcur) {
			while (dbcur.hasNext()) {
				DBObject o = dbcur.next();
				ShortNews temp = new ShortNews();
				if (o.get("date") != null) {
					tempStr = new StringBuilder(o.get("date").toString());
					tempStr.insert(tempStr.length() - 9, "<br/>");
					temp.setDate(tempStr.toString());
				}
				if (o.get("content") != null) {
					temp.setContent(o.get("content").toString());
				}
				temp.setMongoID(o.get("_id").toString());
				result.add(temp);
			}
		}
		return result;
	}

	public static ArrayList<ArticleMessage> queryArticleMessage(
			int startNumber, int pageSize) {
		mongoDB = getMongoDB();
		ArrayList<ArticleMessage> result = new ArrayList<ArticleMessage>();
		BasicDBObject sort = new BasicDBObject();
		sort.put("_id", -1);
		DBCursor dbcur = mongoDB.getCollection(Article_Message).find()
				.sort(sort).skip(startNumber).limit(pageSize);
		if (null != dbcur) {
			while (dbcur.hasNext()) {
				DBObject o = dbcur.next();
				ArticleMessage temp = new ArticleMessage();
				if (o.get("time") != null) {
					temp.setTime(o.get("time").toString());
				}
				if (o.get("content") != null) {
					temp.setContent(o.get("content").toString());
				}
				if (o.get("num") != null) {
					temp.setNum(o.get("num").toString());
				}
				if (o.get("title") != null) {
					temp.setTitle(o.get("title").toString());
				}
				if (o.get("picture") != null) {
					temp.setPicture(o.get("picture").toString());
				}
				if (o.get("isForward") != null) {
					temp.setIsForward(o.get("isForward").toString());
				}
				result.add(temp);
			}
		}
		return result;
	}
	public static ArrayList<VideoMessage> queryVideoMessage(
			int startNumber, int pageSize) {
		mongoDB = getMongoDB();
		ArrayList<VideoMessage> result = new ArrayList<VideoMessage>();
		BasicDBObject sort = new BasicDBObject();
		sort.put("_id", -1);
		DBCursor dbcur = mongoDB.getCollection(Video_Message).find()
				.sort(sort).skip(startNumber).limit(pageSize);
		if (null != dbcur) {
			while (dbcur.hasNext()) {
				DBObject o = dbcur.next();
				VideoMessage temp = new VideoMessage();
				if (o.get("time") != null) {
					temp.setTime(o.get("time").toString());
				}
				if (o.get("content") != null) {
					temp.setContent(o.get("content").toString());
				}
				if (o.get("num") != null) {
					temp.setNum(o.get("num").toString());
				}
				if (o.get("title") != null) {
					temp.setTitle(o.get("title").toString());
				}
				if (o.get("isReprint") != null) {
					temp.setIsReprint(o.get("isReprint").toString());
				}
				if (o.get("isForward") != null) {
					temp.setIsForward(o.get("isForward").toString());
				}
				if (o.get("webUrl") != null) {
					temp.setWebUrl(o.get("webUrl").toString());
				}
				result.add(temp);
			}
		}
		return result;
	}

	public static boolean deleteShortNews(String id) {
		Boolean ret = false;
		try {
			DBObject removeQuery = new BasicDBObject();
			removeQuery.put("_id", new ObjectId(id));
			mongoDB.getCollection(short_news).remove(removeQuery);
			ret = true;
		} catch (Exception e) {
			log.info("remove--" + e.getMessage());
		}
		return ret;

	}

	public static List<String> queryUserKM(String openid) {
		mongoDB = getMongoDB();
		List<String> kmLists = new ArrayList<String>();
		try {
			DBCursor dbcur = mongoDB.getCollection(wechat_user).find(
					new BasicDBObject().append("OpenID", openid));
			if (null != dbcur) {
				while (dbcur.hasNext()) {
					DBObject o = dbcur.next();
					if (o.get("likeLists") != null) {
						BasicDBList hist = (BasicDBList) o.get("likeLists");
						Object[] kmObjects = hist.toArray();
						for (Object dbobj : kmObjects) {
							if (dbobj instanceof String) {
								kmLists.add((String) dbobj);
							}
						}
					}
				}
			}
		} catch (Exception e) {
			log.info("queryUserKM--" + e.getMessage());
		}
		return kmLists;
	}
	
	public static boolean delAllAreaOrRole(String openid,String flag) {
		mongoDB = getMongoDB();
		Boolean ret = false;
		try {
			HashSet<String> kmSets = new HashSet<String>();
			DBCursor dbcur = mongoDB.getCollection(wechat_user).find(
					new BasicDBObject().append("OpenID", openid));
			if (null != dbcur) {
				while (dbcur.hasNext()) {
					DBObject o = dbcur.next();
					if (o.get("likeLists") != null) {
						BasicDBList hist = (BasicDBList) o.get("likeLists");
						Object[] kmObjects = hist.toArray();
						for (Object dbobj : kmObjects) {
							if (dbobj instanceof String) {
								if (!((String) dbobj).startsWith(flag)){
									kmSets.add((String) dbobj);
								}
							}
						}
					}
				}
			}
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			update.put("likeLists", kmSets);
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(wechat_user).update(
					new BasicDBObject().append("OpenID", openid), doc);
			ret = true;

		} catch (Exception e) {
			log.info("delAllAreaOrRole--" + e.getMessage());
		}
		return ret;
	}
	public static boolean saveUserKM(String openid, String kmItem, String flag) {
		kmItem = kmItem.trim();
		mongoDB = getMongoDB();
		Boolean ret = false;
		try {
			HashSet<String> kmSets = new HashSet<String>();
			DBCursor dbcur = mongoDB.getCollection(wechat_user).find(
					new BasicDBObject().append("OpenID", openid));
			if (null != dbcur) {
				while (dbcur.hasNext()) {
					DBObject o = dbcur.next();
					if (o.get("likeLists") != null) {
						BasicDBList hist = (BasicDBList) o.get("likeLists");
						Object[] kmObjects = hist.toArray();
						for (Object dbobj : kmObjects) {
							if (dbobj instanceof String) {
								if ("del".equals(flag)) {
									if (!kmItem.equals((String) dbobj)) {
										kmSets.add((String) dbobj);
									}
								} else {
									kmSets.add((String) dbobj);
								}
							}
						}
					}
				}
			}
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			if ("add".equals(flag)) {
				kmSets.add(kmItem);
			}
			update.put("likeLists", kmSets);
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(wechat_user).update(
					new BasicDBObject().append("OpenID", openid), doc);
			ret = true;

		} catch (Exception e) {
			log.info("saveUserKM--" + e.getMessage());
		}
		return ret;
	}

	public static HashMap<String, String> getWeChatUserFromOpenID(String OpenID) {
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		query.put("OpenID", OpenID);
		System.out.println("OpenID----"+OpenID);
		HashMap<String, String> res = null;
		DBCursor queryresults = mongoDB.getCollection(wechat_user).find(query)
				.limit(1);
		if (null != queryresults&&queryresults.hasNext()) {

			System.out.println("queryresults has data----");
			res=new HashMap<String, String>();
			DBObject o = queryresults.next();
			if (o.get("HeadUrl") != null) {
				res.put("HeadUrl", o.get("HeadUrl").toString());
			}
			if (o.get("NickName") != null) {
				res.put("NickName", o.get("NickName").toString());
			}
			Object teamer = o.get("Teamer");
			DBObject teamobj = new BasicDBObject();
			teamobj = (DBObject) teamer;
			if (teamobj != null) {
				if (teamobj.get("realName") != null) {
					res.put("NickName", teamobj.get("realName").toString());
				}
				if (teamobj.get("role") != null) {
					res.put("role", teamobj.get("role").toString());
				}

				if (teamobj.get("level") != null) {
					res.put("level", teamobj.get("level").toString());
					System.out.println("level----------:"+teamobj.get("level").toString());
				}
				if (teamobj.get("phone") != null) {
					res.put("phone", teamobj.get("phone").toString());
				}
			}
			if (o.get("IsAuthenticated") != null) {
				res.put("IsAuthenticated", o.get("IsAuthenticated").toString());
			}
		}
		return res;
	}
	public static List<QuoteVisit> getVisitedDetailByWeek(String date) {
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		query.put("date", date);
		query.put("pageName", "profile");
		List<QuoteVisit> quoteVisit = new ArrayList<QuoteVisit>();
		DBCursor queryresults = mongoDB.getCollection(collectionVisited).find(
				query);
		System.out.println("implement mongo query....");
		if (null != queryresults) {
			while(queryresults.hasNext()){
			DBObject o = queryresults.next();
			QuoteVisit qv;
			if (o.get("nickName") != null) {
				qv = new QuoteVisit();
				qv.setName(o.get("nickName").toString());
				System.out.println("realName==="+o.get("nickName").toString());
				qv.setTotalVisited(o.get("visitedNum").toString());
				System.out.println("realvisited==="+o.get("visitedNum").toString());
				quoteVisit.add(qv);
			}
		}
		}
		List<QuoteVisit> quoteVisitCount = new ArrayList<QuoteVisit>();
		combVisitedDetail(quoteVisit,quoteVisitCount);
		return quoteVisitCount;
	}
	public static void combVisitedDetail(List<QuoteVisit> before,List<QuoteVisit> after){
        for (QuoteVisit qv : before) {  
            boolean state = false;  
            for (QuoteVisit qvs : after) {  
                if(qvs.getName().equals(qv.getName())){  
                    int count = Integer.parseInt(qvs.getTotalVisited());  
                    count += Integer.parseInt(qv.getTotalVisited());
                    qvs.setTotalVisited(count+"");
                    state = true;  
                }  
            }  
            if(!state){  
            	after.add(qv);  
            }  
        }
	}
	public static List<QuoteVisit> getVisitedDetailByMonth(String month) {
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		Pattern pattern = Pattern.compile("^.*" + month + ".*$",
				Pattern.CASE_INSENSITIVE);
		query.put("date", pattern);
		query.put("pageName", "profile");
		List<QuoteVisit> quoteVisit = new ArrayList<QuoteVisit>();
		DBCursor queryresults = mongoDB.getCollection(collectionVisited).find(
				query);
		if (null != queryresults) {
			while(queryresults.hasNext()){
	 		DBObject o = queryresults.next();
			QuoteVisit qv;
			if (o.get("nickName") != null) {
				qv = new QuoteVisit();
				qv.setName(o.get("nickName").toString());
				System.out.println("realName==="+o.get("nickName").toString());
				qv.setTotalVisited(o.get("visitedNum").toString());
				System.out.println("realvisited==="+o.get("visitedNum").toString());
				quoteVisit.add(qv);
			}
		}
		}
		List<QuoteVisit> quoteVisitCount = new ArrayList<QuoteVisit>();
		combVisitedDetail(quoteVisit,quoteVisitCount);
		return quoteVisitCount;
	}



	

	public static String ActivaeClientMeta(String clientCode) {
		String cm = "";
		mongoDB = getMongoDB();
		try {
			DBObject query = new BasicDBObject();
			query.put("ClientCode", clientCode);
			String clientName = mongoDB.getCollection(ClientMeta)
					.findOne(query).get("ClientName").toString();
			if (!StringUtils.isEmpty(clientName)) {
				BasicDBObject doc = new BasicDBObject();
				DBObject update = new BasicDBObject();
				update.put("Active", "Y");
				doc.put("$set", update);
				WriteResult wr = mongoDB.getCollection(ClientMeta).update(
						new BasicDBObject().append("ClientCode", clientCode),
						doc);

				// disable other clients
				DBObject q = new BasicDBObject();
				q.put("ClientCode", new BasicDBObject("$ne", clientCode));
				q.put("Active", "Y");
				DBCursor dbcur = mongoDB.getCollection(ClientMeta).find(q);
				if (null != dbcur) {
					while (dbcur.hasNext()) {
						DBObject o = dbcur.next();
						DBObject qry = new BasicDBObject();
						qry.put("ClientCode", new BasicDBObject("$ne",
								clientCode));
						qry.put("Active", "Y");
						BasicDBObject doc1 = new BasicDBObject();
						DBObject update1 = new BasicDBObject();
						update1.put("Active", "N");
						doc1.put("$set", update1);
						WriteResult wr1 = mongoDB.getCollection(ClientMeta)
								.update(qry, doc1);
					}
				}
				cm = clientName;
			}
		} catch (Exception e) {
			log.info("ActivaeClientMeta--" + e.getMessage());
			cm = e.getMessage();
		}
		return cm;
	}

	@SuppressWarnings("null")
	public static WeChatUser queryWeChatUser(String OpenID) {
		mongoDB = getMongoDB();
		WeChatUser ret = null;
		try {
			DBObject query = new BasicDBObject();
			query.put("OpenID", OpenID);
			DBObject queryresult = mongoDB.getCollection(wechat_user).findOne(
					query);
			if (queryresult != null) {
				ret.setLat(queryresult.get("CurLAT").toString());
				ret.setLng(queryresult.get("CurLNG").toString());
				ret.setOpenid(OpenID);
			}
		} catch (Exception e) {
			log.info("queryWeChatUser--" + e.getMessage());
		}
		return ret;
	}
	@SuppressWarnings("null")
	public static String queryAttrByOpenID(String attr,String OpenID,boolean isTeamer) {
		mongoDB = getMongoDB();
		try {
			DBObject query = new BasicDBObject();
			query.put("OpenID", OpenID);
			DBObject queryresult = mongoDB.getCollection(wechat_user).findOne(
					query);
			if (queryresult != null) {
				if(isTeamer){
					Object teamer = queryresult.get("Teamer");
					DBObject teamobj = new BasicDBObject();
					teamobj = (DBObject) teamer;
					if (teamobj != null) {
						if (teamobj.get(attr) != null) {

							return teamobj.get(attr).toString();
						}
					}
					
				}else{
				return queryresult.get(attr).toString();
				}
			}
		} catch (Exception e) {
			log.info("queryWeChatUser--" + e.getMessage());
		}
		return "";
	}
	
	public static boolean queryWeChatUserTelephone(String telephone) {
		mongoDB = getMongoDB();
		try {
			DBObject query = new BasicDBObject();
			query.put("telephone", telephone);
			DBObject queryresult = mongoDB.getCollection(wechat_user).findOne(
					query);
			if (queryresult != null) {
				return true;
			}
		} catch (Exception e) {
			log.info("queryTelephone--" + e.getMessage());
		}
		return false;
	}

	public static boolean queryWeChatUserEmail(String email) {
		mongoDB = getMongoDB();
		try {
			DBObject query = new BasicDBObject();
			query.put("email", email);
			DBObject queryresult = mongoDB.getCollection(wechat_user).findOne(
					query);
			if (queryresult != null) {
				return true;
			}
		} catch (Exception e) {
			log.info("queryEmail--" + e.getMessage());
		}
		return false;
	}

	public static boolean createUser(WeChatUser wcu) {
		mongoDB = getMongoDB();
		java.sql.Timestamp cursqlTS = new java.sql.Timestamp(
				new java.util.Date().getTime());
		Boolean ret = false;
		try {
			DBObject insert = new BasicDBObject();
			insert.put("OpenID", wcu.getOpenid());
			insert.put("HeadUrl", wcu.getHeadimgurl());
			insert.put("NickName", wcu.getNickname());
			insert.put("Created", DateUtil.timestamp2Str(cursqlTS));
			insert.put("FormatAddress", "");
			insert.put("CurLAT", "");
			insert.put("CurLNG", "");
			insert.put("LastUpdatedDate", DateUtil.timestamp2Str(cursqlTS));
			mongoDB.getCollection(wechat_user).insert(insert);
			ret = true;
		} catch (Exception e) {
			log.info("createUser--" + e.getMessage());
		}
		return ret;
	}

	public static boolean checkUserPoint(String OpenID) {
		mongoDB = getMongoDB();
		boolean ret = false;
		String date = "";
		try {
			DBObject result = mongoDB.getCollection(wechat_user).findOne(
					new BasicDBObject().append("OpenID", OpenID));
			Object likeobj = result.get("Point");
			DBObject like = new BasicDBObject();
			like = (DBObject) likeobj;
			if (like != null) {
				if (like.get("date") != null) {
					date = like.get("date").toString();
				}
			}
			Date d = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
			String dateNowStr = sdf.format(d);
			if (dateNowStr.equals(date)) {
				ret = false;
			} else {
				ret = true;
			}
		} catch (Exception e) {
			log.info("registerUser--" + e.getMessage());
		}
		return ret;
	}

	public static int updateUserPoint(String OpenID, int point) {
		mongoDB = getMongoDB();
		int pointSum = point;
		try {
			DBObject result = mongoDB.getCollection(wechat_user).findOne(
					new BasicDBObject().append("OpenID", OpenID));
			Object likeobj = result.get("Point");
			DBObject like = new BasicDBObject();
			like = (DBObject) likeobj;
			if (like != null) {
				if (like.get("num") != null) {
					pointSum = Integer.parseInt(like.get("num").toString())
							+ point;
				}
			}
			if (point != 0) {
				DBObject dbo = new BasicDBObject();
				dbo.put("Point.num", pointSum);
				Date d = new Date();
				SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
				String dateNowStr = sdf.format(d);

				dbo.put("Point.date", dateNowStr);

				BasicDBObject doc = new BasicDBObject();
				doc.put("$set", dbo);
				WriteResult wr = mongoDB.getCollection(wechat_user).update(
						new BasicDBObject().append("OpenID", OpenID), doc);
			}
		} catch (Exception e) {
			log.info("registerUser--" + e.getMessage());
		}
		return pointSum;
	}
	
	public static boolean registerUser(Teamer teamer) {
		mongoDB = getMongoDB();
		java.sql.Timestamp cursqlTS = new java.sql.Timestamp(
				new java.util.Date().getTime());
		Boolean ret = false;
		String OpenID = teamer.getOpenid();
		try {
			DBCursor dbcur = mongoDB.getCollection(wechat_user).find(
					new BasicDBObject().append("OpenID", OpenID));
			if (null != dbcur) {
				while (dbcur.hasNext()) {
					DBObject o = dbcur.next();
					DBObject dbo = new BasicDBObject();
					dbo.put("Teamer.openid", teamer.getOpenid());
					// dbo.put("Teamer.groupid", teamer.getGroupid());
					dbo.put("IsRegistered", "true");
					dbo.put("Teamer.realName", teamer.getRealName());
					dbo.put("Teamer.email", teamer.getEmail());
					dbo.put("Teamer.phone", teamer.getPhone());
					// dbo.put("Teamer.role", teamer.getRole());
					dbo.put("Teamer.selfIntro", teamer.getSelfIntro());
					// dbo.put("Teamer.suppovisor", teamer.getSuppovisor());
					// dbo.put("Teamer.tag", teamer.getTag());
					Object teamer2 = o.get("Teamer");
					if (teamer2 == null) {
						dbo.put("Teamer.registerDate", teamer.getRegisterDate());
					}
					BasicDBObject doc = new BasicDBObject();
					doc.put("$set", dbo);
					WriteResult wr = mongoDB.getCollection(wechat_user).update(
							new BasicDBObject().append("OpenID", OpenID), doc);
					ret = true;
				}
			}
		} catch (Exception e) {
			log.info("registerUser--" + e.getMessage());
		}
		return ret;
	}

	public static boolean removeUser(String OpenID) {
		mongoDB = getMongoDB();
		java.sql.Timestamp cursqlTS = new java.sql.Timestamp(
				new java.util.Date().getTime());
		Boolean ret = false;
		try {
			DBObject removeQuery = new BasicDBObject();
			removeQuery.put("OpenID", OpenID);
			mongoDB.getCollection(wechat_user).remove(removeQuery);
			ret = true;
		} catch (Exception e) {
			log.info("removeUser--" + e.getMessage());
		}
		return ret;
	}

	public static boolean modifyOrgSiteInstance(String field, String source,
			String target, String cmd) {
		mongoDB = getMongoDB();
		Boolean ret = false;
		try {
			if (StringUtils.isEqual(cmd, "remove")) {
				DBObject removeQuery = new BasicDBObject();
				removeQuery.put(field, source);
				mongoDB.getCollection(collectionMasterDataName).remove(
						removeQuery);
				ret = true;
			} else if (StringUtils.isEqual(cmd, "modify")) {
				for (int i = 0; i < 100; i++) {
					DBObject findQuery = new BasicDBObject();
					findQuery.put(field, source);
					DBObject updateQuery = new BasicDBObject();
					updateQuery.put(field, target);
					BasicDBObject doc = new BasicDBObject();
					doc.put("$set", updateQuery);
					mongoDB.getCollection(collectionMasterDataName).update(
							findQuery, doc);
				}
				ret = true;
			}
		} catch (Exception e) {
			log.info("modifyOrgSiteInstance--" + e.getMessage());
			ret = false;
		}
		return ret;
	}

	public static boolean updateClientMeta(ClientMeta cm) {
		mongoDB = getMongoDB();
		Boolean ret = false;
		try {
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			update.put("ClientCopyRight", cm.getClientCopyRight());
			update.put("ClientLogo", cm.getClientLogo());
			update.put("ClientName", cm.getClientName());
			update.put("ClientSubName", cm.getClientSubName());
			update.put("ClientThemeColor", cm.getClientThemeColor());
			update.put("ClientName", cm.getClientName());
			update.put("Slide", cm.getSlide());
			update.put("SmsSwitch", cm.getSmsSwitch());
			//update.put("MetricsMapping", cm.getMetricsMapping());

			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(ClientMeta).update(
					new BasicDBObject().append("ClientCode",
							cm.getClientStockCode()), doc);
			ret = true;
		} catch (Exception e) {
			log.info("updateUser--" + e.getMessage());
		}
		return ret;
	}

	
	public static boolean delNullUser() {
		Boolean ret = false;
		mongoDB = getMongoDB();
		DBCollection dbCol = mongoDB.getCollection(wechat_user);
		BasicDBObject doc = new BasicDBObject();
		doc.put("OpenID", null);
		dbCol.remove(doc);
		ret = true;
		return ret;
	}

	public static boolean updateUser(WeChatUser wcu) {
		mongoDB = getMongoDB();
		java.sql.Timestamp cursqlTS = new java.sql.Timestamp(
				new java.util.Date().getTime());
		Boolean ret = false;
		try {
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			update.put("HeadUrl", wcu.getHeadimgurl());
			update.put("NickName", wcu.getNickname());
			update.put("Created", DateUtil.timestamp2Str(cursqlTS));
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(wechat_user).update(
					new BasicDBObject().append("OpenID", wcu.getOpenid()), doc);
			ret = true;
		} catch (Exception e) {
			log.info("updateUser--" + e.getMessage());
		}
		return ret;
	}

	public static boolean syncWechatUserToMongo(WeChatUser wcu) {
		mongoDB = getMongoDB();
		boolean result = false;
		WeChatUser ret = null;
		try {
			DBObject query = new BasicDBObject();
			query.put("OpenID", wcu.getOpenid());
			DBObject queryresult = mongoDB.getCollection(wechat_user).findOne(
					query);
			if (queryresult != null) {
				result = updateUser(wcu);
			} else {
				result = createUser(wcu);
			}
			result = true;
		} catch (Exception e) {
			log.info("queryWeChatUser--" + e.getMessage());
		}
		return result;
	}

	
	public static List<Quiz> getQuizsByType(String type) {
		List<Quiz> quizs=new ArrayList<Quiz>();
		mongoDB = getMongoDB();
		DBCursor dbcur;
		if(type==""){
			dbcur = mongoDB.getCollection(Quiz_Pool).find();
		}
		else{
		 dbcur = mongoDB.getCollection(Quiz_Pool).find(
				new BasicDBObject().append("Type", type));
		}
		Quiz q;
		if (null != dbcur) {
			while (dbcur.hasNext()) {
				DBObject o = dbcur.next();
				q=new Quiz();
				q.setQuestion(o.get("Question").toString());
				if(o.get("CaseStudy")!=null){
				q.setCaseStudy(getCaseStudyAttrByID(o.get("CaseStudy").toString(),"CaseStudy"));
				System.out.println("caseStudy..."+getCaseStudyAttrByID(o.get("CaseStudy").toString(),"CaseStudy"));
				if(getCaseStudyAttrByID(o.get("CaseStudy").toString(),"ImgBG")!="")
				{
					System.out.println("img..."+getCaseStudyAttrByID(o.get("CaseStudy").toString(),"ImgBG"));
					q.setImg(getCaseStudyAttrByID(o.get("CaseStudy").toString(),"ImgBG"));
				}
				}
				if(o.get("Category")!=null){
				q.setCategory(o.get("Category").toString());
				}
				if(o.get("ImgBG")!=null){
					q.setImg(o.get("ImgBG").toString());
				}
				q.setCorrectAnswers(o.get("CorrectAnswers").toString());
				q.setScore(o.get("Score").toString());
				q.setType(type);
				DBObject answerObj=(DBObject)o.get("Answers");
				List<String> answers=new ArrayList<String>();
				if("TrueOrFalse".equals(o.get("Type").toString())){
					answers.add(answerObj.get("A").toString());
					answers.add(answerObj.get("B").toString());
				}
				if("SingleChoice".equals(o.get("Type").toString())){
					answers.add(answerObj.get("A").toString());
					answers.add(answerObj.get("B").toString());
					answers.add(answerObj.get("C").toString());
					answers.add(answerObj.get("D").toString());
				}
				if("MultipleChoice".equals(o.get("Type").toString())){
					answers.add(answerObj.get("A").toString());
					answers.add(answerObj.get("B").toString());
					answers.add(answerObj.get("C").toString());
					answers.add(answerObj.get("D").toString());
					answers.add(answerObj.get("D").toString());
				}
				q.setAnswers(answers);
				quizs.add(q);
			}
		}
		return quizs;
	}

	public static String getCaseStudyAttrByID(String ID,String attr) {
		mongoDB = getMongoDB();

		DBCursor dbcur = mongoDB.getCollection(Quiz_Pool).find(
				new BasicDBObject().append("ID", ID));
		String val="";
		if (null != dbcur) {
			while (dbcur.hasNext()) {
				DBObject o = dbcur.next();
				if(o.get(attr)!=null){
					val=o.get(attr).toString();
				}
				
			}
		}
		return val;
	}

	public static boolean updateUser(String OpenID) {
		mongoDB = getMongoDB();
		java.sql.Timestamp cursqlTS = new java.sql.Timestamp(
				new java.util.Date().getTime());
		Boolean ret = false;
		try {
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			update.put("LastUpdatedDate", DateUtil.timestamp2Str(cursqlTS));
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(wechat_user).update(
					new BasicDBObject().append("OpenID", OpenID), doc);
			ret = true;
			addSkimNum();
		} catch (Exception e) {
			log.info("updateUser--" + e.getMessage());
		}
		return ret;
	}

	public static boolean updateUser(String OpenID, String Lat, String Lng,
			WeChatUser wcu) {
		mongoDB = getMongoDB();
		java.sql.Timestamp cursqlTS = new java.sql.Timestamp(
				new java.util.Date().getTime());
		Boolean ret = false;
		try {
			List<DBObject> arrayHistdbo = new ArrayList<DBObject>();
			DBCursor dbcur = mongoDB.getCollection(wechat_user).find(
					new BasicDBObject().append("OpenID", OpenID));
			if (null != dbcur) {
				while (dbcur.hasNext()) {
					DBObject o = dbcur.next();
					BasicDBList hist = (BasicDBList) o.get("VisitHistory");
					if (hist != null) {
						Object[] visitHistory = hist.toArray();
						for (Object dbobj : visitHistory) {
							if (dbobj instanceof DBObject) {
								arrayHistdbo.add((DBObject) dbobj);
							}
						}
					}
				}

				String faddr = RestUtils.getUserCurLocWithLatLng(Lat, Lng);
				BasicDBObject doc = new BasicDBObject();
				DBObject update = new BasicDBObject();
				update.put("FormatAddress", faddr);
				update.put("CurLAT", Lat);
				update.put("CurLNG", Lng);
				update.put("LastUpdatedDate", DateUtil.timestamp2Str(cursqlTS));
				DBObject innerInsert = new BasicDBObject();
				innerInsert.put("lat", Lat);
				innerInsert.put("lng", Lng);
				innerInsert.put("visitDate", DateUtil.timestamp2Str(cursqlTS));
				innerInsert.put("FAddr", faddr);
				arrayHistdbo.add(innerInsert);
				/*update.put("VisitHistory", arrayHistdbo);*/
				doc.put("$set", update);
				WriteResult wr = mongoDB.getCollection(wechat_user).update(new BasicDBObject().append("OpenID", OpenID), doc);
			}
			ret = true;
			addSkimNum();
		} catch (Exception e) {
			log.info("updateUser--" + e.getMessage());
		}
		return ret;
	}

	public static boolean updateUserWithSignature(String openid, String svg) {
		mongoDB = getMongoDB();
		boolean ret = false;
		try {
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			update.put("Signature", svg);
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(wechat_user).update(
					new BasicDBObject().append("OpenID", openid), doc);
			ret = true;
		} catch (Exception e) {
			log.info("updateUserWithSignature--" + e.getMessage());
		}
		return ret;
	}

	public static boolean updateUserWithManageStatus(WeChatMDLUser user) {
		mongoDB = getMongoDB();
		boolean ret = false;
		try {
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			update.put("IsActive", user.getIsActive());
			update.put("IsAuthenticated", user.getIsAuthenticated());
			update.put("IsRegistered", user.getIsRegistered());
			update.put("isAdmin", user.getIsAdmin());
			update.put("isSmsTeam", user.getIsSmsTeam());
			update.put("Teamer.registerDate", user.getRegisterDate());
			update.put("Teamer.realName", user.getRealName());
			update.put("Teamer.email", user.getEmail());
			update.put("Teamer.phone", user.getPhone());
			update.put("Teamer.role", user.getRole());
			update.put("Teamer.level", user.getLevel());
			update.put("Teacher", user.getTeacher());

			log.info("Teacher--" + user.getTeacher());
			System.out.println("get level from mongoBasic"+user.getLevel());
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(wechat_user)
					.update(new BasicDBObject().append("OpenID",
							user.getOpenid()), doc);
			ret = true;
		} catch (Exception e) {
			log.info("updateUserWithManageStatus--" + e.getMessage());
		}
		return ret;
	}
	
	public static boolean updateUserWithFaceUrl(String openid, String picurl) {
		mongoDB = getMongoDB();
		boolean ret = false;
		try {
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			update.put("FaceUrl", picurl);
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(wechat_user).update(
					new BasicDBObject().append("OpenID", openid), doc);
			ret = true;
		} catch (Exception e) {
			log.info("updateUserWithFaceUrl--" + e.getMessage());
		}
		return ret;
	}

	public static boolean updateUserWithLike(String openid, String likeToName,
			String ToOpenId) {
		mongoDB = getMongoDB();
		java.sql.Timestamp cursqlTS = new java.sql.Timestamp(
				new java.util.Date().getTime());
		boolean ret = false;
		try {
			BasicDBObject doc = new BasicDBObject();
			DBObject innerInsert = new BasicDBObject();
			innerInsert.put("Like.lastLikeTo", likeToName);
			innerInsert.put("Like.lastLikeDate",
					DateUtil.timestamp2Str(cursqlTS));
			doc.put("$set", innerInsert);
			WriteResult wr = mongoDB.getCollection(wechat_user).update(
					new BasicDBObject().append("OpenID", openid), doc);

			doc = new BasicDBObject();
			BasicDBObject update = new BasicDBObject();
			update.append("Like.number", 1);
			doc.put("$inc", update);
			wr = mongoDB.getCollection(wechat_user).update(
					new BasicDBObject().append("OpenID", ToOpenId), doc);
			ret = true;
		} catch (Exception e) {
			log.info("updateUserWithSignature--" + e.getMessage());
		}
		return ret;
	}

	public static String getUserWithSignature(String openid) {
		mongoDB = getMongoDB();
		String ret = "";
		try {
			ret = mongoDB.getCollection(wechat_user)
					.findOne(new BasicDBObject().append("OpenID", openid))
					.get("Signature").toString();
		} catch (Exception e) {
			log.info("getUserWithSignature--" + e.getMessage());
			ret = e.getMessage();
		}
		return ret;
	}

	public static String getUserWithFaceUrl(String openid) {
		mongoDB = getMongoDB();
		String ret = "";
		try {
			ret = mongoDB.getCollection(wechat_user)
					.findOne(new BasicDBObject().append("OpenID", openid))
					.get("FaceUrl").toString();
		} catch (Exception e) {
			log.info("getUserWithSignature--" + e.getMessage());
			e.getMessage();
		}
		return ret;
	}

	

	@SuppressWarnings("unchecked")
	public static List<DBObject> getDistinctSubjectArea(String fieldname) {
		List<DBObject> result = null;
		try {
			mongoDB = getMongoDB();
			if (null != mongoDB.getCollection(collectionMasterDataName)) {
				result = mongoDB.getCollection(collectionMasterDataName)
						.distinct(fieldname);
			}
		} catch (Exception e) {
			log.info("getDistinctSubjectArea--" + e.getMessage());
		}
		return result;
	}

	public static GeoLocation getDBUserGeoInfo(String OpenID) {
		mongoDB = getMongoDB();
		GeoLocation loc = new GeoLocation();
		try {
			DBObject query = new BasicDBObject();
			query.put("OpenID", OpenID);
			DBObject result = mongoDB.getCollection(wechat_user).findOne(query);
			loc.setLAT(result.get("CurLAT").toString());
			loc.setLNG(result.get("CurLNG").toString());
			loc.setFAddr(result.get("FormatAddress").toString());
		} catch (Exception e) {
			log.info("getDBUserGeoInfo--" + e.getMessage());
		}
		return loc;
	}


	@SuppressWarnings("unchecked")
	public static List<String> getFilterSegmentArea(String state) {
		mongoDB = getMongoDB();
		List<String> listOfSegmentArea = new ArrayList<String>();
		@SuppressWarnings("rawtypes")
		List results;
		try {
			// results =
			// mongoDB.getCollection(collectionMasterDataName).distinct("industrySegmentNames");
			BasicDBObject query = new BasicDBObject();
			/*
			 * if(state != "" && state != null && state.toLowerCase() != "null"
			 * ){ Pattern pattern3 = Pattern.compile("^.*" + state + ".*$",
			 * Pattern.CASE_INSENSITIVE); query.put("state", pattern3); }
			 */
			query.put("state", state);
			results = mongoDB.getCollection(collectionMasterDataName).distinct(
					"industrySegmentNames", query);
			for (int i = 0; i < results.size(); i++) {
				if (results.get(i) != "null" && results.get(i) != "NULL"
						&& results.get(i) != null) {
					String tmp = (String) results.get(i);
					tmp = tmp.trim();
					tmp = tmp.substring(1, tmp.length() - 1);
					String[] d = tmp.split(",");
					for (int j = 0; j < d.length; j++) {
						if (!listOfSegmentArea.contains(d[j].trim())) {
							listOfSegmentArea.add(d[j].trim());
						}
					}
				}
			}
		} catch (Exception e) {
			log.info("getFilterSegmentArea--" + e.getMessage());
		}
		return listOfSegmentArea;
	}

	public static List<String> getFilterRegionFromMongo(String state) {
		mongoDB = getMongoDB();
		List<String> listOfRegion = new ArrayList<String>();
		@SuppressWarnings("rawtypes")
		List results;
		try {
			DBObject dbquery = new BasicDBObject();
			if (state != "" && state != null && state != "null") {
				Pattern pattern = Pattern.compile("^.*" + state + ".*$",
						Pattern.CASE_INSENSITIVE);
				dbquery.put("state", pattern);
			}

			/*
			 * DBObject query1 = new BasicDBObject("state", "重庆市"); DBObject
			 * query2 = new BasicDBObject("state", "重庆"); BasicDBList or = new
			 * BasicDBList(); or.add(query1); or.add(query2); DBObject query =
			 * new BasicDBObject("$or", or);
			 */

			results = mongoDB.getCollection(collectionMasterDataName).distinct(
					"cityRegion", dbquery);
			for (int i = 0; i < results.size(); i++) {
				if (results.get(i) != "null" && results.get(i) != "NULL"
						&& results.get(i) != null) {
					listOfRegion.add((String) results.get(i));
				}
			}
		} catch (Exception e) {
			log.info("getFilterRegionFromMongo--" + e.getMessage());
		}
		return listOfRegion;
	}

	public static List<String> getFilterNonLatinCitiesFromMongo(String state) {
		mongoDB = getMongoDB();
		List<String> listOfNonLatinCities = new ArrayList<String>();
		@SuppressWarnings("rawtypes")
		List results;
		try {
			DBObject dbquery = new BasicDBObject();
			if (state != "" && state != null && state != "null") {
				Pattern pattern = Pattern.compile("^.*" + state + ".*$",
						Pattern.CASE_INSENSITIVE);
				dbquery.put("state", pattern);
			}

			/*
			 * DBObject query1 = new BasicDBObject("state", state); DBObject
			 * query2 = new BasicDBObject("state", "重庆"); BasicDBList or = new
			 * BasicDBList(); or.add(query1); or.add(query2); DBObject query =
			 * new BasicDBObject("$or", or);
			 */

			if (StringUtils.isLatinString(state)) {
				results = mongoDB.getCollection(collectionMasterDataName)
						.distinct("latinCity", dbquery);
			} else {
				results = mongoDB.getCollection(collectionMasterDataName)
						.distinct("nonlatinCity", dbquery);
			}

			for (int i = 0; i < results.size(); i++) {
				if (results.get(i) != "null" && results.get(i) != "NULL"
						&& results.get(i) != null) {
					String tmpStr = (String) results.get(i);
					if (tmpStr.contains(state)) {
						tmpStr = tmpStr.replaceAll("\\s+", "");
						tmpStr = tmpStr.replaceAll(state, "");
					}
					if (tmpStr != null && !tmpStr.isEmpty() && tmpStr != ".") {
						if (!listOfNonLatinCities
								.contains(tmpStr.toUpperCase())) {
							listOfNonLatinCities.add(tmpStr.toUpperCase());
						}
					}
				}
			}
		} catch (Exception e) {
			log.info("getFilterNonLatinCitiesFromMongo--" + e.getMessage());
		}
		return listOfNonLatinCities;
	}

	public static List<String> getFilterStateFromMongo() {
		mongoDB = getMongoDB();
		List<String> listOfstates = new ArrayList<String>();
		@SuppressWarnings("rawtypes")
		List results;

		try {
			results = mongoDB.getCollection(collectionMasterDataName).distinct(
					"state");
			for (int i = 0; i < results.size(); i++) {
				if (results.get(i) != "null" && results.get(i) != "NULL"
						&& results.get(i) != null) {
					listOfstates.add((String) results.get(i));
				}
			}
		} catch (Exception e) {
			log.info("getFilterStateFromMongo--" + e.getMessage());
		}
		return listOfstates;
	}

	public static String getFilterCountOnCriteriaFromMongo(
			String industrySegmentNames, String nonlatinCity, String state,
			String cityRegion) {
		mongoDB = getMongoDB();
		String ret = "0";
		DBObject query = new BasicDBObject();
		if (industrySegmentNames != "" && industrySegmentNames != null
				&& industrySegmentNames != "null") {
			Pattern pattern = Pattern.compile("^.*" + industrySegmentNames
					+ ".*$", Pattern.CASE_INSENSITIVE);
			query.put("industrySegmentNames", pattern);
			// query.put("industrySegmentNames", industrySegmentNames);
		}
		if (nonlatinCity != "" && nonlatinCity != null
				&& nonlatinCity.toLowerCase() != "null") {
			Pattern pattern2 = Pattern.compile("^.*" + nonlatinCity + ".*$",
					Pattern.CASE_INSENSITIVE);
			query.put("nonlatinCity", pattern2);
		}
		if (state != "" && state != null && state.toLowerCase() != "null") {
			Pattern pattern3 = Pattern.compile("^.*" + state + ".*$",
					Pattern.CASE_INSENSITIVE);
			query.put("state", pattern3);
		}
		if (cityRegion != "" && cityRegion != null
				&& cityRegion.toLowerCase() != "null") {
			Pattern pattern4 = Pattern.compile("^.*" + cityRegion + ".*$",
					Pattern.CASE_INSENSITIVE);
			query.put("cityRegion", pattern4);
		}
		try {
			// Pattern pattern = Pattern.compile("^.*name8.*$",
			// Pattern.CASE_INSENSITIVE);
			ret = String.valueOf(mongoDB
					.getCollection(collectionMasterDataName).count(query));
		} catch (Exception e) {
			log.info("getFilterCountOnCriteriaFromMongo--" + e.getMessage());
		}
		return ret;
	}

	/*
	 * author chang-zheng
	 */

	public static Map<String, String> CallgetFilterCountOnCriteriaFromMongoBylistOfSegmentArea(
			List<String> listOfSegmentArea, String nonlatinCity, String state,
			String cityRegion) {
		mongoDB = getMongoDB();
		Map<String, String> radarmap = new HashMap<String, String>();

		for (String area : listOfSegmentArea) {
			String ret = "0";
			DBObject query = new BasicDBObject();
			if (!StringUtils.isEmpty(area)) {
				Pattern pattern = Pattern.compile("^.*" + area + ".*$",
						Pattern.CASE_INSENSITIVE);
				query.put("industrySegmentNames", pattern);
				// query.put("industrySegmentNames", area);

				if (nonlatinCity != "" && nonlatinCity != null
						&& nonlatinCity.toLowerCase() != "null") {
					Pattern pattern2 = Pattern.compile("^.*" + nonlatinCity
							+ ".*$", Pattern.CASE_INSENSITIVE);
					query.put("nonlatinCity", pattern2);
				}
				if (state != "" && state != null
						&& state.toLowerCase() != "null") {
					Pattern pattern3 = Pattern.compile("^.*" + state + ".*$",
							Pattern.CASE_INSENSITIVE);
					query.put("state", pattern3);
				}
				if (cityRegion != "" && cityRegion != null
						&& cityRegion.toLowerCase() != "null") {
					Pattern pattern4 = Pattern.compile("^.*" + cityRegion
							+ ".*$", Pattern.CASE_INSENSITIVE);
					query.put("cityRegion", pattern4);
				}
				try {
					// Pattern pattern = Pattern.compile("^.*name8.*$",
					// Pattern.CASE_INSENSITIVE);
					ret = String.valueOf(mongoDB.getCollection(
							collectionMasterDataName).count(query));
				} catch (Exception e) {
					log.info("getFilterCountOnCriteriaFromMongo--"
							+ e.getMessage());
				}

			}
			radarmap.put(area, ret);
		}

		return radarmap;
	}

	@SuppressWarnings("unused")
	public static String getFilterTotalOPSIFromMongo(String stateProvince,
			String nonlatinCity, String cityRegion) {
		mongoDB = getMongoDB();
		String ret = "0";
		try {
			DBObject query = new BasicDBObject();
			if (stateProvince != "" && stateProvince != null
					&& stateProvince.toLowerCase() != "null") {
				Pattern patternst = Pattern.compile("^.*" + stateProvince
						+ ".*$", Pattern.CASE_INSENSITIVE);
				query.put("state", patternst);
			}
			if (nonlatinCity != "" && nonlatinCity != null
					&& nonlatinCity.toLowerCase() != "null") {
				Pattern patternstnc = Pattern.compile("^.*" + nonlatinCity
						+ ".*$", Pattern.CASE_INSENSITIVE);
				query.put("nonlatinCity", patternstnc);
			}
			if (cityRegion != "" && cityRegion != null
					&& cityRegion.toLowerCase() != "null") {
				Pattern patterncr = Pattern.compile("^.*" + cityRegion + ".*$",
						Pattern.CASE_INSENSITIVE);
				query.put("cityRegion", patterncr);
			}

			if (query != null) {
				ret = String.valueOf(mongoDB
						.getCollection(collectionMasterDataName).find(query)
						.count());
			} else {
				ret = String
						.valueOf(mongoDB
								.getCollection(collectionMasterDataName).find()
								.count());
			}

		} catch (Exception e) {
			log.info("getFilterTotalOPSIFromMongo--" + e.getMessage());
		}
		return ret;
	}

	

	/*
	 * author chang-zheng purpose to get userState list .eg 上海市，重庆市
	 */
	@SuppressWarnings("unchecked")
	public static List<String> getAllStates(String countryCode) {
		mongoDB = getMongoDB();
		BasicDBObject query_State = new BasicDBObject();
		query_State.put("countryCode", countryCode);
		List<String> lst = mongoDB.getCollection(collectionMasterDataName)
				.distinct("state", query_State);
		List<String> lstRet = new ArrayList<String>();
		for (String i : lst) {
			if (!StringUtils.isEmpty(i)) {
				lstRet.add(i);
			}
		}
		return lstRet;
	}

	

	public static List<String> getFilterOnIndustryByAggregateFromMongo() {
		List<String> ret = new ArrayList<String>();
		mongoDB = getMongoDB();
		ret.add("--connected---");
		try {
			DBObject fields = new BasicDBObject("industrySegmentNames", 1);
			fields.put("industrySegmentNames", 1);
			fields.put("_id", 0);
			DBObject project = new BasicDBObject("$project", fields);
			ret.add("--projecting completed---");
			DBObject groupFields = new BasicDBObject("_id",
					"$industrySegmentNames");
			groupFields.put("count", new BasicDBObject("$sum", 1));
			DBObject group = new BasicDBObject("$group", groupFields);
			ret.add("--group completed---");
			AggregationOutput aop = mongoDB.getCollection(
					collectionMasterDataName).aggregate(project, group);
			ret.add("--aggregate completed---");
			Iterable<DBObject> results = aop.results();
			int i = 0;
			while (results.iterator().hasNext()) {
				i = i + 1;
			}
			ret.add("---count---" + i);
			ret.add("---desc---" + results.toString());
		} catch (Exception e) {
			log.info("getFilterOnIndustryByAggregateFromMongo--"
					+ e.getMessage());
		}
		return ret;
	}

	public static String setLocationtoMongoDB(String state) {
		String ret = "error";
		// mongoDB = getMongoDB();

		return ret;
	}

	public static ArrayList<String> QueryLikeAreaOpenidList(String roleOrAreaId) {
		ArrayList<String> result = new ArrayList<String>();
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		query.put("likeLists", roleOrAreaId);
		DBCursor queryresults = mongoDB.getCollection(wechat_user).find(query);
		if (null != queryresults) {
			while (queryresults.hasNext()) {
				DBObject o = queryresults.next();
				if (o.get("OpenID") != null) {
					result.add(o.get("OpenID").toString());
				}
			}
		}
		return result;
	}
	
	public static ArrayList<ClientMeta> QueryClientMetaList() {
		ArrayList<ClientMeta> result = new ArrayList<ClientMeta>();
		mongoDB = getMongoDB();
		DBCursor queryresults;
		try {
			BasicDBObject sort = new BasicDBObject();
			sort.put("Active", -1);
			queryresults = mongoDB.getCollection(ClientMeta).find().limit(1000)
					.sort(sort);
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					ClientMeta cm = new ClientMeta();
					DBObject o = queryresults.next();
					String clientCopyRight = o.get("ClientCopyRight") == null ? ""
							: o.get("ClientCopyRight").toString();
					String clientLogo = o.get("ClientLogo") == null ? "" : o
							.get("ClientLogo").toString();
					String clientName = o.get("ClientName") == null ? "" : o
							.get("ClientName").toString();
					String clientSubName = o.get("ClientSubName") == null ? ""
							: o.get("ClientSubName").toString();
					String clientThemeColor = o.get("ClientThemeColor") == null ? ""
							: o.get("ClientThemeColor").toString();
					String clientStockCode = o.get("ClientCode") == null ? ""
							: o.get("ClientCode").toString();
					String clientActive = o.get("Active") == null ? "" : o.get(
							"Active").toString();
					String SmsSwitch = o.get("SmsSwitch") == null ? "false" : o.get(
							"SmsSwitch").toString();
					BasicDBList slide = (BasicDBList) o.get("Slide");
					if (slide != null) {
						ArrayList<String> list = new ArrayList<String>();
						Object[] tagObjects = slide.toArray();
						for (Object dbobj : tagObjects) {
							if (dbobj instanceof DBObject) {
								list.add(((DBObject) dbobj).get("src")
										.toString());
							}
						}
						cm.setSlide(list);
					}
					cm.setClientCopyRight(clientCopyRight);
					cm.setClientLogo(clientLogo);
					cm.setClientName(clientName);
					cm.setClientSubName(clientSubName);
					cm.setClientActive(clientActive);
					cm.setClientStockCode(clientStockCode);
					cm.setClientThemeColor(clientThemeColor);
					cm.setSmsSwitch(SmsSwitch);
					result.add(cm);
				}
			}
		} catch (Exception e) {
			log.info("QueryClientMeta--" + e.getMessage());
		}
		return result;
	}
	public static boolean saveArticleMessageSignUp(String num,String name,String phone) {
		mongoDB = getMongoDB();
		if (num != null) {
			if (mongoDB == null) {
				mongoDB = getMongoDB();
			}
			DBObject queryresult = mongoDB.getCollection(Article_Message).findOne(new BasicDBObject().append("num", num));
			ArrayList<Map> list = new ArrayList<Map>();
			if (queryresult != null) {
				if(queryresult.get("signUp")!=null){
					BasicDBList signUpList = (BasicDBList) queryresult.get("signUp");
					Object[] signUpObjects = signUpList.toArray();
					for (Object dbobj : signUpObjects) {
						if (dbobj instanceof DBObject) {
							HashMap<String,String> temp = new HashMap<String,String>();
							temp.put("name",((DBObject) dbobj).get("name").toString());
							temp.put("phone",((DBObject) dbobj).get("phone").toString());
							if(!phone.equals(temp.get("phone"))){
								list.add(temp);
							}
						}
					}
				}
			}
			HashMap<String,String> temp = new HashMap<String,String>();
			temp.put("name",name);
			temp.put("phone",phone);
			list.add(temp);
			
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			update.put("signUp", list);
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(Article_Message).update(
					new BasicDBObject().append("num", num), doc);
		}
		return true;
	}

	public static boolean updateVisitPage(String realName, String flag) {
		mongoDB = getMongoDB();
		ArrayList list = new ArrayList();
		DBObject query = new BasicDBObject();
		query.put("Active", "Y");
		DBObject queryresults = mongoDB.getCollection(ClientMeta)
				.findOne(query);
		BasicDBList visitPage = (BasicDBList) queryresults.get("visitPage");
		if (visitPage != null) {
			Object[] tagObjects = visitPage.toArray();
			for (Object dbobj : tagObjects) {
				if (dbobj instanceof DBObject) {
					HashMap<String, String> temp = new HashMap<String, String>();
					temp.put("realName", ((DBObject) dbobj).get("realName")
							.toString());
					temp.put("descName", ((DBObject) dbobj).get("descName")
							.toString());
					temp.put("attention", ((DBObject) dbobj).get("attention")
							.toString());
					if (realName.equals(((DBObject) dbobj).get("realName")
							.toString())) {
						if ("add".equals(flag)) {
							temp.put("attention", "1");
						} else {
							temp.put("attention", "0");
						}
					}
					list.add(temp);
				}
			}
		}

		BasicDBObject doc = new BasicDBObject();
		DBObject update = new BasicDBObject();
		update.put("visitPage", list);
		doc.put("$set", update);
		WriteResult wr = mongoDB.getCollection(ClientMeta).update(
				new BasicDBObject().append("Active", "Y"), doc);
		return true;
	}

	public static ArrayList<Map> QueryVisitPageAttention() {
		mongoDB = getMongoDB();
		ArrayList list = new ArrayList();
		try {
			DBObject query = new BasicDBObject();
			query.put("Active", "Y");
			DBObject queryresults = mongoDB.getCollection(ClientMeta).findOne(
					query);
			BasicDBList visitPage = (BasicDBList) queryresults.get("visitPage");
			if (visitPage != null) {
				Object[] tagObjects = visitPage.toArray();
				for (Object dbobj : tagObjects) {
					if (dbobj instanceof DBObject) {
						HashMap<String, String> temp = new HashMap<String, String>();
						temp.put("realName", ((DBObject) dbobj).get("realName")
								.toString());
						temp.put("descName", ((DBObject) dbobj).get("descName")
								.toString());
						if ("1".equals(((DBObject) dbobj).get("attention")
								.toString())) {
							list.add(temp);
						}
					}
				}
			}
		} catch (Exception e) {
			log.info("QueryVisitPage--" + e.getMessage());
		}
		return list;
	}

	public static ArrayList<Map> QueryVisitPage() {
		mongoDB = getMongoDB();
		ArrayList list = new ArrayList();
		try {
			DBObject query = new BasicDBObject();
			query.put("Active", "Y");
			DBObject queryresults = mongoDB.getCollection(ClientMeta).findOne(
					query);
			BasicDBList visitPage = (BasicDBList) queryresults.get("visitPage");
			if (visitPage != null) {
				Object[] tagObjects = visitPage.toArray();
				for (Object dbobj : tagObjects) {
					if (dbobj instanceof DBObject) {
						HashMap<String, String> temp = new HashMap<String, String>();
						temp.put("realName", ((DBObject) dbobj).get("realName")
								.toString());
						temp.put("descName", ((DBObject) dbobj).get("descName")
								.toString());
						temp.put("attention",
								((DBObject) dbobj).get("attention").toString());
						list.add(temp);
					}
				}
			}
		} catch (Exception e) {
			log.info("QueryVisitPage--" + e.getMessage());
		}
		return list;
	}

	public static ClientMeta QueryClientMeta(String ClientCode) {
		ClientMeta cm = new ClientMeta();
		mongoDB = getMongoDB();
		try {
			DBObject query = new BasicDBObject();
			query.put("Active", "Y");
			query.put("ClientCode", ClientCode);
			DBObject queryresults = mongoDB.getCollection(ClientMeta).findOne(
					query);
			String clientCopyRight = queryresults.get("ClientCopyRight") == null ? ""
					: queryresults.get("ClientCopyRight").toString();
			String clientLogo = queryresults.get("ClientLogo") == null ? ""
					: queryresults.get("ClientLogo").toString();
			String clientName = queryresults.get("ClientName") == null ? ""
					: queryresults.get("ClientName").toString();
			String clientSubName = queryresults.get("ClientSubName") == null ? ""
					: queryresults.get("ClientSubName").toString();
			String clientThemeColor = queryresults.get("ClientThemeColor") == null ? ""
					: queryresults.get("ClientThemeColor").toString();
			String clientStockCode = queryresults.get("ClientCode") == null ? ""
					: queryresults.get("ClientCode").toString();
			String clientActive = queryresults.get("Active") == null ? ""
					: queryresults.get("Active").toString();
			String metricsMapping = queryresults.get("MetricsMapping") == null ? ""
					: queryresults.get("MetricsMapping").toString();
			BasicDBList slide = (BasicDBList) queryresults.get("Slide");
			if (slide != null) {
				ArrayList list = new ArrayList();
				Object[] tagObjects = slide.toArray();
				for (Object dbobj : tagObjects) {
					if (dbobj instanceof DBObject) {
						HashMap<String, String> temp = new HashMap<String, String>();
						list.add(((DBObject) dbobj).get("src").toString());
					}
				}
				cm.setSlide(list);
			}
			cm.setClientCopyRight(clientCopyRight);
			cm.setClientLogo(clientLogo);
			cm.setClientName(clientName);
			cm.setClientSubName(clientSubName);
			cm.setClientActive(clientActive);
			cm.setClientStockCode(clientStockCode);
			cm.setClientThemeColor(clientThemeColor);
			cm.setMetricsMapping(metricsMapping);
		} catch (Exception e) {
			log.info("QueryClientMeta--" + e.getMessage());
		}
		return cm;
	}

	public static boolean addSkimNum() {
		boolean result = false;
		mongoDB = getMongoDB();

		Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		String dateNowStr = sdf.format(d);
		java.util.Random random = new java.util.Random();// 定义随机类
		int randomNum = random.nextInt(5);// 返回[0,10)集合中的整数，注意不包括10

		DBObject query = new BasicDBObject();
		query.put("Active", "Y");
		DBObject queryresults = mongoDB.getCollection(ClientMeta)
				.findOne(query);
		BasicDBList skim = (BasicDBList) queryresults.get("SkimNum");
		ArrayList list1 = new ArrayList();
		if (skim != null) {
			Object[] tagObjects = skim.toArray();
			for (Object dbobj : tagObjects) {
				if (dbobj instanceof DBObject) {
					HashMap<String, Object> temp = new HashMap<String, Object>();
					temp.put("date", ((DBObject) dbobj).get("date").toString());
					if (dateNowStr.equals(((DBObject) dbobj).get("date")
							.toString())) {
						temp.put(
								"num",
								Integer.parseInt(((DBObject) dbobj).get("num")
										.toString()) + 1 + randomNum);
						result = true;
					} else {
						temp.put("num", Integer.parseInt(((DBObject) dbobj)
								.get("num").toString()));
					}
					list1.add(temp);
				}
			}
		}
		if (!result) {
			HashMap<String, Object> temp = new HashMap<String, Object>();
			temp.put("date", dateNowStr);
			temp.put("num", 1 + randomNum);
			list1.add(temp);
		}
		BasicDBObject doc = new BasicDBObject();
		BasicDBObject update = new BasicDBObject();
		update.append("SkimNum", list1);
		doc.put("$set", update);
		WriteResult wr = mongoDB.getCollection(ClientMeta).update(
				new BasicDBObject().append("Active", "Y"), doc);
		result = true;
		return result;
	}

	public static ClientMeta QueryClientMeta() {
		ClientMeta cm = new ClientMeta();
		mongoDB = getMongoDB();
		try {
			DBObject query = new BasicDBObject();
			query.put("Active", "Y");
			DBObject queryresults = mongoDB.getCollection(ClientMeta).findOne(
					query);
			String clientCopyRight = queryresults.get("ClientCopyRight") == null ? ""
					: queryresults.get("ClientCopyRight").toString();
			String clientLogo = queryresults.get("ClientLogo") == null ? ""
					: queryresults.get("ClientLogo").toString();
			String clientName = queryresults.get("ClientName") == null ? ""
					: queryresults.get("ClientName").toString();
			String clientSubName = queryresults.get("ClientSubName") == null ? ""
					: queryresults.get("ClientSubName").toString();
			String clientThemeColor = queryresults.get("ClientThemeColor") == null ? ""
					: queryresults.get("ClientThemeColor").toString();
			String clientStockCode = queryresults.get("ClientCode") == null ? ""
					: queryresults.get("ClientCode").toString();
			String clientActive = queryresults.get("Active") == null ? ""
					: queryresults.get("Active").toString();
			String SmsSwitch = queryresults.get("SmsSwitch") == null ? ""
					: queryresults.get("SmsSwitch").toString();
			BasicDBList skim = (BasicDBList) queryresults.get("SkimNum");
			if (skim != null) {
				ArrayList list1 = new ArrayList();
				Object[] sObjects = skim.toArray();
				for (Object dbobj : sObjects) {
					if (dbobj instanceof DBObject) {
						HashMap<String, Object> temp = new HashMap<String, Object>();
						temp.put("date", ((DBObject) dbobj).get("date")
								.toString());
						temp.put("num", Integer.parseInt(((DBObject) dbobj)
								.get("num").toString()));
						list1.add(temp);
					}
				}
				cm.setSkimNum(list1);
			}
			BasicDBList slide = (BasicDBList) queryresults.get("Slide");
			if (slide != null) {
				ArrayList list = new ArrayList();
				Object[] tagObjects = slide.toArray();
				for (Object dbobj : tagObjects) {
					if (dbobj instanceof DBObject) {
						list.add(((DBObject) dbobj).get("src").toString());
					}
				}
				cm.setSlide(list);
			}

			cm.setClientCopyRight(clientCopyRight);
			cm.setClientLogo(clientLogo);
			cm.setClientName(clientName);
			cm.setClientSubName(clientSubName);
			cm.setClientActive(clientActive);
			cm.setClientStockCode(clientStockCode);
			cm.setClientThemeColor(clientThemeColor);
			cm.setSmsSwitch(SmsSwitch);
		} catch (Exception e) {
			log.info("QueryClientMeta--" + e.getMessage());
		}
		return cm;
	}

	@SuppressWarnings("unchecked")
	public static List<WeChatMDLUser> getWeChatUserFromMongoDB(String OpenID) {
		mongoDB = getMongoDB();
		List<WeChatMDLUser> ret = new ArrayList<WeChatMDLUser>();
		WeChatMDLUser weChatMDLUser = null;
		DBCursor queryresults;
		try {
			if (!StringUtils.isEmpty(OpenID)) {
				DBObject query = new BasicDBObject();
				query.put("OpenID", OpenID);
				queryresults = mongoDB.getCollection(wechat_user).find(query)
						.limit(1);
			} else {
				BasicDBObject sort = new BasicDBObject();
				sort.put("Teamer.role", -1);
				sort.put("Teamer.registerDate", 1);
				sort.put("Created", 1);
				queryresults = mongoDB.getCollection(wechat_user).find()
						.limit(1000).sort(sort);
			}
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					weChatMDLUser = new WeChatMDLUser();
					DBObject o = queryresults.next();
					if (o.get("OpenID") != null) {
						weChatMDLUser.setOpenid(o.get("OpenID").toString());
						if (o.get("CurLAT").toString() != null) {
							weChatMDLUser.setLat(o.get("CurLAT").toString());
						}
						if (o.get("CurLNG") != null) {
							weChatMDLUser.setLng(o.get("CurLNG").toString());
						}
						if (o.get("HeadUrl") != null) {
							weChatMDLUser.setHeadimgurl(o.get("HeadUrl")
									.toString());
						}
						if (o.get("NickName") != null) {
							weChatMDLUser.setNickname(o.get("NickName")
									.toString());
						}
						if (o.get("Teacher") != null) {
							weChatMDLUser.setTeacher(o.get("Teacher")
									.toString());
						}
						Object CongratulateHistory = o
								.get("CongratulateHistory");
						BasicDBList CongratulateHistoryObj = (BasicDBList) CongratulateHistory;
						if (CongratulateHistoryObj != null) {
							ArrayList conList = new ArrayList();
							Object[] ConObjects = CongratulateHistoryObj
									.toArray();
							weChatMDLUser.setCongratulateNum(ConObjects.length);
						}
						Object teamer = o.get("Teamer");
						DBObject teamobj = new BasicDBObject();
						teamobj = (DBObject) teamer;
						if (teamobj != null) {
							if (teamobj.get("selfIntro") != null) {
								weChatMDLUser.setSelfIntro(teamobj.get(
										"selfIntro").toString());
							}
							if (teamobj.get("realName") != null) {
								weChatMDLUser.setNickname(teamobj.get(
										"realName").toString());
							}
							if (teamobj.get("role") != null) {
								weChatMDLUser.setRole(teamobj.get("role")
										.toString());
							}
							if (teamobj.get("level") != null) {
								weChatMDLUser.setLevel(teamobj.get("level")
										.toString());
							}
							if (o.get("LastUpdatedDate") != null) {
								weChatMDLUser.setLastUpdatedDate(o.get(
										"LastUpdatedDate").toString());
							}
							if (teamobj.get("registerDate") != null) {
								weChatMDLUser.setRegisterDate(teamobj.get(
										"registerDate").toString());
								SimpleDateFormat sdf = new SimpleDateFormat(
										"yyyy-MM-dd");
								String dstr = teamobj.get("registerDate")
										.toString();
								dstr = dstr.replaceAll("/", "-");
								java.util.Date date = sdf.parse(dstr);
								long s1 = date.getTime();// 将时间转为毫秒
								long s2 = System.currentTimeMillis();// 得到当前的毫秒
								int day = (int) ((s2 - s1) / 1000 / 60 / 60 / 24) + 1;
								weChatMDLUser.setWorkDay(day);
							}
							BasicDBList hist = (BasicDBList) teamobj.get("tag");
							if (hist != null) {
								ArrayList list = new ArrayList();
								Object[] tagObjects = hist.toArray();
								for (Object dbobj : tagObjects) {
									if (dbobj instanceof DBObject) {
										HashMap<String, String> temp = new HashMap<String, String>();
										temp.put(((DBObject) dbobj).get("key")
												.toString(), ((DBObject) dbobj)
												.get("value").toString());
										list.add(temp);
									}
								}
								weChatMDLUser.setTag(list);
							}
						}
						Object likeobj = o.get("Like");
						DBObject like = new BasicDBObject();
						like = (DBObject) likeobj;
						HashMap<String, String> likeMap = new HashMap<String, String>();
						likeMap.put("number", "");
						likeMap.put("lastLikeTo", "");
						likeMap.put("lastLikeDate", "");
						if (like != null) {
							if (like.get("number") != null) {
								likeMap.put("number", like.get("number")
										.toString());
							}
							if (like.get("lastLikeTo") != null) {
								likeMap.put("lastLikeTo", like
										.get("lastLikeTo").toString());
							}
							if (like.get("lastLikeDate") != null) {
								likeMap.put("lastLikeDate",
										like.get("lastLikeDate").toString());
							}
						}
						weChatMDLUser.setLike(likeMap);
						if (teamobj != null) {
							if (teamobj.get("email") != null) {
								weChatMDLUser.setEmail(teamobj.get("email")
										.toString());
							}
							if (teamobj.get("phone") != null) {
								weChatMDLUser.setPhone(teamobj.get("phone")
										.toString());
							}
							if (teamobj.get("realName") != null) {
								weChatMDLUser.setRealName(teamobj.get(
										"realName").toString());
							}
							if (teamobj.get("groupid") != null) {
								weChatMDLUser.setGroupid(teamobj.get("groupid")
										.toString());
							}
						}
						if (o.get("IsActive") != null) {
							weChatMDLUser.setIsActive(o.get("IsActive")
									.toString());
						}
						if (o.get("IsAuthenticated") != null) {
							weChatMDLUser.setIsAuthenticated(o.get(
									"IsAuthenticated").toString());
						}
						if (o.get("IsRegistered") != null) {
							weChatMDLUser.setIsRegistered(o.get("IsRegistered")
									.toString());
						}
						if (o.get("isAdmin") != null) {
							weChatMDLUser.setIsAdmin(o.get("isAdmin")
									.toString());
						}
						if (o.get("isSmsTeam") != null) {
							weChatMDLUser.setIsSmsTeam(o.get("isSmsTeam")
									.toString());
						}
						if (!StringUtils.isEmpty(OpenID)) {

						}
					}
					if (weChatMDLUser != null) {
						ret.add(weChatMDLUser);
					}
				}
			}
		} catch (Exception e) {
			log.info("getWeChatUserFromMongoDB--" + e.getMessage());
		}
		return ret;
	}
	public static ArrayList<HashMap> QuerySmsUser() {
		ArrayList<HashMap> result = new ArrayList<HashMap>();
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		query.put("isSmsTeam", "true");
		DBCursor queryresults = mongoDB.getCollection(wechat_user).find(query);
		if (null != queryresults) {
			while (queryresults.hasNext()) {
				DBObject o = queryresults.next();
				HashMap<String,String> temp =new HashMap<String,String>();

				if (o.get("OpenID") != null) {
					temp.put("OpenID",o.get("OpenID").toString());
				}
				Object teamer = o.get("Teamer");
				DBObject teamobj = new BasicDBObject();
				teamobj = (DBObject) teamer;
				if (teamobj != null) {
					if (teamobj.get("phone") != null) {
						temp.put("phone",teamobj.get("phone")
								.toString());
					}
					if (teamobj.get("realName") != null) {
						temp.put("realName",teamobj.get(
								"realName").toString());
					}
				}
				if(temp!=null&&temp.get("phone")!=null){
					result.add(temp);
				}
			}
		}
		return result;
	}

	// Bit Add Start
	public static DBObject getOpptByOpsiFromMongoDB(String opsi) {
		DBObject queryresults = null;
		mongoDB = getMongoDB();
		try {
			DBObject dbquery = new BasicDBObject();
			if (!StringUtils.isEmpty(opsi)) {
				dbquery.put("siteInstanceId", opsi);
			}

			DBCursor dbCursor = mongoDB.getCollection(collectionMasterDataName)
					.find(dbquery);
			if (null == dbCursor) {
				queryresults = null;
			} else {
				queryresults = dbCursor.next();
			}

		} catch (Exception e) {
			log.info("getOpptByOpsiFromMongoDB--" + e.getMessage());
		}
		return queryresults;
	}

	/***
	 * search mongodb with condition lng&lat=null. only return one record.
	 * 
	 * @param inputString
	 * @return
	 */
	public static String updateOpptLatLngIntoMongoDB(String state) {
		mongoDB = getMongoDB();
		String queryOrg = "";
		try {
			DBObject dbquery = new BasicDBObject();
			dbquery.put("state", state);
			dbquery.put("lat", null);
			dbquery.put("lng", null);
			log.info("-1--" + dbquery.toString());
			/*
			 * dbquery.put("lat", new BasicDBObject("$eq", null));
			 * dbquery.put("lng", new BasicDBObject("$eq", null));
			 */
			DBObject queryresult = mongoDB.getCollection(
					collectionMasterDataName).findOne(dbquery);
			log.info("-2--" + queryresult.toString());
			if (queryresult != null) {
				log.info("-2.1--");
				String OPSIID = queryresult.get("siteInstanceId").toString();
				log.info("-2.2--" + OPSIID);
				String organizationNonLatinExtendedName = queryresult.get(
						"organizationNonLatinExtendedName").toString();
				String organizationExtendedName = queryresult.get(
						"organizationExtendedName").toString();
				log.info("-3--" + OPSIID + organizationNonLatinExtendedName
						+ organizationExtendedName);
				if (!StringUtils.isEmpty(organizationNonLatinExtendedName)) {
					queryOrg = organizationNonLatinExtendedName;
				} else {
					queryOrg = organizationExtendedName;
				}
				log.info("-4--" + queryOrg);
				GoogleLocationUtils gApi = new GoogleLocationUtils();
				GeoLocation geo = new GeoLocation();
				geo = gApi.geocodeByAddressNoSSL(queryOrg);
				DBObject update = new BasicDBObject();
				update.put("lat", geo.getLAT());
				update.put("lng", geo.getLNG());
				WriteResult wr = mongoDB
						.getCollection(collectionMasterDataName).update(
								new BasicDBObject().append("siteInstanceId",
										OPSIID), update);
				queryOrg = queryOrg + "[" + geo.getLAT() + "," + geo.getLNG()
						+ "]";
			}
		} catch (Exception e) {
			log.info("updateOpptLatLngIntoMongoDB--" + e.getMessage());
			queryOrg = e.getMessage().toString();
		}
		return queryOrg;
	}

	/***
	 * search oppts from mongodb with lng=null&lat=null limit(limitSize)
	 * 
	 * @param limitSize
	 *            integer of return row number.
	 * @return oppts's json DBCursor
	 */
	public static DBCursor getOpptListFromMongoDB(int limitSize) {
		DBCursor queryresults = null;
		mongoDB = getMongoDB();
		try {
			DBObject dbquery = new BasicDBObject();
			dbquery.put("lat", new BasicDBObject("$eq", null));
			dbquery.put("lng", new BasicDBObject("$eq", null));

			log.info("[getOpptFromMongoDB] query mongodb filter :"
					+ dbquery.toString());
			if (limitSize <= 0 || limitSize > 302) {
				limitSize = 302;
			}
			queryresults = mongoDB.getCollection(collectionMasterDataName)
					.find(dbquery).limit(limitSize);
			if (queryresults.size() == 0) {
				queryresults = null;
			}
		} catch (Exception e) {
			if (mongoDB.getMongo() != null) {
				mongoDB.getMongo().close();
			}
		} finally {
			if (mongoDB.getMongo() != null) {
				mongoDB.getMongo().close();
			}
		}
		return queryresults;
	}

	

	

	
	

	/*
	 * chang-zheng get NonLatinCity
	 */
	public static List<String> getAllDistrict(String state) {
		mongoDB = getMongoDB();
		List<String> listOfRegion = new ArrayList<String>();
		@SuppressWarnings("rawtypes")
		List results;
		try {
			DBObject dbquery = new BasicDBObject();
			if (state != "" && state != null && state != "null") {
				Pattern pattern = Pattern.compile("^.*" + state + ".*$",
						Pattern.CASE_INSENSITIVE);
				dbquery.put("state", pattern);
			}

			results = mongoDB.getCollection(collectionMasterDataName).distinct(
					"cityRegion", dbquery);
			for (int i = 0; i < results.size(); i++) {
				if (results.get(i) != "null" && results.get(i) != "NULL"
						&& results.get(i) != null) {
					listOfRegion.add((String) results.get(i));
				}
			}
		} catch (Exception e) {
			log.info("getFilterRegionFromMongo--" + e.getMessage());
		}
		return listOfRegion;
	}



	/*
	 * chang-zheng to update user CongratulateHistory
	 */
	public static boolean updateUserCongratulateHistory(String OpenID,
			CongratulateHistory conhis) {
		mongoDB = getMongoDB();
		java.sql.Timestamp cursqlTS = new java.sql.Timestamp(
				new java.util.Date().getTime());
		Boolean ret = false;
		try {
			List<DBObject> arrayHistdbo = new ArrayList<DBObject>();
			DBCursor dbcur = mongoDB.getCollection(wechat_user).find(
					new BasicDBObject().append("OpenID", OpenID));
			if (null != dbcur) {
				while (dbcur.hasNext()) {
					DBObject o = dbcur.next();
					BasicDBList hist = (BasicDBList) o
							.get("CongratulateHistory");
					if (hist != null) {
						Object[] CongratulateHistory = hist.toArray();
						for (Object dbobj : CongratulateHistory) {
							if (dbobj instanceof DBObject) {
								arrayHistdbo.add((DBObject) dbobj);
							}
						}
					}
				}

				BasicDBObject doc = new BasicDBObject();
				DBObject update = new BasicDBObject();
				DBObject innerInsert = new BasicDBObject();
				innerInsert.put("num", conhis.getNum());
				innerInsert.put("from", conhis.getFrom());
				innerInsert.put("to", conhis.getTo());
				innerInsert.put("comments", conhis.getComments());
				innerInsert.put("type", conhis.getType());
				innerInsert.put("point", conhis.getPoint());
				innerInsert.put("giftImg", conhis.getGiftImg());
				innerInsert.put("userImg", conhis.getUserImg());
				innerInsert.put("congratulateDate",
						DateUtil.timestamp2Str(cursqlTS));
				arrayHistdbo.add(innerInsert);
				update.put("CongratulateHistory", arrayHistdbo);
				doc.put("$set", update);
				WriteResult wr = mongoDB.getCollection(wechat_user).update(
						new BasicDBObject().append("OpenID", OpenID), doc);
			}
			ret = true;
		} catch (Exception e) {
			log.info("updateUser--" + e.getMessage());
		}
		return ret;
	}

	/*
	 * chang-zheng
	 */
	public static List<String> getRegisterUserByOpenID(String openID) {
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		query.put("OpenID", openID);
		@SuppressWarnings("unchecked")
		List<String> dbuser = mongoDB.getCollection(wechat_user).distinct(
				"Teamer.realName", query);
		return dbuser;
	}

	/*
	 * Panda
	 */
	public static List<CongratulateHistory> getRecognitionInfoByOpenID(
			String OpenID, String num) {
		mongoDB = getMongoDB();
		List<CongratulateHistory> chList = new ArrayList<CongratulateHistory>();
		CongratulateHistory ch = null;
		DBCursor queryresults;
		try {
			DBObject query = new BasicDBObject();
			query.put("OpenID", OpenID);
			queryresults = mongoDB.getCollection(wechat_user).find(query)
					.limit(1);
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					DBObject o = queryresults.next();
					Object CongratulateHistory = o.get("CongratulateHistory");
					BasicDBList CongratulateHistoryObj = (BasicDBList) CongratulateHistory;
					if (CongratulateHistoryObj != null) {
						Object[] ConObjects = CongratulateHistoryObj.toArray();
						for (Object co : ConObjects) {
							if (co instanceof DBObject) {
								if (!StringUtils.isEmpty(num)) {
									if (null != ((DBObject) co).get("num")) {
										if (num.equals(((DBObject) co).get(
												"num").toString())) {
											ch = new CongratulateHistory();
											ch.setComments(((DBObject) co).get(
													"comments").toString());
											ch.setCongratulateDate(((DBObject) co)
													.get("congratulateDate")
													.toString()
													.substring(0, 11));
											ch.setFrom(((DBObject) co).get(
													"from").toString());
											ch.setTo(((DBObject) co).get("to")
													.toString());
											ch.setPoint(((DBObject) co).get(
													"point").toString());
											ch.setType(((DBObject) co).get(
													"type").toString());
											ch.setGiftImg(((DBObject) co).get(
													"giftImg").toString());
											ch.setUserImg(((DBObject) co).get(
													"userImg").toString());
											chList.add(ch);
										}
									}
								} else {
									ch = new CongratulateHistory();
									ch.setComments(((DBObject) co).get(
											"comments").toString());
									ch.setCongratulateDate(((DBObject) co)
											.get("congratulateDate").toString()
											.substring(0, 11));
									ch.setFrom(((DBObject) co).get("from")
											.toString());
									ch.setTo(((DBObject) co).get("to")
											.toString());
									ch.setPoint(((DBObject) co).get("point")
											.toString());
									ch.setType(((DBObject) co).get("type")
											.toString());
									ch.setGiftImg(((DBObject) co)
											.get("giftImg").toString());
									ch.setUserImg(((DBObject) co)
											.get("userImg").toString());
									chList.add(ch);
								}

							}
						}
					}
				}
			}
		} catch (Exception e) {
			log.info("getWeChatUserFromMongoDB--" + e.getMessage());
		}
		return chList;
	}

	/*
	 * Panda
	 */
	public static int getRecognitionMaxNumByOpenID(String OpenID) {
		int num = 0;
		mongoDB = getMongoDB();
		DBCursor queryresults;
		try {
			DBObject query = new BasicDBObject();
			query.put("OpenID", OpenID);
			queryresults = mongoDB.getCollection(wechat_user).find(query)
					.limit(1);
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					DBObject o = queryresults.next();
					Object CongratulateHistory = o.get("CongratulateHistory");
					BasicDBList CongratulateHistoryObj = (BasicDBList) CongratulateHistory;
					if (CongratulateHistoryObj != null) {

						Object[] ConObjects = CongratulateHistoryObj.toArray();
						for (Object co : ConObjects) {
							if (co instanceof DBObject) {
								if (null != ((DBObject) co).get("num")) {
									num = Integer.parseInt(String.valueOf(
											((DBObject) co).get("num")).trim());
								}
							}
						}
					}
				}
			}
		} catch (Exception e) {
			log.info("getWeChatUserFromMongoDB--" + e.getMessage());
		}
		return num;
	}

	public static int getNotificationMaxNumByOpenID(String OpenID) {
		int num = 0;
		mongoDB = getMongoDB();
		DBCursor queryresults;
		try {
			DBObject query = new BasicDBObject();
			query.put("OpenID", OpenID);
			queryresults = mongoDB.getCollection(wechat_user).find(query)
					.limit(1);
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					DBObject o = queryresults.next();
					Object TechnologyCar = o.get("TechnologyCar");
					BasicDBList TechnologyCarObj = (BasicDBList) TechnologyCar;
					if (TechnologyCarObj != null) {

						Object[] ConObjects = TechnologyCarObj.toArray();
						for (Object co : ConObjects) {
							if (co instanceof DBObject) {
								if (null != ((DBObject) co).get("num")) {
									num = Integer.parseInt(String.valueOf(
											((DBObject) co).get("num")).trim());
								}
							}
						}
					}
				}
			}
		} catch (Exception e) {
			log.info("getWeChatUserFromMongoDB--" + e.getMessage());
		}
		return num;
	}

	public static String getRegisterUserByrealName(String realName) {
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		query.put("Teamer.realName", realName);
		@SuppressWarnings("unchecked")
		List<String> dbuser = mongoDB.getCollection(wechat_user).distinct(
				"OpenID", query);
		if (dbuser != null) {
			return dbuser.get(0);
		}
		return "null";
	}

	/*
	 * chang-zheng
	 */
	public static List<String> getAllRegisterUsers() {
		mongoDB = getMongoDB();
		@SuppressWarnings("unchecked")
		DBObject query = new BasicDBObject();
		query.put("IsActive", "true"); // live conversation
		List<String> lst = mongoDB.getCollection(wechat_user).distinct(
				"Teamer.realName", query);
		return lst;
	}

	/*
	 * chang-zheng
	 */
	public static String getfaceURL(String openID) {
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		query.put("OpenID", openID);
		@SuppressWarnings("unchecked")
		List<String> dbuser = mongoDB.getCollection(wechat_user).distinct(
				"FaceUrl", query);
		return dbuser == null ? "" : dbuser.get(0);
	}

	/*
	 * chang-zheng
	 */
	public static List<String> getAllOpenIDByIsActivewithIsRegistered() {
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		query.put("IsActive", "true");
		query.put("IsRegistered", "true");
		@SuppressWarnings("unchecked")
		List<String> dbuser = mongoDB.getCollection(wechat_user).distinct(
				"OpenID", query);

		return dbuser;
	}

	public static List<String> getAllOpenID() {
		mongoDB = getMongoDB();
		@SuppressWarnings("unchecked")
		List<String> dbuser = mongoDB.getCollection(wechat_user).distinct(
				"OpenID");
		return dbuser;
	}

	/*
	 * chang-zheng to update user CongratulateHistory
	 */
	public static boolean updateNotification(String OpenID, Notification note) {
		System.out.println("openID--------------------" + OpenID);
		System.out.println("picture--------------------" + note.getPicture());
		mongoDB = getMongoDB();
		java.sql.Timestamp cursqlTS = new java.sql.Timestamp(
				new java.util.Date().getTime());
		Boolean ret = false;
		try {
			List<DBObject> arrayTcar = new ArrayList<DBObject>();
			DBCursor dbcur = mongoDB.getCollection(wechat_user).find(
					new BasicDBObject().append("OpenID", OpenID));
			if (null != dbcur) {
				while (dbcur.hasNext()) {
					DBObject o = dbcur.next();
					BasicDBList hist = (BasicDBList) o.get("TechnologyCar");
					if (hist != null) {
						Object[] TechnologyCar = hist.toArray();
						for (Object dbobj : TechnologyCar) {
							if (dbobj instanceof DBObject) {
								arrayTcar.add((DBObject) dbobj);
							}
						}
					}
				}

				BasicDBObject doc = new BasicDBObject();
				DBObject update = new BasicDBObject();
				DBObject innerInsert = new BasicDBObject();
				innerInsert.put("num", note.getNum());
				innerInsert.put("content", note.getContent());
				innerInsert.put("picture", note.getPicture());
				innerInsert.put("time", note.getTime());
				innerInsert.put("type", note.getType());
				innerInsert.put("title", note.getTitle());

				arrayTcar.add(innerInsert);
				update.put("TechnologyCar", arrayTcar);
				doc.put("$set", update);
				WriteResult wr = mongoDB.getCollection(wechat_user).update(
						new BasicDBObject().append("OpenID", OpenID), doc);
			}
			ret = true;
		} catch (Exception e) {
			log.info("updateUser--" + e.getMessage());
		}
		return ret;
	}
	public static boolean updateVideoMessageByNum(String num) {
		boolean ret=false;
		try {
			mongoDB = getMongoDB();
			DBObject dbo = new BasicDBObject();
			dbo.put("isForward","1");
			BasicDBObject doc = new BasicDBObject();
			doc.put("$set", dbo);
			mongoDB.getCollection(Video_Message).update(new BasicDBObject().append("num",num), doc);
			ret=true;
			log.info("updateVideoMessageByNum end");
		} catch (Exception e) {
			log.info("updateVideoMessageByNum--" + e.getMessage());
		}
		return ret;
	}
	public static List<VideoMessage> getVideoMessageByNum(String num) {
		mongoDB = getMongoDB();
		List<VideoMessage> vmList = new ArrayList<VideoMessage>();
		VideoMessage vm = null;
		DBCursor queryresults;
		try {
			if ("".equals(num)) {
				BasicDBObject sort = new BasicDBObject();
				sort.put("_id", -1);
				queryresults = mongoDB.getCollection(Video_Message).find()
						.sort(sort);
			} else {
				DBObject query = new BasicDBObject();
				query.put("num", num);
				queryresults = mongoDB.getCollection(Video_Message)
						.find(query).limit(1);
			}
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					DBObject o = queryresults.next();
					vm = new VideoMessage();
					vm.setNum(o.get("num") == null ? "" : o.get("num")
							.toString());
					vm.setIsReprint(o.get("isReprint") == null ? "" : o.get("isReprint")
							.toString());
					vm.setContent(o.get("content") == null ? "" : o.get(
							"content").toString());
					vm.setTime(o.get("time") == null ? "" : o.get("time")
							.toString());
					vm.setTitle(o.get("title") == null ? "" : o.get("title")
							.toString());
					vm.setWebUrl(o.get("webUrl") == null ? "" : o.get("webUrl")
							.toString());
					vm.setIsForward(o.get("isForward") == null ? "" : o.get("isForward")
							.toString());
					vmList.add(vm);
				}
			}
		} catch (Exception e) {
			log.info("getVideoMessageByNum--" + e.getMessage());
		}
		return vmList;
	}
	public static boolean updateArticleMessageByNum(String num) {
		boolean ret=false;
		try {
			mongoDB = getMongoDB();
			DBObject dbo = new BasicDBObject();
			dbo.put("isForward","1");
			BasicDBObject doc = new BasicDBObject();
			doc.put("$set", dbo);
			mongoDB.getCollection(Article_Message).update(new BasicDBObject().append("num",num), doc);
			ret=true;
			log.info("updateArticleMessageByNum end");
		} catch (Exception e) {
			log.info("updateArticleMessageByNum--" + e.getMessage());
		}
		return ret;
	}
	public static List<ArticleMessage> getArticleMessageByNum(String num) {
		mongoDB = getMongoDB();
		List<ArticleMessage> amList = new ArrayList<ArticleMessage>();
		ArticleMessage am = null;
		DBCursor queryresults;
		try {
			if ("".equals(num)) {
				BasicDBObject sort = new BasicDBObject();
				sort.put("_id", -1);
				queryresults = mongoDB.getCollection(Article_Message).find()
						.sort(sort);
			} else {
				DBObject query = new BasicDBObject();
				query.put("num", num);
				queryresults = mongoDB.getCollection(Article_Message)
						.find(query).limit(1);
			}
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					DBObject o = queryresults.next();
					am = new ArticleMessage();
					am.setNum(o.get("num") == null ? "" : o.get("num")
							.toString());
					am.setContent(o.get("content") == null ? "" : o.get(
							"content").toString());
					am.setTime(o.get("time") == null ? "" : o.get("time")
							.toString());
					am.setTitle(o.get("title") == null ? "" : o.get("title")
							.toString());
					am.setVisitedNum(o.get("visitedNum") == null ? "" : o.get(
							"visitedNum").toString());
					am.setPicture(o.get("picture") == null ? "" : o.get(
							"picture").toString());
					am.setIsForward(o.get("isForward") == null ? "" : o.get(
							"isForward").toString());
					BasicDBList signUp = (BasicDBList) o.get("signUp");
					Teamer s;
					List<Teamer> signUpMaps=new ArrayList<Teamer>();
					if (signUp != null) {
						Object[] su = signUp.toArray();
						for (Object dbobj : su) {
							if (dbobj instanceof DBObject) {
								 s=new Teamer();
								 s.setRealName(((DBObject) dbobj).get("name").toString());
								 s.setPhone(((DBObject) dbobj).get("phone").toString());
								 signUpMaps.add(s);
							}
						}
					}
					am.setSignUp(signUpMaps);
					amList.add(am);
				}
			}
		} catch (Exception e) {
			log.info("getArcticleMessageByNum--" + e.getMessage());
		}
		return amList;
	}

	public static boolean isSignUpByName(String name,List<Teamer> signUps)
	{
		boolean isSignUp=false;
		if(signUps.size()!=0){
		for(Teamer s:signUps){
			if(s.getRealName().equals(name)){
				isSignUp=true;
			}
		}
		}
		return isSignUp;
	}
	/*
	 * chang-zheng to update user getNotification
	 */
	public static List<Notification> getNotification(String OpenID, String num) {
		System.out.println("openid:----" + OpenID);
		System.out.println("num:----" + num);
		mongoDB = getMongoDB();
		List<Notification> nfList = new ArrayList<Notification>();
		DBObject query = new BasicDBObject();
		query.put("OpenID", OpenID);
		DBCursor queryresults = mongoDB.getCollection(wechat_user).find(query)
				.limit(1);
		if (null != queryresults) {
			System.out.print("queryresults is not null");
			while (queryresults.hasNext()) {
				DBObject o = queryresults.next();
				Object TechnologyCar = o.get("TechnologyCar");
				BasicDBList TechnologyCarObj = (BasicDBList) TechnologyCar;
				if (TechnologyCarObj != null) {
					Notification nt = new Notification();
					Object[] ConObjects = TechnologyCarObj.toArray();
					for (Object co : ConObjects) {
						if (co instanceof DBObject) {
							if (!StringUtils.isEmpty(num)) {
								if (null != ((DBObject) co).get("num")) {
									System.out.print("num is not null");
									if (num.equals(((DBObject) co).get("num")
											.toString())) {
										System.out
												.print("num existed----------");
										nt.setContent(((DBObject) co).get(
												"content").toString());
										nt.setNum(num);
										if (null != ((DBObject) co)
												.get("picture")) {
											nt.setPicture(((DBObject) co).get(
													"picture").toString());
										}
										nt.setTime(((DBObject) co).get("time")
												.toString());
										nt.setTitle(((DBObject) co)
												.get("title").toString());
										nt.setType(((DBObject) co).get("type")
												.toString());
										nfList.add(nt);
									}

								}
							} else {
								nt.setContent(((DBObject) co).get("content")
										.toString());
								nt.setNum(((DBObject) co).get("num").toString());
								nt.setPicture(((DBObject) co).get("picture")
										.toString());
								nt.setTime(((DBObject) co).get("time")
										.toString());
								nt.setTitle(((DBObject) co).get("title")
										.toString());
								nt.setType(((DBObject) co).get("type")
										.toString());
								nfList.add(nt);
							}
						}
					}
				}

			}
		}
		System.out.println("title is ------------:" + nfList.get(0).getTitle());
		System.out.println("size is ------------:" + nfList.size());
		return nfList;
	}

	

	public static int getArticleMessageMaxNum() {
		DBCursor cor = mongoDB.getCollection(Article_Message).find();
		String maxNum = "";
		if (cor != null) {
			while (cor.hasNext()) {
				DBObject objam = cor.next();
				maxNum = objam.get("num") == null ? "" : objam.get("num")
						.toString();
				System.out.println("maxNum----------------" + maxNum);
			}
		}
		if (!"".equals(maxNum)) {
			return Integer.parseInt(maxNum);
		} else {
			return 0;
		}
	}
	public static int getVideoMessageMaxNum() {
		DBCursor cor = mongoDB.getCollection(Video_Message).find();
		String maxNum = "";
		if (cor != null) {
			while (cor.hasNext()) {
				DBObject objam = cor.next();
				maxNum = objam.get("num") == null ? "" : objam.get("num")
						.toString();
				System.out.println("maxNum----------------" + maxNum);
			}
		}
		if (!"".equals(maxNum)) {
			return Integer.parseInt(maxNum);
		} else {
			return 0;
		}
	}
	public static String saveVideoMessage(VideoMessage videoMessage) {
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		String ret = "VideoMessage fail";
		if (videoMessage != null) {
			if (mongoDB == null) {
				mongoDB = getMongoDB();
			}
			query.put("num", videoMessage.getNum());
			DBObject queryresult = mongoDB.getCollection(Video_Message)
					.findOne(query);

			DBObject insertQuery = new BasicDBObject();

			WriteResult writeResult;
			if (queryresult == null) {

				System.out.println("add new Article--------------");
				insertQuery.put("num", videoMessage.getNum());
				insertQuery.put("title", videoMessage.getTitle());
				insertQuery.put("isReprint", videoMessage.getIsReprint());
				insertQuery.put("isForward", "0");
				insertQuery.put("content", videoMessage.getContent());
				insertQuery.put("time", videoMessage.getTime());
				insertQuery.put("webUrl", videoMessage.getWebUrl());
				writeResult = mongoDB.getCollection(Video_Message).insert(
						insertQuery);
				ret = "insert videoMessage ok  -->" + writeResult;
			} else {
				System.out.println("update old Article--------------");
				if (videoMessage.getNum() == null
						&& queryresult.get("num") != null) {
					insertQuery.put("num", queryresult.get("num").toString());
				} else {
					insertQuery.put("num", videoMessage.getNum());
				}

				if (videoMessage.getTitle() == null
						&& queryresult.get("title") != null) {
					insertQuery.put("title", queryresult.get("title")
							.toString());
				} else {
					insertQuery.put("title", videoMessage.getTitle());
				}

				if (videoMessage.getIsReprint() == null
						&& queryresult.get("isReprint") != null) {
					insertQuery.put("isReprint", queryresult.get("isReprint").toString());
				} else {
					insertQuery.put("sReprint", videoMessage.getIsReprint());
				}

				if (videoMessage.getContent() == null
						&& queryresult.get("content") != null) {
					insertQuery.put("content", queryresult.get("content")
							.toString());
				} else {
					insertQuery.put("content", videoMessage.getContent());
				}

				if (videoMessage.getTime() == null
						&& queryresult.get("time") != null) {
					insertQuery.put("time", queryresult.get("time").toString());
				} else {
					insertQuery.put("time", videoMessage.getTime());
				}
				if (videoMessage.getWebUrl() == null
						&& queryresult.get("webUrl") != null) {
					insertQuery.put("webUrl", queryresult.get("webUrl")
							.toString());
				} else {
					insertQuery.put("webUrl", videoMessage.getWebUrl());
				}

				BasicDBObject doc = new BasicDBObject();
				doc.put("$set", insertQuery);
				writeResult = mongoDB.getCollection(Video_Message).update(
						new BasicDBObject().append("num",
								videoMessage.getNum()), doc);
				ret = "update Article_Message ok  -->" + writeResult;
			}
		}
		return ret;
	}
	public static String saveArticleMessage(ArticleMessage articleMessage) {
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		String ret = "ArticleMessage fail";
		if (articleMessage != null) {
			if (mongoDB == null) {
				mongoDB = getMongoDB();
			}
			query.put("num", articleMessage.getNum());
			DBObject queryresult = mongoDB.getCollection(Article_Message)
					.findOne(query);

			DBObject insertQuery = new BasicDBObject();

			WriteResult writeResult;
			if (queryresult == null) {

				System.out.println("add new Article--------------");
				insertQuery.put("num", articleMessage.getNum());
				insertQuery.put("title", articleMessage.getTitle());
				insertQuery.put("type", articleMessage.getType());
				insertQuery.put("content", articleMessage.getContent());
				insertQuery.put("isForward", "0");
				insertQuery.put("time", articleMessage.getTime());
				insertQuery.put("picture", articleMessage.getPicture());
				insertQuery.put("webUrl", articleMessage.getWebUrl());
				insertQuery.put("visitedNum", articleMessage.getVisitedNum());
				if (!"".equals(articleMessage.getAuthor())) {
					insertQuery.put("author", articleMessage.getAuthor());
				}
				writeResult = mongoDB.getCollection(Article_Message).insert(
						insertQuery);
				ret = "insert articleMessage ok  -->" + writeResult;
			} else {
				System.out.println("update old Article--------------");
				if (articleMessage.getNum() == null
						&& queryresult.get("num") != null) {
					insertQuery.put("num", queryresult.get("num").toString());
				} else {
					insertQuery.put("num", articleMessage.getNum());
				}

				if (articleMessage.getTitle() == null
						&& queryresult.get("title") != null) {
					insertQuery.put("title", queryresult.get("title")
							.toString());
				} else {
					insertQuery.put("title", articleMessage.getTitle());
				}

				if (articleMessage.getType() == null
						&& queryresult.get("type") != null) {
					insertQuery.put("type", queryresult.get("type").toString());
				} else {
					insertQuery.put("type", articleMessage.getType());
				}

				if (articleMessage.getContent() == null
						&& queryresult.get("content") != null) {
					insertQuery.put("content", queryresult.get("content")
							.toString());
				} else {
					insertQuery.put("content", articleMessage.getContent());
				}

				if (articleMessage.getTime() == null
						&& queryresult.get("time") != null) {
					insertQuery.put("time", queryresult.get("time").toString());
				} else {
					insertQuery.put("time", articleMessage.getTime());
				}

				if (articleMessage.getPicture() == null
						&& queryresult.get("picture") != null) {
					insertQuery.put("picture", queryresult.get("picture")
							.toString());
				} else {
					insertQuery.put("picture", articleMessage.getPicture());
				}

				if (articleMessage.getWebUrl() == null
						&& queryresult.get("webUrl") != null) {
					insertQuery.put("webUrl", queryresult.get("webUrl")
							.toString());
				} else {
					insertQuery.put("webUrl", articleMessage.getWebUrl());
				}

				if (articleMessage.getAuthor() == null
						&& queryresult.get("author") != null) {
					insertQuery.put("author", queryresult.get("author")
							.toString());
				} else {
					insertQuery.put("author", articleMessage.getAuthor());
				}
				if (articleMessage.getVisitedNum() == null
						&& queryresult.get("visitedNum") != null) {
					insertQuery.put("visitedNum", queryresult.get("visitedNum")
							.toString());
				} else {
					insertQuery.put("visitedNum",
							articleMessage.getVisitedNum());
				}

				BasicDBObject doc = new BasicDBObject();
				doc.put("$set", insertQuery);
				writeResult = mongoDB.getCollection(Article_Message).update(
						new BasicDBObject().append("num",
								articleMessage.getNum()), doc);
				ret = "update Article_Message ok  -->" + writeResult;
			}
		}
		return ret;
	}

	public static List<String> getAllOpenIDByIsRegistered() {
		mongoDB = getMongoDB();
		DBObject query = new BasicDBObject();
		query.put("IsRegistered", "true");
		@SuppressWarnings("unchecked")
		List<String> dbuser = mongoDB.getCollection(wechat_user).distinct(
				"OpenID", query);

		return dbuser;
	}

	

	public static List<Integer> getTotalVisitedNumByPage(List<String> dates,
			String page) {
		/*
		 * for(int a=0;a<dates.size();a++){
		 * System.out.println("dates list-------:"+dates.get(a)); }
		 */
		int num = 0;
		List<Integer> numList = new ArrayList<Integer>();
		List<Visited> data = new ArrayList<Visited>();
		for (int i = 0; i < dates.size(); i++) {
			data = MongoDBBasic.getVisitedDetail(dates.get(i), page);
			// System.out.println("data.size():"+data.size());
			for (int j = 0; j < data.size(); j++) {

				// System.out.println("j index-----"+j+"num:---"+data.get(j).getVisitedNum()+"/page:---"+data.get(j).getPageName());
				num += data.get(j).getVisitedNum();
			}
			// System.out.println("num  ====:"+num);
			numList.add(num);
			num = 0;
		}
		return numList;
	}

	public static List<Visited> getVisitedDetail(String date, String pageName) {
		List<Visited> vitlist = new ArrayList<Visited>();
		if (mongoDB == null) {
			mongoDB = getMongoDB();
		}
		DBObject query = new BasicDBObject();
		query.put("date", date);
		query.put("pageName", pageName);
		DBCursor visiteds = mongoDB.getCollection(collectionVisited)
				.find(query);
		if (null != visiteds) {
			while (visiteds.hasNext()) {
				Visited vit = new Visited();
				DBObject obj = visiteds.next();
				vit.setDate(date);
				vit.setOpenid(obj.get("openid") + "");
				if(obj.get("visitedNum")!=null){
					vit.setVisitedNum(Integer.parseInt(obj.get("visitedNum") + ""));
				}
				if(obj.get("sharedNum")!=null){
					vit.setSharedNum(Integer.parseInt(obj.get("sharedNum") + ""));
				}
				else {
					vit.setSharedNum(0);
				}
				vit.setPageName(obj.get("pageName") + "");
				vit.setImgUrl(obj.get("imgUrl") + "");
				vit.setNickName(obj.get("nickName") + "");
				vitlist.add(vit);
			}
		} else {
			Visited vit = new Visited();
			vit.setDate(date);
			vit.setOpenid("");
			vit.setVisitedNum(0);
			vit.setPageName(pageName);
			vit.setImgUrl("");
			vit.setNickName("");
			vitlist.add(vit);
		}
		return vitlist;
	}

	public static List<String> getLastestDate(int day) {
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
		Date date = new Date();
		List<String> finalVisiteds = new ArrayList<String>();
		String currentDate = format.format(date);
		finalVisiteds.add(currentDate);
		for (int i = -1; i > day - 1; i--) {
			finalVisiteds.add(beforNumDay(date, i));
		}
		return finalVisiteds;
	}

	public static String beforNumDay(Date date, int day) {
		Calendar c = Calendar.getInstance();
		c.setTime(date);
		c.add(Calendar.DAY_OF_YEAR, day);
		return new SimpleDateFormat("yyyy-MM-dd").format(c.getTime());
	}


	public static String addNewAppointment(Appointment app) {
		if (mongoDB == null) {
			mongoDB = getMongoDB();
		}
		String ret = "ok";
		try {
			DBObject query = new BasicDBObject();
			query.put("childName", app.getName());
			query.put("tel", app.getTel());
			query.put("address", app.getAddr());
			query.put("age", app.getAge());
			query.put("sex", app.getSex());
			query.put("school", app.getSchool());
			query.put("subject", app.getSubject());
			java.sql.Timestamp cursqlTS = new java.sql.Timestamp(new java.util.Date().getTime());
			query.put("date", DateUtil.timestamp2Str(cursqlTS));
			DBObject apppoint = mongoDB.getCollection(APPOINTMENT).findOne(query);
			if (apppoint != null) {
				// String num = visited.get("visitedNum")+"";
				BasicDBObject doc = new BasicDBObject();
				BasicDBObject update = new BasicDBObject();
				// update.put("visitedNum", Integer.parseInt(num)+1);
				update.append("childName", app.getName());
				update.append("tel", app.getTel());
				update.append("address", app.getAddr());
				update.append("age", app.getAge());
				update.append("sex", app.getSex());
				update.append("school", app.getSchool());
				update.append("subject", app.getSubject());
				update.append("date", DateUtil.timestamp2Str(cursqlTS));
				doc.put("$inc", update);
				// doc.put("$set", update);
				mongoDB.getCollection(APPOINTMENT).update(query, doc);
			} else {
				mongoDB.getCollection(APPOINTMENT).insert(query);
			}
			//send message to leshu admin to get client engaged
			List<String> telList = new ArrayList<String>();
			String templateId="231590";
			telList.add("15123944895"); //Ning
			telList.add("18883811118"); //presendent guo
			String para=": 姓名 "+app.getName() + " 电话 "+app.getTel()+" 课程 "+app.getSubject();
			for(String to : telList){
				if(to!=null && !"".equals(to)){
					RestTest.testTemplateSMS(true, Constants.ucpass_accountSid,Constants.ucpass_token,Constants.ucpass_appId, templateId,to,para);
				}
			}

		} catch (Exception e) {
			ret = e.getMessage();
		}

		return ret;
	}
	public static String updateVisited(String openid, String date,
			String pageName, String imgUrl, String nickName) {
		if (mongoDB == null) {
			mongoDB = getMongoDB();
		}
		String ret = "ok";
		try {
			DBObject query = new BasicDBObject();
			query.put("openid", openid);
			query.put("date", date);
			query.put("pageName", pageName);
			query.put("imgUrl", imgUrl);
			query.put("nickName", nickName);
			DBObject visited = mongoDB.getCollection(collectionVisited)
					.findOne(query);
			if (visited != null) {
				// String num = visited.get("visitedNum")+"";
				BasicDBObject doc = new BasicDBObject();
				BasicDBObject update = new BasicDBObject();
				// update.put("visitedNum", Integer.parseInt(num)+1);
				update.append("visitedNum", 1);
				doc.put("$inc", update);
				// doc.put("$set", update);
				mongoDB.getCollection(collectionVisited).update(query, doc);
			} else {
				query.put("visitedNum", 1);
				mongoDB.getCollection(collectionVisited).insert(query);
			}

		} catch (Exception e) {
			ret = e.getMessage();
		}

		return ret;
	}
	public static String updateShared(String openid, String date,
			String pageName, String imgUrl, String nickName,String imgUrl2, String nickName2) {
		if (mongoDB == null) {
			mongoDB = getMongoDB();
		}
		String ret = "ok";
		HashSet<String> sharedList = new HashSet<String>();
		boolean isExisted=false;
		try {
			DBObject query = new BasicDBObject();
			query.put("openid", openid);
			query.put("date", date);
			query.put("pageName", pageName);
			query.put("nickName", nickName2);
			DBObject visited = mongoDB.getCollection(collectionVisited)
					.findOne(query);
			if (visited != null) {
				if(visited.get("sharedList") != null){
					BasicDBList hist = (BasicDBList) visited.get("sharedList");
					Object[] slObjects = hist.toArray();
					for (Object dbobj : slObjects) {
						if (dbobj instanceof String) {
							if(!nickName.equals((String) dbobj)){
								sharedList.add((String) dbobj);
							}else {
								isExisted=true;
							}
						}
					}
					System.out.println("isExisted-----"+isExisted);
					if(!isExisted){
						BasicDBObject doc = new BasicDBObject();
						BasicDBObject update1 = new BasicDBObject();
						BasicDBObject update2 = new BasicDBObject();
						update1.append("sharedNum", 1);
						doc.put("$inc", update1);
						sharedList.add(nickName);
						update2.put("sharedList", sharedList);
						doc.put("$set", update2);
						mongoDB.getCollection(collectionVisited).update(query, doc);
						}
				}else{
					System.out.println("sharedList is null-----");
					BasicDBObject doc = new BasicDBObject();
					BasicDBObject update = new BasicDBObject();
					update.put("sharedNum", 1);
					sharedList.add(nickName);
					update.put("sharedList", sharedList);
					doc.put("$set", update);
					mongoDB.getCollection(collectionVisited).update(query, doc);
				}
				
			} else {
				query.put("imgUrl", imgUrl2);
				System.out.println("visited is null-----");
				query.put("sharedNum", 1);
				sharedList.add(nickName);
				query.put("sharedList", sharedList);
				mongoDB.getCollection(collectionVisited).insert(query);
			}

		} catch (Exception e) {
			ret = e.getMessage();
		}

		return ret;
	}
	public static List<String> getSharedDetail(String openid, String date,
			String pageName,String nickName) {
		if (mongoDB == null) {
			mongoDB = getMongoDB();
		}
		String ret = "ok";
		List<String> sharedList = new ArrayList<String>();
		boolean isExisted=false;
		try {
			DBObject query = new BasicDBObject();
			query.put("openid", openid);
			query.put("date", date);
			query.put("pageName", pageName);
			query.put("nickName", nickName);
			DBObject visited = mongoDB.getCollection(collectionVisited)
					.findOne(query);
			if (visited != null) {
				if(visited.get("sharedList") != null){
					BasicDBList hist = (BasicDBList) visited.get("sharedList");
					Object[] slObjects = hist.toArray();
					for (Object dbobj : slObjects) {
						if (dbobj instanceof String) {
							if(!nickName.equals((String) dbobj)){
								sharedList.add((String) dbobj);
						}
					}
					System.out.println("isExisted-----"+isExisted);
				}
			}
			}
		} catch (Exception e) {
			ret = e.getMessage();
		}

		return sharedList;
	}
	public static String InsertArtcleID(String articleID) {
		mongoDB = getMongoDB();
		String ret = "false";
		try {
			DBObject query = new BasicDBObject();
			query.put("_id", new ObjectId("594ca210b73ebeeeb4d783b9"));
			DBObject articles = mongoDB.getCollection(ClientMeta)
					.findOne(query);
			if (articles != null) {
				System.out.println("articleID is not null...");
				// String num = visited.get("visitedNum")+"";
				BasicDBObject doc = new BasicDBObject();
				DBObject update = new BasicDBObject();
				update.put("articleID", articleID);
				doc.put("$set", update);
				WriteResult wr = mongoDB.getCollection(ClientMeta).update(
						new BasicDBObject().append("_id",
								"594ca210b73ebeeeb4d783b9"), doc);
			} else {
				DBObject insert = new BasicDBObject();
				insert.put("articleID", articleID);
				insert.put("updateTime", articleID);
				mongoDB.getCollection(ClientMeta).insert(insert);
			}
			
			ret = true+":"+articleID;
		} catch (Exception e) {
			log.info("createOrUpdateArticleID--" + e.getMessage());
		}
		return ret;
	}
	public static String getArticleID() {
		String articleID="";
		mongoDB = getMongoDB();
		
		try {
			DBObject query = new BasicDBObject();
			query.put("_id",  new ObjectId("594ca210b73ebeeeb4d783b9"));
			DBCursor queryresults = mongoDB.getCollection(ClientMeta).find(query).limit(1);;
			if (null != queryresults) {

				while (queryresults.hasNext()) {
					DBObject DBObj = queryresults.next();
					articleID = DBObj.get("articleID") == null ? ""
							: DBObj.get("articleID").toString();

				}
			}

		} catch (Exception e) {
			log.info("getArticleID--" + e.getMessage());
		}
		return articleID;
	}
	
	
	public static boolean followAllAreaOrRole(String openid,String flag) {
		mongoDB = getMongoDB();
		Boolean ret = false;
		try {
			ArrayList<RoleOfAreaMap> list=MongoDBBasic.QueryRoleOfAreaMap(flag);
			HashSet<String> kmSets = new HashSet<String>();
			DBCursor dbcur = mongoDB.getCollection(wechat_user).find(
					new BasicDBObject().append("OpenID", openid));
			if (null != dbcur) {
				while (dbcur.hasNext()) {
					DBObject o = dbcur.next();
					if (o.get("likeLists") != null) {
						BasicDBList hist = (BasicDBList) o.get("likeLists");
						Object[] kmObjects = hist.toArray();
						for (Object dbobj : kmObjects) {
							if (dbobj instanceof String) {
								if (!((String) dbobj).startsWith(flag)){
									kmSets.add((String) dbobj);
								}
							}
						}
					}
				}
			}
			for(RoleOfAreaMap temp:list){
				kmSets.add(temp.getId());
			}
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			update.put("likeLists", kmSets);
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(wechat_user).update(
					new BasicDBObject().append("OpenID", openid), doc);
			ret = true;

		} catch (Exception e) {
			log.info("followAllAreaOrRole--" + e.getMessage());
		}
		return ret;
	}
	
	public static ArrayList<RoleOfAreaMap> QueryRoleOfAreaMap(String flag) {
		mongoDB = getMongoDB();
		ArrayList<RoleOfAreaMap> list = new ArrayList<RoleOfAreaMap>();
		DBObject query = new BasicDBObject();
		DBCursor queryresults;
		if (flag != null && !flag.isEmpty()) {
			query.put("flag", flag);
			queryresults = mongoDB.getCollection(role_area).find(query);
		} else {
			queryresults = mongoDB.getCollection(role_area).find();
		}
		if (null != queryresults) {
			while (queryresults.hasNext()) {
				DBObject o = queryresults.next();
				RoleOfAreaMap temp = new RoleOfAreaMap();
				if (o.get("id") != null) {
					temp.setId(o.get("id").toString());
				}
				if (o.get("flag") != null) {
					temp.setFlag(o.get("flag").toString());
				}
				if (o.get("name") != null) {
					temp.setName(o.get("name").toString());
				}
				ArrayList<String> relateLists = new ArrayList<String>();
				if (o.get("relateLists") != null) {
					BasicDBList hist = (BasicDBList) o.get("relateLists");
					Object[] kmObjects = hist.toArray();
					for (Object dbobj : kmObjects) {
						if (dbobj instanceof String) {
							relateLists.add((String) dbobj);
						}
					}
				}
				temp.setRelateLists(relateLists);
				list.add(temp);
			}
		}
		return list;
	}

	
	public static boolean createRoleOfAreaMap(RoleOfAreaMap role) {
		mongoDB = getMongoDB();
		Boolean ret = false;
		try {
			DBObject insert = new BasicDBObject();
			insert.put("id", role.getId());
			insert.put("flag", role.getFlag());
			insert.put("name", role.getName());
			mongoDB.getCollection(role_area).insert(insert);
			ret = true;
		} catch (Exception e) {
			log.info("createRoleOfAreaMap--" + e.getMessage());
		}
		return ret;
	}
/*
 *  march for create AbacusQuizPool
 */
	public static boolean createAbacusQuizPool(AbacusQuizPool abacusQuiz) {
		
		Boolean ret = false;
		//String[] questions = new ArrayList();
		
		try {
			//String[] questions=abacusQuiz.getQuestion().split(",");
			DBObject insert = new BasicDBObject();
			//String uuid = UUID.randomUUID().toString().trim().replaceAll("-", ""); 
			//java.sql.Timestamp cursqlTS = new java.sql.Timestamp(new java.util.Date().getTime());
			Date d = new Date();
			String id="B2017"+d.getTime();
			insert.put("id", id);
			insert.put("title", abacusQuiz.getTitle());			
			insert.put("category", abacusQuiz.getCategory());
			insert.put("checkpoint", abacusQuiz.getCheckpoint());
			insert.put("grade", abacusQuiz.getGrade());	
			insert.put("questionSequence", abacusQuiz.getQuestionSequence());	
			insert.put("batchId", abacusQuiz.getBatchId());	
			List<String> question=abacusQuiz.getQuestion();
			String operators = "";
			int answer=0;
			if(answer==0){
				
				for(String str : question){
					Integer itg=Integer.parseInt(str);
					answer=answer+itg;
					if(Math.abs(itg)==itg){
						operators=operators+"+,";
					}else{
						operators=operators+"-,";
					}
				}
				insert.put("answer", answer);
				insert.put("operator", operators);
				if(answer<0){
					return ret;
				}
			}
			mongoDB = getMongoDB();
			mongoDB.getCollection(collectionAbacusQuizPool).insert(insert);
			
			
			ret = addTagAndQuestion(id,question);
		} catch (Exception e) {
			log.info("createAbacusQuizPool--" + e.getMessage());
		}
		return ret;
	}
	
	@SuppressWarnings("unchecked")
	public static boolean addTagAndQuestion(String id,List<String> questionlist){
		boolean result = false;
		try{
			DBObject query = new BasicDBObject();
			query.put("id", id);
			mongoDB = getMongoDB();
			DBObject queryresults = mongoDB.getCollection(collectionAbacusQuizPool).findOne(query);
			//BasicDBList Tags = (BasicDBList) queryresults.get("Tag");
			BasicDBList Questions = (BasicDBList) queryresults.get("question");
			List listtag = new ArrayList();
			List listquestion = new ArrayList();
			/*if (Tags != null) {
				Object[] tagObjects = Tags.toArray();
				for (Object dbobj : tagObjects) {
					if (dbobj instanceof DBObject) {
						HashMap<String, Object> temp = new HashMap<String, Object>();
						temp.put("tag", ((DBObject) dbobj).get("tag").toString());				
						listtag.add(temp);
					}
					listtag.add(dbobj);
				}
				if(taglist.size()>0){
					for(String lt : taglist){
						listtag.add(lt);
					}
				}
			}else{
				listtag=taglist;
			}*/
			if(Questions !=null){
				Object[] questionObjs = Questions.toArray();
				for (Object dbobj : questionObjs) {
					if (dbobj instanceof DBObject) {			
						listquestion.add(dbobj);
					}
				}
				if(questionlist.size()>0){
					for(String lt : questionlist){
						listquestion.add(Math.abs(Integer.parseInt(lt)));
					}
				}
			}else if(questionlist.size()>0){
				for(String lt : questionlist){
					listquestion.add(Math.abs(Integer.parseInt(lt)));
				}
			}
				
			BasicDBObject doc = new BasicDBObject();
			BasicDBObject update = new BasicDBObject();
			//update.append("tag", listtag);
			update.append("question", listquestion);
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(collectionAbacusQuizPool).update(
					new BasicDBObject().append("id", id), doc);
			result = true;
		} catch (Exception e) {
		log.info("addTagAndQuestion--" + e.getMessage());
	}
	
	return result;

	}
	/*
	 * find all
	 */
	public static List<AbacusQuizPool> findAllAbacusQuizPool(){
		mongoDB = getMongoDB();
		List<AbacusQuizPool> aqps=new ArrayList<AbacusQuizPool>();
		AbacusQuizPool abacusQuizPool;
		
		try {
			//DBObject query = new BasicDBObject();
			DBCursor queryresults = mongoDB.getCollection(collectionAbacusQuizPool).find();
			if (null != queryresults) {
				
				while (queryresults.hasNext()) {
					abacusQuizPool = new AbacusQuizPool();
					//List<String> tag = new ArrayList<String>();
					List<String> question = new ArrayList<String>();
					DBObject o = queryresults.next();
					abacusQuizPool.setTitle(o.get("title")+"");
					abacusQuizPool.setAnswer(Integer.parseInt(o.get("answer")+""));
					abacusQuizPool.setCategory(o.get("category")+"");
					abacusQuizPool.setCheckpoint(o.get("checkpoint")+"");
					abacusQuizPool.setGrade(o.get("grade")+"");
					abacusQuizPool.setId(o.get("id")+"");
					abacusQuizPool.setOperator(o.get("operator")+"");
					abacusQuizPool.setQuestionSequence(o.get("questionSequence")+"");
					abacusQuizPool.setBatchId(o.get("batchId")+"");
					//BasicDBList tags = (BasicDBList) o.get("tag");
					BasicDBList hist = (BasicDBList) o.get("question");
					if (hist != null) {
						Object[] questions = hist.toArray();
						for (Object dbobj : questions) {
							question.add(dbobj+"");
						}
					}
					abacusQuizPool.setQuestion(question);
					/*if(tags!=null){
						Object[] tagss = tags.toArray();
						for (Object dbobj : tagss) {
							tag.add(dbobj+"");
						}
					}
					abacusQuizPool.setTag(tag);*/
					if (abacusQuizPool != null) {
						aqps.add(abacusQuizPool);
					}
				}
			}
		} catch (Exception e) {
			log.info("findAllAbacusQuizPool--" + e.getMessage());
		}
		return aqps;
	}
	/*
	 * find by category
	 */
	public static List<AbacusQuizPool> findAbacusQuizPoolBycategory(String category){
		List<AbacusQuizPool> aqps=new ArrayList<AbacusQuizPool>();
		
		try {
			mongoDB = getMongoDB();
			DBObject Query = new BasicDBObject();
			Query.put("category", category);
			DBCursor queryresults = mongoDB.getCollection(collectionAbacusQuizPool).find(Query);
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					AbacusQuizPool abacusQuizPool = new AbacusQuizPool();
					List<String> tag = new ArrayList<String>();
					List<String> question = new ArrayList<String>();
					DBObject o = queryresults.next();
					abacusQuizPool.setTitle(o.get("title")+"");
					abacusQuizPool.setAnswer(Integer.parseInt(o.get("answer")+""));
					abacusQuizPool.setCategory(o.get("category")+"");
					abacusQuizPool.setCheckpoint(o.get("checkpoint")+"");
					abacusQuizPool.setGrade(o.get("grade")+"");
					abacusQuizPool.setId(o.get("id")+"");
					abacusQuizPool.setOperator(o.get("operator")+"");
					//BasicDBList tags = (BasicDBList) o.get("tag");
					BasicDBList hist = (BasicDBList) o.get("question");
					abacusQuizPool.setQuestionSequence(o.get("questionSequence")+"");
					abacusQuizPool.setBatchId(o.get("batchId")+"");
					if (hist != null) {
						Object[] questions = hist.toArray();
						for (Object dbobj : questions) {
							question.add(dbobj+"");
						}
					}
					abacusQuizPool.setQuestion(question);
					/*if(tags!=null){
						Object[] tagss = tags.toArray();
						for (Object dbobj : tagss) {
							if (dbobj instanceof String) {
								tag.add((String) dbobj);
							}
						}
					}
					abacusQuizPool.setTag(tag);*/
					if (abacusQuizPool != null) {
						aqps.add(abacusQuizPool);
					}
				}
			}
		} catch (Exception e) {
			log.info("findAllAbacusQuizPool--" + e.getMessage());
		}
		return aqps;
	}
	/*
	 * find by id
	 */
	public static List<AbacusQuizPool> findAbacusQuizPoolById(String id){
		List<AbacusQuizPool> aqps=new ArrayList<AbacusQuizPool>();
		
		try {
			mongoDB = getMongoDB();
			DBObject Query = new BasicDBObject();
			Query.put("id", id);
			DBCursor queryresults = mongoDB.getCollection(collectionAbacusQuizPool).find(Query);
			//DBObject queryresults = mongoDB.getCollection(collectionAbacusQuizPool).findOne(query);
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					AbacusQuizPool abacusQuizPool = new AbacusQuizPool();
					List<String> tag = new ArrayList<String>();
					List<String> question = new ArrayList<String>();
					DBObject o = queryresults.next();
					abacusQuizPool.setTitle(o.get("title")+"");
					abacusQuizPool.setAnswer(Integer.parseInt(o.get("answer")+""));
					abacusQuizPool.setCategory(o.get("category")+"");
					abacusQuizPool.setCheckpoint(o.get("checkpoint")+"");
					abacusQuizPool.setGrade(o.get("grade")+"");
					abacusQuizPool.setId(o.get("id")+"");
					abacusQuizPool.setOperator(o.get("operator")+"");
					//BasicDBList tags = (BasicDBList) o.get("tag");
					abacusQuizPool.setQuestionSequence(o.get("questionSequence")+"");
					abacusQuizPool.setBatchId(o.get("batchId")+"");
					BasicDBList hist = (BasicDBList) o.get("question");
					if (hist != null) {
						Object[] questions = hist.toArray();
						for (Object dbobj : questions) {
							question.add(dbobj+"");
						}
					}
					abacusQuizPool.setQuestion(question);
					/*if(tags!=null){
						Object[] tagss = tags.toArray();
						for (Object dbobj : tagss) {
							if (dbobj instanceof String) {
								tag.add((String) dbobj);
							}
						}
					}
					abacusQuizPool.setTag(tag);*/
					if (abacusQuizPool != null) {
						aqps.add(abacusQuizPool);
					}
				}
			}
		} catch (Exception e) {
			log.info("findAbacusQuizPoolById--" + e.getMessage());
		}
		return aqps;
	}
	
	
	/*
	 * delete all
	 */
	public static boolean deleteAllAbacusQuizPool(){
		
		boolean result = false;
		try{
		mongoDB = getMongoDB();
		DBObject removeQuery = new BasicDBObject();
		
		mongoDB.getCollection(collectionAbacusQuizPool).remove(removeQuery);
		result = true;
		}catch (Exception e) {
			log.info("createAbacusQuizPool--" + e.getMessage());
		}
		return result;
	}
	/*
	 * delete by category
	 */
	public static boolean deleteAbacusQuizPoolBycategory(String category){
		
		boolean result = false;
		try{
		mongoDB = getMongoDB();
		DBObject removeQuery = new BasicDBObject();
		removeQuery.put("category", category);
		mongoDB.getCollection(collectionAbacusQuizPool).remove(removeQuery);
		result = true;
		}catch (Exception e) {
			log.info("deleteAbacusQuizPoolBycategory--" + e.getMessage());
		}
		return result;
	}
		
		/*
		 * delete by id
		 */
	public static boolean deleteAbacusQuizPoolById(String id){
			
			boolean result = false;
			try{
			mongoDB = getMongoDB();
			DBObject removeQuery = new BasicDBObject();
			removeQuery.put("id", id);
			mongoDB.getCollection(collectionAbacusQuizPool).remove(removeQuery);
			result = true;
			}catch (Exception e) {
				log.info("deleteAbacusQuizPoolById--" + e.getMessage());
			}
			return result;
	}
	
	/*
	 * 
	 * update HistoryQuiz
	 * 
	 */
	public static boolean updateHistoryQuiz(HistoryQuiz historyQuiz) {
		boolean ret = false;
		DBObject query = new BasicDBObject();
		query.put("openid", historyQuiz.getOpenID());
		query.put("category", historyQuiz.getCategory());

		String level="2";
		if(historyQuiz.getCategory().equals("第一关")){
			level="1";
		}
		try {
			mongoDB = getMongoDB();
			DBObject queryresults = mongoDB.getCollection(collectionHistoryAbacus).findOne(query);
			DBObject dbo = new BasicDBObject();
			String openid=historyQuiz.getOpenID();
			String category=historyQuiz.getCategory();
			if(historyQuiz.getBatchId()!=null&&historyQuiz.getBatchId()!=""){
			dbo.put("batchId",historyQuiz.getBatchId());}
			if(historyQuiz.getQuestionSequence()!=null&&historyQuiz.getQuestionSequence()!=""){
			dbo.put("questionSequence",historyQuiz.getQuestionSequence());}
			dbo.put("answers",historyQuiz.getAnswers());
			dbo.put("wrongIndex",historyQuiz.getWrongIndex());
			if(queryresults!=null){
				System.out.println("update record here ");

				System.out.println("openID====="+historyQuiz.getOpenID()+"|| category===="+ level);
				System.out.println("answers====="+historyQuiz.getAnswers());
				System.out.println("batchID====="+historyQuiz.getBatchId()+"|| questionSequence===="+ historyQuiz.getQuestionSequence());
				BasicDBObject doc = new BasicDBObject();
				doc.put("$set", dbo);
				BasicDBObject db=new BasicDBObject();
				db.append("openid",openid);
				db.append("category",category);
				mongoDB.getCollection(collectionHistoryAbacus).update(db, doc);
				log.info("updateHistoryQuiz end");
				ret = true;
			}else{

				dbo.put("openid",openid);
				dbo.put("category",historyQuiz.getCategory());
				System.out.println("insert record here ");

				System.out.println("openID====="+historyQuiz.getOpenID()+"|| category===="+ level);
				System.out.println("answers====="+historyQuiz.getAnswers());
				System.out.println("batchID====="+historyQuiz.getBatchId()+"|| questionSequence===="+ historyQuiz.getQuestionSequence());
				mongoDB.getCollection(collectionHistoryAbacus).insert(dbo);
			}
			
		} catch (Exception e) {
			log.info("updateTicket--" + e.getMessage());
		}
		return ret;
	}
	
	/*
	 * find by openid and category
	 */
	
	public static HistoryQuiz findHistoryQuizByOpenidAndCategory(String openid,String category){
		HistoryQuiz historyQuiz = new HistoryQuiz();
		DBObject query = new BasicDBObject();
		
		query.put("openid", openid);
		query.put("category", category);
		try {
			mongoDB = getMongoDB();
			DBObject queryresults = mongoDB.getCollection(collectionHistoryAbacus).findOne(query);
			if (null != queryresults) {
				historyQuiz.setOpenID(queryresults.get("openid")+"");
				historyQuiz.setCategory(queryresults.get("category")+"");
				historyQuiz.setBatchId(queryresults.get("batchId")+"");
				historyQuiz.setQuestionSequence(queryresults.get("questionSequence")+"");
				historyQuiz.setAnswers(queryresults.get("answers")+"");
				historyQuiz.setWrongIndex(queryresults.get("wrongIndex")+"");
			}
		}catch (Exception e) {
			log.info("findHistoryQuizByOpenidAndCategory--" + e.getMessage());
		}
		
		return historyQuiz;
		
	}
	
	public static HistoryQuiz findHistoryQuizByOpenid(String openid){
		//List<HistoryQuiz> aqps=new ArrayList<HistoryQuiz>();
		HistoryQuiz historyQuiz = new HistoryQuiz();
		try {
			mongoDB = getMongoDB();
			DBObject Query = new BasicDBObject();
			Query.put("openid", openid);
			DBObject queryresults = mongoDB.getCollection(collectionHistoryAbacus).findOne(Query);
			//DBObject queryresults = mongoDB.getCollection(collectionAbacusQuizPool).findOne(query);
			if (null != queryresults) {
				historyQuiz.setCategory(queryresults.get("category")+"");
				historyQuiz.setBatchId(queryresults.get("batchId")+"");
				historyQuiz.setQuestionSequence(queryresults.get("questionSequence")+"");
				historyQuiz.setAnswers(queryresults.get("answers")+"");
		
			}
		} catch (Exception e) {
			log.info("findAbacusQuizPoolById--" + e.getMessage());
		}
		return historyQuiz;
	}
	
	
public static boolean createAbacusRank(AbacusRank ar) {
		
		Boolean ret = false;
		
		try {
			mongoDB = getMongoDB();
			
			DBObject insert = new BasicDBObject();
			insert.put("openid", ar.getOpenID().trim());
			insert.put("lengthMax",ar.getLengthMax() );			
			insert.put("lengthMin", ar.getLengthMin());
			insert.put("numCount", ar.getNumCount());
			insert.put("rightRate", ar.getRightRate());	
			insert.put("speed", ar.getSpeed());	
			insert.put("type", ar.getType());	
			insert.put("way", ar.getWay());	
			DBObject queryresults = mongoDB.getCollection(collectionAbacusRank).findOne(insert);
			if(queryresults!=null){
				BasicDBObject doc = new BasicDBObject();
				doc.put("$set", insert);
				mongoDB.getCollection(collectionAbacusRank).update(new BasicDBObject().append("openid",ar.getOpenID().trim()), doc);
				log.info("updateAbacusRank end");
				ret = true;
			}else{
				mongoDB.getCollection(collectionAbacusRank).insert(insert);
				ret = true;
			}
		} catch (Exception e) {
			log.info("createAbacusQuizPool--" + e.getMessage());
		}
		return ret;
	}
public static AbacusRank findAbacusRankByOpenid(String openid){
	AbacusRank ar = new AbacusRank();
	try {
		mongoDB = getMongoDB();
		DBObject Query = new BasicDBObject();
		Query.put("openid", openid);
		DBObject queryresults = mongoDB.getCollection(collectionAbacusRank).findOne(Query);
		if (null != queryresults) {
			ar.setLengthMax(queryresults.get("lengthMax")+"");
			ar.setLengthMin(queryresults.get("lengthMin")+"");
			ar.setNumCount(queryresults.get("numCount")+"");
			ar.setOpenID(queryresults.get("openID")+"");
			ar.setRightRate(queryresults.get("rightRate")+"");
			ar.setSpeed(queryresults.get("speed")+"");
			ar.setType(queryresults.get("type")+"");
			ar.setWay(queryresults.get("way")+"");
		}
	} catch (Exception e) {
		log.info("findAbacusRankByOpenid--" + e.getMessage());
	}
	return ar;
	}


/*
 * findUsersByRole
 */
	public static List<WeChatMDLUser> findUsersByRole(String role){
		List<WeChatMDLUser> wmList = new ArrayList<WeChatMDLUser>();
		try {
			mongoDB = getMongoDB();
			BasicDBObject query = new BasicDBObject();
			query.put("Teamer.role", role);
			DBCursor queryresults = mongoDB.getCollection(wechat_user).find(query);
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					WeChatMDLUser weChatMDLUser = new WeChatMDLUser();
					DBObject o = queryresults.next();
					weChatMDLUser.setOpenid(o.get("OpenID")+"");
					Object teamer = o.get("Teamer");
					DBObject teamobj = new BasicDBObject();
					teamobj = (DBObject) teamer;
					if (teamobj != null) {
						if (teamobj.get("selfIntro") != null) {
							weChatMDLUser.setSelfIntro(teamobj.get(
									"selfIntro").toString());
						}
						if (teamobj.get("realName") != null) {
							weChatMDLUser.setNickname(teamobj.get(
									"realName").toString());
						}
					}
					wmList.add(weChatMDLUser);
				}
			}
		} catch (Exception e) {
			log.info("findUsersByRole--" + e.getMessage());
		}
		return wmList;
	}
	
	/*
	 * updateUserByid
	 */
	public static boolean updateUserByOpenid(String studentID,String teacherID) {
		mongoDB = getMongoDB();
		
		Boolean ret = false;
		try {
			BasicDBObject doc = new BasicDBObject();
			DBObject update = new BasicDBObject();
			update.put("Teacher", teacherID);
			doc.put("$set", update);
			WriteResult wr = mongoDB.getCollection(wechat_user).update(
					new BasicDBObject().append("OpenID", studentID), doc);
			ret = true;
		} catch (Exception e) {
			log.info("updateUser--" + e.getMessage());
		}
		return ret;
	}
	
	
	/*
	 * GET student by teacher
	 */
	public static List<WeChatMDLUser> getUserByTeacherOpenid(String teacherID) {
		List<WeChatMDLUser> students = new ArrayList<WeChatMDLUser>();
		mongoDB = getMongoDB();
		
		try {
			BasicDBObject query = new BasicDBObject();
			query.put("Teacher", teacherID);
			DBCursor queryresults = mongoDB.getCollection(wechat_user).find(query);
			if (null != queryresults) {
				while (queryresults.hasNext()) {
					WeChatMDLUser weChatMDLUser = new WeChatMDLUser();
					DBObject o = queryresults.next();
					weChatMDLUser.setOpenid(o.get("OpenID")+"");
					weChatMDLUser.setHeadimgurl(o.get("HeadUrl")+"");
					Object teamer = o.get("Teamer");
					DBObject teamobj = new BasicDBObject();
					teamobj = (DBObject) teamer;
					if (teamobj != null) {
						if (teamobj.get("realName") != null) {
							weChatMDLUser.setNickname(teamobj.get("realName").toString());
						}
					}
					students.add(weChatMDLUser);
				}
			}
		} catch (Exception e) {
			log.info("updateUser--" + e.getMessage());
		}
		return students;
	}
	
//	--------------------------------------------- CLASS RECORD
	public static boolean updateStudentBasicInformation(StudentBasicInformation stInfor) {
		mongoDB = getMongoDB();
		Boolean ret = false;
		String OpenID = stInfor.getOpenID();
		try {
			DBCursor dbcur = mongoDB.getCollection(wechat_user).find(
					new BasicDBObject().append("OpenID", OpenID));
			if (null != dbcur) {
				while (dbcur.hasNext()) {
					DBObject dbo = new BasicDBObject();
					dbo.put("Teamer.enrolledTime", stInfor.getEnrolledTime());
				    dbo.put("Teamer.enrolledWay", stInfor.getEnrolledWay());
					dbo.put("Teamer.district", stInfor.getDistrict());
					//dbo.put("Teamer.totalClass", stInfor.getTotalClass());
					//dbo.put("Teamer.expenseClass", stInfor.getExpenseClass());
					//dbo.put("Teamer.leftPayClass", stInfor.getLeftPayClass());
				   //dbo.put("Teamer.leftSendClass", stInfor.getLeftSendClass());
					BasicDBObject doc = new BasicDBObject();
					doc.put("$set", dbo);
					WriteResult wr = mongoDB.getCollection(wechat_user).update(
							new BasicDBObject().append("OpenID", OpenID), doc);
					ret = true;
				}
			}
		} catch (Exception e) {
			log.info("updateStudentBasicInformation--" + e.getMessage());
		}
		return ret;
	}

	public static boolean updateStudentSendClass(String OpenID, int send) {
		mongoDB = getMongoDB();
		Boolean ret = false;
		DBCursor dbcur = mongoDB.getCollection(wechat_user).find(new BasicDBObject().append("OpenID", OpenID));
		if (null != dbcur) {
			while (dbcur.hasNext()) {
				int sent = 0;
				DBObject teamer = dbcur.next();
				Object tea = teamer.get("Teamer");
				DBObject teamobj = new BasicDBObject();
				teamobj = (DBObject) tea;
				if (teamobj != null) {
					
					if(teamobj.get("leftSendClass")!=null && !"".equals(teamobj.get("leftSendClass")+"")){
						sent = Integer.parseInt(teamobj.get("totalClass")+"");
					}
				}
				sent = sent+send;
				DBObject dbo = new BasicDBObject();
			    dbo.put("Teamer.leftSendClass", sent);
				BasicDBObject doc = new BasicDBObject();
				doc.put("$set", dbo);
				WriteResult wr = mongoDB.getCollection(wechat_user).update(new BasicDBObject().append("OpenID", OpenID), doc);
				ret = true;
			}
		}
		return ret;
		
	}
	
	
	public static boolean addClasspayrecord(Classpayrecord classpr) {
		mongoDB = getMongoDB();
		Boolean ret = false;
		try {
			DBObject dbo = new BasicDBObject();
			
			dbo.put("payOption", classpr.getPayOption());
		    dbo.put("payMoney", classpr.getPayMoney());
			dbo.put("classCount", classpr.getClassCount());
			dbo.put("payTime", classpr.getPayTime());
			dbo.put("studentName", classpr.getStudentName());
			dbo.put("studentOpenID", classpr.getStudentOpenID());
		    
			//String OpenID = classpr.getStudentOpenID();
		
			
			WriteResult wr = mongoDB.getCollection(collectionClassPayRecord).insert(dbo);
			DBCursor dbcur = mongoDB.getCollection(wechat_user).find(new BasicDBObject().append("OpenID", classpr.getStudentOpenID()));
			while(dbcur.hasNext()){
				DBObject o = dbcur.next();
				Object teamer = o.get("Teamer");
				DBObject updatedbo = new BasicDBObject();
				DBObject teamobj = new BasicDBObject();
				teamobj = (DBObject) teamer;
				if (teamobj != null) {
					int total = 0;
					int leftPay=0;
					if(teamobj.get("totalClass")!=null && !"".equals(teamobj.get("totalClass")+"")){
						total = Integer.parseInt(teamobj.get("totalClass")+"");
					}
					if((teamobj.get("leftPayClass"))!=null && !"".equals(teamobj.get("leftPayClass")+"")){
						leftPay = Integer.parseInt(teamobj.get("leftPayClass")+"");
					}
					updatedbo.put("Teamer.totalClass", total+classpr.getClassCount());
					
					updatedbo.put("Teamer.leftPayClass", classpr.getClassCount()+leftPay);
					}
					BasicDBObject doc = new BasicDBObject();
					doc.put("$set", updatedbo);
					WriteResult wrt = mongoDB.getCollection(wechat_user).update(new BasicDBObject().append("OpenID", classpr.getStudentOpenID()), doc);
					ret = true;
				}

		} catch (Exception e) {
			log.info("addClasspayrecord--" + e.getMessage());
			}
		return ret;
	}
//	collectionClassExpenseRecord
	
	public static boolean addClassExpenseRecord(Classexpenserecord exrecord) {
		mongoDB = getMongoDB();
		Boolean ret = false;
		Boolean ret1 = false;
		try {
			DBObject dbo = new BasicDBObject();
			
			dbo.put("expenseOption", exrecord.getExpenseOption());
		    dbo.put("expenseTime", exrecord.getExpenseTime());
			dbo.put("expenseClassCount", exrecord.getExpenseClassCount());
			dbo.put("teacherName", exrecord.getTeacherName());
			dbo.put("teacherOpenID", exrecord.getTeacherOpenID());
			dbo.put("studentName", exrecord.getStudentName());
			dbo.put("studentOpenID",exrecord.getStudentOpenID());
			dbo.put("expenseDistrict", exrecord.getExpenseDistrict());
			dbo.put("teacherComment", exrecord.getTeacherComment());
			dbo.put("teacherConfirmExpense", exrecord.isTeacherConfirmExpense());
			dbo.put("teacherConfirmTime", exrecord.getTeacherConfirmTime());
			dbo.put("parentConfirmExpense", exrecord.isParentConfirmExpense());
			dbo.put("parentConfirmTime", exrecord.getParentConfirmTime());
			
			WriteResult wr = mongoDB.getCollection(collectionClassExpenseRecord).insert(dbo);
			ret = true;
			if(ret){
				DBCursor dbcur = mongoDB.getCollection(wechat_user).find(new BasicDBObject().append("OpenID", exrecord.getStudentOpenID()));
				while(dbcur.hasNext()){
					DBObject o = dbcur.next();
					Object teamer = o.get("Teamer");
					DBObject updatedbo = new BasicDBObject();
					DBObject teamobj = new BasicDBObject();
					teamobj = (DBObject) teamer;
					if (teamobj != null) {
						int total = 0;
						if(teamobj.get("totalClass")!=null && !"".equals(teamobj.get("totalClass")+"")){
							total = Integer.parseInt(teamobj.get("totalClass")+"");
						}
						
						if(total<=0){
							total=0;
						}else if(null!=exrecord.getExpenseClassCount()&&!"".equals(exrecord.getExpenseClassCount())){
							total=total-Integer.parseInt(exrecord.getExpenseClassCount());
						}if(total<=0){
							total=0;
						}
						
						int expense = 0;
						if(teamobj.get("expenseClass")!=null && !"".equals(teamobj.get("expenseClass")+"")){
							expense = Integer.parseInt(teamobj.get("expenseClass")+"");
							
						}if(null!=exrecord.getExpenseClassCount()&&!"".equals(exrecord.getExpenseClassCount())){
							expense=expense+Integer.parseInt(exrecord.getExpenseClassCount().trim());
						}
						
						int leftPay = 0;
						int leftsend=0;
						if((teamobj.get("leftPayClass"))!=null && !"".equals(teamobj.get("leftPayClass")+"")){
							leftPay = Integer.parseInt(teamobj.get("leftPayClass")+"");
						}if(null!=exrecord.getExpenseClassCount()&&!"".equals(exrecord.getExpenseClassCount())){
							leftPay = leftPay - Integer.parseInt(exrecord.getExpenseClassCount());
						}if(leftPay<=0){
							if((teamobj.get("leftSendClass"))!=null && !"".equals(teamobj.get("leftSendClass")+"")){
								leftsend = Integer.parseInt(teamobj.get("leftSendClass")+"")-Math.abs(leftPay);
							}if(leftsend<=0){
								leftsend=0;
							}
							updatedbo.put("Teamer.leftSendClass",leftsend );
							leftPay = 0;
						}
						
						updatedbo.put("Teamer.totalClass",total);
						updatedbo.put("Teamer.expenseClass", expense);
						updatedbo.put("Teamer.leftPayClass", leftPay);
						BasicDBObject doc = new BasicDBObject();
						doc.put("$set", updatedbo);
						WriteResult wrt = mongoDB.getCollection(wechat_user).update(new BasicDBObject().append("OpenID", exrecord.getStudentOpenID()), doc);
						ret1 = true;
					}
				}
			}
			
		} catch (Exception e) {
			log.info("updateClassExpenseRecord--" + e.getMessage());
		}
		return ret1;
	}
}
