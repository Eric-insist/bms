package com.bms.service.impl;

import com.bms.dao.ApplyMapper;
import com.bms.dao.BedRoomMapper;
import com.bms.dao.UserMapper;
import com.bms.model.Apply;
import com.bms.model.BedRoom;
import com.bms.model.User;
import com.bms.query.ApplyQuery;
import com.bms.service.ApplyService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Date;
import java.util.List;

@Service
public class ApplyServiceImpl implements ApplyService {

    @Autowired
    private ApplyMapper applyMapper;

    @Autowired
    private BedRoomMapper bedRoomMapper;

    @Autowired
    private UserMapper userMapper;

    @Override
    public List<Apply> findAll(ApplyQuery apply) {
        return applyMapper.findAll(apply);
    }

    @Override
    public Integer countAll(ApplyQuery apply) {
        return applyMapper.countAll(apply);
    }

    @Override
    public List<Apply> findApplyAll(ApplyQuery apply) {
        return applyMapper.findApplyAll(apply);
    }

    @Override
    public Integer countAppAll(ApplyQuery apply) {
        return applyMapper.countApplyAll(apply);
    }

    @Override
    @Transactional
    public Integer agree(Integer id, Integer type) {
        Apply apply = applyMapper.selectByPrimaryKey(id);
        if (apply.getState() != 1){
            return 0;
        }else {
            //换寝
            if (type == 1){
                apply.setResult("同意");
            }else {//报修
                apply.setResult("处理完成");
            }
            apply.setState(2);
            apply.setSubmitTime(new Date());
            //更新用户的宿舍
            if (type == 1){
                List<Apply> list = applyMapper.selectByOldAndNewRoomNo(apply.getRoomNo(),apply.getNewRoomNo());
                //没有互换寝室的，判断寝室是否满员
                if (list.isEmpty()){
                    BedRoom bedRoom = bedRoomMapper.selectByRoomNo(apply.getNewRoomNo());
                    if (bedRoom != null){
                        //满员
                        if (bedRoom.getRealPerson() == bedRoom.getMaxPerson()){
                            return 2;
                        }else {//不满员
                            User user = new User();
                            user.setId(apply.getUserId());
                            user.setRoomId(bedRoomMapper.selectByRoomNo(apply.getNewRoomNo()).getId());
                            //更新用户
                            userMapper.updateByPrimaryKeySelective(user);
                            //更新申请
                            applyMapper.updateByPrimaryKeySelective(apply);
                            //更新两个寝室的实际入住
                            //新寝室
                            bedRoom.setRealPerson(bedRoom.getRealPerson() + 1);
                            bedRoomMapper.updateByPrimaryKeySelective(bedRoom);
                            //老寝室
                            BedRoom bedRoom1 = bedRoomMapper.selectByRoomNo(apply.getRoomNo());
                            bedRoom1.setRealPerson(bedRoom1.getRealPerson() - 1);
                            bedRoomMapper.updateByPrimaryKeySelective(bedRoom1);
                        }
                    }else {
                        return 3;
                    }
                }else {
                    //存在互换的，同时更新另一个申请，并且互换寝室
                    //互换的apply对象
                    Apply apply1 = list.get(1);
                    User user = new User();
                    //更新第一个
                    user.setId(apply.getUserId());
                    user.setRoomId(bedRoomMapper.selectByRoomNo(apply.getNewRoomNo()).getId());
                    //更新用户
                    userMapper.updateByPrimaryKeySelective(user);
                    //更新申请
                    applyMapper.updateByPrimaryKeySelective(apply);
                    //更新第二个
                    user.setId(apply1.getUserId());
                    user.setRoomId(bedRoomMapper.selectByRoomNo(apply1.getNewRoomNo()).getId());
                    apply1.setState(2);
                    apply1.setResult("同意");
                    apply1.setSubmitTime(new Date());
                    //更新用户
                    userMapper.updateByPrimaryKeySelective(user);
                    //更新申请
                    applyMapper.updateByPrimaryKeySelective(apply);
                }
            }else {
                applyMapper.updateByPrimaryKeySelective(apply);
            }
            return 1;
        }
    }

    @Override
    public Integer refuse(Apply apply) {
        Apply temp = applyMapper.selectByPrimaryKey(apply.getId());
        if (temp.getState() != 1){
            return 0;
        }else {
            temp.setResult(apply.getResult());
            temp.setState(3);
            temp.setSubmitTime(new Date());
            return applyMapper.updateByPrimaryKeySelective(temp);
        }
    }

    @Override
    public void change(Apply apply) {
        apply.setState(1);
        apply.setDescription(apply.getDescription()+"(从"+apply.getRoomNo()+"换到"+apply.getNewRoomNo()+")");
        apply.setApplyTime(new Date());
        apply.setType(1);
        apply.setTowerNo(Integer.parseInt(apply.getRoomNo().substring(0,1)));
        applyMapper.insert(apply);
    }

    @Override
    public void repair(Apply apply) {
        apply.setState(1);
        apply.setDescription(apply.getDescription()+"("+apply.getResult()+")");
        apply.setResult(null);
        apply.setApplyTime(new Date());
        apply.setType(2);
        apply.setTowerNo(Integer.parseInt(apply.getRoomNo().substring(0,1)));
        applyMapper.insert(apply);
    }
}
