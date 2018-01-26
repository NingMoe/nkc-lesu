package com.nkang.kxmoment.controller;


import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.mysql.jdbc.StringUtils;
import com.nkang.kxmoment.baseobject.WeChatMDLUser;
import com.nkang.kxmoment.util.MongoDBBasic;
import com.nkang.kxmoment.util.RestUtils;

@Controller
public class RegisterController {
	
	@RequestMapping("/regist")
	@ResponseBody
	public boolean regist(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
		request.setCharacterEncoding("UTF-8"); 
		String openId = request.getParameter("uid");
		String name = request.getParameter("name");
	//	String role = request.getParameter("role");
		Date now = new Date(); 
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		String registerDate = dateFormat.format(now);
		//String selfIntro = URLDecoder.decode(request.getParameter("selfIntro"),"UTF-8");
		String selfIntro = request.getParameter("selfIntro");
		String telephone = request.getParameter("telephone");
		String email = request.getParameter("email");
	//	String group = request.getParameter("group");

		ArrayList list = new ArrayList();
		Map map = new HashMap();

		list.add(map);
		System.out.println(list);
		WeChatMDLUser user = new WeChatMDLUser();
		user.setOpenid(URLEncoder.encode(openId, "UTF-8"));
		user.setRealName(URLEncoder.encode(name, "UTF-8"));
	//	user.setRole(URLEncoder.encode(role, "UTF-8"));
		user.setRegisterDate(registerDate);
//		user.setSelfIntro(URLEncoder.encode(selfIntro, "UTF-8"));
		user.setPhone(URLEncoder.encode(telephone, "UTF-8"));
//		user.setEmail(URLEncoder.encode(email, "UTF-8"));
	//	user.setGroupid(URLEncoder.encode(group, "UTF-8"));
	//	user.setTag(list);
		//if(validateRegist(user)){
			return Boolean.parseBoolean(RestUtils.regist(user));
//		}
//		return false;
	}
	

	@RequestMapping("/updateUserInfo")
	@ResponseBody
	public boolean updateUserInfo(HttpServletRequest request, HttpServletResponse response) throws UnsupportedEncodingException{
		request.setCharacterEncoding("UTF-8"); 
		String openId = request.getParameter("uid");
		String isActived = request.getParameter("isActived");
		String isAuthenticated = request.getParameter("isAuthenticated");
		String isRegistered = request.getParameter("isRegistered");
		String isSmsTeam = request.getParameter("isSmsTeam");
		String isAdmin = request.getParameter("isAdmin");
		String registerDate = request.getParameter("registerDate");
		String role = request.getParameter("role");
		String level = request.getParameter("level");
		String creditPoint = request.getParameter("creditPoint");
		System.out.println("get level is"+level);
		String teacher = request.getParameter("teacher");
		String realName = request.getParameter("realName");
		String phone = request.getParameter("phone");
		String email = request.getParameter("email");
		WeChatMDLUser user = new WeChatMDLUser();
		user.setOpenid(URLEncoder.encode(openId, "UTF-8"));
		user.setIsAdmin(isAdmin);
		user.setIsSmsTeam(isSmsTeam);
		user.setIsActive(isActived);
		user.setIsAuthenticated(isAuthenticated);
		user.setIsRegistered(isRegistered);
		user.setRole(role);
		user.setTeacher(teacher);
		user.setLevel(level);
		user.setRealName(realName);
		user.setPhone(phone);
		user.setEmail(email);
		user.setCreditPoint(creditPoint);

		System.out.println("Teacher first" + user.getTeacher());
		if(!StringUtils.isNullOrEmpty(registerDate)){
			user.setRegisterDate(registerDate);
		}
		return MongoDBBasic.updateUserWithManageStatus(user);
	}
	
	@RequestMapping("/ajaxValidateTelephone")
	@ResponseBody
	private boolean ajaxValidateTelephone(HttpServletRequest request, HttpServletResponse response) throws IOException{
		String telephone = request.getParameter("telephone");
		return MongoDBBasic.queryWeChatUserTelephone(telephone);
	}
	
	@RequestMapping("/ajaxValidateEmail")
	@ResponseBody
	public boolean ajaxValidateEmail(HttpServletRequest request, HttpServletResponse response) throws IOException {
		String email = request.getParameter("email");
		return MongoDBBasic.queryWeChatUserEmail(email);
	}
	
	private boolean validateRegist(WeChatMDLUser formUser) {
		String openId = formUser.getOpenid();
		if(StringUtils.isNullOrEmpty(openId)){
			return false;
		} 
		
		String telephone = formUser.getPhone();
		if(telephone == null || telephone.trim().isEmpty()){
			return false;
		} else if(!telephone.matches("^1[34578]\\d{9}$")){
			return false;
		} else if(!MongoDBBasic.queryWeChatUserTelephone(telephone)){
			return false;
		}
		
		String email = formUser.getEmail();
		if(email == null || email.trim().isEmpty()) {
			return false;
		} else if(!email.matches("^(\\w-*\\.*)+@(\\w-?)+(\\.\\w{2,})+$")) {
			return false;
		} else if(!MongoDBBasic.queryWeChatUserEmail(email)) {
			return false;
		}
		
		String role = formUser.getRole();
		if(StringUtils.isNullOrEmpty(role)){
			return false;
		} 
		
		String groupid = formUser.getGroupid();
		if(StringUtils.isNullOrEmpty(groupid)){
			return false;
		} 
		return true;
	}
	
}
