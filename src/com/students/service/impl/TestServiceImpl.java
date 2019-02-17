package com.students.service.impl;

import com.students.dao.TestDao;
import com.students.entity.TestName;
import com.students.entity.TestTable;
import com.students.service.TestService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class TestServiceImpl implements TestService {
    @Autowired
    private TestDao testDao;
    @Override
    public Integer addNewTestName(String testname) throws Exception {
        try{
            return testDao.addNewTestName(testname);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }
    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer addNewTest(TestTable testTable) throws Exception {
        try{
            return testDao.addNewTest(testTable);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public Integer getTestId(String testname) throws Exception {
        try{
            return testDao.getTestId(testname);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<TestName> getTestInfo() throws Exception {
        try{
            return testDao.getTestInfo();
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }
    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer eotaDel(Integer test_id) throws Exception {
        try{
            return testDao.eotaDel(test_id);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }
    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer eotaDel2(Integer test_id) throws Exception {
        try{
            return testDao.eotaDel2(test_id);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }
    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer eotaUpdate(String test_name, Integer test_id) throws Exception {
        try{
            return testDao.eotaUpdate(test_name,test_id);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<TestTable> getTestInfoOfStudents(String classNum, Integer test_id) throws Exception {
        try{
            return testDao.getTestInfoOfStudents(classNum,test_id);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer updateAllFen(TestTable testTable) throws Exception {
        try{
            return testDao.updateAllFen(testTable);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<TestTable> getAllTestInfoOfStudents(Integer test_id) throws Exception {
        try{
            return testDao.getAllTestInfoOfStudents(test_id);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<String> getAllTestinfoClassNum(Integer test_id) throws Exception {
        try{
            return testDao.getAllTestinfoClassNum(test_id);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }
}
