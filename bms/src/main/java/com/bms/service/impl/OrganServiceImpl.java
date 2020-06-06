package com.bms.service.impl;

import com.bms.dao.OrganMapper;
import com.bms.model.Organ;
import com.bms.query.OrganQuery;
import com.bms.service.OrganService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Service
public class OrganServiceImpl implements OrganService {

    @Autowired
    private OrganMapper organMapper;

    @Override
    public List<Organ> selectOrganList() {
        return organMapper.selectOrganList();
    }

    @Override
    public List<Organ> selectOrganListByQuery(OrganQuery organQuery) {
        return organMapper.selectOrganListByQuery(organQuery);
    }

    @Override
    public Integer countOrganListByQuery(OrganQuery organQuery) {
        return organMapper.countOrganListByQuery(organQuery);
    }

    @Override
    public Integer addOrgan(Organ organ) {
        Organ parent = organMapper.selectByPrimaryKey(organ.getParentId());
        if (parent != null){
            organ.setPath(parent.getPath()+"."+parent.getId());
            organ.setParentName(parent.getOrganName());
            organ.setLevel((byte) (parent.getLevel()+1));
            organ.setFlag((byte) 1);
            organ.setCreateTime(new Date());
        }
        return organMapper.insert(organ);
    }

    @Override
    public Integer updateOrgan(Organ organ) {
        return null;
    }

    @Override
    public Integer delOrgan(Integer id) {
        Organ organ = new Organ();
        organ.setId(id);
        organ.setFlag((byte) 0);
        return organMapper.updateByPrimaryKeySelective(organ);
    }

    @Override
    public Integer checkOrgan(Organ organ) {
        return organMapper.checkOrgan(organ);
    }
}
