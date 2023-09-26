Class DWR.INI.SystemSet Extends %RegisteredObject
{

//	w ##Class(DWR.INI.SystemSet).SetInitData()

/// 设置系统初始化数据
ClassMethod SetInitData()
{
	do ##Class(DWR.INI.SystemSet).SetOrdItemCode()				/// 设置护理级别和危重病情的医嘱项代码
	do ##Class(DWR.INI.SystemSet).SetOrdCatIconFile()			/// 设置医嘱类别的图标文件路径
	do ##Class(DWR.INI.SystemSet).SetEMRBrowse()				/// 设置电子病历浏览的服务器信息
	do ##Class(DWR.INI.SystemSet).SetImageBrowse()				/// 设置Pacs浏览图像的方式
	quit "ok"
}

/// 设置Pacs浏览图像的方式
ClassMethod SetImageBrowse()
{
	///图像浏览方式 DICOM下载
	set ^DHCDWRSET("Image","Browse")="DICOM"
	//实际的Pad端的AETitle为^DHCDWRSET("DICOM","localAETitle")+加IPAD的IP地址的后两位拼成的串,点转换为D
	//例如iPad ip 地址为192.168.0.1,AETitle为IPAD0D1,这个需要与Pacs厂商协调好
	i ^DHCDWRSET("Image","Browse")="DICOM" d
	.set ^DHCDWRSET("DICOM","localAETitle")="IPAD"  		///这个很重要
	.set ^DHCDWRSET("DICOM","localPort")=105        		///这个很重要
	.set ^DHCDWRSET("DICOM","localSyntax")="Explicit Little Endian"
	.set ^DHCDWRSET("DICOM","serverDesc")="GEPACS"  		///这个很重要
	.set ^DHCDWRSET("DICOM","serverAETitle")="GEPACS"  		///这个很重要
	.set ^DHCDWRSET("DICOM","serverAddress")="172.21.21.78"	///这个很重要
	.set ^DHCDWRSET("DICOM","serverPort")=4100				///这个很重要
	.set ^DHCDWRSET("DICOM","serverRetrieve")="C-MOVE"
	.set ^DHCDWRSET("DICOM","serverTLS")="N"
	.set ^DHCDWRSET("DICOM","serverSyntax")="Implicit Little Endian"
	//set ^DHCDWRSET("Image","Browse")="INFINITT"
	//set ^DHCDWRSET("Image","Browse")="AGFA"
	//set ^DHCDWRSET("Image","Browse")="URL"
	quit
}

/// 设置护理级别和危重病情的医嘱项代码
ClassMethod SetOrdItemCode()
{
	/// 护理级别
	set ^DHCDWRSET("ORD","CareLevel",1)="Y130A0110003"     // 一级护理
	set ^DHCDWRSET("ORD","CareLevel",2)="Y130A0110004"     // 二级护理
	set ^DHCDWRSET("ORD","CareLevel",3)="Y130A0110005"     // 三级护理
	set ^DHCDWRSET("ORD","CareLevel",4)="Y130A0110002"     // 特级护理
	
	/// 病情危重
	set ^DHCDWRSET("ORD","Condition",1)="Y13001G"     // 病危
	set ^DHCDWRSET("ORD","Condition",2)="Y13001H"     // 病重
	
	quit
}

/// 设置医嘱类别的图标文件路径
ClassMethod SetOrdCatIconFile()
{
 
	set ^DHCDWRSET("ORD","OrdCatIconFile","Default")="orderdefault.png"
	set ^DHCDWRSET("ORD","OrdCatIconFile","XY")="drug.png"
	set ^DHCDWRSET("ORD","OrdCatIconFile","ZC")="drug.png"
	set ^DHCDWRSET("ORD","OrdCatIconFile","ZCH")="drug.png"
	quit
}

/// 设置电子病历浏览的服务器信息
ClassMethod SetEMRBrowse()
{
	////     协议://用户名:口令@服务器地址:端口/虚拟路径,当为http时不需要用名、口令
	///例如: http://172.23.6.210:80/ipad
	//		 ftp://administrator:slyydyq-yy210@172.23.6.210:21/ipad
	set ^DHCDWRSET("NUR","SERVERINTRA")="http://172.21.21.78/mhc/ipad"
	set ^DHCDWRSET("NUR","SERVERINTER")="http://172.21.21.78/mhc/ipad"
	set ^DHCDWRSET("NUR","FTP")="http://172.21.21.78/mhc/ipad" 
	
	set ^DHCDWRSET("EMR","BROWSETYPE")="FTP"						// 设置浏览电子病历的方式为通过FTP传输image文件
	//set ^DHCDWRSET("EMR","BROWSETYPE")="HTTP"						// 设置浏览电子病历的方式为通过HTTP浏览html文件
	//set ^DHCDWRSET("EMR","BROWSETYPE")="ONEURL"					// 设置浏览电子病历的方式为访问一个URL地址
	
	set ^DHCDWRSET("EMR","FTP","SERVERINTRA")="172.21.21.78"     	// ftp服务器内网IP
	set ^DHCDWRSET("EMR","FTP","SERVERINTER")="172.21.21.78"     	// ftp服务器外网IP
	set ^DHCDWRSET("EMR","FTP","VDIR")=""							// 虚拟目录
	set ^DHCDWRSET("EMR","FTP","USER")="DtHealth"				// 用户名
	set ^DHCDWRSET("EMR","FTP","PASSWORD")="DT_2012"			// 密码
	set ^DHCDWRSET("EMR","FTP","PORT")="1974"							// 端口
	
	set ^DHCDWRSET("EMR","HTTP","SERVERINTRA")="172.21.21.78"     	// http服务器内网IP
	set ^DHCDWRSET("EMR","HTTP","SERVERINTER")="172.21.21.78"     	// http服务器外网IP
	set ^DHCDWRSET("EMR","HTTP","VDIR")=""							// 虚拟目录
	set ^DHCDWRSET("EMR","HTTP","USER")=""							// 用户名
	set ^DHCDWRSET("EMR","HTTP","PASSWORD")=""						// 密码
	set ^DHCDWRSET("EMR","HTTP","PORT")=""							// 端口
	
	//set ^DHCDWRSET("EMR","ONEURL","SERVERINTRA")="http://172.16.1.227/WebDoqLeiView/DoqLeiView/WebFormLeft.aspx?type=HOS&regdate=2012-07-02&&id="     	// http服务器内网IP
	//set ^DHCDWRSET("EMR","ONEURL","SERVERINTER")="http://172.16.1.227/WebDoqLeiView/DoqLeiView/WebFormLeft.aspx?type=HOS&regdate=2012-07-02&&id="      	// http服务器外网IP
	
	quit
}

}
