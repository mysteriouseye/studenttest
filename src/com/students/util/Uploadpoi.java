package com.students.util;

import com.students.entity.CourseTable;
import com.students.entity.TestTable;
import com.students.entity.User;
import com.students.entity.WorkBookVersion;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

import java.util.ArrayList;
import java.util.List;
import java.util.Objects;

public class Uploadpoi {
    public Workbook getWorkbooj(MultipartFile file, String suffix) throws Exception{
        Workbook wk = null;
        if(Objects.equals(WorkBookVersion.WorkBook2003Xls.getCode(),suffix)){
            wk = new HSSFWorkbook(file.getInputStream());
        }else if(Objects.equals(WorkBookVersion.WorkBook2007Xlsx.getCode(),suffix)){
            wk = new XSSFWorkbook(file.getInputStream());
        }
        return wk;
    }
    public List<TestTable> readExcelDataOfTest(Workbook wb) throws Exception{
        TestTable testTable = null;

        List<TestTable> testTables = new ArrayList<TestTable>();
        Row row = null;
        int numSheet = wb.getNumberOfSheets();
        if(numSheet > 0){
            for(int i = 0;i < numSheet;i++){
                Sheet sheet = wb.getSheetAt(i);
                int numRow = sheet.getLastRowNum();
                if(numRow > 0){
                    for(int j = 1;j < numRow+1;j++){
                        row = sheet.getRow(j);
                        testTable = new TestTable();
                        Integer test_id = Integer.valueOf(ExcelUtil.manageCell(row.getCell(0),null));
                        String userName = ExcelUtil.manageCell(row.getCell(1),null);
                        String classNum = ExcelUtil.manageCell(row.getCell(2),null);
                        String peoNum = ExcelUtil.manageCell(row.getCell(3),null);
                        Integer Chinese = Integer.valueOf(ExcelUtil.manageCell(row.getCell(4),null));
                        Integer Math = Integer.valueOf(ExcelUtil.manageCell(row.getCell(5),null));
                        Integer English = Integer.valueOf(ExcelUtil.manageCell(row.getCell(6),null));
                        Integer Physic = Integer.valueOf(ExcelUtil.manageCell(row.getCell(7),null));
                        Integer Chemical = Integer.valueOf(ExcelUtil.manageCell(row.getCell(8),null));
                        Integer Biology = Integer.valueOf(ExcelUtil.manageCell(row.getCell(9),null));
                        Integer Politics = Integer.valueOf(ExcelUtil.manageCell(row.getCell(10),null));
                        Integer History = Integer.valueOf(ExcelUtil.manageCell(row.getCell(11),null));
                        Integer Geography = Integer.valueOf(ExcelUtil.manageCell(row.getCell(12),null));

                        testTable.setTest_id(test_id);
                        testTable.setUserName(userName);
                        testTable.setPeoNum(peoNum);
                        testTable.setClassNum(classNum);
                        testTable.setChinese(Chinese);
                        testTable.setMath(Math);
                        testTable.setEnglish(English);
                        testTable.setPhysic(Physic);
                        testTable.setChemical(Chemical);
                        testTable.setBiology(Biology);
                        testTable.setPolitics(Politics);
                        testTable.setHistory(History);
                        testTable.setGeography(Geography);

                        testTables.add(testTable);
                    }
                }
            }
        }
        return testTables;
    }
    public List<CourseTable> readExcelDataOfCourse(Workbook wb) throws Exception{
        CourseTable courseTable = null;
        List<CourseTable> courseTables = new ArrayList<CourseTable>();
        Row row = null;
        int numSheet = wb.getNumberOfSheets();
        if(numSheet > 0){
            for(int i = 0;i < numSheet;i++){
                Sheet sheet = wb.getSheetAt(i);
                int numRow = sheet.getLastRowNum();
                if(numRow > 0){
                    for(int j = 1;j < numRow+1;j++){
                        row = sheet.getRow(j);
                        courseTable = new CourseTable();
                        Integer cou_id = Integer.valueOf(ExcelUtil.manageCell(row.getCell(0),null));
                        String classNum = ExcelUtil.manageCell(row.getCell(1),null);
                        Integer c_year = Integer.valueOf(ExcelUtil.manageCell(row.getCell(2),null));
                        Integer c_time = Integer.valueOf(ExcelUtil.manageCell(row.getCell(3),null));
                        String c_time_more = ExcelUtil.manageCell(row.getCell(4),null);
                        Integer c_what = Integer.valueOf(ExcelUtil.manageCell(row.getCell(5),null));
                        String c_location = ExcelUtil.manageCell(row.getCell(6),null);
                        String c_teacher = ExcelUtil.manageCell(row.getCell(7),null);
                        String peoNum = ExcelUtil.manageCell(row.getCell(8),null);

                        courseTable.setCou_id(cou_id);
                        courseTable.setClassNum(classNum);
                        courseTable.setC_year(c_year);
                        courseTable.setC_time(c_time);
                        courseTable.setC_time_more(c_time_more);
                        courseTable.setC_what(c_what);
                        courseTable.setC_location(c_location);
                        courseTable.setC_teacher(c_teacher);
                        System.out.println(c_teacher);
                        courseTable.setPeoNum(peoNum);

                        courseTables.add(courseTable);
                    }
                }
            }
        }
        return courseTables;
    }
    public List<User> readExcelDataOfUser(Workbook wb) throws Exception{
        User user = null;

        List<User> users = new ArrayList<User>();
        Row row = null;
        int numSheet = wb.getNumberOfSheets();
        if(numSheet > 0){
            for(int i = 0;i < numSheet;i++){
                Sheet sheet = wb.getSheetAt(i);
                int numRow = sheet.getLastRowNum();
                if(numRow > 0){
                    for(int j = 1;j < numRow+1;j++){
                        row = sheet.getRow(j);
                        user = new User();
                        String userName = ExcelUtil.manageCell(row.getCell(0),null);
                        Integer age = Integer.valueOf(ExcelUtil.manageCell(row.getCell(1),null));
                        String sex = ExcelUtil.manageCell(row.getCell(2),null);
                        String classNum = ExcelUtil.manageCell(row.getCell(3),null);
                        String identity = ExcelUtil.manageCell(row.getCell(4),null);
                        String peoNum = ExcelUtil.manageCell(row.getCell(5),null);
                        String email = ExcelUtil.manageCell(row.getCell(6),null);
                        String phoneNum = ExcelUtil.manageCell(row.getCell(7),null);

                        user.setUserName(userName);
                        user.setAge(age);
                        user.setSex(sex);
                        user.setClassNum(classNum);
                        user.setIdentity(identity);
                        user.setPeoNum(peoNum);
                        user.setEmail(email);
                        user.setPhoneNum(phoneNum);

                        users.add(user);
                    }
                }
            }
        }
        return users;
    }

}
