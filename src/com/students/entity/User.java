package com.students.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import org.springframework.format.annotation.DateTimeFormat;

import java.util.Date;

public class User {
    public Integer getUid() {
        return uid;
    }

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

    public String getPassWord() {
        return passWord;
    }

    public void setPassWord(String passWord) {
        this.passWord = passWord;
    }

    public String getSex() {
        return sex;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public String getClassNum() {
        return classNum;
    }

    public void setClassNum(String classNum) {
        this.classNum = classNum;
    }

    public String getIdentity() {
        return identity;
    }

    public void setIdentity(String identity) {
        this.identity = identity;
    }

    public String getSigned() {
        return signed;
    }

    public void setSigned(String signed) {
        this.signed = signed;
    }

    public String getHeadIco() {
        return headIco;
    }

    public void setHeadIco(String headIco) {
        this.headIco = headIco;
    }

    public Date getRetime() {
        return retime;
    }

    public void setRetime(Date retime) {
        this.retime = retime;
    }

    public String getEmail() {
        return email;
    }

    public String getPeoNum() {
        return peoNum;
    }

    public void setPeoNum(String peoNum) {
        this.peoNum = peoNum;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhoneNum() {
        return phoneNum;
    }

    public void setPhoneNum(String phoneNum) {
        this.phoneNum = phoneNum;
    }

    public Integer getU_status() {
        return u_status;
    }

    public void setU_status(Integer u_status) {
        this.u_status = u_status;
    }

    public Integer getAge() {
        return age;
    }

    public void setAge(Integer age) {
        this.age = age;
    }
    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    private Integer uid;
    private String r_userName;
    private String userName;
    private String passWord;
    private String sex;
    private String cname;
    private Integer age;
    private String classNum;
    private String identity;
    private String peoNum;
    private String email;
    private String phoneNum;
    private String signed;
    private String headIco;
    private Integer u_status;
    @DateTimeFormat(pattern="yyyy年MM月dd日")
    @JsonFormat(pattern="yyyy年MM月dd日")
    private Date retime;


}
