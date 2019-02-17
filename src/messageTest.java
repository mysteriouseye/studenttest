import org.springframework.util.DigestUtils;

import javax.mail.MessagingException;
import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;

public class messageTest {
    public static void main(String[] args){
//        String[] lp={"A","B","C","D","E","F","J","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
//        String code = String.valueOf((int) ((Math.random()*9)+1))+lp[(int)(Math.random()*lp.length)+1]+String.valueOf((int) ((Math.random()*9)+1))+lp[(int)(Math.random()*lp.length)+1]+String.valueOf((int) ((Math.random()*9)+1));
//        com.students.util.MailUtil mailUtil = new com.students.util.MailUtil("1597273688@qq.com",code);
//        Map<String,String> map = new HashMap<>();
//        Poll poll = new Poll();
//        poll.send(mailUtil);
//        poll.close();
//        System.out.println(DigestUtils.md5DigestAsHex("Iwantslq1314".getBytes()));
        String str="abc.def";
        String str1=str.substring(str.indexOf(".")+1, str.length());
        System.out.println(str1);
    }
}
