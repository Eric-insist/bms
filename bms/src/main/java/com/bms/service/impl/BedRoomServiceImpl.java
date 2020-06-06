package com.bms.service.impl;

import com.bms.dao.BedRoomMapper;
import com.bms.dao.OrganMapper;
import com.bms.dao.UserMapper;
import com.bms.model.BedRoom;
import com.bms.model.User;
import com.bms.query.BedRoomQuery;
import com.bms.service.BedRoomService;
import com.bms.utils.Md5Encrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Service
public class BedRoomServiceImpl implements BedRoomService {

    @Autowired
    private BedRoomMapper bedRoomMapper;
    @Autowired
    private OrganMapper organMapper;
    @Autowired
    private UserMapper userMapper;

    @Override
    public List<BedRoom> findAll(BedRoomQuery bedRoom) {
        return bedRoomMapper.findAll(bedRoom);
    }

    @Override
    public Integer countAll(BedRoomQuery bedRoom) {
        return bedRoomMapper.countAll(bedRoom);
    }

    @Override
    public Integer addBedroom(BedRoom bedRoom) {
        if (bedRoomMapper.selectByRoomNo(bedRoom.getRoomNo()) != null){
            return 0;
        }
        bedRoom.setTowerNo(Integer.parseInt(bedRoom.getRoomNo().substring(0,1)));
        bedRoom.setCreateTime(new Date());
        return bedRoomMapper.insertSelective(bedRoom);
    }

    @Override
    public Integer delBedroom(Integer id) {
        return bedRoomMapper.updateflagById(id);
    }

    @Override
    public Integer updateBedroom(BedRoom bedRoom) {
        if (bedRoomMapper.selectByRoomNo(bedRoom.getRoomNo()) != null){
            return 0;
        }
        bedRoom.setTowerNo(Integer.parseInt(bedRoom.getRoomNo().substring(0,1)));
        bedRoom.setUpdateTime(new Date());
        return bedRoomMapper.updateByPrimaryKeySelective(bedRoom);
    }

    @Override
    public void inBedroom(User user,BedRoom bedRoom) {
        //插入用户
        user.setRoleId(4);
        user.setCreateTime(new Date());
        user.setInDate(new Date());
        user.setPassword(Md5Encrypt.md5("123456"));
        user.setFlag((byte) 1);
        userMapper.insertSelective(user);
        //修改寝室实际用户
        bedRoom.setRealPerson(bedRoom.getRealPerson() + 1);
        bedRoomMapper.updateByPrimaryKeySelective(bedRoom);
    }

    @Override
    public BedRoom selectByRoomNo(String roomNo) {
        return bedRoomMapper.selectByRoomNo(roomNo);
    }

    @Override
    public boolean checkRoomPerson(BedRoom bedRoom) {
        //满员
        if (bedRoom.getRealPerson() == bedRoom.getMaxPerson()){
            return true;
        }
        else {
            return false;
        }
    }

    @Override
    public List<BedRoom> insertByExcelImport(List<BedRoom> list) {
        List<BedRoom> successList = new ArrayList<>();
        List<BedRoom> failList = new ArrayList<>();
        for(BedRoom bedRoom : list){
            if (bedRoomMapper.selectByRoomNo(bedRoom.getRoomNo()) != null){
                bedRoom.setFailure("寝室号已存在");
                failList.add(bedRoom);
                continue;
            }
            bedRoom.setFlag((byte) 1);
            bedRoom.setRealPerson(0);
            bedRoom.setTowerNo(Integer.parseInt(bedRoom.getRoomNo().substring(0,1)));
            successList.add(bedRoom);
        }
        if (successList.size() > 0){
            bedRoomMapper.insertByList(successList);
        }
        return failList;
    }

    @Override
    public void outBedroom(User user) {
        userMapper.updateFlag(user);
    }

    @Override
    public void BatchLeave(List<Integer> idList) {
        userMapper.updateFlagByList(idList);
    }
}
