// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function PAPatMas_ListEMRPatDetails_BodyLoadHandler() {
	var tbl=document.getElementById("tPAPatMas_ListEMRPatDetails");
	//KM 22-Aug-2002: This removed as the new Icon Profile stuff now caters for this.
	//var obj=document.getElementById("PatientInfoz1");
	//if (obj && tbl) imagesShow(tbl);
	var valToBecome="<IMG SRC='../images/webemr/Dead.gif' title='Patient Deceased'>";
	var obj=document.getElementById("Deceasedz1");
	if (obj && tbl) changeColContent(tbl,'Deceased','DeceasedCode','Y',valToBecome);
}
//KM 4-Oct-2001: This functionality now in PAPerson.Banner: This function can be deleted.
//function imgClickHandler(id) {
//	var f=document.getElementById("fPAPatMas_ListEMRPatDetails");
//	var PatientID=f.elements["IDz1"].value;
//	var ChartID=f.elements["ChartIDz1"].value;
//	alert(ChartID);
//	var component="";
//	if (id=="patientalert") component="PAAlertMsg.List";
//	if (id=="Intoxicated") component="PAPatMas.ListEMRHistory";
//	if (component!="") websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT='+component+'&PatientID='+PatientID,'new','top=0,left=0,width=400,height=300,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
//}
document.body.onload=PAPatMas_ListEMRPatDetails_BodyLoadHandler;
