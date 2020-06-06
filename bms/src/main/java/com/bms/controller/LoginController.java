package com.bms.controller;

import com.bms.common.ReturnResult;
import com.bms.model.Log;
import com.bms.model.User;
import com.bms.service.LogService;
import com.bms.service.UserService;
import com.sun.org.apache.bcel.internal.generic.RETURN;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@RestController
@RequestMapping("/login")
public class LoginController {

    @Autowired
    private UserService userService;
    @Autowired
    private LogService logService;

    /**
     * 登陆
     * @param account
     * @param pwd
     * @return
     */
    @RequestMapping("/login")
    public ReturnResult login(String account,String pwd){
        Map<Object,Object> map = userService.login(account,pwd);
        if (map.get("msg") == null){
            Log log = new Log();
            log.setType((byte) 4);
            log.setDescription("登陆了系统");
            logService.add(log);
            return ReturnResult.SUCCESS("成功",map);
        }else {
            return ReturnResult.FAILURE("失败",map);
        }
    }

}
