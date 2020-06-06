package com.bms.service;

import com.bms.model.Organ;
import com.bms.query.OrganQuery;

import java.util.List;

public interface OrganService {
    List<Organ> selectOrganList();

    List<Organ> selectOrganListByQuery(OrganQuery organQuery);

    Integer countOrganListByQuery(OrganQuery organQuery);

    Integer addOrgan(Organ organ);

    Integer updateOrgan(Organ organ);

    Integer delOrgan(Integer id);

    Integer checkOrgan(Organ organ);
}
