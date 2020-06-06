package com.bms.controller;

import com.bms.common.ReturnResult;
import com.bms.model.User;
import com.bms.query.UserQuery;
import com.bms.service.UserService;
import com.sun.org.apache.bcel.internal.generic.RETURN;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/user")
public class UserController {

    @Autowired
    private UserService userService;

    @GetMapping("/getUserList")
    public ReturnResult getUserList(UserQuery user, @RequestParam("page") Integer page, @RequestParam("limit") Integer limit){
        user.setPageNo(page);
        user.setPageSize(limit);
        List<User> list = userService.findAll(user);
        Integer count = userService.countAll(user);
        return ReturnResult.SUCCESS("成功",list,count);
    }

    /**
     * 检查密码
     * @param id
     * @param password
     * @return
     */
    @PostMapping("/checkPassword")
    public ReturnResult checkPassword(@RequestParam("userId") Integer id,@RequestParam("password") String password){
        Integer count = userService.checkPassword(id,password);
        if (count > 0){
            return ReturnResult.SUCCESS("原密码正确");
        }else {
            return ReturnResult.FAILURE("原密码错误");
        }
    }

    /**
     * 修改密码
     * @param user
     * @return
     */
    @PostMapping("/updatePassword")
    public ReturnResult updatePassword(User user){
        Integer flag = userService.updatePassword(user);
        if (flag > 0){
            return ReturnResult.SUCCESS("修改密码成功");
        }else {
            return ReturnResult.FAILURE("修改密码失败");
        }
    }

    /**
     * 添加用户
     * @param user
     * @return
     */
    @PostMapping("/addUser")
    public ReturnResult addUser(User user){
        String msg = userService.addUser(user);
        if (msg == null){
            return ReturnResult.SUCCESS("添加用户成功");
        }
        return ReturnResult.FAILURE(msg);
    }

    /**
     * 修改用户
     * @param user
     * @return
     */
    @PostMapping("/updateUser")
    public ReturnResult updateUser(User user){
        String msg = userService.updateUser(user);
        if (msg != null){
            return ReturnResult.FAILURE(msg);
        }
        return ReturnResult.SUCCESS("修改成功");
    }
}
