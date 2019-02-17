package com.students.Interceptor;

import com.students.entity.User;
import com.sun.deploy.net.HttpResponse;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.List;


public class StudentManInterceptor implements HandlerInterceptor {
    @Override
    public boolean preHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o) throws Exception {
        HttpSession session = httpServletRequest.getSession(true);
        User obj = (User) session.getAttribute("user");
        if (obj == null || "".equals(obj.toString())) {
            httpServletResponse.setCharacterEncoding("UTF-8");
            httpServletResponse.setHeader("content-type", "text/html;charset=UTF-8");
            httpServletResponse.getWriter().print("<script>alert('你没有登录或者身份过期！请重新登录！');</script>");
            httpServletResponse.sendRedirect("/login/show");
            return false;
        }
        String identity = obj.getIdentity();
        if("管理员".equals(identity)){
            identity = "admin";
        }else if("教职工".equals(identity)){
            identity = "teacher";
        }
        if(obj == null || identity == null || identity.length() <= 0){
            httpServletResponse.setCharacterEncoding("UTF-8");
            httpServletResponse.setHeader("content-type", "text/html;charset=UTF-8");
            httpServletResponse.getWriter().print("<script>alert('你没有登录或者身份过期！请重新登录！');</script>");
            httpServletResponse.sendRedirect("/login/show");
            return false;
        }

        String url = httpServletRequest.getRequestURI();
        String[] matchurl = url.split("/");
        System.out.println("权限："+matchurl[2]);
        if("admin".equals(matchurl[2])){
            if(identity.equals(matchurl[2])){
                return true;
            }else {
                httpServletResponse.setCharacterEncoding("UTF-8");
                httpServletResponse.setHeader("content-type", "text/html;charset=UTF-8");
                httpServletResponse.getWriter().print("<script>alert('小伙子你路走窄了');window.history.back(-1);</script>");
                return false;
            }
        }
        if("indexloadTeacherInfo".equals(matchurl[1]+matchurl[2])){
            if(!obj.getClassNum().equals(matchurl[3])){
                httpServletResponse.setCharacterEncoding("UTF-8");
                httpServletResponse.setHeader("content-type", "text/html;charset=UTF-8");
                httpServletResponse.getWriter().print("<script>alert('小伙子你想偷窥别的班的信息啊？');window.history.back(-1);</script>");
                return false;
            }else {
                return true;
            }
        }
        if("indexloadClassinfo".equals(matchurl[1]+matchurl[2])){
            String[] marchurlparm = matchurl[3].split("&");
            if(!obj.getClassNum().equals(marchurlparm[0])){
                httpServletResponse.setCharacterEncoding("UTF-8");
                httpServletResponse.setHeader("content-type", "text/html;charset=UTF-8");
                httpServletResponse.getWriter().print("<script>alert('小伙子你想偷窥别的班的信息啊？');window.history.back(-1);</script>");
                return false;
            }else {
                return true;
            }
        }
        if("indexloadTestInfoTable".equals(matchurl[1]+matchurl[2])){
            String[] marchurlparm = matchurl[3].split("&");
            if(!obj.getClassNum().equals(marchurlparm[0])){
                httpServletResponse.setCharacterEncoding("UTF-8");
                httpServletResponse.setHeader("content-type", "text/html;charset=UTF-8");
                httpServletResponse.getWriter().print("<script>alert('小伙子你想偷窥别的班的信息啊？');window.history.back(-1);</script>");
                return false;
            }else {
                return true;
            }
        }
        if("indexloadCourseTable".equals(matchurl[1]+matchurl[2])){
            String[] marchurlparm = matchurl[3].split("&");
            if(!obj.getClassNum().equals(marchurlparm[1])){
                httpServletResponse.setCharacterEncoding("UTF-8");
                httpServletResponse.setHeader("content-type", "text/html;charset=UTF-8");
                httpServletResponse.getWriter().print("<script>alert('小伙子你想偷窥别的班的信息啊？');window.history.back(-1);</script>");
                return false;
            }else {
                return true;
            }
        }
        if("indexdownExcelofTestinfo".equals(matchurl[1]+matchurl[2])){
            String[] marchurlparm = matchurl[3].split("&");
            if(!obj.getClassNum().equals(marchurlparm[0])){
                httpServletResponse.setCharacterEncoding("UTF-8");
                httpServletResponse.setHeader("content-type", "text/html;charset=UTF-8");
                httpServletResponse.getWriter().print("<script>alert('小伙子你想偷窥别的班的信息啊？');window.history.back(-1);</script>");
                return false;
            }else {
                return true;
            }
        }

        System.out.println("请求的url"+url);
        return true;
    }

    @Override
    public void postHandle(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, ModelAndView modelAndView) throws Exception {

    }

    @Override
    public void afterCompletion(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse, Object o, Exception e) throws Exception {

    }

}
