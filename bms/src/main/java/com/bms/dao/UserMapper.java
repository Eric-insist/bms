package com.bms.dao;

import com.bms.model.User;
import com.bms.query.UserQuery;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface UserMapper {
    int deleteByPrimaryKey(Integer id);

    int insert(User record);

    int insertSelective(User record);

    User selectByPrimaryKey(Integer id);

    int updateByPrimaryKeySelective(User record);

    int updateByPrimaryKey(User record);

    User findByCount(String count);

    List<User> findAll(UserQuery user);

    Integer countAll(UserQuery user);

    List<User> findStudentAll(UserQuery user);

    Integer countStudentAll(UserQuery user);

    Integer selectByPassword(@Param("id") Integer id, @Param("password") String password);

    Integer updatePassword(User user);

    void updateFlag(User user);

    void updateFlagByList(@Param("list") List<Integer> idList);

    List<User> selectAll();
}