package com.bms.dao;

import com.bms.model.Organ;
import com.bms.query.OrganQuery;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface OrganMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Organ record);

    int insertSelective(Organ record);

    Organ selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Organ record);

    int updateByPrimaryKey(Organ record);

    List<Organ> selectOrganList();

    List<Organ> selectOrganListByQuery(OrganQuery organQuery);

    Integer countOrganListByQuery(OrganQuery organQuery);

    Integer checkOrgan(Organ organ);
}