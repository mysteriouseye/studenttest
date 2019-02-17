package com.students.util;

import com.students.entity.TestTable;
import com.students.entity.User;
import org.apache.commons.beanutils.BeanMap;
import org.apache.poi.ss.usermodel.*;

import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

public class ExcelUtil {
    public static List<Map<Integer,Object>> manageList(final List<TestTable> testTables){
        List<Map<Integer,Object>> datalist = new ArrayList<>();
        if(testTables != null && testTables.size()>0){
            int length = testTables.size();

            Map<Integer,Object> dataMap;
            TestTable bean = new TestTable();
            for(int i = 0;i < length;i++){
                bean = testTables.get(i);

                dataMap = new HashMap<>();
                dataMap.put(0,bean.getTest_id());
                dataMap.put(1,bean.getXu_number());
                dataMap.put(2,bean.getUserName());
                dataMap.put(3,bean.getClassNum());
                dataMap.put(4,bean.getPeoNum());
                dataMap.put(5,bean.getChinese());
                dataMap.put(6,bean.getMath());
                dataMap.put(7,bean.getEnglish());
                dataMap.put(8,bean.getPhysic());
                dataMap.put(9,bean.getChemical());
                dataMap.put(10,bean.getBiology());
                dataMap.put(11,bean.getPolitics());
                dataMap.put(12,bean.getHistory());
                dataMap.put(13,bean.getGeography());
                dataMap.put(14,bean.getSumFen());
                datalist.add(dataMap);
            }
        }
        return datalist;
    }
    public static List<Map<Integer,Object>> manageListOfUser(final List<User> user){
        List<Map<Integer,Object>> datalist = new ArrayList<>();
        if(user != null && user.size()>0){
            int length = user.size();

            Map<Integer,Object> dataMap;
            User bean = new User();
            for(int i = 0;i < length;i++){
                bean = user.get(i);

                dataMap = new HashMap<>();
                dataMap.put(0,bean.getR_userName());
                dataMap.put(1,bean.getUserName());
                dataMap.put(2,bean.getAge());
                dataMap.put(3,bean.getSex());
                dataMap.put(4,bean.getIdentity());
                dataMap.put(5,bean.getClassNum());
                dataMap.put(6,bean.getPeoNum());
                dataMap.put(7,bean.getEmail());
                dataMap.put(8,bean.getPhoneNum());
                dataMap.put(9,bean.getSigned());
                datalist.add(dataMap);
            }
        }
        return datalist;
    }
    private static final String dateFormat = "yyyy-MM-dd";
    private static final SimpleDateFormat simdateFormat = new SimpleDateFormat(dateFormat);
    public static void fillExcelSheetData(List<Map<Integer,Object>> dataList, Workbook wb,String[] headers,String sheetName){
        Sheet sheet = wb.createSheet(sheetName);
        Row headerRow = sheet.createRow(0);
        for(int i = 0;i < headers.length;i++){
            headerRow.createCell(i).setCellValue(headers[i]);
        }
        int rowIndex = 1;
        Row row;
        Object obj;
        for(Map<Integer,Object> rowMap:dataList){
            try{
                row = sheet.createRow(rowIndex++);
                for(int i = 0;i < headers.length;i++){
                    obj = rowMap.get(i);
                    if(obj == null){
                        row.createCell(i).setCellValue("");
                    }else if(obj instanceof Date){
                        String tempDate = simdateFormat.format((Date)obj);
                        row.createCell(i).setCellValue((tempDate == null)?"":tempDate);
                    }else {
                        row.createCell(i).setCellValue(String.valueOf(obj));
                    }
                }
            }catch (Exception e){
                e.printStackTrace();
            }
        }
    }
    public static String manageCell(Cell cell,String dateFormat) throws Exception{
        DecimalFormat decimalFormat = new DecimalFormat("0");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        DecimalFormat decimalFormat1 = new DecimalFormat("0.00");

        String value = "";
        CellType cellType = cell.getCellTypeEnum();
        if(CellType.STRING.equals(cellType)){
            value = cell.getStringCellValue();
        }else if(CellType.NUMERIC.equals(cellType)){
            if("General".equals(cell.getCellStyle().getDataFormatString())){
                value = decimalFormat.format(cell.getNumericCellValue());
            }else if("m/d/yy".equals(cell.getCellStyle().getDataFormatString())){
                value = sdf.format(cell.getDateCellValue());
            }else {
                value = decimalFormat1.format(cell.getNumericCellValue());
            }
        }else if(CellType.BOOLEAN.equals(cellType)){
            value = String.valueOf(cell.getBooleanCellValue());
        }else if(CellType.BLANK.equals(cellType)){
            value = "";
        }
        return value;
    }
}
