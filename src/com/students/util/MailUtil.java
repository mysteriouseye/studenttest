package com.students.util;

import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Properties;

import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

public class MailUtil implements Runnable{
    private static Properties props;
    private static Session session;
    private static MimeMessage message;

    public static Boolean checkEmail(String email) {
        if (email.matches("^[a-z0-9A-Z]+[- | a-z0-9A-Z . _]+@([a-z0-9A-Z]+(-[a-z0-9A-Z]+)?\\.)+[a-z]{2,}$")) {
            return true;
        } else {
            return false;
        }
    }
    public MailUtil(String receiveMail,String body){
        props = new Properties();
        props.setProperty("mail.transport.protocol", "smtp"); // 使用的协议（JavaMail规范要求）
        props.setProperty("mail.smtp.host", "smtp.163.com"); // 发件人的邮箱的 SMTP
        // 服务器地址
        props.setProperty("mail.smtp.auth", "true"); // 需要请求认证

             /* SMTP 服务器的端口 (非 SSL 连接的端口一般默认为 25, 可以不添加, 如果开启了 SSL 连接, 需要改为对应邮箱的 SMTP 服务器的端口, 具体可查看对应邮箱服务的帮助, QQ邮箱的SMTP(SLL)端口为465或587, 其他邮箱自行去查看) */
        final String smtpPort = "465";
        props.setProperty("mail.smtp.port", smtpPort);
        props.setProperty("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory");
        props.setProperty("mail.smtp.socketFactory.fallback", "false");
        props.setProperty("mail.smtp.socketFactory.port", smtpPort);

        session = Session.getDefaultInstance(props);
        session.setDebug(false);
        message = new MimeMessage(session);

        // 2. From: 发件人
        try {
            message.setFrom(new InternetAddress("yuanhong143shen@163.com", "yuanhong143shen@163.com", "UTF-8"));

            // 3. To: 收件人（可以增加多个收件人、抄送、密送）

            message.setRecipient(MimeMessage.RecipientType.TO, new InternetAddress(receiveMail, "yuanhong143shen@163.com", "UTF-8"));

            // 4. Subject: 邮件主题
            message.setSubject("你的验证码为", "UTF-8");

            // 5. Content: 邮件正文（可以使用html标签）
            message.setContent(body, "text/html;charset=UTF-8");

            // 6. 设置发件时间
            message.setSentDate(new Date());

            // 7. 保存设置
            message.saveChanges();

        } catch (MessagingException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        }

    }
    public void send(){
        try{
            Transport.send(message,"yuanhong143shen@163.com","Iwantslq1314");
            System.out.println("send success");
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
    @Override
    public void run() {
        send();
    }

}


