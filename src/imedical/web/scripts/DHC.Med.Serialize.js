var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_3=String.fromCharCode(3);
var CHR_4=String.fromCharCode(4);
var CHR_5=String.fromCharCode(5);


var CHR_Up="^";
var CHR_Tilted="/";



//create object arry from a string
//Param: str   string to make the array
//splitChar  string to be used as a delimiter
//buildFun:  function pointer to build a object from string
function BuildObjArry(str, splitChar, BuildFun)
{
	var objArry = new Array();
	var obj = null;
	if((str == "")||(str == null))
		return objArry;
	var arryString = str.split(splitChar);
	for(var i = 0; i < arryString.length; i ++)
	{
		obj = BuildFun.call(null, arryString[i]);
		if(obj != null)
			objArry.push(obj);
	}
	return objArry;
}

//create serialize objects in an array
//Param: arry   object array
//splitChar  string to be used as a delimiter
//buildFun:  function pointer to serialzie a object
function SerializeObjArry(arry, splitChar, SerialFun)
{
	var objItem = null;
	var str = "";
	for(var i = 0; i < arry.length; i ++)
	{
		objItem = arry[i];
		if(objItem != null)
			str += SerialFun.call(null, objItem) + splitChar;
	}
	return str;
}


function BuildPatient(str)
{
	var arry = null;
	var obj = new Object();
	if((str == undefined) || (str == ""))
	{
		return null;
	}
	arry = str.split(CHR_2);
	obj.PatientNo = arry[22]; 
	obj.MedRecNo = arry[19]; 
	obj.Sex = arry[1]; 
	obj.Identity = arry[4]; 
	obj.Birthday =arry[2]; 
	obj.Age = arry[3]; 
	obj.NowAddress = arry[17]; 
	obj.Telephone = arry[8]; 
	obj.RelationName = arry[13]; 
	obj.Company = arry[10]; 
	obj.PatientName = arry[0]; 
	obj.Nationality = arry[18]; 
	obj.Nation = arry[7]; 
	obj.Marriage = arry[6]; 
	obj.Culture = arry[9]; 
	obj.NativePlace = arry[5]; 
	obj.Relation = arry[11]; 
	obj.RelativeAddress = arry[12]; 
	obj.Payment = arry[20]; 
	obj.Occupation = arry[15]; 
	obj.RowID = arry[21];
	return obj;
}

function BuildDHCMedAdmInfo(str)
{
	if(str == "")
		return null;
	var arry = str.split(CHR_Up);
	var obj = DHCWMRAdmInfo();
	obj.RowID = arry[0];
	obj.AdmType = arry[1];
	obj.AdmNo = arry[2];
	obj.AdmDate = arry[3];
	obj.AdmTime = arry[4];
	obj.PatientID = arry[5];
	obj.LocDesc = arry[6];
	obj.DocDesc = arry[7];
	obj.WardDesc = arry[8];
	obj.RoomDesc = arry[9];
	obj.BedDesc = arry[10];
	obj.DischgDate = arry[11];
	obj.DischgTime = arry[12];
	obj.VisitStatus = arry[13];
	return obj;
}

function BuildDHCMedDictionaryItem(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedDictionaryItem();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];
	obj.Code = arry[1];
	obj.Desc = arry[2];
	obj.Type = arry[3];
	obj.Active = (arry[4] == "Y");
	obj.DateFrom =arry[5];
	obj.DateTo = arry[6];
	obj.StrA = arry[7];
	obj.StrB = arry[8];
	obj.StrC = arry[9];
	obj.StrD = arry[10];
	return obj;
}

function BuildDHCMedAdmitDiagnose(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedAdmitDiagnose();
	var arrySections = str.split(CHR_3);
	var arryFields = arrySections[0].split(CHR_2);
	var arryTmp = null;
	var arryTmp1 = null;
	var objDia = BuildDHCMedInfectionRepDia(arrySections[1]);
	obj.Paadm = arryFields[0];
	obj.PatientType = arryFields[1];
	arryTmp = arryFields[2].split(CHR_Tilted);
	arryTmp1 = arryTmp[1].split("-");
	obj.Location.RowID = arryTmp[0];
	obj.Location.Code = arryTmp1[0];
	obj.Location.Department = arryTmp1[1];
	obj.DiagnoseRowID = arryFields[3];
	arryTmp = arryFields[4].split(CHR_Tilted);
	if(arryTmp.length == 3)
	{
		obj.ICDRowID = arryTmp[0];
		obj.ICD = arryTmp[1];
		obj.DiagnoseName = arryTmp[2];
	}
	arryTmp = arryFields[5].split(CHR_Tilted);
	if(arryTmp.length == 3)
	{
		obj.Doctor.RowID = arryTmp[0];
		obj.Doctor.Code = arryTmp[1];
		obj.Doctor.UserName = arryTmp[2];
	}
	arryTmp = arryFields[6].split(CHR_Tilted);
	if(arryTmp.length == 3)
	{
	  obj.DiagnoseTypeRowID = arryTmp[0];
	  obj.DiagnoseTypeCode = arryTmp[1];
    obj.DiagnoseTypeDesc = arryTmp[2];	
	}
	obj.DiagnoseDate = arryFields[7];
	obj.DiagnoseTime = arryFields[8];
	obj.RepDia = objDia;
	
	return obj;
}

function BuildAdmitOperation(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedAdmitOperation();
	var arry = str.split(CHR_2);
	switch(arry.length)
	{
		case 4:
			obj.OperationRowID = arry[0];
			obj.OperationName = arry[1];
			obj.OrderDate = arry[2];
			obj.Status = arry[3];
			break;
		case 10:
			obj.OperationRowID = arry[0];
			obj.OperationName = arry[1];
			obj.OrderDate = arry[2];
			obj.Status = arry[3];		
			obj.StartDate = arry[4];
			obj.StartTime = arry[5];
			obj.EndDate = arry[6];
			obj.EndTime = arry[7];
			obj.OperDoc = arry[8];
			obj.Anamed = arry[9];			
			break;
		case 13:
			obj.OperationRowID = arry[0];
			obj.OperationName = arry[1];
			obj.OrderDate = arry[2];
			obj.Status = arry[3];		
			obj.StartDate = arry[4];
			obj.StartTime = arry[5];
			obj.EndDate = arry[6];
			obj.EndTime = arry[7];
			obj.OperDoc = arry[8];
			obj.Anamed = arry[9];
			obj.anDoctor=arry[10];
			obj.assList=arry[11];
			obj.OPICD9Map=arry[12];
			obj.OperDocObj=BuildDoctor(arry[8],CHR_Tilted );  //20090826
			break;	
	}

	return obj;
}

function BuildDHCMedAdmitLabCheckItem(str)
{
	if((str == "") || (str == null))
		return null;	
	var obj = new DHCMedAdmitLabCheckItem();	
	arry = str.split(CHR_2);
	obj.OrderID = arry[0];
	obj.LabName = arry[1];
	obj.LabDate = arry[2];
	obj.flag = arry[3];
	obj.LabTestSetRow = arry[4];
	obj.Status = arry[5];
	return obj;
}

function BuildDHCMedAdmitArcim(str)
{
	if((str == "") || (str == null))
		return null;	
	var obj = new DHCMedAdmitArcim();
	var arry = str.split(CHR_2);
	obj.OrderID = arry[0];
	obj.ArcimDesc = arry[1];
	obj.StartDate = arry[2];
	obj.EndDate = arry[3];
	obj.Days = arry[4];
	return obj;	
}

function BuildInfectionDisease(str)
{
	if((str == "") || (str == null))
		return null;	
	var obj = new DHCMedInfectionDisease();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];
	obj.ICD = arry[1];
	obj.DiseaseName = arry[2];
	obj.DiseaseType = arry[3];
	obj.ActiveFlag = (arry[4] == "Y");
	obj.ResumeText = arry[5];
	obj.PinyYin = arry[6];
	return obj;	
}

function BuildDoctor(str, splitChar)
{
	if((str == "") || (str == null))
		return null;	
	var obj = new DHCMedDoctor();	
	if ((splitChar == null) || (splitChar == ""))
		splitChar = CHR_Up;
	var arry = str.split(splitChar);
	var arryTmp = null;
	obj.RowID = arry[0];
	obj.Code = arry[1];
	obj.DoctorName = arry[2];
	if(arry.length > 3)
	{
		arryTmp = arry[3].split(CHR_Tilted);
		obj.Department.RowID = arryTmp[0];
		obj.Department.DepName = arryTmp[1];
	}
	return obj;
}


function SerializeDHCMedInfectionRep(obj)
{
	var str = "";
	if(obj == null)
		return "";
	str += obj.RowID + CHR_Up;
	str += obj.Paadm_DR + CHR_Up;
	str += obj.LapseTo + CHR_Up;
	str += obj.DeathConnection + CHR_Up;
	str += obj.ICUFlag + CHR_Up;
	str += obj.DrugEffect + CHR_Up;
	str += obj.DblInfFlag + CHR_Up;
	str += obj.BeModify_DR + CHR_Up;
	str += obj.Date + CHR_Up;
	str += obj.Time + CHR_Up;
	str += obj.User_DR + CHR_Up;
	str += obj.Status + CHR_Up;
	str += obj.CheckUsr_DR + CHR_Up;
	str += obj.CheckDate + CHR_Up;
	str += obj.CheckTime + CHR_Up;
	str += obj.Demo + CHR_Up;
	str += obj.RepPlace; //Add By LiYang 2009-4-7
	return str;
}

function BuildDHCMedInfectionRep(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedInfectionRep();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];
	obj.Paadm_DR = arry[1];
	obj.LapseTo = arry[2];
	obj.DeathConnection = arry[3];
	obj.ICUFlag = arry[4];
	obj.DrugEffect = arry[5];
	obj.DblInfFlag = arry[6];
	obj.BeModify_DR = arry[7];
	obj.Date = arry[8];
	obj.Time = arry[9];
	obj.UserObj = BuildDoctor(arry[10], CHR_Tilted);
	obj.User_DR = obj.UserObj.RowID;
	obj.Status = arry[11];
	obj.CheckUsrObj = BuildDoctor(arry[10], CHR_Tilted);
	obj.CheckUsr_DR = obj.CheckUsrObj.RowID;
	obj.CheckDate = arry[13];
	obj.CheckTime = arry[14];
	obj.Demo = arry[15];
	obj.RepPlace = arry[16];//Add By LiYang 2009-4-7
	return obj;
}

function SerializeDHCMedInfectionRepDia(obj,CleanChildSub)
{
	if(CleanChildSub ==null)
		CleanChildSub = true;	
	var str = "";
	if(obj == null)
		return "";
	str += (CleanChildSub ? "" : obj.ParRef) + CHR_Up;//obj.ParRef + CHR_Up;
	str += (CleanChildSub ? "" : obj.ChildSub) + CHR_Up;//obj.ChildSub + CHR_Up;
	str += obj.MrDia_DR + CHR_Up;
	str += obj.DiagDesc + CHR_Up;
	str += obj.DiagType + CHR_Up;
	str += obj.DiagDoc+ CHR_Up;
	str += obj.DiagDate + CHR_Up;
	str += obj.DiagTime + CHR_Up;
	str += obj.ICD10 + CHR_Up;
	str += obj.ICD10Desc + CHR_Up;
	str += obj.IsActive + CHR_Up;
	str += obj.Resume + CHR_Up;
	return str;		
}

function BuildDHCMedInfectionRepDia(str) //Modified By LiYang 2009-1-4
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedInfectionRepDia();
	var arry = str.split(CHR_Up);
	obj.ParRef = GetCode(arry[0],"||");
	obj.ChildSub = GetDesc(arry[0],"||");
	obj.RowID = arry[0];
	obj.MrDia_DR = arry[1];
	obj.DiagDesc = arry[2];
	obj.DiagType = arry[3];
	obj.DiagDoc = arry[4];
	obj.DiagDate = arry[5];
	obj.DiagTime = arry[6];
	obj.ICD10 = arry[7];
	obj.ICD10Desc = arry[8];
	obj.IsActive = arry[9];
	obj.Resume = arry[10];	
	return obj;		
}

function SerializeDHCMedInfectionRepOPR(obj,CleanChildSub)
{
	if(CleanChildSub ==null)
		CleanChildSub = true;
	var str = "";
	if(obj == null)
		return "";
		str += (CleanChildSub ? "" : obj.ParRef) + CHR_Up;//obj.ParRef + CHR_Up;
		str += (CleanChildSub ? "" : obj.ChildSub) + CHR_Up;//obj.ChildSub + CHR_Up;
		str += obj.OperationDesc + CHR_Up;
		str += obj.EmerOprFlag + CHR_Up;
		str += obj.DateFrom + CHR_Up;
		str += obj.TimeFrom + CHR_Up;
		str += obj.DateTo + CHR_Up;
		str += obj.TimeTo + CHR_Up;
		str += obj.OprDoc + CHR_Up;
		str += obj.Anaesthesia + CHR_Up;
		str += obj.CuteType + CHR_Up;
		str += obj.Concrescence + CHR_Up;
		str += obj.CuteInfFlag + CHR_Up;
		str += obj.OprCuteType + CHR_Up;
		str += obj.InfectionFlag + CHR_Up;
		str += obj.OEORI_DR + CHR_Up;
		str += obj.OPICD9Map + CHR_Up; //Modified By LiYang 2009-1-5
		str += obj.OperICD9Desc + CHR_Up; //Modified By LiYang 2009-1-5
		str += obj.IsActive + CHR_Up; //Modified By LiYang 2009-1-5
		str += obj.Resume; //Modified By LiYang 2009-1-5
	return str;	
}

function SerializeDHCMedInfectionRepRea(obj)
{
	var str = "";
	if(obj == null)
		return "";
	str += CHR_Up;//obj.ParRef + CHR_Up;
	str += CHR_Up;//obj.ChildSub + CHR_Up;
	str += obj.InfReason;
	return str;
}

function SerializeMedInfectionRepPos(obj)
{
	var str = "";
	if(obj == null)
		return "";
	str += CHR_Up;//obj.ParRef + CHR_Up;
	str += CHR_Up;//obj.ChildSub + CHR_Up;
	str += obj.InfPos_DR + CHR_Up;
	str += obj.InfDate + CHR_Up;
	str += obj.InfDiag_DR + CHR_Up;
	str += obj.InroadOpr + CHR_Up;
	str += obj.InfEndDate + CHR_Up;
	str += obj.InfDays + CHR_Up;
	
	//Add By LiYang 2009-09-08 
	str += obj.OprEndDate + CHR_Up;
	str += obj.OprEndTime + CHR_Up;
	str += obj.OprStartDate + CHR_Up;
	str += obj.OprStartTime + CHR_Up;
	return str;
}

function SerializeDHCMedInfectionRepDrug(obj)
{
	var str = "";
	if(obj == null)
		return "";
	str += CHR_Up;//obj.ParRef + CHR_Up;
	str += CHR_Up;//obj.ChildSub + CHR_Up;
	str += obj.OEORI_DR + CHR_Up;
	str += obj.Instr + CHR_Up;
	str += obj.DateFrom + CHR_Up;
	str += obj.DateTo + CHR_Up;
	str += obj.Days + CHR_Up;
	str += obj.Mode + CHR_Up;
	str += obj.Aim + CHR_Up;
	str += obj.CureDrugMode + CHR_Up;
	str += obj.PrevDrugMode + CHR_Up;
	str += obj.PrevDrugFlag + CHR_Up;
	str += obj.PrevDrugEffect + CHR_Up;
	str += obj.UniteDrug + CHR_Up;
	str += obj.OprDrugFlag + CHR_Up;
	str += obj.PreDrugTime + CHR_Up;
	str += obj.AftDrugDays + CHR_Up;
	str += obj.RightFlag + CHR_Up;
	str += obj.Impertinency + CHR_Up;
	str += obj.Effect + CHR_Up;
	str += obj.OEORI_DR;
	return str;	
}

function SerializeDHCMedInfPathogeny(obj)
{
	var str = "";
	if(obj == null)
		return "";
	str += CHR_Up;//obj.ParRef + CHR_Up;
	str += CHR_Up;//obj.ChildSub + CHR_Up;
	str += obj.Sample + CHR_Up;
	str += obj.InfPos_DR + CHR_Up;
	str += obj.Date + CHR_Up;
	str += obj.Method + CHR_Up;
	str += obj.DrugFlag + CHR_Up;
	str += obj.OEORI_DR + CHR_2;
	for(var i = 0; i < obj.GermArry.length; i ++)
	{
		str += 	SerializeDHCMedInfPyObj(obj.GermArry[i]) + CHR_3;
	}
	return str;		
}

function BuildDHCMedMedInfPathogen(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedMedInfPathogen();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];
	obj.Code = arry[1];
	//obj.Desc = arry[2];
	obj.Desc = arry[1]+"-"+arry[2]; //cjb 20091010
	obj.IsActive = arry[3] == "Yes";
	obj.Resume = arry[4];   //20090828 cjb ="" 
	return obj;
}

function BuildDHCMedMedAntiDic(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedMedInfPathogen();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];
	obj.Code = arry[1];
	//obj.Desc = arry[2];
	obj.Desc = arry[1]+"-"+arry[2];
	obj.IsActive = arry[3] == "Yes";
	obj.Resume = arry[4];   //20090828 cjb =""
	return obj;
}

function BuildDHCMedInfectionRepOPR(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedInfectionRepOPR();
	var arry = str.split(CHR_Up);
	obj.ParRef = GetCode(arry[0], '||');
	obj.ChildSub = GetDesc(arry[0], '||');
	obj.RowID = arry[0];
	obj.OperationDesc = arry[1];
	obj.EmerOprFlag = arry[2];
	obj.DateFrom = arry[3];
	obj.TimeFrom = arry[4];
	obj.DateTo = arry[5];
	obj.TimeTo = arry[6];
	obj.OprDocObj = BuildDoctor(arry[7],CHR_Tilted );
	obj.OprDoc = obj.OprDocObj.RowID;  //Modified By LiYang 2009-1-8
	obj.Anaesthesia = arry[8];
	obj.CuteType = arry[9];
	obj.Concrescence = arry[10];
	obj.CuteInfFlag = arry[11];
	obj.OprCuteType = arry[12];
	obj.InfectionFlag = arry[13];
	obj.OEORI_DR = arry[14];
	obj.OPICD9Map = arry[15];
	obj.OperICD9Desc = arry[16];
	obj.IsActive = arry[17];
	obj.Resume = arry[18];		
	return obj;	
}

function BuildDHCMedInfectionRepRea(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedInfectionRepRea();
	var arry = str.split(CHR_Up);
	obj.ParRef = GetCode(arry[0], "||");
	obj.ChildSub = GetDesc(arry[1], "||");
	obj.RowID = obj.ParRef + "||" + obj.ChildSub;	
	obj.InfReason = arry[1];
	return obj;	
}

function BuildDHCMedInfectionRepPos(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedInfectionRepPos();
	var arry = str.split(CHR_Up);		
	var arryTmp = arry[1].split(CHR_Tilted);
	var arryTmp1 = arry[3].split(CHR_Tilted);
	obj.ParRef = GetCode(arry[0], "||");
	obj.ChildSub = GetDesc(arry[0], "||");
	obj.RowID = arry[0];
	obj.InfPos_DR = {RowID:arryTmp[0], Code:arryTmp[1], InfPosition:arryTmp[2]};
	obj.InfDate = arry[2];
	obj.InfDiag_DR = {RowID:arryTmp1[0], DiseaseName:arryTmp1[1]};
	obj.InroadOpr = arry[4];	
	obj.InfEndDate = arry[5];  //Add by LiYang  2008-12-1
	obj.InfDays = arry[6]; //Add by LiYang  2008-12-1
	// Add By LiYang 2009-09-08 operate start/end date and time
	obj.OprEndDate = arry[7];
	obj.OprEndTime = arry[8];
	obj.OprStartDate = arry[9];
	obj.OprStartTime = arry[10];
	return obj;
}

function BuildDHCMedInfectionRepDrug(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedInfectionRepPos();
	var arry = str.split(CHR_Up);		
	obj.ParRef = GetCode(arry[0], '||');
	obj.RowID = arry[0];
	obj.ChildSub = GetDesc(arry[0], "||");
	obj.OEORI_DR = GetCode(arry[19], '/');
	obj.Instr = arry[2];
	obj.DateFrom = arry[3];
	obj.DateTo = arry[4];
	obj.Days = arry[5];
	obj.Mode = arry[6];
	obj.Aim = arry[7];
	obj.CureDrugMode = arry[8];
	obj.PrevDrugMode = arry[9];
	obj.PrevDrugFlag = arry[10];
	obj.PrevDrugEffect = arry[11];
	obj.UniteDrug = arry[12];
	obj.OprDrugFlag = arry[13];
	obj.PreDrugTime = arry[14];
	obj.AftDrugDays = arry[15];
	obj.RightFlag = arry[16];
	obj.Impertinency = arry[17];
	obj.Effect = arry[18];
	return obj;
	
}


function BuildDHCMedInfPathogeny(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedInfPathogeny();	
	var arry = str.split(CHR_Up);		
	obj.ParRef = GetCode(arry[0], '||');
	obj.RowID = arry[0];
	obj.ChildSub = GetDesc(arry[0], "||");
	obj.Sample = arry[1];
	obj.InfPos_DR = arry[2];
	obj.Date = arry[3];
	obj.Method = arry[4];
	obj.DrugFlag = arry[5];
	obj.OEORI_DR = arry[6];
	return obj;
}


function BuildDHCMedInfPyObj(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedInfPyObj();	
	var arry = str.split(CHR_Up);		
	obj.ParRef = GetCode(arry[0], '||');
	obj.RowID = arry[0];
	obj.ChildSub = GetDesc(arry[0], "||");
	obj.Object = arry[1];
	//obj.Flag = arry[2] == "Y";
	obj.Flag = arry[2];
	return obj;
}

function BuildDHCMedInfPyObjDrug(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedInfPyObjDrug();	
	var arry = str.split(CHR_Up);		
	obj.ParRef = GetCode(arry[0], '||');
	obj.RowID = arry[0];
	obj.Drug_DR = arry[1];
	obj.Flag = arry[2];
	return obj;		
} 

function BuildDHCMedInfectPosition(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedInfectPosition();	
	var arry = str.split(CHR_Up);		 
	obj.RowID = arry[0];
	obj.Code = arry[1];
	obj.InfPosition = arry[2];
	obj.Active = arry[3];
	obj.Demo = arry[4];
	return obj;
}


function SerializeDHCMedInfPyObj(obj)
{
	if(obj == null)
		return "";
	var str = "";
	str += CHR_Up;//obj.ParRef + CHR_Up;
	str += CHR_Up;//obj.ChildSub + CHR_Up;
	str += obj.Object + CHR_Up;
	//str += (obj.Flag ? "Y" : "N") + CHR_4;
	str += obj.Flag + CHR_4;
	for(var i = 0; i < obj.arryDrug.length; i ++)
	{
		str += SerializeDHCMedInfPyObjDrug(obj.arryDrug[i]) + CHR_5;
	}
	return str;
}

function SerializeDHCMedInfPyObjDrug(obj)
{
	if(obj == null)
		return "";
	var str = "";
	str += CHR_Up;//obj.ParRef + CHR_Up;
	str += CHR_Up;//obj.ChildSub + CHR_Up;
	str += obj.Drug_DR + CHR_Up;
	//str += obj.Flag ? "Y" : "N";
	str += obj.Flag;
	return str;
}

function BuildSenKabTestResult(str)
{
	if((str == "") || (str == null))
		return;
	var obj = new SenKabTestResult();
	var arry = str.split("^");
	obj.GermNme = arry[0];
	obj.AntiName = arry[1];
	obj.IsSen = arry[3];
	return obj;
}
//add by lxf 2008-10-23
//Split data string and save it to object
function BuildMedIPBKTempItem(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedIPBKTempItem();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];
	obj.ItemCode = arry[1];
	obj.ItemDesc = arry[2];
	obj.DateTypeID = arry[3];
	obj.DictionaryName =arry[4];
	obj.IsActive = (arry[5] == "Y");
	obj.ResumeText = arry[6];
	return obj;
}


//add by lxf 2008-10-23
//Get the array that contained the MedDictionary objects.
function GetDHCMedDictionaryArray(str)
{
	var objDicArray = new Array();
	var objArray = str.split(CHR_1);
	var objDic = null;
	for(var i = 0; i < objArray.length; i++)
	{
		objDic = BuildDHCMedDictionaryItem(objArray[i]);
		if(objDic != null)
		{
			objDicArray.push(objDic);
		}
	}
	return objDicArray;
}

function BuildDHCMedIPBKTemplate(str) {

    if ((str == "") || (str == null))
        return null;
    var obj = new DHCMedIPBKTemplate();
    var arry = str.split("^");
    obj.RowID = arry[0];
    obj.TempCode = arry[1];
    obj.TempDesc = arry[2];
    obj.IsActive = arry[3];
    obj.ResumeText = arry[4];
    return obj;

}


//add by lxf 2008-10-24
//Split data string and save it to object
//Table DHC_MedIPBKTemplate
function BuildMedIPBKTemplate(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedIPBKTemplate();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];
	obj.TempCode = arry[1];
	obj.TempDesc = arry[2];
	obj.IsActive = (arry[3] == "Y");
	obj.ResumeText = arry[4];
	return obj;
}
//add by lxf 2008-10-27
//RowID^TempID^ItemID^DefaultValue^IsNeed^ToolTip^ResumeText
//Table DHC_MedIPBKTempDtl
function SerializeDHCMedIPBKTempDtlList(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.RowID + CHR_Up;			
	tmp += obj.TempID + CHR_Up;		
	tmp += obj.ItemID + CHR_Up;		
	tmp += obj.DefaultValue + CHR_Up;		
	tmp += (obj.IsNeed ? "Y" : "N") + CHR_Up;	
	tmp += obj.ToolTip + CHR_Up;
	tmp += obj.ResumeText; 
	return tmp;
} 
//add by lxf 2008-10-28
//Split data string and save it to object
//Table DHC_MedIPBKTempDtl
//RowID^TempID^ItemID^DefaultValue^IsNeed^ToolTip^ResumeText
function BuildMedIPBKTempDtl(str)
{
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedIPBKTempDtl();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];
	obj.TempID = arry[1];
	obj.ItemID = arry[2];
	obj.DefaultValue = arry[3];
	obj.IsNeed = (arry[4] == "Y");
	obj.ToolTip = arry[5];
	obj.ResumeText = arry[6];
	return obj;
}
//add by lxf 2008-10-23
//Get the array that contained the MedDictionary objects.
function GetDHCMedIPBKTempItemArray(str)
{
	var objDicArray = new Array();
	var objArray = str.split(CHR_1);
	var objDic = null;
	for(var i = 0; i < objArray.length; i++)
	{
		objDic = BuildMedIPBKTempItem(objArray[i]);
		if(objDic != null)
		{
			objDicArray.push(objDic);
		}
	}
	return objDicArray;
}

//add by lxf 2008-10-23
function SerializeDHCMedDic(obj)
{//Rowid,Code,Desc,Type,Active,DateFrom,DateTo,StrA,StrB,StrC,StrD
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.Rowid + CHR_Up;
	tmp += obj.Code + CHR_Up;
	tmp += obj.Desc + CHR_Up;
	tmp += obj.Type + CHR_Up;
	tmp += (obj.Active ? "Y" : "N") + CHR_Up;
	tmp += obj.DateFrom + CHR_Up;
	tmp += obj.DateTo + CHR_Up;
	tmp += obj.StrA + CHR_Up;
	tmp += obj.StrB + CHR_Up;
	tmp += obj.StrC + CHR_Up;
	tmp += obj.StrD;
	return tmp;
}
	//add by lxf 2008-10-23
	function SerializeMedIPBKTemplate(obj)
	{	
		if(obj == null)
		{
			return "";
		}
		var tmp = "";
		tmp += obj.RowID + CHR_Up;
		tmp += obj.TempCode + CHR_Up;
		tmp += obj.TempDesc + CHR_Up;
		tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;
		tmp += obj.ResumeText;
		return tmp;
	}
	//add by lxf 2008-10-23
	function SerializeMedIPBKTempItem(obj)
	{	
		if(obj == null)
		{
			return "";
		}
		var tmp = "";
		tmp += obj.RowID + CHR_Up;
		tmp += obj.ItemCode + CHR_Up;
		tmp += obj.ItemDesc + CHR_Up;
		tmp += obj.DateTypeID + CHR_Up;
		tmp += obj.DictionaryName + CHR_Up;
		tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;
		tmp += obj.ResumeText + CHR_Up;
		return tmp;
	}
//build user information
function BuildDHCWMRUser(str) {
    if ((str == null) || (str == null))
        return null;
    //	window.alert(str);
    var obj = DHCWMRUser();
    var arry = str.split(CHR_Up);
    var arryTmp = null;
    obj.RowID = arry[0];
    obj.Code = arry[1];
    obj.UserName = arry[2];
    if (arry.length > 3) {
        arryTmp = arry[3].split(CHR_Tilted);
        obj.Location = new Object();
        obj.Location.RowID = arryTmp[0];
        obj.Location.Code = arryTmp[1];
        obj.Location.Name = arryTmp[2];
        arryTmp = arry[4].split(CHR_Tilted);
        obj.Department = new Object();
        obj.Department.RowID = arryTmp[0];
        obj.Department.Code = arryTmp[1];
        obj.Department.Name = arryTmp[2];
        arryTmp = arry[5].split(CHR_Tilted);
        obj.Group = new Object();
        obj.Group.RowID = arryTmp[0];
        obj.Group.Name = arryTmp[1];
    }
    return obj;
}



function BuildDHCMedIPBooking(str) {

    if ((str == "") || (str == null))
        return;
    var obj = new DHCMedIPBooking();
    var arry = str.split("^");
    obj.RowID = arry[0];
    obj.PatientID = arry[1];
    obj.EpisodeIDFrom = arry[2];
    obj.EpisodeIDTo = arry[3];
    obj.CreateDate = arry[4];
    obj.CreateTime = arry[5];
    obj.CreateUserID = arry[6];
    obj.CreateDocID = arry[7];
    obj.CurrentStateID = arry[8];
    obj.IsActive = arry[9];
    obj.BookingDate = arry[10];
    obj.Text1 = arry[11];
    obj.Text2 = arry[12];
    obj.Text3 = arry[13];
    obj.Text4 = arry[14];
    obj.ResumeText = arry[15];
    return obj;

}


function SerializeDHCMedIPBooking(obj) {

    if (obj == null)
        return "";
    var str = "";
    str += obj.RowID + CHR_Up;
    str += obj.PatientID + CHR_Up;
    str += obj.EpisodeIDFrom + CHR_Up;
    str += obj.EpisodeIDTo + CHR_Up;
    str += obj.CreateDate + CHR_Up;
    str += obj.CreateTime + CHR_Up;
    str += obj.CreateUserID + CHR_Up;
    str += obj.CreateDocID + CHR_Up;
    str += obj.CurrentStateID + CHR_Up;
    str += obj.IsActive + CHR_Up;
    str += obj.BookingDate + CHR_Up;
    str += obj.Text1 + CHR_Up;
    str += obj.Text2 + CHR_Up;
    str += obj.Text3 + CHR_Up;
    str += obj.Text4 + CHR_Up;
    str += obj.ResumeText
    return str;

}



function BuildDHCMedIPBKState(str) {

    if ((str == "") || (str == null))
        return;
    var obj = new DHCMedIPBooking();
    var arry = str.split("^");
    obj.RowID = arry[0];
    obj.BookID = arry[1];
    obj.StateID = arry[2];
    obj.ChangeUserID = arry[3];
    obj.ChangeDate = arry[4];
    obj.ChangeTime = arry[5];
    obj.ReasonID = arry[6];
    obj.ResumeText = arry[7];
    return obj;

}


function SerializeDHCMedIPBKState(obj) {

    if (obj == null)
        return "";
    var str = "";
    str += obj.RowID + CHR_Up;
    str += obj.BookID + CHR_Up;
    str += obj.StateID + CHR_Up;
    str += obj.ChangeUserID + CHR_Up;
    str += obj.ChangeDate + CHR_Up;
    str += obj.ChangeTime + CHR_Up;
    str += obj.ReasonID + CHR_Up; 
    str += obj.ResumeText;
    return str;

}


function BuildDHCMedIPBKDetail(str) {

    if ((str == "") || (str == null))
        return;
    var obj = new DHCMedIPBooking();
    var arry = str.split("^");
    obj.RowID = arry[0];
    obj.BookID = arry[1];
    obj.ItemID = arry[2];
    obj.ItemValue = arry[3];
    return obj;

}


function SerializeDHCMedIPBKDetail(obj) {

    if (obj == null)
        return "";
    var str = "";
    str += obj.RowID + CHR_Up;
    str += obj.BookID + CHR_Up;
    str += obj.ItemID + CHR_Up; 
    str += obj.ItemValue
    return str;

}

function BuildDHCMedIPBKTemplate(str) {

    if ((str == "") || (str == null))
        return null;
    var obj = new DHCMedIPBKTemplate();
    var arry = str.split("^");
    obj.RowID = arry[0];
    obj.TempCode = arry[1];
    obj.TempDesc = arry[2];
    obj.IsActive = arry[3];
    obj.ResumeText = arry[4];
    return obj;

}

//build user information
function BuildDHCWMRUser(str) {
    if ((str == null) || (str == null))
        return null;
    //	window.alert(str);
    var obj = DHCWMRUser();
    var arry = str.split(CHR_Up);
    var arryTmp = null;
    obj.RowID = arry[0];
    obj.Code = arry[1];
    obj.UserName = arry[2];
    if (arry.length > 3) {
        arryTmp = arry[3].split(CHR_Tilted);
        obj.Location = new Object();
        obj.Location.RowID = arryTmp[0];
        obj.Location.Code = arryTmp[1];
        obj.Location.Name = arryTmp[2];
        arryTmp = arry[4].split(CHR_Tilted);
        obj.Department = new Object();
        obj.Department.RowID = arryTmp[0];
        obj.Department.Code = arryTmp[1];
        obj.Department.Name = arryTmp[2];
        arryTmp = arry[5].split(CHR_Tilted);
        obj.Group = new Object();
        obj.Group.RowID = arryTmp[0];
        obj.Group.Name = arryTmp[1];
    }
    return obj;
}


function BuildDHCMedDepartment(str) { 
    if ((str == "") || (str == null))
        return null;
    var obj = DHCMedDepartment();
    var arry = str.split(CHR_2);
    obj.RowID = arry[0];
    obj.Department = arry[1];
    return obj;
}

function BuildDHCMedWard(str) {
    if ((str == "") || (str == null))
        return null;
    var obj = DHCMedDepartment();
    var arry = str.split(CHR_Up);
    obj.RowID = arry[0];
    obj.Department = arry[1];
    return obj;
}

function BuildDHCMedBed(str) {
    if ((str == "") || (str == null))
        return null;
    var obj = DHCMedBed();
    var arry = str.split(CHR_Up);
    obj.RowID = arry[0];
    obj.Desc = arry[1];
    return obj;
}