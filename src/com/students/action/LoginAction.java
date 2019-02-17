package com.students.action;

import com.students.entity.User;
import com.students.service.UserService;
import com.students.service.impl.UserServiceImpl;
import com.students.util.*;
import net.sf.json.JSONObject;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;
import java.security.KeyPair;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

@RequestMapping("/login")
@Controller
public class LoginAction {
    private Properties rsaProperties;
    private Map<String,String> mailmap = new HashMap<>();
    @RequestMapping("/show")
    public String show(){
        return "login";
    }

    @RequestMapping("/code")
    public String showcode(){
        return "showcode";
    }

    @ResponseBody
    @RequestMapping(value = "/loginRsa",method = RequestMethod.POST)
    public Object checkName(@RequestParam("name") String name, @RequestParam("password") String password,@RequestParam("code")String code,HttpServletRequest request) throws Exception {
        JSONObject result = new JSONObject();
        if(name.trim().length() > 0 && password.trim().length() > 0 && code.trim().length() > 0) {
            try {
                rsaProperties = LoadProperties.getProperties(LoginAction.class, "rsaPath.properties");

                result = (JSONObject) RSAUtil.RSA(rsaProperties.getProperty("loginRsaPath"), request);
                return result;
            } catch (Exception e) {
                e.printStackTrace();
                result.put("error", 404);
                return result;
            }
        }else {
            result.put("error",500);
            return result;
        }

    }

    @ResponseBody
    @RequestMapping(value = "/forgetRsa",method = RequestMethod.POST)
    public Object checkForget(HttpServletRequest request) throws Exception {

        JSONObject result = new JSONObject();
        try{
            rsaProperties = LoadProperties.getProperties(LoginAction.class,"rsaPath.properties");
            result = (JSONObject) RSAUtil.RSA(rsaProperties.getProperty("ForgetRsaPath"),request);
            return result;
        }catch (Exception e){
            e.printStackTrace();
            result.put("error",404);
            return result;
        }

    }


    @ResponseBody
    @RequestMapping(value = "/loginCheck",method = RequestMethod.POST)
    public Integer login(@RequestParam("name") String name, @RequestParam("password") String password,@RequestParam("code")String code,HttpServletRequest request) throws Exception {
        if(name.trim().length() > 0 && password.trim().length() >= 0 && code.trim().length() > 0){
            String showcode = request.getSession().getAttribute("showcode").toString();
            UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
            try{
                rsaProperties = LoadProperties.getProperties(LoginAction.class,"rsaPath.properties");
                String pwd = RSAUtil.decryptRSA(password,rsaProperties.getProperty("loginRsaPath"));
                System.out.println("用户名："+name);
                User user = userService.findUserInfo(name);
                if(user != null && user.getPassWord().equals(pwd.toString()) && user.getU_status() == 1 && code.equals(showcode)){
                    return 600;
                }else {
                    return 300;
                }

            }catch (Exception e){
                e.printStackTrace();
                return 100;
            }
        }else {
            return 200;
        }

    }

    @ResponseBody
    @RequestMapping(value = "/forgetMail",method = RequestMethod.POST)
    public Integer forgetMail(@RequestParam("foremail") String foremail){
        try{
            MailPool mailPool = null;
            MailUtil mailUtil;
            if(foremail.trim().length() > 0 && MailUtil.checkEmail(foremail)){
                UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
                String code = CodeUtil.getCode();
                User user1 = userService.findUserInfo(foremail);
                if(user1 != null && foremail.equals(user1.getEmail()) && user1.getU_status() == 1) {
                    mailUtil = new MailUtil(foremail, code);
                    mailPool = new MailPool();
                    mailPool.send(mailUtil);
                    mailmap.put(foremail, code);
                    mailPool.close();
                    return 300;
                }else {
                    return 200;
                }
            }else {
                return 400;
            }
        }catch (Exception e){
            e.printStackTrace();
            return 100;
        }
    }
    @ResponseBody
    @RequestMapping(value = "/forgetAction",method = RequestMethod.POST)
    public Integer forgetAction(@RequestParam("foremail") String foremail,@RequestParam("forpassword") String forpassword,@RequestParam("foremailCode") String foremailCode){
        if(foremail.trim().length() > 0 && forpassword.trim().length() > 0  && foremailCode.trim().length() > 0 && MailUtil.checkEmail(foremail)){
            try{
                UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
                User user1 = userService.findUserInfo(foremail);
                String codes = mailmap.get(foremail);
                if(foremailCode.equalsIgnoreCase(codes)){
                    if(user1 != null && foremail.equals(user1.getEmail()) && user1.getU_status() == 1){
                        User user = new User();
                        String pwd = RSAUtil.decryptRSA(forpassword,rsaProperties.getProperty("ForgetRsaPath"));
                        if(pwd.trim().length() >= 6 && pwd.trim().length() < 17){
                            System.out.println(pwd);
                            user.setEmail(foremail);
                            user.setPassWord(pwd);
                            Integer p = userService.updateForget(user);
                            if(p == 0){
                                return 600;
                            }else {
                                return 700;
                            }
                        }else {
                            return 800;
                        }
                    }else {
                        return 200;
                    }
                }else {
                    return 100;
                }
            }catch (Exception e){
                e.printStackTrace();
                return 300;
            }
        }else {
            return 400;
        }
    }

    @RequestMapping(value = "/loginAction",method = RequestMethod.POST)
    public String login(@RequestParam("name") String name, HttpSession session, Model model){
        UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);

        User user = userService.findUserInfo(name);

//        model.addAttribute("user",user);
        session.setAttribute("user",user);
//        model.addAttribute("user",user);
        return "redirect:/index/show";
    }

}
