package com.bms.service.impl;

import com.bms.dao.LogMapper;
import com.bms.model.Log;
import com.bms.model.Organ;
import com.bms.model.User;
import com.bms.query.LogQuery;
import com.bms.service.LogService;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

@Service
public class LogServiceImpl implements LogService {

    @Autowired
    private LogMapper logMapper;

    @Override
    public List<Log> findAll(LogQuery log) {
        return logMapper.findAll(log);
    }

    @Override
    public Integer countAll(LogQuery log) {
        return logMapper.countAll(log);
    }

    @Override
    public void add(Log log) {
        User user = (User) SecurityUtils.getSubject().getSession().getAttribute("user");
        Organ organ = (Organ) SecurityUtils.getSubject().getSession().getAttribute("organ");
        log.setUserId(user.getId());
        log.setOrganId(organ.getId());
        log.setTime(new Date());
        logMapper.insertSelective(log);
    }
}
