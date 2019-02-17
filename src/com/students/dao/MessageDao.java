package com.students.dao;

import com.students.entity.MessageTable;

import java.util.List;

public interface MessageDao {
    public Integer addNewMessage(MessageTable messageTable) throws Exception;
    public List<MessageTable> adminselectAllMessage() throws Exception;
    public List<MessageTable> findUserMessage(Integer uid) throws Exception;
    public Integer passMsg(Integer m_id) throws Exception;
    public Integer deleteMsg(Integer m_id) throws Exception;
}
