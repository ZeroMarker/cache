// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.
var tbl=document.getElementById("tRBResEffDateSession_List");
var f=document.getElementById("fRBResEffDateSession_List");
// these two vars for the reg no search, so the appointment frame doesnt reload
var noreloadval="";
var noreload=document.getElementById("noreload");
if (noreload) noreloadval=noreload.value;
var currsessval="";
var context=session['CONTEXT'];
//alert(context);
var currsess=document.getElementById("currsess");
if (currsess) currsessval=currsess.value;

function docLoaded() {
    window.parent.resetRows();
	var RBSessID=top.frames['eprmenu'].RBSessID;
	if (currsessval!="") RBSessID=currsessval;
	var row=1;
	if (RBSessID!="") {
		for (var i=1;i<tbl.rows.length;i++) {
            if (f.elements["IDz"+i].value==RBSessID) {row=i;break;}
        }
	}
	if (f.elements["IDz"+row]) { f.elements["IDz"+row].click();} else {websys_createWindow('websys.default.csp','appointments','');}

 	// ab 23.07.02 - override the reset button when displaying search results since its reseting to the wrong session
    //alert(noreloadval);
    if ((noreloadval=="1")&&(parent.frames['appointments'])&&(row)) {
       // if theres a appt frame then get the selected session,date,resc and override the reset button
       var currResc="",currDate="",currID="";
       var docapp=parent.frames['appointments'].document;
       var rst=docapp.getElementById("Reset");
       var currID=document.getElementById("IDz"+row);
       if (currID) currID=currID.value;
       var currDate=document.getElementById("DateLogicalz"+row);
       if (currDate) currDate=currDate.value;
       var currResc=document.getElementById("PARREFz"+row);
       if (currResc) currResc=currResc.value;

       if (rst) rst.href="websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.FindRescDaySched&RescID="+currResc+"&CONTEXT="+context+"&date="+currDate+"&sessId="+currID;
    }

    if (noreloadval=="1") noreloadval="";
}
function SelectRowHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	//BR 38772 - Don't want to reload the bottom frame when loading a sub screen as this will cause
	// the popup to go behind the main window.
	if (eSrcAry[0]=="FTA") { noreloadval="1"; }
	if (eSrcAry[0]=="AddMessage") { noreloadval="1"; }
	if (eSrcAry[0]=="ReasonForVariance") { noreloadval="1"; }
	if (selectedRowObj.rowIndex!="") {
		var RescID=f.elements["PARREFz"+selectedRowObj.rowIndex].value;
		var date=f.elements["DateLogicalz"+selectedRowObj.rowIndex].value;
		var time=f.elements["TimeLogicalz"+selectedRowObj.rowIndex].value.split("^");
		var RBSessID=f.elements["IDz"+selectedRowObj.rowIndex].value;
		top.frames['eprmenu'].RBSessID=RBSessID;
		//alert(RBSessID + "," + date)
		//SB 28/07/04 (43614): If row contains more than one session, don't pass sessID so we show all sessions in botton grid.
		var sessList=RBSessID.split("^");
		if (sessList[1]) RBSessID="";
		// SB Log 23211: Need to pass SessId rather than Timeto/from so that multiple overlapping sessions display correctly.
		if (noreloadval!="1") websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.FindRescDaySched&RescID='+RescID+'&date='+date+'&sessId='+RBSessID+'&CONTEXT='+context,'appointments','');
	}
	noreloadval="";

	//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.FindRescDaySched&RescID='+RescID+'&date='+date+'&timefrom='+time[0]+'&timeto='+time[1],'appointments','');
}
window.onload=docLoaded;


