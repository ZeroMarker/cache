//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//KM 18-Oct-2001: This function called from RBAppointment.ChangeStatus.js and RBAppointment.FindRescDaySched.js
//t['NoFutureArrival'] is defined as a Message on both the above appointments.
function validateStatusChange(Code,DateAppt,DateNow,aryID,arySt) {
	var message="";
	// Log 57848 - GC - 18-05-2006: Added Code=="S"
	if (Code=="A" || Code=="N" || Code=="S") {
		//Can not mark future appointments as arrived.
		if (DateAppt>DateNow) {message=t['NoFutureArrival'];}
	}
	if (Code=="X") {
		//Can  not cancel appointments where patient has arrived.
		for (var i=0;i<aryID.length;i++) {if (arySt[i]=="A") {message=t['NoCanelArrived'];}}
	}
	return message
}

//KM 25-Oct-2001: This function called from RBAppointment.FindRescDaySched.js and RBAppointment.ListApptByStatus.js
// BC 1-7-2002: Amended to allow if the "Select" column is removed or only a row is selected without the select column checked
function RBAppointment_ChangeStatusHandler() {
	// Log 31443 Need this so if either of these are not defined to simple give them a black value

	try {dummy=RescID;} catch(e){RescID="";}
	try {dummy=dt;} catch(e){dt="";}
	// End Log 31443
	try {
		if (document.getElementById("DateLogical")) dt= document.getElementById("DateLogical").value
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			if (f.elements['ApptIDz'+rowid].value=="") {
				alert(t['NOSELECTION']);
			} else {
				//log  37434 15-9-2003 Need to have a workflow here
				//log 37850 28/10/03 if we pass a common workflow don't get a conext. pass in an override context.
				//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.ChangeStatus&RescID='+RescID+'&date='+dt+'&ID='+f.elements['ApptIDz'+rowid].value+'&PresentStatus='+f.elements['StatusCodez'+rowid].value+'&PatientID='+f.elements['PatientIDz'+rowid].value+'&PatientBanner=1','Prompt','top=0,left=0,width=400,height=400');
				// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
				websys_createWindow('websys.csp?TWKFL=524&TCONTEXT='+session['CONTEXT']+'&RescID='+RescID+'&date='+dt+'&ID='+f.elements['ApptIDz'+rowid].value+'&PresentStatus='+f.elements['StatusCodez'+rowid].value+'&EpisodeID='+f.elements['EpisodeIDz'+rowid].value+'&PatientID='+f.elements['PatientIDz'+rowid].value+'&PatientBanner=1','Prompt','top=0,left=0,width=400,height=400,titlebar=no,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
			}
		}
		if (aryfound.length>0) {
			var aryID=new Array();var aryStat=new Array();var aryEpisodeID=new Array();var n=0;
			//alert("1: "+selectedRowObj.rowIndex);
			//alert("Length: "+aryfound.length);
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					//BR 45216. Only want the items which are selected by the check box if more then 1 item is selected
					//if ((aryfound[j]==i)||(selectedRowObj.rowIndex==i)) {
					if (aryfound[j]==i) {
						//SB 13/09/04 (45177): Need to eliminate duplicates from list
						pID=""; pn=n-1; if (pn!=-1) pID=aryID[pn];
						if (pID!=f.elements['ApptIDz'+i].value) {
						//debugger;
							aryID[n]=f.elements['ApptIDz'+i].value;
							aryEpisodeID[n]=f.elements['EpisodeIDz'+i].value;
							aryStat[n]=f.elements['StatusCodez'+i].value;
							n++
						}
					}
				}
			}
			//log  37434 15-9-2003 Need to have a workflow here
			websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.ChangeStatus&RescID='+RescID+'&date='+dt+'&ID='+aryID.join(",")+'&PresentStatus='+aryStat.join(",")+'&EpisodeID='+aryEpisodeID.join(","),'Prompt','top=0,left=0,width=400,height=400');
			//websys_createWindow('websys.csp?TWKFL=524&RescID='+RescID+'&date='+dt+'&ID='+aryID.join(",")+'&PresentStatus='+aryStat.join(","),'Prompt','top=0,left=0,width=400,height=400');
		}
	} catch(e) {
		if ((selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			//log  37434 15-9-2003 Need to have a workflow here
			//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.ChangeStatus&RescID='+RescID+'&date='+dt+'&ID='+f.elements['ApptIDz'+rowid].value+'&PresentStatus='+f.elements['StatusCodez'+rowid].value+'&PatientID='+f.elements['PatientIDz'+rowid].value+'&PatientBanner=1','Prompt','top=0,left=0,width=400,height=400');
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow('websys.csp?TWKFL=524&TCONTEXT='+session['CONTEXT']+'&RescID='+RescID+'&date='+dt+'&ID='+f.elements['ApptIDz'+rowid].value+'&PresentStatus='+f.elements['StatusCodez'+rowid].value+'&EpisodeID='+f.elements['EpisodeIDz'+rowid].value+'&PatientID='+f.elements['PatientIDz'+rowid].value+'&PatientBanner=1','Prompt','top=0,left=0,width=400,height=400,titlebar=no,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
		}
	}
}

//JW 16-nOV-2001: This function called from RBAppointment.FindRescDaySched.js to change outcome of appointment
// BC 1-7-2002: Amended to allow if the "Select" column is removed
function RBAppointment_ChangeOutcomeHandler() {
	try {

		var context=session['CONTEXT'];
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			if (f.elements['ApptIDz'+rowid].value=="") {
				alert(t['NOSELECTION']);
			} else {
				websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.OutcomeOfAppt&RescID='+RescID+'&date='+dt+'&ID='+f.elements['ApptIDz'+rowid].value+'&PatientID='+f.elements['PatientIDz'+rowid].value+'&PatientBanner=1'+'&CONTEXT='+context,'out','top=0,left=0,width=400,height=400');
			}
		}
		if (aryfound.length>0) {
			var aryID=new Array();var aryOutcome=new Array();var n=0;
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					//BR 45216. Only want the items which are selected by the check box if more then 1 item is selected
					//if ((aryfound[j]==i)||(selectedRowObj.rowIndex==i)) {
					if (aryfound[j]==i) {
						//debugger;
						aryID[n]=f.elements['ApptIDz'+i].value;
						//alert (aryID[n])
						if (f.elements['OutcomeCodez'+i]) aryOutcome[n]=f.elements['OutcomeCodez'+i].value;
						n++
					}
				}
			}
	websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.OutcomeOfAppt&RescID='+RescID+'&date='+dt+'&ID='+aryID.join(",")+'&CONTEXT='+context,'out','top=0,left=0,width=400,height=400');

		}
	} catch(e) {
		if ((selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.OutcomeOfAppt&RescID='+RescID+'&date='+dt+'&ID='+f.elements['ApptIDz'+rowid].value+'&PatientID='+f.elements['PatientIDz'+rowid].value+'&PatientBanner=1'+'&CONTEXT='+context,'out','top=0,left=0,width=400,height=400');
		}
	}
}

function RBAppointment_TransApptHandler() {
	try {
		var context=session['CONTEXT'];
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			//workflow = Trak.Outpatient.TransferAppointment
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow('websys.csp?TWKFL=586&TCONTEXT='+session['CONTEXT']+'&BulkApptList='+f.elements['ApptIDz'+rowid].value+'&PatientBanner=1','Prompt','top=0,left=0,width=400,height=400,titlebar=no,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
		}
		if (aryfound.length>0) {
			var aryID=new Array();var aryOutcome=new Array();var n=0;
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					//BR 45216. Only want the items which are selected by the check box if more then 1 item is selected
					//if ((aryfound[j]==i)||(selectedRowObj.rowIndex==i)) {
					if (aryfound[j]==i) {
						aryID[n]=f.elements['ApptIDz'+i].value;
						//alert (aryID[n])
						if (f.elements['OutcomeCodez'+i]) aryOutcome[n]=f.elements['OutcomeCodez'+i].value;
						n++
					}
				}
			}
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow('websys.csp?TWKFL=586&TCONTEXT='+session['CONTEXT']+'&BulkApptList='+aryID.join("^")+'&PatientBanner=1','Prompt','top=0,left=0,width=400,height=400,titlebar=no,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
		}
	} catch(e) {
		if ((selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			// Log 59598 - BC - 29-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow('websys.csp?TWKFL=586&TCONTEXT='+session['CONTEXT']+'&BulkApptList='+f.elements['ApptIDz'+rowid].value+'&PatientBanner=1','Prompt','top=0,left=0,width=400,height=400,titlebar=no,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
		}
	}
}
//Log 36820 bc 16-9-2003 FTA and Rebook Process
function RBAppointment_FTARebookHandler(){
	//alert("RBAppointment_FTARebookHandler()");
	var lnk="rbappointment.ftacheck.csp?"

	try {
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			lnk=lnk+'ApptIDs='+f.elements['ApptIDz'+rowid].value;
			websys_createWindow(lnk,"TRAK_hidden");
		}
		if (aryfound.length>0) {
			var aryID=new Array();var n=0;
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					//BR 45216. Only want the items which are selected by the check box if more then 1 item is selected
					//if ((aryfound[j]==i)||(selectedRowObj.rowIndex==i)) {
					if (aryfound[j]==i) {
						aryID[n]=f.elements['ApptIDz'+i].value;
						//alert (i+","+cnt+","+n+":"+aryfound[j]+","+selectedRowObj.rowIndex+":"+aryID[n])
						n++
					}
				}
			}
			lnk=lnk+'ApptIDs='+aryID.join(",");
			websys_createWindow(lnk,"TRAK_hidden");
		}
	} catch(e) {
		if ((selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			lnk=lnk+'ApptIDs='+f.elements['ApptIDz'+rowid].value;
			websys_createWindow(lnk,"TRAK_hidden");
		}
	}
}

//Log 56831 - 12.01.2007 - to handle manual Bulk Transfers - used by the menu in RBApptPatientTraking.List
function RBAppointment_BulkTransHandler(){
	var lnk="rbappointment.bulktransfer.csp?"
	try {
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			lnk=lnk+'ApptIDs='+f.elements['ApptIDz'+rowid].value;
			websys_createWindow(lnk,"TRAK_hidden");
		}
		if (aryfound.length>0) {
			var aryID=new Array();var n=0;
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					//BR 45216. Only want the items which are selected by the check box if more then 1 item is selected
					//if ((aryfound[j]==i)||(selectedRowObj.rowIndex==i)) {
					if (aryfound[j]==i) {
						aryID[n]=f.elements['ApptIDz'+i].value;
						n++
					}
				}
			}
			lnk=lnk+'ApptIDs='+aryID.join(",");
			websys_createWindow(lnk,"TRAK_hidden");
		}
	} catch(e) {
		if ((selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			lnk=lnk+'ApptIDs='+f.elements['ApptIDz'+rowid].value;
			websys_createWindow(lnk,"TRAK_hidden");
		}
	}
}

//Log 56831 - 15.01.2007 - to handle Automatic Bulk Transfers - used by the menu in RBApptPatientTraking.List
function RBAppointment_AutoBulkTransHandler(){
	try {
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			lnk=lnk+'ApptIDs='+f.elements['ApptIDz'+rowid].value;
			websys_createWindow(lnk,"TRAK_hidden");
		}
		if (aryfound.length>0) {
			var aryID=new Array();var n=0;
			var warn=0;
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					//BR 45216. Only want the items which are selected by the check box if more then 1 item is selected
					//if ((aryfound[j]==i)||(selectedRowObj.rowIndex==i)) {
					if (aryfound[j]==i) {
						//Log 62342 - 23.02.2007 - check if selected appointments have correct status before transfering
						if ((f.elements['StatusCodez'+i].value!="P") && (f.elements['StatusCodez'+i].value!="N"))
						{
							warn=warn+1;
						} else {
							aryID[n]=f.elements['ApptIDz'+i].value;
							n++;
						}
					}
				}
			}
			var obj = document.getElementById('ResDesc');
			if (obj) Res=obj.value;
			var ApptList=aryID.join("^")
			//Log 62342 - 23.02.2007 - give error if selected appointments do not have correct status before transfering
			if (warn!=0) {
				alert(warn + " " + t['RBNotFTAOrBooked']);
				if (n==0) return false;
			}
			var lnk="rbappointment.automaticbulktransfer.csp?ApptList="+ApptList+"&Res="+Res;
			window.open(lnk,"frmAutoBulkTransEdit","top=50,left=50,width=400,height=350,resizable,scrollbars=yes,status=yes");
			return false;
		}
	} catch(e) {
		if ((selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			var lnk="rbappointment.automaticbulktransfer.csp?ApptList="+ApptList+"&Res="+Res;
			window.open(lnk,"frmAutoBulkTransEdit","top=50,left=50,width=400,height=350,resizable,scrollbars=yes,status=yes");
			return false;
		}
	}
}

function RBOperatingRoom_BulkTransHandler(e) {
	var eSrc=websys_getSrcElement(e);
	var tbl=tk_getTableFromMenu(eSrc,'RBOperatingRoom_List');
	var arrGetItems=new Array();
	arrGetItems["OperRoomID"]=new Array();
	/*****arrGetItems["OperationID"]=new Array();****/
	arrGetItems=tk_getDataSelRows(tbl,'select',arrGetItems);
	var lnk="rboperatingroom.beforebulktransfer.csp?type=S&BulkOpList=";
	if (arrGetItems["OperRoomID"].length==0) {
		alert(t['RBOPNonSelected']);
		return false;
	}
	lnk=lnk+arrGetItems["OperRoomID"].join("^");
	websys_createWindow(lnk,"TRAK_hidden");
	websys_cancel();
	return false;

	/***** old code
	try {
		if (etbl) {
			//alert("RBOperatingRoom_BulkTransHandler");
			var lnk="rboperatingroom.beforebulktransfer.csp?type=S&BulkOpList=";
			var BulkOpList=etbl.getElementById("BulkOpList");
			//var BulkApptList=document.getElementById("BulkApptList");
			alert(BulkOpList.value);
			if (BulkOpList.value=="") {
				alert(t['RBOPNonSelected']);
				return false;
			}
			lnk=lnk+BulkOpList.value;
			websys_createWindow(lnk,"TRAK_hidden");
		}
	}catch(e) {
		return false;
	}
	*******/
}

function RBOperatingRoom_BulkTransAllHandler() {
	try {
		//alert("RBOperatingRoom_BulkTransAllHandler");
		var lnk="rboperatingroom.beforebulktransfer.csp?type=A&BulkOpList=";
		var tbl=document.getElementById("tRBOperatingRoom_List")
		if (tbl) {
			//alert(tbl.rows.length);
			if (tbl.rows.length<2){
				alert(t['RBOPNonSelected']);
				return false;
			}
		}
		var parwin=window.parent;
		if (parwin) {
			var editframe=parwin.frames['RBOperatingRoomEdit']
			if (editframe) {
				if (editframe.document.getElementById("RBOPDateOper")){
					lnk=lnk+"&RBOPDateOper="+editframe.document.getElementById("RBOPDateOper").value;
				} else {
					lnk=lnk+"&RBOPDateOper=";
				}
				if (editframe.document.getElementById("CTLocID")){
					lnk=lnk+"&CTLocID="+editframe.document.getElementById("CTLocID").value;
				} else {
					lnk=lnk+"&CTLocID=";
				}
				if (editframe.document.getElementById("ResID")){
					lnk=lnk+"&ResID="+editframe.document.getElementById("ResID").value;
				} else {
					lnk=lnk+"&ResID=";
				}
				if (editframe.document.getElementById("Anesthetiest")){
					lnk=lnk+"&Anesthetiest="+editframe.document.getElementById("Anesthetiest").value;
				} else {
					lnk=lnk+"&Anesthetiest=";
				}
				if (editframe.document.getElementById("RBOPOperDepartmentID")){
					lnk=lnk+"&RBOPOperDepartmentID="+editframe.document.getElementById("RBOPOperDepartmentID").value;
				} else {
					lnk=lnk+"&RBOPOperDepartmentID=";
				}
				//Log 48401 Chandana 28/2/05 - status is a listbox now
				if (editframe.document.getElementById("OPStatus")){
					var obj=editframe.document.getElementById("OPStatus");
					var OPStatus="";
					if(obj) {
						for (var i=(obj.length-1); i>=0; i--) {
							if (obj.options[i].selected) {
								if(OPStatus==""){
									OPStatus=obj.options[i].value;
								}
								else {
									OPStatus=OPStatus+" "+obj.options[i].value;
								}
							}
						}
						lnk=lnk+"&OPStatus="+OPStatus;
					}
				}
				else {
					lnk=lnk+"&OPStatus=";
				}
				if (editframe.document.getElementById("dateto")){
					lnk=lnk+"&dateto="+editframe.document.getElementById("dateto").value;
				} else {
					lnk=lnk+"&dateto=";
				}
				if (editframe.document.getElementById("surgeonid")){
					lnk=lnk+"&surgeonid="+editframe.document.getElementById("surgeonid").value;
				} else {
					lnk=lnk+"&surgeonid=";
				}
				if (editframe.document.getElementById("NoAppt")){
					lnk=lnk+"&NoAppt="+editframe.document.getElementById("NoAppt").checked;
				} else {
					lnk=lnk+"&NoAppt=";
				}
				if (editframe.document.getElementById("RBOPOperation")){
					lnk=lnk+"&RBOPOperation="+editframe.document.getElementById("RBOPOperation").value;
				} else {
					lnk=lnk+"&RBOPOperation=";
				}
				if (editframe.document.getElementById("RBOPStatePPP")){
					lnk=lnk+"&RBOPStatePPP="+editframe.document.getElementById("RBOPStatePPP").value;
				} else {
					lnk=lnk+"&RBOPStatePPP=";
				}
				if (editframe.document.getElementById("RegistrationNo")){
					lnk=lnk+"&RegistrationNo="+editframe.document.getElementById("RegistrationNo").value;
				} else {
					lnk=lnk+"&RegistrationNo=";
				}
				if (editframe.document.getElementById("Surgeon")){
					lnk=lnk+"&Surgeon="+editframe.document.getElementById("Surgeon").value;
				} else {
					lnk=lnk+"&Surgeon=";
				}
				if (editframe.document.getElementById("Params")){
					lnk=lnk+"&Params="+editframe.document.getElementById("Params").value;
				} else {
					lnk=lnk+"&Params=";
				}


			}
		}
		lnk=lnk+"";
		//alert("lnk:" + lnk)
		websys_createWindow(lnk,"TRAK_hidden");
	}catch(e) {
		alert("err");
		return false;
	}
}

function RBOperatingRoom_ReadmitHandler(lnk,newwin) {
	var tbl=document.getElementById("tRBOperatingRoom_List")
	var selRow=0; var rowTotal=0
	if (tbl) {
		for (var i=1;i<tbl.rows.length;i++) {
			if ((tbl.rows[i].className=="clsRowSelected")||(document.getElementById("selectz"+i).checked==true)) {
				rowTotal=rowTotal+1;
				if (selRow==0) selRow=i
				if (document.getElementById("statz"+i).value!="D") {
					alert(t["DoneOnly"]);
					return false;
				}
			}
		}
		if (selRow==0) {
			alert(t['RBOPNonSelected']);
			return false;
		}
		if (rowTotal>1) alert(t["FirstSelected"]);
		lnk+="&Readmit=1&ID="+document.getElementById("OperRoomIDz"+selRow).value+"&PatientID="+document.getElementById("PatientIDz"+selRow).value+"&EpisodeID="+document.getElementById("EpisodeIDz"+selRow).value;
	}
	websys_createWindow(lnk,"",newwin);
}
function RBAppointment_ChangeServiceHandler() {
	try {
		var context=session['CONTEXT'];
		var aryfound=checkedCheckBoxes(f,tbl,"Selectz");
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((aryfound.length==0)&&(selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			if (f.elements['ApptIDz'+rowid].value=="") {
				alert(t['NOSELECTION']);
			} else {
				//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.UpdateBooking&RescID='+RescID+'&date='+dt+'&ApptID='+f.elements['ApptIDz'+rowid].value+'&PatientID='+f.elements['PatientIDz'+rowid].value+'&PatientBanner=1'+'&CONTEXT='+context,'out','top=0,left=0,width=400,height=400');
				// RC 02/05/07 62697 Changed to csp to accomodate a hidden frame for appointment checks
				websys_createWindow("rbappointment.updatebooking.popup.csp?PatientBanner=1&PatientID="+f.elements['PatientIDz'+rowid].value+"&EpisodeID=&locid=&resid="+RescID+"&ApptID="+f.elements['ApptIDz'+rowid].value+"&date="+dt+"&CONTEXT="+context,'out','top=0,left=0,width=400,height=400');
			}
		}
		if (aryfound.length>0) {
			var aryID=new Array();var aryOutcome=new Array();var n=0;
			for (var i=0;i<tbl.rows.length;i++) {
				for (var j=0;j<aryfound.length;j++) {
					//BR 45216. Only want the items which are selected by the check box if more then 1 item is selected
					//if ((aryfound[j]==i)||(selectedRowObj.rowIndex==i)) {
					if (aryfound[j]==i) {
						aryID[n]=f.elements['ApptIDz'+i].value;
						//alert (aryID[n])
						if (f.elements['OutcomeCodez'+i]) aryOutcome[n]=f.elements['OutcomeCodez'+i].value;
						n++
					}
				}
			}
			//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.UpdateBooking&RescID='+RescID+'&date='+dt+'&ApptID='+aryID.join(",")+'&CONTEXT='+context,'out','top=0,left=0,width=400,height=400');
			// RC 02/05/07 62697 Changed to csp to accomodate a hidden frame for appointment checks
			websys_createWindow("rbappointment.updatebooking.popup.csp?resid="+RescID+"&ApptID="+aryID.join(",")+"&date="+dt+"&CONTEXT="+context,'out','top=0,left=0,width=400,height=400');
		}
	} catch(e) {
		if ((selectedRowObj)&&(selectedRowObj.rowIndex==0)) alert(t['NOSELECTION']);
		if ((selectedRowObj)&&(selectedRowObj.rowIndex>0)) {
			var rowid=selectedRowObj.rowIndex
			//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=RBAppointment.UpdateBooking&RescID='+RescID+'&date='+dt+'&ApptID='+f.elements['ApptIDz'+rowid].value+'&PatientID='+f.elements['PatientIDz'+rowid].value+'&PatientBanner=1'+'&CONTEXT='+context,'out','top=0,left=0,width=400,height=400');
			// RC 02/05/07 62697 Changed to csp to accomodate a hidden frame for appointment checks
			websys_createWindow("rbappointment.updatebooking.popup.csp?PatientBanner=1&PatientID="+f.elements['PatientIDz'+rowid].value+"&EpisodeID=&locid=&resid="+RescID+"&ApptID="+f.elements['ApptIDz'+rowid].value+"&date="+dt+"&CONTEXT="+context,'out','top=0,left=0,width=400,height=400');
		}
	}
}