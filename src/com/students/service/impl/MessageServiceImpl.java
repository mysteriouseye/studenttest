package com.students.service.impl;

import com.students.dao.MessageDao;
import com.students.entity.MessageTable;
import com.students.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
@Service
public class MessageServiceImpl implements MessageService{
    @Autowired
    private MessageDao messageDao;
    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer addNewMessage(MessageTable messageTable) throws Exception {
        try{
            return messageDao.addNewMessage(messageTable);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Override
    public List<MessageTable> adminselectAllMessage() throws Exception {
        try{
            return messageDao.adminselectAllMessage();
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Override
    public List<MessageTable> findUserMessage(Integer uid) throws Exception {
        try{
            return messageDao.findUserMessage(uid);
        }catch (Exception e){
            e.printStackTrace();
            return null;
        }
    }

    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer passMsg(Integer m_id) throws Exception {
        try{
            return messageDao.passMsg(m_id);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }

    @Transactional(propagation= Propagation.REQUIRED)
    @Override
    public Integer deleteMsg(Integer m_id) throws Exception {
        try{
            return messageDao.deleteMsg(m_id);
        }catch (Exception e){
            e.printStackTrace();
            return 0;
        }
    }
}
