package com.bms.service;

import com.bms.model.Late;
import com.bms.query.LateQuery;

import java.util.List;

public interface LateService {
    List<Late> findAll(LateQuery late);

    Integer countAll(LateQuery late);

    void add(Late late);
}
