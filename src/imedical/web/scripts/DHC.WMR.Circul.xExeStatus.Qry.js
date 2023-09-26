function InitForm()
{
	DisplayMrType();
	DisplayWorkItems();
	InitEvent();
}

function InitEvent()
{
	var obj=document.getElementById("txtUserFromDesc");
	if (obj) {obj.onchange=txtUserFromDesc_onchange;}
	var obj=document.getElementById("txtUserToDesc");
	if (obj) {obj.onchange=txtUserToDesc_onchange;}
	
	var obj=document.getElementById("btnQuery");
	if (obj) {obj.onclick=btnQuery_onclick;}
}

function btnQuery_onclick()
{
	var MrType=getElementValue("txtMrTypeId");
	var ItemId=getElementValue("cboWorkItem");
	var UserFrom=getElementValue("txtUserFromId");
	var UserTo=getElementValue("txtUserToId");
	var DateFrom=getElementValue("txtDateFrom");
	var DateTo=getElementValue("txtDateTo");
	var IsCurrStatus=(getElementValue("chkCurrStatus")==true ? "Y" : "N")
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Circul.xExeStatus.List"+"&MrType=" +MrType+ "&ItemId=" +ItemId+ "&DateFrom=" +DateFrom+ "&DateTo=" +DateTo+ "&UserFrom=" +UserFrom+ "&UserTo=" +UserTo+"&IsCurrStatus=" +IsCurrStatus;
	parent.RPbottom.location.href=lnk;
}

function LookupUserFrom(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtUserFromId").value=tmpList[0];
	document.getElementById("txtUserFromDesc").value=tmpList[2];
}

function LookupUserTo(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtUserToId").value=tmpList[0];
	document.getElementById("txtUserToDesc").value=tmpList[2];
}

function txtUserFromDesc_onchange()
{
	if (document.getElementById("txtUserFromDesc").value=="")
	{
		document.getElementById("txtUserFromId").value="";
	}
}

function txtUserToDesc_onchange()
{
	if (document.getElementById("txtUserToDesc").value=="")
	{
		document.getElementById("txtUserToId").value="";
	}
}

function DisplayMrType()
{
	var DicRowid = GetParam(window,"MrType");
	var strMethod = document.getElementById("MethodGetDicById").value;
	var ret = cspRunServerMethod(strMethod,DicRowid);
	if (ret=="") return;
	var tmpList=ret.split("^");
	if (tmpList.length>=2)
	{
		document.getElementById("txtMrTypeId").value=tmpList[0];
		document.getElementById("txtMrTypeDesc").value=tmpList[2];
	}
}

function DisplayWorkItems()
{
	var obj=document.getElementById("cboWorkItem");
	if (obj)
	{
		obj.size=1;
		obj.multiple=false;
		obj.length=0
		
		var ItemStr = GetParam(window,"ItemStr");
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

InitForm();