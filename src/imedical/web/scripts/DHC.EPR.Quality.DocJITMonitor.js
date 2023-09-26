function InitFrom() {
    DisplayRules("B");
    var obj = document.getElementById("btnSearch");
    if (obj) { obj.onclick = btnSearch_onClick; }
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
    var LocID = getElementValue("LOGON.CTLOCID", null);
    var DoctorID = getElementValue("LOGON.USERCODE", null);
    var RuleID = getElementValue("ARuleDesc", null);
    var AregNo= getElementValue("ARegNo",null)
    var PatName = getElementValue("APatientName", null);
    var FromDate = getElementValue("AFromDate", null);
    var ToDate = getElementValue("AToDate", null);
    
    if (RuleID == null || RuleID == "") {
        alert("请选择质控标准!");
        return;
    }

    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.DocJITMonitor&ALocID=" + LocID + "&ADoctorID=" + DoctorID + "&ARegNo=" + AregNo + "&APatientName=" + PatName + "&ARuleID=" + RuleID  + "&AFromDate=" + FromDate + "&AToDate=" + ToDate + "&Type=1";
    window.location.href = lnk;
}

InitFrom();