package com.nkang.kxmoment.controller;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;


@Controller
public class MasterDataController {
	@RequestMapping(value="/getInformation")
	public String getInfo(HttpServletRequest request, HttpServletResponse response){
		request.getSession().setAttribute("totalRecordCount", "Test here");
		return "index";
	}
	
	@RequestMapping(value="/getInformationJS")
	public @ResponseBody String getInfoJS(HttpServletRequest request, HttpServletResponse response, @RequestParam(value = "aa") String aaName){
		System.out.println("am here-----------------------------------" + aaName);
		aaName =  aaName + "is it ok?";
		return aaName;
	}
	
    @RequestMapping("/getBespeakInfo")
    public ModelAndView main() {
        ModelAndView mv = new ModelAndView();
        mv.setViewName("bespeakinfo");
        return mv;
    }
}
