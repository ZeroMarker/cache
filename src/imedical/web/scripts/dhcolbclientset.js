function BodyLoadHandler() {
	var obj=document.getElementById("btnAdd")
	if (obj) obj.onclick=AddHandler;
	var obj=document.getElementById("btnUpdate")
	if (obj) obj.onclick=UpdateHandler;
	var obj=document.getElementById("btnDelete")
	if (obj) obj.onclick=DeleteHandler;
	
}
function VerifyIPHandler(ip)
{
	var pattern=/^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/;
	flag_ip=pattern.test(ip);
	if(!flag_ip)
	{
		alert("IP地址输入非法!");
		document.all.txtComputerIP.focus();
		return false;
	}
}

function AddHandler()
{
	var obj=document.getElementById('txtClientName');
	var ClientName=obj.value;
	if(ClientName=="") return;
	
	var obj=document.getElementById('txtServerDR');
	var ServerDR=obj.value;
	if(ServerDR=="") return;

	var ComputerActive="N";
	var obj=document.getElementById('chkComputerActive');
	if(obj.checked) ComputerActive="Y";
	
	var obj=document.getElementById('txtComputerIP');
	if(obj) ComputerIP=obj.value;
	else ComputerIP="";
	if(ComputerIP!="")
	{
		var flag=VerifyIPHandler(ComputerIP)
		if(flag==false) return;
	}
	
	var obj=document.getElementById('txtComputerMac');
	var ComputerMac=obj.value;
	if(ComputerMac==" ") ComputerMac=""; 
	//if(ComputerMac=="") return;

	var obj=document.getElementById('txtComputerName');
	var ComputerName=obj.value;
	if(ComputerName==" ") ComputerName=""; 
	//if(ComputerName=="") return;

	var obj=document.getElementById('txtComputerIPUpper');
	var ComputerIPUpper=obj.value;
	if(ComputerIPUpper==" ") ComputerIPUpper=""; 
	//if(ComputerIPUpper=="") return;

	var obj=document.getElementById('txtComputerIPLower');
	var ComputerIPLower=obj.value;
	if(ComputerIPLower==" ") ComputerIPLower="";
	//if(ComputerIPLower=="") return;

	var obj=document.getElementById('txtComputerNote');
	var ComputerNote=obj.value;
	if(ComputerNote==" ") ComputerNote=""; 

	var obj=document.getElementById('MethodInsert');
	if(obj)
	{
		var objInsert=obj.value;
		var retStr=cspRunServerMethod(objInsert,ClientName,ServerDR,ComputerActive,ComputerIP,ComputerMac,ComputerName,ComputerIPUpper,ComputerIPLower,ComputerNote);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnAdd_click();
	}
	
}

function UpdateHandler()
{
	
	var obj=document.getElementById('txtClientId');
	var ClientId=obj.value;
	if(ClientId=="") return;

	var obj=document.getElementById('txtClientName');
	var ClientName=obj.value;
	if(ClientName=="") return;
	
	var obj=document.getElementById('txtServerDR');
	var ServerDR=obj.value;
	if(ServerDR=="") return;

	var ComputerActive="N";
	var obj=document.getElementById('chkComputerActive');
	if(obj.checked) ComputerActive="Y";
	
	var obj=document.getElementById('txtComputerIP');
	if(obj) ComputerIP=obj.value;
	else ComputerIP="";
	if(ComputerIP==" ") ComputerIP="";
	if(ComputerIP!="")
	{
		var flag=VerifyIPHandler(ComputerIP)
		if(flag==false) return;	
	}
	
	var obj=document.getElementById('txtComputerMac');
	var ComputerMac=obj.value;
	if(ComputerMac==" ") ComputerMac="";
	//if(ComputerMac=="") return;

	var obj=document.getElementById('txtComputerName');
	var ComputerName=obj.value;
	if(ComputerName==" ") ComputerName="";
	//if(ComputerName=="") return;

	var obj=document.getElementById('txtComputerIPUpper');
	var ComputerIPUpper=obj.value;
	if(ComputerIPUpper==" ") ComputerIPUpper="";
	//if(ComputerIPUpper=="") return;

	var obj=document.getElementById('txtComputerIPLower');
	var ComputerIPLower=obj.value;
	if(ComputerIPLower==" ") ComputerIPLower="";
	//if(ComputerIPLower=="") return;

	var obj=document.getElementById('txtComputerNote');
	var ComputerNote=obj.value;
	if(ComputerNote==" ") ComputerNote=""; 
	
	var obj=document.getElementById('MethodUpdate');
	if(obj)
	{
		var objUpdate=obj.value;
		var retStr=cspRunServerMethod(objUpdate,ClientId,ClientName,ServerDR,ComputerActive,ComputerIP,ComputerMac,ComputerName,ComputerIPUpper,ComputerIPLower,ComputerNote);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnUpdate_click();
	}
	
}

function DeleteHandler()
{
	var obj=document.getElementById('txtClientId');
	var ClientId=obj.value;
	if(ClientId=="") return;
	var obj=document.getElementById('MethodDelete');
	if(obj)
	{
		var objDelete=obj.value;
		var retStr=cspRunServerMethod(objDelete,ClientId);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnDelete_click();
	}
}
//// ClientName,ServerDR,ComputerActive,ComputerIP,ComputerMac,ComputerName,ComputerIPUpper,ComputerIPLower,ComputerNote
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOLBClientSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('txtClientId');
	var obj1=document.getElementById('txtComputerName');
	var obj2=document.getElementById('txtClientName');
	var obj3=document.getElementById('txtComputerIP');
	var obj4=document.getElementById('txtComputerMac');
	var obj5=document.getElementById('txtComputerIPUpper');
	var obj6=document.getElementById('txtComputerIPLower');
	var obj7=document.getElementById('txtComputerNote');
	var obj8=document.getElementById('chkComputerActive');
	var obj9=document.getElementById('txtServerDR');
	var obj10=document.getElementById('txtServerName');


	var SelRowObj=document.getElementById('ClientIdz'+selectrow);
	var SelRowObj1=document.getElementById('ComputerNamez'+selectrow);
	var SelRowObj2=document.getElementById('ClientNamez'+selectrow);
	var SelRowObj3=document.getElementById('ComputerIPz'+selectrow);
	var SelRowObj4=document.getElementById('ComputerMacz'+selectrow);
	var SelRowObj5=document.getElementById('ComputerIPUpperz'+selectrow);
	var SelRowObj6=document.getElementById('ComputerIPLowerz'+selectrow);
	var SelRowObj7=document.getElementById('ComputerNotez'+selectrow);
	var SelRowObj8=document.getElementById('ComputerActivez'+selectrow);
	var SelRowObj9=document.getElementById('ServerDRz'+selectrow);
	var SelRowObj10=document.getElementById('ServerNamez'+selectrow);

	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;
	if(obj1&&SelRowObj1) obj1.value=SelRowObj1.innerText;
	if(obj2&&SelRowObj2) obj2.value=SelRowObj2.innerText;
	if(obj3&&SelRowObj3) obj3.value=SelRowObj3.innerText;
	if(obj4&&SelRowObj4) obj4.value=SelRowObj4.innerText;
	if(obj5&&SelRowObj5) obj5.value=SelRowObj5.innerText;
	if(obj6&&SelRowObj6) obj6.value=SelRowObj6.innerText;
	if(obj7&&SelRowObj7) obj7.value=SelRowObj7.innerText;
	if(obj8&&SelRowObj8)
	{
		if(SelRowObj8.innerText=="Y") obj8.checked=true;
		else obj8.checked=false;
	}
	if(obj9&&SelRowObj9) obj9.value=SelRowObj9.innerText;
	if(obj10&&SelRowObj10) obj10.value=SelRowObj10.innerText;
}
function ServerSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtServerName');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtServerDR');
	if (obj) obj.value=ret[0]
}
window.document.body.onload=BodyLoadHandler;