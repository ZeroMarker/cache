function BodyLoadHandler() {
	var obj=document.getElementById("btnAdd")
	if (obj) obj.onclick=AddHandler;
	var obj=document.getElementById("btnUpdate")
	if (obj) obj.onclick=UpdateHandler;
	var obj=document.getElementById("btnDelete")
	if (obj) obj.onclick=DeleteHandler;
	var obj=document.getElementById("btnClearLoadInfo")
	if (obj) obj.onclick=ClearHandler;
}
function VerifyIPHandler(ip)
{
	var pattern=/^(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9])\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[1-9]|0)\.(25[0-5]|2[0-4][0-9]|[0-1]{1}[0-9]{2}|[1-9]{1}[0-9]{1}|[0-9])$/;
	flag_ip=pattern.test(ip);
	if(!flag_ip)
	{
		alert("IP地址输入非法!");
		document.all.txtSiteIP.focus();
		return false;
	}
}

///

function AddHandler()
{
	var obj=document.getElementById('txtOLBName');
	var OLBName=obj.value;
	if (OLBName=="") return;
	
	var obj=document.getElementById('txtSiteName');
	var SiteName=obj.value;
	if(SiteName=="") return;

	var obj=document.getElementById('txtSiteIP');
	if(obj) SiteIP=obj.value;
	else SiteIP="";
	if((SiteIP!="")&&(SiteIP!=" "))
	{
		var flag=VerifyIPHandler(SiteIP)
		if(flag==false) return;	
	}	
	
	var obj=document.getElementById('txtApplication');
	var Application=obj.value;
	if(Application=="") return;

	var obj=document.getElementById('txtSiteNote');
	var SiteNote=obj.value;
	if(SiteNote==" ") SiteNote=""; 

	
	var obj=document.getElementById('MethodInsert');
	if(obj)
	{
		var objInsert=obj.value;
		var retStr=cspRunServerMethod(objInsert,OLBName,SiteIP,SiteName,Application,SiteNote);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnAdd_click();
	}
	
}


function UpdateHandler()
{	
	var obj=document.getElementById('txtSiteId');
	var SiteId=obj.value;
	if(SiteId=="") return;

	var obj=document.getElementById('txtOLBName');
	var OLBName=obj.value;
	if (OLBName=="") return;
	
	var obj=document.getElementById('txtSiteName');
	var SiteName=obj.value;
	if(SiteName=="") return;
	
	var obj=document.getElementById('txtSiteIP');
	if(obj) SiteIP=obj.value;
	else SiteIP="";
	if((SiteIP!="")&&(SiteIP!=" "))
	{
		var flag=VerifyIPHandler(SiteIP)
		if(flag==false) return;	
	}
	
	var obj=document.getElementById('txtApplication');
	var Application=obj.value;
	if(Application=="") return;

	var obj=document.getElementById('txtSiteNote');
	var SiteNote=obj.value;
	if(SiteNote==" ") SiteNote=""; 
		
	var obj=document.getElementById('MethodUpdate');
	if(obj)
	{
		var objUpdate=obj.value;
		var retStr=cspRunServerMethod(objUpdate,SiteId,OLBName,SiteIP,SiteName,Application,SiteNote);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnUpdate_click();
	}
}

function DeleteHandler()
{
	var obj=document.getElementById('txtSiteId');
	var SiteId=obj.value;
	if(SiteId=="") return;
	var obj=document.getElementById('MethodDelete');
	if(obj)
	{
		var objDelete=obj.value;
		var retStr=cspRunServerMethod(objDelete,SiteId);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnDelete_click();
	}
}
function ClearHandler()
{
	var obj=document.getElementById('MethodClearLoadInfo');
	if(obj)
	{
		var objClear=obj.value;
		var retStr=cspRunServerMethod(objClear);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnClearLoadInfo_click();
	}
}
//// ClientName,ServerDR,ComputerActive,ComputerIP,ComputerMac,ComputerName,ComputerIPUpper,ComputerIPLower,ComputerNote
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCOLBProfileSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj=document.getElementById('txtSiteId');
	var obj1=document.getElementById('txtOLBName');
	var obj2=document.getElementById('txtSiteName');
	var obj3=document.getElementById('txtSiteIP');
	var obj4=document.getElementById('txtApplication');
	var obj5=document.getElementById('txtSiteNote');

	//// txtSiteId txtOLBName txtSiteName txtSiteIP txtApplication txtSiteNote
	var SelRowObj=document.getElementById('SiteIdz'+selectrow);
	var SelRowObj1=document.getElementById('OLBNamez'+selectrow);
	var SelRowObj2=document.getElementById('SiteNamez'+selectrow);
	var SelRowObj3=document.getElementById('SiteIPz'+selectrow);
	var SelRowObj4=document.getElementById('Applicationz'+selectrow);
	var SelRowObj5=document.getElementById('SiteNotez'+selectrow);

	if(obj&&SelRowObj) obj.value=SelRowObj.innerText;
	if(obj1&&SelRowObj1) obj1.value=SelRowObj1.innerText;
	if(obj2&&SelRowObj2) obj2.value=SelRowObj2.innerText;
	if(obj3&&SelRowObj3) obj3.value=SelRowObj3.innerText;
	if(obj4&&SelRowObj4) obj4.value=SelRowObj4.innerText;
	if(obj5&&SelRowObj5) obj5.value=SelRowObj5.innerText;
}

window.document.body.onload=BodyLoadHandler;