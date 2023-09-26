///DHC.WMR.MerLateTo.Qry.js
/// 名称: DHC.WMR.MerLateTo.Qry.js 
/// Creator：     liulan
/// CreatDate：   2012-11-22
/// Description:  病案迟归查询:查询病案未按时完成汇总表
function InitFrom()
{   
	DisplayWorkItems();
	DisplayMrType();
	
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=cmdQuery_click;}
}

function DisplayMrType()
{
	var DicRowid = GetParam(window,"MrType");
	var strMethod = document.getElementById("MethodGetDicItem").value;
	var ret = cspRunServerMethod(strMethod,DicRowid);
	if (ret=="") return;
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		document.getElementById("MrTypeDr").value=tmpList[0];
		document.getElementById("txtMrType").value=tmpList[2];
		
	}
}
function DisplayWorkItems()
{
	var obj=document.getElementById("StatusID");
	if (obj)
	{
		
		obj.size=1;
		obj.multiple=false;
		
		var ItemStr = GetParam(window,"ItemStr");
		
		if (ItemStr=="") return;
		obj.length=0;
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
    		if (tmpList.length>0) (obj.selectedIndex=-1);       
	}
}

function cmdQueryclick()
{
	var MrTypeDr=getElementValue("MrTypeDr");
	var From=getElementValue("From");
	var To=getElementValue("To");
	var StatusID=getElementValue("StatusID");
	var RestDay=getElementValue("RestDay");		
	var WorkDay=getElementValue("WorkDay");	
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MerLateTo.List"+"&MrTypeDr=" +MrTypeDr+ "&From=" +From+"&To="+To+"&StatusID="+StatusID +"&RestDay="+RestDay+"&WorkDay="+WorkDay;
    parent.RPbottom.location.href=lnk;
}
function InitEvents()
{
	var obj=document.getElementById("cmdExport");
	if (obj) {obj.onclick=cmdExport_onclick;}
	var obj=document.getElementById("cmdPrint");
	if (obj) {obj.onclick=cmdPrint_onclick;}
	var obj=document.getElementById("cmdQuery");
	if (obj) {obj.onclick = cmdQueryclick;}
	
}
function cmdExport_onclick()
{ 	
	var objLnk=parent.RPbottom;
	var MrTypeDr=GetParam(objLnk,"MrTypeDr");
	var From=GetParam(objLnk,"From");
	var To=GetParam(objLnk,"To");
	var StatusID=GetParam(objLnk,"StatusID");
	var RestDay=GetParam(objLnk,"RestDay");
	var WorkDay=GetParam(objLnk,"WorkDay");
	var cArguments=MrTypeDr+"^"+From+"^"+To+"^"+StatusID+"^"+RestDay+"^"+WorkDay;
	var flg=ExportDataToExcel("MethodGetServer","MethodGetData","DHCWMRMerLateToList.xls",cArguments);
}
function cmdPrint_onclick()
{
	var objLnk=parent.RPbottom;
	var MrTypeDr=GetParam(objLnk,"MrTypeDr");
	var From=GetParam(objLnk,"From");
	var To=GetParam(objLnk,"To");
	var StatusID=GetParam(objLnk,"StatusID");
	var RestDay=GetParam(objLnk,"RestDay");
	var WorkDay=GetParam(objLnk,"WorkDay");
	
	var cArguments=MrTypeDr+"^"+From+"^"+To+"^"+StatusID+"^"+RestDay+"^"+WorkDay;
	var flg=PrintDataByExcel("MethodGetServer","MethodGetData","DHCWMRMerLateToList.xls",cArguments);
}
InitFrom();
InitEvents();				



