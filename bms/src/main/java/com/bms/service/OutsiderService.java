package com.bms.service;

import com.bms.model.Outsider;
import com.bms.query.OutsiderQuery;

import java.util.List;

public interface OutsiderService {
    List<Outsider> findAll(OutsiderQuery outsider);

    Integer countAll(OutsiderQuery outsider);

    void add(Outsider outsider);

    void del(Integer id);
}
