package com.nkang.kxmoment.baseobject.classhourrecord;
/*              1-》 消费项目：【珠心算| YY拼音 | 趣味数学】
                1-》 消费时间： 2017.12.23 星期三 下午3点-4点半
                1-》 消费课时： 1
                1-》       任课老师： 苹果老师
                	家长反馈
                老师id
                1-》 学员姓名： 康智萌
                1-》 学员ID：12345
                1-》       课销校区： 观音桥校区
                1-》 老师评语： 今天小朋友刚刚学会6的乘法口诀。请家长鼓励帮助孩子练习。并且多加练习1-100的加减百子
                1-》 老师是否确认消课： 苹果老师【是】
                1-》 家长确认课销时间： 2017.12.23 星期三 4:30PM
                1-》 家长是否确认消课： 康爸爸【是】
                1-》 家长确认课销时间： 2017.12.23 星期三 9:30PM
*/
public class Classexpenserecord {
	public String expenseOption;
	public String expenseTime;
	public String expenseClassCount;
	public String teacherName;
	public String teacherOpenID;
	public String studentName;
	public String studentOpenID;
	public String expenseDistrict;
	public String teacherComment;
	public boolean teacherConfirmExpense;
	public String teacherConfirmTime;
	public boolean parentConfirmExpense;
	public String parentConfirmTime;
	public String parentComment;
	
	public String getParentComment() {
		return parentComment;
	}
	public void setParentComment(String parentComment) {
		this.parentComment = parentComment;
	}
	public String getExpenseOption() {
		return expenseOption;
	}
	public void setExpenseOption(String expenseOption) {
		this.expenseOption = expenseOption;
	}
	public String getExpenseTime() {
		return expenseTime;
	}
	public void setExpenseTime(String expenseTime) {
		this.expenseTime = expenseTime;
	}
	public String getExpenseClassCount() {
		return expenseClassCount;
	}
	public void setExpenseClassCount(String expenseClassCount) {
		this.expenseClassCount = expenseClassCount;
	}
	public String getTeacherName() {
		return teacherName;
	}
	public void setTeacherName(String teacherName) {
		this.teacherName = teacherName;
	}
	public String getTeacherOpenID() {
		return teacherOpenID;
	}
	public void setTeacherOpenID(String teacherOpenID) {
		this.teacherOpenID = teacherOpenID;
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
	public String getExpenseDistrict() {
		return expenseDistrict;
	}
	public void setExpenseDistrict(String expenseDistrict) {
		this.expenseDistrict = expenseDistrict;
	}
	public String getTeacherComment() {
		return teacherComment;
	}
	public void setTeacherComment(String teacherComment) {
		this.teacherComment = teacherComment;
	}
	public boolean isTeacherConfirmExpense() {
		return teacherConfirmExpense;
	}
	public void setTeacherConfirmExpense(boolean teacherConfirmExpense) {
		this.teacherConfirmExpense = teacherConfirmExpense;
	}
	public String getTeacherConfirmTime() {
		return teacherConfirmTime;
	}
	public void setTeacherConfirmTime(String teacherConfirmTime) {
		this.teacherConfirmTime = teacherConfirmTime;
	}
	public boolean isParentConfirmExpense() {
		return parentConfirmExpense;
	}
	public void setParentConfirmExpense(boolean parentConfirmExpense) {
		this.parentConfirmExpense = parentConfirmExpense;
	}
	public String getParentConfirmTime() {
		return parentConfirmTime;
	}
	public void setParentConfirmTime(String parentConfirmTime) {
		this.parentConfirmTime = parentConfirmTime;
	}
	
	
}
