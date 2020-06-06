package com.bms.controller;

import com.bms.common.ReturnResult;
import com.bms.model.Log;
import com.bms.query.LogQuery;
import com.bms.service.LogService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/log")
public class LogController {

    @Autowired
    private LogService logService;

    /**
     * 获取日志列表
     * @param log
     * @param page
     * @param limit
     * @return
     */
    @RequestMapping("/getLogList")
    public ReturnResult getLogList(LogQuery log,Integer page,Integer limit){
        log.setPageNo(page);
        log.setPageSize(limit);
        List<Log> list = logService.findAll(log);
        Integer count = logService.countAll(log);
        return ReturnResult.SUCCESS("获取日志列表成功",list,count);
    }

    /**
     * 新增(userId,type,organId,description)
     * @param log
     * @return
     */
    @PostMapping("/add")
    public ReturnResult add(Log log){
        logService.add(log);
        return ReturnResult.SUCCESS("成功");
    }
}
