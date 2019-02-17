package com.students.service;

import com.students.entity.User;

import java.util.List;
import java.util.Map;

public interface UserService {
    public User findUserInfo(String name);
    public Integer findRUserName(String name);
    public Integer updateActive(List<User> user);
    public Integer updateForget(User user) throws Exception;
    public Integer IndexUpdateUserinfo(User user) throws Exception;
    public Integer adminInsertInfo(User user) throws Exception;
    public List<User> loadClassInfo(String classNum) throws Exception;
    public List<User> selectClassTeacherInfo(String classNum) throws Exception;
    public List<String> getAllClassNum() throws Exception;
    public List<User> getAllClassNumPeoNumNoDis() throws Exception;
    public List<User> getClassNumPeoNum(String classNum) throws Exception;
    public List<User> AdminfindAllUserinfo() throws Exception;
    public User findUserByUId(Integer id) throws Exception;
    public Integer deleteUser(Integer id) throws Exception;
    public Integer updateUserInfo(User user) throws Exception;
    public List<User> checkUserIsKnown(User user) throws Exception;
    public Integer updateKnownUser(User user) throws Exception;
    public Integer insertUserinfo(User user) throws Exception;
    public List<User> checkadmininsert(User user) throws Exception;
    public List<User> indexcheckUser(User user) throws Exception;
}
