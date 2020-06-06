package com.bms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import javax.jws.WebParam;


@Controller
public class PageController {

    @RequestMapping("/login")
    public String login(){
        return "login";
    }

    @RequestMapping("/index")
    public String index(){
        return "index";
    }

    @RequestMapping("/gotoUserList")
    public ModelAndView gotoUserList(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("system/userList");
        mv.addObject("navigate",navigate);
        return mv;
    }

    @RequestMapping("/gotoBedroomList")
    public ModelAndView gotoBedroomList(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("bedroom/bedRoomList");
        mv.addObject("navigate",navigate);
        return mv;
    }

    @RequestMapping("/gotoStudentList")
    public ModelAndView gotoStudentList(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("student/studentList");
        mv.addObject("navigate",navigate);
        return mv;
    }

    @RequestMapping("/gotoOrganList")
    public ModelAndView gotoOrganList(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("system/organList");
        mv.addObject("navigate",navigate);
        return mv;
    }

    @RequestMapping("/inBedroom")
    public ModelAndView inBedroom(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("bedroom/inBedroom");
        mv.addObject("navigate",navigate);
        return mv;
    }

    @RequestMapping("/outBedroom")
    public ModelAndView outBedroom(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("bedroom/outBedroom");
        mv.addObject("navigate",navigate);
        return mv;
    }

    /**
     * 日志页面
     * @param navigate
     * @return
     */
    @RequestMapping("/gotoLogList")
    public ModelAndView gotoLogList(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("system/logList");
        mv.addObject("navigate",navigate);
        return mv;
    }

    /**
     * 个人信息页面
     * @param navigate
     * @return
     */
    @RequestMapping("/gotoPersonnel")
    public ModelAndView gotoPersonnel(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("student/personnel");
        mv.addObject("navigate",navigate);
        return mv;
    }

    /**
     * 申请记录
     * @param navigate
     * @return
     */
    @RequestMapping("/gotoStudentApply")
    public ModelAndView gotoStudentApply(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("student/studentApply");
        mv.addObject("navigate",navigate);
        return mv;
    }

    /**
     * 换寝审批
     * @param navigate
     * @return
     */
    @RequestMapping("/gotoApplyList")
    public ModelAndView gotoApplyList(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("student/applyList");
        mv.addObject("navigate",navigate);
        return mv;
    }

    /**
     * 离返录入
     * @param navigate
     * @return
     */
    @RequestMapping("/gotolf")
    public ModelAndView gotolf(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("student/lf");
        mv.addObject("navigate",navigate);
        return mv;
    }

    /**
     * 晚归录入
     * @param navigate
     * @return
     */
    @RequestMapping("/gotoLate")
    public ModelAndView gotoLate(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("student/late");
        mv.addObject("navigate",navigate);
        return mv;
    }

    /**
     * 外来人员
     * @param navigate
     * @return
     */
    @RequestMapping("/gotoOutsidersList")
    public ModelAndView gotoOutsidersList(@RequestParam(value = "navigate",required = false) String navigate){
        ModelAndView mv = new ModelAndView("bedroom/outsider");
        mv.addObject("navigate",navigate);
        return mv;
    }

}
