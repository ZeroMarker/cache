//DHC.WMR.DataAccess.JS
//By Liyang 2007-3-27

var ApplicationName = "DHCWMR";//the name of applications use to get Competence Group
var BarCodeFontName = "ZB:Code 128";
/*===========================================
Name:GetDHCWMRDictionaryByID
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:Method name control ID
RowID:Dictionary RowID
Comment: Display dictionary in combox
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRDictionaryCtl.GetDataById"))
============================================*/
function GetDHCWMRDictionaryByID(methodControl, rowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, rowID);
	var objDic = null;
	if(ret != "undefined")
	{
		objDic = BuildDHCWMRDictionary(ret);
	}
	return objDic;
}

/*===========================================
Name:GetDHCWMRWorkItemByID
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:Method name control ID
RowID:workitem RowID
Comment: Get workitem by rowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRWorkItemCtl.GetDataById"))
============================================*/
function GetDHCWMRWorkItemByID(methodControl, rowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, rowID);
	var objItm = null;
	if(ret != "undefined")
	{
		objItm = BuildDHCWMRWorkItem(ret);
	}
	return objItm;
}

/*===========================================
Name:GetDHCWMRWorkItemRuleByID
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:
RowID:WorkItemRule RowID
Comment: Get WorkItemRule By Rowid
============================================*/
function GetDHCWMRWorkItemRuleByID(methodControl, rowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, rowID);
	var objItm = null;
	if(ret != "undefined")
	{
		objItm = BuildDHCWMRWorkItemRule(ret);
	}
	return objItm;
}

/*===========================================
Name:GetDHCWMRWorkDetailByID
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:
RowID:WorkDetail RowID
Comment: Get WorkDetail By Rowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRWorkDetailCtl.GetDataById"))
============================================*/
function GetDHCWMRWorkDetailByID(methodControl, rowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, rowID);
	var objItm = null;
	if(ret != "undefined")
	{
		objItm = BuildDHCWMRWorkDetail(ret);
	}
	return objItm;
}

/*===========================================
Name:GetDHCWMRWorkItemListArry
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:
Parref:WorkItem Rowid
Flag??/N
Comment: Get WorkItemList of one WorkItem
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRWorkItemCtl.SLQueryDataByParFlagLIST"))
============================================*/
function GetDHCWMRWorkItemListArry(MethodControl, Parref, Flag)
{
	var strMethod = document.getElementById(MethodControl).value;
	var ret = cspRunServerMethod(strMethod, Parref, Flag);
	var arry = new Array();
	var arryStr = null;
	var obj = null;
	if(ret == "undefined")
	{
		//window.alert("Don't read information!");
	}
	else
	{
		arryStr = ret.split(CHR_1);
		for(var i = 0; i < arryStr.length; i ++)
		{
			obj = BuildDHCWMRWorkItemList(arryStr[i]);
			if(obj != null)
			{
				arry.push(obj);
			}
		}
	}
	return arry;
}
/*===========================================
Name:SaveDHCWMRWorkItemListArry
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:
arry:The collection of WorkItemList
Comment: Save WorkItemList
============================================*/
function SaveDHCWMRWorkItemListArry(MethodControl, arry)
{
	var strMethod = document.getElementById(MethodControl).value;
	var tmp = "";
	var ret = "";
	var returnValue = true;
	for(var i = 0; i < arry.length; i ++)
	{
		tmp = "";
		tmp = SerializeDHCWMRWorkItemList(arry[i]);
		ret = cspRunServerMethod(strMethod, tmp);
		if(ret == "-100")
		{
			returnValue = false;
		}
	}
	return returnValue;
}
/* ======================================================================
NAME: GetPatientByRegNo
AUTHOR: LiYang , Microsoft
DATE  : 2007-3-21
Param:
	MethodControl:
	RegNo:RegNo
Return??
    Patient Base Information
COMMENT: Select Patient Base Information By RegNo
========================================================================= */

//Get Patient Information by RegNo!
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetPatInfo2"))
function GetPatientByNo(methodControl, RegNo)
{
	if(Trim(RegNo) == "")
	{
		return null;
	}
	var obj = Patient();
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RegNo);
	return BuildPatient(ret);
}

//Get Patient Information By Papmi
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetPatInfo"))
function GetPatientByID(methodControl, strID)
{
	if(Trim(strID) == "")
	{
		return null;
	}
	var obj = Patient();
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, strID);
	return BuildPatient(ret);
}


//Get Medical Records Main Information By Rowid
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainCtl.GetMainById"))
function GetDHCWMRMainByID(methodControl, MrMainID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrMainID)
	if((ret == "undefined") || (ret == ""))
	{
		return null;
	}
	return BuildDHCWMRMain(ret);
	
}
//Save medical records main information
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainCtl.UpdateMain"))
function SaveDHCWMRMain(methodControl, obj)
{
	var strMethod = document.getElementById(methodControl).value;
	if(obj == null)
	{
		return "";
	}
	var str = SerializeDHCWMRMain(obj);
	var ret = cspRunServerMethod(strMethod, str);
	if(ret > 0)
	{
		obj.RowID = ret;
	}
	return (ret > 0);
}

//Get history medical records information by rowid
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRHistoryCtl.GetHistoryById"))
function GetDHCWMRHistoryByID(methodControl, ID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, ID);
	if((ret == "undefined") || (ret == ""))
	{
		return null;
	}
	else
	{
		return buildDHCWMRHistory(ret);
	}
}

//Get history paadm information
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRHistoryCtl.GetHistoryAdmById"))
function GetDHCWMRHistoryAdmByID(methodControl, ID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, ID);
	if((ret == "undefined") || (ret == ""))
	{
		return null;
	}
	else
	{
		return BuildDHCWMRHistoryAdm(ret);
	}
}

//Get user information by rowid
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetLogUserInfo"))
function GetDHCWMRUserByID(methodControl, ID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, ID);
	if((ret == "undefined") || (ret == ""))
	{
		return null;
	}
	else
	{
		return BuildDHCWMRUser(ret);
	}
}
//Get patient paadm information list
//PatientID:the papmi of patient
//Type:Out patient/In patient
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRBasePaadm.GetAdmList"))
function GetPatientAdmitList(methodControl, PatientID, Type)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, PatientID, Type);
	var obj = null;
	var arry = null;
	var objArry = new Array();
	if((ret == "undefined") || (ret == ""))
	{
		
	}
	else
	{
		arry = ret.split(CHR_1);
		for(var i = 0; i < arry.length; i ++)
		{
			obj = BuildDHCWMRAdmInfo(arry[i]);
			if(obj != null)
			{
				objArry.push(obj);
			}
		}
	}
	return objArry;
}

//Get patient paamd information
//Paadm:paadm rowid
//return:patient paadm information
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRBasePaadm.GetAdmInfo"))
function GetPatientAdmitInfo(methodControl, Paadm)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Paadm);
	var obj = null;
	if((ret != "undefined") && (ret != ""))
	{		
		obj = BuildDHCWMRAdmInfo(ret);
	}
	return obj;
}

//Get workflow by mrtype
function GetWorkFlowByMrType(methodControl, MrType)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrType);
	if(ret == "undefined")
	{
		return null;
	}
	else
	{
		return BuildDHCWMRWorkFlow(ret);
	}
}

//Save volume main information
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRVolumeCtl.UpdateVol"))
function SaveDHCWMRMainVolume(methodControl, obj)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, SerializeDHCWMRMainVolume(obj));
	if(ret.indexOf("||") > -1)
	{
		obj.Parref = GetCode(ret, "||");
		obj.RowID = ret;
		obj.ChildSub = GetDesc(ret, "||");
		return true;
	}
	else
	{
		return false;
	}
}

//Save volume Paadm
function SaveDHCWMRVolAdm(methodControl, obj)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, SerializeDHCWMRVolAdm(obj));
	if(ret.indexOf("||") > -1)
	{
		obj.ChildSub = GetDesc(ret, "||");
		return true;
	}
	else
	{
		return false;
	}
}

//Save volume base information
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRVolumeCtl.UpdateVolInfo"))
function SaveDHCWMRVolInfo(methodControl, obj)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, SerializeDHCWMRVolInfo(obj));
	if(ret > -1)
	{
		obj.RowID = ret;
		return true;
	}
	else
	{
		return false;
	}
}

//Update volume status information
function SaveDHCWMRVolStatus(methodControl, obj)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, SerializeDHCWMRVolStatus(obj));
	if(ret.indexOf("||") > -1)
	{
		obj.ChildSub = GetDesc(ret, "||");
		return true;
	}
	else
	{
		return false;
	}
}

//Get new MrNo
//mrType medical records type
//loc :location
function GetNewMrNo(methodControl, mrType, loc)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, mrType, loc);
	return ret;
}


//Get the whole workflow by mrtype and isactive
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRWorkFlowCtl.QueryByTypeActiveDateLIST"))
function GetDHCWMRWorkFlowByTypeFlag(methodControl, mrType, flag)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, mrType, flag, "");
	if(ret != "")
	{
		return BuildDHCWMRWorkFlow(ret);
	}
	else
	{
		return null;
	}
}
//Get all items of workflow
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRWorkFlowCtl.SSGetDataByIdLIST")) 
function GetDHCWMRWokrFlowSubList(methodControl, Parref)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Parref);
	var arry = new Array();
	var arryStr = null;
	var obj = null;
	if(ret == "undefined")
	{
		//window.alert("Don't read information!");
	}
	else
	{
		arryStr = ret.split(CHR_1);
		for(var i = 0; i < arryStr.length; i ++)
		{
			obj = BuildDHCWMRFlowSub(arryStr[i]);
			if(obj != null)
			{
				arry.push(obj);
			}
		}
	}
	return arry;
}

//whether have right to do the operation
//GroupID:Group ID
//FunctionName:
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.UserFunction"))
function HasPower(methodControl, GroupID, FunctionName)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, GroupID, ApplicationName, FunctionName);
	return (ret == 0);
}

/*===========================================
Name:GetDHCWMRMainByMrNo
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:
MrType:
MrNo:
Flag??/N isActive
Comment: Select medical records by mrtype and mrno
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainCtl.GetMainByTypeNo"))
============================================*/
function GetDHCWMRMainByMrNo(methodControl, MrType, MrNo, Flag)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrType, MrNo, Flag);
	//window.alert(strMethod);
	if(ret.indexOf("^") == -1)
	{
		return null;
	}
	else
	{
		return BuildDHCWMRMain(ret);
	}
}

/*===========================================
Name:GetMainByTypeRegNo
Author: wuqk
Date: 2012-02-08
Param:
methodControl:
MrType:
MrNo:
Flag??/N isActive
Comment: Select medical records by mrtype and mrno
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainCtl.GetMainByTypeRegNo"))
============================================*/
function GetMainByTypeRegNo(methodControl, MrType, MrNo, Flag)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrType, MrNo);
	//window.alert(strMethod);
	if(ret.indexOf("^") == -1)
	{
		return null;
	}
	else
	{
		return BuildDHCWMRMain(ret);
	}
}
/*===========================================
Name:GetDHCWMRMain
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:
paadm:Paadm Rowid
condition
Comment: Update discharge information of paadm
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainCtl.GetMainById"))
============================================*/
function UpdateAdmitCondition(methodControl, paadm, condition)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, paadm, condition);
	//window.alert(paadm + "   " + condition);
	//window.alert(ret);
	return (ret > 0);
}

/*===========================================
Name:GetDHCWMRWorkItemByTypeFlag
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:
workType:
flag
Comment: Get workitems by worktype
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRWorkItemCtl.QueryByTypeFlagLIST"))
============================================*/
function GetDHCWMRWorkItemByTypeFlag(methodControl, workType, flag)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, workType, flag);
	var arry = new Array();
	var strArry = null;
	var obj = null;
	if(ret != null)
	{
		arry = GetDHCWMRWorkItemArray(ret);
	}
	return arry;
}

/*===========================================
Name:GetDHCWMRDictionaryArryByTypeFlag
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:
dicType:
flag
Comment: Get dictionary list by dictionary name
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRDictionaryCtl.QueryByTypeFlagLIST"))
============================================*/
function GetDHCWMRDictionaryArryByTypeFlag(methodControl, dicType, flag)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, dicType, flag);
	var arry = new Array();
	var strArry = null;
	var obj = null;
	if(ret != null)
	{
		arry = GetDHCWMRDictionaryArray(ret);
	}
	return arry;
}
/*===========================================
Name:GetPatientInfoByMrRowID
Author: LiYang, Microsoft
Date: 2007-3-13
Param:
methodControl:
MrType 
MrRowID:medical records RowID
Flag :
Comment: Get patient information by medical records rowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRBaseInfoCtl.GetBaseInfoByMain"))
============================================*/
function GetPatientInfoByMrRowID(methodControl, MrRowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrRowID);
	return buildDHCWMRHistory(ret);	
}

/*===========================================
Name:GetDHCWMRMainVolumeByID
Author: LiYang, Microsoft
Date: 2007-4-4
Param:
methodControl:
Parref:volume ROWID
Comment: Get volume information by voluem rowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRVolumeCtl.GetVolume"))
============================================*/
function GetDHCWMRMainVolumeByID(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	return BuildDHCWMRMainVolume(ret);	
}

/*===========================================
Name:Receipt
Author: LiYang, Microsoft
Date: 2007-4-4
Param:
methodControl:
MrType:
papmi, patient RowID
paadm, Paadm RowID
MainRowid, medical records rowid
ctloc, Next's office Location ID
NameSpell, 
patcond, Admission state
OldNo, old MrNo
UserId user RowID
Comment: get volume informationary by volume rowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRReceipt.Receipt"))
============================================*/
function Receipt(methodControl, MrType, papmi, paadm, MainRowid, ctloc, NameSpell, patcond, OldNo, UserId)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrType, papmi, paadm, MainRowid, ctloc, NameSpell, patcond, OldNo, UserId);
	return ret;
}


/*===========================================
Name:UnReceipt
Author: LiYang, Microsoft
Date: 2007-4-4
Param:
methodControl:
VolRowid:RowID
Comment: get volume informationary by volume rowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRReceipt.UnReceipt"))
update by zf 2008-09-02
============================================*/
function UnReceipt(methodControl, VolRowid,LocId,UserId)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, VolRowid,LocId,UserId);
	return (ret == "0");
}





/*===========================================
Name:UnReceipt
Author: LiYang, Microsoft
Date: 2007-4-4
Param:
methodControl:
VolID:
Comment: get volume informationary by volume rowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRReceipt.UnReceipt"))
============================================
function UnReceipt(methodControl, VolID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, VolID);
	return (ret == 0);
}*/

/*===========================================
Name:SaveWorkDetail
Author: LiYang, Microsoft
Date: 2008-3-2
Param:
///   ObjectType   :operation item  0-medical records    1-volume
///   ItemDr       :operation item   DHC_WMR_WorkItem.Rowid
///   MainRowid    :  DHC_WMR_Main.Rowid         ObjectType=0
///   VolRowid     :  DHC_WMR_MainVolume.Rowid   ObjectType=1
///   sStatus      :the input string of DHC_WMR_MainStatus/DHC_WMR_VolStatus
///   sDtlList     ?? the input string of StatusDtl  Separate by $c(1)
/// return        ??ret=0 success    ret<0 fale
Comment: get volume informationary by volume rowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMROperation.Operation"))
============================================*/
function SaveWorkDetail(methodControl, ObjectType, ItemDr, MainRowid, VolRowid, sStatus, sDtlList, RequestDr)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, ObjectType, ItemDr, MainRowid, VolRowid, sStatus, sDtlList, RequestDr);
	return (ret == 0);
}

/*===========================================
Name:GetVolumeByAdm
Author: LiYang, Microsoft
Date: 2007-4-16
Param:
methodControl:
adm:
Comment: Get voluem information by AdmId
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRVolumeCtl.GetVolumeByAdm"))
============================================*/
function GetVolumeByAdm(methodControl, adm) 
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, adm);
	var obj = null;
	if((ret != null) && (ret != ""))
	{
		obj = BuildDHCWMRMainVolume(ret);
	}
	return obj;
}

/*===========================================
Name:VerifyUser
Author: LiYang, Microsoft
Date: 2008-3-5
Param:
methodControl:
UserCode:
Passwor:
Comment: Get User information by UserCode and UserPassword
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.VerifyUser"))
============================================*/
function VerifyUser(methodControl, UserCode, Password)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, UserCode, Password);
	var objUser = null;
	var arryTmp = null;
	if(ret != "-1")
	{
		objUser = BuildVerifyUser(ret);
	}
	return objUser;
}


/*===========================================
Name:GetFullUserInfo
Author: LiYang, Microsoft
Date: 2007-5-9
Param:
methodControl:
UserCode:
Passwor:
Comment: Get User information by UserCode and UserPassword
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetLogUserInfo"))
============================================*/
function GetFullUserInfo(methodControl, UserID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, UserID);
	var objUser = null;
	if(ret != "-1")
	{
		objUser = BuildDHCWMRUser(ret);
	}
	return objUser;
}

/*===========================================
Name:GetDHCWMRMainVolumeArryByMainID
Author: LiYang, Microsoft
Date: 2007-4-27
Param:
methodControl:
RowID:
Comment: get volume information by MainRowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRVolumeQry.QueryVolListByMainInfo"))
============================================*/
function GetDHCWMRMainVolumeArryByMainID(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	if(ret != "")
	{
		return BuildDHCWMRMainVolumeArry(ret);
	}
	else
	{
		return new Array();
	}
}


/*===========================================
Name:GetVBPrinterObjectString
Author: LiYang, Microsoft
Date: 2007-5-8
Param:
methodControl:
VbPrinter <object></object>
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRPUBLIC.clsPrinter"))
============================================*/
function GetVBPrinterObjectString(methodControl)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod);
	return ret;
}

/*===========================================
Name:GetPinyinObjectString
Author: LiYang, Microsoft
Date: 2007-5-8
Param:
methodControl:
VbPrinter <object></object>
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRPUBLIC.clsPinYin"))
============================================*/
function GetPinyinObjectString(methodControl)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod);
	return ret;
}


/*===========================================
Name:GetWMRBarCodeObjectString
Author: LiYang, Microsoft
Date: 2007-5-8
Param:
methodControl:
VbPrinter <object></object>
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRPUBLIC.clsWMRBarCode"))
============================================*/
function GetWMRBarCodeObjectString(methodControl)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod);
	return ret;
}



/*===========================================
Name:GetDischargeList
Author: LiYang, Microsoft
Date: 2007-5-8
Param:
methodControl:
MrTypeDr:
separate records by $c(1)
Separate fields by "^"
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRVolDisAdmQry.GetDischargeList"))
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRVolDisAdmQry.GetDataBy"))
============================================*/
function GetDischargeList(methodControl1,methodControl2, MrTypeDr)
{
	var strMethod = document.getElementById(methodControl1).value;
	var ProcessID = GetCode(cspRunServerMethod(strMethod, "", MrTypeDr, ""), "^");
	var strMethod1 = document.getElementById(methodControl2).value;
	var ret = cspRunServerMethod(strMethod1, ProcessID);
	return BuildDHCWMRDischargeListItemArry(ret);
}


/*===========================================
Name:GetDHCWMRVolInfoByVolumeID
Author: LiYang, Microsoft
Date: 2007-5-16
Param:
methodControl:
MrTypeDr:
Get volume information by volume rowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRVolumeCtl.GetVolInfoByVol"))
============================================*/
function GetDHCWMRVolInfoByVolumeID(methodControl, VolumeID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, VolumeID);
	return BuildDHCWMRVolInfo(ret);
}

/*===========================================
Name:GetDHCWMRHistoryAdm
Author: LiYang, Microsoft
Date: 2007-5-28
Param:
methodControl:
HistoryAdmID:
Get history paadm information by history AdmId
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRHistoryCtl.GetHistoryAdmById"))
============================================*/
function GetDHCWMRHistoryAdm(methodControl, HistoryAdmID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, HistoryAdmID);
	return BuildDHCWMRHistoryAdm(ret);
}

/*===========================================
GetDHCWMRMainByPapmi
Author: LiYang, Microsoft
Date: 2007-6-20
Param:
methodControl:
PatientID:
MrType:

Get medical records main information by papmi
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainQry.GetMainByPapmi"))
============================================*/
function GetDHCWMRMainByPapmi(methodControl, MrType, PatientID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrType, PatientID);
	return BuildDHCWMRMain(ret);
}



/*===========================================
GetMrNoCountAndCurrNo
Author: LiYang, Microsoft
Date: 2007-6-20
Param:
methodControl:
MrType:
Loc:
return:
remaining MrNo^Current MrNo

//Get Remaining MrNO
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRNoCtl.GetMrNoCountAndCurrNo"))
============================================*/
function GetMrNoCountAndCurrNo(methodControl, MrType, Loc)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrType, Loc);
	return ret;
}

/*===========================================
GetMrNoCountAndCurrNo
Author: LiYang, Microsoft
Date: 2007-6-20
Param:
methodControl:
/// sHistory       :  DHC_WMR_History string
/// sMain          :  DHC_WMR_Main string
/// sHisVolList    :  Separate DHC_WMR_HistoryAdm and DHC_WMR_MainVolume by $c(1)
return:
remaining MrNo^Current MrNo

//Get Remaining MrNO
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRHistoryCtl.SaveHistory"))
============================================*/
function SaveHistory(methodControl, sHistory, sMain, sHisVolList,LocId,UserId)
{
	//update by zf   LocId  UserId
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, sHistory, sMain, sHisVolList,LocId,UserId);
	return ret;
}

//get diagnose of one paadm
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRBasePaadm.GetMrDiagnose"))
function GetMrDiagnose(methodControl, Paadm)
{
	var strMethod = document.getElementById(methodControl).value;
	return cspRunServerMethod(methodControl, Paadm);
}



/*===========================================
Name:GetRuleByDic
Author: LiYang, Microsoft
Date: 2007-9-5
Param:
methodControl:
RowID:
Active:
Comment: Get Rule list by dictionary
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamRuleCtl.GetRuleByDic"))
============================================*/
function GetRuleByDic(methodControl, RuleDic, Active)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RuleDic, Active);
	var objRule = null;
	var objRuleDic = null;
	var arry = ret.split(CHR_2);
	if(ret != "undefined")
	{
	    objRule = BuildDHCWMRExamRule(arry[0]);
	    objRuleDic = BuildDHCWMRRuleDic(arry[1]);
		objRule.RuleDic = objRuleDic;
	}
	return objRule;
}

/*===========================================
Name:GetSectionByRule
Author: LiYang, Microsoft
Date: 2007-9-5
Param:
methodControl:
RuleRowID:
Active:
Comment: Get section list by RuleRowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamRuleCtl.GetSectionByRule"))
============================================*/
function GetSectionByRule(methodControl, RuleRowID, Active)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RuleRowID, Active);
	var objSection = null;
	var objSectionDic = null;
	var arry = ret.split(CHR_1);
	var arryTmp = null;
	var arrySection = new Array();
	for(var i = 0; i < arry.length; i ++)
	{
	    arryTmp = arry[i].split(CHR_2);
	    objSection = BuildDHCWMRExamSection(arryTmp[0]);
	    objSectionDic = BuildDHCWMRSectionDic(arryTmp[1]);
		objSection.SectionDic = objSectionDic;
		arrySection.push(objSection);
	}
	return arrySection;
}



/*===========================================
Name:GetEntryBySection
Author: LiYang, Microsoft
Date: 2007-9-5
Param:
methodControl:
SectionRowID:section rowid
Active:
Comment: Get Entry by sectionId
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamRuleCtl.GetEntryBySection"))
============================================*/
function GetEntryBySection(methodControl, SectionRowID, Active)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, SectionRowID, Active);
	var objEntry = null;
	var objEntryDic = null;
	var arry = ret.split(CHR_1);
	var arryTmp = null;
	var arryEntry = new Array();
	for(var i = 0; i < arry.length; i ++)
	{
	    arryTmp = arry[i].split(CHR_2);
	    objEntry = BuildDHCWMRExamEntry(arryTmp[0]);
	    objEntryDic = BuildDHCWMREntryDic(arryTmp[1]);
	    if(objEntryDic != null)
	    {
		    objEntry.EntryDic = objEntryDic;
		    arryEntry.push(objEntry);
	    }
	}
	return arryEntry;
}


/*===========================================
Name:GetExamEntryById
Author: LiYang, Microsoft
Date: 2007-9-5
Param:
methodControl:
EntryID:
Active:
Comment: Get ExamEntry list by sectionId
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamRuleCtl.ByIdGetEntry"))
============================================*/
function GetExamEntryById(methodControl, EntryID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, EntryID);
	var objEntry = null;
	var objEntryDic = null;
	var arryTmp = ret.split(CHR_2);
	if(ret != "")
	{
		objEntry = BuildDHCWMRExamEntry(arryTmp[0]);
		objEntryDic = BuildDHCWMREntryDic(arryTmp[1]);
		objEntry.EntryDic = objEntryDic;
	}
	return objEntry;
}


/*===========================================
Name:GetGradeByRuleId
Author: LiYang, Microsoft
Date: 2007-9-5
Param:
methodControl:
RuleID:
Comment: Get Grade By RuleId
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamRuleCtl.GetGardeByRuleId"))
============================================*/
function GetGradeByRuleId(methodControl, RuleID, Active)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RuleID, Active);
	var objGrade = null;
	var arryTmp = ret.split(CHR_1);
	var arryGrade = new Array();
	for(var i = 0; i < arryTmp.length; i ++)
	{
		objGrade = BuildDHCWMRExamGrade(arryTmp[i]);
		arryGrade.push(objGrade);
	}
	return arryGrade;
}


/*===========================================
Name:UpdateExamResult
Author: LiYang, Microsoft
Date: 2007-9-5
Param:
methodControl:
str:
return:rowid
Comment: Update ExamResult
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamResultCtl.UpdateExamResult"))
============================================*/
function UpdateExamResult(methodControl, str)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, str);
	return ret;
} 



/*===========================================
Name:SaveExamRDtl
Author: LiYang, Microsoft
Date: 2007-9-5
Param:
methodControl:
RuleID:
strResult:Result Main
strDetail:Related Detail info
Comment: Save ExamResult
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamResultCtl.SaveExamRst"))
============================================*/
function SaveDHCWMRExamResult(methodControl, strResult, strDetail)
{
    var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, strResult, strDetail);
	return ret;
} 

/*===========================================
Name:SaveExamRDtl
Author: LiYang
Date: 2008-10-13
Param:
methodControl:
RowID:DHCWMRExamResult RowID
Comment: Get ExamResult by it's rowid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRQualityBaseCtl.GetExRById"))
============================================*/
function GetDHCWMRExamResultByID(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	return BuildDHCWMRExamResult(ret);
}


//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRChineseCtl.GetChinese"))
function GetChineseDic(MethodName, Ind)
{
	try{
		var strMethod = document.getElementById(MethodName).value;
	}catch(e){
		MethodName="MethodGetChinese";
		var strMethod = document.getElementById(MethodName).value;
	}
	var ret = cspRunServerMethod(strMethod,Ind);

	var tmpList=ret.split("#");
	var objDic = new ActiveXObject("Scripting.Dictionary");
	var strKey = "";
	var strValue = "";
	for(var i = 0; i <tmpList.length; i ++)
	{
		strKey = GetCode(tmpList[i], "^");
		strValue = GetDesc(tmpList[i], "^");
		if(!objDic.Exists(strKey))
			objDic.Add(strKey, strValue);
	}
	return objDic;
}


//20071216

//Save AutoCheckRuleItem info
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamACRCtl.UpdateACRule"))
function UpdateACRule(methodControl, str)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, str);
	return ret;
}

//get AutoCheckRuleItem info
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamACRCtl.GetExamACRById"))
function GetExamACRById(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	return BuildAutoCheckRuleItem(ret);
}

//get AutoCheckRuleItem info by Code
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamACRCtl.GetExamACRByRCode"))
function GetExamACRByRCode(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	return BuildAutoCheckRuleItem(ret);
}

//query AutoCheckRuleItem info by Description
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamACRCtl.GetExamACRByDesc"))
function GetExamACRByDesc(methodControl, Desc)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Desc);
	var objArry = new Array();
	if(ret != null)
	{
	    var arry = ret.split(CHR_1);
	    for(var i = 0; i < arry.length; i ++)
	    {
	        if(arry[i] != "")
	            objArry.push(BuildAutoCheckRuleItem(arry[i]));
	    }
	}
	return objArry;
}

//query all AutoCheckRuleItem info by Description
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamACRCtl.GetExamACRAll"))
function GetExamACRAll(methodControl)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod);
	var objArry = new Array();
	if(ret != null)
	{
	    var arry = ret.split(CHR_1);
	    for(var i = 0; i < arry.length; i ++)
	    {
	        if(arry[i] != "")
	            objArry.push(BuildAutoCheckRuleItem(arry[i]));
	    }
	}
	return objArry;
}

//Get Dictionary by Type
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRDictionaryCtl.QueryByTypeFlagLIST"))
function QueryDictionaryByTypeFlagLIST(methodControl, dicTpye, flag)
{
    var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, dicTpye, flag);
	var objArry = new Array();
	if(ret != null)
	{
	    var arry = ret.split(CHR_1);
	    for(var i = 0; i < arry.length; i ++)
	    {
	        if(arry[i] != "")
	            objArry.push(BuildDHCWMRDictionary(arry[i]));
	    }
	}
	return objArry;
}

//2008-1-17
//Get ICD Dictionary
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseICD.GetMyICDByRowId"))
//Modified By LiYang 2009-07-29 can assign dic type
function GetDHCWMRDiseaseICDDxByID(methodControl, RowID, SrcType)
{
	if ((SrcType == null)||(SrcType == ''))
		SrcType = -1;
    var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID, SrcType);
	return BuildDHCWMRICDDx(ret);
}

//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseICD.GetMyOperByRowId"))
//Modified By LiYang 2009-07-29 can assign dic type
function GetDHCWMROperationICDDxByID(methodControl, RowID, SrcType)
{
	if ((SrcType == null)||(SrcType == ''))
		SrcType = -1;	
  var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID, SrcType);
	return BuildDHCWMRICDDx(ret);
}


//Get Front Page input Template
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRFPTempCtl.GetTemp"))
function GetDHCWMRFPTemplateByID(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	return BuildDHCWMRFPTemplate(ret);
}


//Get Front Page input Template detail
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRFPTempCtl.GetTempDtl"))
function GetDHCWMRTemplateDtlFromTempID(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	var objArry = new Array();
	var arryTmp = ret.split(CHR_2);
	var obj = null;
	for(var i = 0; i < arryTmp.length; i ++)
	{
		obj = BuildDHCWMRTemplateDtl(arryTmp[i]);
		if(obj != null)
			objArry.push(obj);
	}
	return objArry;
}


//Get Front page Item Dic
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRFPTempCtl.GetItem"))
function GetFrontPageItemDicByID(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	return BuildDHCWMRFPItemDic(ret);
}

//get dictionary by dictionary type and code
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRDictionaryCtl.QueryByTypeCode"))
function GetDHCWMRDictionaryByTypeCode(methodControl, Type, Code)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Type, Code);
	return BuildDHCWMRDictionary(ret);
}

//transaction of saving front page
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRFrontPageCtl.Coding"))
function SaveFrontPageInfo(methodControl, DelICDStr, FrontPage, ICDList, ExtraList)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, DelICDStr, FrontPage, ICDList, ExtraList);
	return ret;
}
//Get Front Page Main info
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRFrontPageQry.GetFrontPageInfo"))
function GetFrontPageInfo(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	if(ret == "")
		return null;
	var tmpArry = ret.split(CHR_1);
	var objFPMain = BuildDHCWMRFrontPage(tmpArry[0]);
	var arryTmpICD = tmpArry[1].split(CHR_2);
	var arryTmpExtra = tmpArry[2].split(CHR_2);
	var arryICD = new Array();
	var arryExtra = new Array();
	var tmp = "";
	var obj = null;
	for(var i = 0; i < arryTmpICD.length; i++)
	{
		tmp = arryTmpICD[i];
		obj = BuildDHCWMRFPICD(tmp);
		if(obj != null)
			arryICD.push(obj);
	}
	for(var i = 0; i < arryTmpExtra.length; i++)
	{
		tmp = arryTmpExtra[i];
		obj = BuildDHCWMRFPExtra(tmp);
		if(obj != null)
			arryExtra.push(obj);
	}	
	objFPMain.ICDList = arryICD;
	objFPMain.ExtraList = arryExtra;
	
	return objFPMain;
}

//get template detail from MrType
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRFPTempQry.GetTempItem"))
function GetTemplateDetailByMrType(methodControl, MrType)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrType);
  var arry = new Array();
  var arryTmp = ret.split(CHR_1);
  var obj = null;
  for(var i = 0; i < arryTmp.length; i ++)
  {
  		obj = BuildDHCWMRTemplateDtl(arryTmp[i]);
  		if(obj != null)
  			arry.push(obj);
  }
  return arry;
}

//get entrie mrno dictionary

//*************need implenment 
function GetMrNoList(methodControl, Regno)
{
		var strMethod = document.getElementById(methodControl).value;
		var ret = cspRunServerMethod(strMethod, Regno);
		var objDic = new ActiveXObject("Scripting.Dictionary");
		
		return objDic;
}


//by wuqk 2008-2-26
//get DHCWMRRequest
//Param:MrMainRowId, AimDateFrom, AimDateTo, sIsActive
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRRequest.GetReqList"))
function GetReqList(methodControl, MrMainRowId, AimDateFrom, AimDateTo, sIsActive)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MrMainRowId, AimDateFrom, AimDateTo, sIsActive);
  var arry = new Array();
  var arryTmp = ret.split(CHR_1);
  var obj = null;
  for(var i = 0; i < arryTmp.length; i ++)
  {
  		obj = BuildDHCWMRRequest(arryTmp[i]);
  		if(obj != null)
  			arry.push(obj);
  }
  return arry;
}
/*===========================================
Name:NewRequest
Author: wuqk
Date: 2008-2-26
Param:
methodControl:
str:
return:rowid
Comment: NewRequest
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRRequest.NewRequest"))
============================================*/
function NewRequest(methodControl, str)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, str);
	return ret;
} 

//CommitReqIndex
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRRequest.CommitReqIndex"))
function CommitReqIndex(methodControl, InString)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, InString);
  return ret;
}

//TransferReq     add by wuqk 2008-03-05
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRRequest.TransferReq"))
function TransferReq(methodControl, ReqRowId, ItemDr, UserId)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, ReqRowId, ItemDr, UserId);
  return ret;
}
/***********************End by wuqk *************************/


//-------2007-3-5 by liyang//
//GetMrNoByRegNo   get mrno by registration number and mr type dr
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainCtl.GetMainByRegNo"))
function GetMrNoByRegNo(methodControl, RegNo)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RegNo);
	var objDic = new ActiveXObject("Scripting.Dictionary");
	var arry = ret.split(CHR_1);
	var objMain = null;
	for(var i = 0; i < arry.length; i ++)
	{
		objMain = BuildDHCWMRMain(arry[i]);
		//Modified By LiYang  2008-09-08  to prevent multiple medical Record no error
		if((objMain != null)&&(!objDic.Exists(objMain.MrType)))
			objDic.Add(objMain.MrType, objMain);
	}
  return objDic;
}

//--------end----------


/*===========================================
Name:QueryAdmitOperation
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
Flag:IsActive
Comment:Get Operation List of a patient
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseArcimCtl.GetOrdsOper"))
============================================*/
function QueryAdmitOperation(methodControl, Paadm)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Paadm);
	return BuildObjArry(ret, CHR_1, BuildAdmitOperation);
}

/*===========================================
Name:QueryAdmitDiagnose
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
Flag:IsActive
Comment:Get Diagnose List of a patient
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBasePaadmCtl.GetMrDiagnose"))
============================================*/
function QueryAdmitDiagnose(methodControl, Paadm)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Paadm);
	return BuildObjArry(ret, CHR_1, BuildDHCMedAdmitDiagnose);
}


//Get paadm number list of an mr volume
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRVolumeCtl.GetVolumeAdmList"))
function GetVolumeAdmList(methodControl, VolID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, VolID);
	return ret.split(CHR_Up);	
}

//--------end----------

//GetWMRMainPatient     add by wuqk 2008-04-22
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainCtl.GetWMRMainPatient"))
function GetWMRMainPatient(methodControl, PatNo)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, PatNo);
	var objDHCWMRMainPatient=null;
	objDHCWMRMainPatient=BuildDHCWMRMainPatient(ret)
  return objDHCWMRMainPatient;
}

//GetNoVolAdm     add by wuqk 2008-04-22
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRMainCtl.GetNoVolAdm"))
function GetNoVolAdm(methodControl, papmi,strAdmType,strMrType)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, papmi,strAdmType,strMrType);
	var arry = ret.split(CHR_1);
	var objArray = new Array();
	var objVolAdm = null;
	for(var i = 0; i < arry.length; i ++)
	{
		objVolAdm = BuildDHCWMRNoVolAdm(arry[i]);
		if(objVolAdm != null)
			objArray.push(objVolAdm);
	}
  return objArray;
}

//GetcurrHospital     add by wuqk 2008-04-28
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBase01.GetDefaultHosp"))
function GetcurrHospital(methodControl)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod);
	var objHospital=null;
	objHospital=BuildHospital(ret)
  return objHospital;
}

//GetDHCWMRMainPatientTMP     add by zf 2008-05-30
//w ##Class(web.DHCWMRBaseInfoCtl).GetBaseInfoByMain(MainId)
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRBaseInfoCtl.GetBaseInfoByMain"))
function GetDHCWMRMainPatientTMP(methodControl, MainId)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MainId);
	var objDHCWMRMainPatientTMP=null;
	objDHCWMRMainPatientTMP=BuildDHCWMRMainPatientTMP(ret)
    return objDHCWMRMainPatientTMP;
}

//Get Disease ICD Dictionary config
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseICD.GetDHCWMRICDSettingD"))
function GetDHCWMRICDSettingD(methodControl)
{
	var strMethod = document.getElementById(methodControl).value;
	return cspRunServerMethod(strMethod);
}

//Get Operation ICD Dictionary config
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseICD.GetDHCWMRICDSettingO"))
function GetDHCWMRICDSettingO(methodControl)
{
	var strMethod = document.getElementById(methodControl).value;
	return cspRunServerMethod(strMethod);
}

//-------By Liyang 2008-6-15
//Get Department List
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetAllDep"))
function GetAllDep(methodControl)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod);
	var arry = ret.split(CHR_1);
	var obj = null;
	var arryReturn = new Array();
	for(var i = 0; i < arry.length; i ++)
	{
		obj = BuildDep(arry[i]);
		if(obj != null)
			arryReturn.push(obj);
	}
	return arryReturn;
}

//Get Location List
//Dep : Department ID
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetCtLocByDep"))
function GetCtLocByDep(methodControl,Dep)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Dep);
	var arry = ret.split(CHR_1);
	var obj = null;
	var arryReturn = new Array();
	for(var i = 0; i < arry.length; i ++)
	{
		obj = BuildDep(arry[i]);
		if(obj != null)
			arryReturn.push(obj);
	}
	return arryReturn;
}

//Get ExamRuleDIC List
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamRuleCtl.GetRuleDicList"))
function GetExamRuleDicList(methodControl, IsActive)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, IsActive);
	var arry = ret.split(CHR_1);
	var obj = null;
	var arryReturn = new Array();
	for(var i = 0; i < arry.length; i ++)
	{
		obj = BuildDHCWMREntryDic(arry[i]);
		if(obj != null)
			arryReturn.push(obj);
	}
	return arryReturn;
}

//Get Web Server Info
//Modified by LiYang 2008-10-08
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetServerInfo"))
function GetServerInfo(encmeth){
	var objWebConfig=new clsWebConfig("")
	if (encmeth!=""){		
		ret=cspRunServerMethod(encmeth);
		if (ret!=""){
			var TempFileds=ret.split(CHR_1)
			objWebConfig.CurrentNS=TempFileds[0];
			objWebConfig.MEDDATA=TempFileds[1];
			objWebConfig.LABDATA=TempFileds[2];
			objWebConfig.Server="cn_iptcp:"+TempFileds[3]+"[1972]";
			objWebConfig.Path=TempFileds[4];
			objWebConfig.LayOutManager=TempFileds[5];
			objWebConfig.WebServerAppURL = TempFileds[6];
			}
		}
	return objWebConfig;
	}


//Get Admit Information By VolumeID
//VolumeID: Volume RowID of a volume
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRBaseInfoCtl.GetAdmInfoByVol"))
function GetAdmByVolumeID(methodControl, VolumeID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, VolumeID);
	return BuildDHCWMRHistoryAdm(ret);
}


//get exam grade by id
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRQualityBaseCtl.GetEGById"))
function GetExamGradeByID(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	return BuildDHCWMRExamGrade(ret);
}

//get exam result by id
//Add By LiYang 2008-10-29
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRQualityBaseCtl.GetExamResultByVolID"))
//Get Exam Result by Volume ID
//RuleID: ExamRule RowID
//RowID: Exam Result RowID
function GetExamResultByVolumeID(methodControl, RuleID, RowID) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, RuleID, RowID);
    var arry = ret.split(CHR_1);
    var tmpArry = new Array();
    var obj = null;
    for (var i = 0; i < arry.length; i++) {
        obj = BuildDHCWMRExamResult(arry[i]);
        if (obj != null)
            tmpArry.push(obj);
    }
    return tmpArry;
}

//get exam result detail list by result id
//Add By LiYang 2008-11-12
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRExamResultCtl.GetDetailByResultID"))
//Get Exam Result Detail List
//ResultRowID: Exam Result RowID
function GetDHCWMRExamDetailListByResultID(methodControl, ResultRowID)
{
		var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, ResultRowID);
		return BuildDHCWMRExamResultDetailList(ret);
}


//Get patient paamd information
//VolID:Volume RowID
//return:get Patient admitinfo by volume id (for HIS only)
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRVolumeCtl.GetVolAdmInfo"))
//By LiYang 2008-09-24
function GetVolAdmInfo(methodControl, VolID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, VolID);
	var obj = null;
	if((ret != "undefined") && (ret != ""))
	{		
		obj = BuildDHCWMRAdmInfo(ret);
	}
	return obj;
}

//get PatCond ID  by EpisodeID
//Add By LiuXuefeng 2009-02-11
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRBasePaadm.GetAdmPatCondID"))
function GetAdmPatCondIDByEpisodeID(methodControl, EpisodeID)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, EpisodeID);
    return ret;
}
//Build DHC_WMR_Main For FC
//Add By LiuXuefeng 2009-03-23
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRService.IBuildMain"))
function IBuildMain(methodControl, MrType, papmi, InPutMrNo, UserId)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, MrType, papmi, InPutMrNo, UserId);
    return ret;
}

//UnReceipt By EpisodeID For FC
//Add By LiuXuefeng 2009-03-23
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRService.IUnReceiptByEpisodeID"))
function IUnReceiptByEpisodeID(methodControl, paadm,UserID)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, paadm,UserID);
    return ret;
}
//Build DHC_WMR_MainVolume For FC
//Add By LiuXuefeng 2009-03-23
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRService.IBuildVolume"))
function IBuildVolume(methodControl, MrType, paadm, NameSpell, InputMrNo, UserId)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, MrType, paadm, NameSpell, InputMrNo, UserId);
    return ret;
}
//Check MrNo in DHC_WMR_No whether Available or not
//Add By LiuXuefeng 2009-03-23
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRService.CheckMrNoActive"))
function CheckMrNoActive(methodControl, MrTypeDr, MrNo)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, MrTypeDr, MrNo);
    return ret;
}
//Check Financial Settlement Status 
//Add By LiuXuefeng 2009-06-05
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRBasePaadm.GetFSStatus"))
function GetFSStatus(methodControl, EpisodeID)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, EpisodeID);
    return ret;
}

//Get Ward List By Department
//Add By LiYang 2009-5-18
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetWardByDepHosp"))
function GetWardByDepHosp(methodControl, DepartmentID)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, DepartmentID);
    var arry = ret.split(CHR_1);
    var arryReturn = new Array();
    var obj = null;
    for(var i = 0; i < arry.length; i ++)
    {
    	obj = BuildWard(arry[i]);
    	if(obj != null)
    		arryReturn.push(obj);
    }
    return arryReturn;	
}


//Get MrNo String By PatName
//Add By LiuXuefeng 2009-07-01
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetMrNoStrByPatName"))
function GetMrNoStrByPatName(methodControl, PatName, MrType)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, PatName, MrType);
    return ret;
}

//Get Department By it's loc
//Add By LiYang 2009-5-18
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBase01.GetDepartmentByLocID"))
function GetDepartmentByLocID(methodControl, Loc)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, Loc);	
    return ret;
}



//Add By LiYang 2009-07-29 Query front page icd dictionary item
//Code :ICD Code
//SrcType : 1--MRC_ICDDx 2--ORC_Operation  3--MRC_DiagnosSignSymptom
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseICD.QueryByCode"))
function QueryFPICDByCode(methodControl, Code, SrcType)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, Code, SrcType);	
    return BuildDHCWMRICDDx(ret);	
}

//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRBaseDic.GetDocByName"))
function QueryDoctorByName(methodControl, DoctorName)
{
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, DoctorName);	
    return BuildDHCWMRUser(ret);		
}