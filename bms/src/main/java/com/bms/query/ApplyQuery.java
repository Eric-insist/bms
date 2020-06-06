package com.bms.query;

import java.util.Date;

public class ApplyQuery extends BaseQuery {
    private Integer id;

    private Integer userId;

    private String userName;

    private Integer type;

    private Date applyTime;

    private Integer state;

    private String roomNo;

    private Integer towerNo;

    private String description;

    private String newRoomNo;

    private Date submitTime;

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public Integer getType() {
        return type;
    }

    public void setType(Integer type) {
        this.type = type;
    }

    public Date getApplyTime() {
        return applyTime;
    }

    public void setApplyTime(Date applyTime) {
        this.applyTime = applyTime;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public String getRoomNo() {
        return roomNo;
    }

    public void setRoomNo(String roomNo) {
        this.roomNo = roomNo;
    }

    public Integer getTowerNo() {
        return towerNo;
    }

    public void setTowerNo(Integer towerNo) {
        this.towerNo = towerNo;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getNewRoomNo() {
        return newRoomNo;
    }

    public void setNewRoomNo(String newRoomNo) {
        this.newRoomNo = newRoomNo;
    }

    public Date getSubmitTime() {
        return submitTime;
    }

    public void setSubmitTime(Date submitTime) {
        this.submitTime = submitTime;
    }
}
