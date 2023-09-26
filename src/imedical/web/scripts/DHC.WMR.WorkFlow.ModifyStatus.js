/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.WorkFlow.ModifyStatus.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-5-11
============================================================================ */
var objWorkFlowDic = new ActiveXObject("Scripting.Dictionary"); //Save work flow dictionary
var objCurrentFlow = null; //save current workflow
var objArryExtra = null;

var strParref = "";
var strChildSub = "";
var objCurrentMr = null;//current medical record
var strType = "";//medical record type


var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodGetChinese","WorkFlowModifyStatus");
//alert(tmpChinese[0]+"||"+tmpChinese[1]+"||"+tmpChinese[2]+"||"+tmpChinese[3]);

//init workflow type
function InitWorkFlow(MrType)
{
	var objWorkTypeDic = GetDHCWMRDictionaryArryByTypeFlag("MethodGetWorkType", "WorkType", "Y");//  Order or Sudden
	var objFlow = GetDHCWMRWorkFlowByTypeFlag("MethodGetWorkFlow", MrType, "Y");
	var objItm = null; //workflow item
	var objDetail = null;//workflow item detail info
	var objDic = null;
	var strEmergencyRowID = ""; //emergency item rowid
	var arryEm = null;
	
	if(objFlow == null)
	{
		window.alert(t["WorkFlowError"]);
		return;
	}
	var arryItems = GetDHCWMRWokrFlowSubList("MethodGetWorkFlowArry", objFlow.RowID);
	if(strType == "02")//volume
	{
		for(var i = 0; i < arryItems.length; i ++)
		{
			objItm = arryItems[i];
			objDetail = GetDHCWMRWorkItemByID("MethodGetDHCWMRWorkItemByID", objItm.Item_Dr);
			objDetail.IsEmergency = false;//indicate it is sequence work flow
			objWorkFlowDic.Add(objDetail.RowID,  objDetail);		
			AddListItem("cboNewStatus", objDetail.Description, objDetail.RowID);
		}
	}	
	for(var i = 0; i < objWorkTypeDic.length; i ++)
	{
		objDic = objWorkTypeDic[i];
		if(objDic.Description.indexOf(tmpChinese[0]) > -1)
		{
			strEmergencyRowID = objDic.RowID;
			arryEm = GetDHCWMRWorkItemByTypeFlag("MethodGetEmergeWorkItem", strEmergencyRowID, "Y");
			for(var j = 0; j < arryEm.length; j ++)
			{
				objDetail = arryEm[j];
				AddListItem("cboNewStatus", objDetail.Description + tmpChinese[1], objDetail.RowID);
				objDetail.IsEmergency = true;//indicate it is emergency work flow
				objWorkFlowDic.Add(objDetail.RowID,  objDetail);				
			}
		}
	}
	var objList = document.getElementById("cboNewStatus");
	if(objList.options.length > 0)
		objList.selectedIndex = 0;
	cboNewStatusSelected();
}

function SaveStatusToObject(flag)
{
	var obj = null;
	var objMr = objCurrentMr;	
	var objItm = null;
	if(flag == "1")
	{
		obj = DHCWMRMainStatus();
		obj.Parref = objMr.RowID;
	}
	else
	{
		obj = DHCWMRVolStatus();
		obj.Parref = objMr.Volume.RowID;
	}
	obj.Status_Dr = objCurrentFlow.RowID;
	obj.UserFromDr = session['LOGON.USERID'];
	return obj;
}

//Save information
function SaveInfo()
{
	var obj = objCurrentMr;
	var objStatus = null;
	var objStatusDetailList = null;
	var returnValue = false;
	var objUser = null;

	if(objArryExtra.length > 0)
	{
		objStatusDetailList = SaveStatusDetailToObject(2);
		if(objStatusDetailList.length == 0)
		{
			window.alert(t["ExtraInfoCanceled"]);
			return false;
		}
	}
	else
	{
		objStatusDetailList = new Array();
	}		
	if(objCurrentFlow.CheckUser)//check whether need sign
	{
		objUser = ValidateUser(t["ValidateUser"]);
		if(objUser == null)//user canceled the sign process
		{
			window.alert(t["ValidateUserCanceled"]);
			return false;
		}
	}
	else
	{
		objUser = DHCWMRUser(); 
	}

	switch(strType)
	{
		case "01":
			objStatus = SaveStatusToObject("1");
			objStatus.UserToDr = objUser.RowID;			
			returnValue = SaveWorkDetail("MethodSaveWorkDetail", 
				"0", 
				objCurrentFlow.RowID, 
				objCurrentMr.RowID, 
				"",
				SerializeDHCWMRVolStatus(objStatus),
				SerializeDHCWMRMainStatusDtlArry(objStatusDetailList));
			break;
		case "02":
			objStatus = SaveStatusToObject("2");
			objStatus.UserToDr = objUser.RowID;
			returnValue = SaveWorkDetail("MethodSaveWorkDetail", 
				"1", 
				objCurrentFlow.RowID, 
				"",
				objCurrentMr.Volume.RowID,
				SerializeDHCWMRVolStatus(objStatus),
				SerializeDHCWMRMainStatusDtlArry(objStatusDetailList));
				break;
		default:
			throw new Error(9999, "function not implemented")
	}
	return returnValue;
}


//Save additional information table
//1-mainStatus 2-volStatus
function SaveStatusDetailToObject(flag)
{
	var strUrl = "dhc.wmr.workflow.extra.csp?";
	var objReturn = null;
	var arg = "MainStatusRowid=" +
			"&VolStatusRowid=" + 
			"&WorkItemRowid=" + objCurrentFlow.RowID +
			"&IsEdit=" + "Y" +
			"&StatusFrom=" + 
			"&StatusTo=" + 
			"&ValidateUser=" + "N" + 
			"&MainRowid=" + 
			"&VolRowid=" + 
			"&flag=" + flag;
	
	objReturn = window.showModalDialog(strUrl + arg,"dialogWidth=300,dialogHeight=500");
	if(objReturn == null)
		objReturn = new Array();
	return objReturn;
}


function cboNewStatusSelected()
{
	if(window.event != null)
	{
		if(window.event.propertyName != "value")
			return;
	}
	var objWork = null;
	var objList = document.getElementById("cboNewStatus");
	if(objList.options.length == 0)
	{
		window.alert("You have no power to use this function!"); //
		return;
	}
	objCurrentFlow = objWorkFlowDic.Item(getElementValue("cboNewStatus"));//modify current status
	objArryExtra = GetDHCWMRWorkItemListArry("MethodGetWorkItemExtra", objCurrentFlow.RowID, "Y");
}



function DisplayMrInfo(RowID, Type)
{
	var objDicStatus = null;
	var objMain = null;
	var objVol = null;
	var objInfo = null;
	var objDicMrType = null;
	strType = Type;
	switch(Type)
	{
		case "01"://entire medical record
			objMain = GetDHCWMRMainByID("MethodGetDHCWMRMainByID", RowID);
			if(objMain == null)
			{
				window.alert(t["MrNotFound"]);
				return;
			}
			objDicStatus = DHCWMRDictionary();
			if(objMain.IsStayIn)
				objDicStatus.Description = tmpChinese[2];
			else
				objDicStatus.Description = tmpChinese[3];
			break;
		case "02"://volume
			objVol = GetDHCWMRMainVolumeByID("MethodGetDHCWMRMainVolumeByID", RowID);	
			objMain = GetDHCWMRMainByID("MethodGetDHCWMRMainByID", objVol.Main_Dr);
			if((objMain == null) || (objVol == null))
			{
				window.alert(t["MrNotFound"]);
				return;
			}
			objMain.Volume = objVol;
			objDicStatus = GetDHCWMRWorkItemByID("MethodGetDHCWMRWorkItemByID", objVol.Status_Dr);
			
			break;
	}
	objDicMrType = GetDHCWMRDictionaryByID("MethodGetDHCWMRDictionaryByID", objMain.MrType);
	objInfo = GetPatientInfoByMrRowID("MethodGetPatientInfoByMrRowID", objMain.RowID);
	objCurrentMr = objMain;
	InitWorkFlow(objMain.MrType);
	setElementValue("txtMrType", objDicMrType.Description);
	setElementValue("txtMrInfo", objMain.MRNO + "   " + objInfo.PatientName);
	setElementValue("txtCurrentSatus", objDicStatus.Description);

}

function cmdSaveOnClick()
{	
	if(SaveInfo())
	{
		window.alert(t["SaveOK"]);
	}
	else
	{
		window.alert(t["SaveFail"]);
	}
	window.close();
}

function cmdCancelOnClick()
{
	window.close();
}



function initForm()
{
	MakeComboBox("cboNewStatus");
	DisplayMrInfo(GetParam(window, "RowID"), GetParam(window, "Type"));
	
}

function initEvent()
{
	document.getElementById("cboNewStatus").onpropertychange = cboNewStatusSelected;
	document.getElementById("cmdOK").onclick = cmdSaveOnClick;
	document.getElementById("cmdCancel").onclick = cmdCancelOnClick;
}

initForm();
initEvent();