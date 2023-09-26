function InitForm()
{
	DisplayMrType();
	InitEvent();
}

function InitEvent()
{
	var obj=document.getElementById("txtRegNo");
	if (obj) {obj.onkeydown=txtRegNo_onkeydown;}
	var obj=document.getElementById("txtMrNo");
	if (obj) {obj.onkeydown=txtMrNo_onkeydown;}
	var obj=document.getElementById("txtIPNo");
	if (obj) {obj.onkeydown=txtIPNo_onkeydown;}
	var obj=document.getElementById("txtBarCode");
	if (obj) {obj.onkeydown=txtBarCode_onkeydown;}
	
	var obj=document.getElementById("btnQuery");
	if (obj) {obj.onclick=btnQuery_onclick;}
}

function btnQuery_onclick()
{
	var MrType=getElementValue("txtMrTypeId");
	var RegNo=getElementValue("txtRegNo");
	var MrNo=getElementValue("txtMrNo");
	var IPNo=getElementValue("txtIPNo");
	var BarCode=getElementValue("txtBarCode");
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Circul.xVolumeByNo.List"+"&MrType=" +MrType+ "&RegNo=" +RegNo+ "&MrNo=" +MrNo+ "&IPNo=" +IPNo+ "&BarCode=" +BarCode;
	parent.RPbottom.location.href=lnk;
}

function txtRegNo_onkeydown()
{
	if(window.event.keyCode != 13) return;
	setElementValue("txtMrNo","");
	setElementValue("txtIPNo","");
	setElementValue("txtBarCode","");
	btnQuery_onclick();
	setElementValue("txtRegNo","");
	return false;
}

function txtMrNo_onkeydown()
{
	if(window.event.keyCode != 13) return;
	setElementValue("txtRegNo","");
	setElementValue("txtIPNo","");
	setElementValue("txtBarCode","");
	btnQuery_onclick();
	setElementValue("txtMrNo","");
	return false;
}

function txtIPNo_onkeydown()
{
	if(window.event.keyCode != 13) return;
	setElementValue("txtRegNo","");
	setElementValue("txtMrNo","");
	setElementValue("txtBarCode","");
	btnQuery_onclick();
	setElementValue("txtIPNo","");
	return false;
}

function txtBarCode_onkeydown()
{
	if(window.event.keyCode != 13) return;
	setElementValue("txtRegNo","");
	setElementValue("txtMrNo","");
	setElementValue("txtIPNo","");
	btnQuery_onclick();
	setElementValue("txtBarCode","");
	return false;
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

InitForm();