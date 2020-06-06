package com.bms.controller;

import com.bms.common.ReturnResult;
import com.bms.model.Organ;
import com.bms.query.OrganQuery;
import com.bms.service.OrganService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/organ")
public class OrganController {

    @Autowired
    private OrganService organService;

    /**
     * 获取机构树
     * @return
     */
    @RequestMapping("/selectOrganTree")
    public ReturnResult selectOrganTree(){
        List<Organ> organList = organService.selectOrganList();
        List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
        if (organList.size() > 0){
            for (Organ organ : organList){
                Map<String, Object> mapArr = new HashMap<String, Object>();
                if (organ.getParentId() == 0 && organ.getLevel() == 1){
                    mapArr.put("title",organ.getOrganName());
                    mapArr.put("id",organ.getId());
                    mapArr.put("value",organ.getId());
                    List<Map<String, Object>> listMap = menuChild(organ.getId(), organList);
                    mapArr.put("children", listMap);
                    returnList.add(mapArr);
                }
            }
        }
        if (returnList.size() > 0){
            return ReturnResult.SUCCESS("获取机构树成功",returnList);
        }else {
            return ReturnResult.FAILURE("获取机构树失败");
        }
    }

    /**
     * 递归获取孩子节点
     *
     * @param id
     * @param orgList
     * @return
     */
    private List<Map<String, Object>> menuChild(Integer id, List<Organ> orgList) {
        List<Map<String, Object>> lists = new ArrayList<Map<String, Object>>();
        for (Organ org : orgList) {
            Map<String, Object> childArray = new HashMap<String, Object>();
            if (id == org.getParentId()) {
                childArray.put("id", org.getId());
                childArray.put("name", org.getOrganName());
                childArray.put("title", org.getOrganName());
                childArray.put("value", org.getId());
                childArray.put("checked", false);
//                childArray.put("showCheckbox",false);
//                childArray.put("disabled", false);
                List<Map<String, Object>> listMap = menuChild(org.getId(), orgList);
//                childArray.put("list", listMap);
                childArray.put("children", listMap);
                lists.add(childArray);
            }
        }
        return lists;
    }

    /**
     * 获取机构列表
     * @param organQuery
     * @param page
     * @param limit
     * @return
     */
    @RequestMapping("/getOrganList")
    public ReturnResult getOrganList(OrganQuery organQuery, Integer page, Integer limit){
        organQuery.setPageNo(page);
        organQuery.setPageSize(limit);
        List<Organ> list = organService.selectOrganListByQuery(organQuery);
        Integer count = organService.countOrganListByQuery(organQuery);
        return ReturnResult.SUCCESS("获取机构列表成功",list,count);
    }

    /**
     * 添加机构渲染树型组件
     * @return
     */
    @RequestMapping("/selectOrgTreeData")
    public List<Map<String,Object>> selectOrgTreeData(){
        List<Organ> organList = organService.selectOrganList();
        List<Map<String, Object>> returnList = new ArrayList<Map<String, Object>>();
        if (organList.size() > 0){
            for (Organ organ : organList){
                Map<String, Object> mapArr = new HashMap<String, Object>();
                if (organ.getParentId() == 0 && organ.getLevel() == 1){
                    mapArr.put("id", organ.getId());
                    mapArr.put("name", organ.getOrganName());
                    mapArr.put("title", organ.getOrganName());
                    mapArr.put("value", organ.getId());
                    mapArr.put("checked",false);
                    List<Map<String, Object>> listMap = menuChild(organ.getId(), organList);
                    mapArr.put("list",listMap);
                    mapArr.put("children", listMap);
                    returnList.add(mapArr);
                }
            }
        }
        return returnList;
    }

    /**
     * 添加机构
     * @param organ
     * @return
     */
    @RequestMapping("/addOrgan")
    public ReturnResult addOrgan(Organ organ){
        Integer count = organService.checkOrgan(organ);
        if (count > 0){
            return ReturnResult.FAILURE("机构名重复");
        }else {
            Integer flag = organService.addOrgan(organ);
            if (flag != 0){
                return ReturnResult.SUCCESS("添加机构成功");
            }else {
                return ReturnResult.FAILURE("添加机构失败");
            }
        }
    }

    /**
     * 修改机构
     * @param organ
     * @return
     */
    @RequestMapping("/updateOrgan")
    public ReturnResult updateOrgan(Organ organ){
        Integer flag = organService.updateOrgan(organ);
        if (flag != 0){
            return ReturnResult.SUCCESS("修改机构成功");
        }else {
            return ReturnResult.FAILURE("修改机构失败");
        }
    }

    /**
     * 删除机构
     * @param id
     * @return
     */
    @RequestMapping("/delOrgan")
    public ReturnResult delOrgan(@RequestParam("id") Integer id){
        Integer flag = organService.delOrgan(id);
        if (flag != 0){
            return ReturnResult.SUCCESS("删除机构成功");
        }else {
            return ReturnResult.FAILURE("删除机构失败");
        }
    }
}
