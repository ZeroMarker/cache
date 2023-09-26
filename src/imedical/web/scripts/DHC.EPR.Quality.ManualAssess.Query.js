//add by lfb for bug1998
var m_RegNoLength=10

function InitFrom() 
{
    DisplayStatus();
    var obj = document.getElementById("ALocDesc");
    if (obj) { obj.onchange = txtLocDesc_onChange; }
    var obj = document.getElementById("AWardDesc");
    if (obj) { obj.onchange = txtWardDesc_onChange; }
	var obj=document.getElementById("ADoctorDesc");
	if (obj){obj.onchange = txtDoctorDesc_onChange;}
    var obj = document.getElementById("ASetFlag");
    if (obj) { obj.onclick = chkSetFlag_onClick; }
    var obj = document.getElementById("btnSearch");
    if (obj) { obj.onclick = btnSearch_onClick; }
    var obj = document.getElementById("btnSetManual");
    if (obj) { obj.onclick = btnSetManual_onClick; }

	var obj = document.getElementById("ARegNo")
	if (obj){
		obj.onkeydown=RegNo_OnKeyDown;
	}
}

function DisplayStatus() 
{
    var objStatus = document.getElementById("AStatus");
    if (objStatus) {
        objStatus.size = 1;
        objStatus.multiple = false;
        objStatus.length = 0;

        objStatus.options.add(new Option("请选择", "0"));
        objStatus.options.add(new Option("在院", "1"));
        objStatus.options.add(new Option("出院", "2"));
        objStatus.options.add(new Option("死亡", "3")); 
    }
}

function txtLocDesc_onChange()
{
	setElementValue("ALocID","");
	setElementValue("AWardID","");
	setElementValue("AWardDesc","");
}

function txtWardDesc_onChange()
{
	setElementValue("AWardID","");
}

function txtDoctorDesc_onChange()
{
	setElementValue("ADoctorID","");	
}

function GetLoc(str)
{
	var tmpList=str.split("^");
	setElementValue("ALocID",tmpList[0]);
	setElementValue("ALocDesc",tmpList[1]);
}

function GetWard(str)
{
	var tmpList=str.split("^");
	setElementValue("AWardID",tmpList[0]);
	setElementValue("AWardDesc",tmpList[1]);
}

function GetDoctor(str)
{
	var tmpList=str.split("^");
	setElementValue("ADoctorID",tmpList[0]);
	setElementValue("ADoctorDesc",tmpList[2]);	
}

function chkSetFlag_onClick() 
{
    var flag = getElementValue("ASetFlag", null);
    var btnSetManual = document.getElementById("btnSetManual");
    if (flag == "Y") {
        btnSetManual.setAttribute("disabled", "disabled");
        btnSetManual.onclick = ""
    } else {
        btnSetManual.removeAttribute("disabled");
        btnSetManual.onclick = btnSetManual_onClick;
    }
}

function btnSearch_onClick()
{
	var LocID=getElementValue("ALocID",null);
	var WardID=getElementValue("AWardID",null);
	var RegNo=getElementValue("ARegNo",null);
	//add by lfb for bug1998
	SetRegNoLength()
	var PatientName=getElementValue("APatientName",null);
	var StartDate=getElementValue("AStartDate",null);
	var EndDate = getElementValue("AEndDate", null);
	var Status = getElementValue("AStatus", null);
	var SetFlag = getElementValue("ASetFlag", null);
	var MedicareNo = getElementValue("AMedicareNo", null);
	var DoctorID=getElementValue("ADoctorID",null);
	if (RegNo == "" && PatientName == "" && LocID == "" && WardID == "" && MedicareNo == "") {
	    alert("为保证查询效率，请选择科室、病区或者患者登记号、病案号、姓名之一进行检索！");
	    return;
	}
	var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.ManualAssess.List&ALocID=" + LocID + "&AWardID=" + WardID + "&ADoctorID=" + DoctorID + "&ARegNo=" + RegNo + "&APatientName=" + PatientName + "&AStartDate=" + StartDate + "&AEndDate=" + EndDate + "&AStatus=" + Status + "&ASetFlag=" + SetFlag + "&AMedicareNo=" + MedicareNo;
	parent.frames[1].location.href = lnk;
}
//add by lfb for bug1998
function SetRegNoLength(){
	var obj=document.getElementById('ARegNo');
	if (obj.value!='') 
	{
		if ((obj.value.length<m_RegNoLength)&&(m_RegNoLength!=0)) 
		{
			for (var i=(m_RegNoLength-obj.value.length-1); i>=0; i--)
			{
				obj.value="0"+obj.value;
			}
		}
	}
}

function btnSetManual_onClick() {
    var objTable = window.parent.RPlist.document.getElementById("tDHC_EPR_Quality_ManualAssess_List");
    var Count = 0;
    var EpisodeIDs = "", IsFirstNode = 1
    for (var i = 1; i < objTable.rows.length; i++) {
        var objSelected = window.parent.RPlist.document.getElementById("TSelectedz" + i);
        var EpisodeID = window.parent.RPlist.document.getElementById("TEpisodeIDz" + i).value;
        if (objSelected != null && objSelected.disabled != true && objSelected.checked == true) {
            Count++;
            if (IsFirstNode == 1) {
                EpisodeIDs = EpisodeID
                IsFirstNode = 0
            }
            else {
                EpisodeIDs = EpisodeIDs + "^" + EpisodeID
            }
        }
    }
    if (Count == 0) {
        alert("请选择需要设置为手工检查病历的患者!");
        return;
    } else {
        var CreateUserID = getElementValue("LOGON.USERID", null);
        var obj = document.getElementById("MethodSetManualEpisodes");
        if (obj) { var strMethod = obj.value; } else { var strMethod = ""; }
        var ret = cspRunServerMethod(strMethod, EpisodeIDs, CreateUserID);
        if (ret > 0) {
            window.parent.RPlist.location.reload();
        } else {
            alert("设置手工检查病历失败!");
            return;
        }
    }
}

function RegNo_OnKeyDown()
{
	if(window.event.keyCode != 13)
	return;
	SetRegNoLength();
	 //var RegNo=getElementValue("ARegNo",null);
	obj.onkeydown=btnSearch_onClick;
}


InitFrom();