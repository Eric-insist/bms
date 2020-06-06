package com.bms.controller;

import com.bms.common.ReturnResult;
import com.bms.model.Late;
import com.bms.model.LiFan;
import com.bms.query.LateQuery;
import com.bms.query.LiFanQuery;
import com.bms.service.LiFanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 离返校控制器
 */
@RestController
@RequestMapping("/lf")
public class LiFanController {

    @Autowired
    private LiFanService liFanService;

    /**
     * 晚归记录
     * @param liFan
     * @param page
     * @param limit
     * @return
     */
    @RequestMapping("/getLiFanList")
    public ReturnResult getLiFanList(LiFanQuery liFan, Integer page, Integer limit){
        liFan.setPageNo(page);
        liFan.setPageSize(limit);
        Integer count = liFanService.countAll(liFan);
        List<LiFan> list = liFanService.findAll(liFan);
        return ReturnResult.SUCCESS("获取数据成功",list,count);
    }

    /**
     * 新增
     * @param liFan
     * @return
     */
    @PostMapping("/add")
    public ReturnResult add(LiFan liFan){
        liFanService.add(liFan);
        return ReturnResult.SUCCESS("操作成功");
    }
}
