//DHCWeb.OPCommon.js
//



///显示图片
//根据病人ID和显示图片按钮ID
function ShowPicByPatientID(CareID,PicElementName)
{
	var picType=".jpg"
	var PicFilePath="D:\\"
	var src="ftp://10.160.16.112:21/CarePhoto/"+CareID + picType
	//var src="ftp://administrator:123456@10.72.16.158:21/picture/"+PatientID+picType
	ShowPicBySrc(src,PicElementName);
}
//根据图片路径和显示图片按钮ID
function ShowPicBySrc(src,PicElementName)
{
	var NoExistSrc="ftp://10.160.16.112:21/CarePhoto/blank.gif"; //没有保存照片时显示的图片
	//var NoExistSrc="ftp://administrator:123456@10.72.16.158:21/picture/blank.jpg"; //没有保存照片时显示的图片
	var obj=document.getElementById(PicElementName);
	//var obj = Ext.get('PicElementName').dom
	"<img src='ftp://10.160.16.112:21/CarePhoto/blank.gif' width=420 height=210>"
	if (obj) obj.innerHTML="<p style='text-align:center'><img SRC='"+src+"' width=420 height=210 onerror=this.src='"+NoExistSrc+"'></p>"
	//alert(document.getElementById(PicElementName).innerHTML)
	//document.getElementById(PicElementName).innerHTML='<img SRC='+src+' BORDER="0" width=90 height=140>'
  
}

function IsExistsFile(filepath)
    {
    	try
    	{
       		 var xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
       		 xmlhttp.open("GET",filepath,false);
       		 xmlhttp.send();
       		 if(xmlhttp.readyState==4){   
        	 return true;
             /*if(xmlhttp.status==200) return true; //url存在   
             else if(xmlhttp.status==404) return false; //url不存在   
             else return false;//其他状态  */ 
        } 
    	}
    	catch(e)
    	{
    		return false;
    	}
    }
        
//判断文件是否存在
function PicFileIsExist(filespec) 
{ 
      var   fso,   s   =   filespec; 
      fso   =   new   ActiveXObject( "Scripting.FileSystemObject"); 
      if   (fso.FileExists(filespec)) 
           return true;
      else   
           return false; 
}

//document.write("<OBJECT ID='Photo' CLASSID='CLSID:6939ADA2-0045-453B-946F-44F0D6424D8A' CODEBASE='../addins/client/Photo.CAB#version=2,0,0,20'></OBJECT>");
//document.write("<OBJECT ID='Photo' CLASSID='CLSID:3B5FF267-69BD-41DB-BA9E-6F6F94551840' CODEBASE='../addins/client/Photo.CAB#version=2,1,0,1'></OBJECT>");
//document.write("<OBJECT ID='Photo' CLASSID='CLSID:9FB3C86F-D98D-4848-BD55-223BE1323A0D' CODEBASE='../addins/client/Photo.CAB#version=2,0,0,7'></OBJECT>");
//转换联众Base64的串为图片

document.write("<OBJECT ID='Photo' CLASSID='CLSID:6939ADA2-0045-453B-946F-44F0D6424D8A' CODEBASE='../addins/client/BDPPhoto.CAB#version=2,0,0,52'></OBJECT>");
//document.write("<OBJECT ID='Photo' CLASSID='CLSID:6939ADA2-0045-453B-946F-44F0D6424D8A' CODEBASE='../addins/client/Photo.CAB#version=2,0,0,20'></OBJECT>");

function ChangeStrToPhoto(DR,furl)
{
	try{
		//var Photo= new ActiveXObject("PhotoProject.Photo");
		var FileName = furl
		Photo.FileName = FileName; //保存图片的名称包括后缀
		Photo.PatientID = DR //PA_PatMas表的ID
		//Photo.DBConnectString="CN_IPTCP:127.0.0.1[1972]:DHC-APP" //数据库服务器
		Photo.FTPString="10.160.16.112^anonymous^^21" //FTP服务器
		//Photo.DBConnectString="CN_IPTCP:10.160.16.31[1972]:DHC-APP" //数据库服务器
		//Photo.FTPString="10.72.16.158^administrator^123456^21" //FTP服务器
		//Photo.ChangePicture()
		if (PicFileIsExist(FileName)){
			Photo.AppName="CarePhoto/" //ftp目录
			Photo.DBFlag="0"  //是否保存到数据库  0  1
			Photo.FTPFlag="1" //是否上传到ftp服务器  0  1 
			Photo.SaveFile("jpg") //对于已经存在图片保存到数据库同时上传FTP的标志有效
		}
		return "1";
	}catch(e){
		return e;
	
	}
}
