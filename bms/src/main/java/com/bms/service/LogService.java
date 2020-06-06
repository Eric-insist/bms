package com.bms.service;

import com.bms.model.Log;
import com.bms.query.LogQuery;

import java.util.List;

public interface LogService {

    List<Log> findAll(LogQuery log);

    Integer countAll(LogQuery log);

    void add(Log log);
}
