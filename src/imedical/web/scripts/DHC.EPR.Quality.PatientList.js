function InitFrom() {
	var obj=document.getElementById("ALocDesc");
	if (obj){obj.onchange=txtLocDesc_onChange;}
	var obj=document.getElementById("AWardDesc");
	if (obj){obj.onchange=txtWardDesc_onChange;}
	var obj=document.getElementById("btnSearch");
	if (obj){obj.onclick=btnSearch_onClick;}
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

function btnSearch_onClick()
{
	var LocID=getElementValue("ALocID",null);
	var LocDesc=getElementValue("ALocDesc",null);
	var WardID=getElementValue("AWardID",null);
	var WardDesc=getElementValue("AWardDesc",null);
	var RegNo=getElementValue("ARegNo",null);
	var PatientName=getElementValue("APatientName",null);
	var StartDate=getElementValue("AStartDate",null);
	var EndDate = getElementValue("AEndDate", null);
	if (RegNo == "" && PatientName == "" && LocID == "" && WardID == "") {
	    alert("为保证查询效率，请选择科室、病区或者患者登记号、姓名之一进行检索！");
	    return;
	}
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT=DHCEPRQuality.PatientList&ALocID="+LocID+"&ALocDesc="+LocDesc+"&AWardID="+WardID+"&AWardDesc="+WardDesc+"&ARegNo="+RegNo+"&APatientName="+PatientName+"&AStartDate="+StartDate+"&AEndDate="+EndDate;
	location.href=lnk;
}

var SelEpisodeID = ""

function SelectRowHandler() 
{
    var eSrc = window.event.srcElement;
    var objTable = document.getElementById("tDHC_EPR_Quality_PatientList");
    var rowObj = getRow(eSrc);
    var selRowIndex = rowObj.rowIndex;
    if (!selRowIndex) { return };
    var SelRowObj = document.getElementById('TEpisodeIDz' + selRowIndex);
    //var chkEpisode = document.getElementById('TSelectedz'+selRowIndex);
    var EpisodeID = SelRowObj.value
    var DischRuleID = 7;
    var SSGroupID = getElementValue("LOGON.GROUPID", null);
    var CTLocID = getElementValue("LOGON.CTLOCID", null);
    //debugger;
    if (SelEpisodeID != "" && EpisodeID == SelEpisodeID) {
        //chkEpisode.checked = !chkEpisode.checked;
        return;
    } else {
        //chkEpisode.checked = true;
        SelEpisodeID = EpisodeID;
        window.parent.RPcenter.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.ManualCheck&AEpisodeID=" + EpisodeID + "&ASSGroupID=" + SSGroupID + "&ACTLocatID=" + CTLocID
        window.parent.RPbottom.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.QualityDetail&AEpisodeID=" + EpisodeID + "&ARuleIDs=" + DischRuleID
    }
}

InitFrom();