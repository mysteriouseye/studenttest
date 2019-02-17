package com.students.dao;

import com.students.entity.User;

public interface FileDao {
    public Integer uploadHeadFile(User user) throws Exception;
}
