/* ======================================================================
JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1
NAME: DHC.WMR.Serialize
AUTHOR: LiYang , Microsoft
DATE  : 2007-3-9
========================================================================= */
var CHR_1=String.fromCharCode(1);
var CHR_2=String.fromCharCode(2);
var CHR_3=String.fromCharCode(3);
var CHR_Up="^";
var CHR_Tilted="/";
var appletFieldSplit = "<field>";
var appletRowSplit = "<row>";


function BuildDHCWMRDictionary(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRDictionary();
	obj.RowID = arry[0];
	obj.DictionaryName = arry[1];
	obj.Code = arry[2];
	obj.Description = arry[3];
	obj.FromDate = arry[4];
	obj.ToDate = arry[5];
	obj.TextA = arry[6];
	obj.TextB = arry[7];
	obj.TextC = arry[8];
	obj.TextD = arry[9];
	obj.IsActive = (arry[10] == "Y");
	obj.ResumeText = arry[11];
	return obj;
}



function GetDHCWMRDictionaryArray(str)
{
	var objDicArry = new Array();
	var objArry = str.split(CHR_1);
	var objDic = null;
	for(var i = 0; i < objArry.length; i ++)
	{
		objDic = BuildDHCWMRDictionary(objArry[i]);
		if(objDic != null)
		{
			objDicArry.push(objDic);
		}
	}
	return objDicArry;
}



function SerializeDHCWMRDictionary(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.RowID + CHR_Up;
	tmp += obj.DictionaryName + CHR_Up;
	tmp += obj.Code + CHR_Up;
	tmp += obj.Description + CHR_Up;
	tmp += obj.FromDate + CHR_Up;
	tmp += obj.ToDate + CHR_Up;
	tmp += obj.TextA + CHR_Up;
	tmp += obj.TextB + CHR_Up;
	tmp += obj.TextC + CHR_Up;
	tmp += obj.TextD + CHR_Up;
	tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;
	tmp += obj.ResumeText;
	return tmp;
	
}
//*********************************************************************************


function BuildDHCWMRWorkItem(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split("^");
	var obj = DHCWMRWorkItem();
	obj.RowID = arry[0];						//	DHC_WMR_WorkItem RowID
	obj.ItemType = arry[1];						//	
	obj.Description =arry[2];					//	
	obj.IsActive = (arry[3] == "Y");			//	
	obj.Resume = arry[4];
	obj.SysOper_Dr = arry[5];					//
	obj.CheckUser = (arry[6] == "Y");			//
	obj.BeRequest = (arry[7] == "Y");
	return obj;
}



function SerialzieDHCWMRWorkItem(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = new String();
	tmp += obj.RowID + CHR_Up;
	tmp += obj.ItemType + CHR_Up;
	tmp += obj.Description + CHR_Up;
	tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;
	tmp += obj.Resume + CHR_Up;
	tmp += obj.SysOper_Dr + CHR_Up;
	tmp += (obj.CheckUser ? "Y" : "N")+ CHR_Up;
	tmp += (obj.BeRequest ? "Y" : "N");
	return tmp;
}

//**************************************************************************

function BuildDHCWMRWorkItemRule(str)
{
	if((str == null) || (str == ""))
	{
		return ;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRWorkItemRule();
	obj.Parref = GetCode(arry[0]);				//	DHC_WMR_WorkItem Parent Reference
	obj.ChildSub = GetDesc(arry[0]);			//	DHC_WMR_WorkItemRule RowID
	obj.RowID = arry[0];						//	DHC_WMR_WorkItemRule RowID
	obj.Description = arry[1];					//	
	obj.IsActive = (arry[2] == "Y");			//	
	obj.Resume = arry[3];						//	
	return obj;
}

function SerializeDHCWMRWorkItemRule(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.Parref + CHR_Up;		//	DHC_WMR_WorkItem Parent Reference
	tmp += obj.ChildSub + CHR_Up;		//	Childsubscript
	tmp += obj.Description + CHR_Up;	//	
	tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;		//	
	tmp += obj.Resume;		//	
	return tmp;
}

//********************************************

function BuildDHCWMRWorkDetail(str)
{
	var obj = DHCWMRWorkDetail();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];				//	DHC_WMR_WorkDetail RowID
	obj.Code = arry[1];					//	
	obj.Description = arry[2];			//	
	obj.DataType = arry[3];				//	
	obj.IsActive = (arry[4] == "Y");				//	
	obj.Resume = arry[5];				//	
	obj.DictionaryCode = arry[6];
	return obj;
}

function SerialDHCWMRWorkDetail(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.RowID + CHR_Up;					//	DHC_WMR_WorkDetail RowID
	tmp += obj.Code + CHR_Up;					//	
	tmp += obj.Description + CHR_Up;			//	
	tmp += obj.DataType + CHR_Up;				//	
	tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;				//	
	tmp += obj.Resume + CHR_Up;					//	
	tmp += obj.DictionaryCode;
	return tmp;
}



function GetDHCWMRWorkDetailArray(str)
{
	var objDicArry = new Array();
	var objArry = str.split(CHR_1);
	var objDic = null;
	for(var i = 0; i < objArry.length; i ++)
	{
		objDic = BuildDHCWMRWorkDetail(objArry[i]);
		if(objDic != null)
		{
			objDicArry.push(objDic);
		}
	}
	return objDicArry;
}

//****************************************************************



function BuildDHCWMRWorkItemList(str)
{
	if(str == "")
	{
		return;
	}
	var obj = DHCWMRWorkItemList();
	var arry = str.split(CHR_Up);
	if(arry.length < 6)
	{
		return;
	}
	obj.Parref = GetCode(arry[0], "||");			//	DHC_WMR_WorkItem Parent Reference
	obj.Rowid = arry[0];					//	DHC_WMR_WorkItemList RowID
	obj.ChildSub = GetDesc(arry[0], "||");		//	Childsubscript
	obj.DetailDr = arry[1];				//	
	obj.ListIndex = arry[2];				//	
	obj.IsActive = (arry[3] == "Y");		//	
	obj.IsNeed = (arry[4] == "Y");			//	
	obj.Resume = arry[5];					//	
	obj.DefaultValue = arry[6];  //  
// 	window.alert(str);
	return obj;
}


function SerializeDHCWMRWorkItemList(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.Parref + CHR_Up;				//	DHC_WMR_WorkItem Parent Reference
	tmp += obj.ChildSub + CHR_Up;			//	Childsubscript
	tmp += obj.DetailDr + CHR_Up;			//	
	tmp += obj.ListIndex + CHR_Up;			//	
	tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;			//	
	tmp += (obj.IsNeed ? "Y" : "N")  + CHR_Up;			//	
	tmp += obj.Resume + CHR_Up;				//  
	tmp += obj.DefaultValue;  //  
	return tmp;
} 


//******************************************
//build main information
//******************************************
function BuildDHCWMRMain(str)
{
	
	if((str == "") || (str == null))
	{
		return null;
	}
	var obj = new Object();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];				//	DHC_WMR_MainRowID
	obj.MrType = arry[1];			//		
	obj.MRNO =arry[2];				//		
	obj.Papmi_Dr = arry[3];			//		
	obj.History_DR = arry[4];		//		
	obj.IsDead = (arry[5] == "Y");			//		
	obj.IsActive = (arry[6] == "Y");			//		
	obj.IsStayIn = (arry[7] == "Y");			//		
	obj.BuildDate = arry[8];			//		
	obj.ResumeText = arry[9];		//		
	return obj;
}

function SerializeDHCWMRMain(obj)
{
	var tmp = "" ;
	if(obj == null)
	{
		return "";
	}
	tmp += obj.RowID + CHR_Up;				//	DHC_WMR_MainRowID
	tmp += obj.MrType + CHR_Up;			//		
	tmp += obj.MRNO + CHR_Up;				//		
	tmp += obj.Papmi_Dr  + CHR_Up;			//		
	tmp += obj.History_DR + CHR_Up;		//		
	tmp += (obj.IsDead ? "Y" : "N") + CHR_Up;			//		
	tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;			//		
	tmp += (obj.IsStayIn ? "Y" : "N") + CHR_Up;			//		
	tmp += obj.BuildDate + CHR_Up;			//		
	tmp += obj.ResumeText;		//		
	return tmp;
}

//*********************************************
//build history information
//*********************************************
function buildDHCWMRHistory(str)
{
	if(str == "")
	{
		return null;
	}
	var obj = new Object();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];					//	DHC_WMR_History RowID
	obj.PatientName = arry[1];			//	
	obj.NameSpell = arry[2];				//	
	obj.Sex = arry[3];					//	
	obj.Birthday = arry[4];				//	
	obj.Age = arry[5];					//	
	obj.Wedlock = arry[6];				//	
	obj.Occupation = arry[7];			//	
	obj.City = arry[8];					//	
	obj.County = arry[9];				//	
	obj.Nation = arry[10];				//	
	obj.Nationality = arry[11];			//	
	obj.IdentityCode = arry[12];			//	
	obj.Company = arry[13];				//	
	obj.CompanyTel = arry[14];			//	
	obj.CompanyZip = arry[15];			//	
	obj.HomeAddress = arry[16];			//	
	obj.HomeTel = arry[17];				//	
	obj.HomeZip = arry[18];				//	
	obj.RelationDesc = arry[19];			//	
	obj.RelativeName = arry[20];			//	
	obj.RelativeTel = arry[21];			//	
	obj.RelativeAddress = arry[22];		//	
	obj.IsActive = arry[23];				//	
	obj.ResumeText = arry[24];			//	
	return obj;
}

function SerializeDHCWMRHistory(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.RowID + CHR_Up;					//	DHC_WMR_History RowID
	tmp += obj.PatientName + CHR_Up;			//	
	tmp += obj.NameSpell + CHR_Up;				//	
	tmp += obj.Sex + CHR_Up;					//	
	tmp += obj.Birthday + CHR_Up;				//	
	tmp += obj.Age + CHR_Up;					//	
	tmp += obj.Wedlock + CHR_Up;				//	
	tmp += obj.Occupation + CHR_Up;			//	
	tmp += obj.City + CHR_Up;					//	
	tmp += obj.County + CHR_Up;				//	
	tmp += obj.Nation + CHR_Up;				//	
	tmp += obj.Nationality + CHR_Up;			//	
	tmp += obj.IdentityCode + CHR_Up;			//	
	tmp += obj.Company + CHR_Up;				//	
	tmp += obj.CompanyTel + CHR_Up;			//	
	tmp += obj.CompanyZip + CHR_Up;			//	
	tmp += obj.HomeAddress + CHR_Up;			//	
	tmp += obj.HomeTel + CHR_Up;				//	
	tmp += obj.HomeZip + CHR_Up;				//	
	tmp += obj.RelationDesc + CHR_Up;			//	
	tmp += obj.RelativeName + CHR_Up;			//	
	tmp += obj.RelativeTel + CHR_Up;			//	
	tmp += obj.RelativeAddress + CHR_Up;		//	
	tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;				//	
	tmp += obj.ResumeText;			//	
	return tmp;
}

//build patient adm information
function BuildDHCWMRAdmInfo(str)
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

//build history adm
function BuildDHCWMRHistoryAdm(str)
{
	if(str == "")
		return null;
	var arry = str.split(CHR_Up);
	var obj = DHCWMRHistoryAdm();
	obj.RowID = arry[0]; 				//	DHC_WMR_HistoryAdm RowID
	obj.History_Dr = arry[1]; 			//	
	obj.AdmitDate = arry[2]; 			//	
	obj.AdmitTime = arry[3]; 			//	
	obj.AdmitDep = arry[4]; 				//	
	obj.AdmitStatus = arry[5]; 			//	
	obj.DischargeDate = arry[6]; 		//	
	obj.DischargeTime = arry[7]; 		//	
	obj.DischargeDep = arry[8]; 			//	
	obj.Diagnose = arry[9]; 				//	
	obj.IsActive = (arry[10] == "Y"); 				//	
	obj.ResumeText = arry[11]; 			//	
	return obj;
}

function SerializeDHCWMRHistoryAdm(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.RowID + CHR_Up; 				//	DHC_WMR_HistoryAdm RowID
	tmp += obj.History_Dr + CHR_Up; 			//	
	tmp += obj.AdmitDate + CHR_Up; 			//	
	tmp += obj.AdmitTime + CHR_Up; 			//	
	tmp += obj.AdmitDep + CHR_Up; 				//	
	tmp += obj.AdmitStatus + CHR_Up; 			//	
	tmp += obj.DischargeDate + CHR_Up; 		//	
	tmp += obj.DischargeTime + CHR_Up; 		//	
	tmp += obj.DischargeDep + CHR_Up; 			//	
	tmp += obj.Diagnose + CHR_Up; 				//	
	tmp += obj.IsActive + CHR_Up; 				//	
	tmp += obj.ResumeText; 			//	
	return tmp;
}



//build workflow
function BuildDHCWMRWorkFlow(str)
{
	if((str == null) || (str == ""))
	{
		return;
	}
	var obj = DHCWMRWorkFlow();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];		//	DHC_WMR_WorkFlow RowID
	obj.MrType = arry[1];		//	
	obj.Description = arry[2];		//	
	obj.IsActive = arry[3];		//	
	obj.DateFrom = arry[4];		//	
	obj.DateTo = arry[5];		//	
	obj.Resume = arry[6];		//	
	return obj;
}

function SerializeDHCWMRWorkFlow()
{
	window.alert("No Code!!!!!!!");
}

//build volume main information
function BuildDHCWMRMainVolume(str)
{
	if(str == "")
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var tmp = null;
	var obj = DHCWMRMainVolume();
	obj.RowID = arry[0];						//DHC_WMR_MainVolume RowID
	obj.Main_Dr = arry[1];						//DHC_WMR_Main
	obj.Paadm_Dr = arry[2];						//
	obj.HistroyAdm_Dr = arry[3];				//
	obj.IsReprography = (arry[4] == "Y");		//
	obj.IsSeal = (arry[5] == "Y");				//
	obj.Status_Dr = arry[6];			//
	obj.IsActive = (arry[7] == "Y");		//
	obj.InFlow = (arry[8] == "Y");			//
	obj.ResumeText = arry[9];		//
	return obj;
}

function SerializeDHCWMRMainVolume(obj)
{
	if(obj == null)
	{
		return null;
	}
	var tmp = "";
	tmp += obj.RowID + CHR_Up;				//	DHC_WMR_Main Parent Reference
	tmp += obj.Main_Dr + CHR_Up;			//	Childsubscript
	tmp += obj.Paadm_Dr + CHR_Up;			//	
	tmp += obj.HistroyAdm_Dr + CHR_Up;	//	
	tmp += obj.IsReprography + CHR_Up;	//	
	tmp += (obj.IsSeal ? "Y" : "N") + CHR_Up;				//	
	tmp += obj.Status_Dr + CHR_Up;				//	
	tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;			//	
	tmp += (obj.InFlow ? "Y" : "N") + CHR_Up;				//	
	tmp += obj.ResumeText;		//	
	return tmp;
}

//build volume information
function BuildDHCWMRVolInfo(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var obj = DHCWMRVolInfo();
	var arry = str.split(CHR_Up)
	obj.RowID = arry[0];								//	DHC_WMR_VolInfo RowID
	obj.PatientName = arry[1];					//	
	obj.NameSpell = arry[2];						//	
	obj.Sex = arry[3];							//	
	obj.Birthday = arry[4];						//	
	obj.Age = arry[5];									//	
	obj.Wedlock = arry[6];							//	
	obj.Occupation = arry[7];					//	
	obj.City = arry[8];								//	
	obj.County = arry[9];							//	
	obj.Nation = arry[10];							//	
	obj.Nationality = arry[11];					//	
	obj.IdentityCode = arry[12];				//	
	obj.Company = arry[13];							//	
	obj.CompanyTel = arry[14];					//	
	obj.CompanyZip = arry[15];					//	
	obj.HomeAddress = arry[16];					//	
	obj.HomeTel = arry[17];							//	
	obj.HomeZip = arry[18];							//	
	obj.RelationDesc = arry[19];				//	
	obj.RelativeName = arry[20];				//	
	obj.RelativeTel = arry[21];					//	
	obj.RelativeAddress = arry[22];				//	
	obj.IsActive = arry[23];				 //	
	obj.ResumeText = arry[24];					//	
	obj.Volume_Dr = arry[25];						//	
	return obj;
}

function SerializeDHCWMRVolInfo(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.RowID + CHR_Up;								//	DHC_WMR_VolInfo RowID
	tmp += obj.PatientName + CHR_Up;					//	
	tmp += obj.NameSpell + CHR_Up;						//	
	tmp += obj.Sex + CHR_Up;							//	
	tmp += obj.Birthday + CHR_Up;						//	
	tmp += obj.Age + CHR_Up;									//	
	tmp += obj.Wedlock + CHR_Up;							//	
	tmp += obj.Occupation + CHR_Up;					//	
	tmp += obj.City + CHR_Up;								//	
	tmp += obj.County + CHR_Up;							//	
	tmp += obj.Nation + CHR_Up;							//	
	tmp += obj.Nationality + CHR_Up;					//	
	tmp += obj.IdentityCode + CHR_Up;				//	
	tmp += obj.Company + CHR_Up;							//	
	tmp += obj.CompanyTel + CHR_Up;					//	
	tmp += obj.CompanyZip + CHR_Up;					//	
	tmp += obj.HomeAddress + CHR_Up;					//	
	tmp += obj.HomeTel + CHR_Up;							//	
	tmp += obj.HomeZip + CHR_Up;							//	
	tmp += obj.RelationDesc + CHR_Up;				//	
	tmp += obj.RelativeName + CHR_Up;				//	
	tmp += obj.RelativeTel + CHR_Up;					//	
	tmp += obj.RelativeAddress + CHR_Up;				//	
	tmp += (obj.IsActive ? "Y" : "N") + CHR_Up;				 //	
	tmp += obj.ResumeText + CHR_Up;					//	
	tmp += obj.Volume_Dr;						//	
	return tmp;
}
//build volume paadm information
function BuildDHCWMRVolAdm(str)
{
	if((str == "") || (str == null))
	{
		return;
	}
	var arry = str.split(CHR_Up);
	obj.Perref = GetCode(arry[0]);		//	DHC_WMR_MainVolume Parent Reference
	obj.Rowid = arry[0];			//	DHC_WMR_VolAdm RowID
	obj.ChildSub = arry[0];		//	Childsubscript
	obj.Paadm_Dr = arry[0];		//	Paadm_Dr
}

function SerializeDHCWMRVolAdm(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.Perref + CHR_Up;		//	DHC_WMR_MainVolume Parent Reference
	tmp += obj.ChildSub + CHR_Up;		//	Childsubscript
	tmp += obj.Paadm_Dr;		//	Paadm_Dr
	return tmp;
}

//build volume status
function BuildDHCWMRVolStatus(str)
{
	if((str == "") || (str == null))
	{
		return;
	}
	var obj = DHCWMRVolStatus();
	var arry = str.split(CHR_Up);
	obj.Parref = GetCode(arry[0], "||");		//	DHC_WMR_MainVolume Parent Reference
	obj.Rowid = arry[0];			//	DHC_WMR_VolStatus RowID
	obj.ChildSub = GetDesc(arry[0], "||");		//	Childsubscript
	obj.Status_Dr = arry[1];		//	
	obj.UserFromDr = arry[2];	//	
	obj.CurrDate = arry[3];		//	
	obj.CurrTime = arry[4];		//	
	obj.UserToDr = arry[5];		//	
	return obj;
}

function SerializeDHCWMRVolStatus(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.Parref + CHR_Up;		//	DHC_WMR_MainVolume Parent Reference
	tmp += obj.ChildSub + CHR_Up;		//	Childsubscript
	tmp += obj.Status_Dr + CHR_Up;		//	
	tmp += obj.UserFromDr + CHR_Up;	//	
	tmp += obj.CurrDate + CHR_Up;		//	
	tmp += obj.CurrTime + CHR_Up;		//	
	tmp += obj.UserToDr;		//	
	return tmp;
}

//build volume status detail
/*function BuildDHCWMRVolStatusDtl(str)
{
	if((str == "") || (str == null))
	{
		return;
	}
	var arry = str.split(CHR_Up);
	obj.Parref = GetCode(arry[0], "||");		//	DHC_WMR_VolStatus Parent Reference
	obj.Rowid = arry[0];			//	DHC_WMR_VolStatusDtl RowID
	obj.ChildSub = GetDesc(arry[0]);		//	Childsubscript
	obj.Detail_Dr = arry[1];		//	
	obj.ItemValue = arry[2];		//	
	obj.Resume = arry[3];		//	
	return obj;
}*/

/*function SerializeDHCWMRVolStatusDtl(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.Parref + CHR_Up;		//	DHC_WMR_MainStatus Parent Reference
	tmp += obj.ChildSub + CHR_Up;		//	Childsubscript
	tmp += obj.Detail_Dr + CHR_Up;		//	
	tmp += obj.ItemValue + CHR_Up;		//	
	tmp += obj.Resume;		//	
	return tmp;
}*/
//build patient information 
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

//build workflowsub
function BuildDHCWMRFlowSub(str)
{
	if((str == "") || (str == null))
	{
		return;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRWorkFlowSub();
	obj.Parref = GetCode(arry[0], "||"); 		//	DHC_WMR_WorkFlow Parent Reference
	obj.RowID = arry[0]; 		//	DHC_WMR_WorkFlowSub RowID
	obj.ChildSub = GetDesc(arry[0]); 		//	Childsubscript
	obj.IndexNo = arry[1]; 		//	
	obj.Item_Dr = arry[2]; 		//	

	return obj;
}

function SerializeDHCWMRFlowSub(obj)
{
	if(obj == null)
	{
		return "";
	}
	var tmp = "";
	tmp += obj.Parref + "||"; 		//	DHC_WMR_WorkFlow Parent Reference
	tmp += obj.RowID + CHR_Up; 		//	DHC_WMR_WorkFlowSub RowID
	tmp += obj.ChildSub + CHR_Up; 		//	Childsubscript
	tmp += obj.IndexNo + CHR_Up; 		//	
	tmp += obj.Item_Dr; 		//	
	return tmp;
}

//build workitem Array
function GetDHCWMRWorkItemArray(str)
{
	var objArry = new Array();
	var objStrArry = str.split(CHR_1);
	var obj = null;
	for(var i = 0; i < objStrArry.length; i ++)
	{
		obj = BuildDHCWMRWorkItem(objStrArry[i]);
		if(obj != null)
		{
			objArry.push(obj);
		}
	}
	return objArry;
}

//build DHCWMRMainStatusDtl
function BuildDHCWMRMainStatusDtl(str)
{
	if((str == "") || (str == null))
	{
		return;
	}
	var obj = DHCWMRMainStatusDtl();
	var arry = str.split(CHR_Up);
	obj.Parref = GetCode(arry[0], "||");	//	DHC_WMR_Main Parent Reference
	obj.Rowid = arry[0];					//	DHC_WMR_MainStatus RowID
	obj.ChildSub = GetDesc(arry[0], "||");	//	Childsubscript
	obj.Detail_Dr = arry[1];				//	
	obj.ItemValue = arry[2];				//	
	obj.Resume = arry[3];					//	
	obj.WorkItemList_Dr = arry[4];			//	
	return obj;
}

//build DHCWMRVolStatusDtl
/*function BuildDHCWMRVolStatusDtl(str)
{
	if((str == "") || (str == null))
	{
		return;
	}
	var obj = DHCWMRVolStatusDtl();
	var arry = str.split(CHR_Up);
	obj.Parref = GetCode(arry[0], "||");	//	DHC_WMR_VolStatus Parent Reference
	obj.Rowid = arry[0];					//	DHC_WMR_VolStatusDtl RowID
	obj.ChildSub = GetDesc(arry[0], "||");	//	Childsubscript
	obj.Detail_Dr = arry[1];				//	
	obj.ItemValue = arry[2];				//	
	obj.Resume = arry[3];					//	
	obj.WorkItemList_Dr = arry[4];			//	
	return obj;
}*/

//Get DHCWMRMainStatusDtl String
function SerializeDHCWMRMainStatusDtl(obj)
{
	if(obj == null)
		return "";
	var tmp = "";
	tmp += obj.Parref + CHR_Up;		//	DHC_WMR_MainStatus Parent Reference
	tmp += obj.ChildSub + CHR_Up;		//		Childsubscript
	tmp += obj.Detail_Dr + CHR_Up;		//		
	tmp += obj.ItemValue + CHR_Up;		//		
	tmp += obj.Resume + CHR_Up;			//		
	tmp += obj.WorkItemList_Dr;			//	
	return tmp;
}


//Get DHCWMRVolStatusDtl String
function SerializeDHCWMRVolStatusDtl(obj)
{
	if(obj == null)
		return "";
	var tmp = "";
	tmp += obj.Parref + CHR_Up;			//	DHC_WMR_MainStatus Parent Reference
	tmp += obj.ChildSub + CHR_Up;		//		Childsubscript
	tmp += obj.Detail_Dr + CHR_Up;		//		
	tmp += obj.ItemValue + CHR_Up;		//		
	tmp += obj.Resume + CHR_Up;			//		
	tmp += obj.WorkItemList_Dr;			//	
	return tmp;
}

//build DHCWMRMainStatus
function  BuildDHCWMRMainStatus(str)
{
	if((str == "") || (str == null))
	{
		return;
	}
	var obj = DHCWMRMainStatus();
	var arry = str.split(CHR_Up);
	obj.Parref = GetCode(arry[0], "||");		//	DHC_WMR_Main Parent Reference
	obj.Rowid = arry[0];						//	DHC_WMR_MainStatus RowID
	obj.ChildSub = GetDesc(arry[0], "||");		//	Childsubscript
	obj.Status_Dr = arry[1];					//	
	obj.UserFromDr = arry[2];					//	
	obj.CurrDate = arry[3];						//	
	obj.CurrTime = arry[4];						//	
	obj.UserToDr = arry[5];						//	
	return obj;
}

//build DHCWMRVolStatusDtl
function  BuildDHCWMRVolStatusDtl(str)
{
	if((str == "") || (str == null))
	{
		return;
	}
	var obj = DHCWMRVolStatusDtl();
	var arry = str.split(CHR_Up);
	obj.Parref = GetCode(arry[0], "||");		//	DHC_WMR_MainVolume Parent Reference
	obj.Rowid = arry[0];						//	DHC_WMR_VolStatus RowID
	obj.ChildSub = GetDesc(arry[0], "||");		//	Childsubscript
	obj.Status_Dr = arry[1];					//	
	obj.UserFromDr = arry[2];					//	
	obj.CurrDate = arry[3];						//	
	obj.CurrTime = arry[4];						//	
	obj.UserToDr = arry[5];						//	
	return obj;
}
/*//Get DHCWMRVolStatusDtl string
function SerializeDHCWMRVolStatusDtl(obj)
{
	if(obj == null)
		return "";
	var tmp = "";
	tmp += Parref + CHR_Up;			//	DHC_WMR_MainVolume Parent Reference
	tmp += ChildSub + CHR_Up;		//	Childsubscript
	tmp += Status_Dr + CHR_Up;		//	
	tmp += UserFrom_Dr + CHR_Up;	//	
	tmp += CurrDate + CHR_Up;		//	
	tmp += CurrTime + CHR_Up;		//	
	tmp += UserTo_Dr + CHR_Up;		//	
	return tmp;
}*/
//Get DHCWMRMainStatus String
function SerializeDHCWMRMainStatus(obj)
{
	if(obj == null)
		return "";
	var tmp = "";
	tmp += obj.Parref + CHR_Up;			//	DHC_WMR_MainVolume Parent Reference
	tmp += obj.ChildSub + CHR_Up;		//	Childsubscript
	tmp += obj.Status_Dr + CHR_Up;		//	
	tmp += obj.UserFromDr + CHR_Up;	//	
	tmp += obj.CurrDate + CHR_Up;		//	
	tmp += obj.CurrTime + CHR_Up;		//	
	tmp += obj.UserToDr + CHR_Up;		//	
	return tmp;
}

//Get DHCWMRVolStatusDtl string  separate by $c(1)
function SerializeDHCWMRVolStatusDtlArry(arry)
{
	if(arry.length == 0)
	{
		return "";
	}
	var tmp = "";
	for(var i = 0; i < arry.length; i ++)
	{
		tmp += SerializeDHCWMRVolStatusDtl(arry[i]) + (i == (arry.length - 1) ? "" : CHR_1);
	}
	return tmp;
}

//Get DHCWMRMainStatusDtl string  separate by $c(1)
function SerializeDHCWMRMainStatusDtlArry(arry)
{
	if(arry.length == 0)
	{
		return "";
	}
	var tmp = "";
	for(var i = 0; i < arry.length; i ++)
	{
		tmp += SerializeDHCWMRMainStatusDtl(arry[i]) + (i == (arry.length - 1) ? "" : CHR_1);
	}
	return tmp;
}

//build user information
function BuildDHCWMRUser(str)
{
	if((str == null) || (str == null))
		return null;
	//	window.alert(str);
	var obj = DHCWMRUser();
	var arry = str.split(CHR_Up);
	var arryTmp = null;
	obj.RowID = arry[0];
	obj.Code = arry[1];
	obj.UserName = arry[2];
	if(arry.length > 3)
	{
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

//build voluem list
function BuildDHCWMRMainVolumeArry(str)
{
	if((str == "") || (str == null))
		return null;
	var objTmp = str.split(CHR_2);
	var objArry = new Array();
	var obj = null;
	for(var i = 0; i < objTmp.length; i ++)
	{
		obj = BuildDHCWMRMainVolume(objTmp[i]);
		if(obj != null)
			objArry.push(obj);
	}
	return objArry;
}

//discharge patient list
function BuildDHCWMRDischargeListItem(str)
{
	if((str == "") || (str == null))
		return null;
	var objArry = str.split(CHR_Up);
	var obj = DHCWMRDischargeListItem();
	obj.WardDesc = objArry[0];
	obj.DischargeDate = objArry[1];
	obj.PatientNo = objArry[2];
	obj.PatientName = objArry[3];
	obj.MedicalRecordNo = objArry[4];
	return obj;
}

function BuildDHCWMRDischargeListItemArry(str)
{
	if((str == "") || (str == null))
		return new Array();
	var objArry = str.split(CHR_1);
	var objObjArry = new Array();
	var obj = null;
	for(var i = 0; i < objArry.length; i ++)
	{
		obj = BuildDHCWMRDischargeListItem(objArry[i]);
		if(obj != null)
			objObjArry.push(obj);
	}
	return objObjArry;
}


//History volume
function SerializeHistoryVol(obj)
{
    if(obj == null)
        return "";
    //update by zf 2008-07-15
    //var str = "";  
    var str = obj.VolId + CHR_Up;	//
    str += obj.IPNum + CHR_Up;          //
    str += obj.AdmitDate + CHR_Up;	//
    str += obj.AdmitTime + CHR_Up;	//
    str += obj.AdmitDep + CHR_Up;	//
    str += obj.AdmitStatus + CHR_Up;	//
    str += obj.DischargeDate + CHR_Up;	//
    str += obj.DischargeTime + CHR_Up;	//
    str += obj.DischargeDep + CHR_Up;	//
    str +=  obj.Diagnose;	//
   return str; 
}


function SerializeHistoryVolArry(objArry)
{
    var str = "";
   for(var i = 0; i < objArry.length; i ++)
  {
    str += SerializeHistoryVol(objArry[i]) + CHR_1;
  }  
  return str;
}








function BuildDHCWMRRuleDic(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRRuleDic();
	obj.RowID = arry[0];//	DHC_WMR_RuleDic
    obj.Code = arry[1];//	
    obj.Title = arry[2];//	
    obj.RuleTypeDr = arry[3];//	
    obj.IsActive = (arry[4] == "Y");//	
    obj.ResumeText = arry[5];//	
	return obj;
}

function BuildDHCWMRSectionDic(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRSectionDic();
	obj.RowID = arry[0];//	DHC_WMR_SectionDic
	obj.Code = arry[1];//	
	obj.Title = arry[2];//	
	obj.SectionTypeDr = arry[3];//	
	obj.IsActive = (arry[4] == "Y");//	
	obj.ResumeText = arry[5];//	
	return obj;
}
function BuildDHCWMREntryDic(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMREntryDic();
	obj.RowID = arry[0];// 	DHC_WMR_EntryDic
    obj.Code = arry[1];//	
    obj.Title = arry[2];//	
    obj.EntryTypeDr = arry[3];//	
    obj.IsActive = (arry[4] == "Y");//	
    obj.ResumeText = arry[5];//	
	return obj;
}
function BuildDHCWMRExamRule(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRExamRule();
    obj.RowID = arry[0];//	DHC_WMR_ExamRule
    obj.RuleDr = arry[1];//	
    obj.MaxScore = arry[2];//	
    obj.PassingScore = arry[3];//	
    obj.DeductLine = arry[4];//	
    obj.MonyPerPoint = arry[5];//	
    obj.Punishment = arry[6];//	
    obj.ScoreMethod = arry[7];//	
    obj.IsActive = (arry[8] == "Y");//	
    obj.ResumeText = arry[9];//	
	return obj;
}

function BuildDHCWMRExamSection(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRExamSection();
    obj.Parref = GetCode(arry[0], "||");//	DHC_WMR_ExamRul
    obj.RowID = arry[0];//	
    obj.ChildSub = GetDesc(arry[0], "||");//	
    obj.SectionDr = arry[1];//	
    obj.Score = arry[2];//	
    obj.Pos = arry[3];//	
    obj.IsActive = (arry[4] == "Y");//	
    obj.ResumeText = arry[5];//	
	return obj;
}
function BuildDHCWMRExamEntry(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRExamEntry();
    obj.Parref = GetArryItem(arry[0], "||", 0) + "||" + GetArryItem(arry[0], "||", 1);//	DHC_WMR_ExamSection
    obj.RowID = arry[0];//	
    obj.ChildSub = GetArryItem(arry[0], "||", 2);//	
    obj.EntryDr = arry[1];//	
    obj.Score = arry[2];//	
    obj.Pos = arry[3];//	
    obj.Money = arry[4];//	
    obj.MultiErr = arry[5];//	
    obj.Veto = (arry[6] == "Y");//	
    obj.ParentDr = arry[7];//	
    obj.Layer = arry[8];//	
    obj.RSbilityDr = arry[9];//	
    obj.IsActive = (arry[10] == "Y");//	
    obj.ResumeText = arry[11];//	
	return obj;
}

function BuildDHCWMRExamGrade(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRExamGrade();
    obj.Parref = GetCode(arry[0], "||");//	DHC_WMR_ExamRule
    obj.ChildSub = GetDesc(arry[0], "||");//	
    obj.RowID = arry[0];//		
    obj.Title = arry[1];//	
    obj.MinScore = arry[2];//	
    obj.IsActive = (arry[3] == "Y");//	
    obj.ResumeText = arry[4];//	
	obj.Money = arry[5];//
	return obj;
}

function BuildDHCWMRRuleComplex(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRRuleComplex();
	obj.RowID = arry[0];//	RuleComplex
    obj.Code = arry[1];//	
    obj.Title = arry[2];//	
    obj.IsActive = (arry[3] == "Y");//	
    obj.ResumeText = arry[4];//	
	return obj;
}


function BuildDHCWMRRuleComplexDtl(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRRuleComplexDtl();
    obj.Parref = GetCode(arry[0], "||");//	RuleComplexDetail
    obj.ChildSub = GetDesc(arry[0], "||");//		
    obj.RowID = arry[0];//	
    obj.ExamRuleDr = arry[1];//	
    obj.Power = arry[2];//	
    obj.IsActive = (arry[3] == "Y");//	
    obj.ResumeText = arry[4];//	
	return obj;
}


function BuildDHCWMRExamResult(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRExamResult();
	obj.RowID = arry[0];//	DHC_WMR_ExamResult
    obj.VolumeID = arry[1];//	volume rowid
    obj.RuleDr = arry[2];//	
    obj.Veto = (arry[3] == "Y");//	
    obj.Score = arry[4];//	
    obj.ActualScore = arry[5];//	
    obj.IsPrimary = (arry[6] == "Y");//	
    obj.GradeDr = arry[7];//	
    obj.Remind = arry[8];//	
    obj.Money = arry[9];//	
    obj.SignUserDr = arry[10];//	
    obj.ExamDate = arry[11];//	
    obj.ExamTime = arry[12];//	
    obj.IsActive = (arry[13] == "Y");//	
    obj.ResumeText = arry[14];//	
	return obj;
}


function BuildDHCWMRExamRDtl(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRExamRDtl();
    obj.Parref = arry[0];//	DHC_WMR_ExamResult
    obj.ChildSub = arry[1];//
    obj.RowID = arry[0] + "||" + arry[1];//		
    obj.EntryDr = arry[2];//	
    obj.Number = arry[3];//	
    obj.Score = arry[4];//	
    obj.Money = arry[5];//	
    obj.TriggerDate = arry[6];//	
    obj.ErrType = arry[7];//	
    obj.IsActive = (arry[8] == "Y");//	
    obj.ResumeText = arry[9];//	
	return obj;
}
function BuildDHCWMRExamRDtlPeople(str)
{
	if((str == null) || (str == ""))
	{
		return null;
	}
	var arry = str.split(CHR_Up);
	var obj = DHCWMRExamRDtlPeople();
	obj.Parref = GetCode(arry[0], "||");//	DHC_WMR_ExamRDtl
    obj.RowID	 = arry[0];//
    obj.ChildSub = GetDesc(arry[0], "||");//	
    obj.EmployeeDr = arry[1];//	
    obj.RSbilityDr = arry[2];//	
    obj.CtLocDr = arry[3];//	
    obj.IsActive = (arry[4] == "Y");//	
    obj.ResumeText = arry[5];//	
	return obj;
}




function SerializeDHCWMRRuleDic(obj)
{
    if(obj == null)
        return "";
   	var str = ""; 
	str += obj.RowID + CHR_Up;//	DHC_WMR_RuleDic
    str += obj.Code + CHR_Up;//	
    str += obj.Title + CHR_Up;//	
    str += obj.RuleTypeDr + CHR_Up;//	
    str += (obj.IsActive ? "Y" : "N") + CHR_Up;//	
    str += obj.ResumeText;//	
   return str; 
}

function SerializeDHCWMRExamSection(obj)
{
    if(obj == null)
        return "";
   var str = ""; 
	str += obj.RowID + CHR_Up;//	DHC_WMR_SectionDic
	str += obj.Code + CHR_Up;//	
	str += obj.Title + CHR_Up;//	
	str += obj.SectionTypeDr + CHR_Up;//	
	str += obj.IsActive = (obj.IsActive ? "Y" : "N");//	
	str += obj.ResumeText + CHR_Up;//	
   return str; 
}

function SerializeDHCWMREntryDic(obj)
{
    if(obj == null)
        return "";
   var str = ""; 
   str +=  obj.RowID + CHR_Up;// 	DHC_WMR_EntryDic
   str +=  obj.Code + CHR_Up;//	
   str +=  obj.Title + CHR_Up;//	
   str +=  obj.EntryTypeDr + CHR_Up;//	
   str +=  obj.IsActive = (obj.IsActive ? "Y" : "N");//	
    str += obj.ResumeText + CHR_Up;//	
   return str; 
}

function SerializeDHCWMRExamRule(obj)
{
    if(obj == null)
        return "";
   var str = ""; 
    str += obj.RowID + CHR_Up;//	DHC_WMR_ExamRule
     str +=obj.RuleDr + CHR_Up;//	
     str +=obj.MaxScore + CHR_Up;//	
     str +=obj.PassingScore + CHR_Up;//	
     str +=obj.DeductLine + CHR_Up;//	
     str +=obj.MonyPerPoint + CHR_Up;//	
     str +=obj.Punishment + CHR_Up;//	
     str +=obj.ScoreMethod + CHR_Up;//	
     str +=obj.IsActive = (obj.IsActive ? "Y" : "N");//	
     str +=obj.ResumeText + CHR_Up;//	
   return str; 
}

function SerializeDHCWMRExamGrade(obj)
{
    if(obj == null)
        return "";
   var str = ""; 
    str +=obj.Parref + CHR_Up;//	DHC_WMR_ExamRule
    str +=obj.RowID + CHR_Up;//	
    str +=obj.ChildSub + CHR_Up;//	
    str +=obj.SectionDr + CHR_Up;//	
    str +=obj.Score + CHR_Up;//	
    str +=obj.Pos + CHR_Up;//	
    str +=obj.IsActive = (obj.IsActive ? "Y" : "N");//	
    str +=obj.ResumeText + CHR_Up;//	
   return str; 
}

function SerializeDHCWMRRuleComplex(obj)
{
    if(obj == null)
        return "";
   var str = ""; 
   str += obj.RowID + CHR_Up;//	RuleComplex
   str += obj.Code + CHR_Up;//	
   str += obj.Title + CHR_Up;//	
   str += obj.IsActive = (obj.IsActive ? "Y" : "N");//	
   str += obj.ResumeText + CHR_Up;//	
   return str; 
}


function SerializeDHCWMRRuleComplexDtl(obj)
{
    if(obj == null)
        return "";
   var str = ""; 
    str += obj.Parref + CHR_Up;//	RuleComplexDetail
    str += obj.RowID + CHR_Up;//	
    str += obj.ChildSub + CHR_Up;//	
    str += obj.ExamRuleDr + CHR_Up;//	
    str += obj.Power + CHR_Up;//	
    str += obj.IsActive = (obj.IsActive ? "Y" : "N");//	
    str += obj.ResumeText + CHR_Up;//	
   return str; 
}

function SerializeDHCWMRExamResult(obj)
{
    if(obj == null)
        return "";
   var str = ""; 
   str +=  obj.RowID + CHR_Up;//	DHC_WMR_ExamResult
   str +=  obj.VolumeID + CHR_Up;//	volume rowid
   str +=  obj.RuleDr + CHR_Up;//	
   str +=  (obj.Veto ? "Y" : "N") + CHR_Up;//	
   str +=  obj.Score + CHR_Up;//	
   str +=  obj.ActualScore + CHR_Up;//	
   str +=  (obj.IsPrimary ? "Y" : "N") + CHR_Up;//	
   str +=  obj.GradeDr + CHR_Up;//	
   str +=  (obj.Remind ? "Y" : "N") + CHR_Up;//	
   str +=  obj.Money + CHR_Up;//	
   str +=  obj.SignUserDr + CHR_Up;//	
   str +=  obj.ExamDate + CHR_Up;//	
   str +=  obj.ExamTime + CHR_Up;//	
   str +=  obj.IsActive = (obj.IsActive ? "Y" : "N");//	
   str +=  obj.ResumeText + CHR_Up;//	
   return str; 
}


	function SerializeDHCWMRExamRDtl(obj)
	{
		if(obj == null)
			return "";
	   var str = ""; 
	   //str += obj.RowID + CHR_Up;//	
	   str += obj.Parref + CHR_Up;//	DHC_WMR_ExamResult   	   
	   str += obj.ChildSub + CHR_Up;//
	   str += obj.EntryDr + CHR_Up;//	
	   str += obj.Number + CHR_Up;//	The number of trigger
	   str += obj.Score + CHR_Up;//	
	   str += obj.Money + CHR_Up;//	The amount of incentives
	   str += obj.TriggerDate + CHR_Up;//	trigger date
	   str += obj.ErrType + CHR_Up;//	Regulation of error
	   str += obj.IsActive = (obj.IsActive ? "Y" : "N");//	
	   str += obj.ResumeText + CHR_Up;//	
	   return str; 
	}



function SerializeDHCWMRExamRDtlPeople(obj)
{
    if(obj == null)
        return "";
   var str = ""; 
   str +=  obj.Parref + CHR_Up;//
   str += obj.ChildSub + CHR_Up;
   //str +=  obj.Parref + CHR_Up;//	DHC_WMR_ExamRDtl
   //str +=  obj.ChildSub + CHR_Up;//	
   str +=  obj.EmployeeDr + CHR_Up;//	responsibility
   str +=  obj.RSbilityDr + CHR_Up;//	responsibility type
   str +=  obj.CtLocDr + CHR_Up;//	
   str +=  obj.IsActive = (obj.IsActive ? "Y" : "N");//	
   str +=  obj.ResumeText + CHR_Up;//	result
   return str; 
}


//Serialize for java applet
function SerializeExamRuleForApplet(objRule, objRuleDic)
{
    var str = "";
    str += objRule.RowID + appletFieldSplit;
    str += objRuleDic.Title + appletFieldSplit;
    str += (objRule.ResumeText == "" ? "  " : objRule.ResumeText) + appletFieldSplit;
    return str;
}

function SerializeExamSectionForApplet(objCurrRule)
{
    var str = "";
    var objSection = null;
    var objSectionDic = null;
    for(var i = 0; i < objCurrRule.SectionList.length; i ++)
    {
    	objSection = objCurrRule.SectionList[i];
    	objSectionDic = objSection.SectionDic;
	    str += objSection.RowID + appletFieldSplit;
	    str += objSectionDic.Title + appletFieldSplit;
	    str += objSection.Score + appletFieldSplit;
	    str += (objSection.ResumeText == "" ? " " : objSection.ResumeText) + appletFieldSplit + appletRowSplit;
	  }
    return str;
}

function SerializeExamEntryForApplet(objCurrRule)
{
    var str = "";
    var objSection = null;
    var objEntry = null;
    var objEntryDic = null;
    for(var i = 0; i < objCurrRule.SectionList.length; i ++)
    {
    	objSection = objCurrRule.SectionList[i];
    	for(var j = 0; j < objSection.EntryList.length; j ++)
    	{
	    	//a();
    		objEntry = objSection.EntryList[j];
    		objEntryDic = objEntry.EntryDic;
		    str += objEntry.RowID + appletFieldSplit;
		    str += objEntryDic.Title + appletFieldSplit;
		    str += objEntry.Parref + appletFieldSplit;
		    str += objEntry.ParentDr + appletFieldSplit;
		    str += objEntry.Score + appletFieldSplit;
		    str += objEntry.Money + appletFieldSplit;
		    str += (objEntry.IsVeto ? "Y" : "N") + appletFieldSplit;
		    str += objEntry.Pos + appletFieldSplit;
		    str += (objEntry.ResumeText == "" ? " " : objEntry.ResumeText) + appletFieldSplit + appletRowSplit;
	    }
	  }
    return str;
}


// display question list string
function SerializeExamDetailForApplet(arryDetail)
{
	//  chapter entry count responsibility
    var str = "";
    var objDetail = null;
    for(var i = 0; i < arryDetail.length; i ++)
    {
    	objDetail = arryDetail[i];
    	objEntry = dicEntry.Item(objDetail.EntryDr);
    	objSection = dicSection.Item(objEntry.Parref);
    	
    	str += objDetail.Section.SectionDic.Title +  appletFieldSplit;
    	str += objDetail.Entry.EntryDic.Title + appletFieldSplit;
		str += objDetail.TriggerDate + appletFieldSplit;
		str += objDetail.ErrTypeDic.Description + appletFieldSplit;
		str += objDetail.Number + appletFieldSplit;
		str += objDetail.Score + appletFieldSplit;
		for(var j = 0; j < objDetail.DoctorList.length; j ++)
		{
			objPeople = objDetail.DoctorList[j];
			str += objPeople.User.UserName + ","
		}
		str += appletFieldSplit;
		str += objDetail.ResumeText + appletFieldSplit + "     .." + appletFieldSplit;
		str += appletRowSplit;
		
    }

    return str;
}



//Get department serialize string
function SerializeDepartment(obj)
{
	if(obj == null)
		return;
	var str = "";
	str += obj.RowID + CHR_Up;
	str += obj.Code + CHR_Up;
	str += obj.Name;
	return str;
}

function BuildDepartment(str)
{
	if((str == null) || (str == ""))
		return null;
	var objArry = str.split(CHR_Up);
	var obj = new Object();
	obj.RowID = objArry[0];
	obj.Code = objArry[1];
	obj.Name = objArry[2];
	return obj;
}


//20071216
function SerializeAutoCheckRuleItem(obj)
{
    if(obj == null)
        return;
    var str = "";
    str += obj.RowID + CHR_Up;
    str += obj.Description + CHR_Up;
    str += obj.Expression + CHR_Up;
    str += (obj.IsActive ? "Y" : "N") + CHR_Up;
    str += obj.ResumeText + CHR_Up;
    str += obj.Code;
    return str;
}

function BuildAutoCheckRuleItem(str)
{
    if((str == null) || (str == ""))
		    return null;
	var objArry = str.split(CHR_Up);
	var obj = new Object();
    obj.RowID = objArry[0];
    obj.Description = objArry[1];
    obj.Expression = objArry[2];
    obj.IsActive = (objArry[3] == "Y");
    obj.ResumeText = objArry[4];
    obj.Code = objArry[5];
    return obj;
}



//-------Project Coding
//2008-1-11

function SerializeDHCWMRICDVersion(obj)
{
    var str = "";
    if(obj == null)
        return "";
    str += obj.RowID + CHR_Up;
    str += obj.Code + CHR_Up;
    str += obj.Description + CHR_Up;
    str += obj.ItemTypeDr + CHR_Up;
    str += (obj.IsActive ? "Y" : "N") + CHR_Up;
    str += obj.ResumeText;
    return str;
}

function BuildDHCWMRICDVersion(str)
{
    if(str == "")
        return null;
    var obj = DHCWMRICDVersion();
    var arry = str.split(CHR_Up);
    obj.RowID = arry[0];
    obj.Code = arry[1];
    obj.Description = arry[2];
    obj.ItemTypeDr = arry[3];
    obj.IsActive = (arry[4]=="Y");
    obj.ResumeText = arry[5];
    return obj; 
}

function SerializeDHCWMRICDDx(obj)
{
    var str = "";
    if(obj == null)
        return "";
    str += obj.RowID + CHR_Up;
    str += obj.ICD + CHR_Up;
    str += obj.ICD1 + CHR_Up;
    str += obj.Name + CHR_Up;
    str += obj.Version + CHR_Up;
    str += obj.ResumeText;
    return str;
}

function BuildDHCWMRICDDx(str)
{
    if(str == "")
        return null;
    var obj = DHCWMRICDDx();
    var arry = str.split(CHR_Up);
    obj.RowID = arry[0];
    obj.ICD =  arry[1];
    obj.ICD1 =  arry[2];
    obj.Name =  arry[3];
    obj.Version =  arry[4];
    obj.ResumeText =  arry[5];
    return obj;
}

function SerializeDHCWMRICDAlias(obj)
{
    var str = "";
    if(obj == null)
        return "";
    str += obj.RowID + CHR_UP;
    str += obj.ICDDxDr + CHR_UP;
    str += obj.Alias;
    return obj;
}

function BuildDHCWMRICDAlias(str)
{
    if(str == "")
        return null;
    var obj = DHCWMRICDDx();
    var arry = str.split(CHR_Up); 
    obj.RowID = arry[0];
    obj.ICDDxDr = arry[1];
    obj.Alias = arry[2];
    return obj;
}

function SerializeDHCWMRICDExplain(obj)
{
    var str = "";
    if(obj == null)
        return "";
    str += obj.RowID + CHR_UP;
    str += obj.Code + CHR_UP;
    str += obj.Description + CHR_UP;
    str += (obj.IsActive ? "Y" : "N") + CHR_UP;
    str += obj.ResumeText;    
    return str;
}

function BuildDHCWMRICDExplain(str)
{
    if(str == "")
        return null;
    var obj = DHCWMRICDExplain();
    var arry = str.split(CHR_Up); 
    obj.RowID = arry[0];
    obj.Code = arry[1];
    obj.Description = arry[2];
    obj.IsActive = (arry[3] == "Y");
    obj.ResumeText = arry[4];
    return obj;
}

function SerializeDHCWMRFPItemDic(obj)
{
    var str = "";
    if(obj == null)
        return "";
    str += obj.RowID + CHR_UP;
    str += obj.Description + CHR_UP;
    str += obj.DataType + CHR_UP;
    str += obj.DefaultValue + CHR_UP;
    str += obj.DictionaryName + CHR_UP;
    str += obj.ResumeText;
    return str;
}

function BuildDHCWMRFPItemDic(str)
{
    if(str == "")
        return null;
    var obj = DHCWMRFPItemDic();
    
    var arry = str.split(CHR_Up);   
    obj.RowID = arry[0];
    obj.Description = arry[1];
    obj.DataType = arry[2];
    obj.DefaultValue = arry[3];
    obj.DictionaryName = arry[4];
    obj.ResumeText = arry[5];
    return obj;  
}

function SerializeDHCWMRFPTemplate(obj)
{
    var str = "";
    if(obj == null)
        return "";
    str += obj.RowID + CHR_Up;
    str += obj.Code + CHR_Up;
    str += obj.Description + CHR_Up;
    str += obj.MRTypeDr + CHR_Up;
    str += obj.IsActive + CHR_Up;
    str += obj.ResumeText;
    return str;
}

function BuildDHCWMRFPTemplate(str)
{
    if(str == "")
        return null;
    var obj = DHCWMRFPTemplate();
    var arry = str.split(CHR_Up); 
    obj.RowID = arry[0];
    obj.Code = arry[1];
    obj.Description = arry[2];
    obj.MRTypeDr = arry[3];
    obj.IsActive = (arry[4] == "Y");
    obj.ResumeText = arry[5];
    return obj;
}

function SerializeDHCWMRTemplateDtl(obj)
{
    var str = "";
    if(obj == null)
        return "";
    str += obj.RowID + CHR_Up;
    str += obj.TempId + CHR_Up;
    str += obj.ItemId + CHR_Up;
    str += obj.Pos + CHR_Up;
    str += obj.DefaultValue + CHR_Up;
    str += obj.ToolTip + CHR_Up;
    str += obj.ResumeText;
    return str;    
}

function BuildDHCWMRTemplateDtl(str)
{
    if(str == "")
        return null;
    var obj = DHCWMRTemplateDtl();    
    var arry = str.split(CHR_Up); 
    obj.RowID = arry[0];
    obj.TempId = arry[1];
    obj.ItemId = arry[2]
    obj.Pos = arry[3];
    obj.DefaultValue = arry[4];
    obj.ToolTip = arry[5];
    obj.ResumeText = arry[6];
    return obj;
}

function SerializeDHCWMRFrontPage(obj)
{
    var str = "";
    if(obj == null)
        return "";  
    str += obj.RowID + CHR_Up;
    str += obj.VolumeDr + CHR_Up;
    str += obj.ResumeText + CHR_Up;
    str += obj.RepUserDr + CHR_Up;
    str += obj.RepDate + CHR_Up;
    str += obj.RepTime;
    return str;
}

function BuildDHCWMRFrontPage(str)
{
    if(str == "")
        return null;
    var obj = DHCWMRFrontPage();    
    var arry = str.split(CHR_Up); 
    obj.RowID = arry[0];
    obj.VolumeDr = arry[1];
    obj.ResumeText = arry[2];
    obj.RepUserDr = arry[3];
    obj.RepDate = arry[4];
    obj.RepTime = arry[5];
    return obj;
}

function SerializeDHCWMRFPICD(obj)
{
    var str = "";
    if(obj == null)
        return "";      
    str += obj.RowID + CHR_Up;
    str += obj.FrontPageDr + CHR_Up;
    str += obj.ICDDr + CHR_Up;
    str += obj.Result + CHR_Up;
    str += obj.Operator + CHR_Up;
    str += obj.AssistantDr1 + CHR_Up;
    str += obj.AssistantDr2 + CHR_Up;
    str += obj.NarcosisType + CHR_Up;
    str += obj.NarcosisDoctorDr + CHR_Up;
    str += obj.CloseUp + CHR_Up;
    str += obj.ItemTypeDr + CHR_Up;
    str += obj.Pos + CHR_Up;
    str += obj.ResumeText + CHR_Up;
    str += obj.OperationDate + CHR_Up;
    str += obj.FPICDType
    return str;
}

function BuildDHCWMRFPICD(str)
{
    if(str == "")
        return null;
    var arryTmp = null;
    var obj = DHCWMRFrontPage();    
    var arry = str.split(CHR_Up); 
    obj.RowID = arry[0];
    obj.FrontPageDr = arry[1];
    obj.ICDDr = arry[2];
    obj.Result = arry[3];
    if(arry[4] != "")
    {
    	arryTmp = arry[4].split(CHR_Tilted);	
    	obj.OperatorObj = {RowID:arryTmp[0], Code:arryTmp[1], UserName:arryTmp[2]};
    	obj.Operator = arryTmp[0];
    }
    else
    {
    	obj.OperatorObj = {RowID:"", Code:"", UserName:""};
    }
    if(arry[5] != "")
    {
    	arryTmp = arry[5].split(CHR_Tilted);	
    	obj.AssistantDr1Obj = {RowID:arryTmp[0], Code:arryTmp[1], UserName:arryTmp[2]};
    	obj.AssistantDr1 = arryTmp[0];
    }
    else
    {
    	obj.AssistantDr1Obj = {RowID:"", Code:"", UserName:""};
    }
   	if(arry[6] != "")
    {
    	arryTmp = arry[6].split(CHR_Tilted);	
    	obj.AssistantDr2Obj = {RowID:arryTmp[0], Code:arryTmp[1], UserName:arryTmp[2]};
    	obj.AssistantDr2 = arryTmp[0];
    }
  	else
  	{
  		obj.AssistantDr2Obj = {RowID:"", Code:"", UserName:""};
  	}
    obj.NarcosisType = arry[7];
    if(arry[8] != "")
    {
    	arryTmp = arry[8].split(CHR_Tilted);	
    	obj.NarcosisDoctorDrObj = {RowID:arryTmp[0], Code:arryTmp[1], UserName:arryTmp[2]};
    	obj.NarcosisDoctorDr = arryTmp[0];
    }
  	else
  	{
  		obj.NarcosisDoctorDrObj = {RowID:"", Code:"", UserName:""};
  	}
    obj.CloseUp = arry[9];
    obj.ItemTypeDr = arry[10];
    obj.Pos = arry[11];
    obj.ResumeText = arry[12];    
    obj.OperationDate = arry[13];
    obj.FPICDType = arry[14];
    return obj;
}

function SerializeDHCWMRFPExtra(obj)
{
    var str = "";
    if(obj == null)
        return "";   
    str += obj.RowID + CHR_Up;
    str += obj.FrontPageDr + CHR_Up;
    str += obj.ItemId + CHR_Up;
    str += obj.ItemValue + CHR_Up;
    str += obj.Pos;
    return str;    
}

function BuildDHCWMRFPExtra(str)
{
    if(str == "")
        return null;
    var obj = DHCWMRFrontPage();    
    var arry = str.split(CHR_Up); 
    obj.RowID = arry[0];
    obj.FrontPageDr = arry[1];
    obj.ItemId = arry[2];
    obj.ItemValue = arry[3];
    obj.Pos = arry[4];
    return obj;    
}

function BuildDHCWMRRequest(str)
{
    if(str == "")
    return null;
    var obj = DHCWMRRequest();    
    var arry = str.split(CHR_Up); 
    obj.RowID=arry[0];
    //obj.MrType_Dr = arry[1];
    if(arry[1] != "")
    {
    	arryTmp = arry[1].split(CHR_Tilted);	
    	obj.MrTypeObj = {RowID:arryTmp[0], Code:arryTmp[2], UserName:arryTmp[1]};
    	obj.MrType_Dr = arryTmp[0];
    }
  	else
  	{
  		obj.MrTypeObj = {RowID:"", Code:"", UserName:""};
  	}
    
    obj.MrMain_Dr=arry[2];
    
    //obj.RequestType=arry[3];
    if(arry[3] != "")
    {
    	arryTmp = arry[3].split(CHR_Tilted);	
    	obj.RequestTypeObj = {RowID:arryTmp[0], Code:arryTmp[2], UserName:arryTmp[3]};
    	obj.RequestType = arryTmp[0];
    }
  	else
  	{
  		obj.RequestTypeObj = {RowID:"", Code:"", UserName:""};
  	}
    
    //obj.WorkItem_Dr=arry[4];
    if(arry[4] != "")
    {
    	arryTmp = arry[4].split(CHR_Tilted);	
    	obj.WorkItemObj = {RowID:arryTmp[0], Code:"", UserName:arryTmp[2]};
    	obj.WorkItem_Dr = arryTmp[0];
    }
  	else
  	{
  		obj.WorkItemObj = {RowID:"", Code:"", UserName:""};
  	}
    
    obj.AimDate=arry[5];
    
    //obj.AimCtLoc_Dr=arry[6];
    if(arry[6] != "")
    {
    	arryTmp = arry[6].split(CHR_Tilted);	
    	obj.AimCtLocObj = {RowID:arryTmp[0], Code:"", UserName:arryTmp[1]};
    	obj.AimCtLoc_Dr = arryTmp[0];
    }
  	else
  	{
  		obj.AimCtLocObj = {RowID:"", Code:"", UserName:""};
  	}
    
    //obj.AimUser_Dr=arry[7];
    if(arry[7] != "")
    {
    	arryTmp = arry[7].split(CHR_Tilted);	
    	obj.AimUserObj = {RowID:arryTmp[0], Code:arryTmp[1], UserName:arryTmp[2]};
    	obj.AimUser_Dr = arryTmp[0];
    }
  	else
  	{
  		obj.AimUserObj = {RowID:"", Code:"", UserName:""};
  	}
  	
    obj.FirstFlag=(arry[8] == "Y");
    obj.RequestDate=arry[9];
    obj.RequestTime=arry[10];
    
    //obj.RequestUser_Dr=arry[11];
    if(arry[11] != "")
    {
    	arryTmp = arry[11].split(CHR_Tilted);	
    	obj.RequestUserObj = {RowID:arryTmp[0], Code:arryTmp[1], UserName:arryTmp[2]};
    	obj.RequestUser_Dr = arryTmp[0];
    }
  	else
  	{
  		obj.RequestUserObj = {RowID:"", Code:"", UserName:""};
  	}
    
    
    obj.IsActive=(arry[12] == "Y");
    obj.ResponseDate=arry[13];
    obj.ResponseTime=arry[14];
    
    //obj.ResponseUser_Dr=arry[15];
    if(arry[15] != "")
    {
    	arryTmp = arry[15].split(CHR_Tilted);	
    	obj.ResponseUserObj = {RowID:arryTmp[0], Code:arryTmp[1], UserName:arryTmp[2]};
    	obj.ResponseUser_Dr = arryTmp[0];
    }
  	else
  	{
  		obj.ResponseUserObj = {RowID:"", Code:"", UserName:""};
  	}
    
    obj.MrMainStatus_Dr=arry[16];
    obj.ResumeText=arry[17];
    obj.Paadm_Dr=arry[18];
    return obj;    
}
function SerializeDHCWMRRequest(obj)
{
    var str = "";
    if(obj == null)
        return "";   
    str+= obj.RowID+ CHR_Up;   
    str+= obj.MrType_Dr+ CHR_Up;   
    str+= obj.MrMain_Dr+ CHR_Up;   
    str+= obj.RequestType+ CHR_Up;   
    str+= obj.WorkItem_Dr+ CHR_Up;   
    str+= obj.AimDate+ CHR_Up;   
    str+= obj.AimCtLoc_Dr+ CHR_Up;   
    str+= obj.AimUser_Dr+ CHR_Up;   
    str+= (obj.FirstFlag ? "Y" : "N") + CHR_Up;   
    str+= obj.RequestDate+ CHR_Up;   
    str+= obj.RequestTime+ CHR_Up;   
    str+= obj.RequestUser_Dr+ CHR_Up;   
    str+= (obj.IsActive ? "Y" : "N")+ CHR_Up;   
    str+= obj.ResponseDate+ CHR_Up;   
    str+= obj.ResponseTime+ CHR_Up;   
    str+= obj.ResponseUser_Dr+ CHR_Up;   
    str+= obj.MrMainStatus_Dr+ CHR_Up;   
    str+= obj.ResumeText+ CHR_Up;   
    str+= obj.Paadm_Dr;   
    return str;    
}
/*function SerializeDHCWMRRequest(obj)
{
	if(obj == null)
		return "";
		var str = "";
		str += obj.RowID + CHR_Up;
		str += obj.MrType_Dr + CHR_Up;
		str += obj.MrMain_Dr + CHR_Up;
		str += obj.RequestType + CHR_Up;
		str += obj.WorkItem_Dr + CHR_Up;
		str += obj.AimDate + CHR_Up;
		str += obj.AimCtLoc_Dr + CHR_Up;
		str += obj.AimUser_Dr + CHR_Up;
		str += obj.FirstFlag + CHR_Up;
		str += obj.RequestDate + CHR_Up;
		str += obj.RequestTime + CHR_Up;
		str += obj.RequestUser_Dr + CHR_Up;
		str += (obj.IsActive ? "Y" : "N") + CHR_Up;
		str += obj.ResponseDate + CHR_Up;
		str += obj.ResponseTime + CHR_Up;
		str += obj.ResponseUser_Dr + CHR_Up;
		str += obj.MrMainStatus_Dr + CHR_Up;
		str += obj.ResumeText + CHR_Up;
		str += obj.Paadm_Dr;
		return str;	
}*/

//2008-3-5 by liyang
function BuildVerifyUser(str)
{
		if((str == null) || (str == ""))
			return null;
		var obj = new Object();
		var arry = str.split(CHR_Tilted);
		obj.RowID = arry[0];
		obj.Code = arry[1];
		obj.UserName = arry[2];
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
			break;	
	}

	return obj;
}




function BuildDHCMedAdmitDiagnose(str)
{
	//alert(str);
	if((str == "") || (str == null))
		return null;
	var obj = new DHCMedAdmitDiagnose();
	var arryFields = str.split(CHR_2);
	var arryTmp = null;
	var arryTmp1 = null;
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
	if (arryFields.length>=9)     //add by wuqk 2008-05-28
	{
		obj.ResumeText = arryFields[9];
	}
	
	if (arryFields.length>=10)     //add by zf 2008-06-10
	{
		obj.DischargeState = arryFields[10];
	}
	
	return obj;
}


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
//window.alert("DHC.WMR.Serialize Loaded!!!");

//add by wuqk 2008-04-23
function BuildDHCWMRMainPatient(str)
{
	var arryAll=null;
	var obj = new DHCWMRMainPatient();
	if((str == undefined) || (str == ""))
	{
		return null;
	}
	arryAll=str.split(CHR_1);
	var strPatient=arryAll[0];
	if((strPatient == undefined) || (strPatient == ""))
	{
		return null;
	}
	
	var strWMRMain=arryAll[1];
	var arry = strPatient.split(CHR_2);	
	obj.PatientNo = arry[22]; 
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
	obj.Papmi = arry[21];
		
	if (strWMRMain!="")
	{
		var arry = strWMRMain.split(CHR_Up);
  	obj.RowID = arry[0];
  	obj.MrType = arry[1];
  	obj.MRNO =arry[2];
  	obj.Papmi_Dr = arry[3];
  	obj.History_DR = arry[4];
  	obj.IsDead = (arry[5] == "Y");
  	obj.IsActive = (arry[6] == "Y");
  	obj.IsStayIn = (arry[7] == "Y");
  	obj.BuildDate = arry[8];
  	obj.ResumeText = arry[9];
  }
	return obj;
}

function BuildDHCWMRNoVolAdm(str)
{
	if(str == "")
		return null;
	var arry = str.split(CHR_Up);
	var obj = DHCWMRNoVolAdm();
	obj.Paadm = arry[0];
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

function BuildHospital(str)
{
	if(str == "")
		return null;
	var arry = str.split(CHR_Tilted);
	var obj = currHospital();
	var arryH=arry[0].split(CHR_Up);
  obj.RowID=arryH[0];
  obj.Code=arryH[1];
  obj.Desc=arryH[2];
  obj.DepType=arry[1];
  obj.AppCardType=arry[2];
  obj.MyHospitalCode=arry[3];
  obj.BarcodePrinter=arry[4];
	return obj;
}


//*********************************************
//add by zf 208-05-30
//build main patient(papmi/history_dr)
//*********************************************
function BuildDHCWMRMainPatientTMP(str)
{
	if(str == "")
	{
		return null;
	}
	var obj = new Object();
	var arry = str.split(CHR_Up);
	obj.RowID = arry[0];			    //	Papmi or History_Dr
	obj.PatientName = arry[1];			//	
	obj.NameSpell = arry[2];			//	
	obj.Sex = arry[3];					//	
	obj.Birthday = arry[4];				//	
	obj.Age = arry[5];					//	
	obj.Wedlock = arry[6];				//	
	obj.Occupation = arry[7];			//	
	obj.City = arry[8];					//	
	obj.County = arry[9];				//	
	obj.Nation = arry[10];				//	
	obj.Nationality = arry[11];			//	
	obj.IdentityCode = arry[12];		//	
	obj.Company = arry[13];				//	
	obj.CompanyTel = arry[14];			//	
	obj.CompanyZip = arry[15];			//	
	obj.HomeAddress = arry[16];			//	
	obj.HomeTel = arry[17];				//	
	obj.HomeZip = arry[18];				//	
	obj.RelationDesc = arry[19];		//	
	obj.RelativeName = arry[20];		//	
	obj.RelativeTel = arry[21];			//	
	obj.RelativeAddress = arry[22];		//	
	obj.IsActive = arry[23];			//	
	obj.ResumeText = arry[24];			//	
	obj.Papmi = arry[25];			    //	
	obj.PatitneNO = arry[26];			//	
	return obj;
}