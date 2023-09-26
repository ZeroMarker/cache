

function init()
{
	MakeComboBox("cboStatus");
	document.getElementById("btnLookFor").onclick = btnLookFor;
}



function btnLookFor()
{	
	var URL = "websys.default.csp?WEBSYS.TCOMPONENT=DHC.WMR.QueryMissVolume.List";
	URL += "&FromDate=" + getElementValue("startTime");
	URL += "&MrType=" + getElementValue("MrType");
	URL += "&PaadmType=" + GetParam(window, "AdmType");
	URL += "&ToDate=" + getElementValue("endtime");
	URL += "&Status=" + getElementValue("cboStatus");
	//window.alert(URL);
	//window.open(URL);
	window.parent.frames[1].location.href = URL;
	
}
window.onload = init;