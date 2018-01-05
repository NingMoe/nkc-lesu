package com.nkang.kxmoment.baseobject.classhourrecord;
/*
 *    学员ID：12345                
                姓名：康智萌
                电话：15123944895
                报名时间：2016.3.3 (onboardingDate)
                报名渠道： 老带新 / 网络 / 广告 ， 其他 (channel)
                校区：红旗河沟校区 （district）
               总课时:75
               已经消费课时:30
               剩余购买课时:22
               剩余赠与课时:3

 */
public class StudentBasicInformation {
	public String openID;
	public String realName;
	public String phone;
	public String enrolledTime;
	public String enrolledWay;
	public String district;
	public int totalClass;
	public int expenseClass;
	public int leftPayClass;
	public int leftSendClass;
	public String getOpenID() {
		return openID;
	}
	public void setOpenID(String openID) {
		this.openID = openID;
	}
	public String getRealName() {
		return realName;
	}
	public void setRealName(String realName) {
		this.realName = realName;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getEnrolledTime() {
		return enrolledTime;
	}
	public void setEnrolledTime(String enrolledTime) {
		this.enrolledTime = enrolledTime;
	}
	public String getEnrolledWay() {
		return enrolledWay;
	}
	public void setEnrolledWay(String enrolledWay) {
		this.enrolledWay = enrolledWay;
	}
	public String getDistrict() {
		return district;
	}
	public void setDistrict(String district) {
		this.district = district;
	}
	public int getTotalClass() {
		return totalClass;
	}
	public void setTotalClass(int totalClass) {
		this.totalClass = totalClass;
	}
	public int getExpenseClass() {
		return expenseClass;
	}
	public void setExpenseClass(int expenseClass) {
		this.expenseClass = expenseClass;
	}
	public int getLeftPayClass() {
		return leftPayClass;
	}
	public void setLeftPayClass(int leftPayClass) {
		this.leftPayClass = leftPayClass;
	}
	public int getLeftSendClass() {
		return leftSendClass;
	}
	public void setLeftSendClass(int leftSendClass) {
		this.leftSendClass = leftSendClass;
	}
	
	
}
