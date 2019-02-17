package com.students.util;

import org.springframework.scheduling.concurrent.ThreadPoolTaskExecutor;

import java.util.concurrent.*;

public class MailPool {
    BlockingDeque<Runnable> workd;
    ExecutorService es;
    public MailPool(){
        workd = new LinkedBlockingDeque<>();
        es = new ThreadPoolExecutor(2,4,30, TimeUnit.SECONDS,workd,new ThreadPoolExecutor.CallerRunsPolicy());//30s keep alive
    }
    public Boolean send(Runnable task){
        System.out.println("poolsend start...");
        try{
            es.execute(task);
            return true;
        }catch (Exception e){
            e.printStackTrace();
            return false;
        }
    }
    public void close(){
        es.shutdown();
    }
}
