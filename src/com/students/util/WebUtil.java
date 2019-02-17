package com.students.util;

import org.apache.poi.ss.usermodel.Workbook;

import javax.servlet.http.HttpServletResponse;
import java.io.OutputStream;

public class WebUtil {
    public static void downloadExcel(HttpServletResponse response, Workbook wb,String filename) throws Exception{
        response.setHeader("Content-Disposition","attachment;filename="+new String(filename.getBytes("utf-8"),"iso-8859-1"));
        response.setContentType("application/ynd.ms-excel;charset=UTF-8");
        OutputStream out = response.getOutputStream();
        wb.write(out);
        out.flush();
        out.close();
    }
}
