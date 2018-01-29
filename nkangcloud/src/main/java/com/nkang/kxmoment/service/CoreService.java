package com.nkang.kxmoment.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Random;
import java.util.Timer;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.dom4j.Element;
import com.mongodb.DBObject;
import com.nkang.kxmoment.baseobject.ArticleMessage;
import com.nkang.kxmoment.baseobject.ClientMeta;
import com.nkang.kxmoment.baseobject.CongratulateHistory;
import com.nkang.kxmoment.baseobject.GeoLocation;
import com.nkang.kxmoment.baseobject.WeChatUser;
import com.nkang.kxmoment.response.Article;
import com.nkang.kxmoment.response.NewsMessage;
import com.nkang.kxmoment.response.TextMessage;
import com.nkang.kxmoment.util.Constants;
import com.nkang.kxmoment.util.MessageUtil;
import com.nkang.kxmoment.util.MongoDBBasic;
import com.nkang.kxmoment.util.RestUtils;

public class CoreService
{
	private static Logger log = Logger.getLogger(CoreService.class);
	private static Timer timer= new Timer();
	public static String processRequest(HttpServletRequest request)
	{
		
		String respXml = null;
		String respContent = "unknown request type.";
		String AccessKey = MongoDBBasic.getValidAccessKey();
		ClientMeta cm=MongoDBBasic.QueryClientMeta(Constants.clientCode);
		String navPic = "http://leshu.bj.bcebos.com/standard/navigation.png";
		try {
			Element requestObject 	= 	MessageUtil.parseXml(request);
			String fromUserName 	= 	requestObject.element("FromUserName").getText();
			String toUserName 		= 	requestObject.element("ToUserName").getText();
			String msgType 			= 	requestObject.element("MsgType").getText();

			TextMessage textMessage = new TextMessage();
			textMessage.setToUserName(fromUserName);
			textMessage.setFromUserName(toUserName);
			textMessage.setCreateTime(new Date().getTime());
			textMessage.setMsgType(MessageUtil.RESP_MESSAGE_TYPE_TEXT);

			NewsMessage newsMessage = new NewsMessage();
			newsMessage.setToUserName(fromUserName);
			newsMessage.setFromUserName(toUserName);
			newsMessage.setCreateTime(new Date().getTime());
			newsMessage.setMsgType(MessageUtil.RESP_MESSAGE_TYPE_NEWS);

			List<Article> articleList = new ArrayList<Article>();

			if (msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_TEXT)) {
				String textContent = requestObject.element("Content").getText().trim();

                String status="";
				int realReceiver=0;
				if ("cm".equals(textContent)) {
					respContent = RestUtils.createMenu(AccessKey);
					textMessage.setContent(respContent);
					respXml = MessageUtil.textMessageToXml(textMessage);
					
				}
				else {
					List<String> allUser = MongoDBBasic.getAllOpenIDByIsActivewithIsRegistered();
	                for(int i=0;i<allUser.size();i++){
	                     if(fromUserName.equals(allUser.get(i))){
	                         allUser.remove(i);
	                     }
	                }
	                    
                 for(int i=0;i<allUser.size();i++){
                    status=RestUtils.sendTextMessageToUserOnlyByCustomInterface(textContent,allUser.get(i),fromUserName);
                   if(RestUtils.getValueFromJson(status,"errcode").equals("0")){
                	   realReceiver++;
                   }
                 }
	                textMessage.setContent(realReceiver + " recevied");
	                respXml = MessageUtil.textMessageToXml(textMessage);
				}
			}

			else if (msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_LINK)) {
				respContent = "LINK";
				textMessage.setContent(respContent);
				respXml = MessageUtil.textMessageToXml(textMessage);
			}
			else if (msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_VOICE)) {
				respContent = "VOICE";
				List<DBObject> results = MongoDBBasic.getDistinctSubjectArea("industrySegmentNames");
				respContent = respContent + results.size() + "\n";

				textMessage.setContent(respContent);
				respXml = MessageUtil.textMessageToXml(textMessage);
			}
			else if (msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_VIDEO)) {
				respContent = "VIDEO";
				textMessage.setContent(respContent);
				respXml = MessageUtil.textMessageToXml(textMessage);
			}
			else if (msgType.equals(MessageUtil.REQ_MESSAGE_TYPE_EVENT)) {
				String eventType = requestObject.element("Event").getText();
				if (eventType.equals(MessageUtil.EVENT_TYPE_SUBSCRIBE)) {
					WeChatUser wcu = RestUtils.getWeChatUserInfo(AccessKey, fromUserName);
					Boolean ret =  false;
					if(wcu.getOpenid() != "" || wcu.getOpenid() != null){
						ret = MongoDBBasic.createUser(wcu);
					}
					articleList.clear();
					Article article = new Article();
					article.setTitle("【"+cm.getClientName()+"】欢迎来到乐数大家庭，请完成注册，享受更多会员福利");
					article.setDescription("移动应用");
					article.setPicUrl("http://leshu.bj.bcebos.com/standard/registerherepls.JPG");
					article.setUrl("http://"+Constants.baehost+"/mdm/profile.jsp?UID=" + fromUserName);
					articleList.add(article);

					Article article4 = new Article();
					article4.setTitle("在此注册");
					article4.setDescription("在此注册");
					article4.setPicUrl("http://leshu.bj.bcebos.com/standard/register_icon.png");
					article4.setUrl("http://"+Constants.baehost+"/mdm/profile.jsp?UID=" + fromUserName);
					articleList.add(article4);
					newsMessage.setArticleCount(articleList.size());
					newsMessage.setArticles(articleList);
					respXml = MessageUtil.newsMessageToXml(newsMessage);
					if(!ret){
						respContent = "User Initialization Failed：\n";
						textMessage.setContent(respContent);
						respXml = MessageUtil.textMessageToXml(textMessage);
					}
				} else if (eventType.equals(MessageUtil.EVENT_TYPE_UNSUBSCRIBE)) {
					// Inactive the User - To-Be-Done
					MongoDBBasic.removeUser(fromUserName);

				} else if (eventType.equals(MessageUtil.EVENT_TYPE_CLICK)) {
					String eventKey = requestObject.element("EventKey").getText();
					if(eventKey.equals("myleshuclass")){
						articleList.clear();
						String role=MongoDBBasic.queryAttrByOpenID("role", fromUserName,true);

						if(role.equals("Role001")||role.equals("Role004")||role.equals("Role005")){
							Article article1 = new Article();
							article1.setTitle("我的课时视图");
							article1.setDescription("欢迎乐数老师在次查看和管理学员课时");
							article1.setPicUrl("http://leshucq.bj.bcebos.com/standard/classunitmgtbig.JPG");
							article1.setUrl("http://"+Constants.baehost+"/mdm/StudentDetail.jsp?UID=" + fromUserName);
							articleList.add(article1);
						}
						else{
							Article article = new Article();
							article.setTitle("我的乐数课时");
							article.setDescription("您可以在次查看课时消费情况哦");
							article.setPicUrl("http://leshucq.bj.bcebos.com/standard/classunitmgtbig.JPG");
							article.setUrl("http://"+Constants.baehost+"/mdm/MyClassDetail.jsp?UID=" + fromUserName);
							articleList.add(article);
						}

						newsMessage.setArticleCount(articleList.size());
						newsMessage.setArticles(articleList);
						respXml = MessageUtil.newsMessageToXml(newsMessage);
					}
					else if(eventKey.equals("mycoupen")){ // Data Lake
						respContent = "正在建设中，请等待";
						textMessage.setContent(respContent);
						respXml = MessageUtil.textMessageToXml(textMessage);
					}
					else if(eventKey.equals("MYAPPS")){
						articleList.clear();
						Article article = new Article();
						
						article.setTitle(cm.getClientName()+"|移动应用");
						article.setDescription("移动应用");
						article.setPicUrl("http://leshu.bj.bcebos.com/standard/leshuapp.JPG");
						article.setUrl("http://"+Constants.baehost+"/mdm/profile.jsp?UID=" + fromUserName);
						articleList.add(article);
						Article article2 = new Article();
						article2.setTitle("乐数微应用");
						article2.setDescription("My Personal Applications");
						article2.setPicUrl("http://leshu.bj.bcebos.com/icon/weiapp.png");
						article2.setUrl("http://"+Constants.baehost+"/mdm/profile.jsp?UID=" + fromUserName);
						articleList.add(article2);
						String hardcodeUID = "oO8exvz-DZOu8wc0f81v9EHYq2HE";
						String hardcodeUID2 = "oI3krwbSD3toGOnt_bhuhXQ0TVyo";
						if(hardcodeUID2.equalsIgnoreCase(fromUserName)||hardcodeUID.equalsIgnoreCase(fromUserName)||MongoDBBasic.checkUserAuth(fromUserName, "isAdmin")){
							Article article3 = new Article();
							article3.setTitle("乐数微管理");
							article3.setDescription("Administration");
							article3.setPicUrl("http://leshu.bj.bcebos.com/icon/weiadmin.png");
							article3.setUrl("http://"+Constants.baehost+"/admin/index.jsp?UID=" + fromUserName);
							articleList.add(article3);
							
							Article article4 = new Article();
							article4.setTitle("课时充值");
							article4.setDescription("Administration");
							article4.setPicUrl("http://leshucq.bj.bcebos.com/icon/Cost_savings.png");
							article4.setUrl("http://"+Constants.baehost+"/wxpay/WechatPay.jsp?UID=" + fromUserName);
							articleList.add(article4);
							
							Article article5 = new Article();
							article5.setTitle("积分管理");
							article5.setDescription("Administration");
							article5.setPicUrl("http://leshucq.bj.bcebos.com/icon/creditbuy.png");
							article5.setUrl("http://"+Constants.baehost+"/mdm/CreditManagement.jsp?UID=" + fromUserName);
							articleList.add(article5);
							
							
						}
						newsMessage.setArticleCount(articleList.size());
						newsMessage.setArticles(articleList);
						respXml = MessageUtil.newsMessageToXml(newsMessage);
					}
					else if(eventKey.equals("MYRECOG")){
						articleList.clear();
						Article article = new Article();
						article.setTitle("My Lasted Recognitions");
						article.setDescription("My Lasted Recognition");
						article.setPicUrl("http://"+Constants.baehost+"/MetroStyleFiles/RecognitionImage.jpg");
						article.setUrl("http://"+Constants.baehost+"/mdm/DQNavigate.jsp?UID=" + fromUserName);
						articleList.add(article);
						
						// add article here
						List<CongratulateHistory> myrecoghistList = MongoDBBasic.getRecognitionInfoByOpenID(fromUserName, "");
						int myRecog = myrecoghistList.size();
						if(myRecog > 6){
							myRecog = 6;
						}
						Article myarticle;
						CongratulateHistory congratulateHistory;
						String icoURLPartnerFirst = "https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000DkaRc&oid=00D90000000pkXM";
						String icoURLBaisForAction = "https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000DkaS6&oid=00D90000000pkXM";
						String icoURLInnovator = "https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000DkaSa&oid=00D90000000pkXM";
						String icoURL = "http://"+Constants.baehost+"/MetroStyleFiles/RecognitionImage.jpg";
						for(int i = myRecog; i >= 1; i--){
							myarticle = new Article();
							congratulateHistory = new CongratulateHistory();
							congratulateHistory = myrecoghistList.get(i-1);
							String type = congratulateHistory.getType();
							String comments  = congratulateHistory.getComments();
							if(StringUtils.isEmpty(comments)){
								comments = "You must done something amazaing";
							}
							else if(comments.length() >= 30){
								comments =  comments.trim();
								comments = comments.substring(0, 30) + "...";
							}
							myarticle.setTitle(congratulateHistory.getComments()  +"\n" + congratulateHistory.getCongratulateDate() + " | " + congratulateHistory.getFrom() + "\n" + type);
							myarticle.setDescription("My Recognition");
							if(type.equalsIgnoreCase("Bais For Action")){
								icoURL = icoURLBaisForAction;
							}
							else if(type.equalsIgnoreCase("Innovators at Heart")){
									icoURL = icoURLInnovator;
							}
							else{ 
								icoURL = icoURLPartnerFirst;
							}
							myarticle.setPicUrl(icoURL);
							myarticle.setUrl("http://"+Constants.baehost+"/mdm/RecognitionCenter.jsp?uid=" + fromUserName + "&num="+i);
							articleList.add(myarticle);
						}						

						newsMessage.setArticleCount(articleList.size());
						newsMessage.setArticles(articleList);
						respXml = MessageUtil.newsMessageToXml(newsMessage);
					}
					else if (eventKey.equals("nbcolleague")) {
						GeoLocation geol = MongoDBBasic.getDBUserGeoInfo(fromUserName);
						String lat = geol.getLAT();
						String lng = geol.getLNG();
						String addr = geol.getFAddr();
						Article article = new Article();
						Random rand = new Random();
						int randNum = rand.nextInt(30);
						article.setTitle("附近和我一起学习珠心算的乐数同学");
						article.setDescription("您当前所在位置:" + addr);
						article.setPicUrl("http://leshu.bj.bcebos.com/standard/abacus.jpg");
						article.setUrl("http://"+Constants.baehost+"/mdm/scan/scan.jsp?UID=" + fromUserName+"&num="+randNum);
						articleList.add(article);
						newsMessage.setArticleCount(articleList.size());
						newsMessage.setArticles(articleList);
						respXml = MessageUtil.newsMessageToXml(newsMessage);
						
					}else if (eventKey.equals("myPoints")) {//使劲戳我
						Article article = new Article();
						Random rand = new Random();
						int randNum = rand.nextInt(30);
						article.setTitle("点击开启你的幸运旅程-每日抽奖");
						article.setPicUrl("https://c.ap1.content.force.com/servlet/servlet.ImageServer?id=0159000000E9rIB&oid=00D90000000pkXM");
						//article.setUrl("http://"+Constants.baehost+"/mdm/scan/scan.jsp?UID=" + fromUserName+"&num="+randNum);
						article.setUrl("https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constants.APP_ID+"&redirect_uri=http%3A%2F%2F"+Constants.baehost+"%2Fmdm%2FLucky.jsp&response_type=code&scope=snsapi_userinfo&state=STATE#wechat_redirect");
						articleList.add(article);
						newsMessage.setArticleCount(articleList.size());
						newsMessage.setArticles(articleList);
						respXml = MessageUtil.newsMessageToXml(newsMessage);

					}else if (eventKey.equals("SelfTraining")) {//我的订阅
						articleList.clear();
						Article article = new Article();
						article.setTitle(cm.getClientName()+"|欢迎进入自我修炼");
						article.setDescription("乐数在线练习");
						article.setPicUrl("http://leshucq.bj.bcebos.com/standard/standard_leshuslide1.jpg");
						article.setUrl("http://leshu.bj.bcebos.com/standard/leshuslide2.JPG");
						articleList.add(article);
						
						Article article1 = new Article();
						article1.setTitle("乐数在线练习 - 悟时自渡");
						article1.setDescription("乐数在线练习 - 悟时自渡");
						article1.setPicUrl("http://leshucq.bj.bcebos.com/icon/selflearning.png");
						article1.setUrl("https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constants.APP_ID+"&redirect_uri=http%3A%2F%2F"+Constants.baehost+"%2Fmdm%2FNavigator.jsp?UID="+fromUserName+"&response_type=code&scope=snsapi_userinfo&state="+fromUserName+"#wechat_redirect");
						articleList.add(article1);
						
						Article article2 = new Article();
						article2.setTitle("乐数在线练习 - 虚拟算盘");
						article2.setDescription("乐数在线练习 - 虚拟算盘");
						article2.setPicUrl("http://leshucq.bj.bcebos.com/standard/classunitmgt.png");
						article2.setUrl("https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constants.APP_ID+"&redirect_uri=http%3A%2F%2F"+Constants.baehost+"%2Fmdm%2FNavigator.jsp?UID="+fromUserName+"&response_type=code&scope=snsapi_userinfo&state="+fromUserName+"#wechat_redirect");
						articleList.add(article2);

						newsMessage.setArticleCount(articleList.size());
						newsMessage.setArticles(articleList);
						respXml = MessageUtil.newsMessageToXml(newsMessage);
						
					}
					else if (eventKey.equals("opsmetric")) {//我的订阅
						
						articleList.clear();
						Article article = new Article();
						article.setTitle(cm.getClientName()+"|乐数风采");
						article.setDescription("您可查看实时更新的产品运维报表");
						article.setPicUrl("http://leshu.bj.bcebos.com/standard/leshumoment.JPG");
						article.setUrl("http://leshu.bj.bcebos.com/standard/leshuslide2.JPG");
						articleList.add(article);
						
						Article article1 = new Article();
						article1.setTitle("学员风采");
						article1.setDescription("IM统计情况");
						article1.setPicUrl("http://leshu.bj.bcebos.com/icon/student.png");
						article1.setUrl("http://wxe542e71449270554.dodoca.com/164368/phonewebsitet/websitet?uid=164368&openid=FANS_ID&id=99846#mp.weixin.qq.com");
						articleList.add(article1);

						Article article3 = new Article();
						article3.setTitle("家园共育");
						article3.setDescription("家园共育");
						article3.setPicUrl("http://leshu.bj.bcebos.com/icon/parenteacher.png");
						article3.setUrl("http://mp.weixin.qq.com/s/EwgxfqfuzIuQgPss7jdNtQ");
						articleList.add(article3);
						
						newsMessage.setArticleCount(articleList.size());
						newsMessage.setArticles(articleList);
						respXml = MessageUtil.newsMessageToXml(newsMessage);

					}
					else if (eventKey.equals("sitenavigator")){
						articleList.clear();
						Article article = new Article();
						article.setTitle("乐数为您导航");
						article.setDescription("乐数为您导航");
						article.setPicUrl("http://leshu.bj.bcebos.com/standard/carnavigation.JPG");
						article.setUrl("http://m.amap.com/search/view/keywords=%E5%8D%97%E5%9D%AA%E4%B8%87%E8%BE%BE%E5%B9%BF%E5%9C%BA2%E5%8F%B7%E5%86%99%E5%AD%97%E6%A5%BC11-6%20"); //http://map.baidu.com/mobile
						articleList.add(article);
						
						Article articlenav1 = new Article();
						articlenav1.setTitle("南坪校区[TEL:023-62387134 | MOB：13372680273]\n南坪万达广场2号写字楼11-6"); //九龙坡区铁路村198号
						articlenav1.setDescription("南坪校区[TEL:023-62387134]");
						articlenav1.setPicUrl(navPic);
						articlenav1.setUrl("http://m.amap.com/search/view/keywords=%E5%8D%97%E5%9D%AA%E4%B8%87%E8%BE%BE%E5%B9%BF%E5%9C%BA2%E5%8F%B7%E5%86%99%E5%AD%97%E6%A5%BC11-6%20");
						articleList.add(articlenav1);
						
						Article articlenav2 = new Article();
						articlenav2.setTitle("江北校区[TEL:023-67616306 | MOB：18102381821]\n红旗河沟佰乐街2栋5-14"); //港城工业园区C区
						articlenav2.setDescription("江北校区[TEL:023-67616306]");
						articlenav2.setPicUrl(navPic);
						articlenav2.setUrl("https://m.amap.com/search/mapview/markers=29.584467%2C106.526931%2C%E9%87%8D%E5%BA%86%E5%B8%82%E6%B1%9F%E5%8C%97%E5%8C%BA%E4%BD%B0%E4%B9%90%E8%A1%972");
						articleList.add(articlenav2);
						
						Article articlenav4 = new Article();
						articlenav4.setTitle("李家沱校区[TEL:023-67505761 | MOB：18423316164]\n李家沱都和广场A栋30-5"); //重庆沙坪坝区土主镇西部物流园区中石油仓储中心
						articlenav4.setDescription("李家沱校区[TEL:023-67505761]");
						articlenav4.setPicUrl(navPic);
						articlenav4.setUrl("http://m.amap.com/search/view/keywords=%E6%9D%8E%E5%AE%B6%E6%B2%B1%E9%83%BD%E5%92%8C%E5%B9%BF%E5%9C%BAA%E6%A0%8B30-5");
						articleList.add(articlenav4);
						
						Article articlenav3 = new Article();
						articlenav3.setTitle("杨家坪校区[TEL:13372680273]\n杨家坪步行街金州大厦16楼");
						articlenav3.setDescription("杨家坪校区[TEL:13372680273]");
						articlenav3.setPicUrl(navPic);
						articlenav3.setUrl("http://m.amap.com/search/view/keywords=%E6%9D%A8%E5%AE%B6%E5%9D%AA%E6%AD%A5%E8%A1%8C%E8%A1%97%E9%87%91%E5%B7%9E%E5%A4%A7%E5%8E%A616%E6%A5%BC");
						articleList.add(articlenav3);
												
						Article articlenav6 = new Article();
						articlenav6.setTitle("青少年宫[TEL:15826269989]\n江北区青少年宫（石子山公园内）");
						articlenav6.setDescription("石子山公园内");
						articlenav6.setPicUrl(navPic);
						articlenav6.setUrl("http://m.amap.com/search/mapview/keywords=%E7%9F%B3%E5%AD%90%E5%B1%B1%E4%BD%93%E8%82%B2%E5%85%AC%E5%9B%AD%E7%AF%AE%E7%90%83%E5%9C%BA&city=500105&poiid=B0FFH0QH92");
						articleList.add(articlenav6);
						
						
						newsMessage.setArticleCount(articleList.size());
						newsMessage.setArticles(articleList);
						respXml = MessageUtil.newsMessageToXml(newsMessage);
						
					}
					else if (eventKey.equals("nboppt")) {// Partner
						Article article = new Article();
						article.setTitle(cm.getClientName()+"| 更多精彩尽乐数动态 ");
						article.setDescription("更多精彩尽乐数动态 ");
						article.setPicUrl("http://leshu.bj.bcebos.com/standard/leshuslide4.JPG");
						article.setUrl("http://"+Constants.baehost+"/mdm/MesPushHistory.jsp?UID="+fromUserName);
						articleList.add(article);
						List<ArticleMessage> ams=MongoDBBasic.getArticleMessageByNum("");
						int size=3;
						if(ams.size()<3){
							size=ams.size();
						}
						for(int i = 0; i < size ;  i++){
							Article articlevar = new Article();
							articlevar.setTitle(ams.get(i).getTitle()+"\n"+ams.get(i).getTime());
							articlevar.setDescription("");
							if(ams.get(i).getPicture()!=null&&ams.get(i).getPicture()!=""){
							articlevar.setPicUrl(ams.get(i).getPicture());
							}
							else{
								articlevar.setPicUrl("http://leshu.bj.bcebos.com/standard/reservationBigPic.jpg");
							}
							articlevar.setUrl("https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constants.APP_ID+"&redirect_uri=http%3A%2F%2F"+Constants.baehost+"%2Fmdm%2FNotificationCenter.jsp?num="+ams.get(i).getNum()+"&response_type=code&scope=snsapi_userinfo&state="+fromUserName+"#wechat_redirect");
							System.out.println("url======="+"https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Constants.APP_ID+"&redirect_uri=http%3A%2F%2F"+Constants.baehost+"%2Fmdm%2FNotificationCenter.jsp?num="+ams.get(i).getNum()+"&response_type=code&scope=snsapi_userinfo&state="+fromUserName+"#wechat_redirect");
							articleList.add(articlevar);
						}
						newsMessage.setArticleCount(articleList.size());
						newsMessage.setArticles(articleList);
						respXml = MessageUtil.newsMessageToXml(newsMessage);
					}

				} else if (eventType.equals(MessageUtil.EVENT_TYPE_SCAN_TEXT)) {
					String eventKey = requestObject.element("EventKey").getText();
					if (eventKey.equals("C1")) {
						respContent = requestObject.element("ScanCodeInfo").element("ScanResult").getText();
						textMessage.setContent(respContent);
						respXml = MessageUtil.textMessageToXml(textMessage);
					}
				} else if (eventType.equals(MessageUtil.EVENT_TYPE_SCAN_URL)) {
					respContent = "scan url and redirect.";
					textMessage.setContent(respContent);
					respXml = MessageUtil.textMessageToXml(textMessage);
				} else if (eventType.equals(MessageUtil.EVENT_TYPE_SCAN)) {
					respContent = "scan qrcode.";
					textMessage.setContent(respContent);
					respXml = MessageUtil.textMessageToXml(textMessage);
				} else if (eventType.equals(MessageUtil.EVENT_TYPE_LOCATION)) {
					respContent = "upload location detail.";
					textMessage.setContent(respContent);
					WeChatUser wcu = RestUtils.getWeChatUserInfo(AccessKey, fromUserName);
					MongoDBBasic.updateUser(fromUserName, requestObject.element("Latitude").getText(), requestObject.element("Longitude").getText(),wcu);
				} else if (eventType.equals(MessageUtil.EVENT_TYPE_VIEW)) {
					respContent = "page redirect.";
					textMessage.setContent(respContent);
					respXml = MessageUtil.textMessageToXml(textMessage);
				}
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return respXml;
	}
	
}
