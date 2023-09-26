function BodyLoadHandler()
{
	var obj=document.getElementById("btnFind");
	if (obj){obj.onclick=btnFind_onclick;}
	var obj=document.getElementById("btnPrint");
	if (obj){obj.onclick=btnPrint_onclick;}
	var obj=document.getElementById("txtRegNo");
	if (obj){obj.onkeydown=txt_OnKeyDown;}
	var obj=document.getElementById("txtMrNo");
	if (obj){obj.onkeydown=txt_OnKeyDown;}
	var obj=document.getElementById("txtPatName");
	if (obj){obj.onkeydown=txt_OnKeyDown;}
	var obj=document.getElementById("txtDiagDesc");
	if (obj){obj.onchange=txtDiagDesc_OnChange;}
}

function ClearInfo()
{
	var obj=document.getElementById("txtRegNo");
	if (obj){obj.value="";}
	var obj=document.getElementById("txtMrNo");
	if (obj){obj.value="";}
	var obj=document.getElementById("txtPatName");
	if (obj){obj.value="";}
	var obj=document.getElementById("txtDiagDesc");
	if (obj){obj.value="";}
	var obj=document.getElementById("txtDiagID");
	if (obj){obj.value="";}
}

function txt_OnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	btnFind_onclick();
	ClearInfo();
	return false;
}

function txtDiagDesc_OnChange()
{
	var obj=document.getElementById("txtDiagID");
	if (obj){obj.value="";}
}

function btnFind_onclick()
{
	var cRegNo="",cMrType="",cMrNo="",cPatName="",cDiagType="",cDiagID="",cOperType="",cOperID="",cDateFrom="",cDateTo="";
	var obj=document.getElementById("txtRegNo");
	if (obj){cRegNo=obj.value;}
	var obj=document.getElementById("txtMrType");
	if (obj){cMrType=obj.value;}
	var obj=document.getElementById("txtMrNo");
	if (obj){cMrNo=obj.value;}
	var obj=document.getElementById("txtPatName");
	if (obj){cPatName=obj.value;}
	var obj=document.getElementById("txtDiagType");
	if (obj){cDiagType=obj.value;}
	var obj=document.getElementById("txtDiagID");
	if (obj){cDiagID=obj.value;}
	var obj=document.getElementById("txtOperType");
	if (obj){cOperType=obj.value;}
	var obj=document.getElementById("txtOperID");
	if (obj){cOperID=obj.value;}
	var obj=document.getElementById("txtDateFrom");
	if (obj){cDateFrom=obj.value;}
	var obj=document.getElementById("txtDateTo");
	if (obj){cDateTo=obj.value;}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.Circul.QryFPByColl.List" + "&Arguments=" + cRegNo + "^" + cMrType + "^" + cMrNo + "^" + cPatName + "^" + cDiagType + "^" + cDiagID + "^" + cOperType + "^" + cOperID + "&DateFrom=" + cDateFrom + "&DateTo=" + cDateTo;
	parent.RPbottom.location.href=lnk;
}

function LookUpDiagType(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtDiagTypeID").value=tmpList[0];
	document.getElementById("txtDiagType").value=tmpList[1];
}

function LookUpOperType(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtOperTypeID").value=tmpList[0];
	document.getElementById("txtOperType").value=tmpList[1];
}


function LookUpDiagnose(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtDiagID").value=tmpList[0];
	document.getElementById("txtDiagDesc").value=tmpList[2];
}

function LookUpOperation(str)
{
	var tmpList=str.split("^");
	document.getElementById("txtOperID").value=tmpList[0];
	document.getElementById("txtOperDesc").value=tmpList[2];
}

function btnPrint_onclick()
{
	var objLnk=parent.RPbottom;
	var cArguments=GetParam(objLnk,"Arguments");
	var cDateFrom=GetParam(objLnk,"DateFrom");
	var cDateTo=GetParam(objLnk,"DateTo");
	var strArguments=cArguments+"&"+cDateFrom+"&"+cDateTo
	var flg=PrintDataByExcel("MethodGetServer","MethodGetData","DHCWMRCirculQryFPByColl.xls",strArguments);
}

document.body.onload=BodyLoadHandler;