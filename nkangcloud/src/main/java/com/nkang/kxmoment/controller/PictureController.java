package com.nkang.kxmoment.controller;
import java.util.ArrayList;

import javax.servlet.http.HttpServletRequest;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;


import com.nkang.kxmoment.baseobject.FaceObj;
import com.nkang.kxmoment.util.CommenJsonUtil;
import com.nkang.kxmoment.util.FaceCalUtil;
import com.nkang.kxmoment.util.FaceRecognition;
import com.nkang.kxmoment.util.NumberUtil;
import com.nkang.kxmoment.util.StringUtils;
import com.nkang.kxmoment.util.Constants;
@Controller
public class PictureController{
	/**
    * <p>Description: 上传文件</p>
    * @param request
    */
	@RequestMapping("/uploadPicture")
	@ResponseBody
    public ArrayList<FaceObj>  upload(HttpServletRequest request) {
		String openid = request.getParameter("openid");
		
		String URL = "http://"+Constants.bucketName+"."+Constants.bosDomain+"/"+openid+".jpg";
		String str="";
		FaceRecognition faceRecognition = new FaceRecognition();
		ArrayList<FaceObj> ls = new ArrayList<FaceObj>();
		
		JSONArray jsonArraGoface;
		JSONArray jsonArraEmotion;
		try {
			//String URL = CoreService.picURL;// "http://mmbiz.qpic.cn/mmbiz_jpg/WB6qdHS5xfEEO8tSzLHxG7nvFB0yQzqPdm8iafdluCIq6EOt4sDRyItQJVvQFbb785C3ic3Bbz468ibOS0ibSFBJIg/0";
			if(	StringUtils.isEmpty(URL)){
				str="please reupload a clear head photo..";
				//URL = "http://mmbiz.qpic.cn/mmbiz_jpg/WB6qdHS5xfEEO8tSzLHxG7nvFB0yQzqPdm8iafdluCIq6EOt4sDRyItQJVvQFbb785C3ic3Bbz468ibOS0ibSFBJIg/0";
			}else{
				
				jsonArraGoface = new JSONArray(faceRecognition.goface(URL).toString());
				jsonArraEmotion = new JSONArray(faceRecognition.gofaceEmotion(URL).toString());
				
				if(jsonArraGoface!=null && jsonArraEmotion!=null){
					for(int i=0 ; i < jsonArraEmotion.length() ;i++)
					  {
						  FaceObj fo = new FaceObj();
						  JSONObject myjObject = jsonArraGoface.getJSONObject(i);
						  JSONObject myjObjectEmotion = jsonArraEmotion.getJSONObject(i);
						  fo.setCurrentUrl(URL);
						  fo.setAnger(NumberUtil.scienceToNormal(CommenJsonUtil.jsonToObject(myjObjectEmotion.get("scores").toString()).get("anger").toString()));
						  fo.setContempt(NumberUtil.scienceToNormal(CommenJsonUtil.jsonToObject(myjObjectEmotion.get("scores").toString()).get("contempt").toString()));
						  fo.setDisgust(NumberUtil.scienceToNormal(CommenJsonUtil.jsonToObject(myjObjectEmotion.get("scores").toString()).get("disgust").toString()));
						  fo.setFear(NumberUtil.scienceToNormal(CommenJsonUtil.jsonToObject(myjObjectEmotion.get("scores").toString()).get("fear").toString()));
						  fo.setHappiness(NumberUtil.scienceToNormal(CommenJsonUtil.jsonToObject(myjObjectEmotion.get("scores").toString()).get("happiness").toString()));
						  fo.setNeutral(NumberUtil.scienceToNormal(CommenJsonUtil.jsonToObject(myjObjectEmotion.get("scores").toString()).get("neutral").toString()));
						  fo.setSadness(NumberUtil.scienceToNormal(CommenJsonUtil.jsonToObject(myjObjectEmotion.get("scores").toString()).get("sadness").toString()));
						  fo.setSurprise(NumberUtil.scienceToNormal(CommenJsonUtil.jsonToObject(myjObjectEmotion.get("scores").toString()).get("surprise").toString()));
						  
						  fo.setAge(CommenJsonUtil.jsonToObject(myjObject.get("faceAttributes").toString()).get("age").toString());
						  fo.setBeard(CommenJsonUtil.jsonToObject(CommenJsonUtil.jsonToObject(myjObject.get("faceAttributes").toString()).getString("facialHair").toString()).get("beard").toString());
						  fo.setGender(CommenJsonUtil.jsonToObject(myjObject.get("faceAttributes").toString()).get("gender").toString());
						  fo.setGlasses(CommenJsonUtil.jsonToObject(myjObject.get("faceAttributes").toString()).get("glasses").toString());
						  fo.setMoustache(CommenJsonUtil.jsonToObject(CommenJsonUtil.jsonToObject(myjObject.get("faceAttributes").toString()).getString("facialHair").toString()).get("moustache").toString());
						  fo.setSmile(CommenJsonUtil.jsonToObject(myjObject.get("faceAttributes").toString()).get("smile").toString());
						  
						  fo=FaceCalUtil.toCal(fo);
						  //convert
						  fo.setBeard(String.valueOf(Float.parseFloat(fo.getBeard()) * 100));
						  fo.setMoustache(String.valueOf(Float.parseFloat(fo.getMoustache()) * 100));
						  fo.setSmile(String.valueOf(Float.parseFloat(fo.getSmile()) * 100));
						  //convert
						  fo.setAnger(String.valueOf(Float.parseFloat(fo.getAnger()) * 100)); 
						  fo.setContempt(String.valueOf(Float.parseFloat(fo.getContempt()) * 100));
						  fo.setDisgust(String.valueOf(Float.parseFloat(fo.getDisgust()) * 100));
						  fo.setFear(String.valueOf(Float.parseFloat(fo.getFear()) * 100));
						  fo.setHappiness(String.valueOf(Float.parseFloat(fo.getHappiness()) * 100));
						  fo.setNeutral(String.valueOf(Float.parseFloat(fo.getNeutral()) * 100));
						  fo.setSadness(String.valueOf(Float.parseFloat(fo.getSadness()) * 100));
						  fo.setSurprise(String.valueOf(Float.parseFloat(fo.getSurprise()) * 100));
						  
						  
						  
						  ls.add(fo);
					  }
					for(int i=0 ; i < ls.size() ;i++){
						 str = str+"\n\n" + ls.get(i).Info()+ "\n\n";
					 }
				}else{
					str="服务器繁忙，请稍后再试！";
				}
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		 
		return ls;
	}
}
 
