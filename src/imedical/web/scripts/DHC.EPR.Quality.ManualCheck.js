function InitFrom() {
	SetPower();
	var obj=document.getElementById("btnOpenEntryTree");
	if (obj){obj.onclick=btnOpenEntryTree_onClick;}
	var obj=document.getElementById("txtDepartmentName");
	if (obj){obj.onchange=txtDepartmentName_onChange;}
	var obj=document.getElementById("txtEmployeeName");
	if (obj){obj.onchange=txtEmployeeName_onChange;}
	var obj=document.getElementById("txtEntryTitle");
	if (obj){obj.onchange=txtEntryTitle_onChange;}
	var obj=document.getElementById("btnSave");
	if (obj){obj.onclick=btnSave_onClick;}
	var obj=document.getElementById("btnDelete");
	if (obj){obj.onclick=btnDelete_onClick;}
	var obj=document.getElementById("chkAll");
	if (obj){obj.onclick=chkAll_onclick;}
	var obj=document.getElementById("BtnSendMessage");
	if (obj){obj.onclick=BtnSendMessage_onClick;}
}

function SetPower() 
{
    var SSGroupID = getElementValue("LOGON.GROUPID", null);
    var CTLocID = getElementValue("LOGON.CTLOCID", null);
    var obj = document.getElementById("MethodGetSettingBySSGroup");
    if (obj) { var encmeth = obj.value; } else { var encmeth = ""; }
    var ret = cspRunServerMethod(encmeth, SSGroupID, CTLocID);
    var tmpList = ret.split("^");
    if (tmpList.length >= 2) {
        setElementValue("txtRuleID", tmpList[0]);
        setElementValue("txtControlType", tmpList[1]);
        if (tmpList[1] == "0")			// Control
        {
            setElementValue("txtDepartmentID", "");
            setElementValue("txtDepartmentName", "");
            setElementDisabled("txtDepartmentName", false);
            setElementDisabled("txtEntryTitle", false);
            setElementDisabled("btnOpenEntryTree", false);
            setElementDisabled("btnDelete", false);
            setElementDisabled("btnSave", false);
        } else if (tmpList[1] == "1") {		// Remind
            //setElementDisabled("txtDepartmentName",true);
            setElementDisabled("txtEntryTitle", false);
            setElementDisabled("btnOpenEntryTree", false);
            setElementDisabled("btnDelete", true);
            setElementDisabled("btnSave", true);
        } else {							// Other
            setElementDisabled("txtDepartmentName", true);
            setElementDisabled("txtEntryTitle", true);
            setElementDisabled("btnOpenEntryTree", true);
            setElementDisabled("btnDelete", true);
            setElementDisabled("btnSave", true);
        }
    } else {								// Null 
        setElementDisabled("txtDepartmentName", true);
        setElementDisabled("txtEntryTitle", true);
        setElementDisabled("btnOpenEntryTree", true);
        setElementDisabled("btnSave", true);
        setElementDisabled("btnDelete", true);
    }
    var EpisodeID = getElementValue("txtEpisodeID", null);
    if (EpisodeID == "") {
        setElementDisabled("btnSave", true);
        setElementDisabled("btnDelete", true);
    }
    else {
        setElementDisabled("btnSave", false);
        setElementDisabled("btnDelete", false);
        var obj = document.getElementById("MethodGetPatientInfo");
        if (obj) { var encmeth = obj.value; } else { var encmeth = ""; }
        var ret = cspRunServerMethod(encmeth, EpisodeID);
        var result = ret.split("^");
        if (result.length >= 4) {
            setElementValue("txtDepartmentID", result[0]);
            setElementValue("txtDepartmentName", result[1]);
            setElementValue("txtEmployeeID", result[2]);
            setElementValue("txtEmployeeName", result[3]);
            setElementValue("txtPatientName", result[4]);
            setElementValue("txtRegNo", result[5]);
        }
    }
}

function chkAll_onclick() {
    var IsAll = getElementValue("chkAll", null);
    var objTable = document.getElementById("tDHC_EPR_Quality_ManualCheck");
    for (var Ind = 1; Ind < objTable.rows.length; Ind++) {
        var TSelected = getElementValue("TSelectedz" + Ind, null);
        if (IsAll == "Y") {
            setElementValue("TSelectedz" + Ind, "Y");
        } else {
            if (TSelected == "Y") {
                setElementValue("TSelectedz" + Ind, "N");
            } else {
                setElementValue("TSelectedz" + Ind, "Y");
            }
        }
    }
}

function btnSave_onClick() 
{
    //debugger;
    var EpisodeID = getElementValue("txtEpisodeID", null);
    var RuleID = getElementValue("txtRuleID", null);
    var SignUserID = getElementValue("LOGON.USERID", null);
    var EntryID = getElementValue("txtEntryID", null);
    var TriggerCount = getElementValue("txtTriggerCount", null);
    var TriggerDate = getElementValue("txtProblemDate", null);
    var ResumeText = getElementValue("txtDescription", null);
    var EmployeeID = getElementValue("txtEmployeeID", null);
    var LocID = getElementValue("txtDepartmentID", null);
    var obj = document.getElementById("MethodCheckSetManual");
    if (obj) { var strMethod = obj.value; } else { var strMethod = ""; }
    var flag = cspRunServerMethod(strMethod, EpisodeID);
    if (flag != "Y") {
        alert("请先勾选此患者并设置为手工检查病历!");
        return;
    }
    if (EntryID == "") { alert("请选择手工评估项目!"); return; }
    if (LocID == "" || EmployeeID == "") { alert("请选择责任科室和责任人!"); return; }
    var InitResult = EpisodeID + "^" + RuleID + "^" + EntryID + "^" + LocID + "^" + EmployeeID + "^" + SignUserID + "^" + TriggerCount + "^" + TriggerDate + "^" + ResumeText
    var obj = document.getElementById("MethodSaveManualResult");
    if (obj) { var strMethod = obj.value; } else { var strMethod = ""; }
    var ret = cspRunServerMethod(strMethod, InitResult);
    if (ret > 0) {
        window.parent.RPcenter.location.reload();
    } else {
        alert(t["SaveFail"]);
    } 
}

function btnDelete_onClick() {
    var ControlType = getElementValue("txtControlType", null);
    var SignUserID = getElementValue("LOGON.USERID", null);
    if (ControlType == "") return;
    var obj = document.getElementById("MethodDeleteManualResult");
    if (obj) { var strMethod = obj.value; } else { var strMethod = ""; }
    if (!strMethod) return;
    var objTable = window.parent.RPcenter.document.getElementById("tDHC_EPR_Quality_ManualCheck");
    var selCount = 0;
    var DetailRowIDs = "", IsFirstNode = 1;
    for (var Ind = 1; Ind <= objTable.rows.length; Ind++) {
        var CurSignUserID = window.parent.RPcenter.document.getElementById("TSignUserIDz" + Ind).value;
        if (CurSignUserID != SignUserID) continue;
        var TSelected = window.parent.RPcenter.document.getElementById("TSelectedz" + Ind).checked;
        var ResultID = window.parent.RPcenter.document.getElementById("TResultIDz" + Ind).value;
        var DetailID = window.parent.RPcenter.document.getElementById("TDetailIDz" + Ind).value;
        var RowID = ResultID + "||" + DetailID
        if (TSelected) {
            selCount++;
            if (IsFirstNode == 1) {
                DetailRowIDs = DetailRowIDs + RowID
                IsFirstNode = 0
            }
            else {
                DetailRowIDs = DetailRowIDs + "^" + RowID
            }
        }
    }
    //debugger;
    if (selCount == 0) {
        alert(t["SelectEntry"]);
        return;
    }
    var ret = cspRunServerMethod(strMethod, DetailRowIDs);
    if ((!ret) || (ret < 1)) {
        alert(t["DeleteFail"]);
    }
    window.parent.RPcenter.location.reload();
}

function txtDepartmentName_onChange()
{
	setElementValue("txtDepartmentID","");
	setElementValue("txtEmployeeID","");
	setElementValue("txtEmployeeName","");
}

function txtEmployeeName_onChange()
{
	setElementValue("txtEmployeeID","");
}

function txtEntryTitle_onChange()
{
	setElementValue("txtEntryID","");
}

function LookupLoc(str)
{
	var tmpList=str.split("^");
	if (getElementValue("txtControlType",null)=="1")
	{
		setElementValue("txtDepartmentID",tmpList[0]);
		setElementValue("txtDepartmentName",tmpList[1]);
	}else{
		setElementValue("txtDepartmentName",tmpList[1]);
	}
}

function LookupEmployee(str)
{
	var tmpList=str.split("^");
	setElementValue("txtEmployeeID",tmpList[0]);
	setElementValue("txtEmployeeName",tmpList[2]);
}

function LookupMainDoc(str)
{
	var tmpList=str.split("^");
	setElementValue("txtMainDocID",tmpList[0]);
	setElementValue("txtMainDocName",tmpList[2]);
	setElementValue("txtAttendDocID",tmpList[5]);
	setElementValue("txtAttendDocName",tmpList[7]);
}

function BtnSendMessage_onClick() 
{
	//将 评估项目+备注 作为MessageBody,并且二者不能同时为空,否则会出现MessageBody为空,不能发送消息的问题;
    var txtEntryTitle = getElementValue("txtEntryTitle", null);
	var txtDescription = getElementValue("txtDescription", null);
	if (txtEntryTitle == "" && txtDescription == "")
	{
		alert("评估项目 和 备注 不能同时为空！");
		return;
	}
	else
	{
		var MessageBody = txtEntryTitle + "备注:" + txtDescription;
		MessageBody = MessageBody.replace(/\r\n/gi, '<br/>')
	}

    var EpisodeID = getElementValue("EpisodeID", null);
    var MainDocID = getElementValue("txtMainDocID", null);
    var AttendDocID = getElementValue("txtAttendDocID", null);
	
	if ((EpisodeID == "") || (EpisodeID == null)){
		alert("请选择一个就诊患者");
	}
	else  {
		var CreateUserID = getElementValue("LOGON.USERID", null);
		var Params = escape(MessageBody) + "^" + EpisodeID + "^" + MainDocID + "^" + AttendDocID + "^" + CreateUserID

		var obj = document.getElementById("MethodSendMessage");
		if (obj) { var strMethod = obj.value; } else { var strMethod = ""; }
		var ret = cspRunServerMethod(strMethod, Params);
		if (ret > 0) {
			alert("发送成功!");
			//location.reload();
			window.parent.RPbottom.location.reload();
		} else {
			alert("发送失败!");
		}
	}
}

function btnOpenEntryTree_onClick() {
    var RuleID = getElementValue("txtRuleID", null);
    var EntryTitle = getElementValue("txtEntryTitle", null);
    if (RuleID == "") {
        return;
    }
    var lnk = "dhc.epr.quality.entrytree.csp?RuleID=" + RuleID + "&EntryTitle=" + escape(EntryTitle);
    var ret = window.showModalDialog(lnk, '', "dialogHeight=600px;dialogWidth=600px;scroll=no;status=no;resizable=yes");
	if (!ret) return;
	if (ret.length>1)
	{
		for (var i = 0;i<ret.length ;i++ )
		{
			var result=ret[i].split("^");
			if (result.length >= 3) {
				setElementValue("txtEntryID", result[1]);
				setElementValue("txtEntryTitle", result[2]);
				btnSave_onClick();
			}
		}
	}
	else{
		var result = ret[0].split("^");
		if (result.length >= 3) {
			setElementValue("txtEntryID", result[1]);
			setElementValue("txtEntryTitle", result[2]);
		}
	}
}

InitFrom();