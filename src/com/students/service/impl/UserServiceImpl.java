package com.students.service.impl;

import com.students.dao.UserDao;
import com.students.entity.User;
import com.students.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class UserServiceImpl implements UserService {
    @Autowired
    private UserDao userDao;
    @Override
    public User findUserInfo(String name) {
        User user = userDao.findUserInfo(name);
        return user;
    }

    @Override
    public Integer findRUserName(String name) {
        return userDao.findRUserName(name);
    }

    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer updateActive(List<User> user) {
        try {
            return userDao.updateActive(user);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }

    }

    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer updateForget(User user) throws Exception {
        try{
            return userDao.updateForget(user);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }
    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer IndexUpdateUserinfo(User user) throws Exception {
        try{
            return userDao.IndexUpdateUserinfo(user);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer adminInsertInfo(User user) throws Exception {
        try{
            return userDao.adminInsertInfo(user);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<User> loadClassInfo(String classNum) throws Exception {
        try{
            return userDao.loadClassInfo(classNum);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<User> selectClassTeacherInfo(String classNum) throws Exception {
        try{
            return userDao.selectClassTeacherInfo(classNum);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<String> getAllClassNum() throws Exception {
        try{
            return userDao.getAllClassNum();
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<User> getAllClassNumPeoNumNoDis() throws Exception {
        try{
            return userDao.getAllClassNumPeoNumNoDis();
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<User> getClassNumPeoNum(String classNum) throws Exception {
        try{
            return userDao.getClassNumPeoNum(classNum);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<User> AdminfindAllUserinfo() throws Exception {
        try{
            return userDao.AdminfindAllUserinfo();
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public User findUserByUId(Integer id) throws Exception {
        try{
            return userDao.findUserByUId(id);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }
    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer deleteUser(Integer id) throws Exception {
        try{
            return userDao.deleteUser(id);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer updateUserInfo(User user) throws Exception {
        try{
            return userDao.updateUserInfo(user);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<User> checkUserIsKnown(User user) throws Exception {
        try{
            return userDao.checkUserIsKnown(user);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer updateKnownUser(User user) throws Exception {
        try{
            return userDao.updateKnownUser(user);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer insertUserinfo(User user) throws Exception {
        try{
            return userDao.insertUserinfo(user);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<User> checkadmininsert(User user) throws Exception {
        try{
            return userDao.checkadmininsert(user);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<User> indexcheckUser(User user) throws Exception {
        try{
            return userDao.indexcheckUser(user);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

}
