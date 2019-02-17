package com.students.action;

import com.students.entity.User;
import com.students.service.UserService;
import com.students.service.impl.UserServiceImpl;
import com.students.util.*;
import net.sf.json.JSONObject;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.security.KeyPair;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.util.*;

@RequestMapping("/regist")
@Controller
public class RegistAction {
    private Properties rsaproperties;
    private Map<String,String> mailmap = new HashMap<>();
    @ResponseBody
    @RequestMapping(value = "/sendmail",method = RequestMethod.POST)
    public Integer sendmail(@RequestParam("peoNum") String peoNum, @RequestParam("email") String email) throws Exception {
        try{
            MailPool mailPool = null;
            MailUtil mailUtil;
            if(peoNum.trim().length() > 0 || email.trim().length() > 0 || MailUtil.checkEmail(email)){
                UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
                String code = CodeUtil.getCode();
                User user1 = userService.findUserInfo(peoNum);
                System.out.println(email);
                System.out.println(code);
                if(user1 != null && email.equals(user1.getEmail()) && user1.getU_status() == 0){
                        mailUtil = new MailUtil(email,code);
                        mailPool = new MailPool();
                        mailPool.send(mailUtil);
                        mailmap.put(email,code);
                        mailPool.close();
                        return 300;
                }else {
                    System.out.println("错误");
                    return 500;
                }
            }else {
                System.out.println("邮箱输入格式有误或为空");
                return 200;
            }
        }catch (Exception e){
            e.printStackTrace();
            return 500;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/registRsa",method = RequestMethod.POST)
    public Object checkName(@RequestParam("repassword")String repassword,HttpServletRequest request) throws Exception {
        JSONObject result = new JSONObject();
        if(repassword.trim().length() >= 6 && repassword.trim().length() <= 16){
            try{
                rsaproperties = LoadProperties.getProperties(RegistAction.class,"rsaPath.properties");
                result = (JSONObject) RSAUtil.RSA(rsaproperties.getProperty("regRsaPath"),request);
                return result;
            }catch (Exception e){
                e.printStackTrace();
                result.put("error",404);
                return result;
            }
        }else {
            result.put("error",505);
            return result;
        }
    }

    @ResponseBody
    @RequestMapping(value = "/active",method = RequestMethod.POST)
    public Integer active(@RequestParam("reguname")String reguname,
                          @RequestParam("repassword")String repassword,
                          @RequestParam("peoNum") String peoNum,
                          @RequestParam("email") String email,
                          @RequestParam("emailCode") String emailCode,
                          HttpServletResponse response) throws Exception{
        try{
            response.setContentType("text/html;charset=utf-8");
            String codes = mailmap.get(email);
            System.out.println(peoNum);
            System.out.println(reguname);
            System.out.println(repassword);
            System.out.println(email);
            System.out.println(emailCode);
            if(peoNum.trim().length() != 0 && email.trim().length() != 0 && MailUtil.checkEmail(email)){
                if(reguname.trim().length() != 0 && reguname.trim().length() < 17){
                    UserService userService = SpringBeanHolder.getBean(UserService.class);
                    Integer isKnow = userService.findRUserName(reguname);
                    System.out.println(isKnow);
                    User user1 = userService.findUserInfo(peoNum);
                    if(codes.equalsIgnoreCase(emailCode)){
                        if(isKnow == null){
                            if(user1 != null && email.equals(user1.getEmail()) && user1.getU_status() == 0){
                                rsaproperties = LoadProperties.getProperties(RegistAction.class,"rsaPath.properties");
                                String pwd = RSAUtil.decryptRSA(repassword,rsaproperties.getProperty("regRsaPath"));
                                if(pwd.trim().length() >= 6 && pwd.trim().length() < 17){
                                    User user = new User();
                                    user.setPeoNum(peoNum);
                                    user.setR_userName(reguname);
                                    user.setPassWord(pwd);
                                    user.setRetime(new Date());
                                    user.setU_status(1);
                                    List<User> list =new ArrayList<>();
                                    list.add(user);
                                    Integer updateRe = userService.updateActive(list);
                                    System.out.println(updateRe);
                                    if(updateRe == 0){
                                        return 600;
                                    }else {
                                        return 700;
                                    }
                                }else {
                                    return 800;
                                }

                            }else {
                                return 500;
                            }
                        }else {
                            return 100;
                        }
                    }else {
                        return 300;
                    }
                }else {
                    return 800;
                }

            }else{
                return 200;
            }
        }catch (Exception e){
            e.printStackTrace();
        }
       return 10;
    }

}
