package com.bms.controller;

import com.bms.common.ReturnResult;
import com.bms.model.BedRoom;
import com.bms.model.Log;
import com.bms.model.User;
import com.bms.query.BedRoomQuery;
import com.bms.service.BedRoomService;
import com.bms.service.LogService;
import com.bms.service.UserService;
import org.apache.jasper.tagplugins.jstl.core.If;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/bedroom")
public class BedRoomController {

    @Autowired
    private BedRoomService bedRoomService;
    @Autowired
    private UserService userService;

    @Autowired
    private LogService logService;

    /**
     * 寝室列表
     * @param bedRoom
     * @param page
     * @param limit
     * @return
     */
    @RequestMapping("/getBedRoomList")
    public ReturnResult getBedRoomList(BedRoomQuery bedRoom,Integer page,Integer limit){
        //日志
        if (bedRoom.getRoomNo() != null || bedRoom.getTowerNo() != null){
            Log log = new Log();
            log.setType((byte) 4);
            log.setDescription("查看了宿舍列表,"+(bedRoom.getRoomNo() != null ? "寝室号:"+bedRoom.getRoomNo() : "")+(bedRoom.getTowerNo() != null ? "栋数"+bedRoom.getTowerNo(): ""));
            logService.add(log);
        }
        bedRoom.setPageNo(page);
        bedRoom.setPageSize(limit);
        List<BedRoom> list = bedRoomService.findAll(bedRoom);
        Integer count = bedRoomService.countAll(bedRoom);
        return ReturnResult.SUCCESS("成功",list,count);
    }

    /**
     * 添加寝室
     * @param bedRoom
     * @return
     */
    @PostMapping("/addBedroom")
    public ReturnResult addBedroom(BedRoom bedRoom){
        Integer flag = bedRoomService.addBedroom(bedRoom);
        if (flag > 0 ){
            return ReturnResult.SUCCESS("添加宿舍成功");
        }else {
            return ReturnResult.FAILURE("宿舍已存在");
        }
    }

    /**
     * 修改寝室
     * @param bedRoom
     * @return
     */
    @PostMapping("/updateBedroom")
    public ReturnResult updateBedroom(BedRoom bedRoom){
        Integer flag = bedRoomService.updateBedroom(bedRoom);
        if (flag > 0 ){
            return ReturnResult.SUCCESS("修改宿舍成功");
        }else {
            return ReturnResult.FAILURE("宿舍已存在");
        }
    }

    /**
     * 删除寝室
     * @param id
     * @return
     */
    @PostMapping("/delBedroom")
    public ReturnResult delBedroom(@RequestParam("id") Integer id){
        Integer flag = bedRoomService.delBedroom(id);
        if (flag > 0 ){
            return ReturnResult.SUCCESS("删除宿舍成功");
        }else {
            return ReturnResult.FAILURE("删除宿舍失败");
        }
    }

    /**
     * 入住办理
     * @param user
     * @return
     */
    @PostMapping("/inBedroom")
    public ReturnResult inBedroom(User user){
        User user1 = userService.findByCount(user.getAccount());
        BedRoom bedRoom = bedRoomService.selectByRoomNo(user.getRoomNo());
        if (bedRoom == null) return ReturnResult.FAILURE("寝室不存在");
        else {
            if (bedRoomService.checkRoomPerson(bedRoom)){
                return ReturnResult.FAILURE("寝室已满,请重新分配寝室");
            }else {
                user.setRoomId(bedRoom.getId());
                if (user1 != null){
                    return ReturnResult.FAILURE("学号重复");
                }else {
                    bedRoomService.inBedroom(user,bedRoom);
                    return ReturnResult.SUCCESS("入住办理成功");
                }
            }
        }
    }

    /**
     * 迁出
     * @param user
     * @return
     */
    @PostMapping("/outBedroom")
    public ReturnResult outBedroom(User user){
        bedRoomService.outBedroom(user);
        return ReturnResult.SUCCESS("迁出办理成功");
    }

    /**
     * 批量迁出
     * @param idList
     * @return
     */
    @PostMapping("/BatchLeave")
    public ReturnResult BatchLeave(@RequestBody List<Integer> idList){
        bedRoomService.BatchLeave(idList);
        return ReturnResult.SUCCESS("迁出办理成功");
    }
}
