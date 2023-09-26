function InitFrom() 
{
    var objTable = document.getElementById("tDHC_EPR_Quality_ManualAssess_List");
    for (var i = 1; i < objTable.rows.length; i++) {
        var objStatus = document.getElementById("TStatusz" + i);
        var objManual = document.getElementById("TManualFlagz" + i);
        var objSelected = document.getElementById("TSelectedz" + i);
        if (objStatus != null && objStatus.value == "3") {
            objTable.rows[i].style.backgroundColor = "hotpink";
        }
        if (objManual != null && objManual.value == "Y") {
            objTable.rows[i].style.backgroundColor = "yellow";
            objSelected.checked = true;
            objSelected.disabled = true;
        }
    }
}

function SelectRowHandler() 
{
    var eSrc = window.event.srcElement;
    var objTable = document.getElementById("tDHC_EPR_Quality_ManualAssess_List");
    var rowObj = getRow(eSrc);
    var selRowIndex = rowObj.rowIndex;
    if (!selRowIndex) { return };
    var SelRowObj = document.getElementById('TEpisodeIDz' + selRowIndex);
    var EpisodeID = SelRowObj.value
    var DischRuleID = 7;
    var SSGroupID = window.parent.RPtop.document.getElementById("LOGON.GROUPID").value;
    var CTLocID = window.parent.RPtop.document.getElementById("LOGON.CTLOCID").value;
    window.parent.RPcenter.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.ManualCheck&AEpisodeID=" + EpisodeID + "&ASSGroupID=" + SSGroupID + "&ACTLocatID=" + CTLocID
    window.parent.RPbottom.location.href = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.EPR.Quality.QualityDetail&AEpisodeID=" + EpisodeID + "&ARuleIDs=" + DischRuleID
}

InitFrom();