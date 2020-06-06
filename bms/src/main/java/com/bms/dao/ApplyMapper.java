package com.bms.dao;

import com.bms.model.Apply;
import com.bms.query.ApplyQuery;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface ApplyMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(Apply record);

    int insertSelective(Apply record);

    Apply selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(Apply record);

    int updateByPrimaryKey(Apply record);

    List<Apply> findAll(ApplyQuery apply);

    Integer countAll(ApplyQuery apply);

    List<Apply> findApplyAll(ApplyQuery apply);

    Integer countApplyAll(ApplyQuery apply);

    List<Apply> selectByOldAndNewRoomNo(@Param("old") String roomNo, @Param("new") String newRoomNo);
}