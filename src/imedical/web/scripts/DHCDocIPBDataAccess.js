

//Create a simple data store for dictionary item
function CreateDicStore(arry)
{
	var obj = null;
	var objData = null;
	var arryData = new Array();
	var store = new Ext.data.SimpleStore({
			fields: [
			{name: 'RowID'}, 
			{name: 'Code'}, 
			{name: 'Description'}, 
			{name: 'DicObj'}, 
			{name:'checked', type:'bool'},
			{name: 'pChange'}
			]
		});
	for(var i = 0; i < arry.length; i ++)
	{
		obj = arry[i];
	  objData = new Ext.data.Record({
	  	RowID : obj.RowID,
	  	Code : obj.Code,
	  	Description : obj.Desc,
	  	DicObj:obj,
	  	checked:false
	  });
	  arryData[i] = objData;
	}
	store.add(arryData);
	return store;
}

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


//Get patient paamd information
//Paadm:paadm rowid
//return:patient paadm information
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCWMRBasePaadm.GetAdmInfo"))
function GetPatientAdmitInfo(methodControl, Paadm)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Paadm);
	var obj = null;
	if((ret != undefined) && (ret != ""))
	{		
		obj = BuildDHCMedAdmInfo(ret);
	}
	return obj;
}


/*===========================================
Name:GetDHCWMRDictionaryByID
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
Type:Dictionary Type
Flag:IsActive
Comment: Query DHCMed Dictionary Item by Dictionary Type and isActive Flag
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedDictionaryCtl.QueryByType"))
============================================*/
function QueryDicItemByTypeFlag(methodControl, Type, Flag,stateFlag)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Type, Flag,stateFlag);
	return BuildObjArry(ret, CHR_1, BuildDHCMedDictionaryItem);
}

function QueryDicItemByTypeFlagDic(methodControl, Type, Flag,stateFlag)
{
	var arry = QueryDicItemByTypeFlag(methodControl, Type, Flag,stateFlag);
	var obj = null;
	var objDic = new ActiveXObject("Scripting.Dictionary");
	for(var i = 0; i < arry.length; i ++)
	{
		obj = arry[i];
		if(!objDic.Exists(obj.Code))	
			objDic.Add(obj.Code, obj);
	}
	return objDic;
}


/*===========================================
Name:QueryInfectionPositionByFlag
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
Flag:IsActive
Comment: Query Infection Position Dictionary
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedInfPositionCtl.QueryInfectionPosition"))
============================================*/
function QueryInfectionPositionByFlag(methodControl, Flag)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Flag);
	return BuildObjArry(ret, CHR_1, BuildDHCMedInfectPosition);
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
Name:QueryAdmitLab
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
Flag:IsActive
Comment:Get Lab check List of a patient
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseArcimCtl.GetOrdsLab"))
============================================*/
function QueryAdmitLabCheck(methodControl, Paadm)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Paadm);
	return BuildObjArry(ret, CHR_1, BuildDHCMedAdmitLabCheckItem);
}

/*===========================================
Name:QueryAdmitArcim
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
Drugflag:Drug Arcim only?
Comment:Get ARCIM List of a patient
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseArcimCtl.GetOrdsDrugArcim"))
============================================*/
function QueryAdmitArcim(methodControl, Paadm, Drugflag)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Paadm, Drugflag);
	return BuildObjArry(ret, CHR_1, BuildDHCMedAdmitArcim);
}

/*===========================================
Name:QueryInfectionDiseaseList
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
alias:Pinyin Code
Type:InfectionSys:infection system's diagnose dictionary
     HIS:His diagnose dictionary
Comment:Query Disease List by Pinyin 
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedInfDiagnoseCtl.QueryByAlias"))
============================================*/
function QueryInfectionDiseaseList(methodControl, alias, Type)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, alias, Type);
	return BuildObjArry(ret, CHR_1, BuildInfectionDisease);
}


/*===========================================
Name:QueryInfectionOperationList
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
alias:Pinyin Code
Type:InfectionSys:infection system's Operation dictionary
     HIS:His diagnose dictionary
Comment:Query Disease List by Pinyin 
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedOrcDICCtl.GetORCOperByAlias"))
============================================*/
function QueryInfectionOperationList(methodControl, alias)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, alias, "");
	return BuildObjArry(ret, CHR_1, BuildInfectionDisease);
}



/*===========================================
Name:QueryInfectionDiseaseListByPos
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
PosID:Infection Pos
Comment:Query Disease List by Pinyin 
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedInfDiagnoseCtl.QueryInfDia"))
============================================*/
function QueryInfectionDiseaseListByPos(methodControl, PosID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, PosID);
	return BuildObjArry(ret, CHR_1, BuildInfectionDisease);
}


/*===========================================
Name:QueryDoctor
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
Code: doctor code, 
DocName: doctor name, 
ctLoc:departent row id
Comment:Query doctor
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBase01.QueryDoctor"))
============================================*/
function QueryDoctorList(methodControl, Code, DocName, ctLoc)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Code, DocName, ctLoc);
	return BuildObjArry(ret, CHR_1, BuildDoctor);
}



/*===========================================
Name:QueryDoctor
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
Code: doctor code, 
DocName: doctor name, 
ctLoc:departent row id
Comment:Query doctor
s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.SaveInfectionRep"))
============================================*/
function SaveInfectionRep(methodControl,MainStr, DiaStr, ReaStr, InfStr, OpeStr, LabStr, DrugStr, GermStr, SenStr)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, MainStr, DiaStr, ReaStr, InfStr, OpeStr, LabStr, DrugStr, GermStr, SenStr);
	return ret;
}

//Add By LiYang 2009-1-5
//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.UpdateInfRepDia"))
function SaveInfectionRepDia(methodControl, Dia)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Dia);
	return ret;
}

//Add By LiYang 2009-1-5
//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.UpdateInfRepOPR"))
function SaveInfectionRepOpe(methodControl, Ope)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, Ope);
	return ret;
}



/*===========================================
Name:QueryPathogenDic
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
Code: doctor code, 
DocName: doctor name, 
ctLoc:departent row id
Comment:Query doctor
s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfDictionaryCtl.QueryPathogenDic"))
s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfDictionaryCtl.GetPathogenDicList"))
============================================*/
function QueryPathogenDic(methodControl1, methodControl2, Code, Desc, ActiveFlag)
{
	var strMethod1 = document.getElementById(methodControl1).value;
	var strMethod2 = document.getElementById(methodControl2).value;
	var pid = cspRunServerMethod(strMethod1, Code, Desc, ActiveFlag);
	var str = "";
	var tmp = "";
	/*
	tmp = cspRunServerMethod(strMethod2, "", pid);
	
	while(tmp != "")
	{
		str += tmp;
		tmp = cspRunServerMethod(strMethod2, "", pid);
	}
	*/
	var tmpJIndex=pid;
	var tmpID="";
	do
	{
		tmp = cspRunServerMethod(strMethod2, tmpID, tmpJIndex);
		if (tmp!=="") {
			str += tmp;
			var tmp2=tmp.split(CHR_1);
			var tmp3=tmp2[tmp2.length-1].split("^");
			tmpID=tmp3[0];
		}
	}
	while (tmp!=="")
	return BuildObjArry(str, CHR_1, BuildDHCMedMedInfPathogen);
}


/*===========================================
Name:QueryAntiDic
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
Code: doctor code, 
DocName: doctor name, 
ctLoc:departent row id
Comment:Query doctor
s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfDictionaryCtl.QueryAntiDic"))
s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfDictionaryCtl.GetAntiDicList"))
============================================*/
function QueryAntiDic(methodControl1, methodControl2, Code, Desc, ActiveFlag)
{
	var strMethod1 = document.getElementById(methodControl1).value;
	var strMethod2 = document.getElementById(methodControl2).value;
	var pid = cspRunServerMethod(strMethod1, Code, Desc, ActiveFlag);
	var str = "";
	var tmp = "";
	/*
	tmp = cspRunServerMethod(strMethod2, "", pid);
	while(tmp != "")
	{
		str += tmp;
		tmp = cspRunServerMethod(strMethod2, "", pid);
	}
	*/
	var tmpJIndex=pid;
	var tmpID="";
	do
	{
			tmp = cspRunServerMethod(strMethod2, tmpID, tmpJIndex);
			if (tmp!=="") {
				str += tmp;
				var tmp2=tmp.split(CHR_1);
				var tmp3=tmp2[tmp2.length-1].split("^");
				tmpID=tmp3[0];
			}
	}
	while (tmp!=="")
	return BuildObjArry(str, CHR_1, BuildDHCMedMedAntiDic);
}


/*===========================================
Name:QueryDoctor
Author: LiYang, Microsoft
Param:
methodControl:Method name control ID
RowID: ReportID;
Comment:GetInfection Report
s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.GetInfRep"))
============================================*/
function GetInfRep(methodControl, RowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RowID);
	return BuildDHCMedInfectionRep(ret);
}
//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.GetInfRepDia"))
function GetInfRepDia(methodControl, RefRowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RefRowID);
	return BuildObjArry(ret, CHR_1, BuildDHCMedAdmitDiagnose);
}

//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.GetInfRepRea"))
function GetInfRepRea(methodControl, RefRowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RefRowID);
	return BuildObjArry(ret, CHR_1, BuildDHCMedInfectionRepRea);
}

//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.GetInfRepPos"))
function GetInfRepPos(methodControl, RefRowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RefRowID);
	return BuildObjArry(ret, CHR_1, BuildDHCMedInfectionRepPos);
}

//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.GetInfRepOPR"))
function GetInfRepOPR(methodControl, RefRowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RefRowID);
	return BuildObjArry(ret, CHR_1, BuildDHCMedInfectionRepOPR);
}

//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.GetInfRepDrug"))
function GetInfRepDrug(methodControl, RefRowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RefRowID);
	return BuildObjArry(ret, CHR_1, BuildDHCMedInfectionRepDrug);
}

//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.GetInfRepPathogeny"))
function GetInfRepPathogeny(methodControl, RefRowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RefRowID);
	return BuildObjArry(ret, CHR_1, BuildDHCMedInfPathogeny);
}

//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.GetInfRepPyObj"))
function GetInfRepPyObj(methodControl, RefRowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RefRowID);
	return BuildObjArry(ret, CHR_1, BuildDHCMedInfPyObj);
}

//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.GetInfRepPyObjDrug"))
function GetInfRepPyObjDrug(methodControl, RefRowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, RefRowID);
	return BuildObjArry(ret, CHR_1, BuildDHCMedInfPyObjDrug);
}

//s val=##Class(%CSP.Page).Encrypt($LB(web.DHCMedInfectionRepCtl.CheckInfRep"))
//Audit Infection Report 
//RowID : REport ID
//Status: New Report Status: 1-Waiting Audit 2-Passed 3-Modified 9-Back 10-BeModified 0-Deleted
//CheckUsr:Check User:who checked the report???
//Check Date/Time:Check date time
//Demo:Back reason
function CheckInfRep(methodControl, RowID, Status, CheckUsr, CheckDate, CheckTime, Demo)
{
	var strMethod = document.getElementById(methodControl).value;
	return  cspRunServerMethod(strMethod, RowID, Status, CheckUsr, CheckDate, CheckTime, Demo);
}


//whether have right to do the operation
//GroupID:Group ID
//FunctionName:
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.UserFunction"))
function HasPower(methodControl, GroupID, ApplicationName, FunctionName)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, GroupID, ApplicationName, FunctionName);
	return (ret == 0);
}

//whether have right to do the operation
//GroupID:Group ID
//FunctionName:
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.UserFunction"))
function HasPower(methodControl, GroupID, ApplicationName, FunctionName)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, GroupID, ApplicationName, FunctionName);
	return (ret == 0);
}


//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedInfConfigCtl.GetBaseConfig"))
function GetMedInfBaseConfig(methodControl)
{
	var objConfig = new Object();
	var strMethod = document.getElementById(methodControl).value; 
	var tmp = cspRunServerMethod(strMethod,"0");
	if(tmp == "")
    tmp = "0^///1/1/1/1/1/1/1^0";      //Default Data
  var tmpList = tmp.split(CHR_Up);
  objConfig.OperFlg = tmpList[0];
  objConfig.DrugFlg = tmpList[1].split(CHR_Tilted);
  objConfig.DiagFlg = tmpList[2];
 	return objConfig;
}


//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBasePaadmCtl.GetMic"))
function  GetMic(methodControl, TestSetRow)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, TestSetRow);
	return BuildObjArry(ret, CHR_1, BuildSenKabTestResult);	
}
	//add by lxf 2008-10-28
	//Query DHCDocIPBKTempItem by RowID
	function GetMedIPBKTempItemByID(methodControl, rowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, rowID);
	var objDic = null;
	if(ret != undefined)
	{
		objDic = BuildMedIPBKTempItem(ret);
	}
	return objDic;
}
	//add by lxf 2008-10-28
	//Query DHCDocIPBKTemplate by RowID
	function GetMedIPBKTemplateByID(methodControl, rowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, rowID);
	var objDic = null;
	if(ret != undefined)
	{
		objDic = BuildMedIPBKTemplate(ret);
	}
	return objDic;
}
	//add by lxf 2008-10-28
	//Get Table DHC_MedIPBKTempDtl list by Template RowID
function GetDHCDocIPBKTempDtlListArry(MethodControl, TempID)
{
	var strMethod = document.getElementById(MethodControl).value;
	var ret = cspRunServerMethod(strMethod,TempID);
	//alert("ret="+ret);
	var arry = new Array();
	var arryStr = null;
	var obj = null;
	if(ret == undefined)
	{
		//window.alert("Don't read information!");
	}
	else
	{
		arryStr = ret.split(CHR_1);
		for(var i = 0; i < arryStr.length; i ++)
		{
			//obj = BuildDHCWMRWorkItemList(arryStr[i]);
			obj = BuildMedIPBKTempDtl(arryStr[i]);
			if(obj != null)
			{
				arry.push(obj);
			}
		}
	}
	return arry;
}
	//add by lxf 2008-10-28
	//Query DHC_MedDictory by RowID
	function GetDHCMedDicByID(methodControl, rowID)
{
	var strMethod = document.getElementById(methodControl).value;
	var ret = cspRunServerMethod(strMethod, rowID);
	var objDic = null;
	if(ret != undefined)
	{
		objDic = BuildDHCMedDictionaryItem(ret);
	}
	return objDic;
}
	//add by lxf 2008-10-28
	//Save to Table DHC_MedDictory
	function SaveDictionary(objDic)
	{
		var encmeth = document.getElementById("MethodSave").value;
		var ret=cspRunServerMethod(encmeth, SerializeDHCMedDic(objDic));
		return (ret != undefined);
	}
	//add by lxf 2008-11-08
	//Get DHC_MedDictory RowID By MDIC_Code
	//Table DHC_MedDictory
	function GetMedDicIDByCode(strMethod,MDicType, MDicCode)
	{
		var encmeth = document.getElementById("MethodGetMedDicIDByCode").value;
		var ret=cspRunServerMethod(encmeth,MDicType,MDicCode);
		return ret;
	}
	//add by lxf 2008-11-09
	//Get CT_Loc Desc By RowID
	//Table CT_Loc
	function GetCTLocDescByID(RowID)
	{
		var encmeth = document.getElementById("MethodGetCTLocDescByID").value;
		var ret=cspRunServerMethod(encmeth,RowID);
		return ret;
	}
	//add by lxf 2008-11-10
	//Get MRDiagnos By EpisodeID
	//Table MR_Diagnos
	function GetMRDiagnosByEpisodeID(methodControl,EpisodeID)
	{
		var encmeth = document.getElementById(methodControl).value;
		var ret=cspRunServerMethod(encmeth,EpisodeID);
		return ret;
	}
	//add by lxf 2008-11-10
	//Get MRDiagnos By RowID
	//Table MRC_ICDDx
	function GetMRDiagnosByID(methodControl,RowID)
	{
		var encmeth = document.getElementById(methodControl).value;
		var ret=cspRunServerMethod(encmeth,RowID);
		return ret;
	}
	//add by lxf 2008-11-11
	//Get PAC_Ward RowID By WARD_LocationDR
	//Table PAC_Ward
	function GetWardRowIDByLocDR(methodControl,WARDLocDR)
	{
		var encmeth = document.getElementById(methodControl).value;
		var ret=cspRunServerMethod(encmeth,WARDLocDR);
		return ret;
	}
	//add by lxf 2008-11-13
	//Get HospName
	//Global ^CT
	function GetHospName(methodControl)
	{
		var encmeth = document.getElementById(methodControl).value;
		var ret=cspRunServerMethod(encmeth);
		return ret;
	}

	//add by lxf 2008-11-13
	//Get RelationID^RelationDesc
	//Table CT_Relation
	function GetRelationByPersonID(methodControl,PersonID)
	{
		var encmeth = document.getElementById(methodControl).value;
		var ret=cspRunServerMethod(encmeth,PersonID);
		return ret;
	}
	
	//add by lxf 2008-11-13
	//Get ForeignPhone
	//Table PA_Person
	function GetFPhoneByPersonID(methodControl,PersonID)
	{
		var encmeth = document.getElementById(methodControl).value;
		var ret=cspRunServerMethod(encmeth,PersonID);
		return ret;
	}
	//add by lxf 2008-10-28
	//Save to Table DHC_MedIPBKTempItem
	function SaveMedIPBKTempItem(objDic)
	{
		var encmeth = document.getElementById("MethodSave").value;
		var input=SerializeMedIPBKTempItem(objDic);
		var ret=cspRunServerMethod(encmeth, input);
		return ret
		//return (ret != undefined);
	}
	//add by lxf 2008-10-28
	//Save to Table DHC_MedIPBKTemplate
	function SaveMedIPBKTemplate(objDic)
	{
		var encmeth = document.getElementById("MethodSave").value;
		var input=SerializeMedIPBKTemplate(objDic);
		var ret=cspRunServerMethod(encmeth, input);
		return (ret != undefined);
	}


//Save DHCDocIPBooking
//By LiYang 2008-10-24
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCDocIPBookingCtl.Update"))
function SaveDHCDocIPBooking(methodControl, obj) {

    var strMethod = document.getElementById(methodControl).value;
    var objStr = SerializeDHCDocIPBooking(obj);
    var ret = cspRunServerMethod(strMethod, objStr)
    obj.RowID = ret;
    return ret;
}

//Get Inpatient Booking info by Book ID
//by LiYang 2008-10-25
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCDocIPBookingCtl.GetIPBookByID"))
function GetDHCDocIPBooking(methodControl, BookID) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, BookID)
    var obj = BuildDHCDocIPBooking(ret);
    return obj;
}


//Get Inpatient Booking info by Out Patient Paadm ID
//by LiYang 2008-10-25
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCDocIPBookingCtl.GetIPBookByPaadm"))
function GetDHCDocIPBookingByPaadm(methodControl, Paadm,RowID) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, Paadm,RowID)
    var obj = BuildDHCDocIPBooking(ret);
    return obj;
}

//Save DHCDocIPBooking
//By LiYang 2008-10-24
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCDocIPBookingCtl.UpdateBookState"))
function SaveDHCDocIPBKState(methodControl, obj) {

    var strMethod = document.getElementById(methodControl).value;
    var objStr = SerializeDHCDocIPBKState(obj);
    var ret = cspRunServerMethod(strMethod, objStr);
    obj.RowID = ret;
    return ret;
}

//Save DHCDocIPBooking
//By LiYang 2008-10-24
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCDocIPBookingCtl.UpdateDetail"))
function SaveDHCDocIPBKDetail(methodControl, obj) {

    var strMethod = document.getElementById(methodControl).value;
    var objStr = SerializeDHCDocIPBKDetail(obj);
    var ret = cspRunServerMethod(strMethod, objStr);
    obj.RowID = ret;
    return ret;
}

//Get user information by rowid
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetLogUserInfo"))
function GetDHCWMRUserByID(methodControl, ID) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, ID);
    if ((ret == undefined) || (ret == "")) {
        return null;
    }
    else {
        return BuildDHCWMRUser(ret);
    }
}
//Get IP Book Template List
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCDocIPBookTempCtl.GetTemplateArry"))
function GetDHCDocIPBookingTemplateArry(methodControl) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod);
    return BuildObjArry(ret, CHR_1, BuildDHCDocIPBKTemplate);
}

//Save Base info(update paperson)
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCDocIPBookingCtl.UpdatePatientBaseInfo"))
//function SaveBookingPatientBaseInfo(methodControl, PatientID, Company, HomeAddress, Tel, PersonalID, FName, FPhone) {
//    var strMethod = document.getElementById(methodControl).value;
//    return cspRunServerMethod(strMethod, PatientID, Company, HomeAddress, Tel, PersonalID, FName, FPhone);
//
//}

//Save Base info(update paperson)
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCDocIPBookingCtl.UpdatePatientBaseInfo"))
function SaveBookingPatientBaseInfo(methodControl, PatientID, Company, HomeAddress, Tel, PersonalID, FName, FPhone, RelationID) {
    var strMethod = document.getElementById(methodControl).value;
    return cspRunServerMethod(strMethod, PatientID, Company, HomeAddress, Tel, PersonalID, FName, FPhone, RelationID);

}

//Create Patient Admit
//s val=##Class(%CSP.Page).Encrypt($LB("web.DHCPAADM.ADMInsert"))
function CreatePaadm(methodControl, Arg) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, Arg);
    return ret;

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
Name:GetAllDep
Author: LiYang, Microsoft
Date: 2008-11-1
Param:
methodControl:
Get Department List of a hospital
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetAllDep"))
============================================*/
function GetAllDep(methodControl) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod);
    return BuildObjArry(ret, CHR_1, BuildDHCMedDepartment);
}


/*===========================================
Name:QueryWardByDep
Author: LiYang, Microsoft
Date: 2008-11-2
Param:
methodControl:
Get get ward list of a department
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBase01.QueryWardByDep"))
============================================*/
function QueryWardByDep(methodControl, Dep) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, Dep);
    return BuildObjArry(ret, CHR_1, BuildDHCMedWard);
}

/*===========================================
Name:QueryBedByDep
Author: LiYang, Microsoft
Date: 2008-11-2
Param:
methodControl:
Get Get Bed List of a department
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBase01.QueryBedByDep"))
============================================*/
function QueryBedByDep(methodControl, Dep) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, Dep);
    return BuildObjArry(ret, CHR_1, BuildDHCMedBed);
}

/*===========================================
Name:GetLocByDep
Author: LiYang, Microsoft
Date: 2008-11-2
Param:
methodControl:
Get Get loc list of a department
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBaseCtl.GetCtLocByDep"))
============================================*/
function GetLocByDep(methodControl, Dep) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, Dep);
    return BuildObjArry(ret, CHR_1, BuildDHCMedDepartment);
}


/*===========================================
Name:GetDepartmentByLocID
Author: LiYang, Microsoft
Date: 2008-11-2
Param:
methodControl:
Get department by its locid
s val=##Class(%CSP.Page).Encrypt($LB("web.DHCMedBase01.GetDepartmentByLocID"))
============================================*/
function GetDepartmentByLocID(methodControl, Dep) {
    var strMethod = document.getElementById(methodControl).value;
    var ret = cspRunServerMethod(strMethod, Dep);
    return ret;
}
