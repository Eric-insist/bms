package com.bms.controller;

import com.bms.common.ReturnResult;
import com.bms.model.Outsider;
import com.bms.query.OutsiderQuery;
import com.bms.service.OutsiderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 外来人员控制器
 */
@RestController
@RequestMapping("/outsider")
public class OutsiderController {

    @Autowired
    private OutsiderService outsiderService;

    /**
     * 外来人员列表
     * @return
     */
    @RequestMapping("/getOutsiderList")
    public ReturnResult getOutsiderList(OutsiderQuery outsider, Integer page, Integer limit){
        outsider.setPageNo(page);
        outsider.setPageSize(limit);
        Integer count = outsiderService.countAll(outsider);
        List<Outsider> list = outsiderService.findAll(outsider);
        return ReturnResult.SUCCESS("获取成功",list,count);
    }

    /**
     * 新增
     * @param outsider
     * @return
     */
    @PostMapping("/add")
    public ReturnResult add(Outsider outsider){
        outsiderService.add(outsider);
        return ReturnResult.SUCCESS("操作成功");
    }

    /**
     * 删除
     * @param id
     * @return
     */
    @PostMapping("/del")
    public ReturnResult del(Integer id){
        outsiderService.del(id);
        return ReturnResult.SUCCESS("操作成功");
    }
}
