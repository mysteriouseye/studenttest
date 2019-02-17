package com.students.entity;

import java.util.Objects;

public enum WorkBookVersion {
    WorkBook2003("2003","2003版本的workBook"),
    WorkBook2007("2007","2007版本的workBook"),

    WorkBook2003Xls("xls","xls后缀名结尾-2003版本workBook"),
    WorkBook2007Xlsx("xlsx","xlsx后缀名结尾-2007版本workBook");

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    WorkBookVersion(String code, String name) {
        this.code = code;
        this.name = name;
    }

    private String code;
    private String name;

    public static WorkBookVersion valueofVersion(String Version){
        if(Objects.equals(WorkBook2003.getCode(),Version)){
            return WorkBook2003;
        }else if(Objects.equals(WorkBook2007.getCode(),Version)){
            return WorkBook2007;
        }else {
            return null;
        }
    }
    public static WorkBookVersion valueofSuffix(String suffix){
        if(Objects.equals(WorkBook2003Xls.getCode(),suffix)){
            return WorkBook2003Xls;
        }else if(Objects.equals(WorkBook2007Xlsx.getCode(),suffix)){
            return WorkBook2007Xlsx;
        }else {
            return null;
        }
    }
}
