package com.bms.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class TestController {

    @RequestMapping("/test")
    public String Test(){
        return "test";
    }

}
