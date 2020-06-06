package com.bms.dao;

import com.bms.model.LiFan;
import com.bms.query.LiFanQuery;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LiFanMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(LiFan record);

    int insertSelective(LiFan record);

    LiFan selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(LiFan record);

    int updateByPrimaryKey(LiFan record);

    List<LiFan> findAll(LiFanQuery liFan);

    Integer countAll(LiFanQuery liFan);
}