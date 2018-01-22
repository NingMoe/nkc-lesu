package com.nkang.kxmoment.baseobject.classhourrecord;
/*
 * 				1-》 缴费项目:【珠心算| YY拼音 | 趣味数学】
                1-》 缴费金额:2160元
                1-》 获得课时数:24次
                1-》 购买时间:2017.5.11
                1-》 学员姓名：康智萌
                1-》 学员ID：12345      
				-》 phone
				->g购买着的openid

 */
public class Classpayrecord {
	public String payOption;
	public int payMoney;
	public int classCount;
	public String payTime;
	public String studentName;
	public String studentOpenID;
	public String phone;
	public String operatorOpenID;
	public String payID;
	public int giftClass;
	
	public int getGiftClass() {
		return giftClass;
	}
	public void setGiftClass(int giftClass) {
		this.giftClass = giftClass;
	}
	public String getPayID() {
		return payID;
	}
	public void setPayID(String payID) {
		this.payID = payID;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getOperatorOpenID() {
		return operatorOpenID;
	}
	public void setOperatorOpenID(String operatorOpenID) {
		this.operatorOpenID = operatorOpenID;
	}
	public String getPayOption() {
		return payOption;
	}
	public void setPayOption(String payOption) {
		this.payOption = payOption;
	}
	public int getPayMoney() {
		return payMoney;
	}
	public void setPayMoney(int payMoney) {
		this.payMoney = payMoney;
	}
	public int getClassCount() {
		return classCount;
	}
	public void setClassCount(int classCount) {
		this.classCount = classCount;
	}
	public String getPayTime() {
		return payTime;
	}
	public void setPayTime(String payTime) {
		this.payTime = payTime;
	}
	public String getStudentName() {
		return studentName;
	}
	public void setStudentName(String studentName) {
		this.studentName = studentName;
	}
	public String getStudentOpenID() {
		return studentOpenID;
	}
	public void setStudentOpenID(String studentOpenID) {
		this.studentOpenID = studentOpenID;
	}
	
	
	
}
