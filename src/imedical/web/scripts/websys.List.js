// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//Useful functions that perform on List Components
var websys_List_Loaded=1;
//only define it once - for nested components
if (typeof selectedRowObj == "undefined") {
	selectedRowObj=new Object();selectedRowObj.rowIndex="";
}
var blokSelected=""; //For use when the list component is to be used with the epr header

function SelectRow(evt) {
	//this js may be associated to the parent window and so need to check which child window the event is coming from.
	var ary=window.frames;
	if (!evt) for (var i=0;i<ary.length;i++) {try{if (ary[i].event) {evt=ary[i].event;}}catch(e){}}
	if (!evt) evt=window.event;
	var lastSelectedRow=selectedRowObj;
	var evtSrcElm=websys_getSrcElement(evt);
	var rowObj=getRow(evtSrcElm);
	//var tblObj=getTable(evtSrcElm);
	var tblObj=getTable(rowObj);
	//TN:3-aug-05:check that row selected if from a selectable table so it doesn't highlight whole tables inside nested components
	//if (rowObj.tagName != "TH") {
	if ((rowObj.tagName != "TH")&&(tblObj)&&(tblObj.className)&&(tblObj.className.indexOf("tblList")==0)) {
		var winf=EPR_getTopWindow();
		//TN:3-aug-05: use the table object instead because nested components on the same branch will have the same table id
		//if ((lastSelectedRow.rowIndex==rowObj.rowIndex)&&(tblObj.id==getTable(lastSelectedRow).id)) {
		if ((lastSelectedRow.rowIndex==rowObj.rowIndex)&&(tblObj==getTable(lastSelectedRow))) {		
			rowObj.className=lastSelectedRow.PrevClassName;
			if ((lastSelectedRow.PrevBGColour)) {rowObj.style.backgroundColor=lastSelectedRow.PrevBGColour; lastSelectedRow.PrevBGColour='';}
			selectedRowObj=new Object();
			selectedRowObj.rowIndex="";
			//2012/11/16 add by wanghc 要清除头信息的才去清除
		    if (document.getElementById("EpisodeIDz"+rowObj.rowIndex) && document.getElementById("EpisodeIDz"+rowObj.rowIndex).value!=""){
				EPR_ClearSelectedEpisode();
		    }
			//TN:don't call this yet;if (DoBufferCheck(rowObj)) EPR_ClearSelectedEpisode();

			//TN:24-Apr-2002: when deselecting the last highlighted row, don't clear out all ids for lists that allow multiple checkbox selection
			//TN:10-Jan-2006: remove as much try{}catch{} so script errors can be seen easier.
			//try {ClearOnMultipleSelection(rowObj,winf);} catch (e) {}
			if (typeof ClearOnMultipleSelection == "function") {ClearOnMultipleSelection(rowObj,winf);}
			//KM 23-Mar-2002: If there is an event handler in a table it needs to happen irrespective of whether the row is selected or not.
			//TN:24-May-2004: event handler in table should now be called <componentname>_SelectRowHandler()
			try {
				eval("returnValue="+tblObj.tCompName+"_SelectRowHandler();");
			} catch (e) { //TN:24-May-2004: for backwards compatibility
				if (typeof SelectRowHandler == "function") {returnValue=SelectRowHandler();}
				if (typeof SelectRowHandler2 == "function") {returnValue=SelectRowHandler2();}
			}
			try {if (returnValue==false) return false} catch(e) {}
		} else {
			if ((rowObj.className!='clsRowDisabled')&&(rowObj.selectenabled!=0)) {
				rowObj.PrevClassName=rowObj.className;
				if ((rowObj.style.backgroundColor!='')) {rowObj.PrevBGColour=rowObj.style.backgroundColor; rowObj.style.backgroundColor='';}
				rowObj.className='clsRowSelected';
				lastSelectedRow.className=lastSelectedRow.PrevClassName;
				if (lastSelectedRow.PrevBGColour) lastSelectedRow.style.backgroundColor=lastSelectedRow.PrevBGColour;
				selectedRowObj=rowObj;
				var f=getFrmFromTbl(tblObj);
				// for nested lists, get the elements directly instead of using the form
				//TN:7-JULY-2006:don't need getElementsFromRow anymore, EPR_SelectEpisodeDetails based on rowObj
				//if (!f) getElementsFromRow(rowObj,winf);
				if (winf) {
					//2012/4/25 add by wanghc 选中行与菜单头信息无关的跳出
					if (document.getElementById("EpisodeIDz"+rowObj.rowIndex)&& document.getElementById("EpisodeIDz"+rowObj.rowIndex).value!=""){
						EPR_SelectEpisodeDetails(f,rowObj.rowIndex,winf,rowObj);
				
					}
				}
				//TN:don't call this yet;if (winf && DoBufferCheck(rowObj)) EPR_SelectEpisodeDetails(f,rowObj.sectionRowIndex+1,winf,rowObj);
				try {
					eval("returnValue="+tblObj.tCompName+"_SelectRowHandler();");
				}catch (err) {
					if (typeof SelectRowHandler == "function") {returnValue=SelectRowHandler();}
					if (typeof SelectRowHandler2 == "function") {returnValue=SelectRowHandler2();}
				}
				try {if (returnValue==false) return false} catch(e) {}
			}
		}
	}
}

//ANA 07 MAY 2002. This is called from the on load(of your class) to highlight the previously selected row when the page reloads.
function HighlightRow_OnLoad(elementid){
	var obj=window.document.getElementById(elementid);
	if (obj) {
		var obj=getRow(obj);
		obj.click()

	}
}

function getRow(eSrc) {
	while(eSrc.tagName != "TR") {if (eSrc.tagName == "TH") break;eSrc=websys_getParentElement(eSrc);}
	if (eSrc.tagName=="TR") {
		var gotheader=0;
		var tbl=getTable(eSrc);
		// 38689 if there are no column headings set TRAKListIndex = rowIndex+1
		if (tbl.tHead) eSrc.TRAKListIndex=eSrc.rowIndex;
		else eSrc.TRAKListIndex=eSrc.rowIndex+1;
	}
	return eSrc;
}
function getTable(eSrc) {
	if ((eSrc)&&(eSrc.tagName)) while(eSrc.tagName != "TABLE") {eSrc=websys_getParentElement(eSrc);}
	return eSrc;
}

function setRowClass(rowObj) {
	//KM 26-Aug-2002: Can delete this shortly.
	//var selectedRowObj=new Object();
	//var selectedRowObj.PrevClassName="";
	//var cName="";
	//if (rowObj.rowIndex>0) {if (rowObj.rowIndex%2==0) {cName="RowEven";} else {cName="RowOdd";}}
	//return cName;
}

//objmenu=element of the component menu clicked
//namelist=name of the component with "." replaced with "_"
function tk_getTableFromMenu(objmenu,namelist) {
	if (typeof objmenu == "undefined") return null;  //no menu clicked

	var objlistdiv=websys_getParentElement(objmenu);
	while (objlistdiv.id != 'd'+namelist) {
		objlistdiv=websys_getParentElement(objlistdiv);
	}
	var arrtbl=objlistdiv.getElementsByTagName("TABLE");
	for (var i=0; i<arrtbl.length; i++) {
		if (arrtbl[i].id == 't'+namelist) {
			objtbl=arrtbl[i];
			break;
		}
	}
	if (typeof objtbl == "undefined") return null;  //can't find table
	return objtbl;
}
//objtbl=element of the list table
//namecbx=name of checkbox tableitem
//arrGetItems=array of tableitem/s to retrieve from selected rows
function tk_getDataSelRows(objtbl,namecbx,arrGetItems) {
	if (typeof objtbl == "undefined") return arrGetItems;  //can't find table
	var arrRowHighlite = null;
	var count=0;
	for (var i=0; i<objtbl.tBodies[0].rows.length; i++) {
		var arrInput=objtbl.tBodies[0].rows[i].all;
		if ((arrInput[namecbx+"z"+(i+1)])&&(arrInput[namecbx+"z"+(i+1)].checked)) {
			for (id in arrGetItems) {
				var objGet=arrInput[id+"z"+(i+1)];
				if (objGet) {
					if (objGet.tagName=="INPUT") {arrGetItems[id][count]=objGet.value;}
					else {arrGetItems[id][count]=objGet.innerHTML;}
				}
			}
			count++;
		}
		if ((objtbl.tBodies[0].rows[i].className=="clsRowSelected")) {
			arrRowHighlite=new Array();
			for (id in arrGetItems) {
				var objGet=arrInput[id+"z"+(i+1)];
				if (objGet) {arrRowHighlite[id]=new Array(objGet.value);}
			}
		}
	}
	if ((arrRowHighlite)&&(count==0)) {arrGetItems=arrRowHighlite;}
	return arrGetItems;
}

//***Start: Functions for capturing List data and passing to Menu Header.
function EPR_SelectEpisode(el) {
	//TN:7-JULY-2006:shouldn't need to call it anymore
	/***
	var winf=EPR_getTopWindow();
	if (el.tagName=="IMG") el=websys_getParentElement(el);
	//check if is within epr frame
	//note: might need to check against the correct link if more than one link appears for each row/record
	if ((winf)&&(winf.frames['TRAK_eprmenu'])&&(el.tagName=="A")) {
		var arrID=el.id.split("z");
		var selectedrow=arrID[arrID.length-1];
		EPR_SelectEpisodeDetails(selectedrow,winf);
	}****/
}
function EPR_getTopWindow() {
	var winf = null;
	if (window.top != window.self) winf = window.top;
	return winf;
}
//row is a number not the <TR> object
//PACWard.ListPatientsInWard.js,OEOrdItem.RadiologyWorkBench.js,RTRequest.FindMRRequest.js
//TN:7-JULY-2006:get data based on rowObj
function EPR_SelectEpisodeDetails(f,row,winf,rowObj) {
	if (!winf) return;
	//if (!((winf)&&(winf.frames["eprmenu"]))) return;   //removed by wuqk 2010-05-19
	//if ((!f)||(row=="")) return;
	//if (isNaN(row)) return;
	if (typeof rowObj == "undefined") {
		if ((!f)||(row=="")) return;
		if (isNaN(row)) return;
		var oTbl=document.getElementById("t"+f.id.substring(1,f.id.length));
		rowObj = oTbl.rows[row];
	}

	blokSelected=row;
	var MultiEpisodeID="";
	var EpisodeID="";var PatientID="";var mradm="";var title="";var multipleIDs="";
	var WardID="";var Decease="";
	var BillRowIds="";var BillTypes="";
	var RTReqItemID="";var RTReqVolID="";
	var OEOrdItemID="";var OEORIItemStatus="";var ItemApptStatus="";var ARCIMDesc="";
	var PAAdmCodingID=""
	var WaitingListID="";var WLWaitListStatusDR="";
	var apptID="";var FollowUpApptID="";var OperRoomID="";var AnaesthesiaID="";
	var canGiveBirth="";
	var NokID="";
	var SinglePatientFlag="";
	var attendID="";
	// BC 17-Jan-2002 New Flag to indicate a single patient for enabling different behaviour

	//TN:27-OCT-2005:new variables stored in array for easier passing
	//nodes of this array must match form fields from epr.menu.csp
	var HEADERBUFFER=new Array();

	//2012/4/25 add by wanghc 选中行与菜单头信息无关的跳出
    //if (!document.getElementById("EpisodeIDz"+row)) return ;

      // grabs the values from the hidden fields of the rowobject directly
    var rowitems=websys_getChildElements(rowObj.cells[0]);
    if (rowitems.length) {
		var elem=rowitems[0].id.split("z");row=elem[elem.length-1];elem=elem[0];
		if (rowitems["PatientIDz"+row]) {PatientID=rowitems["PatientIDz"+row].value;}
		if (rowitems["EpisodeIDz"+row]) {
			EpisodeID=rowitems["EpisodeIDz"+row].value;
			if (typeof EpisodeIDGetSelected=="function") {
				var arrIDs=EpisodeIDGetSelected(f,row);
				if (arrIDs.join("^")!="") multipleIDs="EpisodeID^"+arrIDs.join("^");
				MultiEpisodeID=arrIDs.join("^");
			}
		}
		if (rowitems["mradmz"+row]) {mradm=rowitems["mradmz"+row].value;}
		if (rowitems["PAPMIEPRDescriptionz"+row]) {title=rowitems["PAPMIEPRDescriptionz"+row].value;}
		//[EPISODES]
		if (rowitems["WardID"]) {WardID=rowitems["WardID"].value;}
		//[MATERNITY]
		if (rowitems["canGiveBirthz"+row]) {canGiveBirth=rowitems["canGiveBirthz"+row].value;}
		//[WAITING LISTS]
		//rqg,log25929
		if (rowitems["WLWaitListStatusDRz"+row]) {WLWaitListStatusDR=rowitems["WLWaitListStatusDRz"+row].value;}
		if (rowitems["WaitingListIDz"+row]) {
			//WaitingListID=rowitems["WaitingListIDz"+row].value;
			var WLID="";
			if (typeof WaitingListIDBuilder=="function") {WLID=WaitingListIDBuilder(WaitingListID);}
			WaitingListID=WLID;
			if (WaitingListID.charAt(WaitingListID.length-1)=="^") {
				WaitingListID=WaitingListID.substring(0,WaitingListID.length-1)
			}
		}
		//[CODING AND GROUPING]
		if (rowitems["PAAdmcodingIDz"+row]) {PAAdmCodingID=rowitems["PAAdmcodingIDz"+row].value;}
		//[BOOKINGS]
		if (rowitems["OperRoomIDz"+row]) OperRoomID=rowitems["OperRoomIDz"+row].value;
		if (rowitems["apptIDz"+row]) {
			apptID=rowitems["apptIDz"+row].value;
		} else if (rowitems["ApptIDz"+row]) {
			// ab 3.5.05 51901
			apptID=rowitems["ApptIDz"+row].value;
			//SB 30/07/02 (26711): Need to pass apptid from worklist to followUp appt to get correct appt details
			//if (rowitems["ApptIDz"+row]) FollowUpApptID=rowitems["ApptIDz"+row].value;
			FollowUpApptID=apptID;
		}
		if (rowitems["AnaesthesiaIDz"+row]) AnaesthesiaID=rowitems["AnaesthesiaIDz"+row].value;
		//[BILLING]
		//KK 23/May/2002 Added BillRowID and BillType
		if (rowitems["BillRowIDz"+row]) {
			var BRID="";
			if (typeof BillRowIdBuilder=="function") {BRID=BillRowIdBuilder(row);} //58455 02.03.06 - AJIW need to pass row
			BillRowIds=BRID;
		}
		if (rowitems["BillTypez"+row]) {
			var BTs="";
			if (typeof BillTypeBuilder=="function") {BTs=BillTypeBuilder(row);} //58455 02.03.06 - AJIW need to pass row
			BillTypes=BTs;
		}
		//[ORDERS]
		if (rowitems["OEOrdItemIDz"+row]) {
			OEOrdItemID=rowitems["OEOrdItemIDz"+row].value;
			if (typeof OEOrdItemIDsGetSelected=="function") {
				var arrIDs=OEOrdItemIDsGetSelected();
				OEOrdItemID=arrIDs.join("^");
				PatientID=arrIDs["PatientID"];EpisodeID=arrIDs["EpisodeID"];mradm=arrIDs["mradm"];
				OEORIItemStatus=arrIDs["OEORIItemStatus"];
				if (WaitingListID=="") {WaitingListID=arrIDs["WaitingListID"];}
				if (ItemApptStatus=="") {ItemApptStatus=arrIDs["ItemApptStatus"];}
				if (Decease=="") {Decease=arrIDs["Decease"];}
				if ((winf)&&(winf.frames["eprmenu"])) {
					winf.frames["eprmenu"].OS=arrIDs["OEOrdSubCategID"];
					winf.frames["eprmenu"].UNAUTH=arrIDs["UNAUTH"];
					// Log 51886 - AI - 11-05-2005 : The list of Radiology Work Bench Result Status for the selected items.
					winf.frames["eprmenu"].RWBResStat=arrIDs["RWBResStat"];
					// Log 62069 - AI - 08-01-2007 : The string of selected Radiology Work Bench Non-Standard Result "flags".
					winf.frames["eprmenu"].RWBNSR=arrIDs["RWBNSR"];
					// Log 62069 - AI - 11-01-2007 : The string of selected Radiology Work Bench Text Result "codes".
					winf.frames["eprmenu"].TextCodes=arrIDs["TextCodes"];
					// Log 61123 TedT variable check if selected orders has same result
					winf.frames["eprmenu"].SameResult=arrIDs["SameResult"];
				}
				title="";apptID="";
			//} else {
			//	OEOrdItemID=rowitems["OEOrdItemIDz"+row].value;
			}
		}
		if (rowitems["ARCIMDescHiddenz"+row]) {ARCIMDesc=rowitems["ARCIMDescHiddenz"+row].value;}
		//[MEDICAL RECORDS]
		if ((rowitems["ReqVolIdsz"+row])&&(rowitems["DelVolIdsz"+row])) {
			if (typeof RTReqItemIDsGetSelected=="function") {
				var arrIDs=RTReqItemIDsGetSelected(f,row);
				RTReqItemID=arrIDs["ReqID"];
				RTReqVolID=arrIDs["VolID"];
			} else {
				RTReqItemID=rowitems["RequestIDz"+row].value;
				RTReqVolID=rowitems["ReqVolIdsz"+row].value;
			}
		}
		//[NEXT OF KIN - cjb 22/02/2006 56793]
		if (rowitems["NOK_RowIdz"+row]) {NokID=rowitems["NOK_RowIdz"+row].value;}
		if (rowitems["NokIDz"+row]) {NokID=rowitems["NokIDz"+row].value;}
		//[OBSCURE ???]
		if (rowitems["SinglePatientFlag"]) {SinglePatientFlag=rowitems["SinglePatientFlag"].value;}
		//[Attendance - TedT 08/01/2007 log 61395]
		if (rowitems["attendIDz"+row]) {
			attendID=rowitems["attendIDz"+row].value;
		}
    }
	if (winf) {
		if (winf.frames["eprmenu"]) {
			winf.frames["eprmenu"].MENU_TRELOADPAGE=winf.frames["TRAK_main"].TRELOADPAGE;
			winf.frames["eprmenu"].MENU_TRELOADID=winf.frames["TRAK_main"].TRELOADID;
		}
		//remove try catch by wuqk 2010-07-05 for side menu
		//try {
			//alert(document.getElementsByName("fEPRMENU"));
			//var frm = parent.document.forms["fEPRMENU"];
			//winf.SetEpisodeDetails     //modify by wuqk 2010-05-20
			var frm=document.getElementsByName("fEPRMENU");
			if (typeof winf.SetEpisodeDetails == "function") {
				winf.SetEpisodeDetails(PatientID,EpisodeID,mradm,title,apptID,WaitingListID,OEOrdItemID,SinglePatientFlag,WardID,PAAdmCodingID,multipleIDs,OEORIItemStatus,BillRowIds,BillTypes,WLWaitListStatusDR,ARCIMDesc,FollowUpApptID,ItemApptStatus,Decease,RTReqItemID,RTReqVolID,canGiveBirth,MultiEpisodeID,OperRoomID,AnaesthesiaID,NokID,attendID);
			}
			
		//} catch(e) {
		//	alert(e.message);
		//}
	}
	return false;
}
// ab & KM - 25.07.02
// for nested lists, get and set the elements directly instead of using the form, since no nested forms
//TN:TN:7-JULY-2006: shouldn't need to call this anymore
function getElementsFromRow(rowObj,winf) {
 if ((!rowObj)||(!winf)) return;
 //TN:TN:7-JULY-2006: call the correct one just in case something is calling this
 EPR_SelectEpisodeDetails(null,null,winf,rowObj);
 return;

 var EpisodeID=""; var PatientID=""; var mradm=""; var title="";
 var apptID=""; var WaitingListID=""; var OEOrdItemID="";var WardID="";var PAAdmCodingID="";
 var BillRowIds=""; var BillTypes=""; var OEORIItemStatus="";  var WLWaitListStatusDR="";
 var ARCIMDesc=""; var SinglePatientFlag=""; var multipleIDs=""; var canGiveBirth="";
 var FollowUpApptID="";var OperRoomID=""; var NokID="";
 var HEADERBUFFER=new Array();

 // grabs the values from the hidden tags in the nested row
 var rowitems=websys_getChildElements(rowObj);
 for (var i=0;i<rowitems.length;i++) {
	if (rowitems[i].tagName=="INPUT") {
		var elem=rowitems[i].id.split("z");
		elem=elem[0];
		if (elem=="EpisodeID") EpisodeID=rowitems[i].value;
		else if (elem=="PatientID") PatientID=rowitems[i].value;
		else if (elem=="WLWaitListStatusDR") WLWaitListStatusDR=rowitems[i].value;
		else if (elem=="SinglePatientFlag") SinglePatientFlag=rowitems[i].value;
		else if (elem=="PAAdmcodingID") PAAdmcodingID=rowitems[i].value;
		else if (elem=="mradm") mradm=rowitems[i].value;
		else if (elem=="PAPMIEPRDescription") title=rowitems[i].value;
		else if (elem=="WardID") WardID=rowitems[i].value;
		else if (elem=="apptID") apptID=rowitems[i].value;
		else if (elem=="WaitingListID") WaitingListID=rowitems[i].value;
		else if (elem=="BillRowID") BillRowIds=rowitems[i].value;
		else if (elem=="BillType") BillTypes=rowitems[i].value;
		else if (elem=="OEOrdItemID") OEOrdItemID=rowitems[i].value;
		else if (elem=="ARCIMDescHidden") ARCIMDesc=rowitems[i].value;
		else if (elem=="canGiveBirth") canGiveBirth=rowitems[i].value;
		//rbapptepisode.list has lower case "d"
		else if (elem=="ApptId") {FollowUpApptID=rowitems[i].value;}
		else if (elem=="OperRoomID") OperRoomID=rowitems[i].value;
		else if (elem=="NokID") NokID=rowitems[i].value;	// cjb 22/02/2006 56793
	}
 }
 if (winf.SetEpisodeDetails) winf.SetEpisodeDetails(PatientID,EpisodeID,mradm,title,apptID,WaitingListID,OEOrdItemID,SinglePatientFlag,WardID,PAAdmCodingID,multipleIDs,OEORIItemStatus,BillRowIds,BillTypes,WLWaitListStatusDR,ARCIMDesc,FollowUpApptID,"","","","",canGiveBirth,"",OperRoomID,HEADERBUFFER,NokID);
 return;
}

//stores the selected patient: mainly for use with onunload
function EPR_SaveSelectedEpisode() {
	var winf = null;
	if (window.parent != window.self) winf = window.parent;
	if ((winf)&&(winf.frames['TRAK_eprmenu'])) {
		winf.document.DivRoomSelected = blokSelected;
	}
}
//TN: 21/2/05: called from SelectRow() to see if patientfield or episodefield in list before clearing menu buffer
// for lists that don't have these fields but want yellow highlighting.
//return 1 if continue with buffer processing.
function DoBufferCheck(objRow) {
	if (!objRow) return 1;
	var flds=objRow.getElementsByTagName("INPUT");
	var doMenuBuffer=0;
	for (var i=0;i<flds.length;i++) {
		if (flds[i].id.indexOf("EpisodeIDz")==0) doMenuBuffer=1;
		else if (flds[i].id.indexOf("PatientIDz")==0) doMenuBuffer=1;
	}
	return doMenuBuffer;
}
//reset last selected patient: mainly for use when first loading up the list ie. event onload
function EPR_ClearSelectedEpisode() {
	//SA & KM 4.2.01: log 22468 Added parent.parent code.
	if (window.parent.parent) {
		var winf=window.parent.parent;
	} else {
		if (window.parent != window.self) winf = window.parent;
	}
	//var winf = window.top;

	if ((winf)&&(winf.frames['eprmenu'])) {
		winf.document.isMainLoaded = 1;
		winf.document.elementID ="";
		winf.frames["eprmenu"].MENU_TRELOADPAGE='';
		winf.frames["eprmenu"].MENU_TRELOADID='';
	}

	if (winf) {try {winf.MainClearEpisodeDetails()} catch(e) {}}
	//if ((winf)&&(winf.frames['eprmenu'])) {winf.MainClearEpisodeDetails();}
}

//once an episode has been selected, the menu's shortcut keys can be accessed
//individual component need to capture the onkeypress event
function EPR_GotoShortcutMenu(evt) {
	if (blokSelected=="") return;
	var keycode;
	try {keycode=websys_getKey(evt);} catch(evt) {keycode=websys_getKey();}
	var key=String.fromCharCode(keycode);
	var winf = null;
	if (window.parent != window.self) winf = window.parent;
	if ((winf)&&(winf.frames['TRAK_eprmenu'])&&(winf.document.isMenuLoaded)) {
		var menu = winf.frames['TRAK_eprmenu'].arrAccessKey[key];
		if (menu) menu.click();
	}
}



function DynamicNameChange() {
	/*Procedure for allowing multiple profiles on the same page is to dynamically change the id of a
	  profiles form, table menu and table list to be unique.  The unique id is obtained from
	  adding the document.forms.length property on to the end of their existing names.

	var df=document.forms;
	alert(df);
	var ltbl=document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
	if (ltbl) {ltbl.id=ltbl.id+df.length,ltbl.Name=ltbl.id;}
	var mtbl=document.getElementById("m"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
	if (mtbl) {mtbl.id=mtbl.id+df.length,mtbl.Name=mtbl.id;}
	df[df.length-1].id=df[df.length-1].id+df.length;df[df.length-1].name=df[df.length-1].name+df.length;
	*/
	// ab 23.03.04 - 42071 should loop through all forms

	var df = document.forms;
	for (var j=0; j<df.length; j++) {
		var ltbl=document.getElementById("t"+df[j].id.substring(1,df[j].id.length));
		if (ltbl) {ltbl.id=ltbl.id+j; ltbl.name=ltbl.id; ltbl.tCompName=df[j].id.substring(1,df[j].id.length);}
		var mtbl=document.getElementById("m"+df[j].id.substring(1,df[j].id.length));
		if (mtbl) {mtbl.id=mtbl.id+j; mtbl.name=mtbl.id;}
		df[j].id=df[j].id+j;
		df[j].name=df[j].name+j;
		if (ltbl) {ltbl.onclick=SelectRow; ltbl.onKeyPress=SelectRow;}
	}
}


function getFrmFromTbl(tblObj) {
	return document.getElementById("f"+tblObj.id.substring(1,tblObj.id.length));
}
function defineTbl(e) {
	var df=document.forms;
	//alert(df.length);
	if (df.length<1) return
	return document.getElementById("t"+df[df.length-1].id.substring(1,df[df.length-1].id.length));
}
function websysListTable_AttachEvents(objtbl) {
	if (typeof objtbl != "undefined") {
		objtbl.onclick=SelectRow;
		objtbl.onKeyPress=SelectRow;
		objtbl.className='tblListSelect';
	}
}
if (!tbl) {var tbl=defineTbl()} else {if (tbl.id!=defineTbl.id) var tbl=defineTbl();}
try {if (tbl) tbl.onclick=SelectRow;} catch(e) {}
try {if (tbl) tbl.onKeyPress=SelectRow;} catch(e) {}
//try {if (tbl) tbl.className='tblListSelect';} catch(e) {}  //removed by wuqk 2010-05-24
//make into function and pass table object.
//try {if (tbl) websysListTable_AttachEvents(tbl);} catch(err) {}
//********* End



//adds a stylesheet rule
//can be used to create a new styleclass to be set against a row for row selection
function tk_AddStyleRule(name,styles) {
	var css=document.styleSheets[document.styleSheets.length-1];
	if (!css) css=document.createStyleSheet();
	if (!css) return;
	css.addRule(name,styles);
}