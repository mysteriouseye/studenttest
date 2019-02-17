package com.students.dao;

import com.students.entity.TestName;
import com.students.entity.TestTable;
import com.students.util.ExcelUtil;

import java.util.List;

public interface TestDao {
    public Integer addNewTestName(String testname) throws Exception;
    public Integer addNewTest(TestTable testTable) throws Exception;
    public Integer getTestId(String testname) throws Exception;
    public List<TestName> getTestInfo() throws Exception;
    public Integer eotaDel(Integer test_id) throws Exception;
    public Integer eotaDel2(Integer test_id) throws Exception;
    public Integer eotaUpdate(String test_name,Integer test_id) throws Exception;
    public List<TestTable> getTestInfoOfStudents(String classNum,Integer test_id) throws Exception;
    public Integer updateAllFen(TestTable testTable) throws Exception;
    public List<TestTable> getAllTestInfoOfStudents(Integer test_id) throws Exception;
    public List<String> getAllTestinfoClassNum(Integer test_id) throws Exception;
}
