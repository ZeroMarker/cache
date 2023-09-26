/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.Class

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-9

COMMENT: class declaration for medical record system
to view field meaning infomation, please see database structure table
========================================================================= */

function DHCWMRMain()
{
	var obj = new Object();
	obj.RowID = "";				
	obj.MrType = "";			
	obj.MRNO = "";				
	obj.Papmi_Dr = "";			
	obj.History_DR = "";		
	obj.IsDead = false;			
	obj.IsActive = false;			
	obj.IsStayIn = false;			
	obj.BuildDate = "";			
	obj.ResumeText = "";		
	return obj;
}


function DHCWMRHistoryAdm()
{
	var obj = new Object();
	obj.RowID = ""; 				
	obj.History_Dr = ""; 			
	obj.AdmitDate = ""; 			
	obj.AdmitTime = ""; 			
	obj.AdmitDep = ""; 			
	obj.AdmitStatus = ""; 			
	obj.DischargeDate = ""; 		
	obj.DischargeTime = ""; 		
	obj.DischargeDep = ""; 			
	obj.Diagnose = ""; 				
	obj.IsActive = ""; 				
	obj.ResumeText = ""; 			

	return obj;
}


function DHCWMRDictionary()
{
	var obj = new Object();
	obj.RowID = "";					
	obj.DictionaryName = "";		
	obj.Code = "";				
	obj.Description = "";			
	obj.FromDate = "";			
	obj.ToDate = "";			
	obj.TextA = "";				
	obj.TextB = "";				
	obj.TextC = "";				
	obj.TextD = "";				
	obj.IsActive = false;			
	obj.ResumeText = "";			
		
	return obj;
}

function  DHCWMRWorkItemRule()
{
	var obj = new Object();
	obj.Parref = "";		
	obj.RowID = "";			
	obj.ChildSub = "";		
	obj.Description = "";	
	obj.IsActive = "";	
	obj.Resume = "";	

	return obj;
}
	
function DHCWMRWorkItemList()
{
	var obj = new Object();
	obj.Parref = "";		
	obj.RowID = "";			
	obj.ChildSub = "";		
	obj.DetailDr = "";
	obj.ListIndex = "-1";
	obj.IsActive = false;
	obj.IsNeed = false;
	obj.Resume = "";
	obj.DefaultValue = "";
	return obj;
}

function DHCWMRWorkItem()
{
	var obj = new Object();
	obj.RowID = "";		
	obj.ItemType = "";	
	obj.Description = "";	
	obj.IsActive = "";	
	obj.Resume = "";	
	obj.SysOper_Dr = "";    
	obj.CheckUser = true;	
	obj.BeRequest = false;
	return obj;
}

function DHCWMRWorkFlowSub()
{
	var obj = new Object();
	obj.Parref = ""; 	
	obj.Rowid = ""; 	
	obj.ChildSub = ""; 	
	obj.IndexNo = ""; 	
	obj.Item_Dr = ""; 	

	return obj;
}

function DHCWMRWorkFlow()
{
	var obj = new Object();
	obj.Rowid = "";		
	obj.MrType = "";	
	obj.Description = "";	
	obj.IsActive = "";	
	obj.DateFrom = "";		
	obj.DateTo = "";	
	obj.Resume = "";	
	return obj;
}

function DHCWMRVolStatusEva()
{
	var obj = new Object();
	obj.Perref = "";		
	obj.Rowid = "";		
	obj.ChildSub = "";	
	obj.Eva_Dr = "";	
	obj.User_Dr = "";	
	obj.EvaDate = "";	
	obj.EvaTime = "";
	obj.ResumeText = "";

	return obj;
}

function DHCWMRVolStatusDtl()
{
	var obj = new Object();
	obj.Parref = "";
	obj.Rowid = "";	
	obj.ChildSub = "";
	obj.Detail_Dr = "";
	obj.ItemValue = "";
	obj.Resume = "";
	obj.WorkItemList_Dr = "";

	return obj;
}

function DHCWMRVolStatus()
{
	var obj = new Object();
	obj.Parref = "";
	obj.RowID = "";	
	obj.ChildSub = "";
	obj.Status_Dr = "";
	obj.UserFromDr = "";
	obj.CurrDate = "";
	obj.CurrTime = "";
	obj.UserToDr = "";
	return obj;
}

function DHCWMRVolAdm()
{
	var obj = new Object();
	obj.Perref = "";	
	obj.RowID = "";		
	obj.ChildSub = "";	
	obj.Paadm_Dr = "";	

	return obj;
}

function DHCWMRMainVolume()
{
	var obj = new Object();
	obj.RowID = "";	
	obj.Main_Dr = "";
	obj.Paadm_Dr = "";
	obj.HistroyAdm_Dr = "";
	obj.IsReprography = false;
	obj.IsSeal = false;	
	obj.Status_Dr = "";	
	obj.IsActive = false;	
	obj.InFlow = false;	
	obj.ResumeText = "";	


	return obj;
}

function DHCWMRMainStatusDtl()
{
	var obj = new Object();
	obj.Parref = "";
	obj.Rowid = "";
	obj.ChildSub = "";
	obj.Detail_Dr = "";
	obj.ItemValue = "";
	obj.Resume = "";
	obj.WorkItemList_Dr = "";
	return obj;
}

function DHCWMRMainStatus()
{
	var obj = new Object();
	obj.Parref = "";
	obj.Rowid = "";	
	obj.ChildSub = "";
	obj.Status_Dr = "";
	obj.UserFromDr = "";
	obj.CurrDate = "";
	obj.CurrTime = "";
	obj.UserToDr = "";
	return obj;
}

function DHCWMRWorkDetail()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";	
	obj.Description = "";
	obj.DataType = "";	
	obj.IsActive = "";	
	obj.Resume = "";	
	obj.DictionaryCode = "";

	return obj;
}

function DHCWMRWorkFlow()
{
	var obj = new Object();
	obj.Rowid = "";	
	obj.MrType_Dr = "";
	obj.Description = "";
	obj.IsActive = "";	
	obj.DateFrom = "";	
	obj.DateTo = "";	
	obj.Resume = "";	

	return obj;
}

function Patient()
{
	var obj = new Object();
	obj.RowID = ""; 
	obj.PatientNo = ""; 
	obj.MedRecNo = ""; 
	obj.Sex = ""; 
	obj.Identity = ""; 
	obj.Birthday =""; 
	obj.Age = ""; 
	obj.NowAddress = ""; 
	obj.Telephone = ""; 
	obj.RelationName = ""; 
	obj.Company = ""; 
	obj.PatientName = ""; 
	obj.Nationality = ""; 
	obj.Nation = ""; 
	obj.Marriage = ""; 
	obj.Culture = ""; 
	obj.NativePlace = ""; 
	obj.Relation = ""; 
	obj.RelativeAddress = ""; 
	obj.Payment = ""; 
	obj.Occupation = ""; 
	return obj;
}


function DHCWMRUser()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.UserName = "";
	obj.Password = "";
	obj.GroupID = "";
	obj.Dep = "";
	obj.Location = "";
	
	return obj;
}



function DHCWMRAdmInfo() 
{
	var obj = new Object();
	obj.RowID = "";
	obj.AdmType = "";
	obj.AdmNo = "";
	obj.AdmDate = "";
	obj.AdmTime = "";
	obj.PatientID = "";
	obj.LocDesc = "";
	obj.DocDesc = "";
	obj.WardDesc = "";
	obj.RoomDesc = "";
	obj.BedDesc = "";
	obj.DischgDate = "";
	obj.DischgTime = "";
	obj.VisitStatus = "";
	return obj;
}


function DHCWMRVolInfo()
{
	var obj = new Object();
	obj.RowID = "";
	obj.PatientName = "";	
	obj.NameSpell = "";	
	obj.Sex = "";		
	obj.Birthday = "";	
	obj.Age = "";		
	obj.Wedlock = "";	
	obj.Occupation = "";	
	obj.City = "";		
	obj.County = "";	
	obj.Nation = "";					
	obj.Nationality = "";					
	obj.IdentityCode = "";				
	obj.Company = "";				
	obj.CompanyTel = "";				
	obj.CompanyZip = "";				
	obj.HomeAddress = "";				
	obj.HomeTel = "";				
	obj.HomeZip = "";				
	obj.RelationDesc = "";				
	obj.RelativeName = "";				
	obj.RelativeTel = "";				
	obj.RelativeAddress = "";			
	obj.IsActive = false;				
	obj.ResumeText = "";				
	obj.Volume_Dr = "";				
	return obj;
}

function DHCWMRBarCode(str)
{
	var obj = new Object();
	if(str.length != 13)
		throw new Error("9999", "BarCode Error");
	obj.ID = new Number(str.substr(2, 11)).toString();
	obj.Type = str.substr(0, 2); //01 whole mr 02volume
	obj.Text = str;
	
	
	return obj;
}

function DHCWMRDischargeListItem()
{
	var obj = new Object();
	obj.WardDesc = "";
	obj.DischargeDate = "";
	obj.PatientNo = "";
	obj.PatientName = "";
	obj.MedicalRecordNo = "";
	return obj;
}




function DHCWMRHistory()
{
	var obj = new Object();
	obj.RowID = "";		
	obj.PatientName = "";	
	obj.NameSpell = "";	
	obj.Sex = "";		
	obj.Birthday = "";	
	obj.Age = "";		
	obj.Wedlock = "";	
	obj.Occupation = "";	
	obj.City = "";		
	obj.County = "";	
	obj.Nation = "";	
	obj.Nationality = "";	
	obj.IdentityCode = "";	
	obj.Company = "";	
	obj.CompanyTel = "";	
	obj.CompanyZip = "";	
	obj.HomeAddress = "";	
	obj.HomeTel = "";	
	obj.HomeZip = "";	
	obj.RelationDesc = "";	
	obj.RelativeName = "";	
	obj.RelativeTel = "";	
	obj.RelativeAddress = "";
	obj.IsActive = false;	
	obj.ResumeText = "";	
	obj.PatientNo = "";  //add by zf 20090903
	return obj;
}





function DHCWMRRuleDic()
{
	var obj = new Object();
	obj.RowID = "";
    obj.Code = "";
    obj.Title = "";
    obj.RuleTypeDr = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj;
}


function DHCWMRSectionDic()
{
    var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.Title = "";
	obj.SectionTypeDr = "";
	obj.IsActive = false;
	obj.ResumeText = "";
    return obj;
}


function DHCWMREntryDic()
{
    var obj = new Object();
    obj.RowID = "";
    obj.Code = "";
    obj.Title = "";
    obj.EntryTypeDr = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj;
}

function DHCWMRExamRule()
{
    var obj = new Object();
    obj.RowID = "";
    obj.RuleDr = "";
    obj.MaxScore = "";
    obj.PassingScore = "";
    obj.DeductLine = "";
    obj.MonyPerPoint = "";
    obj.Punishment = "";
    obj.ScoreMethod = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj;
}



function DHCWMRExamSection()
{
    var obj = new Object();
    obj.Parref = "";
    obj.RowID = "";
    obj.ChildSub = "";
    obj.SectionDr = "";
    obj.Score = "";
    obj.Pos = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    obj.ActualScore = 0;
    return obj; 
}



function  DHCWMRExamEntry()
{
    var obj = new Object();
    obj.Parref = "";
    obj.RowID = "";
    obj.ChildSub = "";
    obj.EntryDr = "";
    obj.Score = "";
    obj.Pos = "";
    obj.Money = "";
    obj.MultiErr = false;
    obj.Veto = false;
    obj.ParentDr = "";
    obj.Layer = "";
    obj.RSbilityDr = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj; 
}



function  DHCWMRExamGrade()
{
    var obj = new Object();
    obj.Parref = "";
    obj.RowID = "";
    obj.ChildSub = "";
    obj.Title = "";
    obj.MinScore = "";
    obj.IsActive = false;
    obj.ResumeText = "";
	obj.Money = 0;
    return obj; 
}



function  DHCWMRRuleComplex()
{
    var obj = new Object();
    obj.RowID = "";
    obj.Code = "";
    obj.Title = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj; 
}

function DHCWMRRuleComplexDtl()
{
    var obj = new Object();
    obj.Parref = "";
    obj.RowID = "";//	
    obj.ChildSub = "";//	
    obj.ExamRuleDr = "";
    obj.Power = "";//	
    obj.IsActive = false;//
    obj.ResumeText = "";//	
    return obj;    
}

function DHCWMRExamResult()
{
    var obj = new Object();
    obj.RowID = "";
    obj.VolumeID = "";
    obj.RuleDr = "";
    obj.Veto = "";
    obj.Score = "";
    obj.ActualScore = "";
    obj.IsPrimary = "";
    obj.GradeDr = "";
    obj.Remind = "";
    obj.Money = "";
    obj.SignUserDr = "";
    obj.ExamDate = "";
    obj.ExamTime = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj;  
}



function DHCWMRExamRDtl()
{
    var obj = new Object();
    obj.Parref = "";//	DHC_WMR_ExamResult
    obj.RowID = "";//	
    obj.ChildSub = "";//	
    obj.EntryDr = "";
    obj.Number = "";
    obj.Score = "";
    obj.Money = "";
    obj.TriggerDate = "";
    obj.ErrType = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    obj.DoctorList = new Array();
    return obj;
}



function DHCWMRExamRDtlPeople()
{
    var obj = new Object();
    obj.Parref = "";//	DHC_WMR_ExamRDtl
    obj.RowID	 = "";//
    obj.ChildSub = "";//	
    obj.EmployeeDr = "";
    obj.RSbilityDr = "";
    obj.CtLocDr = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj;
}




//20071216
function AutoCheckRuleItem()
{
    var obj = new Object();
    obj.RowID = "";
    obj.Code = ""
    obj.Description = "";
    obj.Expression = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj;
}



//-----------Project Coding--------------
//2008-1-11
//ICD version dictionary 
function DHCWMRICDVersion()
{
    var obj = new Object();
    obj.RowID = "";
    obj.Code = "";
    obj.Description = "";
    obj.ItemTypeDr = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj;
}

//ICD Dictionary Item
function DHCWMRICDDx()
{
    var obj = new Object();
    obj.RowID = "";
    obj.ICD = "";
    obj.ICD1 = "";
    obj.Name = "";
    obj.Version = "";
    obj.ResumeText = "";
    return obj;
}

//ICD Dictionary Item Pinyin code etc.
function DHCWMRICDAlias()
{
    var obj = new Object();
    obj.RowID = "";
    obj.ICDDxDr = "";
    obj.Alias = "";
    return obj;
}

//Explain for ICD Dictionary Item
function DHCWMRICDExplain()
{
    var obj = new Object();
    obj.RowID = "";
    obj.Code = "";
    obj.Description = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj;
}

//Front Page Item Type Dictionary
function DHCWMRFPItemDic()
{
    var obj = new Object();
    obj.RowID = "";
    obj.Description = "";
    obj.DataType = "";
    obj.DefaultValue = "";
    obj.DictionaryName = "";
    obj.ResumeText = "";
    return obj;
}

//Front Page Template
function DHCWMRFPTemplate()
{
    var obj = new Object();
    obj.RowID = "";
    obj.Code = "";
    obj.Description = "";
    obj.MRTypeDr = "";
    obj.IsActive = false;
    obj.ResumeText = "";
    return obj;
}

//Front Page Template Detail
function DHCWMRTemplateDtl()
{
    var obj = new Object();
    obj.RowID = "";
    obj.TempId = "";
    obj.ItemId = "";
    obj.Pos = "";
    obj.DefaultValue = "";
    obj.ToolTip = "";
    obj.ResumeText = "";
    obj.RelatedControl = null;
    obj.RelatedDtl = null;
    return obj;
}

//Front Page Main
function DHCWMRFrontPage()
{
    var obj = new Object();
    obj.RowID = "";
    obj.VolumeDr = "";
    obj.ResumeText = "";
    obj.RepUserDr = "";
    obj.RepDate = "";
    obj.RepTime = "";
    return obj;
}

//Disease and operation information of front page
function DHCWMRFPICD()
{
    var obj = new Object();
    obj.RowID = "";
    obj.FrontPageDr = "";
    obj.ICDDr = "";
    obj.Result = "";
    obj.Operator = "";
    obj.AssistantDr1 = "";
    obj.AssistantDr2 = "";
    obj.NarcosisType = "";
    obj.NarcosisDoctorDr = "";
    obj.CloseUp = "";
    obj.ItemTypeDr = "";
    obj.Pos = "";
    obj.ResumeText = "";
    obj.OperationDate = "";
    obj.FPICDType = "";
    //Add By LiYang 2009-07-28 New Column
    obj.SrcType = ""; //Dic Type 1---DHCWMRICDDx  2---MRC_ICDDx  3---OPER_ICD9Map  4---MRC_DiagnosSignSymptom
    obj.Text1 = "";
    obj.Text2 = "";
    obj.Text3 = "";
    obj.Text4 = "";    
    return obj;
}

//Front Page Extra infomation
function DHCWMRFPExtra()
{
    var obj = new Object();
    obj.RowID = "";
    obj.FrontPageDr = "";
    obj.ItemId = "";
    obj.ItemValue = "";
    obj.Pos = "";
    return obj;
}

function DHCWMRRequest()
{
    var obj = new Object();
    obj.RowID="";
    obj.MrType_Dr="";
    obj.MrMain_Dr="";
    obj.RequestType="";
    obj.WorkItem_Dr="";
    obj.AimDate="";
    obj.AimCtLoc_Dr="";
    obj.AimUser_Dr="";
    obj.FirstFlag=true;
    obj.RequestDate="";
    obj.RequestTime="";
    obj.RequestUser_Dr="";
    obj.IsActive=true;
    obj.ResponseDate="";
    obj.ResponseTime="";
    obj.ResponseUser_Dr="";
    obj.MrMainStatus_Dr="";
    obj.ResumeText="";
    obj.Paadm_Dr="";
    return obj;
}

function CommonDictionary()
{
    var obj = new Object();
    obj.Id="";
    obj.Code="";
    obj.Name=""
    return obj;
}



//Operation Entity From HIS  by liyang 2008-4-28
function DHCMedAdmitOperation()
{
	var obj = new Object();
	obj.OperationRowID = "";
	obj.OperationName = "";
	obj.OrderDate = "";
	obj.Status = "";
	obj.StartDate = "";
	obj.StartTime = "";
	obj.EndDate = "";
	obj.EndTime = "";
	obj.OperDoc = "";
	obj.Anamed = "";
	obj.anDoctor="";
	obj.assList="";
	obj.OPICD9Map="";
	return obj;	
}

function DHCMedAdmitDiagnose()
{
	var obj = new Object();
	obj.DiagnoseDate = "";
	obj.DiagnoseName = "";
	obj.DiagnoseRowID = "";
	obj.DiagnoseTime = "";
	obj.DiagnoseTypeCode = "";
	obj.DiagnoseTypeDesc = "";
	obj.DiagnoseTypeRowID = "";
	obj.Doctor = new DHCWMRUser();
	obj.ICD = "";
	obj.ICDRowID = "";
	obj.Location = new DHCMedDepartment();
	obj.Paadm = "";
	obj.PatientType = new DHCMedDictionaryItem();
	obj.ResumeText="";             //add by wuqk 2008-05-28 BeiJing DiTan  是否确诊 或 怀疑诊断类型
	obj.DischargeState="";         //add by zf 2008-06-10 BeiJing DiTan   出院情况
	return obj;	
}

function DHCMedDepartment()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.Department = "";
	return obj;
}

function DHCWMRUser()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.UserName = "";
	obj.Password = "";
	obj.GroupID = "";
	obj.Dep = "";
	obj.Location = "";
	
	return obj;
}


function DHCMedDictionaryItem()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.Desc = "";
	obj.Type = "";
	obj.Active = "";
	obj.DateFrom = "";
	obj.DateTo = "";
	obj.StrA = "";
	obj.StrB = "";
	obj.StrC = "";
	obj.StrD = "";
	return obj;
}

function DHCMedDoctor()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.DoctorName = "";
	obj.Department = new Object();
	obj.Department.RowID = "";
	obj.Department.DepName = "";
	return obj;	
}

//add by wuqk 2008-04-23
function DHCWMRNoVolAdm() 
{
	var obj = new Object();
	obj.Paadm = "";
	obj.AdmType = "";
	obj.AdmNo = "";
	obj.AdmDate = "";
	obj.AdmTime = "";
	obj.PatientID = "";
	obj.LocDesc = "";
	obj.DocDesc = "";
	obj.WardDesc = "";
	obj.RoomDesc = "";
	obj.BedDesc = "";
	obj.DischgDate = "";
	obj.DischgTime = "";
	obj.VisitStatus = "";
	obj.VolumeId = "";
	return obj;
}
function DHCWMRMainPatient()
{
	var obj = new Object();
	obj.RowID = "";				
	obj.MrType = "";			
	obj.MRNO = "";				
	obj.Papmi_Dr = "";			
	obj.History_DR = "";		
	obj.IsDead = false;			
	obj.IsActive = false;			
	obj.IsStayIn = false;			
	obj.BuildDate = "";			
	obj.ResumeText = "";		
	obj.Papmi = "";
	obj.PatientNo = ""; 
	obj.Sex = ""; 
	obj.Identity = ""; 
	obj.Birthday =""; 
	obj.Age = ""; 
	obj.NowAddress = ""; 
	obj.Telephone = ""; 
	obj.RelationName = ""; 
	obj.Company = ""; 
	obj.PatientName = ""; 
	obj.Nationality = ""; 
	obj.Nation = ""; 
	obj.Marriage = ""; 
	obj.Culture = ""; 
	obj.NativePlace = ""; 
	obj.Relation = ""; 
	obj.RelativeAddress = ""; 
	obj.Payment = ""; 
	obj.Occupation = ""; 
	return obj;
}

function currHospital()
{
    var obj = new Object();
    obj.RowID="";
    obj.Code="";
    obj.Desc=""
    obj.DepType="";
    obj.AppCardType="";
    obj.MyHospitalCode="";
    obj.BarcodePrinter="";
    return obj;
}

function clsWebConfig(Asize){
	this.CurrentNS="";
	this.MEDDATA="";
	this.LABDATA="";
	this.Server="";
	this.Path="";
	this.LayOutManager="";
	this.WebServerAppURL="";
	}
	

//*********************************************
//add by zf 2008-05-30
//build main patient(papmi/history_dr)
//*********************************************
function DHCWMRMainPatientTMP()
{
	var obj = new Object();
	obj.RowID = "";
	obj.PatientName = "";
	obj.NameSpell = "";
	obj.Sex = "";
	obj.Birthday = "";
	obj.Age = "";
	obj.Wedlock = "";
	obj.Occupation = "";
	obj.City = "";
	obj.County = "";
	obj.Nation = "";
	obj.Nationality = "";
	obj.IdentityCode = "";
	obj.Company = "";
	obj.CompanyTel = "";
	obj.CompanyZip = "";
	obj.HomeAddress = "";
	obj.HomeTel = "";
	obj.HomeZip = "";
	obj.RelationDesc = "";
	obj.RelativeName = "";
	obj.RelativeTel = "";
	obj.RelativeAddress = "";
	obj.IsActive = "";
	obj.ResumeText = "";
	obj.Papmi = "";
	obj.PatitneNO = "";
	return obj;
}