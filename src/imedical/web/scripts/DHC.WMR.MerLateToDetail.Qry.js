///DHC.WMR.MerLateToDetail.Qry
/// 名称: DHC.WMR.MerLateToDetail.Qry 
/// Creator：     liulan
/// CreatDate：   2012-11-27
/// Description:  病案迟归查询:查询病案未按时完成明细表
function InitFrom()
{   
	DisplayWorkItems();
	DisplayMrType();
	/*
	var obj=document.getElementById("cmdQuery");
	if (obj){ obj.onclick=cmdQuery_click;}*/
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
function txtLocDesc_onchange()
{
	if (document.getElementById("txtLocDesc").value=="")
	{
		document.getElementById("txtLocId").value="";
	}
}
function LookUpLocDesc(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtLocId").value=tmpList[0];
	document.getElementById("txtLocDesc").value=tmpList[1];
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
	    		//alert(ret)  
	    		if (ret=="") continue;
	    		tmpListSub=ret.split("^");
	    		var objItm=document.createElement("OPTION");
	    		
			obj.options.add(objItm);
			objItm.innerText = tmpListSub[2];
			//alert(objItm.innerText)
			objItm.value = tmpListSub[0];
    		}
    		if (tmpList.length>0) (obj.selectedIndex=-1);        //modify by liulan 2012-11-20  操作项不显示初始化状态
	}
}

function cmdQueryclick()
{
	var MrTypeDr=getElementValue("MrTypeDr");
	var From=getElementValue("From");
	var To=getElementValue("To");
	var StatusID=getElementValue("StatusID");
	var MinPeriod=getElementValue("MinPeriod");
	var MaxPeriod=getElementValue("MaxPeriod");
	var RestDay=getElementValue("RestDay");		
	var WorkDay=getElementValue("WorkDay");	
	var LocId=""
	var obj=document.getElementById("txtLocId");
	if(obj) {LocId=obj.value;}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MerLateToDetail.List"+"&MrTypeDr=" +MrTypeDr+ "&From=" +From+"&To="+To+"&StatusID="+StatusID +"&MinPeriod="+MinPeriod +"&MaxPeriod="+MaxPeriod +"&RestDay="+RestDay+"&WorkDay="+WorkDay+"&LocId="+LocId;
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
	var obj=document.getElementById("txtLocDesc");
	if (obj){obj.onchange=txtLocDesc_onchange;}
}
function cmdExport_onclick()
{ 	
	var objLnk=parent.RPbottom;
	var MrTypeDr=GetParam(objLnk,"MrTypeDr");
	var From=GetParam(objLnk,"From");
	var To=GetParam(objLnk,"To");
	var StatusID=GetParam(objLnk,"StatusID");
	var MinPeriod=GetParam(objLnk,"MinPeriod");
	var MaxPeriod=GetParam(objLnk,"MaxPeriod");
	var RestDay=GetParam(objLnk,"RestDay");
	var WorkDay=GetParam(objLnk,"WorkDay");
	var LocId=""
	var obj=document.getElementById("txtLocId");
	if(obj) {LocId=obj.value;}
	var cArguments=MrTypeDr+"^"+From+"^"+To+"^"+StatusID+"^"+MinPeriod+"^"+MaxPeriod+"^"+RestDay+"^"+WorkDay+"^"+LocId;
	var flg=ExportDataToExcel("MethodGetServer","MethodGetData","DHCWMRMerLateToDetail.xls",cArguments);
}
function cmdPrint_onclick()
{
	var objLnk=parent.RPbottom;
	var MrTypeDr=GetParam(objLnk,"MrTypeDr");
	var From=GetParam(objLnk,"From");
	var To=GetParam(objLnk,"To");
	var StatusID=GetParam(objLnk,"StatusID");
	var MinPeriod=GetParam(objLnk,"MinPeriod");
	var MaxPeriod=GetParam(objLnk,"MaxPeriod");
	var RestDay=GetParam(objLnk,"RestDay");
	var WorkDay=GetParam(objLnk,"WorkDay");
	var cArguments=MrTypeDr+"^"+From+"^"+To+"^"+StatusID+"^"+MinPeriod+"^"+MaxPeriod+"^"+RestDay+"^"+WorkDay;
	var flg=PrintDataByExcel("MethodGetServer","MethodGetData","DHCWMRMerLateToDetail.xls",cArguments);
}

InitFrom();
InitEvents();				



