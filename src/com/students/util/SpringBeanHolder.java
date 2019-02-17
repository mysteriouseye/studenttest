package com.students.util;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;
import org.springframework.stereotype.Component;

@Component
public class SpringBeanHolder  implements ApplicationContextAware{

	private static ApplicationContext ac;
	
	@Override
	public void setApplicationContext(ApplicationContext applicaionContext) throws BeansException {
		ac = applicaionContext;
	}
	

	public static Object getBean(String beanName)
	{
		System.out.println(ac);
		return ac.getBean(beanName);
		
	}

	public static <T> T getBean(Class<T> clz)
	{
		return ac.getBean(clz);
	}
	
	public static <T> T getBean(String beanName,Class<T> clz)
	{
		return ac.getBean(beanName, clz);
	}

}
