package com.students.service;

import com.students.entity.CourseTable;

import java.util.List;

public interface CourseService {
    public List<CourseTable> findAllCourseByClassNumWithYear(Integer year, String classNum) throws Exception;
    public List<Integer> findAllCourseYear() throws Exception;
    public List<String> findAllCourseClassNum() throws Exception;
    public List<CourseTable> findAllCourse() throws Exception;
    public List<CourseTable> checkCourseisKown(CourseTable courseTable) throws Exception;
    public Integer InsertCourse(CourseTable courseTable) throws Exception;
    public Integer updateCourse(CourseTable courseTable) throws Exception;
    public Integer deleteCourse(String classNum) throws Exception;
}
