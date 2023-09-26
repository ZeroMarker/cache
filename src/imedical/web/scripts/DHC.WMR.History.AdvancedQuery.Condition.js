/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.History.AdvancedQuery.Condition.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-21
========================================================================= */
var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","HistoryAdvancedQueryCond");
//alert(tmpChinese[0]+"||"+tmpChinese[1]+"||"+tmpChinese[2]);

function cmdQueryOnClick()
{
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.History.AdvancedQuery.List" + 
			"&MrTypeDR=" + getElementValue("MrType") + 
			"&NameSpell=" + getElementValue("txtSpell") + 
			"&Name=" + getElementValue("txtName") + "A" + 
			"&Sex=" + getElementValue("cboSex") + "A" + 
			"&Company=" + getElementValue("txtCompany") + "A" + 
			"&Address=" + getElementValue("txtAddress") + "A" + 
			"&Identity=" + getElementValue("txtIdentityCode") +
			"&Birthday=" + getElementValue("txtBirthday") +
			"&AgeFrom=" + getElementValue("txtAgeFrom") +
			"&AgeTo=" + getElementValue("txtAgeTo");
	//window.alert(lnk);
	parent.frames[1].location.href=lnk;
}

function InitEvent()
{
	document.getElementById("cmdQuery").onclick = cmdQueryOnClick;
	document.getElementById("cmdSelect").onclick = cmdSelectOnClick;
	document.getElementById("cmdClose").onclick = cmdCloseOnClick;
	document.getElementById("txtName").onchange = txtNameOnChange;
}

function txtNameOnChange()
{
	setElementValue("txtSpell", GetPinYin(getElementValue("txtName")));
}

function cmdSelectOnClick()
{
    var objMain = GetDHCWMRMainByID("MethodGetDHCWMRMainByID",  parent.frames[1].document.getElementById("txtRowID").value);
    if (!objMain){
	    //alert("This isn't the Patient!");
	}else{
    var objPatient = GetPatientInfoByMrRowID("MethodGetPatientInfoByMrRowID", objMain.RowID);
    
   		setElementValue("txtMMrNo", objMain.MRNO, parent.opener.document);
   		setElementValue("txtNo", objMain.MRNO, parent.opener.document);
		setElementValue("txtMName", objPatient.PatientName, parent.opener.document);
		setElementValue("txtMSex", objPatient.Sex, parent.opener.document);
		setElementValue("txtMCompany", objPatient.Company, parent.opener.document);
		setElementValue("txtMBirthday", objPatient.Birthday + "(" + objPatient.Age + ")", parent.opener.document);
		setElementValue("txtMAddress", objPatient.HomeAddress, parent.opener.document);
		setElementValue("txtMRInfo", objMain.RowID, parent.opener.document);
		
		
		 
	//parent.opener.document.getElementById("txtNo").value = parent.frames[1].document.getElementById("txtNo").value;
	//parent.opener.document.getElementById("txtMrInfo").value = parent.frames[1].document.getElementById("txtRowID").value;
	//parent.opener.document.getElementById("txtMrDisplay").innerText = parent.frames[1].document.getElementById("txtDisplay").value;
	}
	parent.close();
}

function cmdCloseOnClick()
{
	parent.close();
}

function InitForm()
{
	var mrType = GetParam(parent, "MrType");
	if (mrType==""){
			mrType = GetParam(window, "MrType");
	}
	var strPatientName = GetParam(parent, "PatientName");
	setElementValue("MrType", mrType);
	
	if((strPatientName != "") && (strPatientName != null))
	{
		setElementValue("txtName", StringDecode(strPatientName));
		setElementValue("txtSpell", GetPinYin(StringDecode(strPatientName)));
		cmdQueryOnClick();
	}
	MakeComboBox("cboSex");
	AddListItem("cboSex", tmpChinese[0], "");
	AddListItem("cboSex", tmpChinese[1], tmpChinese[1]);
	AddListItem("cboSex", tmpChinese[2], tmpChinese[2]);
	if(parent.opener == null)
	{
		SetControlVisitable("cmdSelect", false);
		SetControlVisitable("cmdClose", false);
	}
}



InitForm();
InitEvent();