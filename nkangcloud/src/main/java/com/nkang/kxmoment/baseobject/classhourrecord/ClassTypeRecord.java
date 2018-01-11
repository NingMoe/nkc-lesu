package com.nkang.kxmoment.baseobject.classhourrecord;
/*
 * 	  具体课程
               总课时:75
               已经消费课时:30
               剩余购买课时:22
               剩余赠与课时:3

 */
public class ClassTypeRecord {
	public String StudentOpenID;
	public String payOption;
	public int totalClass;
	public int expenseClass;
	public int leftPayClass;
	public int leftSendClass;
	
	
	
	public String getStudentOpenID() {
		return StudentOpenID;
	}
	public void setStudentOpenID(String studentOpenID) {
		StudentOpenID = studentOpenID;
	}
	public String getPayOption() {
		return payOption;
	}
	public void setPayOption(String payOption) {
		this.payOption = payOption;
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
