
function BodyLoadHandler() {
	var obj=document.getElementById("btnAdd")
	if (obj) obj.onclick=AddHandler;
	var obj=document.getElementById("btnUpdate")
	if (obj) obj.onclick=UpdateHandler;
	var obj=document.getElementById("btnDelete")
	if (obj) obj.onclick=DeleteHandler;
}

function AddHandler()
{
	var obj=document.getElementById('txtPlanName');
	var PlanName=obj.value;
	if(PlanName=="") return;
	
	var obj=document.getElementById('txtSysFlag');
	var SysFlag=obj.value;
	if(SysFlag=="") return;
	if(SysFlag=="on") SysFlag="Y"
	else SysFlag="N"

	var obj=document.getElementById('txtServerName');
	var ServerName=obj.value;
	
	var obj=document.getElementById('txtServerDR');
	var ServerDR=obj.value;
	if(ServerName=="") ServerDR="";
	
	var obj=document.getElementById('txtClientName');
	var ClientName=obj.value;
	if(ClientName==" ") ClientName="";

	var obj=document.getElementById('txtClientDR');
	var ClientDR=obj.value;
	if(ClientName=="") ClientDR="";
	
	var obj=document.getElementById('txtURL');
	var URL=obj.value;
	if(URL==" ") URL="";
	if(URL=="") return;
	
	var obj=document.getElementById('txtNote');
	var Note=obj.value;
	if(Note==" ") Note="";
	
	if(ClientDR!="")
	{
		SysFlag="N"
		ServerDR=""
	}
	if(ServerDR!="")
	{
		SysFlag="N"
		ServerDR=""
	}
	if((ClientDR=="")&&(ServerDR=="")) SysFlag="Y"
	var obj=document.getElementById('MethodInsert');
	if(obj)
	{
		var objInsert=obj.value;
		var retStr=cspRunServerMethod(objInsert,PlanName,SysFlag,ServerDR,ClientDR,URL,Note);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnAdd_click();
	}
	
}

function UpdateHandler()
{
	var obj=document.getElementById('txtPlanDR');
	var PlanDR=obj.value;
	if(PlanDR=="") return;
	
	var obj=document.getElementById('txtPlanName');
	var PlanName=obj.value;
	if(PlanName=="") return;
	
	var obj=document.getElementById('txtSysFlag');
	var SysFlag=obj.value;
	if(SysFlag=="") return;
	if(SysFlag=="on") SysFlag="Y"
	else SysFlag="N"

	var obj=document.getElementById('txtServerName');
	var ServerName=obj.value;
	
	var obj=document.getElementById('txtServerDR');
	var ServerDR=obj.value;
	if(ServerName=="") ServerDR="";
	
	var obj=document.getElementById('txtClientName');
	var ClientName=obj.value;
	if(ClientName==" ") ClientName="";

	var obj=document.getElementById('txtClientDR');
	var ClientDR=obj.value;
	if(ClientName=="") ClientDR="";
	
	var obj=document.getElementById('txtURL');
	var URL=obj.value;
	if(URL==" ") URL="";
	if(URL=="") return;
	
	var obj=document.getElementById('txtNote');
	var Note=obj.value;
	if(Note==" ") Note="";
	
	if(ClientDR!="")
	{
		SysFlag="N"
		ServerDR=""
	}
	if(ServerDR!="")
	{
		SysFlag="N"
	}
	if((ClientDR=="")&&(ServerDR=="")) SysFlag="Y"
	var obj=document.getElementById('MethodUpdate');
	if(obj)
	{
		var objUpdate=obj.value;
		var retStr=cspRunServerMethod(objUpdate,PlanDR,PlanName,SysFlag,ServerDR,ClientDR,URL,Note);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnUpdate_click();
	}
}

function DeleteHandler()
{
	var obj=document.getElementById('txtPlanDR');
	var PlanDR=obj.value;
	if(PlanDR=="") return;
	var obj=document.getElementById('MethodDelete');
	if(obj)
	{
		var objDelete=obj.value;
		var retStr=cspRunServerMethod(objDelete,PlanDR);
		if(retStr=="0") alert("OK");
		else  alert(retStr)
		btnDelete_click();
	}
}

function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCVISPlayPlanSet');
	var rows=objtbl.rows.length;
	var lastrowindex=rows-1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) return;
	var obj1=document.getElementById('txtPlanDR');
	var obj2=document.getElementById('txtPlanName');
	var obj3=document.getElementById('txtSysFlag');
	var obj4=document.getElementById('txtServerName');
	var obj5=document.getElementById('txtServerDR');
	var obj6=document.getElementById('txtClientName');
	var obj7=document.getElementById('txtClientDR');
	var obj8=document.getElementById('txtURL');
	var obj9=document.getElementById('txtNote');
	
	var SelRowObj1=document.getElementById('PlanDRz'+selectrow);
	var SelRowObj2=document.getElementById('PlanNamez'+selectrow);
	var SelRowObj3=document.getElementById('SysFlagz'+selectrow);
	var SelRowObj4=document.getElementById('ServerNamez'+selectrow);
	var SelRowObj5=document.getElementById('ServerDRz'+selectrow);
	var SelRowObj6=document.getElementById('ClientNamez'+selectrow);
	var SelRowObj7=document.getElementById('ClientDRz'+selectrow);
	var SelRowObj8=document.getElementById('URLz'+selectrow);
	var SelRowObj9=document.getElementById('Notez'+selectrow);
	
	if(obj1&&SelRowObj1)
	{
		obj1.value=SelRowObj1.value;
		var PlanDR=SelRowObj1.value;
	}
	if(obj2&&SelRowObj2) obj2.value=SelRowObj2.innerText;
	if(obj3&&SelRowObj3)
	{
		if(SelRowObj3.innerText=="Y") obj3.checked=true;
		else obj3.checked=false;
	}
	if(obj4&&SelRowObj4) obj4.value=SelRowObj4.innerText;
	if(obj5&&SelRowObj5) obj5.value=SelRowObj5.value;
	if(obj6&&SelRowObj6) obj6.value=SelRowObj6.innerText;
	if(obj7&&SelRowObj7) obj7.value=SelRowObj7.value;
	if(obj8&&SelRowObj8) obj8.value=SelRowObj8.innerText;
	if(obj9&&SelRowObj9) obj9.value=SelRowObj9.innerText;
	
    var lnk;
    lnk= "websys.default.csp?WEBSYS.TCOMPONENT=DHCVISPlayPlanItemSet&txtPlanDR="+PlanDR;
    parent.frames["DHCVISPlayPlanItemSet"].location.href=lnk; 

}
function ServerSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtServerName');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtServerDR');
	if (obj) obj.value=ret[0]
}
function ClientSelect(str){
	var ret=str.split("^");
	var obj=document.getElementById('txtClientName');
	if (obj) obj.value=ret[2]
	var obj=document.getElementById('txtClientDR');
	if (obj) obj.value=ret[0]
}
window.document.body.onload=BodyLoadHandler;