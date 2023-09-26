/* =========================================================================

JavaScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.InputHistory

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-7

COMMENT: DHC.WMR.InputHistory event handler

============================================================================ */
var objMrType = null;//Medcal record type
var ArryStep = new Array(); //
var objTable = null;

var intAdmitDatePos = 0;
var intDischargeDatePos = 0;
var intDiagnosePos = 0; 
var returnValue = false;


var objCurrentMain = null;
var objCurrentHistory = null;
var objDicAdm = new ActiveXObject("Scripting.Dictionary");

var tmpChinese;
function GetChinese(MethodName,Ind)
{
	var strMethod = document.getElementById(MethodName).value;
	var ret = cspRunServerMethod(strMethod,Ind);
	var tmp=ret.split("^");
	return tmp;
}
tmpChinese=GetChinese("MethodChinese","InputHistory");
//alert(tmpChinese[0]+"||"+tmpChinese[1]+"||"+tmpChinese[2]);

function ProcessKey()
{
	var obj = null;
	strControlID = window.event.srcElement.id;
	switch(window.event.keyCode)
	{
		case 13://return key
		case 40://,down key
			for(var i = 0; i < ArryStep.length - 1; i ++)
			{
				obj = ArryStep[i];
				if(obj.id == strControlID)
				{
					switch(obj.id)
					{
						case "txtDepartment":
							if((Trim(obj.value) != "") && (window.event.keyCode != 40))
							{
								DisplayEditRow(
									"",
									"",
									getElementValue("txtDepartment"),
									"",
									getElementValue("txtDepartment"), 
									"");
								obj.select();
								//setElementValue("txtDepartment", "");
								i = 999999;//jump out loop
							}
							else
							{
								obj = ArryStep[i + 1];
								obj.focus();
							}
							break;
					
						case "txtAdmitDate":
						case "txtDischargeDate":
						case "txtDiagnose":
							if(obj.value == "")
							{
								obj = ArryStep[i + 1];
								obj.focus();								
								i = 999999;
								break;
							}
							returnValue = ProcessInput(strControlID, getElementValue(strControlID));
							if(obj.id != "txtDiagnose")
							{
								//setElementValue(strControlID, "");
								setElementValue(strControlID, window.event.srcElement.value);
								window.event.srcElement.value = "";
							}
							else
							{
								document.getElementById(strControlID).select();
							}
							if(!returnValue)
							{
								obj = ArryStep[i + 1];
								obj.focus();
								i = 999999;	
							}
							break;
						default:
							obj = ArryStep[i + 1];
							obj.focus();
							break;		
					}
				}
			}				
			break;
		case 38: //up key
			for(var i = ArryStep.length - 1; i > 0; i --)
			{
				obj = ArryStep[i];
				if(obj.id == window.event.srcElement.id)
				{
					obj = ArryStep[i - 1];
					obj.focus();
					break;
				}
			}				
			break;			
		default:
			//window.alert(window.event.keyCode);
			break;
	}
}

function AddToControlArry(objControl)
{
	if(objControl != null)
	{
		ArryStep.push(objControl);
		objControl.onkeydown = ProcessKey;
	}
}

function CreateTable()
{
	var arryTable = document.getElementsByTagName("table");
	objTable = arryTable[3];
}



function ProcessInput(ControlID, NewValue)
{
	var arry = document.getElementsByName(ControlID + "G");
	var objControl = null;
	var intPos = 0;
	switch(ControlID)
	{
		case "txtAdmitDate":
			intPos = intAdmitDatePos;
			try
			{
				NewValue = GetDateFromString(NewValue);
			}
			catch(err)
			{
				window.alert(err.description);
				return true;
			}
			intAdmitDatePos ++;
			break;
		case "txtDischargeDate":
			intPos = intDischargeDatePos;
			try
			{
				NewValue = GetDateFromString(NewValue);
			}
			catch(err)
			{
				window.alert(err.description);
				return true;
			}
			intDischargeDatePos ++;
			break;
		case "txtDiagnose":
			intPos = intDiagnosePos;
			intDiagnosePos ++;
			break;
	}
	if(intPos < arry.length)
	{
		arry[intPos].value = NewValue;
		if(intPos < (arry.length - 1))
		{
			return true;
		}
		else
		{
			return false;
		}
	}
	else
	{
		return false;
	}
}

function ValidateContents()
{
	var objArryAdmitDate = document.getElementsByName("txtAdmitDateG");
	var objArryDisDate = document.getElementsByName("txtDischargeDateG");
	var obj = null;
   	if(Trim(getElementValue("txtMrID"))== "")
   	{
 	    window.alert(t["InputMrNO"]);
  	    return false; 
   	}    
   	if(Trim(getElementValue("txtName"))== "")
	{
		window.alert(t["InputName"]);
		return false; 
	}
 	for(var i = 0; i < objArryAdmitDate.length; i ++)
 	{
	 	obj = objArryAdmitDate[i];
	 	try
	 	{
		 	GetDateFromString(obj.value);
	 	}
	 	catch(err)
	 	{
		 	window.alert(err.description);
		 	return false;
	 	}
	}    
	for(var i = 0; i < objArryDisDate.length; i ++)
 	{
	 	obj = objArryDisDate[i];
	 	try
	 	{
		 	objArryDisDate(obj.value);
	 	}
	 	catch(err)
	 	{
		 	window.alert(err.description);
		 	return false;
	 	}
	}    
   return true; 
}

function SaveHistoryInfoToObject()
{
    if(objCurrentHistory == null)
        objCurrentHistory = DHCWMRHistory();
    objCurrentHistory.PatientName = getElementValue("txtName" );
    objCurrentHistory.NameSpell = GetPinYin(objCurrentHistory.PatientName);
	objCurrentHistory.Sex = getElementValue("txtSex");
	objCurrentHistory.Age = getElementValue("txtAge");
	objCurrentHistory.City = getElementValue("txtNativePlace");
	objCurrentHistory.Company = getElementValue("txtCompany");
	objCurrentHistory.CompanyZip = getElementValue("txtCompanyZip");
	objCurrentHistory.HomeAddress = getElementValue("txtAddress");
	objCurrentHistory.HomeZip = getElementValue("txtHomeZip");
}

function SaveHistoryAdmArryToObject()
{
    var objArry = new Array();
    var arryAdmitDate = document.getElementsByName("txtAdmitDateG");
    var arryAdmitDep = document.getElementsByName("txtAdmitDeG");
    var arryDisDate = document.getElementsByName("txtDischargeDateG");
    var arryDisDep = document.getElementsByName("txtDischargeDepG");
    var arryDiagnose = document.getElementsByName("txtDiagnoseG");
    var obj = null;
    
    for(var i = 0; i < arryAdmitDate.length; i ++)
   {
         obj = new Object();
         obj.AdmitDate = arryAdmitDate[i].value;	//patient admit date
         obj.AdmitTime = "";	//admit time
         obj.AdmitDep = arryAdmitDep[i].value;	//admit department
         obj.AdmitStatus = "0";	//admit status
         obj.DischargeDate = arryDisDate[i].value;	//discharge date
         obj.DischargeTime = "";	//discharge time
         obj.DischargeDep = arryDisDep[i].value;	//discharge department
         obj.Diagnose = arryDiagnose[i].value;	//diagnose        
         objArry.push(obj);
    } 
   return objArry;
}

//Display base information
//objMain Medical Record Main Information
function DisplayInfo(objMain)
{
	intAdmitDatePos = 0;
	intDischargeDatePos = 0;
	intDiagnosePos = 0; 
	if(objMain == null)
	{
		//setElementValue("txtName", "");
		setElementValue("txtSex", "");
		setElementValue("txtAge", "");
		setElementValue("txtNativePlace", "");
		setElementValue("txtCompany", "");
		setElementValue("txtCompanyZip", "");
		setElementValue("txtAddress", "");
		setElementValue("txtHomeZip", "");
		//setElementValue("txtMrID", "");
		while(objTable.rows.length > 1)
		{
		    objTable.deleteRow(1);
		}
	}
	else
	{
		var objVolume = null;
		var arryVolume = GetDHCWMRMainVolumeArryByMainID("MethodGetVolumeArry", objMain.RowID); //Volume List
		var objCurrentHistory = null;
		
		/*
		if(objMain.Papmi_Dr != "")
			objCurrentHistory = GetPatientByID("MethodGetPatInfo", objMain.Papmi_Dr);
		if(objMain.History_DR != "")
			objCurrentHistory = GetDHCWMRHistoryByID("MethodGetDHCWMRHistoryByID", objMain.History_DR);
		*/
		//update by zf 2008-05-30
		if (objMain.RowID!==""){
			objCurrentHistory=GetDHCWMRMainPatientTMP("MethodGetDHCWMRMainPatient",objMain.RowID);
		}
		if (objCurrentHistory==null){
			objCurrentHistory=DHCWMRMainPatientTMP();
		}
		if(objCurrentHistory.PatientName != ""){
			setElementValue("txtName", objCurrentHistory.PatientName);
		}
		setElementValue("txtSex", objCurrentHistory.Sex);
		setElementValue("txtAge", objCurrentHistory.Age);
		setElementValue("txtNativePlace", objCurrentHistory.City);
		setElementValue("txtCompany", objCurrentHistory.Company);
		setElementValue("txtCompanyZip", objCurrentHistory.CompanyZip);
		setElementValue("txtAddress", objCurrentHistory.HomeAddress);
		setElementValue("txtHomeZip", objCurrentHistory.HomeZip);
		while(objTable.rows.length > 1)
		{
		    objTable.deleteRow(1);
		}
	
		for(var i = 0; i < arryVolume.length; i ++)
		{
			objVolume = arryVolume[i];
			if(!objVolume.IsActive)
				continue;
			if(objVolume.Paadm_Dr != "")
			{
				DisplayHisAdm(objVolume.Paadm_Dr, objVolume.RowID);
			}
			if(objVolume.HistroyAdm_Dr != "")
			{
				DisplayMrAdm(objVolume.HistroyAdm_Dr, objVolume.RowID);
			}
		}
	}
	
}

//Display patient admit information of HIS
function DisplayHisAdm(paadm, VolID)
{
	var objAdm = GetPatientAdmitInfo("MethodGetAdmInfo", paadm);
	var strDiagnose = GetMrDiagnose("MethodGetMrDiagnose", paadm);
	if(objAdm != null)
	{
		DisplayReadOnlyRow(objAdm.AdmDate, 
			GetDesc(objAdm.LocDesc, "/"),
			objAdm.DischgDate,
			GetDesc(objAdm.LocDesc, "/"),
			(strDiagnose == null ? "" : strDiagnose),
			"");
	}
	return objAdm;
}

function DisplayMrAdm(historyAdmID, VolID)
{
	var objHisAdm = GetDHCWMRHistoryAdm("MethodGetHistoryAdm", historyAdmID)
	if(objHisAdm != null)
	{
		//if(!objHisAdm.IsActive)
		//	return;
			
		DisplayReadOnlyRow
		(			
		objHisAdm.AdmitDate, 
			objHisAdm.AdmitDep,
			objHisAdm.DischargeDate,
			objHisAdm.DischargeDep,
			objHisAdm.Diagnose,
			VolID
		);
//		DisplayEditRow(
//			objHisAdm.RowID,
//			objHisAdm.AdmitDate, 
//			objHisAdm.AdmitDep,
//			objHisAdm.DischargeDate,
//			objHisAdm.DischargeDep,
//			objHisAdm.Diagnose);
	}
}


function DisplayReadOnlyRow(admitDate, admitOffice, dischargeDate, dischargeDep, dischargeDiagnose, VolRowID)
{
	var objTR = objTable.insertRow();
	var objCell = null;
	var objTxt = null;
	var objDelButton = null;
	if(VolRowID == null)
		VolRowID = "";
	
	objCell = document.createElement("td");
	objCell.innerText = admitDate;
	objTR.appendChild(objCell);
	
	
	objCell = document.createElement("td");
	objCell.innerText = admitOffice;
	objTR.appendChild(objCell);
	
	objCell = document.createElement("td");
	objCell.innerText = dischargeDate;
	objTR.appendChild(objCell);
	
	objCell = document.createElement("td");
	objCell.innerText = dischargeDep;
	objTR.appendChild(objCell);

	objCell = document.createElement("td");
	objCell.innerText = dischargeDiagnose;
	objTR.appendChild(objCell);
	
	objCell = document.createElement("td");
	objDelButton = document.createElement("<input type='button' onClick='DeleteVol(" + VolRowID + ");' value=" + tmpChinese[0] + " />");
	objCell.appendChild(objDelButton);

	objTR.appendChild(objCell);
//	window.alert(objTable.rows.length);
}

function DisplayEditRow(ID, admitDate, admitOffice, dischargeDate, dischargeDep, dischargeDiagnose)
{
	var objTR = objTable.insertRow();
	var objCell = null;
	var objTxt = null;
	var objHidden = null;
	var objDelButton = null;
	
	objCell = document.createElement("td");
	objHidden = document.createElement("<input name='txtIDG' type='hidden' value='" + ID + ">");
	objTxt = document.createElement("<input name='txtAdmitDateG' type='text' onchange='txtDateLostFocus()' onblur='txtDateLostFocus()' value='" + admitDate + "' style='WIDTH: 100px'>");
	objCell.appendChild(objHidden);
	objCell.appendChild(objTxt);
	objTR.appendChild(objCell);
	
	
	objCell = document.createElement("td");
	objTxt = document.createElement("<input name='txtAdmitDeG' type='text' value='" + admitOffice + "' style='WIDTH: 100px'>");
	objCell.appendChild(objTxt);
	objTR.appendChild(objCell);
	
	objCell = document.createElement("td");
	objTxt = document.createElement("<input name='txtDischargeDateG' type='text' onchange='txtDateLostFocus()' onblur='txtDateLostFocus()'  value='" + dischargeDate + "' style='WIDTH: 100px'>");
	objCell.appendChild(objTxt);
	objTR.appendChild(objCell);
	
	objCell = document.createElement("td");
	objTxt = document.createElement("<input name='txtDischargeDepG' type='text' value='" + dischargeDep + "' style='WIDTH: 100px'>");
	objCell.appendChild(objTxt);
	objTR.appendChild(objCell);

	objCell = document.createElement("td");
	objTxt = document.createElement("<input name='txtDiagnoseG' type='text' value='" + dischargeDiagnose + "' style='WIDTH: 100px'>");
	objCell.appendChild(objTxt);
	objTR.appendChild(objCell);
	
	objCell = document.createElement("td");
	objDelButton = document.createElement("<input type='button' onClick='DeleteRow();' value='Delete' />");
	objCell.appendChild(objDelButton);
	objTR.appendChild(objCell);
}

function txtMrIDLostFocus()
{
	var strMrNo = "a";
	if(getElementValue("txtMrID") != "")
		strMrNo = getElementValue("txtMrID");
	objCurrentMain = GetDHCWMRMainByMrNo(
		"MethodGetDHCWMRMainByMrNo",
		GetParam(window, "MrType"),
		strMrNo,
		"Y");
//	if(objCurrentMain == null)
//	{
//	    objCurrentMain = DHCWMRMain();
//	}
	DisplayInfo(objCurrentMain);
	if(objCurrentMain == null)
	{
		objCurrentMain = DHCWMRMain();
		objCurrentMain.MRNO = getElementValue("txtMrID");
		objCurrentMain.MrType = GetParam(window, "MrType");
		objCurrentMain.IsDead = false;			//		IsDead?
		objCurrentMain.IsActive = true;			//		Is Active(not deleted)
		objCurrentMain.IsStayIn = false;			//		Is stay in
		
		
	}
	objCurrentMain.ResumeText = "MR";
}

function txtDateLostFocus()
{
	objTxt = window.event.srcElement;
	var strValue = "";
	try
	{
		strValue = GetDateFromString(objTxt.value);
		objTxt.value = strValue;
	}
	catch(err)
	{
		window.alert(err.description);
	}
}

function txtSexLostFocus()
{
    var strTmp  = getElementValue("txtSex");
    switch(strTmp)
    {
        case "1":
            setElementValue("txtSex", tmpChinese[1]);
            break;
        case "2":
            setElementValue("txtSex", tmpChinese[2]);
            break;
         case tmpChinese[1]:
         case tmpChinese[2]:
            break;
         default:
            window.alert(t["SexInCorrect"]); 
            break;
    }  
}

function txtGetFocus()
{
    window.event.srcElement.select();
}

function DeleteVol(VolRowID)
{	
	if(VolRowID != null)
	{
		if(VolRowID == "")
			return;
		if(window.confirm(t["ConfirmDelete"]))
		{
			objVolume = GetDHCWMRMainVolumeByID("MethodGetDHCWMRMainVolumeByID", VolRowID);
			objVolume.IsActive = false;
			SaveDHCWMRMainVolume("MethodSaveDHCWMRMainVolume", objVolume);
			DeleteRow();
		}
		else
		{
			return;
		}
	}
}

function DeleteRow()
{
	var objButton = window.event.srcElement;
	var intRowPos = 0;
	var objVolume = null;
	//if(rowIndex == null)
		 intRowPos = objButton.parentElement.parentElement.rowIndex; 
	objTable.deleteRow(intRowPos);
}

function SaveInfo()
{
	SaveHistoryInfoToObject();
	var objArryHistoryAdm = SaveHistoryAdmArryToObject();
	var strHistory = SerializeDHCWMRHistory(objCurrentHistory);
	var strMain = SerializeDHCWMRMain(objCurrentMain);
	var strHisAdm = SerializeHistoryVolArry(objArryHistoryAdm);    
	var ret = SaveHistory("MethodSaveHistory", strHistory, strMain, strHisAdm);
	if(ret== 0)
	{
        DisplayInfo(null);
        intAdmitDatePos = 0;
		intDischargeDatePos = 0;
		intDiagnosePos = 0; 
       	document.getElementById("txtMrID").focus(); 
	}
	else
	{	    
	    window.alert(ret);
	    window.alert(t["SaveFail"]); 
	}
	    
}

function cmdSaveOnClick()
{
	if(!ValidateContents())
		return;
    SaveInfo();
	
	
}

function initForm()
{
	objMrType = GetDHCWMRDictionaryByID("MedthodGetDHCWMRDictionaryByID", GetParam(window, "MrType"));
	if(objMrType == null)
	{
		return;
	}
	setElementValue("lblMrType", objMrType.Description);
	
	
	AddToControlArry(document.getElementById("txtMrID"));
	AddToControlArry(document.getElementById("txtName"));
	AddToControlArry(document.getElementById("txtSex"));
	AddToControlArry(document.getElementById("txtAge"));
	AddToControlArry(document.getElementById("txtNativePlace"));
	AddToControlArry(document.getElementById("txtDepartment"));
	AddToControlArry(document.getElementById("txtCompany"));
	AddToControlArry(document.getElementById("txtCompanyZip"));
	AddToControlArry(document.getElementById("txtAddress"));
	AddToControlArry(document.getElementById("txtHomeZip"));
	AddToControlArry(document.getElementById("txtAdmitDate"));
	AddToControlArry(document.getElementById("txtDischargeDate"));
	AddToControlArry(document.getElementById("txtDiagnose"));
	AddToControlArry(document.getElementById("cmdSave"));

	CreateTable();
}




function initEvent()
{
	document.getElementById("txtMrID").onblur = txtMrIDLostFocus;
	document.getElementById("txtSex").onblur = txtSexLostFocus;
	document.getElementById("cmdSave").onclick = cmdSaveOnClick;
	
	var objArry = document.getElementsByTagName("input");
	var obj = null;
	for(var i = 0; i < objArry.length; i ++)
	{
	    obj = objArry[i];
	   if(obj.id.indexOf("txt") >= 0)
	    obj.onfocus =  txtGetFocus;
	}
}

initForm();
initEvent();