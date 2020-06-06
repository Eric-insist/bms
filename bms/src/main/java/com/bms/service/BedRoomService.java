package com.bms.service;

import com.bms.model.BedRoom;
import com.bms.model.User;
import com.bms.query.BedRoomQuery;

import java.util.List;

public interface BedRoomService {
    List<BedRoom> findAll(BedRoomQuery bedRoom);

    Integer countAll(BedRoomQuery bedRoom);

    Integer addBedroom(BedRoom bedRoom);

    Integer delBedroom(Integer id);

    Integer updateBedroom(BedRoom bedRoom);

    void inBedroom(User user,BedRoom bedRoom);

    BedRoom selectByRoomNo(String roomNo);

    /**
     * 检查寝室人员是否满员
     * @param bedRoom
     * @return
     */
    boolean checkRoomPerson(BedRoom bedRoom );

    /**
     * 导入
     * @param list
     * @return
     */
    List<BedRoom> insertByExcelImport(List<BedRoom> list);

    void outBedroom(User user);

    void BatchLeave(List<Integer> idList);
}
