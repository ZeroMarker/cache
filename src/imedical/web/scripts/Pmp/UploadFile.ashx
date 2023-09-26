<%@ page language="java" import="java.util.*" pageEncoding="utf-8"%>  
<%@ page import="java.io.*" %>  
<%@ page import="com.oreilly.servlet.*" %>  
<%@ page import="com.oreilly.servlet.multipart.*" %>  
<%@ page contentType="text/html;charset=utf-8" %>  
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">  
<html>  
    <head>  
        <title>上传后台页面</title>  
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />  
<%  
    //文件上传后,保存在D://upload  
    String saveDirectory = "D://txt";      
    //每个文件最大5m,最多3个,所以总文件大小为(以字节为单位)  
    int maxPostSize = 3*5*1024*1024;      
    //保存文件 response的编码为utf-8,  
    MultipartRequest multi = new MultipartRequest(request,saveDirectory,maxPostSize,"utf-8");      
    //输出反馈信息  
    Enumeration files = multi.getFileNames();  
    while(files.hasMoreElements()){  
       String name = (String)files.nextElement();  
       File f = multi.getFile(name);  
//       if(f!=null){  
//        String fileName = multi.getFilesystemName(name);    获得文件名  
//        String lastFileName = saveDirectory+"//"+fileName;   显示保存路径  
//        out.println("上传的文件:"+lastFileName);  
//        out.println("<hr>");   
//       }  
    }  
    System.out.println("上传成功");  
    response.setContentType("text/html;charset=utf-8");  
    response.getWriter().print("{success:true,message:'上传成功'}");  
%>  
    </head>  
  
    <body>          
    </body>  
</html>  