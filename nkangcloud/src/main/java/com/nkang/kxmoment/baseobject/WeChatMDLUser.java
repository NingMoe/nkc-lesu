package com.nkang.kxmoment.baseobject;

import java.util.ArrayList;
import java.util.HashMap;

public class WeChatMDLUser extends WeChatUser {

	public String realName;
	public String registerDate;
	public String lastUpdatedDate;
	public int workDay;
	public int CongratulateNum;
	public String role;
	public String teacher;
	public String level;
	public String selfIntro;
	public String email;
	public String phone;
	public String point;
	public String IsActive;
	public String isAdmin;
	public String IsAuthenticated;
	public String IsRegistered;
	public String IsSmsTeam;
	public ArrayList tag;
	public HashMap like;
	public String creditPoint;

	public String getCreditPoint() {
		return creditPoint;
	}
	public void setCreditPoint(String creditPoint) {
		this.creditPoint = creditPoint;
	}
	public double distance;

	public String getLevel() {
		return level;
	}
	public void setLevel(String level) {
		this.level = level;
	}
	public String getIsSmsTeam() {
		return IsSmsTeam;
	}
	public void setIsSmsTeam(String isSmsTeam) {
		IsSmsTeam = isSmsTeam;
	}
	public String getIsAdmin() {
		return isAdmin;
	}
	public void setIsAdmin(String isAdmin) {
		this.isAdmin = isAdmin;
	}
	public String getLastUpdatedDate() {
		return lastUpdatedDate;
	}
	public void setLastUpdatedDate(String lastUpdatedDate) {
		this.lastUpdatedDate = lastUpdatedDate;
	}
	public double getDistance() {
		return distance;
	}
	public void setDistance(double distance) {
		this.distance = distance;
	}
	public String getIsActive() {
		return IsActive;
	}
	public void setIsActive(String isActive) {
		IsActive = isActive;
	}
	public String getIsAuthenticated() {
		return IsAuthenticated;
	}
	public void setIsAuthenticated(String isAuthenticated) {
		IsAuthenticated = isAuthenticated;
	}
	public String getIsRegistered() {
		return IsRegistered;
	}
	public void setIsRegistered(String isRegistered) {
		IsRegistered = isRegistered;
	}
	public HashMap getLike() {
		return like;
	}
	public void setLike(HashMap like) {
		this.like = like;
	}
	public int getCongratulateNum() {
		return CongratulateNum;
	}
	public void setCongratulateNum(int congratulateNum) {
		CongratulateNum = congratulateNum;
	}
	public ArrayList getTag() {
		return tag;
	}
	public void setTag(ArrayList list) {
		this.tag = list;
	}
	public String getRealName() {
		return realName;
	}
	public int getWorkDay() {
		return workDay;
	}
	public void setWorkDay(int workDay) {
		this.workDay = workDay;
	}
	public void setRealName(String realName) {
		this.realName = realName;
	}
	public String getRegisterDate() {
		return registerDate;
	}
	public void setRegisterDate(String registerDate) {
		this.registerDate = registerDate;
	}
	public String getRole() {
		return role;
	}
	public void setRole(String role) {
		this.role = role;
	}
	public String getSelfIntro() {
		return selfIntro;
	}
	public void setSelfIntro(String selfIntro) {
		this.selfIntro = selfIntro;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getPhone() {
		return phone;
	}
	public void setPhone(String phone) {
		this.phone = phone;
	}
	public String getPoint() {
		return point;
	}
	public void setPoint(String point) {
		this.point = point;
	}

	public String getTeacher() {
		return teacher;
	}
	public void setTeacher(String teacher) {
		this.teacher = teacher;
	}
	
}
