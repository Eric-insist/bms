package com.bms.service.impl;

import com.bms.dao.LiFanMapper;
import com.bms.model.Late;
import com.bms.model.LiFan;
import com.bms.query.LiFanQuery;
import com.bms.service.LiFanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class LiFanServiceImpl implements LiFanService {

    @Autowired
    private LiFanMapper liFanMapper;

    @Override
    public List<LiFan> findAll(LiFanQuery lifan) {
        return liFanMapper.findAll(lifan);
    }

    @Override
    public Integer countAll(LiFanQuery lifan) {
        return liFanMapper.countAll(lifan);
    }

    @Override
    public void add(LiFan liFan) {
        liFanMapper.insertSelective(liFan);
    }
}
