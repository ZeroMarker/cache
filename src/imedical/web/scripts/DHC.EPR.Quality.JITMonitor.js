//add by lfb for bug1998
var m_RegNoLength=10
function InitFrom() 
{
    DisplayRules("B");
    var obj = document.getElementById("ALocDesc");
    if (obj) { obj.onchange = txtLocDesc_onChange; }
    var obj = document.getElementById("AWardDesc");
    if (obj) { obj.onchange = txtWardDesc_onChange; }
    var obj = document.getElementById("ADoctorDesc");
    if (obj) { obj.onchange = txtDoctorDesc_onChange; }
    var obj = document.getElementById("btnSearch");
    if (obj) { obj.onclick = btnSearch_onClick; }
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
	setElementValue("ADoctorID","");
	setElementValue("ADoctorDesc","");
}

function txtWardDesc_onChange()
{
	setElementValue("AWardID","");
	setElementValue("ADoctorID","");
	setElementValue("ADoctorDesc","");
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

var SelEpisodeID = ""

function SelectRowHandler() 
{
    var eSrc = window.event.srcElement;
    var objTable = document.getElementById("tDHC_EPR_Quality_JITMonitor");
    var rows = objTable.rows.length;
    var rowObj = getRow(eSrc);
    var selRowIndex = rowObj.rowIndex;
    if (!selRowIndex) { return };
    var SelRowObj = document.getElementById('TEpisodeIDz' + selRowIndex);
    var EpisodeID = SelRowObj.value
    if (SelEpisodeID != "" && EpisodeID == SelEpisodeID) {
        return;
    }
    else {
        SelEpisodeID = EpisodeID;
        window.parent.RPbottom.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.Message&AEpisodeID=" + EpisodeID
    }
}

function btnSearch_onClick() 
{
    var LocID = getElementValue("ALocID", null);
    var LocDesc = getElementValue("ALocDesc", null);
    var WardID = getElementValue("AWardID", null);
    var WardDesc = getElementValue("AWardDesc", null);
    var DoctorID = getElementValue("ADoctorID", null);
    var DoctorDesc = getElementValue("ADoctorDesc", null);
    var RuleID = getElementValue("ARuleDesc", null);
    if (RuleID == null || RuleID == "") {
        alert("必须选择质控标准!");
        return;
    }
    var RegNo = getElementValue("ARegNo", null);
		//add by lfb for bug1998
	SetRegNoLength()
    var PatName = getElementValue("APatientName", null);
    var FromDate = getElementValue("AFromDate", null);
    var ToDate = getElementValue("AToDate", null);
    if (RegNo == "" && PatName == "" && LocID == "" && WardID == "") {
        alert("为保证查询效率，请选择科室、病区或者患者登记号、姓名之一进行检索！");
        return;
    }
	var StructID = GetRootStructID(RuleID);
    if (StructID == "")
    {
	    alert("质控启动项配置错误！");
	    return;
	}
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.JITMonitor&ALocID=" + LocID + "&ALocDesc=" + LocDesc + "&AWardID=" + WardID + "&AWardDesc=" + WardDesc + "&ADoctorID=" + DoctorID + "&ADoctorDesc=" + DoctorDesc + "&ARuleID=" + RuleID + "&ARegNo=" + RegNo + "&APatientName=" + PatName + "&AFromDate=" + FromDate + "&AToDate=" + ToDate + "&AStructID=" + StructID;
    window.parent.RPtop.location.href = lnk;
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

//取质控结构根节点
function GetRootStructID(RuleID)
{
	var StructID = "";
	var strMethod = document.getElementById("MethodGetRootStructID");
	var LogonLocID =  document.getElementById("LOGON.CTLOCID");
	if (strMethod) { var encmeth = strMethod.value } else { var encmeth = "" }
	StructID = cspRunServerMethod(encmeth,LogonLocID.value,RuleID);
	return StructID;
}
InitFrom();