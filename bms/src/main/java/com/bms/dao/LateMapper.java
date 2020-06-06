package com.bms.dao;

import com.bms.model.Late;
import com.bms.query.LateQuery;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface LateMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Late record);

    int insertSelective(Late record);

    Late selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Late record);

    int updateByPrimaryKey(Late record);

    List<Late> findAll(LateQuery late);

    Integer countAll(LateQuery late);
}