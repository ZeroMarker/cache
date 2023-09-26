//add by lfb for bug1998
var m_RegNoLength=10
function InitFrom() {
    DisplayRules("A");
    var obj = document.getElementById("ALocDesc");
    if (obj) { obj.onchange = txtLocDesc_onChange; }
    var obj = document.getElementById("AWardDesc");
    if (obj) { obj.onchange = txtWardDesc_onChange; }
	var obj=document.getElementById("ADoctorDesc");
	if (obj){obj.onchange=txtDoctorDesc_onChange;}
    var obj = document.getElementById("btnSearch");
    if (obj) { obj.onclick = btnSearch_onClick; }
    var obj = document.getElementById("btnExport");
    if (obj) {obj.onclick = btnExport_onClick;}
	var obj = document.getElementById("ARegNo")
	if (obj){
		obj.onkeydown=RegNo_OnKeyDown;
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

function DisplayRules(ADefaultRuleCode) 
{
    var objRule = document.getElementById("ARuleDesc");
    if (objRule) {
        objRule.size = 1;
        objRule.multiple = false;
        objRule.length = 0;

        var RuleCode = getElementValue("ARuleCodes", null);
        var strMethod = document.getElementById("MethodGetQualityRules");
        if (strMethod) { var encmeth = strMethod.value } else { var encmeth = "" }
        var Rules = cspRunServerMethod(encmeth, RuleCode);
        if (Rules != "") {
            var lstRules = Rules.split("|");
            var Rule = "", ID = "", Title = "";
            for (var i = 0; i < lstRules.length; i++) {
                Rule = lstRules[i].split("^");
                ID = Rule[0];
                Code = Rule[1]
                Title = Rule[2];
                var option = document.createElement("OPTION");
                option.value = ID;
                option.text = Title;
                if (ADefaultRuleCode != "" && Code == ADefaultRuleCode) {
                    option.selected = true;
                }
                objRule.add(option);
            }
        }
    }
}

function btnSearch_onClick()
{
	var LocID = getElementValue("ALocID",null);
	var WardID = getElementValue("AWardID",null);
	var RuleID = getElementValue("ARuleDesc", null);
	if(RuleID == "") 
	{
	    alert("请选择质控标准进行检索!");
	    return;
	}
	var RegNo = getElementValue("ARegNo",null);
		//add by lfb for bug1998
	SetRegNoLength()
	var PatientName = getElementValue("APatientName",null);
	var StartDate = getElementValue("AStartDate", null);
	var EndDate = getElementValue("AEndDate", null);
	var MedicareNo = getElementValue("AMedicareNo",null);
	var DoctorID=getElementValue("ADoctorID",null);
    //add buy YHY 
	if (RegNo == "" && PatientName == "" && LocID == "" && WardID == "" && MedicareNo == "") {
	    alert("为保证查询效率，请选择科室、病区或者患者登记号、病案号、姓名之一进行检索！");
	    return;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.Profiler.List&ALocID="+LocID+"&AWardID="+WardID+"&ADoctorID="+DoctorID+"&ARuleID="+RuleID+"&ARegNo="+RegNo+"&APatientName="+PatientName+"&AStartDate="+StartDate+"&AEndDate="+EndDate+"&AMedicareNo="+MedicareNo;
	parent.frames(1).location.href=lnk;	
}

function btnExport_onClick() 
{
	
	var LocID = getElementValue("ALocID",null);
	var WardID = getElementValue("AWardID",null);
	var RuleID = getElementValue("ARuleDesc", null);
	var RegNo = getElementValue("ARegNo", null);
	var PatientName = getElementValue("APatientName",null);
	var StartDate = getElementValue("AStartDate", null);
	var EndDate = getElementValue("AEndDate", null);
	var MedicareNo = getElementValue("AMedicareNo",null);	

    var cArguments = LocID + "#" + WardID + "#" + RuleID + "#" +RegNo + "#" + PatientName + "#" + StartDate + "#" + EndDate + "#" + MedicareNo;
    var flag = ExportDataToExcel("MethodGetServerInfo", "MethodGetProfilerData", "DHCEPRQualityProfiler.xls", cArguments);
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
function RegNo_OnKeyDown()
{
	if(window.event.keyCode != 13)
	return;
	SetRegNoLength();
	 //var RegNo=getElementValue("ARegNo",null);
	obj.onkeydown=btnSearch_onClick;
}
InitFrom();