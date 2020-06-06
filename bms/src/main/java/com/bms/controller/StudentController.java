package com.bms.controller;

import com.bms.common.ReturnResult;
import com.bms.model.User;
import com.bms.query.UserQuery;
import com.bms.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/student")
public class StudentController {

    @Autowired
    private UserService userService;

    @GetMapping("/getStudentList")
    public ReturnResult getStudentList(UserQuery user,Integer page,Integer limit){
        user.setPageNo(page);
        user.setPageSize(limit);
        try {
            List<User> list = userService.findStudentAll(user);
            Integer count = userService.countStudentAll(user);
            return ReturnResult.SUCCESS("获取学生列表成功!",list,count);
        }catch (Exception e){
            return ReturnResult.FAILURE("获取学生列表失败!");
        }

    }
}
