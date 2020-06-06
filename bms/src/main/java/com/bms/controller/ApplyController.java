package com.bms.controller;

import com.bms.common.ReturnResult;
import com.bms.model.Apply;
import com.bms.query.ApplyQuery;
import com.bms.service.ApplyService;
import com.sun.org.apache.bcel.internal.generic.RETURN;
import jdk.nashorn.internal.ir.ReturnNode;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * 各种申请控制器
 */
@RestController
@RequestMapping("/apply")
public class ApplyController {

    @Autowired
    private ApplyService applyService;

    /**
     * 学生申请记录列表
     * @return
     */
    @RequestMapping("/getStudentApplyList")
    public ReturnResult getStudentApplyList(ApplyQuery apply,Integer page,Integer limit){
        apply.setPageNo(page);
        apply.setPageSize(limit);
        List<Apply> list = applyService.findAll(apply);
        Integer count = applyService.countAll(apply);
        return ReturnResult.SUCCESS("获取成功",list,count);
    }

    /**
     * 换寝审核
     * @param apply
     * @param page
     * @param limit
     * @return
     */
    @RequestMapping("/getApplyList")
    public ReturnResult getApplyList(ApplyQuery apply,Integer page,Integer limit){
        apply.setPageNo(page);
        apply.setPageSize(limit);
        List<Apply> list = applyService.findApplyAll(apply);
        Integer count = applyService.countAppAll(apply);
        return ReturnResult.SUCCESS("获取成功",list,count);
    }

    /**
     * 同意换寝/已处理
     * @param id
     * @return
     */
    @PostMapping("/agree")
    public ReturnResult agree(Integer id,Integer type){
        Integer flag = applyService.agree(id,type);
        if ( flag== 0){
            return ReturnResult.FAILURE("该申请已处理,请刷新页面");
        }else if (flag == 1){
            return ReturnResult.SUCCESS("操作成功");
        }else if (flag == 2){
            return ReturnResult.FAILURE("目标寝室满员");
        }else if(flag == 3){
            return ReturnResult.FAILURE("目标寝室不存在");
        }else {
            return ReturnResult.FAILURE("操作失败");
        }

    }

    /**
     * 拒绝
     * @param apply
     * @return
     */
    @PostMapping("/refuse")
    public ReturnResult agree(Apply apply){
        Integer flag = applyService.refuse(apply);
        if ( flag == 0){
            return ReturnResult.FAILURE("该申请已处理,请刷新页面");
        }else if (flag == 1){
            return ReturnResult.SUCCESS("操作成功");
        }else {
            return ReturnResult.FAILURE("操作失败");
        }
    }

    /**
     * 换寝
     * @param apply
     * @return
     */
    @PostMapping("/change")
    public ReturnResult change(Apply apply){
        applyService.change(apply);
        return ReturnResult.SUCCESS("操作成功");
    }

    /**
     * 报修
     * @param apply
     * @return
     */
    @PostMapping("/repair")
    public ReturnResult repair(Apply apply){
        applyService.repair(apply);
        return ReturnResult.SUCCESS("操作成功");
    }
}
