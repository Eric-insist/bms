package com.bms.service;

import com.bms.model.User;
import com.bms.query.UserQuery;

import java.util.List;
import java.util.Map;

public interface UserService {

    User findByCount(String count);

    Map<Object,Object> login(String account, String pwd);

    List<User> findAll(UserQuery user);

    Integer countAll(UserQuery user);

    Integer countStudentAll(UserQuery user);

    List<User> findStudentAll(UserQuery user);

    Integer checkPassword(Integer id, String password);

    Integer updatePassword(User user);

    String addUser(User user);

    List<User> insertByExcelImport(List<User> list);

    String updateUser(User user);
}
