package com.bms.service;

import com.bms.model.Late;
import com.bms.model.LiFan;
import com.bms.query.LiFanQuery;

import java.util.List;

public interface LiFanService {
    List<LiFan> findAll(LiFanQuery liFan);

    Integer countAll(LiFanQuery liFan);

    void add(LiFan liFan);
}
