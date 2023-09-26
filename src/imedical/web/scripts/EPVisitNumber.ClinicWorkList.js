// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//load stylesheet
document.styleSheets[0].addImport("epr.chartbook.side.css",0);

// Set the tbl and tCompName.
var tbl=document.getElementById("tEPVisitNumber_ClinicWorklist");
if (tbl) tbl.tCompName="EPVisitNumber_ClinicWorklist";

var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));


// Because we have the tbl's tCompName property set (above), we can define a component-specific SelectRowHandler.
// This function is for handling links on a row when it is clicked - don't yellow/unyellow (ie. return false), but do something else instead.
function EPVisitNumber_ClinicWorklist_SelectRowHandler(evt) {

//	var eSrc=websys_getSrcElement(evt);
	var eSrc = window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry[0]=='MRN') {
		var row=eSrcAry[1];
		openEpisodeDetails(row);
		return false;
	}
	if (eSrcAry[0]=="ResultsLink") {
		var row=eSrcAry[1];
		//SelectResultHandler(row);
		return false;
	}
}

// Log 58983 - AI - 16-05-2006 : Put at the top because it's run before bodyload (see the call just below the function).
//                             : Go through The HIDDEN "MOColor" fields, setting each row's "ExeTime" cell to that colour.
//                             : Comment all of this out if the class is highlighting the text instead of the entire field.
function DoMOColour() {
	for (var curr_row=1; curr_row<tbl.rows.length; curr_row++) {
		var MOColor=frm.elements["MOColorz" + curr_row].value;
		// We want the whole cell coloured, so use the following :
		if (MOColor!="") document.getElementById("ExeTimez"+curr_row).parentElement.style.backgroundColor=MOColor;
		// If we want just the text within the cell coloured, use the following :
		//if (MOColor!="") document.getElementById("ExeTimez"+curr_row).style.backgroundColor=MOColor;
	}
}

DoMOColour();
// end Log 58983


// Log 48720 - AI - 14-11-2005 : New function to build an array of required variables from the selected rows.
// Called from websys.List.js, EPR_SelectEpisodeDetails function. Copied from OEOrdItem.RadWorkBench.js.
// This function (re)builds the array of selected ("Select checkbox) rows' "useful" IDs, when a row is selected.
function OEOrdItemIDsGetSelected() {
	var arrOEOrdItemIDs=new Array();
	arrOEOrdItemIDs["PatientID"]="";
	arrOEOrdItemIDs["EpisodeID"]="";
	arrOEOrdItemIDs["mradm"]="";
	arrOEOrdItemIDs["OEORIItemStatus"]="";
	// Log 51886 - AI - 11-05-2005 : The list of Radiology Work Bench Result Status for the selected items.
	arrOEOrdItemIDs["RWBResStat"]="";
	var Status="";
	// Log 51886 - AI - 11-05-2005 : The list of Radiology Work Bench Result Status for the selected items.
	var RWBResStat="";
	;
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	// Function checkedCheckBoxes found in websys.List.Tools.js.
	var aryfound=checkedCheckBoxes(frm,tbl,"Selectz");
	if (aryfound.length>0) {
		// If there are "Select" checkboxes selected, get all IDs relevant to the selected rows.
		for (i in aryfound) {
			var row=aryfound[i];
			arrOEOrdItemIDs[i]=frm.elements["OEOrdItemIDz"+row].value;
			// Log 51886 - AI - 11-05-2005 : The list of Radiology Work Bench Result Status for the selected items.
			Status=Status+frm.elements["RadStatusCodez"+row].value+"^";
			if (i==0) {
				// If this is the first selected row, store the PatientID, EpisodeID, and MRAdm values.
				arrOEOrdItemIDs["PatientID"]=frm.elements["PatientIDz"+row].value;
				arrOEOrdItemIDs["EpisodeID"]=frm.elements["EpisodeIDz"+row].value;
				arrOEOrdItemIDs["mradm"]=frm.elements["mradmz"+row].value;
			} else {
				// For subsequent selected row, compare to the first selected row's values.
				//   If different, blank out the stored values (when blank, and error is displayed - multiple Patients, etc).
				if (arrOEOrdItemIDs["PatientID"]!=frm.elements["PatientIDz"+row].value) arrOEOrdItemIDs["PatientID"]="";
				if (arrOEOrdItemIDs["EpisodeID"]!=frm.elements["EpisodeIDz"+row].value) arrOEOrdItemIDs["EpisodeID"]="";
				if (arrOEOrdItemIDs["mradm"]!=frm.elements["mradmz"+row].value) arrOEOrdItemIDs["mradm"]="";
			}
			// Store this row's result type (Word or Text). Used to see if ALL items are allowed in Word or Text.
			// Log 51886 - AI - 11-05-2005 : The list of Radiology Work Bench Result Status for the selected items.
			if (frm.elements["CurrentResultIDz"+row].value != "") RWBResStat=RWBResStat+"W";
			if (frm.elements["TextResultIDz"+row].value != "") RWBResStat=RWBResStat+"T";
			// end Log 51886
		}
		arrOEOrdItemIDs["OEORIItemStatus"]=Status;
		// Log 51886 - AI - 11-05-2005 : The list of Radiology Work Bench Result Status for the selected items.
		arrOEOrdItemIDs["RWBResStat"]=RWBResStat;
	} else {
		// If there are no "Select" checkboxes selected, then do the "yellow" highlight select logic only.
		var rowObj=getRow(eSrc); //row you selected
		if ((rowObj)&&(rowObj.className=="clsRowSelected")) {
			// cheat way of getting the row id - look for "<INPUT id=IDz", then get the character(s) after that string until the next space.
			var stridx=""; var spcidx=""; var rowidx="";
			if (rowObj.cells[0].innerHTML!="") {
				stridx=rowObj.cells[0].innerHTML.indexOf("<INPUT id=IDz");
				if ((stridx!=-1)&&(stridx.length!=0)) spcidx=rowObj.cells[0].innerHTML.indexOf(" ",stridx+10);
				if (spcidx!="") rowidx=rowObj.cells[0].innerHTML.substr(stridx+13,spcidx-(stridx+13));
			}
			if (rowidx!="") {
				arrOEOrdItemIDs["PatientID"]=frm.elements["PatientIDz"+rowidx].value;
				arrOEOrdItemIDs["EpisodeID"]=frm.elements["EpisodeIDz"+rowidx].value;
				arrOEOrdItemIDs["mradm"]=frm.elements["mradmz"+rowidx].value;
			}
		}
	}

	return arrOEOrdItemIDs;
}

// Log 48720 - AI - 07-12-2005 : New function to do the above, when a row is de-selected.
// Called from websys.List.js, SelectRow.
// This function (re)builds the array of selected ("Select checkbox) rows' "useful" IDs, when a row is unselected.
function ClearOnMultipleSelection(objRow,winf) {
	var patID=""; var episID=""; var mradm=""; var itmStat=""; var resStat=""; var multiIDs=""; var orditemIDs="";

	// Calls the above function to get the array.
	var retVal=OEOrdItemIDsGetSelected();

	// Pick out the different IDs to use.
	if (retVal) {
		if (retVal["PatientID"]) patID=retVal["PatientID"];
		if (retVal["EpisodeID"]) episID=retVal["EpisodeID"];
		if (retVal["mradm"]) mradm=retVal["mradm"];
		if (retVal["OEORIItemStatus"]) itmStat=retVal["OEORIItemStatus"];
		if (retVal["RWBResStat"]) resStat=retVal["RWBResStat"];
		if (retVal.join("^")!="") multiIDs="OEOrdItemID^"+retVal.join("^");
		if (retVal.join("^")!="") orditemIDs=retVal.join("^");
	}

	// Set the details found above to the menu frame.
	if (winf) {
		// SetEpisodeDetails found in file epr.frames.csp - "belongs" to the logon object.

		// PatientID,EpisodeID,mradm,title,apptID,WaitingListID,OEOrdItemID,SinglePatientFlag,WardID,PAAdmCodingID,multipleIDs,OEORIItemStatus,BillRowIds,BillTypes,WLWaitListStatusDR,ARCIMDesc,FollowUpApptID,ItemApptStatus,Decease,RTReqItemID,RTReqVolID,canGiveBirth,MultiEpisodeID,OperRoomID,HEADERBUFFER);
		try {winf.SetEpisodeDetails(patID,episID,mradm,"","","",orditemIDs,"","","",multiIDs,itmStat,"","","","","","","","","","","","","");} catch(e) {}

		// This item is not set above (because it is not a generic item used everywhere), therefore set it manually (because we alone need it).
		if (winf.frames["eprmenu"].RWBResStat) winf.frames["eprmenu"].RWBResStat=resStat;
	}
}
// end Log 48720


function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
    var delimArray ="";
	delimArray = s1.split(sep);
	  //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""
    }
}

function DocumentLoadHandler() {
	// if a Nursie worklist
	var objClinicListType=document.getElementById('WIPClinicListType');
	var objWARD=document.getElementById('WLLocation');

	var objNoPrefs=document.getElementById("NoPrefs");
	if (objNoPrefs) {
		objNoPrefs.onclick = NoPrefsClick;
	}

	// Log 49901 YC - Select All Button
	var objSelAll = document.getElementById("SelectAll");
	if (objSelAll) objSelAll.onclick = SelectAll;

	var objPrefParams=document.getElementById("PrefParams");
	var objWorkListParams=document.getElementById("WorkListParams");
	var objPrefLink=document.getElementById("Preferences");
	if (objPrefLink && (objPrefParams.value!="") ) {
		objPrefLink.style.fontWeight="bold";
	}
	
	var objUnread=document.getElementById("WLUnverifiedResults");

	// do we want to use ANY preferences?? - if not -
	// OR if it's nurses workbench...
	if (objNoPrefs && objNoPrefs.checked) {
		// LOG 46660 don't assume current date for nurses WL
		//|| (objClinicListType && (objClinicListType.value=="N")) ){
		// log 65455 YC - only populate date if not looking at unread results only.
		if ((objClinicListType && objClinicListType.value!="R") || ((objUnread && objUnread.checked!=true)||!objUnread)) {
			var today=new Date();
			var objDateFrom=document.getElementById("WLDateFrom");
			var objDateTo=document.getElementById("WLDateTo");
			var DateToday = ReWriteDate(today.getDate(),today.getMonth()+1,today.getYear());
			if (objDateFrom && (objDateFrom.value=="")) {
				objDateFrom.value = DateToday;
			}
			if (objDateTo && (objDateTo.value=="")) {
				objDateTo.value = DateToday;
			}
		}
	} else {
		if (objPrefParams && objWorkListParams) {
			if (objPrefParams.value!="" ) {

				//preferences exist...
				var aryParams = objPrefParams.value.split("^")
				if (aryParams.length > 21) {
					var obj=document.getElementById("WLDateFrom");
					if (obj && (obj.value=="")) {
						if ((aryParams[29]!="") ) {
							obj.value = aryParams[29];
						}
					}
					var obj=document.getElementById("WLDateTo");
					if (obj && (obj.value=="")) {
						if ((aryParams[30]!="") ) {
							obj.value = aryParams[30];
						}
					}
                    // ab 2.06.05 52290
					var obj=document.getElementById("TmFrom");
					if (obj) {
						if ((aryParams[20]!="") ) {
							obj.value = aryParams[20];
						}
					}
					var obj=document.getElementById("TmTo");
					if (obj) {
						if ((aryParams[21]!="") ) {
							obj.value = aryParams[21];
						}
					}
					// Hospital Codes
					if (aryParams[5]!="") {
						var obj = document.getElementById("HospCodes");
						if (obj) {
							var arrhospstr = aryParams[5].split(String.fromCharCode(1));
							var ids = "";
							for (var tmphosp = 0; tmphosp < arrhospstr.length; tmphosp++) {
								var arypiece = arrhospstr[tmphosp].split(String.fromCharCode(2))
								if (arypiece.length > 2) {
									if (ids !="" ) { ids+= "|";}
									ids+= arypiece[2];
								}
							}
							obj.value = ids;
						}
					}
					// Care Provider
					if (aryParams[6]!="") {
						var arrCodes = aryParams[6].split(String.fromCharCode(1));
						/*
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("WLCP");
							if (obj ) {
								obj.value = arrtxt[1];
							}
						}
						*/
					}
					// location
					if (aryParams[8]!="") {
						var strLoc = "";
						var arrCodes = aryParams[8].split(String.fromCharCode(1));
						/*
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("WLSpecialty");
							if (obj) {
								obj.value = arrtxt[1];
							}
						}
						*/
						var obj = document.getElementById("LocIDs");
						if (obj) {
							obj.value = aryParams[22];
						}
					}
					// ward
					if (aryParams[16]!="") {
						var arrCodes = aryParams[16].split(String.fromCharCode(1));
						/*
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("WLLocation");
							if (obj ) {
								obj.value = arrtxt[1];
							}
						}
						*/
					}
				}

			} else {

				// no prefs - so use WorkList defaults
				var aryParams = objWorkListParams.value.split("^");
				if (aryParams.length > 41) {
					var obj=document.getElementById("WLDateFrom");
					if (obj && (obj.value=="")) {
						if ((aryParams[40]!="") ) {
							obj.value = aryParams[40];
						}
					}
					var obj=document.getElementById("WLDateTo");
					if (obj && (obj.value=="")) {
						if ((aryParams[41]!="") ) {
							obj.value = aryParams[41];
						}
					}
					// Hospital Codes
					if (aryParams[22]!="") {
						var obj = document.getElementById("HospCodes");
						if (obj) {
							var arrhospstr = aryParams[22].split(String.fromCharCode(1));
							var ids = "";
							for (var tmphosp = 0; tmphosp < arrhospstr.length; tmphosp++) {
								var arypiece = arrhospstr[tmphosp].split(String.fromCharCode(2))
								if (arypiece.length > 2) {
									if (ids !="" ) { ids+= "|";}
									ids+= arypiece[2];
								}
							}
							obj.value = ids;
						}
					}
					// Care Prov
					if (aryParams[25]!="") {
						var arrCodes = aryParams[25].split(String.fromCharCode(1));
						/*
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("WLCP");
							if (obj ) {
								obj.value = arrtxt[1];
							}
						}
						*/
					}
					// location (unit)
					if (aryParams[33]!="") {
						var arrCodes = aryParams[33].split(String.fromCharCode(1));
						/*
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("WLSpecialty");
							if (obj ) {
								obj.value = arrtxt[1];
							}
						}
						*/
						var obj = document.getElementById("LocIDs");
						if (obj) {
							obj.value = aryParams[43];
						}
					}
					// ward
					if (aryParams[34]!="") {
						var arrCodes = aryParams[34].split(String.fromCharCode(1));
						/*
						if (arrCodes.length==1) {
							var arrtxt = arrCodes[0].split(String.fromCharCode(2));
							var obj = document.getElementById("WLLocation");
							if (obj ) {
								obj.value = arrtxt[1];
							}
						}
						*/
					}
				}

			}  // if (objPrefParams.value!="" )
		}	// if (obj)
	}	// if (objNoPrefs)

	// default today's date if none entered?
}

function NoPrefsClick () {
	var obj = document.getElementById("LocIDs");
	if (obj) {
		obj.value = "";
	}
}
function BedChangeHandler() {
	var objBED=document.getElementById('Bed');
	var objBEDID=document.getElementById('BedID');
	if ((objBED) && (objBEDID)) {
		if (objBED.value=="") objBEDID.value="";
	}

}

function RoomChangeHandler() {
	var objROOM=document.getElementById('Room');
	var objROOMID=document.getElementById('RoomID');
	if ((objROOM) && (objROOMID) && (objROOM.value=="")) {
		objROOMID.value="";
	}
}

// Log 49901 YC - Checks all select boxes when "Select All" is checked.
function SelectAll () {
	var obj = document.getElementById("SelectAll");
	if (obj) {
		var objSelect = document.getElementById("Selectz1");
		var count=1;
		while(objSelect) {
			if(obj.checked==true) objSelect.checked=true;
			else objSelect.checked=false;
			// get next checkbox
			objSelect = document.getElementById("Selectz"+(++count));
		}
	}
}

function DisableKeyDown() {
	return false;
}


// Rather than make ward mandatory it now returns blank if no ward is selected (and in the preferences)
function MandatoryField(fldName) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		fld.disabled = false;
		fld.className = "";
		if (lbl) lbl = lbl.className = "clsRequired";
	}
}

function UnMandatoryField(fldName,icN) {
	var fld = document.getElementById(fldName);
	var lbl = document.getElementById('c'+fldName);
	if (fld) {
		if (lbl) lbl = lbl.className = "";
	}
}


function SelectTab (newtab, newtabcode) {

	var WorkID=document.getElementById('WorkID');
	if (WorkID) WorkID=WorkID.value;
	var WorkName=document.getElementById('WorkName');
	if (WorkName) WorkName=WorkName.value;
	var WIPClinicListType=document.getElementById('WIPClinicListType');
	if (WIPClinicListType) WIPClinicListType=WIPClinicListType.value;
	var WIPNurseTabList=document.getElementById('WIPNurseTabList');
	if (WIPNurseTabList) WIPNurseTabList=WIPNurseTabList.value;
	var frame=document.getElementById('frame');
	if (frame) frame=frame.value;

	var CONTEXT=document.getElementById('CONTEXT');
	if (CONTEXT) {
		var arr = CONTEXT.value.split("_");
		// ab 15.08.06 60448 - pass new tab into context
		CONTEXT=arr[0]+"_"+newtab;
	}

	// remove the currect date/time fields - so we get them afresh

	var TabSelected=document.getElementById('TabSelected');
	if (TabSelected) TabSelected.value = newtab;
	var TabSelectedCode=document.getElementById('TabSelectedCode');
	if (TabSelectedCode) TabSelectedCode.value = newtabcode;

	var RegistrationNo = "";
	var objRegistrationNo=document.getElementById("RegistrationNo");
	if (objRegistrationNo) RegistrationNo=objRegistrationNo.value;
	var PatientBanner= "";
	var objPatientBanner=document.getElementById("PatientBanner");
	if (objPatientBanner) PatientBanner=objPatientBanner.value;
	var DateFrom=document.getElementById("WLDateFrom");
	if (DateFrom) DateFrom="";  //DateFrom.value;
	var DateTo=document.getElementById("WLDateTo");
	if (DateTo) DateTo="";  //DateTo.value;
	var TmFrom=document.getElementById("TmFrom");
	if (TmFrom) TmFrom=TmFrom.value;
	var TmTo=document.getElementById("TmTo");
	if (TmTo) TmTo=TmTo.value;
	DateFrom=""
	DateTo=""
	if (TmFrom==null) TmFrom=""
	if (TmTo==null) TmTo=""
	var Ward=document.getElementById("WLLocation");
	if (Ward) Ward=Ward.value;
	// DON'T pass the location through - as it can be saved diferently for each context
	Ward="";
	var Surname=document.getElementById("Surname");
	if (Surname) {
		Surname=Surname.value;
	} else {
		Surname = "";
	}


	//var url = "epr.worklist.frame.csp?&WLDateFrom="+DateFrom+"&WLDateTo="+DateTo+"&TmFrom="+TmFrom+"&TmTo="+TmTo+"&WLLocation="+escape(Ward)+"&TabSelected="+escape(TabSelected.value)+"&TabSelectedCode="+escape(TabSelectedCode.value)+"&WorkID="+WorkID+"&WorkName="+WorkName+"&WIPClinicListType="+WIPClinicListType+"&frame="+frame+"&WEBSYS.TCOMPONENT=EPVisitNumber.ClinicWorkList";
	var url = "epvisitnumber.clinicworklist.csp?&WLDateFrom="+DateFrom+"&WLDateTo="+DateTo+"&TmFrom="+TmFrom+"&TmTo="+TmTo+"&WLLocation="+escape(Ward)+"&TabSelected="+escape(TabSelected.value)+"&TabSelectedCode="+escape(TabSelectedCode.value)+"&Surname="+Surname+"&WIPNurseTabList="+escape(WIPNurseTabList)+"&WorkID="+WorkID+"&WorkName="+WorkName+"&WIPClinicListType="+WIPClinicListType+"&RegistrationNo="+RegistrationNo+"&PatientBanner="+PatientBanner+"&frame="+frame+"&CONTEXT="+CONTEXT+"&WEBSYS.TCOMPONENT=EPVisitNumber.ClinicWorkList";
	//alert(url);
	window.location.href= url;

}

function BedLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Bed');
	if (obj) obj.value = lu[0];
	var obj=document.getElementById('BedID');
	if (obj) obj.value = lu[3];
}

function RoomLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('Room');
	if (obj) obj.value = lu[0];
	var obj=document.getElementById('RoomID');
	if (obj) obj.value = lu[2];
}

function UnitLookUp(str) {
	var lu = str.split("^");
	var obj=document.getElementById('WLSpecialty');
	if (obj) obj.value = lu[1];
}

document.body.onload = DocumentLoadHandler;

//YC Copied for log 49901
function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"Selectz"); //checkedCheckBoxes() is found in websys.List.Tools.js
	//HitCount var required to force Crystal Web Server to rerun query - see KnowledgeBase Article c2002771
	//Log 19666
	var HitCount=Math.round(Math.random() * 1000)
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
                //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			var hiddenwin=websys_createWindow("","TRAK_hidden","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes");
			//var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="EpisodeID,PatientID,OEOrdItemID">');
				// for each row selected
				//KK 1/10/03 L:39433 - passing OEOrdItemID as well to the report.
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["EpisodeIDz"+row]) continue;
					if (!f.elements["PatientIDz"+row]) continue;
					if (!f.elements["IDz"+row]) continue;
					//KK 5/11/03 L:39967 - Check for values in the hidden fields changed from 'and' to 'or'.
					if ((f.elements["PatientIDz"+row].value!="")||(f.elements["EpisodeIDz"+row].value!="")||(f.elements["IDz"+row].value!="")) {
						document.writeln('<INPUT NAME="PatientID" VALUE="' + f.elements["PatientIDz"+row].value + '">');
						document.writeln('<INPUT NAME="EpisodeID" VALUE="' + f.elements["EpisodeIDz"+row].value + '">');
						document.writeln('<INPUT NAME="OEOrdItemID" VALUE="' + f.elements["IDz"+row].value + '">');
					}
				}
				//Log 63924 - 08.06.2007 - to prevent stack overflow error
				//document.writeln('</FORM><SCR'+'IPT>');
				//document.writeln('window.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
				// Log 44250 - AI - 26-07-2004 : Some sites are getting stack errors when the Print menu is called after selecting a row.
				//document.close();
				document.writeln('</FORM></BODY></HTML>');
				document.close();
				document.HFORM.submit();	
				// End Log 63924 				
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["EpisodeIDz"+row]) continue;
				if (!f.elements["PatientIDz"+row]) continue;
				if (!f.elements["IDz"+row]) continue;
				//alert(f.elements["EpisodeIDz"+row].value + "," + f.elements["PatientIDz"+row].value + "," + f.elements["IDz"+row].value);
				//KK 5/11/03 L:39967 - Check for values in the hidden fields changed from 'and' to 'or'.
				if ((f.elements["EpisodeIDz"+row].value!="")||(f.elements["PatientIDz"+row].value!="")||(f.elements["IDz"+row].value!="")) {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					// PassReportParametersForPreview() is found in websys.Print.Tools.js
					//alert(f.elements["EpisodeIDz"+row].value + "," + f.elements["PatientIDz"+row].value + "," + f.elements["IDz"+row].value);
					//PassReportParametersForPreview(lnk,newwin,f.elements["EpisodeIDz"+row].value,f.elements["PatientIDz"+row].value,f.elements["IDz"+row].value);
				}
			}
		}
	}
}

// Log 56300 YC - Open new window for changing dispense time (need to do it this way to get a window name)
function DispenseTime(OID) {
	//alert(OID);
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow('oeorder.dispensetime.csp?ID='+OID,'DispenseTime','toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes');
	//alert(notes);
	return false;
}

// Log 55309 PeterC 12/01/06
function PatientLeaveAdministration() {
	var PatientID="";
	var EpisodeID="";
	var OEOrdExecIDs="";
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(frm,tbl,"Selectz");
	if (aryfound.length==1) {
		for (i in aryfound) {
			var row=aryfound[i];
			PatientID=frm.elements["PatientIDz"+row].value;
			OEOrdExecIDs=frm.elements["OEOrdExecIDz"+row].value;
			EpisodeID=frm.elements["EpisodeIDz"+row].value;
		}
	}
	if (aryfound.length>1) {
		alert(t['ONEROWONLY']);
		return false;
	}
	if (aryfound.length<1) {
		if (tbl) {
			for (var i=1; i<tbl.rows.length; i++) {
				if(tbl.rows[i].className=="clsRowSelected") {
				 	PatientID=frm.elements["PatientIDz"+i].value;
					OEOrdExecIDs=frm.elements["OEOrdExecIDz"+i].value;
					EpisodeID=frm.elements["EpisodeIDz"+i].value;
				}
			}
		}
	}

	if(PatientID=="") {
		alert(t['NOADMSELECTED']);
		return false;
	}


	var url = "oeorder.patleaveadm.csp?PatientID="+PatientID+"&OEOrdExecIDs="+OEOrdExecIDs+"&PatientBanner=1"+"&EpisodeID="+EpisodeID;
	//alert(url);
        //Log 59598 - BoC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(url,"PatientLeaveAdministration","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
}

//log 60114 BoC 24-08-2006: add new function AdministerClickHandler
function AdministerClickHandler() {
	var rowIndex,EpisodeID,EpisodeIDPre,rowIndexPre;
	var OEORIRowIds="";
	var OEOrdExecIDs="";
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(frm,tbl,"Selectz");
	if (aryfound.length==0) {
		alert (t['NOITEMSSELECTED']);
		return false;
	}
	//alert (frm.elements["OrderTypeCodez"+aryfound[0]].value);
	for (i=0;i<aryfound.length ;i++ )
	{
		rowIndex=aryfound[i];
		if(aryfound[i-1]) rowIndexPre=aryfound[i-1]
		EpisodeID=frm.elements["EpisodeIDz"+rowIndex].value;
		if(rowIndexPre)EpisodeIDPre=frm.elements["EpisodeIDz"+rowIndexPre].value;
		if (EpisodeIDPre && EpisodeID!=EpisodeIDPre) {
			alert (t['DifferentEpisode']);
			return false;
		}
		if (frm.elements["OrderTypez"+rowIndex].value!='R') {
			alert (t['NotDrug']);
			return false;
		}
		if ((frm.elements["AdminQuestionnDRz"+rowIndex].value!="")||(frm.elements["ObservationGroupDRz"+rowIndex].value!="")) {
			if (!(confirm (t['LinkedQueObs']))) return false;
		}
		if (frm.elements["STATCodez"+rowIndex].value!="") {
			alert (t['Administered']);
			return false;
		}

//Log 63496
		if (frm.elements["OkToAdministerz"+rowIndex].value!='Y') {
			alert (t['FutureAdmin']);
			return false;
		}

//
		if(frm.elements["StatusCodez"+rowIndex].value=="H") {
			alert (t['ORDONHOLD2']);
			return false;
		}
		OEORIRowIds=OEORIRowIds+frm.elements["OEOrdItemIDz"+rowIndex].value+"^";
		OEOrdExecIDs=OEOrdExecIDs+frm.elements["OEOrdExecIDz"+rowIndex].value+"^";
		PatientID=frm.elements["PatientIDz"+rowIndex].value;
	}
	var url="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdExec.Multiple.Edit&PatientBanner=1&PatientID="+PatientID+"&OEORIRowIds="+OEORIRowIds+"&OEOrdExecIDs="+OEOrdExecIDs;
    websys_lu(url,'OEOrdExecMultipleEdit','top=50,left=100,width=800,height=600,scrollbars=yes,resizable=yes');
}

// Log 61871 - PJC - Allow Filtering by phone orders and allow them to be signed off
function SignPhoneOrderHandler() {
	var orderIDs="";
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(frm,tbl,"Selectz");
	if (aryfound.length==0) {
		alert (t['NOITEMSSELECTED']);
		return false;
	}
	if (aryfound.length>0) {
		for(i in aryfound){
			var row=aryfound[i];
			orderIDs=orderIDs+frm.elements["OEOrdItemIDz"+row].value+"^";
		}
	}

 var url="websys.default.csp?WEBSYS.TCOMPONENT=EPVisitNumber.ClinicWorkList.SignPhoneOrders&OEORIRowIds="+orderIDs;
    websys_lu(url,'PhoneOrders','top=50,left=100,width=600,height=400,scrollbars=yes,resizable=yes');
}
