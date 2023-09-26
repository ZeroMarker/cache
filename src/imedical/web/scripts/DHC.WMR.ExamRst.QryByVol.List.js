//Event Handler for DHC.WMR.ExamRst.QryByVol.List
//Create By LiYang 2008-10-31


function btnSaveOnClick() {
    var objTable = document.getElementById("tDHC_WMR_ExamRst_QryByVol_List");
    var objResult = null;
    for (var i = 1; i < objTable.rows.length; i++) {
        objResult = GetDHCWMRExamResultByID("MethodGetDHCWMRExamResultByID", getElementValue("ExamRstRowidz" + i));
        objResult.IsPrimary = getElementValue("IsPrimaryz" + i);
        SaveDHCWMRExamResult("MethodSaveDHCWMRExamResult", SerializeDHCWMRExamResult(objResult), "");
    }
    window.alert(t["SaveOK"]);
}

function btnCloseOnClick() {
    window.close();
}


function btnCheckAgainOnClick()
{
    window.returnValue = true;
    window.close();
}

function btnShowDetail()
{
	var ControlID = window.event.srcElement.id;
	var strIndex = ReplaceText(ControlID, "btnShowResultz", ""); 
	var strResultID = getElementValue("ExamRstRowidz" + strIndex);
	var strURL = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.ExamDetail&ResultID=" + strResultID;
	window.showModalDialog(strURL, "", "dialogHeight:300;dialogWidth:500;center:yes");
}

function InitForm() {
	if(!HasPower("MethodHasPower", session['LOGON.GROUPID'], "ModifyIsPrimaryExamResult")) //Check User Power
	{
		document.getElementById("btnSave").style.visibility="hidden"; 	
	}
	if( !HasPower("MethodHasPower", session['LOGON.GROUPID'], "ReviewExamResult")) //Check User Power
	{
		document.getElementById("btnCheckAgain").style.visibility="hidden"; 	
	}	
  InitEvents();
}




function InitEvents() {
    document.getElementById("btnSave").onclick = btnSaveOnClick;
    document.getElementById("btnClose").onclick = btnCloseOnClick;
    document.getElementById("btnCheckAgain").onclick = btnCheckAgainOnClick;
    /*var objTable = document.getElementById("tDHC_WMR_ExamRst_QryByVol_List");
		var objBtn = null;
		for(var i = 1; i < objTable.rows.length; i ++)
		{
			objBtn = document.getElementById("btnShowResultz" + i);	
			objBtn.onclick = btnShowDetail;
		}*/
}

window.onload = InitForm;