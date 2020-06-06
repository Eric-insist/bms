package com.bms.dao;

import com.bms.model.BedRoom;
import com.bms.query.BedRoomQuery;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface BedRoomMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(BedRoom record);

    int insertSelective(BedRoom record);

    BedRoom selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(BedRoom record);

    int updateByPrimaryKey(BedRoom record);

    List<BedRoom> findAll(BedRoomQuery bedRoom);

    Integer countAll(BedRoomQuery bedRoom);

    Integer updateflagById(Integer id);

    BedRoom selectByRoomNo(@Param("roomNo") String roomNo);

    void insertByList(List<BedRoom> list);
}