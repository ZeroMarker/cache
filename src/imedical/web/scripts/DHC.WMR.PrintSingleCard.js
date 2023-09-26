/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.PrintSingleCard

AUTHOR: LiYang , Microsoft
DATE  : 2007-6-19

COMMENT: Print single card
========================================================================= */
var objCurrentPatient = null; //current patient
var objCurrentMR = null;//current Medical record
var objCurrentMrType = null; //current medical record type


function DisplayPatient(MainID)
{
	objCurrentPatient = GetPatientInfoByMrRowID("MethodGetPatientInfoByMrRowID", MainID );
	objCurrentMR = GetDHCWMRMainByID("MethodGetDHCWMRMainByID", MainID);
	if((objCurrentPatient == null) || (objCurrentMR == null))
	{
		window.alert("Patient Not Found!!!!!!!!!!");
		return;
	}
	objCurrentMrType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objCurrentMR.MrType);
	
	setElementValue("txtMrNo", objCurrentMR.MRNO);
	setElementValue("txtName", objCurrentPatient.PatientName);
	setElementValue("txtSex", objCurrentPatient.Sex);
	setElementValue("txtAge", objCurrentPatient.Age);
	setElementValue("txtCompany", objCurrentPatient.Company);
	setElementValue("txtAddress", objCurrentPatient.HomeAddress);
	setElementValue("txtMrType", objCurrentMrType.Description);
}

function cmdPrintOnClick()
{
//	var objPrinter = document.getElementById("clsPrinter");
	var objArry = GetDHCWMRMainVolumeArryByMainID(
		"MethodGetDHCWMRMainVolumeArryByMainID", objCurrentMR.RowID);
	var objVolume = objArry[0];
	var objAdm = null;
//	if(objPrinter == null)
	    objPrinter = new ActiveXObject("DHCMedWebPackage.clsPrinter");
	if(objVolume != null)
	{
		if(objVolume.Paadm_Dr != "")
		{
			objAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", objVolume.Paadm_Dr);
			objCurrentPatient.Volume = ConvertAdm(objAdm);
		}
		else
		{
			objAdm = GetDHCWMRHistoryAdm("MethodGetDHCWMRHistoryAdm", objVolume.HistroyAdm_Dr);
			objCurrentPatient.Volume = ConvertHisAdm(objAdm);
		}
	}
	PrintCard(objPrinter, objCurrentPatient, objCurrentMR);
	
}

function cmdCloseOnClick()
{
	window.close();
}

function initForm()
{
		var strMainID = Trim(GetParam(window, "MainID"));
//		var strPrinter = GetVBPrinterObjectString("MethodGetVBPrinterObjectString" );
		if(strMainID == "")//if DHCWMRMain RowID is blank then return
		{   
		    window.close();
			return;
		}
//		document.write(strPrinter);
		DisplayPatient(strMainID);
		
		
		document.getElementById("txtMrNo").readOnly = true;
		document.getElementById("txtName").readOnly = true;
		document.getElementById("txtSex").readOnly = true;
		document.getElementById("txtAge").readOnly = true;
		document.getElementById("txtCompany").readOnly = true;
		document.getElementById("txtAddress").readOnly = true;
		document.getElementById("txtMrType").readOnly = true;
}

function initEvent()
{
	document.getElementById("cmdPrint").onclick = cmdPrintOnClick;
	document.getElementById("cmdClose").onclick = cmdCloseOnClick;
}

initForm();
initEvent();