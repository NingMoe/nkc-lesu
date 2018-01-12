package com.nkang.kxmoment.baseobject;

import java.util.ArrayList;
import java.util.List;

public class AppointmentList {
	private int pageNum;
	private int totalNum;
	private int totalPage;
	private List<Appointment> appointmentList;
	public int getPageNum() {
		return pageNum;
	}
	public void setPageNum(int pageNum) {
		this.pageNum = pageNum;
	}
	public int getTotalPage() {
		return totalPage;
	}
	public void setTotalPage(int totalPage) {
		this.totalPage = totalPage;
	}
	public int getTotalNum() {
		return totalNum;
	}
	public void setTotalNum(int totalNum) {
		this.totalNum = totalNum;
	}
	public List<Appointment> getAppointmentList() {
		if(appointmentList==null){
			appointmentList = new ArrayList<Appointment>();
		}
		return appointmentList;
	}
	public void setAppointmentList(List<Appointment> appointmentList) {
		this.appointmentList = appointmentList;
	}
	
	
}
