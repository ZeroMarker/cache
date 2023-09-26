//Create by LiYang
//Class definition
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

function DHCMedInfectPosition()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.InfPosition = "";
	obj.Active = "";
	obj.Demo = "";
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
	return obj;	
}


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
	obj.OperDocObj="";  //cjb by 20090826 new DHCMedDoctor()
	return obj;	
}

function DHCMedAdmitLabCheckItem()
{
	var obj = new Object();
	obj.OrderID = "";
	obj.LabName = "";
	obj.LabDate = "";
	obj.flag = "";
	obj.LabTestSetRow = "";
	return obj;
}

function DHCMedAdmitArcim()
{
	var obj = new Object();
	obj.OrderID = "";
	obj.ArcimDesc = "";
	obj.StartDate = "";
	obj.EndDate = "";
	obj.Days = "";
	return obj;
}


//Infection Disease dictionary item. used for Infection Section of Report Reporting
function DHCMedInfectionDisease()
{
	var obj = new Object();
	obj.RowID = "";
	obj.DiseaseName = "";
	obj.DiseaseType = "";
	obj.ICD = "";
	obj.PinyYin = "";
	obj.ResumeText = "";
	obj.ActiveFlag = false;
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


//AntiBio Drug Dic item
function DHCMedInfAntiDic()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.Desc = "";
	obj.IsActive = false;
	obj.Resume = "";
	return obj;
}


// DHC_MedInfPathogenDic
function DHCMedGerm()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.Desc = "";
	obj.IsActive = false;
	obj.Resume = "";
	return obj;
}

function DHCMedInfectionRep()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Paadm_DR = "";
	obj.LapseTo = "";
	obj.DeathConnection = "";
	obj.ICUFlag = "";
	obj.DrugEffect = "";
	obj.DblInfFlag = "";
	obj.BeModify_DR = "";
	obj.Date = "";
	obj.Time = "";
	obj.User_DR = "";
	obj.Status = "";
	obj.CheckUsr_DR = "";
	obj.CheckDate = "";
	obj.CheckTime = "";
	obj.Demo = "";
	obj.RepPlace = "";  //Add BY LiYang 2009-4-7
	return obj;
}

function DHCMedInfectionRepDia()
{
	var obj = new Object();
	obj.ParRef = "";
	obj.RowID = "";
	obj.ChildSub = "";
	obj.MrDia_DR = "";
	obj.DiagDesc = "";
	obj.DiagType = "";
	obj.DiagDoc = "";
	obj.DiagDate = "";
	obj.DiagTime = "";
	obj.ICD10 = "";
	obj.ICD10Desc = "";
	obj.IsActive = "";
	obj.Resume = "";
	return obj;
}

function DHCMedInfectionRepOPR()
{
	var obj = new Object();
	obj.ParRef = "";
	obj.RowID = "";
	obj.ChildSub = "";
	obj.OperationDesc = "";
	obj.EmerOprFlag = "";
	obj.DateFrom = "";
	obj.TimeFrom = "";
	obj.DateTo = "";
	obj.TimeTo = "";
	obj.OprDoc = "";
	obj.Anaesthesia = "";
	obj.CuteType = "";
	obj.Concrescence = "";
	obj.CuteInfFlag = "";
	obj.OprCuteType = "";
	obj.InfectionFlag = "";
	obj.OEORI_DR = "";
	obj.OPICD9Map = "";
	obj.OperICD9Desc = "";
	obj.IsActive = "";
	obj.Resume = "";	
	return obj;	
}

function DHCMedInfectionRepRea()
{
	var obj = new Object();
	obj.ParRef = "";
	obj.RowID = "";
	obj.ChildSub = "";
	obj.InfReason = "";
	return obj;	
}

function DHCMedInfectionRepPos()
{
	var obj = new Object();
	obj.ParRef = "";
	obj.RowID = "";
	obj.ChildSub = "";
	obj.InfPos_DR = "";
	obj.InfDate = "";
	obj.InfEndDate = ""; //Add by LiYang  2008-12-1
	obj.InfDays = ""; //Add by LiYang  2008-12-1
	obj.InfDiag_DR = "";
	obj.InroadOpr = "";
	// Add By LiYang 2009-09-08 operate start/end date and time
	obj.OprEndDate = "";
	obj.OprEndTime = "";
	obj.OprStartDate = "";
	obj.OprStartTime = "";
	return obj;	
}

function  DHCMedInfectionRepDrug()
{
	var obj = new Object();
	obj.ParRef = "";
	obj.RowID = "";
	obj.ChildSub = "";
	obj.OEORI_DR = "";
	obj.Instr = "";
	obj.DateFrom = "";
	obj.DateTo = "";
	obj.Days = "";
	obj.Mode = "";
	obj.Aim = "";
	obj.CureDrugMode = "";
	obj.PrevDrugMode = "";
	obj.PrevDrugFlag = "";
	obj.PrevDrugEffect = "";
	obj.UniteDrug = "";
	obj.OprDrugFlag = "";
	obj.PreDrugTime = "";
	obj.AftDrugDays = "";
	obj.RightFlag = "";
	obj.Impertinency = "";
	obj.Effect = "";
	return obj;
}

function DHCMedInfPathogeny()
{
	var obj = new Object();
	obj.ParRef = "";
	obj.RowID = "";
	obj.ChildSub = "";
	obj.Sample = "";
	obj.InfPos_DR = "";
	obj.Date = "";
	obj.Method = "";
	obj.DrugFlag = "";
	obj.OEORI_DR = "";
	obj.GermArry = new Array();
	return obj;
}

function DHCMedInfPyObj()
{
	var obj = new Object();
	obj.ParRef = "";
	obj.RowID = "";
	obj.ChildSub = "";
	obj.Object = "";
	obj.Flag = "";
	obj.GermObj = null;
	obj.arryDrug = new Array();
	return obj;		
}

function  DHCMedInfPyObjDrug()
{
	var obj = new Object();
	obj.ParRef = "";
	obj.RowID = "";
	obj.ChildSub = "";
	obj.Drug_DR = "";
	obj.Flag = "";
	return obj;
}

function DHCMedMedInfPathogen()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.Desc = "";
	obj.IsActive = "";
	obj.Resume = "";
	return obj;	
}

function DHCMedMedAntiDic()
{
	var obj = new Object();
	obj.RowID = "";
	obj.Code = "";
	obj.Desc = "";
	obj.IsActive = "";
	obj.Resume = "";
	return obj;	
}



//2008-6-29
//Germ Sensitive Test By Liyang
function SenKabTestResult()
{
	var obj = new Object();
	obj.GermNme = "";
	obj.AntiName = "";
	obj.IsSen = "";
	return obj;	
	
}
//add by lxf 2008-10-21
//Table DHC_MedIPBKTempItem
function DHCMedIPBKTempItem()
{
	var obj = new Object();
	obj.RowID = "";
	obj.ItemCode = "";
	obj.ItemDesc = "";
	obj.DateTypeID = "";
	obj.DictionaryName = "";
	obj.IsActive = "";
	obj.ResumeText = "";
	return obj;	
}
//add by lxf 2008-10-24 
//Table DHC_MedIPBKTemplate
function DHCMedIPBKTemplate()
{
	var obj = new Object();
	obj.RowID = "";
	obj.TempCode = "";
	obj.TempDesc = "";
	obj.IsActive = "";
	obj.ResumeText = "";
	return obj;	
}
//add by lxf 2008-10-24 
//Table DHC_MedIPBKTempDtl
function DHCMedIPBKTempDtl()
{
	var obj = new Object();
	obj.RowID = "";
	obj.TempID = "";
	obj.ItemID = "";
	obj.DefaultValue = "";
	obj.IsNeed = "";
	obj.ToolTip = "";
	obj.ResumeText = "";
	return obj;	
}


function DHCMedIPBooking() {

    var obj = new Object();
    obj.RowID = "";
    obj.PatientID = "";
    obj.EpisodeIDFrom = "";
    obj.EpisodeIDTo = "";
    obj.CreateDate = "";
    obj.CreateTime = "";
    obj.CreateUserID = "";
    obj.CreateDocID = "";
    obj.CurrentStateID = "";
    obj.IsActive = "";
    obj.BookingDate = "";
    obj.Text1 = "";
    obj.Text2 = "";
    obj.Text3 = "";
    obj.Text4 = "";
    obj.ResumeText = "";
    return obj;
}

function DHCMedIPBKState() {
    var obj = new Object();
    obj.RowID = "";
    obj.BookID = "";
    obj.StateID = "";
    obj.ChangeUserID = "";
    obj.ChangeDate = "";
    obj.ChangeTime = "";
    obj.ReasonID = "";
    obj.ResumeText = "";
    return obj;
}

function DHCMedIPBKDetail() {

    var obj = new Object();
    obj.RowID = "";
    obj.BookID = "";
    obj.ItemID = "";
    obj.ItemValue = "";
    return obj;
}



function DHCMedBed() {
    var obj = new Object();
    obj.RowID = "";
    obj.Desc = "";
    return obj;
}
	
///Add clsInjuryReport by cjb 2009-05-08
function clsInjuryReport(Rowid){
	this.Rowid=Rowid;                            ///
	this.Pa_AdmRowID=""; 
	this.CardNo="";                             ///
	this.Status=new clsDictionary("");             ///
	this.InjDate="";                              ///
	this.InjTime="";                             ///
	this.Diagnose=new clsEpdICD("");             ///…À∫¶¡Ÿ
	this.RepUser=new clsDictionary("");         ///
	this.ReportDate="";                          ///
	this.ReportTime=""
	this.CheckUser=new clsDictionary("");       ///
	this.CheckDate="";                          ///
	this.CheckTime="";                          ///
	this.IsActive=""
	this.ResumeText="";                          ///
	}
	
function clsInjuryReportDtl(Rowid){
	this.Rowid=Rowid;
	this.InjuryReport=new clsInjuryReport("");
	this.DicID=new clsDictionary("");         ///
	this.Value="";	
	this.Other="";
	this.ResumeText="";
	}
	
function clsPaAdm(Rowid){
	this.Rowid=Rowid;
	this.PatientID=new clsPatient("");
	this.Type="";	
	this.AdmDate="";
	this.AdmTime="";
	}