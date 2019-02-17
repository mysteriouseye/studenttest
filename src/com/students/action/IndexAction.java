package com.students.action;

import com.github.pagehelper.PageHelper;
import com.github.pagehelper.PageInfo;
import com.students.entity.*;
import com.students.service.*;
import com.students.service.impl.*;
import com.students.util.*;
import net.sf.json.JSONObject;
import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Workbook;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.jsp.PageContext;
import java.io.*;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import static org.springframework.http.MediaType.MULTIPART_FORM_DATA_VALUE;

@RequestMapping("/index")
@Controller
public class IndexAction {
    private Properties rsaproperties;
    /*===================================统一请求页面===================================================*/
    @RequestMapping("/show")
    public String show(){
        return "index";
    }
    @RequestMapping("/classinfo")
    public String info(){
        return "classinfo";
    }
    @RequestMapping("/teacherinfo")
    public String teacherinfo(){
        return "teacherinfo";
    }
    @RequestMapping("/coursetable")
    public String coursetable(){
        return "coursetable";
    }
    @RequestMapping("/eotashow")
    public String eotashow(){
        return "eotashow";
    }
    @RequestMapping("/message")
    public String message(Model model,HttpSession session){
        User user = (User) session.getAttribute("user");
        MessageService messageService = SpringBeanHolder.getBean(MessageServiceImpl.class);
        try{
            if("学生".equals(user.getIdentity()) || "教职工".equals(user.getIdentity())){
                List<MessageTable> list = messageService.findUserMessage(user.getUid());
                model.addAttribute("messagetable",list);
                return "message";
            }else {
                List<MessageTable> list = messageService.adminselectAllMessage();
                model.addAttribute("messagetable",list);
                return "message";
            }
        }catch (Exception e){
            e.printStackTrace();
            return "message";
        }
    }
    @RequestMapping("/exitLogin")
    public String exitLogin(HttpSession session){
        session.removeAttribute("user");
        session.invalidate();
        return "redirect:/login/show";
    }

    @ResponseBody
    @RequestMapping(value = "/loadUserinfo/",method = RequestMethod.POST)
    public User loadUserinfo(HttpSession session){
        UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
        User user1 = (User) session.getAttribute("user");
        User user = userService.findUserInfo(user1.getPeoNum());
        user.setPassWord("你想知道密码？就不告诉你！");
        session.setAttribute("user",user);
        return user;
    }
    @ResponseBody
    @RequestMapping(value = "/updateUserinfo",method = RequestMethod.POST)
    public Integer updateUserinfo(@RequestParam("r_userName")String r_userName,
                                  @RequestParam("email")String email,
                                  @RequestParam("signed")String signed, HttpSession session) throws Exception {
        if(r_userName.trim().length() <= 16 && MailUtil.checkEmail(email)){
            User user1 = (User) session.getAttribute("user");
            UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
            User user = new User();
            if (r_userName.trim().length() == 0){
                user.setR_userName(user1.getR_userName());
            }else {
                user.setR_userName(r_userName);
            }
            if(email.trim().length() == 0){
                user.setEmail(user1.getEmail());
            }else {
                user.setEmail(email);
            }
            if(signed.trim().length() == 0){
                user.setSigned(user1.getSigned());
            }else {
                user.setSigned(signed);
            }
            if(userService.indexcheckUser(user).size() == 0){
                user.setUid(user1.getUid());
                try{
                    if(userService.IndexUpdateUserinfo(user) == 0){
                        return 100;
                    }else {
                        return 600;
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    return 300;
                }
            }else {
                return 700;
            }
        }else {
            return 800;
        }

    }
    @ResponseBody
    @RequestMapping(value = "/upRsa",method = RequestMethod.POST)
    public Object upRsa(HttpServletRequest request){
        JSONObject result = new JSONObject();
        try{
            rsaproperties = LoadProperties.getProperties(IndexAction.class,"rsaPath.properties");
            result = (JSONObject) RSAUtil.RSA(rsaproperties.getProperty("IndexRsaPath"),request);
            return result;
        }catch (Exception e){
            e.printStackTrace();
            result.put("error",404);
            return result;
        }
    }
    @ResponseBody
    @RequestMapping(value = "/updateUserPass",method = RequestMethod.POST)
    public Integer updateUserPass(@RequestParam("old_password")String old_Password,
                                  @RequestParam("new_password")String new_passowrd,
                                  @RequestParam("new_re_passowrd")String new_re_password,
                                  HttpSession session) throws Exception {
        User user1 = (User) session.getAttribute("user");

        if(user1.getPeoNum().trim().length() > 0) {
            if (old_Password.trim().length() != 0 && new_passowrd.trim().length() != 0 && new_re_password.trim().length() != 0) {
                UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
                try {
                    rsaproperties = LoadProperties.getProperties(IndexAction.class, "rsaPath.properties");
                    String old_pwd = RSAUtil.decryptRSA(old_Password, rsaproperties.getProperty("IndexRsaPath"));
                    String new_pwd = RSAUtil.decryptRSA(new_passowrd, rsaproperties.getProperty("IndexRsaPath"));
                    String new_re_pwd = RSAUtil.decryptRSA(new_re_password, rsaproperties.getProperty("IndexRsaPath"));
                    if(old_pwd.trim().length() >= 6 && old_pwd.trim().length() <17 && new_pwd.trim().length() >= 6 && new_pwd.trim().length() < 17 && new_re_pwd.trim().length() >= 6 && new_re_pwd.trim().length() < 17){
                        System.out.println("xinmim:" + new_pwd);
                        System.out.println("remi:" + new_re_pwd);
                        User user = userService.findUserInfo(user1.getEmail());
                        if (old_pwd.equals(user.getPassWord())) {
                            if (new_pwd.equals(new_re_pwd)) {
                                User user2 = new User();
                                user2.setEmail(user1.getEmail());
                                user2.setPassWord(new_pwd);
                                if (userService.updateForget(user2) == 0) {
                                    return 100;  //失败
                                } else {
                                    session.removeAttribute("user");
                                    session.invalidate();
                                    return 600;  //成功
                                }
                            } else {
                                return 300;//两次输入密码不相同
                            }
                        } else {
                            return 400;//旧密码不正确
                        }
                    }else {
                        return 800;//格式有问题
                    }

                } catch (Exception e) {
                    e.printStackTrace();
                    return 500;//解密错误
                }
        }
            return 200; //不能为空
        }
        return 700; //身份过期
    }
    @ResponseBody
    @RequestMapping(value = "/getTestInfo",method = RequestMethod.POST)
    public List<TestName> getTestInfo(){
        TestService testService = SpringBeanHolder.getBean(TestServiceImpl.class);
        try {
            return testService.getTestInfo();
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    @ResponseBody
    @RequestMapping("/upHeadFile")
    public Integer upHeadFile(@RequestParam("file")CommonsMultipartFile file,@RequestParam("peoNum")String peoNum) throws IOException {
        if(file != null){
            if(peoNum != ""){
                String filename = file.getOriginalFilename();
                System.out.println(peoNum);
                System.out.println("fileName:"+file.getOriginalFilename());
                String houzhou = filename.trim().substring(filename.lastIndexOf('.') + 1);
                System.out.println(houzhou);
                if("jpg".equalsIgnoreCase(houzhou) || "jpeg".equalsIgnoreCase(houzhou) || "bmp".equalsIgnoreCase(houzhou) || "gif".equalsIgnoreCase(houzhou) || "png".equalsIgnoreCase(houzhou)){
                    String filenames = UUID.randomUUID() + filename;
                    String path = System.getProperty("evan.webapp") +"/img/"+filenames;
                    System.out.println(path);
                    FileService fileService = SpringBeanHolder.getBean(FileServiceImpl.class);
                    try {
                        File file1 = new File(path);
                        file.transferTo(file1);
                        User user = new User();
                        user.setHeadIco("/img/"+filenames);
                        user.setPeoNum(peoNum);
                        Integer po = fileService.uploadHeadFile(user);
                        if(po == 0){
                            return 500;
                        }else {
                            return 600; //成功
                        }
                    }catch (Exception e){
                        e.printStackTrace();
                        return 500; //文件创建异常
                    }
                }else {
                    return 300; //文件非图片文件
                }
            }else {
                return 700; //身份过期
            }
        }else {
            return 400; //文件不为空
        }
    }

    /*===============================学生请求============================================================*/
    @RequestMapping(value = "/loadClassinfo/{classNum}&{pageNum}")
    public String loadClassInfo(@PathVariable("classNum")String classNum,@PathVariable("pageNum")Integer pageNum, Model model){
        List<User> list = new ArrayList<User>();
        if(classNum.trim().length() != 0){
            UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
            try {
                PageHelper.startPage(pageNum,12);
                List<User> listPage = new ArrayList<>();
                listPage = userService.loadClassInfo(classNum);
                PageInfo<User> pageInfo = new PageInfo<User>(listPage);
                System.out.println(pageInfo);
                System.out.println(listPage);
                list = userService.loadClassInfo(classNum);
                model.addAttribute("pageinfo",pageInfo);
                model.addAttribute("classinfo",list);
                model.addAttribute("classinfopage",listPage);
                return "classinfo";
            } catch (Exception e) {
                e.printStackTrace();
                return null;
            }
        }else {
            return null;
        }
    }

    @RequestMapping("/loadTeacherInfo/{classNum}")
    public String loadTeacherInfo(@PathVariable("classNum")String classNum,Model model){
        List<User> list = new ArrayList<User>();
        if(classNum.trim().length() != 0){
            UserService service = SpringBeanHolder.getBean(UserServiceImpl.class);
            try{
                list = service.selectClassTeacherInfo(classNum);
                model.addAttribute("teacherinfo",list);
                return "teacherinfo";
            }catch (Exception e){
                e.printStackTrace();
                return null;
            }
        }else {
            return null;
        }
    }

    @RequestMapping("/loadCourseTable/{year}&{classNum}")
    public String loadCourseTable(@PathVariable("year")Integer year,@PathVariable("classNum")String classNum,Model model){
        if(year != null && classNum.trim().length() > 0){
            List<CourseTable> list = new ArrayList<>();
            try{
                CourseService courseService = SpringBeanHolder.getBean(CourseServiceImpl.class);
                list = courseService.findAllCourseByClassNumWithYear(year,classNum);
                model.addAttribute("coursetable",list);
                return "coursetable";
            }catch (Exception e){
                e.printStackTrace();
                return null;
            }
        }else {
            return null;
        }
    }
    @RequestMapping("/loadTestInfoTable/{classNum}&{test_id}")
    public String loadTestInfoTable(@PathVariable("classNum")String classNum,@PathVariable("test_id")Integer test_id,Model model){
        System.out.println(classNum);
        System.out.println(test_id);
        if(classNum.trim().length() != 0 && test_id != null){
            List<TestTable> list = new ArrayList<>();
            try{
                TestService service = SpringBeanHolder.getBean(TestServiceImpl.class);
                list = service.getTestInfoOfStudents(classNum,test_id);
                System.out.println(list);
                for(TestTable testTable : list){
                    System.out.println(testTable.getChinese());
                }
                model.addAttribute("testtableinfo",list);
                return "eotashow";
            }catch (Exception e){
                e.printStackTrace();
                return null;
            }
        }else {
            return null;
        }
    }

    @RequestMapping("/downExcelofTestinfo/{classNum}&{test_id}")
    public String downExcelTestInfo(@PathVariable("classNum")String classNum,
                                    @PathVariable("test_id")Integer test_id,HttpServletResponse response){
        if(classNum.trim().length() != 0 && test_id != null){
            try{
                TestService testService = SpringBeanHolder.getBean(TestServiceImpl.class);
                String[] headers = new String[]{"考试场次","序号","姓名","班级","学号","语文","数学","英语","物理","化学","生物","政治","历史","地理","总分"};
                List<TestTable> list = testService.getTestInfoOfStudents(classNum,test_id);
                if(list.size() > 0){
                    List<Map<Integer,Object>> datalist = ExcelUtil.manageList(list);
                    Workbook wb = new HSSFWorkbook();
                    ExcelUtil.fillExcelSheetData(datalist,wb,headers,"sheet01");
                    WebUtil.downloadExcel(response,wb,"成绩单.xls");
                    return "正在开始下载...";
                }else {
                    return null;
                }
            }catch (Exception e){
                e.printStackTrace();
            }
        }else {
            return null;
        }
        return null;
    }
    @ResponseBody
    @RequestMapping(value = "/getAllCourseYear",method = RequestMethod.POST)
    public Integer[] getAllCourseYear(){
        CourseService courseService = SpringBeanHolder.getBean(CourseServiceImpl.class);
        try {
            return courseService.findAllCourseYear().toArray(new Integer[0]);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
    @ResponseBody
    @RequestMapping(value = "/addNewMessage",method = RequestMethod.POST)
    public String addNewMessage(@RequestParam("title")String title,@RequestParam("message")String message,HttpSession session){
        if(title.trim().length() > 0 && title.trim().length() <= 30 && message.trim().length() > 0 && message.trim().length() <= 500){
            MessageService messageService = SpringBeanHolder.getBean(MessageServiceImpl.class);
            MessageTable messageTable = new MessageTable();
            messageTable.setTitle(title);
            messageTable.setMes(message);
            User user = (User) session.getAttribute("user");
            messageTable.setUid(user.getUid());
            try {
                messageService.addNewMessage(messageTable);
                return "提交留言成功，请等待管理员阅读!";
            } catch (Exception e) {
                e.printStackTrace();
                return "服务器错误，插入失败!";
            }
        }else {
            return "标题和内容不可为空或标题不可长于三十位，内容不可长于500位!";
        }
    }
    /*======================================管理员请求=================================================================*/
    @ResponseBody
    @RequestMapping(value = "/admin/GetAllUser",method = RequestMethod.POST)
    public String GetAllUser(@RequestParam("pageNum")Integer pageNum, HttpSession session){
        UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
        try{
            List<User> list = userService.AdminfindAllUserinfo();
            PageHelper.startPage(pageNum,20);
            List<User> listPage = new ArrayList<>();
            listPage = userService.AdminfindAllUserinfo();
            PageInfo<User> pageInfo = new PageInfo<User>(listPage);
            session.setAttribute("pageuserinfo",listPage);
            session.setAttribute("pageinfo",pageInfo);
            session.setAttribute("alluserinfo",list);
            return "/index/admin";
        }catch (Exception e){
            e.printStackTrace();
            return "/index/admin";
        }
    }
    @RequestMapping("/admin")
    public String admin()
    {
        return "admin";
    }

    @RequestMapping("/admin/eota")
    public String eota(Model model){
        try{
            TestService testService = SpringBeanHolder.getBean(TestServiceImpl.class);
            List<TestName> list = testService.getTestInfo();
            System.out.println(list);
            model.addAttribute("testinfo",list);
            return "eota";
        }catch (Exception e){
            e.printStackTrace();
            return "eota";
        }
    }

    @ResponseBody
    @RequestMapping(value = "/admin/upUserExcelFile",method = RequestMethod.POST)
    public String upCsvFile(@RequestParam("files") MultipartFile[] files,HttpServletRequest request){
        BaseResponse response = new BaseResponse<>(StatusCode.Success);
        if(files != null && files.length > 0){
            Integer p = 0;
            System.out.println(files.length);
            for(int i = 0;i<files.length;i++){
                MultipartFile file = files[i];
                try{
                    if(file == null || file.getName() == null){
                        return "<script>alert('失败,可能你没有选择文件或是数据有误');window.location.href = document.referrer;</script>"; //异常
                    }
                    String fileName = file.getOriginalFilename();
                    String suffix = StringUtils.substring(fileName,fileName.lastIndexOf(".")+1);
                    if(WorkBookVersion.valueofSuffix(suffix) == null){
                        return "<script>alert('失败,可能你没有选择文件或是数据有误');window.location.href = document.referrer;</script>"; //异常
                    }
                    System.out.println("文件名｛"+fileName+"}"+"文件后缀名：｛"+suffix+"}");

                    Uploadpoi uploadpoi = new Uploadpoi();
                    Workbook wb =  uploadpoi.getWorkbooj(file,suffix);
                    List<User> users = uploadpoi.readExcelDataOfUser(wb);
                    UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
                    for (User user : users){
                        System.out.println(user.getSex().trim());
                        System.out.println("男".equals(user.getSex().trim()));
                        System.out.println(user.getEmail());
                        System.out.println(MailUtil.checkEmail(user.getEmail()));
                        if("男".equals(user.getSex().trim()) || "女".equals(user.getSex().trim())){
                            if(MailUtil.checkEmail(user.getEmail())){
                                if("教职工".equals(user.getIdentity().trim()) || "学生".equals(user.getIdentity().trim())){
                                    if(userService.checkUserIsKnown(user).size() > 0){
                                        p = userService.updateKnownUser(user);
                                    }else {
                                        p = userService.insertUserinfo(user);
                                    }
                                }else {
                                    return "<script>alert('失败,表内身份参数有个别有误！请注意不可直接添加管理员！');window.location.href = document.referrer;</script>";
                                }
                            }else {
                                return "<script>alert('失败,表内邮箱参数有个别有误！');window.location.href = document.referrer;</script>";
                            }
                        }else {
                            return "<script>alert('失败,表内性别有个别有误！');window.location.href = document.referrer;</script>";
                        }
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    return "<script>alert('失败,可能你没有选择文件或是数据有误');window.location.href = document.referrer;</script>"; //异常
                }
            }
            if (p == 0){
                return "<script>alert('失败,可能你没有选择文件或是数据有误');window.location.href = document.referrer;</script>"; //异常
            }else {
                return "<script>alert('成功！');window.location.href = document.referrer;</script>"; //异常
            }
        }else {
            return "<script>alert('失败,可能你没有选择文件或是数据有误');window.location.href = document.referrer;</script>"; //异常
        }
    }

    @RequestMapping("/admin/downExcelofUserinfo/")
    public String admindownExcelUserInfo(HttpServletResponse response){
            try{
                UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
                String[] headers = new String[]{"个性昵称","姓名","年龄","性别","班级/任教班级","身份","学号/工号","邮箱","手机号","个性签名"};
                List<User> list = userService.AdminfindAllUserinfo();
                if(list.size() > 0){
                    List<Map<Integer,Object>> datalist = ExcelUtil.manageListOfUser(list);
                    Workbook wb = new HSSFWorkbook();
                    ExcelUtil.fillExcelSheetData(datalist,wb,headers,"sheet01");
                    WebUtil.downloadExcel(response,wb,"人员名单.xls");
                    return "正在开始下载...";
                }else {
                    return null;
                }
            }catch (Exception e){
                e.printStackTrace();
            }
        return null;
    }

    @ResponseBody
    @RequestMapping(value = "/admin/updateInfo",method = RequestMethod.POST)
    public Integer updateInfo(User user) throws Exception {
        if(user.getUserName().trim().length() != 0 && user.getAge() != null && user.getSex().trim().length() != 0 && user.getClassNum().trim().length() != 0 && user.getIdentity().trim().length() != 0 && user.getPeoNum().trim().length() != 0 && user.getEmail().trim().length() != 0 && MailUtil.checkEmail(user.getEmail()) && user.getPhoneNum().trim().length() != 0){
            UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
            User user1 = new User();
            user1.setPeoNum(user.getPeoNum());
            user1.setR_userName(user.getR_userName());
            user1.setEmail(user.getEmail());
            List<User> checklist = userService.checkadmininsert(user1);
            System.out.println(checklist);
            if(checklist.size() == 0){
                try{
                    System.out.println(user.getUserName());
                    Integer p = userService.adminInsertInfo(user);
                    if(p == 0){
                        return 300; //异常
                    }else {
                        return 600; //成功
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    return 300; //异常
                }
            }else {
                return 700; //存在的用户名或工号
            }

        }else {
            return 400;//为空或格式错误
        }

    }
    @ResponseBody
    @RequestMapping(value = "/admin/getAllClassNum",method = RequestMethod.POST)
    public String[] getAllClassNum() throws Exception{
        UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
        return userService.getAllClassNum().toArray(new String[0]);
    }

    @ResponseBody
    @RequestMapping("/admin/addNewTest")
    public String addNewTest(@RequestParam("classNum")String classNum,@RequestParam("testname")String testname) throws Exception {
        System.out.println(classNum);
        System.out.println(testname);
        if(classNum.trim().length() != 0 && testname.trim().length() != 0){
            if("全部班级".equals(classNum)){
                TestService testService = SpringBeanHolder.getBean(TestServiceImpl.class);
                UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
                try{
                    Integer p = testService.addNewTestName(testname);
                    if(p == 0){
                        return "插入数据错误！请重试！";//插入错误
                    }else {
                        Integer l = testService.getTestId(testname);
                        if(l != null){
                            List<User> list = userService.getAllClassNumPeoNumNoDis();
                            TestTable testTable = new TestTable();
                            for(User user : list){
                                testTable.setPeoNum(user.getPeoNum());
                                testTable.setTest_id(l);
                                testTable.setClassNum(user.getClassNum());
                                testService.addNewTest(testTable);
                            }
                            return "添加成功!";//成功
                        }else {
                            return "考试场次不存在！";//考试场次不存在
                        }
                    }
                }catch (Exception e){
                    e.printStackTrace();
                    return "插入数据异常！请检查重试";//异常
                }
            }else{
                Pattern pattern = Pattern.compile("[0-9]*");
                Matcher isNum = pattern.matcher(classNum);
                if(!isNum.matches()){
                    return "提交的班级号非数字！"; //非数字
                }else {
                    TestService testService = SpringBeanHolder.getBean(TestServiceImpl.class);
                    UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
                    Integer p = testService.addNewTestName(testname);
                    if(p == 0){
                        return "插入场次数据错误！请重试！";//插入错误
                    }else {
                        Integer l = testService.getTestId(testname);
                        List<User> user = userService.getClassNumPeoNum(classNum);
                        if(user != null){
                            TestTable testTable = new TestTable();
                            for(User user1 : user){
                                testTable.setPeoNum(user1.getPeoNum());
                                testTable.setClassNum(user1.getClassNum());
                                testTable.setTest_id(l);
                                testService.addNewTest(testTable);
                            }
                            return "添加成功!";//成功
                        }else {
                            return "班级号不存在!请查证再试！";//班级号不存在
                        }
                    }
                }
            }
        }else {
            return "数据不能为空！";//不能为空
        }
    }
    @ResponseBody
    @RequestMapping(value = "/admin/eotadel",method = RequestMethod.POST)
    public String eotadel(@RequestParam("test_id") Integer test_id){
        if(test_id != null){
            TestService testService = SpringBeanHolder.getBean(TestServiceImpl.class);
            try{
                Integer p = testService.eotaDel(test_id);
                Integer p2 = testService.eotaDel2(test_id);
                System.out.println(p);
                return "成功!";
            }catch (Exception e){
                e.printStackTrace();
                return "出错!请重试!";//出错
            }
        }else {
            return "班级号不能为空！";//为空
        }
    }
    @ResponseBody
    @RequestMapping(value = "/admin/eotaupdate",method = RequestMethod.POST)
    public String eotaupdate(@RequestParam("test_name")String test_name,@RequestParam("test_id")Integer test_id){
        if(test_name.trim().length() != 0 && test_id != null){
            TestService testService = SpringBeanHolder.getBean(TestServiceImpl.class);
            try{
                Integer p = testService.eotaUpdate(test_name,test_id);
                if(p == 0){
                    return "修改失败！请重试！";
                }else {
                    return "修改成功!";
                }
            }catch (Exception e){
                e.printStackTrace();
                return "数据修改时发生异常！请重试！";
            }
        }else {
            return "数据不可为空！";
        }
    }

    @SuppressWarnings("rawtypes")
    @RequestMapping(value = "/admin/uploadExcelofTestinfo",method = RequestMethod.POST,consumes = MULTIPART_FORM_DATA_VALUE)
    @ResponseBody
    public BaseResponse uploadExcelofTestinfo(MultipartHttpServletRequest request){
        BaseResponse response = new BaseResponse<>(StatusCode.Success);
        try{
            MultipartFile file = request.getFile("testTableFile");
            if(file == null || file.getName() == null){
                return new BaseResponse<>(StatusCode.Invalid_Param);
            }
            String fileName = file.getOriginalFilename();
            String suffix = StringUtils.substring(fileName,fileName.lastIndexOf(".")+1);
            if(WorkBookVersion.valueofSuffix(suffix) == null){
                return new BaseResponse<>(StatusCode.WorkBook_Version_Invalid);
            }
            System.out.println("文件名｛"+fileName+"}"+"文件后缀名：｛"+suffix+"}");

            Uploadpoi uploadpoi = new Uploadpoi();
            Workbook wb =  uploadpoi.getWorkbooj(file,suffix);
            List<TestTable> testTables = uploadpoi.readExcelDataOfTest(wb);
            TestService testService = SpringBeanHolder.getBean(TestServiceImpl.class);
            for(TestTable testTable : testTables){
                testService.updateAllFen(testTable);
            }
        }catch (Exception e){
            e.printStackTrace();
            return new BaseResponse<>(StatusCode.System_Error);
        }
        return response;
    }
    @RequestMapping("/admin/downExcelofTestinfo/{test_id}")
    public String downExcelTestInfo(@PathVariable("test_id")Integer test_id,HttpServletResponse response){
        if(test_id != null){
            try{
                TestService testService = SpringBeanHolder.getBean(TestServiceImpl.class);
                String[] headers = new String[]{"考试场次","序号","姓名","班级","学号","语文","数学","英语","物理","化学","生物","政治","历史","地理","总分"};
                List<TestTable> list = testService.getAllTestInfoOfStudents(test_id);
                if(list.size() > 0){
                    List<Map<Integer,Object>> datalist = ExcelUtil.manageList(list);
                    Workbook wb = new HSSFWorkbook();
                    ExcelUtil.fillExcelSheetData(datalist,wb,headers,"sheet01");
                    WebUtil.downloadExcel(response,wb,"成绩单.xls");
                    return "正在开始下载...";
                }else {
                    return null;
                }
            }catch (Exception e){
                e.printStackTrace();
            }
        }else {
            return null;
        }
        return null;
    }
    @SuppressWarnings("rawtypes")
    @RequestMapping(value = "/admin/uploadExcelofCourse",method = RequestMethod.POST,consumes = MULTIPART_FORM_DATA_VALUE)
    @ResponseBody
    public BaseResponse uploadExcelofCourse(MultipartHttpServletRequest request){
        BaseResponse response = new BaseResponse<>(StatusCode.Success);
        try{
            MultipartFile file = request.getFile("courseFile");
            if(file == null || file.getName() == null){
                return new BaseResponse<>(StatusCode.Invalid_Param);
            }
            String fileName = file.getOriginalFilename();
            String suffix = StringUtils.substring(fileName,fileName.lastIndexOf(".")+1);
            if(WorkBookVersion.valueofSuffix(suffix) == null){
                return new BaseResponse<>(StatusCode.WorkBook_Version_Invalid);
            }
            System.out.println("文件名{"+fileName + "}" + "文件后缀名：{"+suffix+"}");
            Uploadpoi uploadpoi = new Uploadpoi();
            Workbook wb = uploadpoi.getWorkbooj(file,suffix);
            List<CourseTable> courseTables = uploadpoi.readExcelDataOfCourse(wb);
            System.out.println(courseTables);
            CourseService courseService = SpringBeanHolder.getBean(CourseServiceImpl.class);
            for(CourseTable courseTable : courseTables){
                List<CourseTable> courseTables1 = new ArrayList<CourseTable>();
                courseTables1 = courseService.checkCourseisKown(courseTable);
                if(courseTables1.size() == 0){
                    courseService.InsertCourse(courseTable);
                }else {
                    CourseTable courseTable1 = courseTable;
                    for(CourseTable courseTable2 : courseTables1){
                        courseTable1.setT_id(courseTable2.getT_id());
                    }
                    courseService.updateCourse(courseTable1);
                }
            }
        }catch (Exception e){
            e.printStackTrace();
            return new BaseResponse<>(StatusCode.System_Error);
        }
        return response;
    }
    @ResponseBody
    @RequestMapping(value = "/admin/delCourse",method = RequestMethod.POST)
    public String delCourse(@RequestParam("classNum")String classNum){
        if(classNum.trim().length() > 0){
            try{
                CourseService courseService = SpringBeanHolder.getBean(CourseServiceImpl.class);
                Integer p = courseService.deleteCourse(classNum);
                if(p == 0){
                    return "删除失败，请稍后重试！";
                }else {
                    return "删除成功!";
                }
            }catch (Exception e){
                e.printStackTrace();
                return "删除失败，请稍后重试！";
            }
        }else {
            return "没有传递班级号，删除失败";
        }
    }
    @ResponseBody
    @RequestMapping(value = "/admin/deleteUserinfo",method = RequestMethod.POST)
    public String deleteUserinfo(@RequestParam("uid")Integer uid){
        if(uid != 1 && uid != null){
            UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
            try{
                User user = userService.findUserByUId(uid);
                if(!"管理员".equals(user.getIdentity())){
                    Integer p = userService.deleteUser(uid);
                    if(p == 0){
                        return "删除失败！请稍后重试！";
                    }else {
                        return "删除成功!";
                    }
                }else {
                    return "不可删除管理员!";
                }
            }catch (Exception e){
                e.printStackTrace();
                return "删除失败！数据库错误！";
            }
        }else {
            return "用户编号为空，或者你删的是一号管理员！无法删除！";
        }
    }

    @ResponseBody
    @RequestMapping(value = "/admin/updateUserInfo",method = RequestMethod.POST)
    public String updateUserInfo(User user){
        if(user.getUid() != 1 && user.getUid() != null){
            UserService userService = SpringBeanHolder.getBean(UserServiceImpl.class);
            try{
                if(userService.checkadmininsert(user).size() == 0){
                    userService.updateUserInfo(user);
                    return "修改成功!";
                }else {
                    return "昵称、工号或者邮箱有已存在的，请检查！";
                }
            }catch (Exception e){
                e.printStackTrace();
                return "修改失败！数据库错误！";
            }
        }else {
            return "不可修改1号管理的信息，或者uid不存在！";
        }
    }


    @RequestMapping("/admin/loadTestInfoTable/{test_id}")
    public String adminLoadTestInfoTable(@PathVariable("test_id")Integer test_id,Model model){
        TestService testService = SpringBeanHolder.getBean(TestServiceImpl.class);
        try {
            List<String> clist = testService.getAllTestinfoClassNum(test_id);
            List<TestTable> tlist = testService.getAllTestInfoOfStudents(test_id);
            model.addAttribute("clist",clist);
            model.addAttribute("tlist",tlist);
            return "eotashow";
        } catch (Exception e) {
            e.printStackTrace();
            return "eotashow";
        }
    }

    @RequestMapping("/admin/loadCourseTable/{year}")
    public String adminloadCourseTable(@PathVariable("year")Integer year,Model model){
        if(year != null){
            List<CourseTable> list = new ArrayList<>();
            List<String> list1 = new ArrayList<>();
            try{
                CourseService courseService = SpringBeanHolder.getBean(CourseServiceImpl.class);
                list1 = courseService.findAllCourseClassNum();
                list = courseService.findAllCourse();
                System.out.println(list1);
                model.addAttribute("coursetable",list);
                model.addAttribute("courseclass",list1);
                return "coursetable";
            }catch (Exception e){
                e.printStackTrace();
                return "coursetable";
            }
        }else {
            return null;
        }
    }
    @ResponseBody
    @RequestMapping(value = "/admin/passMsg",method = RequestMethod.POST)
    public String adminpassMsg(@RequestParam("m_id")Integer m_id){
        if(m_id != null){
            MessageService messageService = SpringBeanHolder.getBean(MessageServiceImpl.class);
            try {
                Integer p = messageService.passMsg(m_id);
                if(p == 0){
                    return "标记失败，请稍后重试！";
                }else {
                    return "标记成功!";
                }
            } catch (Exception e) {
                e.printStackTrace();
                return "标记失败，服务器错误！";
            }
        }else {
            return "id为空！";
        }
    }
    @ResponseBody
    @RequestMapping(value = "/admin/deleteMsg",method = RequestMethod.POST)
    public String deleteMsg(@RequestParam("m_id")Integer m_id){
        if(m_id != null){
            MessageService messageService = SpringBeanHolder.getBean(MessageServiceImpl.class);
            try{
                Integer p = messageService.deleteMsg(m_id);
                if(p == 0){
                    return "删除失败，请稍后重试！";
                }else {
                    return "删除成功!";
                }
            }catch (Exception e){
                e.printStackTrace();
                return "删除失败，服务器错误！";
            }
        }else {
            return "id为空";
        }
    }
}
