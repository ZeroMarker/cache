var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
function SetPatNoLength(PatNo)
{
	var obj=document.getElementById('PatNo');
	if (obj) {
		var PatNo=obj.value;
		if (PatNo!==""){
			var objM=document.getElementById('MethodRegNoCon');
		    if (objM) {var encmeth=objM.value} else {var encmeth=''}
		    var ret=cspRunServerMethod(encmeth,PatNo);
		    obj.value=ret;
		}
	}
}

function PatNo_OnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	SetPatNoLength();
	var PatNo=getElementValue("PatNo",null);
	ClearItems();
	setElementValue("PatNo",PatNo,null);
	xPatNoOnKeyDown();
	return false;
}

function InitForm()
{
	var MrTypeDr=getElementValue("MrType",null);
	objMrType = GetDHCWMRDictionaryByID("MethodGetDicItem", MrTypeDr);
	if(objMrType != null)
	{
		setElementValue("MrTypeDesc", objMrType.Description);
	}
	
	var obj=document.getElementById("PatNo");
	if (obj){
		obj.onkeydown=PatNo_OnKeyDown;
	}
	
	var obj=document.getElementById("MrNo");
	if (obj){
		obj.onkeydown=MrNoOnKeyDown;
	}
	///////////add by liuxuefeng 2009-07-01/////////////
	var obj=document.getElementById("PatName");
	if (obj){
		obj.onkeydown=PatNameOnKeyDown;
	}
	/////////////////////End//////////////////////////
}

function ClearItems()
{
	setElementValue("PatNo","",null);
	setElementValue("MrNo","",null);
	setElementValue("PatName","",null); //add by liuxuefeng 2009-07-01
}

function xPatNoOnKeyDown()
{
	var PatNo=getElementValue("PatNo",null);
	if (PatNo){
		DisplayResult(PatNo,"");
	}
}

function MrNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	/////////////add by liuxuefeng 2009-08-19///////////
	FormatInputMrNo("MrType","MrNo");
	///////////////////// End ////////////////////////
	var MrNo=getElementValue("MrNo");
	ClearItems();
	setElementValue("MrNo",MrNo,null);
	if (MrNo){
		DisplayResult("",MrNo);
	}
	return false;
}

function DisplayResult(PatNo,MrNo)
{
	var PatName=getElementValue("PatName");
	if ((!PatNo)&&(!MrNo)&&(!PatName)) return;
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MainByNo.List" + "&MrTypeDR=" +getElementValue("MrType",null)+"&PatientNo="+PatNo+"&MrNO="+MrNo+"&IsActive=Y" + "&MrType=" +getElementValue("MrType",null);
	parent.RPMain.location.href=lnk;
}
///////////add by liuxuefeng 2009-07-01/////////////
function PatNameOnKeyDown()
{
	//modify Files:web.DHCWMRMainQry\web.DHCWMRMedBaseCtl\DHC.WMR.DataAccess.js
	if(window.event.keyCode != 13)
		return;
	var PatName=getElementValue("PatName");
	var MrType=getElementValue("MrType",null);
	var MrNoStr=GetMrNoStrByPatName("MethodGetMrNoStrByPatName",PatName,MrType);
	ClearItems();
	setElementValue("PatName",PatName,null);
	DisplayResult("",MrNoStr);
	return false;
}
/////////////////////End//////////////////////////
InitForm();
