var objMain = GetDHCWMRMainByID("MethodGetDHCWMRMainByID", GetParam(window, "MainID"));
var objPatient = GetPatientByID("MethodGetPatientByID", objMain.Papmi_Dr);
var objDicMrType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objMain.MrType);
var strDateFrom = GetParam(window, "AimDateFrom");
var strDateTo = GetParam(window, "AimDateTo");
var strIsActive = GetParam(window, "IsActive");
var objDicRequest = new ActiveXObject("Scripting.Dictionary");

function DisplayInfo()
{
	setElementValue("txtName", objPatient.PatientName);	
	setElementValue("txtMrType", objDicMrType.Description);	
	setElementValue("txtRegno", objPatient.PatientNo);	
	setElementValue("txtSex", objPatient.Sex);	
	setElementValue("txtMrNo", objMain.MRNO);	
	setElementValue("txtBirthday", objPatient.Birthday);
	var objArry = GetReqList("MethodGetReqList", objMain.RowID, strDateFrom, strDateTo, strIsActive);
	var objRequest = null;
	var objAdmArry = null;
	var objAdm = null;
	var txt = "";
	var cboRequest = document.getElementById("lstRequest");
	for(var i = 0; i < objArry.length; i ++)
	{
		objRequest = objArry[i];
		
		txt = objRequest.AimCtLocObj.UserName + "(" +objRequest.RequestTypeObj.UserName + "  "+ objRequest.WorkItemObj.UserName+")";
		AddListItem("lstRequest", txt, objRequest.RowID)
		objDicRequest.Add(objRequest.RowID, objRequest);
	}
	if(cboRequest.options.length > 0)
		cboRequest.selectedIndex = 0;
	
}

function cmdOK_OnClick()
{
	var strSelected = getElementValue("lstRequest");
	if(strSelected == "")
	{
		return;	
	}
	window.returnValue = objDicRequest.Item(strSelected);
	window.close();
}

function cmdCancel_OnClick()
{
	window.close();
}

function InitForm()
{
	DisplayInfo();
}

function InitEvents()
{
	document.getElementById("btnOK").onclick = cmdOK_OnClick;
	document.getElementById("btnCancel").onclick = cmdCancel_OnClick;
}

InitForm();
InitEvents();