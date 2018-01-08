package com.nkang.kxmoment.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.nkang.kxmoment.baseobject.classhourrecord.Classexpenserecord;
import com.nkang.kxmoment.baseobject.classhourrecord.Classpayrecord;
import com.nkang.kxmoment.baseobject.classhourrecord.StudentBasicInformation;
import com.nkang.kxmoment.util.MongoDBBasic;
//ClassRecord/updateStudentBasicInformation?openID=oO8exvzE95JUvwpNxNTxraOqzUFI&enrolledTime=2018-1-5&enrolledWay=lao&district=chongqing
@Controller
@RequestMapping("/ClassRecord")
public class ClassRecordController {
	@RequestMapping("/updateStudentBasicInformation")
	public @ResponseBody String AddClassRecord(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "openID") String openid,
			@RequestParam(value = "enrolledTime") String enrolledTime,
			@RequestParam(value = "enrolledWay") String enrolledWay,
			@RequestParam(value = "district") String district
			//@RequestParam(value = "totalClass") String totalClass,
			//@RequestParam(value = "expenseClass") String expenseClass,
			//@RequestParam(value = "leftPayClass") String leftPayClass,
			//@RequestParam(value = "leftSendClass") String leftSendClass
			)
	{
		StudentBasicInformation stInfor = new StudentBasicInformation();
		stInfor.setDistrict(district);
		stInfor.setEnrolledTime(enrolledTime);
		stInfor.setEnrolledWay(enrolledWay);
		//stInfor.setExpenseClass(0);
		//stInfor.setLeftPayClass(0);
		//stInfor.setLeftSendClass(0);
		stInfor.setOpenID(openid);
		//stInfor.setTotalClass(0);
		if(MongoDBBasic.updateStudentBasicInformation(stInfor)){
			return "success";
		}
		return "failed";
		
	}
	
	//updateStudentSendClass(String OpenID, int send)
	
	@RequestMapping("/updateStudentSendClass")
	public @ResponseBody String UpdateStudentSendClass(@RequestParam(value = "openID") String openid,@RequestParam(value = "send") int send){
		if(MongoDBBasic.updateStudentSendClass(openid,send)){
			return "success";
		}
		
		return "failed";
		
		
	}
//	ClassRecord/addClasspayrecord?payOption=YY语音&payMoney=2230&classCount=20&payTime=2018-01-05&studentName=march&studentOpenID=oO8exvzE95JUvwpNxNTxraOqzUFI
	@RequestMapping("/addClasspayrecord")
	public @ResponseBody String AddClasspayrecord(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "payOption") String payOption,
			@RequestParam(value = "payMoney") String payMoney,
			@RequestParam(value = "classCount") String classCount,
			@RequestParam(value = "payTime") String payTime,
			@RequestParam(value = "studentName") String studentName,
			@RequestParam(value = "studentOpenID") String studentOpenID){
		Classpayrecord cpd = new Classpayrecord();
		int money=0;
		int count=0;
		if(null!=payMoney && !"".equals(payMoney)){
			money=Integer.parseInt(payMoney);
		}
		if(null!=classCount && !"".equals(classCount)){
			count = Integer.parseInt(classCount);
		}
		cpd.setStudentName(studentName);
		cpd.setPayMoney(money);
		cpd.setPayOption(payOption);
		cpd.setPayTime(payTime);
		cpd.setStudentOpenID(studentOpenID);
		cpd.setClassCount(count);
		if(MongoDBBasic.addClasspayrecord(cpd)){
			return "succss";
		}
		
				return "failed";
		
		
	}

//	ClassRecord/addClassExpenseRecord?expenseOption=YY语音&expenseTime=2018-1-5&
//	expenseClassCount=1&teacherName=ZHANG&teacherOpenID=oO8exv5qxR-KcrpaSezZJsAfrQF4&
//  studentName=MARCH&studentOpenID=oO8exvzE95JUvwpNxNTxraOqzUFI&expenseDistrict=CHONGQING&
//  teacherComment=GOOD&teacherConfirmExpense=true&teacherConfirmTime=1-5&parentConfirmExpense=true&parentConfirmTime=1-5
	
	@RequestMapping("/addClassExpenseRecord")
	public @ResponseBody String AddClassExpenseRecord(HttpServletRequest request, HttpServletResponse response,
			@RequestParam(value = "expenseOption") String expenseOption,
			@RequestParam(value = "expenseTime") String expenseTime,
			@RequestParam(value = "expenseClassCount") String expenseClassCount,
			@RequestParam(value = "teacherName") String teacherName,
			@RequestParam(value = "teacherOpenID") String teacherOpenID,
			@RequestParam(value = "studentName") String studentName,
			@RequestParam(value = "studentOpenID") String studentOpenID,
			@RequestParam(value = "expenseDistrict") String expenseDistrict,
			@RequestParam(value = "teacherComment") String teacherComment,
			@RequestParam(value = "teacherConfirmExpense") boolean teacherConfirmExpense,
			@RequestParam(value = "teacherConfirmTime") String teacherConfirmTime,
			@RequestParam(value = "parentConfirmExpense") boolean parentConfirmExpense,
			@RequestParam(value = "parentConfirmTime") String parentConfirmTime){
		
		Classexpenserecord cer = new Classexpenserecord();
		cer.setExpenseClassCount(expenseClassCount);
		cer.setExpenseDistrict(expenseDistrict);
		cer.setExpenseOption(expenseOption);
		cer.setExpenseTime(expenseTime);
		cer.setParentConfirmExpense(parentConfirmExpense);
		cer.setParentConfirmTime(parentConfirmTime);
		cer.setStudentName(studentName);
		cer.setStudentOpenID(studentOpenID);
		cer.setTeacherComment(teacherComment);
		cer.setTeacherConfirmExpense(teacherConfirmExpense);
		cer.setTeacherConfirmTime(teacherConfirmTime);
		cer.setTeacherName(teacherName);
		cer.setTeacherOpenID(teacherOpenID);
		
		
		if(MongoDBBasic.addClassExpenseRecord(cer)){
			return "succss";
		}
		
		return "failed";
		
		
	}
	
}
