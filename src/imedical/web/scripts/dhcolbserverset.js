var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
var xmlDoc=new ActiveXObject("Microsoft.XMLDOM");
function BodyLoadHandler() {
	var obj=document.getElementById("btnAdd")
	if (obj) obj.onclick=AddHandler;
	var obj=document.getElementById("btnUpdate")
	if (obj) obj.onclick=UpdateHandler;
	var obj=document.getElementById("btnDelete")
	if (obj) obj.onclick=DeleteHandler;
	AddAvailableLicense();
}
function AddAvailableLicense()
{
	var objtb=document.getElementById('tDHCOLBServerSet');
    for (var i=1;i<objtb.rows.length;i++)
	{
		var ServerIP=document.getElementById("tServerIPz"+i).innerText;
		var ServerActive=document.getElementById("tServerActivez"+i).innerText;
		if(ServerActive=="N") continue;
		var Application=GetProfileApplication(ServerIP)
		if((ServerIP!="")&&(Application!=""))
		{
			var AvailableLicense=GetAvailableLicense(ServerIP,Application);
			if(AvailableLicense!="")
			{
		   		var AvailableLicenseObj=document.getElementById("tAvailableLicensez"+i);
		   		AvailableLicenseObj.innerText=AvailableLicense
		   		var ServerInfo=GetServerInfo(ServerIP,Application);
		   		if(ServerInfo!="")
		   		{
		   			var MemoryUsedAllObj=document.getElementById("tMemoryUsedAllz"+i);
		   			var MemoryAllocatedObj=document.getElementById("tMemoryAllocatedz"+i);
		   			var MemoryUsedPercentObj=document.getElementById("tMemoryUsedPercentz"+i);
		   			if(MemoryUsedAllObj)  MemoryUsedAllObj.innerText=ServerInfo.split("|")[0]
		   			if(MemoryAllocatedObj)  MemoryAllocatedObj.innerText=ServerInfo.split("|")[1]
		   			if(MemoryUsedPercentObj)  MemoryUsedPercentObj.innerText=ServerInfo.split("|")[2]	
		   		}	
			}

		}
	}
}
function CheckURL(URL) 
{ 
	try	 
	{
		//var xmlhttp = new ActiveXObject("Microsoft.XMLHTTP"); 
		xmlhttp.Open("GET",URL, false);
		xmlhttp.Send();
		var result = xmlhttp.status;
		if(result==200) 
		{
			//xmlhttp = null;
			return true; 
		}
		else
		{
			//xmlhttp = null; 
			return false; 
		}
	}
	catch(e)
	{
		return false;
	}	
}
function GetServerInfo(ServerIP,Application)
{
	var nodeValue=""
	try
	{
		var URL="http://"+ServerIP+Application;
		var ret=CheckURL(URL)
		if(ret)
		{
			var URL="http://"+ServerIP+Application+"/DHCOLB.OLBService.cls";
			var Action="http://www.dhcc.com.cn/GetServerInfo";
			var Body = '<GetServerInfo>'+'</GetServerInfo>'; 
			var xmlText=RequestByGet(URL,Body,Action)
			var nodeName="GetServerInfoResult";
			var nodeValue=AnalyseXML(xmlText,nodeName);
		}	
	}
	catch(e)
	{
	}
	return nodeValue;
}
function GetProfileApplication(ServerIP)
{
	var obj=document.getElementById('GetProfileApplication');
	if(obj)
	{
		var GetProfileApplication=obj.value;
		var retStr=cspRunServerMethod(GetProfileApplication,ServerIP);
		return retStr;
	}
	return "";
}
function GetAvailableLicense(ServerIP,Application)
{
	var nodeValue=""
	try
	{
		var URL="http://"+ServerIP+Application;
		var ret=CheckURL(URL)
		if(ret)
		{
			var URL="http://"+ServerIP+Application+"/DHCOLB.OLBService.cls";
			var Action="http://www.dhcc.com.cn/GetMinAvailableLicense";
			var Body = '<GetMinAvailableLicense>'+'</GetMinAvailableLicense>'; 
			var xmlText=RequestByGet(URL,Body,Action)
			var nodeName="GetMinAvailableLicenseResult";
			var nodeValue=AnalyseXML(xmlText,nodeName);
		}
	}
	catch(e)
	{
	}
	return nodeValue;
}
function AnalyseXML(xmlText,nodeName)
{
	var nodeValue=""
	try
	{
		xmlDoc.async="false";
		xmlDoc.loadXML(xmlText);
		var nodeValue=xmlDoc.getElementsByTagName(nodeName)[0].childNodes[0].nodeValue;
	}
	catch(e)
	{
	}
	return nodeValue;
}
function RequestByGet(URL,Body,Action)
{
	var data,response;
	response=""
	try
	{
		data = '<?xml version="1.0" encoding="utf-8"?>';
		data = data + '<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">';
		data = data + '<soap:Body>';
		data = data + Body;
		data = data + '</soap:Body>';
		data = data + '</soap:Envelope>';  
		xmlhttp.Open("GET",URL, false);
		xmlhttp.SetRequestHeader ("Content-Type","text/xml; charset=UTF-8"); 
		xmlhttp.SetRequestHeader ("SOAPAction",Action);
		xmlhttp.Send(data);
		var result = xmlhttp.status;
		if(result==200) {
			response= xmlhttp.responseText;
		}    
	}
	catch(e)
	{
	}
	return response;  
}
function VerifyIPHandler(ip)
{
	var pattern=/^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/;
	flag_ip=pattern.test(ip);
	if(!flag_ip)
	{
		alert("IP地址输入非法!");
		document.all.txtServerIP.focus();
		return false;
	}
}

function AddHandler()
{
	var obj=document.getElementById('txtServerIP');
	var ServerIP=obj.value;
	var flag = VerifyIPHandler(ServerIP)
	if(flag==false)  return;
	
	var obj=document.getElementById('txtServerName');
	var ServerName=obj.value;
	if(ServerName=="") return;

	var ServerActive="N";
	var obj=document.getElementById('chkServerActive');
	if(obj.checked) ServerActive="Y";
	
	var obj=document.getElementById('UserId');
	if(obj) UserId=obj.value;
	else UserId="";

	var obj=document.getElementById('txtLicenseMax');
	var LicenseMax=obj.value;
	if(LicenseMax==" ") LicenseMax="";
	//if(LicenseMax=="") return;

	var obj=document.getElementById('txtLicenseMin');
	var LicenseMin=obj.value;
	if(LicenseMin==" ") LicenseMin="";
	//if(LicenseMin=="") return;

	var obj=document.getElementById('txtIISConMax');
	var IISConMax=obj.value;
	if(IISConMax==" ") IISConMax="";
	//if(IISConMax=="") return;

	var obj=document.getElementById('txtIISConMin');
	var IISConMin=obj.value;
	if(IISConMin==" ") IISConMin=""; 
	//if(IISConMin=="") return;

	var obj=document.getElementById('txtCPUMax');
	var CPUMax=obj.value;
	if(CPUMax==" ") CPUMax="";
	//if(CPUMax=="") return; 
	
	var obj=document.getElementById('txtMemoryMax');
	var MemoryMax=obj.value;
	if(MemoryMax==" ") MemoryMax="";
	//if(MemoryMax=="") return; 
	
	var obj=document.getElementById('txtProfileDR');
	var ProfileDR=obj.value;
	if(ProfileDR==" ") ProfileDR=""; 

	var obj=document.getElementById('txtServerNote');
	var ServerNote=obj.value;
	if(ServerNote==" ") ServerNote=""; 
	
	var obj=document.getElementById('MethodInsert');
	if(obj)
	{
		var objInsert=obj.value;
		var retStr=cspRunServerMethod(objInsert,ServerIP,ServerName,ServerActive,LicenseMax,LicenseMin,IISConMax,IISConMin,CPUMax,MemoryMax,ProfileDR,ServerNote);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnAdd_click();
	}
	
}

function UpdateHandler()
{
	var obj=document.getElementById('txtServerId');
	var ServerId=obj.value;
	if(ServerId=="") return;
	
	var obj=document.getElementById('txtServerIP');
	var ServerIP=obj.value;
	var flag=VerifyIPHandler(ServerIP)
	if(flag==false) return;
	
	var obj=document.getElementById('txtServerName');
	var ServerName=obj.value;
	if(ServerName=="") return;

	var ServerActive="N";
	var obj=document.getElementById('chkServerActive');
	if(obj.checked) ServerActive="Y";
	
	var obj=document.getElementById('UserId');
	if(obj) UserId=obj.value;
	else UserId="";

	var obj=document.getElementById('txtLicenseMax');
	var LicenseMax=obj.value;
	if(LicenseMax==" ") LicenseMax="";
	//if(LicenseMax=="") return;

	var obj=document.getElementById('txtLicenseMin');
	var LicenseMin=obj.value;
	if(LicenseMin==" ") LicenseMin="";
	//if(LicenseMin=="") return;

	var obj=document.getElementById('txtIISConMax');
	var IISConMax=obj.value;
	if(IISConMax==" ") IISConMax="";
	//if(IISConMax=="") return;

	var obj=document.getElementById('txtIISConMin');
	var IISConMin=obj.value;
	if(IISConMin==" ") IISConMin="";
	//if(IISConMin=="") return;

	var obj=document.getElementById('txtCPUMax');
	var CPUMax=obj.value;
	if(CPUMax==" ") CPUMax="";
	//if(CPUMax=="") return; 
	
	var obj=document.getElementById('txtMemoryMax');
	var MemoryMax=obj.value;
	if(MemoryMax==" ") MemoryMax="";
	//if(MemoryMax=="") return; 
	
	var obj=document.getElementById('txtProfileDR');
	var ProfileDR=obj.value;
	if(ProfileDR==" ") ProfileDR=""; 

	var obj=document.getElementById('txtServerNote');
	var ServerNote=obj.value;
	if(ServerNote==" ") ServerNote=""; 
	var obj=document.getElementById('MethodUpdate');
	if(obj)
	{
		var objUpdate=obj.value;
		var retStr=cspRunServerMethod(objUpdate,ServerId,ServerIP,ServerName,ServerActive,LicenseMax,LicenseMin,IISConMax,IISConMin,CPUMax,MemoryMax,ProfileDR,ServerNote);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnUpdate_click();
	}
	
}

function DeleteHandler()
{
	var obj=document.getElementById('txtServerId');
	var ServerId=obj.value;
	if(ServerId=="") return;
	var obj=document.getElementById('MethodDelete');
	if(obj)
	{
		var objDelete=obj.value;
		var retStr=cspRunServerMethod(objDelete,ServerId);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnDelete_click();
	}
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOLBServerSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('txtServerId');
	var obj1=document.getElementById('txtServerIP');
	var obj2=document.getElementById('txtServerName');
	var obj3=document.getElementById('txtLicenseMax');
	var obj4=document.getElementById('txtLicenseMin');
	var obj5=document.getElementById('txtIISConMax');
	var obj6=document.getElementById('txtServerNote');
	var obj7=document.getElementById('chkServerActive');
	var obj8=document.getElementById('txtIISConMin');
	var obj9=document.getElementById('txtCPUMax');
	var obj10=document.getElementById('txtMemoryMax');
	var obj11=document.getElementById('txtProfileDR');
	var obj12=document.getElementById('txtProfile');

	var SelRowObj=document.getElementById('tServerIdz'+selectrow);
	var SelRowObj1=document.getElementById('tServerIPz'+selectrow);
	var SelRowObj2=document.getElementById('tServerNamez'+selectrow);
	var SelRowObj3=document.getElementById('tLicenseMaxz'+selectrow);
	var SelRowObj4=document.getElementById('tLicenseMinz'+selectrow);
	var SelRowObj5=document.getElementById('tIISConMaxz'+selectrow);
	var SelRowObj6=document.getElementById('tServerNotez'+selectrow);
	var SelRowObj7=document.getElementById('tServerActivez'+selectrow);
	var SelRowObj8=document.getElementById('tIISConMinz'+selectrow);
	var SelRowObj9=document.getElementById('tCPUMaxz'+selectrow);
	var SelRowObj10=document.getElementById('tMemoryMaxz'+selectrow);
	var SelRowObj11=document.getElementById('tProfileDRz'+selectrow);
	var SelRowObj12=document.getElementById('tProfilez'+selectrow);

	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;
	if(obj1&&SelRowObj1) obj1.value=SelRowObj1.innerText;
	if(obj2&&SelRowObj2) obj2.value=SelRowObj2.innerText;
	if(obj3&&SelRowObj3) obj3.value=SelRowObj3.innerText;
	if(obj4&&SelRowObj4) obj4.value=SelRowObj4.innerText;
	if(obj5&&SelRowObj5) obj5.value=SelRowObj5.innerText;
	if(obj6&&SelRowObj6) obj6.value=SelRowObj6.innerText;
	if(obj7&&SelRowObj7)
	{
		if(SelRowObj7.innerText=="Y") obj7.checked=true;
		else obj7.checked=false;
	}
	if(obj8&&SelRowObj8) obj8.value=SelRowObj8.innerText;
	if(obj9&&SelRowObj9) obj9.value=SelRowObj9.innerText;
	if(obj10&&SelRowObj10) obj10.value=SelRowObj10.innerText;
	if(obj11&&SelRowObj11) obj11.value=SelRowObj11.innerText;
	if(obj12&&SelRowObj12) obj12.value=SelRowObj12.innerText;
	
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	var ServerIP=document.getElementById("tServerIPz"+selectrow).innerText;
	var Application=GetProfileApplication(ServerIP)
	var LinkObj='tLicenseLinkz'+selectrow;
	if (eSrc.id==LinkObj)
	{
		var ComputerIp=GetComputerIp()
		var lnk = "http://"+ServerIP+Application+"/csp/dhcolbserverlicense.csp?"+"ServerIP="+ServerIP+"&ComputerIP="+ServerIP
		win=open(lnk,"LicenseUsagebyUser","status=yes,top=10,left=10,width=1024,height=768,scrollbars=Yes,resizeable=yes");
	}
	return;
	return;
}

function ProfileSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtProfile');
	if (obj) obj.value=ret[1]
	var obj=document.getElementById('txtProfileDR');
	if (obj) obj.value=ret[0]
}
function GetComputerIp()
{
	var ipAddr="";
	try
	{
		var obj = new ActiveXObject("rcbdyctl.Setting");
		ipAddr=obj.GetIPAddress;
		obj = null;
	}
	catch(e)
	{
		obj = null;
	}
	return ipAddr;
}
window.document.body.onload=BodyLoadHandler;