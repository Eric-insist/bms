package com.bms.model.excelVo;

import cn.afterturn.easypoi.excel.annotation.Excel;
import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class UserVo {
    private Integer id;

    @Excel(name = "学号", orderNum = "1")
    private String account;

    private String password;

    private String salt;

    @Excel(name = "姓名", orderNum = "2")
    private String name;

//    @Excel(name = "年龄", orderNum = "3")
    private Integer age;

    private Integer sex;

    @Excel(name = "性别", orderNum = "3")
    private String sexName;

    @Excel(name = "身份证", orderNum = "4")
    private String idCard;

    private Integer organId;

    @Excel(name = "所属集体", orderNum = "5")
    private String organIdName;

    private String organName;

    private String parentName;

    private String studentClass;

    private String roomNo;

    private Integer roomId;

    @Excel(name = "寝室", orderNum = "6")
    private String roomIdName;

    @Excel(name = "入住时间", orderNum = "7" ,importFormat = "yyyy.MM")
    private Date inDate;

    @Excel(name = "联系电话", orderNum = "8")
    private String phone;

    @Excel(name = "籍贯", orderNum = "9")
    private String home;

    @Excel(name = "居住地", orderNum = "10")
    private String livePlace;

    private Byte flag;

    private Integer roleId;

    private Integer towerNo;

    private Date createTime;

    private Date updateTime;

    private String failure;

    public String getRoomIdName() {
        return roomIdName;
    }

    public void setRoomIdName(String roomIdName) {
        this.roomIdName = roomIdName;
    }

    public String getSexName() {
        return sexName;
    }

    public void setSexName(String sexName) {
        this.sexName = sexName;
    }

    public String getOrganIdName() {
        return organIdName;
    }

    public void setOrganIdName(String organIdName) {
        this.organIdName = organIdName;
    }

    public String getFailure() {
        return failure;
    }

    public void setFailure(String failure) {
        this.failure = failure;
    }

    public Integer getRoomId() {
        return roomId;
    }

    public void setRoomId(Integer roomId) {
        this.roomId = roomId;
    }

    public String getLivePlace() {
        return livePlace;
    }

    public void setLivePlace(String livePlace) {
        this.livePlace = livePlace;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getAccount() {
        return account;
    }

    public void setAccount(String account) {
        this.account = account == null ? null : account.trim();
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password == null ? null : password.trim();
    }

    public String getSalt() {
        return salt;
    }

    public void setSalt(String salt) {
        this.salt = salt == null ? null : salt.trim();
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name == null ? null : name.trim();
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }

    public Integer getSex() {
        return sex;
    }

    public void setSex(Integer sex) {
        this.sex = sex;
    }

    public String getIdCard() {
        return idCard;
    }

    public void setIdCard(String idCard) {
        this.idCard = idCard == null ? null : idCard.trim();
    }

    public Integer getOrganId() {
        return organId;
    }

    public void setOrganId(Integer organId) {
        this.organId = organId;
    }

    public String getOrganName() {
        return organName;
    }

    public void setOrganName(String organName) {
        this.organName = organName == null ? null : organName.trim();
    }

    public String getParentName() {
        return parentName;
    }

    public void setParentName(String parentName) {
        this.parentName = parentName;
    }

    public String getStudentClass() {
        return studentClass;
    }

    public void setStudentClass(String studentClass) {
        this.studentClass = studentClass == null ? null : studentClass.trim();
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo == null ? null : roomNo.trim();
    }

    public Date getInDate() {
        return inDate;
    }

    public void setInDate(Date inDate) {
        this.inDate = inDate;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone == null ? null : phone.trim();
    }

    public String getHome() {
        return home;
    }

    public void setHome(String home) {
        this.home = home == null ? null : home.trim();
    }

    public Byte getFlag() {
        return flag;
    }

    public void setFlag(Byte flag) {
        this.flag = flag;
    }

    public Integer getRoleId() {
        return roleId;
    }

    public void setRoleId(Integer roleId) {
        this.roleId = roleId;
    }

    public Integer getTowerNo() {
        return towerNo;
    }

    public void setTowerNo(Integer towerNo) {
        this.towerNo = towerNo;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }
}