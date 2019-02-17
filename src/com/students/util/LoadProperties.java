package com.students.util;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class LoadProperties {
    public static Properties getProperties(Class l,String proName) throws IOException {
        Properties properties = new Properties();
        InputStream in = l.getClassLoader().getResourceAsStream(proName);
        properties.load(in);
        return properties;
    }
}
