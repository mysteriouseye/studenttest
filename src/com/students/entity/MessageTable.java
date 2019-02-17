package com.students.entity;

public class MessageTable {
    private Integer m_id;
    private Integer uid;
    private String title;
    private String mes;
    private Integer k_status;
    private String userName;
    private String headIco;
    private String r_userName;
    public void setUid(Integer uid) {
        this.uid = uid;
    }

    public String getR_userName() {
        return r_userName;
    }

    public void setR_userName(String r_userName) {
        this.r_userName = r_userName;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getHeadIco() {
        return headIco;
    }

    public void setHeadIco(String headIco) {
        this.headIco = headIco;
    }

    public Integer getM_id() {
        return m_id;
    }

    public void setM_id(Integer m_id) {
        this.m_id = m_id;
    }


    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getMes() {
        return mes;
    }

    public void setMes(String mes) {
        this.mes = mes;
    }

    public Integer getK_status() {
        return k_status;
    }

    public void setK_status(Integer k_status) {
        this.k_status = k_status;
    }
}
