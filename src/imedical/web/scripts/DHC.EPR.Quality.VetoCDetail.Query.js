function InitFrom()
{
    var LocIDs = getElementValue("ALocIDs", null);
    GetLoc(LocIDs);
    var obj = document.getElementById("ALocGroupDesc");
    if (obj) {obj.onchange = txtLocGroup_onChange;}
    var obj = document.getElementById("btnSearch");
    if (obj) {obj.onclick = btnSearch_onClick;}
    var obj = document.getElementById("btnExport");
    if (obj) {obj.onclick = btnExport_onClick;}
    var obj = document.getElementById("btnPrint");
    if (obj) {obj.onclick = btnPrint_onClick;}
}

function txtLocGroup_onChange()
{
    setElementValue("ALocGroupID","");
    GetLoc("");
}

function GetLocGroup(str)
{
    var tmpList = str.split("^");
    setElementValue("ALocGroupID",tmpList[0]);
    setElementValue("ALocGroupDesc",tmpList[1]);
    GetLoc("");
}

function GetLoc(ASelectedIDs) 
{
    var LocGroupID = getElementValue("ALocGroupID", null);
    var obj = document.getElementById('MethodGetLocsByGroupID');
    if (obj) { var encmeth = obj.value } else { var encmeth = '' }
    var LocInfos = cspRunServerMethod(encmeth, LocGroupID);
    if (LocInfos != "") {
        var lstLocInfo = LocInfos.split("|");
        var Locs = document.getElementById("ALocDescs");
        if (Locs) {
            Locs.length = 0;
            var LocInfo = "", ID = "", Name = ""
            for (var i = 1; i < lstLocInfo.length; i++) {
                LocInfo = lstLocInfo[i].split("^");
                ID = LocInfo[0];
                Name = LocInfo[1];
                var oOption = document.createElement("OPTION");
                oOption.text = Name;
                oOption.value = ID;
                oOption.selected = true;
                if (ASelectedIDs != "") {
                    SelectedIDs = "^" + ASelectedIDs + "^";
                    if (SelectedIDs.indexOf("^" + ID + "^") >= 0) {
                        oOption.selected = true;
                    }
                    else {
                        oOption.selected = false;
                    }
                }
                Locs.add(oOption);
            }
        }
    }
}

function btnSearch_onClick() 
{
    var LocIDs = getElementValue("ALocDescs", null);
    var StartDate = getElementValue("AStartDate", null);
    var EndDate = getElementValue("AEndDate", null);
    var EntryIDs = getElementValue("AEntryIDs", null);
    var AnalysisFlag = getElementValue("AAnalysisFlag", null);
    var lnk = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.VetoCDetail.List&ALocIDs=" + LocIDs + "&AStartDate=" + StartDate + "&AEndDate=" + EndDate + "&AEntryIDs=" + EntryIDs + "&AAnalysisFlag=" + AnalysisFlag;
    parent.frames[1].location.href = lnk;
}

function btnExport_onClick() 
{
    var LocIDs = getElementValue("ALocDescs", null);
    var StartDate = getElementValue("AStartDate", null);
    var EndDate = getElementValue("AEndDate", null);
    var EntryIDs = getElementValue("AEntryIDs", null);
    var AnalysisFlag = getElementValue("AAnalysisFlag", null);
    var cArguments = LocIDs + "#" + StartDate + "#" + EndDate + "#" + EntryIDs + "#" + AnalysisFlag;
    var flag = ExportDataToExcel("MethodGetServerInfo", "MethodGetAnalysisData", "DHCEPRQualityReport04.xls", cArguments);
}

function btnPrint_onClick() 
{
    var LocIDs = getElementValue("ALocDescs", null);
    var StartDate = getElementValue("AStartDate", null);
    var EndDate = getElementValue("AEndDate", null);
    var EntryIDs = getElementValue("AEntryIDs", null);
    var AnalysisFlag = getElementValue("AAnalysisFlag", null);
    var cArguments = LocIDs + "#" + StartDate + "#" + EndDate + "#" + EntryIDs + "#" + AnalysisFlag;
    var flag = PrintDataByExcel("MethodGetServerInfo", "MethodGetAnalysisData", "DHCEPRQualityReport04.xls", cArguments);
}

InitFrom();