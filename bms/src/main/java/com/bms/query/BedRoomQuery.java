package com.bms.query;

import java.util.Date;

public class BedRoomQuery extends BaseQuery {
    private Integer id;

    private String roomNo;

    private Integer towerNo;

    private String phone;

    private String roomMan;

    private Byte flag;

    private Date createTime;

    private Date updateTime;

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
}
