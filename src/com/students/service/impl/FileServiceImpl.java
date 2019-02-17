package com.students.service.impl;

import com.students.dao.FileDao;
import com.students.dao.UserDao;
import com.students.entity.User;
import com.students.service.FileService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;
@Service
public class FileServiceImpl implements FileService {
    @Autowired
    private FileDao fileDao;
    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer uploadHeadFile(User user) throws Exception {
        try{
            return fileDao.uploadHeadFile(user);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }
}
