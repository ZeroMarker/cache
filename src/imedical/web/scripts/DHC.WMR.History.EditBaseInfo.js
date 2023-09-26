/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.History.EditBaseInfo

AUTHOR: LiYang , Microsoft
DATE  : 2007-5-15
========================================================================= */

var strCurrentVolumeID = "";
var objCurrentInfo = null;

//objInfo DHCWMRHistory
function DisplayInfo(objInfo)
{
	setElementValue("txtName", objInfo.PatientName);
	setElementValue("txtSex", objInfo.Sex);
	setElementValue("txtBirthday", objInfo.Birthday);
	setElementValue("txtAge", objInfo.Age);
	setElementValue("txtWedlock", objInfo.Wedlock);
	setElementValue("txtOccupation", objInfo.Occupation);
	setElementValue("txtNativePlace", objInfo.City);
	setElementValue("txtCounty", objInfo.County);
	setElementValue("txtNation", objInfo.Nation);
	setElementValue("txtNationality", objInfo.Nationality);
	setElementValue("txtPersonalID", objInfo.IdentityCode);
	setElementValue("txtCompany", objInfo.Company);
	setElementValue("txtCompanyPhone", objInfo.CompanyTel);
	setElementValue("txtCompanyZip", objInfo.CompanyZip);
	setElementValue("txtHomeAddress", objInfo.HomeAddress);
	setElementValue("txtHomePhone", objInfo.HomeTel);
	setElementValue("txtHomeZip", objInfo.HomeZip);
	setElementValue("txtRelativeName", objInfo.RelativeName);
	setElementValue("txtReplation", objInfo.RelationDesc);
	setElementValue("txtRelativeAddress", objInfo.RelativeAddress);
	setElementValue("txtRelativePhone", objInfo.RelativeTel);
	setElementValue("txtPinyin", objInfo.NameSpell);
}

function SaveToObject()
{
	objCurrentInfo.PatientName = getElementValue("txtName");
	objCurrentInfo.Sex = getElementValue("txtSex");
	objCurrentInfo.Birthday = getElementValue("txtBirthday");
	objCurrentInfo.Age = getElementValue("txtAge");
	objCurrentInfo.Wedlock = getElementValue("txtWedlock");
	objCurrentInfo.Occupation = getElementValue("txtOccupation");
	objCurrentInfo.City = getElementValue("txtNativePlace");
	objCurrentInfo.County = getElementValue("txtCounty");
	objCurrentInfo.Nation = getElementValue("txtNation");
	objCurrentInfo.Nationality = getElementValue("txtNationality");
	objCurrentInfo.IdentityCode = getElementValue("txtPersonalID");
	objCurrentInfo.Company = getElementValue("txtCompany");
	objCurrentInfo.CompanyTel = getElementValue("txtCompanyPhone");
	objCurrentInfo.CompanyZip = getElementValue("txtCompanyZip");
	objCurrentInfo.HomeAddress = getElementValue("txtHomeAddress");
	objCurrentInfo.HomeTel = getElementValue("txtHomePhone");
	objCurrentInfo.HomeZip = getElementValue("txtHomeZip");
	objCurrentInfo.RelativeName = getElementValue("txtRelativeName");
	objCurrentInfo.RelationDesc = getElementValue("txtReplation");
	objCurrentInfo.RelativeAddress = getElementValue("txtRelativeAddress");
	objCurrentInfo.RelativeTel = getElementValue("txtRelativePhone");
	objCurrentInfo.NameSpell = getElementValue("txtPinyin");
}

function cmdSaveOnClick()
{
	if(objCurrentInfo == null)
		return;
		
	SaveToObject();
	if(SaveDHCWMRVolInfo("MethodSaveDHCWMRVolInfo", objCurrentInfo))
	{
		window.alert(t["SaveOK"]);
		window.close();
	}
	else
	{
		window.alert(t["SaveFail"]);
	}
	
}

function cmdCancelOnClick()
{
	window.close();
}

function txtNameOnChange()
{
	//var obj = document.getElementById("clsPinYin");
	//if(obj == null)
	//    obj = new ActiveXObject("DHCMedWebPackage.clsPinYin");
	setElementValue("txtPinyin", GetPinYin(getElementValue("txtName")));
}

function ProcessRequest()
{
	strCurrentVolumeID = GetParam(window, "VolID");
	if(strCurrentVolumeID == "")
		return;
	objCurrentInfo = GetDHCWMRVolInfoByVolumeID("MethodGetDHCWMRVolInfoByVolumeID", strCurrentVolumeID);
	if(objCurrentInfo != null)
	{
		DisplayInfo(objCurrentInfo);
	}
}

function initForm()
{
	//var strObject = GetPinyinObjectString("MethodPinYin");
	//document.write(strObject);
	
	AddToControlList(document.getElementById("txtPinyin"));	
	AddToControlList(document.getElementById("txtName"));
	AddToControlList(document.getElementById("txtSex"));
	AddToControlList(document.getElementById("txtBirthday"));
	AddToControlList(document.getElementById("txtAge"));
	AddToControlList(document.getElementById("txtWedlock"));
	AddToControlList(document.getElementById("txtOccupation"));
	AddToControlList(document.getElementById("txtNativePlace"));
	AddToControlList(document.getElementById("txtCounty"));
	AddToControlList(document.getElementById("txtNation"));
	AddToControlList(document.getElementById("txtNationality"));
	AddToControlList(document.getElementById("txtPersonalID"));
	AddToControlList(document.getElementById("txtCompany"));
	AddToControlList(document.getElementById("txtCompanyPhone"));
	AddToControlList(document.getElementById("txtCompanyZip"));
	AddToControlList(document.getElementById("txtHomeAddress"));
	AddToControlList(document.getElementById("txtHomePhone"));
	AddToControlList(document.getElementById("txtHomeZip"));
	AddToControlList(document.getElementById("txtRelativeName"));
	AddToControlList(document.getElementById("txtReplation"));
	AddToControlList(document.getElementById("txtRelativeAddress"));
	AddToControlList(document.getElementById("txtRelativePhone"));
	AddToControlList(document.getElementById("cmdSave"));

	
	
	ProcessRequest();
}

function initEvent()
{
	document.getElementById("cmdSave").onclick = cmdSaveOnClick;
	document.getElementById("cmdCancel").onclick = cmdCancelOnClick;
	document.getElementById("txtName").onchange = txtNameOnChange;
}

initForm();
initEvent();
