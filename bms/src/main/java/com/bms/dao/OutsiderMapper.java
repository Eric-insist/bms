package com.bms.dao;

import com.bms.model.Outsider;
import com.bms.query.OutsiderQuery;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface OutsiderMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Outsider record);

    int insertSelective(Outsider record);

    Outsider selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Outsider record);

    int updateByPrimaryKey(Outsider record);

    List<Outsider> findAll(OutsiderQuery outsider);

    Integer countAll(OutsiderQuery outsider);
}