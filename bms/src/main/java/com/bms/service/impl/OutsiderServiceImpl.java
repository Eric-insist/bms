package com.bms.service.impl;

import com.bms.dao.OutsiderMapper;
import com.bms.model.Outsider;
import com.bms.query.OutsiderQuery;
import com.bms.service.OutsiderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class OutsiderServiceImpl implements OutsiderService {

    @Autowired
    private OutsiderMapper outsiderMapper;

    @Override
    public List<Outsider> findAll(OutsiderQuery outsider) {
        return outsiderMapper.findAll(outsider);
    }

    @Override
    public Integer countAll(OutsiderQuery outsider) {
        return outsiderMapper.countAll(outsider);
    }

    @Override
    public void add(Outsider outsider) {
        outsiderMapper.insertSelective(outsider);
    }

    @Override
    public void del(Integer id) {
        outsiderMapper.deleteByPrimaryKey(id);
    }
}
