/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.HistoryInfo.Display

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
tmpChinese=GetChinese("MethodGetChinese","HistoryInfoDisplay");
//alert(tmpChinese[0]+"||"+tmpChinese[1]+"||"+tmpChinese[2]+"||"+tmpChinese[3]);

function DisplayHistoryInfo(obj, objMr, objPatient)
{
	if(objPatient != null)
	{
		setElementValue("txtRegNo", objPatient.PatientNo);
	}
	setElementValue("txtMrNo", objMr.MRNO);
	setElementValue("txtName", obj.PatientName);
	setElementValue("txtSex", obj.Sex);
	setElementValue("txtAge", obj.Age);
	setElementValue("txtWedlock", obj.Wedlock);
	setElementValue("txtOccupation", obj.Occupation);
	setElementValue("txtNativePlace", obj.City);
	setElementValue("txtCounty", obj.County);
	setElementValue("txtNation", obj.Nation);
	setElementValue("txtNationality", obj.Nationality);
	setElementValue("txtPersonalID", obj.IdentityCode);
	setElementValue("txtCompany", obj.Company);
	setElementValue("txtCompanyTel", obj.CompanyTel);
	setElementValue("txtCompanyZip", obj.CompanyZip);
	setElementValue("txtHomeAddress", obj.HomeAddress);
	setElementValue("txtHomeTel", obj.HomeTel);
	setElementValue("txtHomeZip", obj.HomeZip);
	setElementValue("txtRelative", obj.RelativeName);
	setElementValue("txtRelation", obj.RelationDesc);
	setElementValue("txtRelativeAddress", obj.RelativeAddress);
	setElementValue("txtRelativeTel", obj.RelativeTel);
	setElementValue("txtBirthday", obj.Birthday);
	var strTmp = "";
	var objNote = document.getElementById("lblNote");
	
	strTmp += (objMr.IsDead ? tmpChinese[0] : "");
	var objArryVol = GetDHCWMRMainVolumeArryByMainID("MethodGetDHCWMRMainVolumeArryByMainID", objMr.RowID);
	var objVolume = null;
	for(var i = 0; i < objArryVol.length; i ++)
	{
	    objVolume = objArryVol[i];
	   if(objVolume.IsReprography) 
	   {
	        strTmp += tmpChinese[1];
	   }
	   if(objVolume.IsSeal)
	   {
	        strTmp += tmpChinese[2];
	   }
	}
	objNote.innerText = strTmp;
	objNote.style.color = "red";
    var objTable = document.getElementById("tDHC_WMR_History_Display");
	for(var i = 1; i < objTable.rows.length; i ++)
	{
	    if(getElementValue("IsReprographyz" + i) == "Y")
	        setElementValue("Reprographyz" + i, true);
	   if(getElementValue("IsSealz" + i) == "Y") 
	        setElementValue("Sealz" + i, true);
	}
	
}


function cmdCloseOnClick()
{
	window.close();
}

function cmdPrintOnClick()
{
	//window.alert(t['AAA']);
	window.open("websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.PrintSingleCard&MainID=" + getElementValue("MrMainID") );
}


function ProcessRequest()
{
	var strID = getElementValue("ID");
	var strMrID = getElementValue("MrMainID");
	var objHistory = GetPatientInfoByMrRowID("MethodGetBaseInfoByMain", strMrID);
	var objMrMain = GetDHCWMRMainByID("MethodGetMainByID", strMrID);
	var objPatient = null;
	if((objHistory == null) || (objMrMain == null))
	{
		window.alert(tmpChinese[3]);
		//window.close();
	}
	else
	{
		if(objMrMain.Papmi_Dr != "")
		{
			objPatient = GetPatientByID("MethodGetPatientByID", objMrMain.Papmi_Dr);		
		}
		DisplayHistoryInfo(objHistory, objMrMain, objPatient);
	}
	
	
}


function InitForm()
{
	ProcessRequest();
	var obj = null;
	for(var i = 0; i < document.all.length; i ++)
	{
		obj = document.body.all.item(i);
		if(obj == null)
		{
			continue;
		}
		if(obj.nodeName == "INPUT")
		{
			if(obj.type == "text")
			{
				obj.readOnly = true;
			}
		}
	}
	document.getElementById("txtMrNo").style.fontSize = '20pt';
}

function InitEvent()
{
	document.getElementById("cmdClose").onclick = cmdCloseOnClick;
	//document.getElementById("cmdPrint").onclick = cmdPrintOnClick;
}

InitForm();
InitEvent();