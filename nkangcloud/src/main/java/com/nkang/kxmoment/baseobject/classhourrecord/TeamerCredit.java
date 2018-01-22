package com.nkang.kxmoment.baseobject.classhourrecord;

public class TeamerCredit {
	/*
Table Name： HistryTeamerCredit
数据模型设计
对象名字： TeamerCredit
-> DateTime
-> Name
->amount
-> StudentOpenID
-> Operation (Increase | Decrease)
-> Operator (老师的open ID 或者姓名)
-> ChangeJustification （用以记录积分变化的缘由） 
	 */

	String DateTime;
	String Name;
	String StudentOpenID;
	String Operation;
	String Operator;
	String Amount;
	String ChangeJustification;
	
	public String getAmount() {
		return Amount;
	}
	public void setAmount(String amount) {
		Amount = amount;
	}
	public String getDateTime() {
		return DateTime;
	}
	public void setDateTime(String dateTime) {
		DateTime = dateTime;
	}
	public String getName() {
		return Name;
	}
	public void setName(String name) {
		Name = name;
	}
	public String getStudentOpenID() {
		return StudentOpenID;
	}
	public void setStudentOpenID(String studentOpenID) {
		StudentOpenID = studentOpenID;
	}
	public String getOperation() {
		return Operation;
	}
	public void setOperation(String operation) {
		Operation = operation;
	}
	public String getOperator() {
		return Operator;
	}
	public void setOperator(String operator) {
		Operator = operator;
	}
	public String getChangeJustification() {
		return ChangeJustification;
	}
	public void setChangeJustification(String changeJustification) {
		ChangeJustification = changeJustification;
	}
	
}
