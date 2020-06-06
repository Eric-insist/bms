package com.bms.controller;

import com.bms.common.ReturnResult;
import com.bms.model.Late;
import com.bms.query.LateQuery;
import com.bms.service.LateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 晚归控制器
 */
@RestController
@RequestMapping("/late")
public class LateController {

    @Autowired
    private LateService lateService;

    /**
     * 晚归记录
     * @param late
     * @param page
     * @param limit
     * @return
     */
    @RequestMapping("/getLateList")
    public ReturnResult getLateList(LateQuery late,Integer page,Integer limit){
        late.setPageNo(page);
        late.setPageSize(limit);
        Integer count = lateService.countAll(late);
        List<Late> list = lateService.findAll(late);
        return ReturnResult.SUCCESS("获取数据成功",list,count);
    }

    /**
     * 新增
     * @param late
     * @return
     */
    @PostMapping("/add")
    public ReturnResult add(Late late){
        lateService.add(late);
        return ReturnResult.SUCCESS("操作成功");
    }
}
