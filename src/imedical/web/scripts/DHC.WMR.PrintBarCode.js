/* ======================================================================
JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1
NAME: DHC.WMR.PrintBarCode.JS
AUTHOR: LiYang , Microsoft
DATE  : 2007-4-26
COMMENT: DHC.WMR.PrintBarCode.JS event handler
========================================================================= */
var objMrType = null;
var objMain = null;
var objBaseInfo = null;
var objVolumeDic = new ActiveXObject("Scripting.Dictionary");
var objHosptial=null;

var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodChinese","PrintBarCode");
objHosptial = GetcurrHospital("MethodGetDefaultHosp");

function DisplayMrVolume()
{
	var objVol = null;
	var objAdm = null;
	//**************************************
	//add by zf 20090514
	ClearListBox("lstVolumeList");
	objVolumeDic.RemoveAll();
	var objArry = null;
	//**************************************

	var objArry = GetDHCWMRMainVolumeArryByMainID("MethodGetVolumeArry", objMain.RowID);
	for(var i = 0; i < objArry.length; i ++)
	{
		objVol = objArry[i];	
		if(objVol.Paadm_Dr != "")
		{
			objAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", objVol.Paadm_Dr);
			AddListItem("lstVolumeList", 
				Trim(objMain.MRNO) + "     " + 
				Trim(objBaseInfo.PatientName) + "     " + 
				objAdm.AdmDate + "     " +
				GetDesc(objAdm.LocDesc, "/") + "     " +
				objAdm.DischgDate
				, objVol.RowID);					
		}
		else
		{
			objAdm = GetDHCWMRHistoryAdmByID("MethodGetHistoryPatientAdmitInfo", objVol.HistroyAdm_Dr);
			AddListItem("lstVolumeList", 
				Trim(objMain.MRNO) + "     " + 
				Trim(objBaseInfo.PatientName) + "     " + 
				objAdm.AdmitDate + "     " +
				objAdm.AdmitDep + "     " +
				objAdm.DischargeDate
				, objVol.RowID);						
		}

		objVolumeDic.Add(objVol.RowID, objVol);
	}
	document.getElementById("lstVolumeList").focus();
	document.getElementById("lstVolumeList").selectedIndex = 0;
}

function lstVolumeListOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	var objPrinter = document.getElementById("clsWMRBarCode");
	var strValue = getElementValue("lstVolumeList");
	var objVolume = objVolumeDic.Item(strValue);
	if(objPrinter == null) objPrinter = new ActiveXObject("DHCMedWebPackage.clsWMRBarCode");
	/*Modify by wuqk 2008-04-28 for PrintBarcode*/
	var BarCode = "02" + formatString(objVolume.RowID,11);
	var VolumeNumber = "";
	switch(objHosptial.MyHospitalCode)  //Modified By LiYang 2009-7-24 FuXing Hospital need printing volume number on the barcode label .
	{
		//Fu Xing Hospital need to print volume number
		case "BeiJing_FX":
			if (objVolume.Paadm_Dr != "")
			{
				VolumeNumber = " " + objVolume.ResumeText;
			}
			//Notice:String.fromCharCode(21367) is Chinese Character "Volume"
			//360 is backfeed, you can modify this
			ElseString = String.fromCharCode(21367) + VolumeNumber + CHR_1 + objMain.MRNO + CHR_1 + objBaseInfo.PatientName + CHR_1 + 360 + CHR_1 + objBaseInfo.Sex + CHR_1 + objBaseInfo.Age + CHR_1 + objBaseInfo.Birthday;
			break;
		default:
			ElseString = objMrType.Description + t["(Volume)"] + CHR_1 + objMain.MRNO + CHR_1 + objBaseInfo.PatientName + CHR_1 + 360 + CHR_1 + objBaseInfo.Sex + CHR_1 + objBaseInfo.Age + CHR_1 + objBaseInfo.Birthday;
			break;
	}
	objPrinter.PrintWMRBarCode(objHosptial.MyHospitalCode, objHosptial.BarcodePrinter, BarCode, ElseString);
	/*end*/
	ClearListBox("lstVolumeList");
	objVolumeDic.RemoveAll();
	document.getElementById("txtMrNo").focus();
}

function txtMrNoOnKeyDown()
{
	if(window.event.keyCode != 13)
		return;
	if(Trim(getElementValue("txtMrNo")) == "")
	    return;
	/////////////add by liuxuefeng 2009-08-19///////////
	FormatInputMrNo("MrType","txtMrNo");
	///////////////////// End ////////////////////////
	var objPrinter = document.getElementById("clsWMRBarCode");
    	if(objPrinter == null) objPrinter = new ActiveXObject("DHCMedWebPackage.clsWMRBarCode");
	objMain = GetDHCWMRMainByMrNo(
		"MethodGetMrMainByNo", 
		GetParam(window, "MrType"),
		getElementValue("txtMrNo"),
		"Y");
	if(objMain == null)
	{
		window.alert(t["MrNotFound"]);//not find mr
		return;
	}
	objBaseInfo = GetPatientInfoByMrRowID("MethodGetInfoByMainID", objMain.RowID);
	if(objBaseInfo == null)
	{
	    	objBaseInfo = DHCWMRHistory();
		//window.alert(t["MrNotFound"]);//
		//return;
	}
	switch(getElementValue("cboBarCodeType"))
	{
		case "1":
			/*Modify by wuqk 2008-04-28 for PrintBarcode*/
		     	var BarCode = "01" + formatString(objMain.RowID,11);
			switch(objHosptial.MyHospitalCode)  //Modified By LiYang 2009-7-24 FuXing Hospital do not need print mr tpye description  on  barcode label
			{
				//Fu Xing Hospital need to print volume number
				case "BeiJing_FX":
					//Notice:String.fromCharCode(21367) is Chinese Character "Volume"
					//360 is backfeed, you can modify this
					var ElseString = "" + CHR_1 + objMain.MRNO + CHR_1 + objBaseInfo.PatientName + CHR_1 + 360 + CHR_1 + objBaseInfo.Sex + CHR_1 + objBaseInfo.Age + CHR_1 + objBaseInfo.Birthday;
					break;
				default:
					var ElseString = objMrType.Description + CHR_1 + objMain.MRNO + CHR_1 + objBaseInfo.PatientName; + CHR_1 + 360 + CHR_1 + objBaseInfo.Sex + CHR_1 + objBaseInfo.Age + CHR_1 + objBaseInfo.Birthday;
					break;
			}
			objPrinter.PrintWMRBarCode(objHosptial.MyHospitalCode, objHosptial.BarcodePrinter, BarCode, ElseString);
			/*end*/
			break;
		case "2":
			DisplayMrVolume();
			break;
	}
	setElementValue("txtMrNo", "");
}

function initForm()
{	
	var param = GetParam(window, "MrType");
	if(param == "")
	{
		window.alert(t["MrTypeError"]);
		return;
	}
	var objDic = GetDHCWMRDictionaryByID("MethodGetDictionaryByID", param);
	objMrType = objDic;
	setElementValue("txtMrType", objDic.Description);


	MakeComboBox("cboBarCodeType");
	AddListItem("cboBarCodeType", tmpChinese[0], "1");
	AddListItem("cboBarCodeType", tmpChinese[1], "2");
	setElementValue("cboBarCodeType", "1");
	//window.alert(cspRunServerMethod("MethodGetBarCode"));
//	document.write(cspRunServerMethod(getElementValue("MethodGetBarCode")));
	document.getElementById("txtMrNo").focus();
	document.getElementById("txtMrType").readOnly = true;
}

function initEvent()
{
	document.getElementById("txtMrNo").onkeydown = txtMrNoOnKeyDown;
	document.getElementById("lstVolumeList").onkeydown = lstVolumeListOnKeyDown;
}

initForm();
initEvent();