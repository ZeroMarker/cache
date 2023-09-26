//DHC.WMR.MrEvalation.AddProblem Event Handler
//20070908 By LiYang
//

var objResponsibilityDic = new ActiveXObject("Scripting.Dictionary");
var objErrTypeDic = new ActiveXObject("Scripting.Dictionary");
var objCurrEntry = null;
var objJSCaller = null;
var objArryPeople = new Array();


var objCurrDoctor = null;

function LookupDoctor(str)
{
	var arryTmp = str.split(CHR_Up);
	objCurrDoctor = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", arryTmp[0]);
	setElementValue("txtDoctor", arryTmp[2]);
	setElementValue("txtDoctorDr", arryTmp[0]);
	setElementValue("txtLocationDr", objCurrDoctor.Location.RowID);
}

function LookupLoc(str)
{
	var arryTmp = str.split(CHR_Up);
	setElementValue("txtLocation", arryTmp[2]);
	setElementValue("txtLocationDr", arryTmp[0]);
}

function btnRemoveOnClick()
{
	var strEmployeeID = getElementValue("lstPeople");
	if(objCurrDoctor == null)
	{
		window.alert(t["ChooseDoctor"]);
		return;
	}
	//a();
	objJSCaller.ClearArg();
	objJSCaller.AddArg(objCurrEntry.RowID);
	objJSCaller.AddArg(getElementValue("txtDoctorDr")); //Modified By LiYang 2009-3-9 use doctors' location instead department
	objJSCaller.AddArg(getElementValue("txtLocationDr"));
	/*if(objCurrDoctor.RowID.indexOf("Dep-") < 0)
		objJSCaller.AddArg(objCurrDoctor.Location.RowID); //Modified By LiYang 2009-3-9 use doctors' location instead department
	else
		objJSCaller.AddArg(GetDesc(objCurrDoctor.RowID, "-"));*/
	objJSCaller.Call("RemoveDoctorFromList");
	DisplayDoctorList();
}

function btnAddOnClick() {
    if (getElementValue("txtDoctor") == "") { //Modified By LiYang 2009-3-9 When user clear doctor input box, clear last choice
        setElementValue("txtDoctor", "");
        setElementValue("txtDoctorDr", "");
        objCurrDoctor = null;
    }
	if(!ValidateContents())
		return;
    var objPeople = SavePeopleObject();
    objArryPeople = new Array(); //Modified By LiYang 2009-3-9
	objArryPeople.push(objPeople);
	ReturnSelectionInfo();
	DisplayDoctorList();//Add By LiYang 2009-3-6 Refresh Doctor List when add problem
	//window.close(); Modified By LiYang 2009-3-5 they want to keep window in order to input another problem
}

function lstPeopleOnClick()
{
	var strDoctorID = getElementValue("lstPeople");
	var objListPeople = document.getElementById("lstPeople");
	var objItm = null;
	if(strDoctorID == "")
		return;
	//a();
    objCurrDoctor = GetDHCWMRUserByID("MethodGetDHCWMRUserByID", strDoctorID);
    setElementValue("txtDoctor", "");
    setElementValue("txtDoctorDr", "");
    setElementValue("txtLocationDr", "");
    setElementValue("txtLocation", "");
	if(strDoctorID.indexOf("Dep-") == -1)
	{
		setElementValue("txtDoctor", objCurrDoctor.UserName);
		setElementValue("txtDoctorDr", objCurrDoctor.RowID);
		setElementValue("txtLocationDr", objCurrDoctor.Location.RowID); //Add By LiYang 2009-3-9 Record doctor's location
	}
	else
	{
		objItm = objListPeople.options.item(objListPeople.selectedIndex);
		setElementValue("txtLocationDr", GetDesc(strDoctorID, "-"));
		setElementValue("txtLocation", GetCode(objItm.innerText, " "));
	}
}

function btnCloseOnClick()
{
	window.close();
}

//here program will tranfer selected responsibility to javascript of parent page
function ReturnSelectionInfo()
{
	//a();
	var objDetail = SaveDetailToObject();
	var objPeople = null;
	var strDetail = SerializeDHCWMRExamRDtl(objDetail);
	var strPeople = "";
	var strDep = ""
	for(var i = 0; i < objArryPeople.length; i ++)
	{
		strPeople += SerializeDHCWMRExamRDtlPeopleForBuild(objArryPeople[i]) + CHR_2 + SerializeDepartment(objArryPeople[i].Department) + CHR_1;  //Modified By LiYang 2009-3-9 
	}
	objJSCaller.ClearArg();
	objJSCaller.AddArg(objCurrEntry.RowID);
	objJSCaller.AddArg(strDetail);
	objJSCaller.AddArg(strPeople);
	objJSCaller.Call("SelectedDoctor");
}

function ValidateContents()
{
	if((getElementValue("txtDoctorDr") == "") && (getElementValue("txtLocationDr") == ""))
	{
		window.alert(t["RequireResponsibility"]);
		return false;
	}
	if(getElementValue("txtDoctorDr") != "")
	{
		objJSCaller.AddArg(objCurrEntry.RowID);
		objJSCaller.AddArg(getElementValue("txtDoctorDr"));
		objJSCaller.AddArg(getElementValue("txtLocationDr"));  //Modified By LiYang 2009-3-9
		if(objJSCaller.Call("IsDoctorInTheList") == "Y")
		{
			window.alert(t["DoctorExsists"]);
			return false;
		}
	}
	if(isNaN(getElementValue("txtNumber")))
	{
		window.alert(t["InputNumber"]);
		return false;
	}
	return true;	
}

//Save problem information to object
function SaveDetailToObject()
{
	var objDetail = DHCWMRExamRDtl();
	objDetail.EntryDr = objCurrEntry.RowID;
	objDetail.Number = getElementValue("txtNumber");
	objDetail.Score = objCurrEntry.Score * objDetail.Number;
	objDetail.TriggerDate = getElementValue("txtTriggerDate");
	objDetail.ErrType = getElementValue("cboErrType");
	objDetail.IsActive = true;
	objDetail.ResumeText = getElementValue("txtResume");
	return objDetail;
}

//save responsibility information
function SavePeopleObject()
{
	var objPeople = DHCWMRExamRDtlPeople();
	objPeople.EmployeeDr = getElementValue("txtDoctorDr");
	objPeople.RSbilityDr = getElementValue("cboResponsibility");
	objPeople.CtLocDr = getElementValue("txtLocationDr");
	objPeople.IsActive = true;
	objPeople.ResumeText = "";
	if (getElementValue("txtDoctorDr") != "")
	{
	    objPeople.Department = objCurrDoctor.Location; //Modified By LiYang 2009-3-9 Use the same department source
		objPeople.CtLocDr = objCurrDoctor.Location.RowID;
	}
	else
	{
		objPeople.Department = new Object();
		objPeople.Department.RowID = getElementValue("txtLocationDr");
		objPeople.Department.Code = getElementValue("txtLocationDr");
		objPeople.Department.Name = getElementValue("txtLocation");
		//objPeople.EmployeeDr = "Dep-" + getElementValue("txtLocationDr");
	}
	return objPeople;
}

//for deserialize
function SerializeDHCWMRExamRDtlPeopleForBuild(obj)
{
	//a();
    if(obj == null)
        return "";
   var str = ""; 
   str +=  obj.Parref + CHR_Up;//
   //str +=  obj.Parref + CHR_Up;//	DHC_WMR_ExamRDtl
   //str +=  obj.ChildSub + CHR_Up;//	
   str +=  obj.EmployeeDr + CHR_Up;//	responsibility
   str +=  obj.RSbilityDr + CHR_Up;//	responsibility type
   str +=  obj.CtLocDr + CHR_Up;//	location
   str +=  obj.IsActive = (obj.IsActive ? "Y" : "N");//	is active
   str +=  obj.ResumeText + CHR_Up;//	resume text
   return str; 
}

function DisplayDictionary()
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
		AddListItem("cboResponsibility", objItm.Description, objItm.RowID);
	}
	for(var i = 0; i < arryErrTypeDic.length; i ++)
	{
		objItm = arryErrTypeDic[i];
		objErrTypeDic.Add(objItm.RowID, objItm);
		AddListItem("cboErrType", objItm.Description, objItm.RowID);
	}	
	
}


function DisplayDoctorList()
{
	//a();
	objJSCaller.ClearArg();
	objJSCaller.AddArg(objCurrEntry.RowID);
	var strDoctor = objJSCaller.Call("GetDicDoctorList");
	var arryDoctor = strDoctor.split(CHR_1);
	var strTmp = null;
	var objItm = null;
	ClearListBox("lstPeople");
	for(var i = 0; i < arryDoctor.length; i ++)
	{
		if(arryDoctor[i] == "")
			continue;
		strTmp = arryDoctor[i].split(CHR_Up);
		objItm = AddListItem("lstPeople", strTmp[1], strTmp[0]);
		if(strTmp[2] == "Y")
			objItm.style.color = "red";
		else
			objItm.style.color = "black";
	}
}

function initForm()
{
	objJSCaller = window.opener.document.getElementById("JSCaller");
	MakeComboBox("cboResponsibility");
	MakeComboBox("cboErrType");
	objCurrEntry = GetExamEntryById("MethodGetExamEntryById", GetParam(window, "EntryID"));
	if(objCurrEntry == null)
	{
		window.alert("Param Error: Entry!!!!!");
		return;
	}
	setElementValue("lblProblem", objCurrEntry.EntryDic.Title);
	DisplayDictionary();
	DisplayDoctorList();
	
	setElementValue("cboResponsibility", objCurrEntry.RSbilityDr);//initate Responsibility
	setElementValue("txtNumber", "1");
	if(!objCurrEntry.MultiErr)
		document.getElementById("txtNumber").readOnly = true;
	
}

function initEvent()
{
	document.getElementById("btnAdd").onclick = btnAddOnClick;
	document.getElementById("btnClose").onclick = btnCloseOnClick;
	document.getElementById("btnRemove").onclick = btnRemoveOnClick;
	document.getElementById("lstPeople").onclick = lstPeopleOnClick;
}

initForm();
initEvent();