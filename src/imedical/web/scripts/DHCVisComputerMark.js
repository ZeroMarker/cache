
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
////////////////ע���༭��start//////////////////////
/**
* ע���༭������װ��ע���Ĳ���
*/
function RegEdit(){
this.shell = new ActiveXObject("WScript.Shell");
this.regRead = regRead;
this.regWrite = regWrite;
this.regDelete = regDelete;
}

/** ������Ϊ strName ��ע�����ֵ��
* @param strName Ҫ��ȡ�ļ���ֵ����� strName �Է�б�� (\) �����������������ؼ���������ֵ
* @return ��Ϊ strName ��ע�����ֵ
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

/** ���� strName ָ����ע�����ֵ
* @param strName Ҫд�ļ���ֵ������.��� strName �Է�б�� (\) �����������������ؼ���������ֵ
* @param anyValue Ҫд�����ע���ֵ�е�ֵ
* @param strType ��ѡ�Ҫ���浽ע����е�ֵ����������REG_SZ��REG_EXPAND_SZ��REG_DWORD��REG_BINARY
*/
function regWrite(strName,anyValue,strType){
if(strType == null)
   strType = "REG_SZ";
this.shell.regWrite(strName,anyValue,strType);
}

/** ��ע�����ɾ�� strName ָ���ļ���ֵ��
* @param strName Ҫɾ���ļ���ֵ�����֡���� strName �Է�б�� (\) ��������������ɾ������������ֵ
*/
function regDelete(strName){
this.shell.regDelete(strName);
}