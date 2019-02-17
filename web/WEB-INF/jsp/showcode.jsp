<%@page import="java.awt.Font"%>
<%@page import="javax.imageio.ImageIO"%>
<%@page import="java.awt.Graphics"%>
<%@page import="java.awt.image.BufferedImage"%>
<%@page import="java.util.Random"%>
<%@page import="java.awt.Color"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
//设置页面不缓存  
response.setHeader("Pragma","no-cache");  
response.setHeader("Cache-Control","no-catch");  
response.setDateHeader("Expires",0);  


int width = 90;  
int height = 30;
BufferedImage image = new BufferedImage(width,height,BufferedImage.TYPE_INT_RGB);

Graphics pic = image.getGraphics();
Random r = new Random();
pic.setColor(getRandColor(r.nextInt(50),r.nextInt(100)+50));
pic.fillRect(0, 0, width, height);

// 绘制 干扰线
pic.setColor(Color.gray);

for(int i = 0; i < 30; i++){ 
	
    int x = r.nextInt(width);  
    int y = r.nextInt(height);  
    int xl = r.nextInt(width);  
    int yl = r.nextInt(height);  
    
    pic.drawLine(x, y, xl, yl);
}  


int n1 = r.nextInt(50)+50;
int n2 = r.nextInt(50);

boolean isplus = r.nextInt(2) == 0 ? true: false;

int result = isplus? n1+n2 : n1-n2;

//生成的结果放在 什么地方  客户 可以随时用来对比
session.setAttribute("showcode", result);


System.out.println(result);

pic.setColor(Color.black);

pic.setFont(new Font("Arial",Font.BOLD, 16));

pic.drawString(n1+"", r.nextInt(15)+5, r.nextInt(16)+12);

pic.setColor(Color.black);

pic.setFont(new Font("Arial",Font.BOLD, 20));

pic.drawString(isplus?"+":"-", r.nextInt(15)+32, r.nextInt(16)+10);

pic.setColor(Color.black);

pic.setFont(new Font("Arial",Font.BOLD, 16));

pic.drawString(n2+"", r.nextInt(15)+50, r.nextInt(16)+12);





//图像生效  
pic.dispose();  
//输出图像到页面  
ImageIO.write(image,"JPEG",response.getOutputStream());  
out.clear();  
out = pageContext.pushBody();  

%>

<%!  
    Color getRandColor(int fc,int bc){  
        Random random = new Random();  
        if(fc > 255){  
            fc = 255;  
        }  
        if(bc < 255){  
            bc = 255;  
        }  
        int r = fc +random.nextInt(bc-fc);  
        int g = fc +random.nextInt(bc-fc);  
        int b = fc +random.nextInt(bc-fc);  
            
        return new Color(r,g,b);  
    }  
%>  