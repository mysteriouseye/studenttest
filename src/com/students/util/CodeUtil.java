package com.students.util;

import java.util.Random;

public class CodeUtil {
    public static String getCode(){
        String s1 = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
        String s2 = "0123456789";
        Random random = new Random();
        StringBuilder sb = new StringBuilder(5);
        for(int i = 0;i<3;i++){
            sb.append(s1.charAt(random.nextInt(s1.length())));
            sb.append(s2.charAt(random.nextInt(s2.length())));
        }
        System.out.println(sb);
        return String.valueOf(sb);
    }
}
