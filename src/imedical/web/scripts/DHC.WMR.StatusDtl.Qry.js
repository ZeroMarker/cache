var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_Up="^";
var CHR_Tilted="/";

function InitFrom()
{
	DisplayMrType();
	DisplayWorkItems();
	DisplayWorkItemDtl();
	InitEnvent();
}

function InitEnvent()
{
	var obj=document.getElementById("cmdQuery");
	if (obj){obj.onclick=Query_click;}
	var obj=document.getElementById("cboStatus");
	if (obj){obj.onchange=cboStatus_click;}	
}

function DisplayWorkItems()
{
	var obj=document.getElementById("cboStatus");
	if (obj)
	{
		obj.size=1;
		obj.multiple=false;
		
		var ItemStr = GetParam(window,"ItemStr");
		if (ItemStr=="") return;
		obj.length=0
		var tmpList=ItemStr.split("|");
		var strMethod = document.getElementById("MethodGetItemById").value;
		for (var i=0;i<tmpList.length;i++)
		{
			if (tmpList[i]=="") continue;
	    		var ret=cspRunServerMethod(strMethod,tmpList[i]);
	    		if (ret=="") continue;
	    		tmpListSub=ret.split("^");
	    		var objItm=document.createElement("OPTION");
			obj.options.add(objItm);
			objItm.innerText = tmpListSub[2];
			objItm.value = tmpListSub[0];
    		}
    		if (tmpList.length>0) (obj.selectedIndex=0);
	}
}

function DisplayWorkItemDtl()
{
	var obj=document.getElementById("cboStatusDtl");
	if (obj)
	{
		obj.size=1;
		obj.multiple=false;
		obj.length=0;
		
		var cStatusId=getElementValue("cboStatus");
		if (cStatusId=="") return;
		var strMethod=document.getElementById('MethodGetStatusDtl').value;
		var StatusDtl=cspRunServerMethod(strMethod,cStatusId,"Y");
		if (StatusDtl!="")
		{
			var Temp1=StatusDtl.split(CHR_1);
			for (var i=1;i<Temp1.length;i++)
			{
				var Temp2=Temp1[i].split("^");
				var oOption = document.createElement("OPTION");
			        oOption.text=Temp2[1];
			        oOption.value=Temp2[0];
			        obj.add(oOption);
			}
		}
		
	}
}

function DisplayMrType()
{
	var DicRowid = GetParam(window,"MrType");
	var strMethod = document.getElementById("MethodGetDicById").value;
	var ret = cspRunServerMethod(strMethod,DicRowid);
	if (ret=="") return;
	var tmpList=ret.split("^");
	if (tmpList.length>=3)
	{
		document.getElementById("MrTypeRowid").value=tmpList[0];
		document.getElementById("txtMrType").value=tmpList[3];
	}
}

function cboStatus_click()
{
	DisplayWorkItemDtl();
}

function Query_click()
{
	var cMrTypeId=getElementValue("MrTypeRowid");
	var cStatusId=getElementValue("cboStatus");
	var cStatusDtlId=getElementValue("cboStatusDtl");
	var cFromDate=getElementValue("txtFromDate");
	var cToDate=getElementValue("txtToDate");
	var QryType = GetParam(window,"QryType");
	var IsCurrSta = (getElementValue("chkIsCurrSta")==true ? "Y" : "N");
	if ((!cMrTypeId)||(!cStatusId)||(!cStatusDtlId)||(!cFromDate)||(!cToDate)) return;
	if ((cMrTypeId=="")||(cStatusId=="")||(cStatusDtlId=="")||(cFromDate=="")||(cToDate=="")) return;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.StatusDtl.List" +"&MrTypeDr="+cMrTypeId+"&ItemDr="+cStatusId+"&DetailDr="+cStatusDtlId+"&FromDate="+cFromDate+"&ToDate="+cToDate+"&QryType="+QryType+"&IsCurrSta="+IsCurrSta;
	parent.RPbottom.location.href=lnk;
}

InitFrom();