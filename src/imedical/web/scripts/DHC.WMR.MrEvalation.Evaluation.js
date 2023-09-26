/*
Medical Record Quality Evaluation
By LiYang ,Microsoft
2007-9-5
*/
var strRuleDicParam = GetParam(window, "RuleDicID");//evaluation rule dictionary item rowID
var strMrTypeParam = GetParam(window, "MrType");//Medical record type dr


var arryProblem = new Array();
var objDicDoctor = new ActiveXObject("Scripting.Dictionary");
var dicProblem = new ActiveXObject("Scripting.Dictionary");

var objCurrRule = null;
var objCurrVolume = null;
var objCurrPatient = null;
var objCurrMain = null;

var dicEntry = new ActiveXObject("Scripting.Dictionary");
var dicSection = new ActiveXObject("Scripting.Dictionary"); 
var arryGrade = null;//Levels of a rule



var objResponsibilityDic = new ActiveXObject("Scripting.Dictionary");
var objErrTypeDic = new ActiveXObject("Scripting.Dictionary");


function GetProblemKey(EntryID, EmployeeID, Loc)
{
	if(Loc == null)
		loc = "";
	var tmpEmployeeID = EmployeeID;
	if(tmpEmployeeID.indexOf("Dep-") == 0)
		tmpEmployeeID = "";
	return EntryID + "-" + tmpEmployeeID + "-" + Loc;
}


//load evaluation rule
function LoadExamRule()
{
    var objSection = null;
    var objEntry = null;
    objCurrRule = GetRuleByDic("MethodGetRuleByDic", strRuleDicParam, "Y");
    objCurrRule.SectionList = GetSectionByRule("MethodGetSectionByRule", objCurrRule.RowID, "Y");
    for(var i = 0; i < objCurrRule.SectionList.length; i ++)
    {
        objSection = objCurrRule.SectionList[i];
        if(!dicSection.Exists(objSection.RowID))
            dicSection.Add(objSection.RowID, objSection);
        objSection.EntryList = GetEntryBySection("MethodGetEntryBySection", objSection.RowID, "Y");
        for(var j = 0; j < objSection.EntryList.length; j ++)
        {
            objEntry = objSection.EntryList[j];
            if(!dicEntry.Exists(objEntry.RowID))
                dicEntry.Add(objEntry.RowID, objEntry);
        }
    }
   // a();
    arryGrade = GetGradeByRuleId("MethodGetGradeByRuleId", objCurrRule.RowID , "Y");
}

function LoadDictionary()
{
	var arryResponsibilityDic = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag",
		"Responsibility", "Y");
	var arryErrTypeDic = GetDHCWMRDictionaryArryByTypeFlag("MethodGetDHCWMRDictionaryArryByTypeFlag",
		"ErrorType", "Y");
		
	var objItm = null;
	for(var i = 0; i < arryResponsibilityDic.length; i ++)
	{
		objItm = arryResponsibilityDic[i];
		objResponsibilityDic.Add(objItm.RowID, objItm);
	}
	for(var i = 0; i < arryErrTypeDic.length; i ++)
	{
		objItm = arryErrTypeDic[i];
		objErrTypeDic.Add(objItm.RowID, objItm);
	}	
}

//use java applet to display evaluation rule
function DisplayExamRule()
{
	//window.alert("AAA");
	var strRule = SerializeExamRuleForApplet(objCurrRule, objCurrRule.RuleDic);
	var strSection = SerializeExamSectionForApplet(objCurrRule);
	//a();
	var strEntry = SerializeExamEntryForApplet(objCurrRule);
	EvaluationApp.SetExamRule(strRule, appletFieldSplit);
	EvaluationApp.SetExamSection(strSection, appletFieldSplit, appletRowSplit);
	EvaluationApp.SetExamEntry(strEntry, appletFieldSplit, appletRowSplit);
	EvaluationApp.DisplayRule();
}

//display problem list table
function ShowProblemList()
{
    var strColName = "编号<field>问题<field>范畴<field>数量<field>金额<field>责任人<field>所在科室<field>责任人类型";
    var strLines = "";
}

//obtain medical record infomation
//param:medical record no returned by java applet
function ProcessRequestPatientInfo(MrNo)
{
    var objMain = GetDHCWMRMainByMrNo("MethodGetDHCWMRMainByMrNo", strMrTypeParam, MrNo, "Y");
    var strPatient = "";
    var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MrEvalation.VolList&MrType=" + strMrTypeParam + "&MrNo=" + MrNo;
    //window.alert(MrNo);
    if(objMain != null)
    {
    	strPatient = objMain.RowID;
    	window.open(strUrl, "_Blank", "height=400,width=700,left=300,top=100,status=yes,toolbar=no,menubar=no,location=no"); 
    }
    else
    {
	    window.alert(t["PatientNotFound"]);
    }
    return strPatient;
}

//display patient baseinfomation (transfer data to java applet)
function DisplayPatientBaseInfo(VolumeID)
{
	var strInfo = FormatPatientBaseInfo(VolumeID);
	if(strInfo == "")
		return;
	EvaluationApp.DisplayPatientBaseInfo(GetCode(strInfo, CHR_2), GetDesc(strInfo, CHR_2));
}

//format patient infomation
function FormatPatientBaseInfo(VolumeID)
{	
	var strInfo = "";
	objCurrVolume = GetDHCWMRMainVolumeByID("MethodGetDHCWMRMainVolumeByID", VolumeID)
	objCurrMain = GetDHCWMRMainByID("MethodGetDHCWMRMainByID",  objCurrVolume.Main_Dr);
	objCurrPatient = GetPatientInfoByMrRowID("MethodGetPatientInfoByMrRowID", objCurrMain.RowID);
	if(objCurrVolume == null)
	{
		objCurrVolume = null;
		objCurrMain = null;
		objCurrPatient = null;
		window.alert(t["PatientNotFound"]);
		return "";
	}
	strInfo += t["MrNo"] + objCurrMain.MRNO + "\n";
	strInfo += t["PatientName"] + objCurrPatient.PatientName + "\n";
	strInfo += t["Sex"] + objCurrPatient.Sex + "\n";
	strInfo += t["Age"] + objCurrPatient.Age + "\n";
	
	
	if(objCurrVolume.Paadm_Dr != "")
	{
		strInfo += FormatHISAdm(objCurrVolume.Paadm_Dr);
	}
	else
	{
		strInfo += FormatHistoryAdm(objCurrVolume.HistroyAdm_Dr);
	}
	return strInfo + "\n" + CHR_2 + objCurrMain.MRNO
}

function FormatHISAdm(admID)
{
	var objAdm = GetPatientAdmitInfo("MethodGetPatientAdmitInfo", admID);
	return t["AdmitDate"] + objAdm.AdmDate + "\n" +
			t["AdmitDep"] + objAdm.WardDesc + "\n" +
			t["DischargeDate"] + objAdm.DischgDate + "\n" +
			t["DischargeDep"] + objAdm.WardDesc;
}

function FormatHistoryAdm(admID)
{
	var objAdm = GetDHCWMRHistoryAdm("MethodGetDHCWMRHistoryAdmByID", admID);
	return t["AdmitDate"] + objAdm.AdmitDate + "\n" +
			t["AdmitDep"] + objAdm.AdmitDep + "\n" +
			t["DischargeDate"] + objAdm.DischargeDate + "\n" +
			t["DischargeDep"] + objAdm.DischargeDep;
}


//fired when user click an evaluation entry
function EventDoubleClickEntry(EntryID)
{
	var strUrl = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.MrEvalation.AddProblem&EntryID=" + EntryID;
	//window.alert(strUrl);
	window.open(strUrl, "_Blank", "height=550,width=400,left=300,top=100,status=yes,toolbar=no,menubar=no,location=no");
	
	return "======";
}


//-------------for AddProblem evoke-----------
//return doctor list, EntryID indicate that whether the doctor infracted the entry
function GetDicDoctorList(EntryID)
{
	var arryDoctor = objDicDoctor.Items().toArray();
	var str = "";
	var objDoctor = null;
	var objDetail = null;
	var strKey = "";
	//a();
	for(var i = 0; i < arryDoctor.length; i ++)
	{
		objDoctor = arryDoctor[i];
		strKey = GetProblemKey(EntryID, objDoctor.RowID, objDoctor.Department.RowID);
		if(dicProblem.Exists(strKey))
		{
			objDetail = dicProblem.Item(strKey);
			str += objDoctor.RowID + CHR_Up + objDoctor.UserName + "     " + objDetail.Number + t["Times"]  + CHR_Up + "Y" + CHR_1;
		}	
		else
		{
			str += objDoctor.RowID + CHR_Up + objDoctor.UserName + "     "  + CHR_Up + "N" + CHR_1;
		}
	}	
	return str;
}

//select doctor infoamtion 
function SelectedDoctor(EntryID, strDetail, strPeople)
{
	var objDetail = null;
	var objPeople = null;
	var arryPeople = new Array();
	var arryTmp = strPeople.split(CHR_1);
	var objUser = null;
	var objDep = null;
	var blnFound = false;
	var strKey = "";
	var arryInfo = null;
	var objDoctor = null;
	//a();
	objDetail = BuildDHCWMRExamRDtl(strDetail);
	
	for(var i = 0; i < arryTmp.length; i ++)
	{
		if(arryTmp[i] == "")
			continue;
		arryInfo = arryTmp[i].split(CHR_2);
		objPeople = BuildDHCWMRExamRDtlPeople(arryInfo[0]);
		objDep = BuildDepartment(arryInfo[1]);
		objPeople.Department = objDep;
		strKey = GetProblemKey(EntryID, objPeople.EmployeeDr, objDep.RowID);
		if(dicProblem.Exists(strKey))
			objDetail = dicProblem.Item(strKey);
		else
			objDetail = BuildDHCWMRExamRDtl(strDetail);
		
		if(objPeople.EmployeeDr != "")
		{
			objUser = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", objPeople.EmployeeDr);
			objPeople.User = objUser;//add detail user info to responsibility
		}
		else
		{
			objPeople.User = DHCWMRUser();//if there is no user info ,add an empity info
			objPeople.User.RowID = "Dep-" + objDep.RowID;
			objPeople.User.Code = objDep.Code;
			objPeople.User.UserName = objDep.Name;
			objPeople.User.Department = objDep;
		}
		if(objDetail.ErrType != "")
			objDetail.ErrTypeDic = objErrTypeDic.Item(objDetail.ErrType);
		if(objPeople.RSbilityDr !="")
			objPeople.RSbilityDic = objResponsibilityDic.Item(objPeople.RSbilityDr);
		objDetail.Entry = dicEntry.Item(objDetail.EntryDr);
		objDetail.Section = dicSection.Item(objDetail.Entry.Parref);
		if(!objDicDoctor.Exists(objPeople.User.RowID))//add doctor to doctor list
		{
			objPeople.User.Cnt = 1;
			objDicDoctor.Add(objPeople.User.RowID, objPeople.User);
		}
		else
		{
			objUser = objDicDoctor.Item(objPeople.User.RowID);
			objUser.Cnt ++;
		}
		objDetail.DoctorList.push(objPeople);
		if(!dicProblem.Exists(strKey))
		{
			dicProblem.Add(strKey, objDetail);
		}		
	}
	//if(!blnFound)
		arryProblem.push(objDetail);
}

//remove doctor info form doctor list
function RemoveDoctorFromList(EntryID, EmployeeID, Location)
{
	var objDetail = null;
	var objEmployee = null;
	var objUser = null;
	var strKey = GetProblemKey(EntryID, EmployeeID, Location);
	//a();
	if(!dicProblem.Exists(strKey))
		return;
	objDetail = dicProblem.Item(strKey);
	if(objDetail == null)
	{
		window.alert(t["NotInTheProblemList"]);
		return;
	}
	for(var i = 0; i < objDetail.DoctorList.length; i ++)
	{
		objEmployee = objDetail.DoctorList[i];
		if(EmployeeID.indexOf("Dep-") < 0)
		{
			if(objEmployee.EmployeeDr == EmployeeID)
			{
				objDetail.DoctorList.splice(i, 1);//remove doctor
				if(objDicDoctor.Exists(EmployeeID))
				{
					objUser = objDicDoctor.Item(EmployeeID);
					objUser.Cnt --;
					if(objUser.Cnt == 0)
						objDicDoctor.Remove(EmployeeID);
				}
				break;
			}
		}
		else
		{
			if(objEmployee.CtLocDr == GetDesc(EmployeeID, "-"))
			{
				objDetail.DoctorList.splice(i, 1);//remove doctor
				if(objDicDoctor.Exists(EmployeeID))
				{
					objUser = objDicDoctor.Item(EmployeeID);
					objUser.Cnt --;
					if(objUser.Cnt == 0)
						objDicDoctor.Remove(EmployeeID);
				}
				break;
			}			
		}
	}
	if(dicProblem.Exists(strKey))
		dicProblem.Remove(strKey);
	for(var i = 0; i < arryProblem.length; i ++)
	{
		if(arryProblem[i].DoctorList.length == 0)
			arryProblem.splice(i, 1);
	}
}

//finish evaluation
function FinishEvaluation()
{
	var strURL = "&ExamResultRowID=";
	var strRowID = "";
	var objResult = null;
	var strGradeTitle = "";
	if(!window.confirm(t["EnsureComplete"]))
		return;
	if(!ValidateContents())
		return;
	objResult = SaveExamResult();
	if(objResult != null)
	{
		//save successfual
		if(objResult.Grade != null)
			strGradeTitle = objResult.Grade.Title;
		/*
		window.alert(
			GetCode(FormatPatientBaseInfo(objCurrVolume.RowID), CHR_2) +
			t["Score"] + objResult.Score + "\n" + 
			t["Grade"] + strGradeTitle + "\n");
		*/ 
		window.alert(
			GetCode(FormatPatientBaseInfo(objCurrVolume.RowID), CHR_2) +
			"分数:" + objResult.Score + "\n" + 
			"等级:" + strGradeTitle + "\n");
		Clear();
		
		//window.open(strURL + strRowID, "_Blank", "height=400,width=700,status=yes,toolbar=no,menubar=no,location=no");
	}
	else
	{
		window.alert(t["SaveFailed"]);
	}
}

//cancel evaluation
function CancelEvaluation()
{
	if(!window.confirm("EnsureCancel"))
		return;
	Clear();
}

//check whether a doctor infracted a rule entry
function IsDoctorInTheList(EntryID, EmployeeID)
{
	return (dicProblem.Exsists(GetProblemKey(EntryID, EmployeeID) ? "Y" : "N"));
}

//fired when user click "Display Problem" button
function DisplayProblemList()
{
	//window.alert("AAAA");
	var str = SerializeExamDetailForApplet(arryProblem);
	var objApplet = document.getElementById("EvaluationApp");
	var strCol = t["ColNames"];
	var strData = SerializeExamDetailForApplet(arryProblem);
	objApplet.DisplayProblemList(strCol, strData, appletFieldSplit, appletRowSplit);
	/*if(arryProblem.length > 0)
	{
		objApplet.DisplayProblemList(strCol, strData, appletFieldSplit, appletRowSplit);
	}
	else
	{
		window.alert(t["EmptyList"]);
	}*/
}

//--------------------------------------------

function ValidateContents()
{
	if((objCurrPatient == null) || (objCurrVolume == null))
	{
		window.alert(t["SelectPatient"]);
		return false;
	}
	if(arryProblem.length == 0)//can evaluation pass by max score???
	{
		
	}
	return true;
}

function Clear()
{
	objCurrVolume = null;
	objCurrPatient = null;
	objCurrMain = null;
	objDicDoctor.RemoveAll();
	arryProblem = new Array();
	EvaluationApp.DisplayPatientBaseInfo("", "");

}

function HasVeto()
{
	var objDetail = null;
	var objEntry = null;
	for(var i = 0; i < arryProblem.length; i ++)
	{
		objDetail = arryProblem[i];
		objEntry = dicEntry.Item(objDetail.EntryDr);
		if(objEntry.EntryDic.Veto)
			return true;
	}
	return false;
}

//Calc score(add)
function CalcScoreMethod1()
{
	var objSection = null;
	var objDetail = null;
	var objEntry = null;
	var fltScore = 0;
	for(var i = 0; i < arryProblem.length; i ++)
	{
		objDetail = arryProblem[i];
		objEntry = dicEntry.Item(objDetail.EntryDr);
		objSection = dicSection.Item(objEntry.Parref);
		objSection.ActualScore += new Number(objEntry.Score);
	}
	var arrySection = dicSection.Items().toArray();
	for(var i = 0; i < arrySection.length; i ++)
	{
		objSection = arrySection[i];
		if(objSection.ActualScore > new Number(objSection.Score))
			objSection.ActualScore = new Number(objSection.Score);
		fltScore += objSection.ActualScore;
	}
	return fltScore;
}

//calc score (reduce)
function CalcScoreMethod2()
{
	var objSection = null;
	var objDetail = null;
	var objEntry = null;
	var fltScore = objCurrRule.MaxScore;
	for(var i = 0; i < arryProblem.length; i ++)
	{
		objDetail = arryProblem[i];
		objEntry = dicEntry.Item(objDetail.EntryDr);
		objSection = dicSection.Item(objEntry.Parref);
		objSection.ActualScore += new Number(objEntry.Score);
	}
	var arrySection = dicSection.Items().toArray();
	for(var i = 0; i < arrySection.length; i ++)
	{
		objSection = arrySection[i];
		if(objSection.ActualScore > new Number(objSection.Score))
			objSection.ActualScore = new Number(objSection.Score);
		fltScore -= objSection.ActualScore;
	}
	return fltScore;
}

function CalcScore(Method)
{
	var score = 0;
	var arrySection = dicSection.Items().toArray();

	for(var i = 0; i < arrySection.length; i ++)
	{
		arrySection[i].ActualScore = 0;	
	}	
	switch(Method)
	{
		case "Add":
			score = CalcScoreMethod1();
			break;
		case "Reduce":
			score = CalcScoreMethod2();
			break;
		default:
			break;
			
	}
	return score;
}

//calc actual score
//
function CalcActualScore(Method)
{
	var score = 0;
	switch(Method)
	{
		case "Add":
			score = CalcActualScoreMethod1();
			break;
		case "Reduce":
			score = CalcActualScoreMethod2();
			break;
		default:
			break;
			
	}
	return score;
}

function CalcActualScoreMethod1()
{
	var score = 0;
	var objProblem = null
	var fltScore = new Number(objCurrRule.MaxScore);
	for(var i = 0; i < arryProblem.length; i ++)
	{
		objProblem = arryProblem[i];
		score += new Number(objProblem.Score);
	}
	if(score > fltScore)
		score = fltScore;
	return score;
}

function CalcActualScoreMethod2()
{
	var score = 0;
	var objProblem = null;
	var fltScore = new Number(objCurrRule.MaxScore);
	score = fltScore;
	for(var i = 0; i < arryProblem.length; i ++)
	{
		objProblem = arryProblem[i];
		score -= new Number(objProblem.Score);
	}
	return score;
}

function CalcMoney(Grade, Score)
{
	var money = 0;
	var objProblem = null;
	var MoneyPerScore = 0;
	if(Grade != null)
		MoneyPerScore = new Number(Grade.Money);
	for(var i = 0; i < arryProblem.length; i ++)
	{
		objProblem = arryProblem[i];
		money += new Number(objProblem.Money);
		//money += MoneyPerScore * new Number(objProblem.Score);
	}
	money += MoneyPerScore * (new Number(objCurrRule.MaxScore) - new Number(Score));
	return money;
}

function GetGrade(Score)
{
	var objGrade = null;
	for(var i = arryGrade.length - 1; i >= 0; i --)
	{
		objGrade = arryGrade[i];
		if(Score >= objGrade.MinScore)
			return objGrade;
	}
	return null;
}

function SaveExamResultToObject()
{
	var objResult =  DHCWMRExamResult();
	var objGrade = null;
	//a();
	objResult.VolumeID = objCurrVolume.RowID;
	objResult.RuleDr = objCurrRule.RowID;
	objResult.Veto = HasVeto();
	objResult.Score = CalcScore(objCurrRule.ScoreMethod);
	objResult.ActualScore = CalcActualScore(objCurrRule.ScoreMethod);
	objResult.IsPrimary = true;
	objGrade = GetGrade(objResult.Score);
	if(objGrade == null)
	{
		objResult.GradeDr = "";
	}
	else
	{
		objResult.GradeDr = objGrade.RowID;
		
	}
	objResult.Remind = false;
	objResult.Money = CalcMoney(objGrade, objResult.Score);
	objResult.SignUserDr = session['LOGON.USERID'];
	objResult.IsActive = true;
	objResult.Grade = objGrade;
	return objResult;
}

function SaveExamDetailString()
{
	var str = "";
	var objDetail = null;
	var objPeople = null;
	var strLine = "";
	for(var i = 0; i < arryProblem.length; i ++)
	{
		objDetail = arryProblem[i];
		strLine = SerializeDHCWMRExamRDtl(objDetail) + CHR_2;
		for(var j = 0; j < objDetail.DoctorList.length; j ++)
		{
			objPeople = objDetail.DoctorList[j];
			strLine += SerializeDHCWMRExamRDtlPeople(objPeople) + CHR_3;
		}
		str += strLine;
		if(str != "")
			str += CHR_1;
	}
	return str;
}

function SaveExamResult()
{
	var objResult = SaveExamResultToObject();
	var strResult = SerializeDHCWMRExamResult(objResult);
	var strDetail = "";
	var strRowID = "";
	a();
	strDetail = SaveExamDetailString();	
	strRowID = SaveDHCWMRExamResult("MethodSaveDHCWMRExamResult", strResult ,strDetail);
	if(new Number(strRowID) > 0)
	{
		objResult.RowID = strRowID;
		return objResult;
	}
	else
	{
		return null;
	}
}



function InitForm()
{
	var strApplet = "<APPLET ID = 'EvaluationApp' Name = 'EvaluationApp' codebase = '../addins/java' code = 'com/dhcc/wmr/qualityctl/Evaluation/EvaluationPanel.class' width = '900' height	= '600' >";
    var strAppletJSCaller = "<APPLET ID = 'JSCaller' Name = 'JSCaller' codebase = '../addins/java' code = 'com/dhcc/wmr/qualityctl/utilty/JSCaller.class' width = '0' height	= '0' >";
    LoadExamRule();
    LoadDictionary();
    var objTable = document.getElementsByTagName("table")[1];
    objTable.rows[1].cells[0].appendChild(document.createElement(strApplet));
    objTable.rows[1].cells[0].appendChild(document.createElement(strAppletJSCaller));
}

function InitEvents()
{
	
}


InitForm();
InitEvents();
