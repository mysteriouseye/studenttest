package com.students.service.impl;

import com.students.dao.CourseDao;
import com.students.entity.CourseTable;
import com.students.service.CourseService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
@Service
public class CourseServiceImpl implements CourseService {
    @Autowired
    private CourseDao courseDao;
    @Override
    public List<CourseTable> findAllCourseByClassNumWithYear(Integer year, String classNum) throws Exception {
        try{
            return courseDao.findAllCourseByClassNumWithYear(year,classNum);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<Integer> findAllCourseYear() throws Exception {
        try{
            return courseDao.findAllCourseYear();
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<String> findAllCourseClassNum() throws Exception {
        try{
            return courseDao.findAllCourseClassNum();
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<CourseTable> findAllCourse() throws Exception {
        try{
            return courseDao.findAllCourse();
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<CourseTable> checkCourseisKown(CourseTable courseTable) throws Exception {
        try{
            return courseDao.checkCourseisKown(courseTable);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }
    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer InsertCourse(CourseTable courseTable) throws Exception {
        try{
            return courseDao.InsertCourse(courseTable);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }
    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer updateCourse(CourseTable courseTable) throws Exception {
        try{
            return courseDao.updateCourse(courseTable);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer deleteCourse(String classNum) throws Exception {
        try{
            return courseDao.deleteCourse(classNum);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }
}
