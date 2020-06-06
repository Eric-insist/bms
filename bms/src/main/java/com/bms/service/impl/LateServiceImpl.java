package com.bms.service.impl;

import com.bms.dao.LateMapper;
import com.bms.model.Late;
import com.bms.query.LateQuery;
import com.bms.service.LateService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LateServiceImpl implements LateService {

    @Autowired
    private LateMapper lateMapper;

    @Override
    public List<Late> findAll(LateQuery late) {
        return lateMapper.findAll(late);
    }

    @Override
    public Integer countAll(LateQuery late) {
        return lateMapper.countAll(late);
    }

    @Override
    public void add(Late late) {
        lateMapper.insertSelective(late);
    }
}
