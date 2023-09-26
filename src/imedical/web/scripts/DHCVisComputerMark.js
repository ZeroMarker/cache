
ButtonContorl();
function ButtonContorl()
{
	var IPAddress=GetComputerIp()
	//alert(IPAddress)
	var IPFlag=tkMakeServerCall("web.DHCVISQueueManage","GetActiveFlag",IPAddress);
	if (IPFlag!=0){
		var callObj=document.getElementById("callButton");
		if(callObj) callObj.style.display="none"
		var recallObj=document.getElementById("recallButton")
		if(recallObj) recallObj.style.display="none"
	}else{
		var nextPatObj=document.getElementById("NextPatient");
		if(nextPatObj) nextPatObj.style.display="none"
	}
}

function GetComputerIpBak()
{
	var ipAddr;
	try
	{
	   var obj = new ActiveXObject("rcbdyctl.Setting");
	   ipAddr=obj.GetIPAddress;
	   obj = null;
	}
	catch(e)
	{
	   ipAddr="Exception";
	}
	return ipAddr;
}
function GetComputerIp()
{
	var regedit=new RegEdit();
	var computerName = regedit.regRead("HKEY_CURRENT_USER\\Volatile Environment\\ViewClient_Machine_Name");
	if ((computerName!="")&&(computerName!=null))
	{
		return computerName
	}
	var computerName;
	try
	{
	   var WshNetwork=new ActiveXObject("WScript.Network"); 
	   computerName=WshNetwork.ComputerName;
	   //WshNetwork.UserDomain
	   //WshNetwork.UserName
	   WshNetwork = null;
	}
	catch(e)
	{
	   computerName="";
	}
	return computerName;
}
function GetComputerName()
{
	var regedit=new RegEdit();
	var computerName = regedit.regRead("HKEY_CURRENT_USER\\Volatile Environment\\ViewClient_Machine_Name");
	if ((computerName!="")&&(computerName!=null))
	{
		return computerName
	}
	var computerName;
	try
	{
	   var WshNetwork=new ActiveXObject("WScript.Network"); 
	   computerName=WshNetwork.ComputerName;
	   //WshNetwork.UserDomain
	   //WshNetwork.UserName
	   WshNetwork = null;
	}
	catch(e)
	{
	   computerName="";
	}
	return computerName;
}
////////////////注册表编辑类start//////////////////////
/**
* 注册表编辑器，封装对注册表的操作
*/
function RegEdit(){
this.shell = new ActiveXObject("WScript.Shell");
this.regRead = regRead;
this.regWrite = regWrite;
this.regDelete = regDelete;
}

/** 返回名为 strName 的注册键或值。
* @param strName 要读取的键或值。如果 strName 以反斜线 (\) 结束，本方法将返回键，而不是值
* @return 名为 strName 的注册键或值
*/
function regRead(strName){
var val = null;
try {
   val = this.shell.regRead(strName);
} catch (e) {
   //alert(e.message);
}
return val;
}

/** 设置 strName 指定的注册键或值
* @param strName 要写的键或值的名称.如果 strName 以反斜线 (\) 结束，本方法将返回键，而不是值
* @param anyValue 要写入键或注册表值中的值
* @param strType 可选项。要保存到注册表中的值的数据类型REG_SZ、REG_EXPAND_SZ、REG_DWORD、REG_BINARY
*/
function regWrite(strName,anyValue,strType){
if(strType == null)
   strType = "REG_SZ";
this.shell.regWrite(strName,anyValue,strType);
}

/** 从注册表中删除 strName 指定的键或值。
* @param strName 要删除的键或值的名字。如果 strName 以反斜线 (\) 结束，本方法将删除键，而不是值
*/
function regDelete(strName){
this.shell.regDelete(strName);
}