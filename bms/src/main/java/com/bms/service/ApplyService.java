package com.bms.service;

import com.bms.model.Apply;
import com.bms.query.ApplyQuery;

import java.util.List;

public interface ApplyService {
    List<Apply> findAll(ApplyQuery apply);

    Integer countAll(ApplyQuery apply);

    List<Apply> findApplyAll(ApplyQuery apply);

    Integer countAppAll(ApplyQuery apply);

    Integer agree(Integer id, Integer type);

    Integer refuse(Apply apply);

    void change(Apply apply);

    void repair(Apply apply);
}
