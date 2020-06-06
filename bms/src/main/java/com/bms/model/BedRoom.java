package com.bms.model;

import cn.afterturn.easypoi.excel.annotation.Excel;

import java.util.Date;

public class BedRoom {
    private Integer id;

    @Excel(name = "寝室号", orderNum = "1", mergeVertical = true, isImportField = "roomNo")
    private String roomNo;

    private Integer towerNo;

    private Integer userId;

    private String phone;

    private String roomMan;

    private Integer realPerson;

    @Excel(name = "床位数", orderNum = "2", mergeVertical = true, isImportField = "maxPerson")
    private Integer maxPerson;

    private Byte flag;

    private Date createTime;

    private Date updateTime;

    @Excel(name = "失败原因", orderNum = "3", mergeVertical = true, isImportField = "failure")
    private String failure;

    public String getFailure() {
        return failure;
    }

    public void setFailure(String failure) {
        this.failure = failure;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo == null ? null : roomNo.trim();
    }

    public Integer getTowerNo() {
        return towerNo;
    }

    public void setTowerNo(Integer towerNo) {
        this.towerNo = towerNo;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone == null ? null : phone.trim();
    }

    public String getRoomMan() {
        return roomMan;
    }

    public void setRoomMan(String roomMan) {
        this.roomMan = roomMan == null ? null : roomMan.trim();
    }

    public Integer getRealPerson() {
        return realPerson;
    }

    public void setRealPerson(Integer realPerson) {
        this.realPerson = realPerson;
    }

    public Integer getMaxPerson() {
        return maxPerson;
    }

    public void setMaxPerson(Integer maxPerson) {
        this.maxPerson = maxPerson;
    }

    public Byte getFlag() {
        return flag;
    }

    public void setFlag(Byte flag) {
        this.flag = flag;
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

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }
}