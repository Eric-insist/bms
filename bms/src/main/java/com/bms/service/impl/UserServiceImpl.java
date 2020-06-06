package com.bms.service.impl;

import com.bms.dao.BedRoomMapper;
import com.bms.dao.OrganMapper;
import com.bms.dao.UserMapper;
import com.bms.model.BedRoom;
import com.bms.model.User;
import com.bms.query.UserQuery;
import com.bms.service.UserService;
import com.bms.system.exception.MyException;
import com.bms.utils.IdCardUtil;
import com.bms.utils.IdcardValidator;
import com.bms.utils.Md5Encrypt;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.subject.Subject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.util.*;

@Service
public class UserServiceImpl implements UserService {

    private Logger log = LoggerFactory.getLogger(UserService.class);

    @Autowired
    private UserMapper userMapper;
    @Autowired
    private OrganMapper organMapper;
    @Autowired
    private BedRoomMapper bedRoomMapper;
    @Override
    public User findByCount(String count) {
        return userMapper.findByCount(count);
    }

    @Override
    public Map<Object,Object> login(String account, String pwd) {
        String msg = "登录失败";
        //获取subject
        Subject subject = SecurityUtils.getSubject();
        //创建token
        UsernamePasswordToken token = new UsernamePasswordToken(account, Md5Encrypt.md5(pwd));
        //登陆
        try {
            subject.login(token);
            log.info("对用户[" + account + "]进行登录验证..验证通过");

        } catch (LockedAccountException le) {
            log.info("对用户[" + account + "]进行登录验证..验证未通过,账户未激活");
            msg = le.getMessage();

        } catch (UnknownAccountException uae) {
            log.info("对用户[" + account + "]进行登录验证..验证未通过,未知账户（用户不存在）");
            msg = "用户不存在";
        } catch (IncorrectCredentialsException ice) {
            log.info("对用户[" + account + "]进行登录验证..验证未通过,错误的凭证（密码不正确）");
            msg = "密码不正确";
        } catch (AuthenticationException ae) {
            log.info("对用户[" + account + "]进行登录验证..验证未通过,堆栈轨迹如下");
            throw new MyException(ae.getMessage());
        }
        //验证账号密码
        boolean state = subject.isAuthenticated();
        Map<Object,Object> map = new HashMap<>();
        if (state){
            //验证成功
            User user = userMapper.findByCount(account);
            if (user != null){
                subject.getSession().setAttribute("user",user);
                if (user.getOrganId() != null){
                    subject.getSession().setAttribute("organ",organMapper.selectByPrimaryKey(user.getOrganId()));
                }
                if (user.getRoomId() != null){
                    subject.getSession().setAttribute("room",bedRoomMapper.selectByPrimaryKey(user.getRoomId()));
                }
                //学生
                if (user.getRoleId() == 4){
                    map.put("gotoUrl","gotoPersonnel?navigate=22");
                }
                //管理员和宿管员
                else if (user.getRoleId() == 1 || user.getRoleId() == 2){
                    map.put("gotoUrl","gotoBedroomList?navigate=1");
                }
                //维修人员
                else {
                    map.put("gotoUrl","gotoRepairList?navigate=31");
                }
            }
        }else {
            map.put("msg",msg);
        }
        return map;
    }

    @Override
    public List<User> findAll(UserQuery user) {
        return userMapper.findAll(user);
    }

    @Override
    public Integer countAll(UserQuery user) {
        return userMapper.countAll(user);
    }

    @Override
    public Integer countStudentAll(UserQuery user) {
        return userMapper.countStudentAll(user);
    }

    @Override
    public List<User> findStudentAll(UserQuery user) {
        return userMapper.findStudentAll(user);
    }

    @Override
    public Integer checkPassword(Integer id, String password) {
        return userMapper.selectByPassword(id,Md5Encrypt.md5(password));
    }

    @Override
    public Integer updatePassword(User user) {
        user.setPassword(Md5Encrypt.md5(user.getPassword()));
        return userMapper.updatePassword(user);
    }

    @Override
    public String addUser(User user) {
        String msg = handleUser(user);
        if (msg != null){
            return msg;
        }
        if (user.getRoleId() == 2){
            user.setTowerNo(Integer.parseInt(user.getAccount().substring(0,1)));
        }
        if (user.getIdCard() != null){
            user.setSex(IdCardUtil.getSex(user.getIdCard()));
        }
        user.setPassword(Md5Encrypt.md5("123456"));
        user.setCreateTime(new Date());
        user.setFlag((byte) 1);
        userMapper.insertSelective(user);
        return null;
    }

    /**
     * 导入
     * @param list
     * @return
     */
    @Override
    public List<User> insertByExcelImport(List<User> list) {
        //对实体类做处理（为了导入错误时显示）
        for (User user : list){
            if (user.getOrganIdName() != null && user.getOrganIdName() !=""){
                user.setOrganId(getTypeIdByStr(user.getOrganIdName()));
                user.setOrganName(getNameByStr(user.getOrganIdName()));
            }
            if (user.getSexName() != null && user.getSexName() != ""){
                user.setSex(getTypeIdByStr(user.getSexName()));
            }
            if (user.getRoomIdName() != null && user.getRoomIdName() != ""){
                user.setRoomNo(getNameByStr(user.getRoomIdName()));
                user.setRoomId(getTypeIdByStr(user.getRoomIdName()));
            }
        }

        //导入的list
        List<User> importList = new ArrayList<>();
        //失败的list
        List<User> resultDataList = new ArrayList<>();
        //对数据进行筛选
        Map<String,List> map = new HashMap<>();
        //对excel进行筛选
        map = handleUserListExcel(list);
        resultDataList.addAll(map.get("resultDataList"));
        //对excel数据和数据库进行筛选
        Map<String,List> map1 = new HashMap<>();
        map1 = handleUserList(map.get("importList"));
        resultDataList.addAll(map1.get("resultDataList"));
        //筛选完，最终结果为map1.importList
        List<User> temList = map1.get("importList");
        if (temList == null){
            return resultDataList;
        }
        //合法数据进行拼装属性
        log.debug("合法数据进行拼装属性");
        for (User user : temList){
            //身份证验证工具类
            IdcardValidator idcardValidator = new IdcardValidator();
            //学号
            if (user.getAccount() == null || "".equals(user.getAccount())){
                user.setFailure("学号不能为空");
                resultDataList.add(user);
                continue;
            }
            //姓名
            if (user.getName() == null || "".equals(user.getName())){
                user.setFailure("姓名不能为空");
                resultDataList.add(user);
                continue;
            }
            //性别
            if (user.getSexName() == null || "".equals(user.getSexName())){
                user.setFailure("性别不能为空");
                resultDataList.add(user);
                continue;
            }else {
                user.setSex(getTypeIdByStr(user.getSexName()));
            }
            //身份证
            if (user.getIdCard() == null || "".equals(user.getIdCard())){
                user.setFailure("身份证号不能为空");
                resultDataList.add(user);
                continue;
            }else if ( !idcardValidator.isValidatedAllIdcard(user.getIdCard().trim())){
                user.setFailure("身份证号码格式不正确");
                resultDataList.add(user);
                continue;
            }
            //集体
            if (user.getOrganIdName() ==null || "".equals(user.getOrganIdName())){
                user.setFailure("所属集体不能为空");
                resultDataList.add(user);
                continue;
            }else {
                if (organMapper.selectByPrimaryKey(getTypeIdByStr(user.getOrganIdName())) == null){
                    user.setFailure("所属集体不存在");
                    resultDataList.add(user);
                    continue;
                }
                user.setOrganId(getTypeIdByStr(user.getOrganIdName()));
            }
            //入住时间
            if (user.getInDate() == null){
                user.setFailure("入住时间不能为空");
                resultDataList.add(user);
                continue;
            }
            //电话
            if (user.getPhone() == null || "".equals(user.getPhone())){
                user.setFailure("联系电话不能为空");
                resultDataList.add(user);
                continue;
            }else {
                if ( !IdcardValidator.validPhoneNum("0",user.getPhone())){
                    user.setFailure("电话格式不正确");
                    resultDataList.add(user);
                    continue;
                }

            }
            //籍贯
            if (user.getHome() == null || "".equals(user.getHome())){
                user.setFailure("籍贯不能为空");
                resultDataList.add(user);
                continue;
            }
            //居住地
            if (user.getLivePlace() == null || "".equals(user.getLivePlace())){
                user.setFailure("居住地不能为空");
                resultDataList.add(user);
                continue;
            }
            //寝室号
            if (user.getRoomIdName() == null || "".equals(user.getRoomIdName())){
                user.setFailure("寝室不能为空");
                resultDataList.add(user);
                continue;
            }else if (isFull(getTypeIdByStr(user.getRoomIdName()))){
                user.setFailure("寝室已满员");
                resultDataList.add(user);
                continue;
            }else {
                if (bedRoomMapper.selectByPrimaryKey(getTypeIdByStr(user.getRoomIdName())) == null){
                    user.setFailure("寝室不存在");
                    resultDataList.add(user);
                    continue;
                }
                user.setRoomId(getTypeIdByStr(user.getRoomIdName()));
            }
            user.setFlag((byte) 1);
            user.setPassword(Md5Encrypt.md5("123456"));
            user.setCreateTime(new Date());
            user.setRoleId(4);
            //开始插入（需要判断寝室是否满员）
            userMapper.insertSelective(user);
        }
        return resultDataList;
    }

    @Override
    public String updateUser(User user) {
        //对数据进行判断
        String msg = handleUser(user);
        if (msg != null){
            return msg;
        }
        //对数据进行组装
        if (user.getRoleId() == 2){
            user.setTowerNo(Integer.parseInt(user.getAccount().substring(0,1)));
        }
        if (user.getIdCard() != null){
            user.setSex(IdCardUtil.getSex(user.getIdCard()));
        }
        user.setUpdateTime(new Date());
        //修改
        userMapper.updateByPrimaryKeySelective(user);
        return null;
    }

    /**
     * 通过导入内容获取typeId
     *
     * @param str
     * @return
     */
    private Integer getTypeIdByStr(String str) {
        String strs[] = str.split(":");
        Integer typeId = Integer.parseInt(strs[0]);
        return typeId;
    }

    /**
     *根据导入内容获取name
     * @param str
     * @return
     */
    private String getNameByStr(String str) {
        String strs[] = str.split(":");
        String name = strs[1];
        return name;
    }

    /**
     * 判断寝室是否满员
     * @param id
     * @return
     */
    private boolean isFull(Integer id){
        BedRoom bedRoom = bedRoomMapper.selectByPrimaryKey(id);
        if (bedRoom.getRealPerson() >= bedRoom.getMaxPerson()){
            return true;
        }
        return false;
    }


    /**
     * 过滤excel中的数据是否重复（学号,身份证，手机号）
     * @param importList
     * @return
     */
    private Map<String, List> handleUserListExcel(List<User> importList) {

        List<User> resultDataList = new ArrayList<User>();
        Map<String, List> mapList = new HashMap<String, List>();
        for (int i = 0; i < importList.size()-1; i++) {
            for (int j = importList.size()-1; j >= i; j--) {
                if (importList.get(j).getAccount() != null && importList.get(j).getAccount() != "" &&
                        importList.get(i).getAccount() != null && importList.get(i).getAccount() != "") {
                    if (importList.get(j).getAccount().trim().equals(importList.get(i).getAccount().trim())) {
                        importList.get(j).setFailure("Excel表中学号重复！");
                        resultDataList.add(importList.get(j));
                        importList.remove(j);
                        continue;
                    }
                } else {
                    importList.get(j).setFailure("Excel表中学号为空！");
                    resultDataList.add(importList.get(j));
                    importList.remove(j);
                    continue;
                }
                if (importList.get(j).getIdCard() != null && importList.get(j).getIdCard() != "" &&
                        importList.get(i).getIdCard() != null && importList.get(i).getIdCard() != "") {
                    if (importList.get(j).getIdCard().trim().equals(importList.get(i).getIdCard().trim())) {
                        importList.get(j).setFailure("Excel表中身份证号码重复！");
                        resultDataList.add(importList.get(j));
                        importList.remove(j);
                        continue;
                    }
                } else {
                    importList.get(j).setFailure("Excel表中身份证号码为空！");
                    resultDataList.add(importList.get(j));
                    importList.remove(j);
                    continue;
                }
                if (importList.get(j).getPhone() != null && importList.get(j).getPhone() != "" &&
                        importList.get(i).getPhone() != null && importList.get(i).getPhone() != "") {
                    if (importList.get(j).getPhone().trim().equals(importList.get(i).getPhone().trim())) {
                        importList.get(j).setFailure("Excel表中电话号码重复！");
                        resultDataList.add(importList.get(j));
                        importList.remove(j);
                        continue;
                    }
                }
            }
        }
        mapList.put("importList", importList);
        mapList.put("resultDataList", resultDataList);
        return mapList;

    }

    /**
     * 过滤数据和数据库是否重复（学号，身份证号，电话号码）
     * @param importList
     * @return
     */
    private Map<String, List> handleUserList(List<User> importList) {

        Map<String, List> mapList = new HashMap<String, List>();
//        Map<String, Object> map = new HashMap<String, Object>();
        List<User> resultDataList = new ArrayList<User>();
        List<User> successList = new ArrayList<>();

        List<String> stringList = new ArrayList<>();

        log.debug("获取所有的学生");
        List<User> allList = userMapper.findStudentAll(new UserQuery());
        for (User user : allList){
            stringList.add(user.getAccount());
            stringList.add(user.getIdCard());
            stringList.add(user.getPhone());
        }

        for (User imp : importList){
            if (stringList.contains(imp.getAccount())){
                imp.setFailure("学号重复！");
                resultDataList.add(imp);
                continue;
            }
            if (stringList.contains(imp.getIdCard())){
                imp.setFailure("身份证重复！");
                resultDataList.add(imp);
                continue;
            }
            if (stringList.contains(imp.getPhone())){
                imp.setFailure("电话重复！");
                resultDataList.add(imp);
                continue;
            }
            successList.add(imp);
        }


//        Iterator<User> impIt = importList.iterator();
//        while (impIt.hasNext()) {
//            User imp = impIt.next();
//            Iterator<User> allIt = allList.iterator();
//            while (allIt.hasNext()) {
//                User all = allIt.next();
//                //过滤学号号
//                if (!StringUtils.isEmpty(imp.getAccount())) {
//                    log.debug("导入学号:" + imp.getAccount().trim() + "========库里面的学号:" + all.getAccount());
//                    if (imp.getAccount().trim().equals(all.getAccount())) {
//                        allIt.remove();
//                        impIt.remove();
//                        imp.setFailure("学号重复！");
//                        resultDataList.add(imp);
//                        continue;
//                    }
//                }
//                //过滤手机号
//                if (!StringUtils.isEmpty(imp.getPhone())) {
//                    log.debug("导入电话号码:" + imp.getPhone().trim() + "========库里面的电话号码:" + all.getPhone());
//                    if (imp.getPhone().trim().equals(all.getPhone())) {
//                        allIt.remove();
//                        impIt.remove();
//                        imp.setFailure("手机号码重复！");
//                        resultDataList.add(imp);
//                        continue;
//                    }
//                }
//                // 过滤证件号码
//                if (!StringUtils.isEmpty(imp.getIdCard())) {
//                    log.debug("导入身份证:" + imp.getIdCard().trim() + "========库里面的身份证:" + all.getIdCard());
//                    if (imp.getIdCard().trim().equals(all.getIdCard())) {
//                        allIt.remove();
//                        impIt.remove();
//                        imp.setFailure("身份证号码重复！");
//                        resultDataList.add(imp);
//                        continue;
//                    }
//                }
//            }
//        }

//        for (User imp : importList){
//            for (User all : allList){
//                //过滤学号
//                if (!StringUtils.isEmpty(imp.getAccount())) {
//                    log.debug("导入学号:" + imp.getAccount().trim() + "========库里面的学号:" + all.getAccount());
//                    if (imp.getAccount().trim().equals(all.getAccount())) {
//                        imp.setFailure("学号重复！");
//                        resultDataList.add(imp);
//                        break;
//                    }
//                }
//                //过滤手机号
//                if (!StringUtils.isEmpty(imp.getPhone())) {
//                    log.debug("导入电话号码:" + imp.getPhone().trim() + "========库里面的电话号码:" + all.getPhone());
//                    if (imp.getPhone().trim().equals(all.getPhone())) {
//                        imp.setFailure("手机号码重复！");
//                        resultDataList.add(imp);
//                        break;
//                    }
//                }
//                // 过滤证件号码
//                if (!StringUtils.isEmpty(imp.getIdCard())) {
//                    log.debug("导入身份证:" + imp.getIdCard().trim() + "========库里面的身份证:" + all.getIdCard());
//                    if (imp.getIdCard().trim().equals(all.getIdCard())) {
//                        imp.setFailure("身份证号码重复！");
//                        resultDataList.add(imp);
//                        break;
//                    }
//                }
//                successList.add(imp);
//            }
//        }


        mapList.put("resultDataList", resultDataList);
        mapList.put("importList", successList);
        return mapList;
    }

    /**
     * 用于判断用户是否存在库中（学号，身份证号，手机号码）
     * @param user
     * @return
     */
    private String handleUser(User user){
        //查询全部
        String msg = null;
        List<User> list = userMapper.selectAll();
        for (User user1 : list){
            if (user.getAccount()!= null && user.getAccount()!= ""){
                if (user.getAccount().equals(user1.getAccount())){
                    msg = "学号/账号已存在";
                    break;
                }
            }
            if (user.getIdCard() != null && user.getIdCard() != ""){
                if (user.getIdCard().equals(user1.getIdCard())){
                    msg = "身份证已存在";
                }
            }
            if (user.getPhone() != null && user.getPhone() != ""){
                if (user.getPhone().equals(user1.getPhone())){
                    msg = "电话号码已存在";
                }
            }
        }
        return msg;
    }
}
