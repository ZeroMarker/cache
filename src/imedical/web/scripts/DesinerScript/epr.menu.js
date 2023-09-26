//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

//MENU_TRELOADID and MENU_TRELOADPAGE will contain the treloadid and page name of whatever is in the main window when a selection occurs.
//ie. The page currently loaded in frame TRAK_main at the time a patient was selected from a list or floorplan, just before going off to that menu.
var MENU_TRELOADID='';
var MENU_TRELOADPAGE='';
var MENU_TRELOADURL='';
var currentWardId="";
/***
variables used for menu checking
***/
/*KM 25-Oct-2001: These variables are so that workflows can return to the correct worklist Session.
RBSessIDs: which Sessions List should be displayed in the "sessions" frame
RBSessID: which of the above RBSessIDs should be displayed in the "appointments" frame*/
var RBSessIDs="";var RBSessID=""
//TN 25-Jan-2002:order item variables...
var OC="";var OS="";var UNAUTH="";

// Log 51886 - AI - 11-05-2005 : New global for the string of selected Radiology Work Bench Result Status.
var RWBResStat="";
//TN 27-Oct-2005:episode variables...
var EpisodeType="";var EpisodeStatus="";
// Log 62069 - AI - 08-01-2007 : New global for the string of selected Radiology Work Bench Non-Standard Result "flags".
var RWBNSR="";
// Log 62069 - AI - 11-01-2007 : New global for the string of selected Radiology Work Bench Text Result "codes".
var TextCodes="";
//log61123 TedT
var SameResult="";

/***
3 main functions:
ClearDetails: clears buffer of selected patient(s)/episode(s)/order(s)/etc
PassDetails: pass buffer ids of selected patient(s)/episode(s)/order(s)/etc to menus
CheckLinkDetails: checks that the buffer contains a selected episode before continuation of menu workflow with the buffered episode
***/
function ClearDetails(lnk,newwin) {
	var winf = null;
	if (window.parent != window.self) winf = window.parent;
	if (winf) winf.MainClearEpisodeDetails();
	if (newwin != "")
		websys_lu(lnk,0,newwin);
	else{
		groupMutilTabMenu = groupMutilTabMenu||0;
		if (groupMutilTabMenu==1){
			var srcEl = websys_getSrcElement()
			websys_createWindow(lnk,"TRAK_main","addTab=1,title="+srcEl.innerText);	//
		}else{
			top.frames["TRAK_main"].location = lnk;
		}
	}
	if (winf) {
		winf.document.DivRoomSelected = "";
		winf.document.elementID = "";
		winf.document.elementValue = "";
	}
}

//-----dhc add--------------------------
function SelectToolbar(idbar) {
	//GetTRELOADFromMainFrame();
	var menuBar = document.getElementById(idbar);
	var btn = idbar.split("i");
	var id = btn[0] + btn[1];
	var menu = document.getElementById(id);
	var el;
	if ((tlbar != "") && (tlbar != idbar)) {
		el=document.getElementById(tlbar);
		if (el) {el.style.visibility = "hidden";/*el.style..backgroundcolor="#10f0f0";*/}
		el=document.getElementById(tlbarbtn);
		if (el) {el.style.border = "";/*el.style..backgroundcolor="#00f0f0";*/}
	}

	if (menuBar) {
		if (menuBar.style.visibility == "hidden") {
			menuBar.style.visibility = "visible";
			menuBar.style.display = "";
			tlbar = idbar;
			tlbarbtn = id;

			menu.className="tb1";
			menu.style.borderTop = "1px solid #366798"/*buttonhighlight*/;
			menu.style.borderRight = "0px solid buttonshadow";
			menu.style.borderBottom = "0px solid buttonshadow";
			menu.style.borderLeft = "0px solid buttonhighlight";
			//menu.style.backgroundColor = "#336699";
			menu.style.background="url('../images/bg_menu.jpg')";
            //menu.disabled=true;
			
			menu.style.color="#00ff00";
			//document.getElementsByTagName("link")[0].href="../scripts/tbtest.css"
			///////////////////////
			for (var i=1;i<50;i++)
			{
				if (i!=btn[1]){
					var tbMenu = document.getElementById(btn[0]+i)
					if (tbMenu){
						//document.all.tbMenu.style.className="tb1";
						tbMenu.className="tb";
						tbMenu.style.visibility = "visible";
						tbMenu.style.background = "";
						//tbMenu.style.background = "url('../images/bg_menui.jpg')"
						//tbMenu.style.backgroundColor = "#f3f3f3";
						
						
						/////tbMenu.style.color="#000000";
						//document.getElementsByTagName("link")[0].href="../scripts/tb.css"
						//tb.disabled=false;
					}
					
					
				}
			}
			
			

		}
	}
	parent.document.body.rows="30,*,0";
	ReleaseFieldFocus(top.frames[1]);
}
//--------dhc add end-------------------------

function PassDetails(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	//lnk += "&TWKFLJ="+top.frames["TRAK_main"].TRELOADPAGE+"^"+top.frames["TRAK_main"].TRELOADID;
	if (MENU_TRELOADID!='') lnk += "&TWKFLJ="+MENU_TRELOADPAGE+"^"+MENU_TRELOADID;
	if (frm.MultipleIDs.value) lnk += "&TWKFLL="+frm.MultipleIDs.value;
	lnk += "&PatientID="+frm.PatientID.value + "&EpisodeID="+frm.EpisodeID.value + "&mradm="+frm.mradm.value;

	if (frm.WaitingListID.value) lnk += "&WaitingListID=" + frm.WaitingListID.value;
	if (frm.WardID.value) lnk += "&WardID="+frm.WardID.value;
	//else lnk += "&WardID=" + WardId     //08018  WKZ
	else{
		if(currentWardId!="") lnk += "&WardID=" + currentWardId;
		else {
			lnk += "&WardID=" + WardId;  //removed by wuqk 2010-05-20
		}
	}
	if (frm.PAAdmCodingID.value) lnk += "&PAAdmCodingID=" + frm.PAAdmCodingID.value;
	if (frm.MultiEpisodeID.value) lnk += "&MultiEpisodeID=" + frm.MultiEpisodeID.value;
	if (frm.OEOrdItemID.value) lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value;
	if (frm.apptID.value) lnk+= "&apptID=" + frm.apptID.value;
	if (frm.OperRoomID.value) lnk+= "&OperRoomID=" + frm.OperRoomID.value;
	if (frm.NokID.value) lnk+= "&NokID=" + frm.NokID.value;	//cjb 22/02/2006 56793
	if (frm.AnaesthesiaID.value) lnk+= "&AnaesthesiaID=" + frm.AnaesthesiaID.value; //TN:58239

	//shouldn't need to pass codes nor desc nor flags, just ids
	//for backwards compatibilty keep these 3, but no more should be added
	if (frm.WLWaitListStatusDR.value) lnk += "&WLWaitListStatusDR=" + frm.WLWaitListStatusDR.value; //rqg,log25929
	if (frm.SinglePatientFlag.value) lnk += "&SinglePatientFlag=" + frm.SinglePatientFlag.value;
	if (frm.ARCIMDesc.value) lnk += "&ARCIMDesc=" + frm.ARCIMDesc.value;
	//药理实验项目 add by guorongyong
	if (frm.PPRowId.value) lnk+= "&PPRowId=" + frm.PPRowId.value;
	//alert(lnk);
	if (newwin == "TRAK_hidden")
		top.frames["TRAK_hidden"].location = lnk;
	else if (newwin != ""){
		//websys_lu(lnk,0,newwin);
		if (newwin=='') newwin='width=300,height=380';
		var winname = "TMENUWIN" ; 
		if (lnk.indexOf("TMENU")>-1) winname += lnk.split("TMENU=")[1].split("&")[0];
		var mycurWin = websys_createWindow(lnk,winname,newwin+",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes");
		mycurWin.focus();
	}else{
		groupMutilTabMenu = groupMutilTabMenu||0;
		if (groupMutilTabMenu==1){
			var srcEl = websys_getSrcElement()
			websys_createWindow(lnk,"TRAK_main","addTab=1,title="+srcEl.innerText);	//
		}else{
			top.frames["TRAK_main"].location = lnk;
		}
	}
}
function CheckLinkDetails(lnk,newwin) {
	//alert("Check Deceased");
	var frm = document.forms["fEPRMENU"];
	var EID=frm.EpisodeID.value;
	if(isNaN(EID)){
		if ($.messager){
			$.messager.alert('信息提示',t['NoEpisode'],"info");
		}else{
			alert(t['NoEpisode']);
		}
		return;
	}
	if (frm.EpisodeID.value == "") {
		if ($.messager){
			$.messager.alert('信息提示',t['NoEpisode'],"info");
		}else{
			alert(t['NoEpisode']);
		}
		return;
	}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		if ($.messager){
			$.messager.confirm('信息提示',t['PAT_DECEASED'],function(r){
				if (r){
					PassDetails(lnk,newwin);
				}
			});
			/*走回调方法,返回*/
			return ;
		}else{
			var choice3=confirm(t['PAT_DECEASED'])
			if(choice3==false) return;
		}
	}
	PassDetails(lnk,newwin);
}
/**检查选中病人且在hidden中打开*/
function CheckLinkDetailsHidden(lnk,newwin) {
	//alert("Check Deceased");
	var frm = document.forms["fEPRMENU"];
	var EID=frm.EpisodeID.value;
	if(isNaN(EID)){
		alert(t['NoEpisode']);
		return;
	}

	if (frm.EpisodeID.value == "") {
		alert(t['NoEpisode']);
		return;
	}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED'])
		if(choice3==false) return;
	}
	PassDetails(lnk,"TRAK_hidden");
}
function CheckLinkDetailsDeptAndName(lnk,newwin) {
	//alert("Check Deceased");
	var frm = document.forms["fEPRMENU"];
	var EID=frm.EpisodeID.value;
	if(isNaN(EID)){
		alert(t['NoEpisode']);
		return;
	}
	if (frm.EpisodeID.value == "") {
		alert(t['NoEpisode']);
		return;
	}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED'])
		if(choice3==false) return;
	}
	lnk += tkMakeServerCall("web.DHCViewJHEPR","GetURL",EID);
	PassDetails(lnk,newwin);
}
/***
 other main generic functions
***/
function mPiece(s1,sep,n) {
	//Split the array with the passed delimeter
      delimArray = s1.split(sep);

	//If out of range, return a blank string
      if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
	} else {
	  return ""
      }
}

function CheckPatientDetails(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.PatientID.value == "") {
		alert(t['NoPatient']);
		return;
	}
	PassDetails(lnk,newwin);
}

function CheckLinkDetailsMulti(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.EpisodeID.value == "") {
		alert(t['NoEpisode']);
		return;
	}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED'])
		if(choice3==false) return;
	}

	var tempEpis=mPiece(frm.MultiEpisodeID.value,"^",1)
	if (tempEpis!="") {
		var choice4=confirm(t['EPIS_MULTI'])
		if(choice4==false) return;
	}
	PassDetails(lnk,newwin);
}

function clearWorklistVariables(lnk,newwin) {
	RBSessIDs="";RBSessID="";
	top.frames["TRAK_main"].location = lnk;
}

function websysLastPatientList(lnk,newwin) {
	if (tlbarprev!='') {SelectToolbar(tlbarprev);}
	var pl=top.frames['TRAK_main'].TRELOADPATLIST;
	if (pl!='') {
		var winf = null;
		if (window.parent != window.self) winf = window.parent;
		if (winf) winf.MainClearEpisodeDetails();
		top.frames["TRAK_main"].location = "websys.csp?a=a"+pl;
		var wkf=(pl.split("&")[1]).split("=")[1];
		var pl_lnk=document.getElementById("twkfl"+wkf);
		var pl_btnid="tbi"+websys_getParentElement(pl_lnk).id.split("tb")[1];
		SelectToolbar(pl_btnid);
	} else {
		alert(t['LastPatientList']);
	}
}


/***
 other specific functions for certain modules
***/

//[ORDERS]
function CheckOrderItemDetails(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	var pattern=new RegExp("D","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['DiscontinuedOrder']);
		return;
	}
	var pattern=new RegExp("E","i");
	//PEC 26203 9/7/02 New if condition to by pass the Message "Cannot process executed order"
	/*if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}*/
	if (frm.EpisodeID.value == "") {
		alert(t['DiffEpisode']);
		return;
	}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED'])
		if(choice3==false) return;
	}
	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value;
	//PEC 26203 9/7/02 New if condition to by pass the Message "Cannot process executed order"
	if (UNAUTH!="") lnk+= "&UNAUTH=1";
	if (pattern.test(frm.OEORIItemStatus.value)){ lnk+= "&ReadOnly=1";}
	PassDetails(lnk,newwin);
}
//[END:ORDERS]

//[ORDER RESULTS]
function CheckLinkDetailsVoice(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	var pattern=new RegExp("E","i");
	var pattern2=new RegExp("RESV","i");
	var pattern3=new RegExp("TYP","i");
	//alert(frm.OEORIItemStatus.value);
	var i=0;
	while (mPiece(frm.OEORIItemStatus.value,"^",i)!="") {
		ItmStat=mPiece(frm.OEORIItemStatus.value,"^",i)
		if ((!pattern.test(ItmStat))&&(!pattern2.test(ItmStat))&&(!pattern3.test(ItmStat))) {
			alert(t['NotExecuted'])
			return;
		}
		i+=1;
	}
	var firstat=mPiece(frm.OEORIItemStatus.value,"^",0)
	for (var i=0; mPiece(frm.OEORIItemStatus.value,"^",i)!=""; i++) {
		if (firstat!=mPiece(frm.OEORIItemStatus.value,"^",i)) {
			alert(t['SameStatus']);
			return;
		}
	}
	if (frm.EpisodeID.value == "") {
		alert(t['NoEpisode']);
		return;
	}
	if (frm.PatientID.value == "") {
		alert(t['DiffPatient']);
		return;
	}
	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value + "&OEItemStatus=" + frm.OEORIItemStatus.value;
	//lnk="&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value;
	//alert("newwin="+newwin);
	//alert(lnk);
	PassDetails(lnk,newwin);
}

function CheckLinkDetailsforWordDoc(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	var pattern=new Array("^AUTH^","^S^","^V^","^H^","^D^","^DNA^","^WL^","^W^","^IP^")
	var patt="";
	var ItemStatus="^" + frm.OEORIItemStatus.value;
	if (frm.OEOrdItemID.value!="") {
		for (var i=0;i<pattern.length;i++) {
			patt=pattern[i];
			if (ItemStatus.indexOf(patt)!=-1) {
				alert(t['NotReported']);
				return;
			}
		}
	}
	var firstat=mPiece(frm.OEORIItemStatus.value,"^",0)
	for (var i=0; mPiece(frm.OEORIItemStatus.value,"^",i)!=""; i++) {
		if (firstat!=mPiece(frm.OEORIItemStatus.value,"^",i)) {
			alert(t['SameStatus']);
			return;
		}
	}
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	if (frm.PatientID.value == "") {
		alert(t['DiffPatient']);
		return;
	}
	// Log 51886 - AI - 11-05-2005 : Finally, check that this is not already a "... Text" Result.
	if (RWBResStat.indexOf("T") != -1) {
		alert(t['TextResultExists']);
		return;
	}
	// end Log 51886

	//log61123 TedT
	if(SameResult==0) {
		alert(t['DiffResult']);
		return;
	}

	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value + "&OEItemStatus=" + frm.OEORIItemStatus.value;
	PassDetails(lnk,newwin);
}

//log57642 TedT
function CheckLinkDetailsforFastWordDoc(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];

	var firstat=mPiece(frm.OEORIItemStatus.value,"^",0)
	for (var i=0; mPiece(frm.OEORIItemStatus.value,"^",i)!=""; i++) {
		if (firstat!=mPiece(frm.OEORIItemStatus.value,"^",i)) {
			alert(t['SameStatus']);
			return;
		}
	}
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	if (frm.PatientID.value == "") {
		alert(t['DiffPatient']);
		return;
	}
	// Log 51886 - AI - 11-05-2005 : Finally, check that this is not already a "... Text" Result.
	if (RWBResStat.indexOf("T") != -1) {
		alert(t['TextResultExists']);
		return;
	}
	// end Log 51886
	lnk+= "&execute=1&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value + "&OEItemStatus=" + frm.OEORIItemStatus.value;
	PassDetails(lnk,newwin);
}

function CheckLinkDetailsforWordDocVerify(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	//alert(frm.OEOrdItemID.value);
	//alert(frm.OEORIItemStatus.value);
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	var pattern=new Array("^AUTH^","^S^","^V^","^H^","^D^","^DNA^","^WL^","^W^","^IP^","^E^","^REP^","^RESV^")
	var patt="";
	var ItemStatus="^" + frm.OEORIItemStatus.value;
	if (frm.OEOrdItemID.value!="") {
		for (var i=0;i<pattern.length;i++) {
			patt=pattern[i];
			if (ItemStatus.indexOf(patt)!=-1) {
				alert(t['NotTyped']);
				return;
			}
		}
	}
	var firstat=mPiece(frm.OEORIItemStatus.value,"^",0)
	for (var i=0; mPiece(frm.OEORIItemStatus.value,"^",i)!=""; i++) {
		if (firstat!=mPiece(frm.OEORIItemStatus.value,"^",i)) {
			alert(t['SameStatus']);
			return;
		}
	}

//	if (frm.OEORIItemStatus.value != "Typed") {
//		alert(t['NoOrderItems']);
//		return;
//	}
	/* SB 21/02/03 (32836): We can now verify orders from different patients at the same time.
	if (frm.PatientID.value == "") {
		alert(t['DiffPatient']);
		return;
	}
	*/
	// Log 51886 - AI - 11-05-2005 : Finally, check that this is not already a "... Text" Result.
	if (RWBResStat.indexOf("T") != -1) {
		alert(t['TextResultExists']);
		return;
	}
	// end Log 51886
	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value;
	PassDetails(lnk,newwin);
}

// Log 38063 - AI - 29-10-2004 : New functions for Transcribing and Verifying Text Results.
function CheckLinkDetailsforText(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	//alert(frm.OEOrdItemID.value);
	//alert(frm.OEORIItemStatus.value);
	var pattern1="^E^";
	var pattern2="^REP^";
	var pattern3="^TYP^";
	var pattern4="^RESV^";
	// ab 22.11.06 61465
	var pattern5="^C^";
	// Add a "^" to the front of the Item Status for pattern matching. It already has a "^" at the end.
	var ItemStatus="^" + frm.OEORIItemStatus.value;
	if ((frm.OEOrdItemID.value!="")&&(ItemStatus.indexOf(pattern1)==-1)&&(ItemStatus.indexOf(pattern2)==-1)&&(ItemStatus.indexOf(pattern3)==-1)&&(ItemStatus.indexOf(pattern4)==-1)&&(ItemStatus.indexOf(pattern5)==-1)) {
		alert(t['NotReported']);
		return;
	}
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	if (frm.PatientID.value == "") {
		alert(t['DiffPatient']);
		return;
	}
	// Log 51886 - AI - 11-05-2005 : Finally, check that this is not already a "Word" Result.
	// Log 62069 - AI - 08-01-2007 : Add to this check, if all "W" Status are actually Non-Standard Results, then it is OK to continue.
	//     Go through the RWBResStat string with .indexOf("W"), and for each one, check if the corresponding character in RWBNSR is "Y".
	//     If all corresponding characters are "Y", we are OK to continue. If not, we are still seeing a Word Result !
	for (i=0; i<RWBResStat.length; i++) {
		if (RWBResStat.substr(i,1)=="W") {
			if (RWBNSR.substr(i,1)!="Y") {
				alert(t['WordResultExists']);
				return;
			}
		}
	}
	// end Logs 51886, 62069.

	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value + "&OEItemStatus=" + frm.OEORIItemStatus.value + "&Action=X" + "&TextCodes=" + TextCodes;
	PassDetails(lnk,newwin);
}

//log57642 TedT
function CheckLinkDetailsforFastText(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	if (frm.PatientID.value == "") {
		alert(t['DiffPatient']);
		return;
	}
	// Log 51886 - AI - 11-05-2005 : Finally, check that this is not already a "Word" Result.
	// Log 62069 - AI - 08-01-2007 : Add to this check, if all "W" Status are actually Non-Standard Results, then it is OK to continue.
	//     Go through the RWBResStat string with .indexOf("W"), and for each one, check if the corresponding character in RWBNSR is "Y".
	//     If all corresponding characters are "Y", we are OK to continue. If not, we are still seeing a Word Result !
	for (i=0; i<RWBResStat.length; i++) {
		if (RWBResStat.substr(i,1)=="W") {
			if (RWBNSR.substr(i,1)!="Y") {
				alert(t['WordResultExists']);
				return;
			}
		}
	}
	// end Logs 51886, 62069.

	lnk+= "&execute=1&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value + "&OEItemStatus=" + frm.OEORIItemStatus.value + "&Action=X" + "&TextCodes=" + TextCodes;
	PassDetails(lnk,newwin);
}

function CheckLinkDetailsforTextVerify(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	//alert(frm.OEOrdItemID.value);
	//alert(frm.OEORIItemStatus.value);
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	var pattern="^TYP^";
	// Add a "^" to the front of the Item Status for pattern matching. It already has a "^" at the end.
	var ItemStatus="^" + frm.OEORIItemStatus.value;
	if (ItemStatus.indexOf(pattern)==-1) {
		alert(t['NotTyped'])
		return;
	}

	// Log 61269 - AI - 19-10-2006 : Add this check as per Word Verify (CheckLinkDetailsforWordDocVerify).
	var firstat=mPiece(frm.OEORIItemStatus.value,"^",0)
	for (var i=0; mPiece(frm.OEORIItemStatus.value,"^",i)!=""; i++) {
		if (firstat!=mPiece(frm.OEORIItemStatus.value,"^",i)) {
			alert(t['SameStatus']);
			return;
		}
	}
	// end Log 61269

	// Log 51886 - AI - 11-05-2005 : Finally, check that this is not already a "Word" Result.
	// Log 62069 - AI - 08-01-2007 : Add to this check, if all "W" Status are actually Non-Standard Results, then it is OK to continue.
	//      Go through the RWBResStat string with .indexOf("W"), and for each one, check if the corresponding character in RWBNSR is "Y".
	//      If all corresponding characters are "Y", we are OK to continue. If not, we are still seeing a Word Result !
	// NOTE : Should never get to this, as NSR are "RESV", which cannot be verified again.
	for (i=0; i<RWBResStat.length; i++) {
		if (RWBResStat.substr(i,1)=="W") {
			if (RWBNSR.substr(i,1)!="Y") {
				alert(t['WordResultExists']);
				return;
			}
		}
	}
	// end Logs 51886, 62069.

	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value + "&Action=Y" + "&TextCodes=" + TextCodes;
	PassDetails(lnk,newwin);
}
// end Log 38063

// Log 46532 - BKJ - 24-05-2005 : New function for Delivery.
function CheckLinkDetailsforDelivery(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	//alert(frm.OEOrdItemID.value);
	//alert(frm.OEORIItemStatus.value);
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	if (frm.PatientID.value == "") {
		alert(t['DiffPatient']);
		return;
	}
	if (mPiece(frm.OEOrdItemID.value,"^",1)!="") {
		//alert("Multiple orders are not allowed for the Delivery function");
		alert(t['DeliveryMultipleOrders']);
		return;
	}
	var pattern="^RESV^";
	// Add a "^" to the front of the Item Status for pattern matching. It already has a "^" at the end.
	var ItemStatus="^" + frm.OEORIItemStatus.value;
	if (ItemStatus.indexOf(pattern)==-1) {
		alert(t['NotVerified'])
		return;
	}
	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value + "&Action=Y";
	PassDetails(lnk,newwin);
}
//[END:ORDER RESULTS]

//[RADIOLOGY]
function CheckWLAddDetails(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	// RQG 06.01.03 Log30995 To restrict multiple selection of order items
	var orderitem=frm.OEOrdItemID.value;
	if (mPiece(frm.OEOrdItemID.value,"^",1)!="") {
		//alert("Multiple orders not allowed!");
		alert(t['MultipleOrder']);
		return;
	}
	if (OS=="DIFFERENT") {
		alert(t['DiffOrderSubCateg']);
		return;
	}
	var pattern=new RegExp("D","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['DiscontinuedOrder']);
		return;
	}
	var pattern=new RegExp("E","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	if (frm.EpisodeID.value == "") {
		alert(t['DiffEpisode']);
	return;
	}
	var pattern=new RegExp("REP","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	var pattern=new RegExp("TYP","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	var pattern=new RegExp("RESV","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	var pattern=new RegExp("IP","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	if (frm.EpisodeID.value == "") {
		alert(t['DiffEpisode']);
		return;
	}
	//Log 34932 - Ajiw 15/4/03 - should also allow for cancelled appointments->(X)
	if (frm.ItemApptStatus.value != "" && frm.ItemApptStatus.value != "X") {
		alert(t['APPTWLADD']);
		return;
	}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED']);
		if(choice3==false) return;
	}
	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value;
	//PEC 26203 9/7/02 New if condition to by pass the Message "Cannot process executed order"
	if (UNAUTH!="") lnk+= "&UNAUTH=1";
	if (pattern.test(frm.OEORIItemStatus.value)){ lnk+= "&ReadOnly=1";}
	PassDetails(lnk,newwin);
}
function ExecuteOrderQuantity() {
	var frm = document.forms["fEPRMENU"];
	var pattern=frm.OEORIItemStatus.value;
	var countE=0;
	var splitlen=0;
	var len=pattern.length;
	var strArray=pattern.split(" ");
	var splitlen=strArray.length;
	for (var i=0;i<len;i++)
	{
		if (pattern.charAt(i)=="E") countE ++;
	}
	if (countE > 1) return false;
	if(countE>0 && splitlen>2) return false;
	else return true;
}
function CheckOrderItemAndSubCategory(lnk,newwin) {
	if (!ExecuteOrderQuantity()) {
		alert(t['MultipleExecute']);
		return;
	}
	var frm = document.forms["fEPRMENU"];
	//alert("status="+frm.WLWaitListStatusDR.value);
	if (frm.WLWaitListStatusDR.value == "S") {
		//alert("Suspended Waiting List cannot be actioned");
		alert(t['SuspendedWL']);
		return;
	}
	//log 58638 TedT show no order selected msg first
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	if (frm.EpisodeID.value=="") {
		alert(t['DiffEpisode']);
		return;
	}
	var pattern=new RegExp("D","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['DiscontinuedOrder']);
		return;
	}
	var pattern=new RegExp("E","i");
	//PEC 26203 9/7/02 New if condition to by pass the Message "Cannot process executed order"
	/*if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}*/
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED']);
		if(choice3==false) return;
	}
	//log 57642 TedT added OrdIDtoTranscribe for transcribe
	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value + "&OrdIDtoTranscribe=" + frm.OEOrdItemID.value;
	//lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value + "&ARCIMDesc=" + frm.ARCIMDesc.value;
	if (UNAUTH!="") {
		//alert(t['UnAuthorisedOrders']);
		lnk+= "&UNAUTH=1";
	}
	var AllAtOnce=1;
	if (frm.OEOrdItemID.value.split("^").length>1) AllAtOnce=confirm(t['AllAtOnce']);
	if (AllAtOnce) {
		var msg="";
		if (frm.EpisodeID.value == "") {
			msg+=t['DiffEpisode']+'\n';
		}
		if (OS=="DIFFERENT") {
			msg+=t['DiffOrderSubCateg']+'\n';
		}
		if (msg!="") {alert(msg);return;}
		lnk+= "&AllAtOnce=1&OS="+OS;
		//alert("Sub"+OS);
	} else {
		lnk+= "&AllAtOnce=0";
	}
	//PEC 26203 9/7/02 New if condition to by pass the Message "Cannot process executed order"
	if (pattern.test(frm.OEORIItemStatus.value)) {lnk+= "&ReadOnly=1";}
	PassDetails(lnk,newwin);
}
//[END:RADIOLOGY]

//[WAITING LISTS]
function CheckWaitingListAdmDetails(lnk,newwin) {
	//GR 16.05.03
	var frm = document.forms["fEPRMENU"];
	var WLID=frm.WaitingListID.value
	var text=""
	var arrlnk = WLID.split("^");
	if (arrlnk[1]) text=arrlnk[1];
	//if (text=="") 
	CheckWaitingListDetails(lnk,newwin);
}
function CheckWaitingListDetails(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	//alert(frm.WaitingListID.value)
	//if (frm.WaitingListID.value == "") {
	//	alert(t['XINVALID']);
	//	return;
	//}
	//if (frm.WaitingListID.value == "undefined") {
	//	alert(t['XINVALID']);
	//	return;
	//}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED'])
		if(choice3==false) return;
	}
	if ((frm.WaitingListID.value != "")) {newwin="height=500,width=720,left=35,top=5"}
	//alert("hello "+frm.OEOrdItemID.value);
	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value;
	PassDetails(lnk,newwin);
}
function CheckEpisodeDetailsforApp(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.PatientID.value != "") {newwin="height=500,width=720,left=35,top=5"}
	PassDetails(lnk,newwin);
}
function CheckForEpisodeDetails(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.EpisodeID.value == "") {
		alert(t['NoEpisodeWL']);
		return;
	}
	PassDetails(lnk,newwin);
}
//[END:WAITING LISTS]

//[MATERNITY]
function CheckNewBornLinkDetails(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	// ab 16.07.03 - removed because need to be able to pass through maternity menus without having episode selected
	if (frm.EpisodeID.value == "") {
		if ($.messager){
			$.messager.alert('信息提示',t['NoEpisode'],"info");
		}else{
			alert(t['NoEpisode']);
		}
		return;
	}
	if ((frm.EpisodeID.value!="")&&(frm.canGiveBirth.value==0)) {
		if ($.messager){
			$.messager.alert('信息提示',t['NotFemale'],"info");
		}else{
			alert(t['NotFemale']);
		}
		return;
	}
	PassDetails(lnk,newwin);
}
//[END:MATERNITY]

//[MEDICAL RECORD TRACKING]
//Log 49591 PeterC 15/02/05
function PassDetailsExceptEpis(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if(frm) frm.EpisodeID.value="";

	if (MENU_TRELOADID!='') lnk += "&TWKFLJ="+MENU_TRELOADPAGE+"^"+MENU_TRELOADID;
	if (frm.MultipleIDs.value) lnk += "&TWKFLL="+frm.MultipleIDs.value;

	lnk += "&PatientID="+frm.PatientID.value;
	if (frm.OEOrdItemID.value) lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value;

	if (newwin == "TRAK_hidden")
		top.frames["TRAK_hidden"].location = lnk;
	else if (newwin != "")
		websys_lu(lnk,0,newwin);
	else
		top.frames["TRAK_main"].location = lnk;
}
//BM Log 34846 Bulk Patient use only
function BulkPatientClearDetails(lnk,newwin) {
	var winf = null;
	if (window.parent != window.self) winf = window.parent;
	if (winf) {
		//winf.BulkPatientMainClearEpisodeDetails();
		//don't call menu specific script from epr.frames.csp, code moved here now
		var frm = document.forms["fEPRMENU"];
		var ReqIDs=frm.ReqIDs.value;
		var ReqVolIDs=frm.ReqVolIDs.value;
		//alert(ReqIDs+"****"+ReqVolIDs);
		winf.MainClearEpisodeDetails();
		winf.SetSingleField("ReqIDs",ReqIDs);
		winf.SetSingleField("ReqVolIDs",ReqVolIDs);
	}
	if (newwin != "")
		websys_lu(lnk,0,newwin);
	else
		top.frames["TRAK_main"].location = lnk;
	if (winf) {
		winf.document.DivRoomSelected = "";
		winf.document.elementID = "";
		winf.document.elementValue = "";
	}
}
//[END:MEDICAL RECORD TRACKING]

//[CLINICIAN]
function NextInList(lnk,newwin) {
	var arrlnk = lnk.split("?");
	var newlnk = "paadm.prevornextinlist.csp?ListType=N&"
	if (arrlnk[1]) newlnk += arrlnk[1];
	PassDetails(newlnk,"TRAK_hidden");
}
function PrevInList(lnk,newwin) {
	var arrlnk = lnk.split("?");
	var newlnk = "paadm.prevornextinlist.csp?ListType=P&"
	if (arrlnk[1]) newlnk += arrlnk[1];
	PassDetails(newlnk,"TRAK_hidden");
}
//[END:CLINICIAN]

//[BILLING AND CASHIERS]
//KK 23/May/2002 Log 25345
function ARPBill_CancelSelectedBills(lnk,newwin){
	var BillsOK=true;
	var frm = document.forms["fEPRMENU"];
	if (frm.BillRowIds.value=="") {
		alert(t['NoBill']);
		return;
	}
	//alert(frm.BillRowIds.value);
	var PatientIds="";
	var EpisodeIds="";
	var BillRowIds="";
	var BillType="";
	var NextBillType="";
	var i=1;
	while (mPiece(frm.BillRowIds.value,"^",i)!="") {
		i=i+1;
	}
	var SelectedRows=i;
	//alert(SelectedRows);
	i=0;
	while (mPiece(frm.BillRowIds.value,"^",i)!="") {
		BillRowIds=BillRowIds+mPiece(frm.BillRowIds.value,"^",i)
		EpisodeIds=EpisodeIds+frm.EpisodeID.value;
		PatientIds=PatientIds+frm.PatientID.value;
		BillType=mPiece(frm.BillTypes.value,"^",i)
		NextBillType=mPiece(frm.BillTypes.value,"^",i)
		if (NextBillType=="D") {
			//Deposit lines may not be selected
			alert(t['DepSelect']+" "+t['NoDepsBill']);
			BillsOK=false;
			return;
		}
		if (NextBillType=="ADM") {
			//Admission lines may not be selected
			alert(t['CancelOnlyInvoice']);
			BillsOK=false;
			return;
		}
		if (BillType=="") {
			BillType=NextBillType;
		} else {
			if (BillType!=NextBillType) {
				alert(t['NoPatInsBill']+"\n"+t['OnlySameBill']);
				BillsOK=false;
				return;
			}
		}
		if (i<SelectedRows-1) {
			BillRowIds=BillRowIds+"|";
			PatientIds=PatientIds+"|";
			EpisodeIds=EpisodeIds+"|";
		}
		i=i+1;
	}
	lnk += "&PatientIDs="+PatientIds+"&EpisodeIDs="+EpisodeIds+"&BillRowIDs="+BillRowIds+"&CONTEXT="+session["CONTEXT"];
	PassDetails(lnk,newwin);
}
//KK 23/May/2002 Log 25345
function ARPBill_PrintSelectedBills(lnk,newwin){
	var found=0;
	var BillType="";
	var BillRowID="";
	var PatientID="";
	var EpisodeID="";
	var BillsOK=true;
	var frm = document.forms["fEPRMENU"];
	if (frm.BillRowIds.value=="") {
		alert(t['NoBill']);
		return;
	}
	var i=1;
	while (mPiece(frm.BillRowIds.value,"^",i)!="") {
		i=i+1;
	}
	var SelectedRows=i;
	//alert(SelectedRows);
	i=1;
	while (mPiece(frm.BillRowIds.value,"^",i)!="") {
		BillRowID=BillRowID+mPiece(frm.BillRowIds.value,"^",i)
		EpisodeID=EpisodeID+frm.EpisodeID.value;
		PatientID=PatientID+frm.PatientID.value;
		BillType=mPiece(frm.BillTypes.value,"^",i)
		NextBillType=mPiece(frm.BillTypes.value,"^",i)
		if ((NextBillType!="I")&&(NextBillType!="P")) {
			//bill type other than invoice has been selected.
			alert(t['PrintInvoices']);
			BillsOK=false;
			return false;
		}
		if (BillType=="") {
			BillType=NextBillType;
		}
		if ((BillType!="I")&&(BillType!="P")) {
			alert(t['PrintInvoices']);
			BillsOK=false;
			return false;
		}
		//var row=aryfound[i];
		//cheat to pass EpisodeID for print history description
		var arrParam=lnk.split("&prompt0=");
		lnk=arrParam[0] + "&BillRowID="+BillRowID + "&PatientID="+PatientID;
		//PassReportParameters(lnk,newwin,,,BillRowID,PatientID);
		var arrParam=lnk.split("&prompt");
		var newpath=arrParam[0];
		//alert(lnk+"^"+newpath);
		if (newwin=="TRAK_hidden") {
			//alert("1");
			//window.top.frames["TRAK_hidden"].location = newpath;
			websys_createWindow(newpath,"TRAK_hidden");
			//PassDetails(newpath,newwin);

		} else {
			//alert("2");
			websys_lu(newpath,false,"width="+screen.availWidth+",height="+screen.availHeight);
			//PassDetails(newpath,newwin);
		}
		i=i+1;
	}
	//return false;
}
//[END:BILLING AND CASHIERS]

//[Attendance]

//log 61395 TedT
function CheckAttendance(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.attendID.value=="") {
		alert(t['NOAttend']);
		return;
	}
	lnk+= "&attendID=" + frm.attendID.value+"&ID="+frm.EpisodeID.value;
	PassDetails(lnk,newwin);
}
//[End: Attendance]

//[DEBUGGING]
function PassMenuDetails(lnk,newwin) {
	alert(t['PrintPreview']);
	return;
}
function GetHiddenFromMain() {
	var frm = document.forms["fEPRMENU"];
	lnk += "&PatientID=" + frm.PatientID.value + "&EpisodeID=" + frm.EpisodeID.value + "&mradm=" + frm.mradm.value + "&WLWaitListStatusDR=" + frm.WLWaitListStatusDR.value;
	//alert(lnk);
	//var frm = top.frames["TRAK_main"].document.forms[0];
	//for (var i=0;i<frm.elements.children.length;i++) {
	//alert(frm.elements.children[i].name+": "+frm.elements.children[i].value);
	//}
}
//[END:DEBUGGING]

//??? are these still used?
function CheckItemDetails(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	var pattern=new RegExp("D","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['DiscontinuedOrder']);
		return;
	}
	var pattern=new RegExp("E","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	var pattern=new RegExp("B","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['CannotRebook']);
		return;
	}
	if (frm.EpisodeID.value == "") {
		alert(t['DiffEpisode']);
		return;
	}
	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value;
	if (UNAUTH!="") lnk+= "&UNAUTH=1";
	PassDetails(lnk,newwin);
}
function CheckLinkDetailsMovement(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.EpisodeID.value == "") {
		alert(t['NoEpisode']);
		return;
	}
	PassDetails(lnk,newwin);
}
//KK 06-Feb-2002 for PAWaitingListRB
function CheckOrderItemAndSubCategoryforWLRB(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	//alert(frm.OEOrdItemID.value);
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	if (frm.PatientID.value == "") {
		alert(t['DiffPatient']);
		return;
	}
	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value + "&allOEIDsToLoop=" + frm.OEOrdItemID.value;
	PassDetails(lnk,newwin);
}
function CheckExecuteOrderQuantity() {
	var tbl=document.getElementById("tOEOrdItem_RadiologyWorkBench");
	var count=0;
	if (tbl) {
			for (i=1; i<tbl.rows.length; i++) {
				var obj=document.getElementById("Selectz"+i);
				if ((obj)&&(obj.checked)&&(document.getElementById("OEORIItemStatus"+i).value=="Executed")) {
					count++;
				}
			}
	}
	if(count>1) return false;
	else return true;
}
function CheckItemAppointmentDetails(lnk,newwin) {
	var frm = document.forms["fEPRMENU"];
	if (frm.OEOrdItemID.value == "") {
		alert(t['NoOrderItems']);
		return;
	}
	if (frm.ItemApptStatus.value != "") {
		alert(t['APPT_EXIST']);
		return;
	}
	var pattern=new RegExp("D","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['DiscontinuedOrder']);
		return;
	}
	var pattern=new RegExp("E","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	var pattern=new RegExp("REP","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	var pattern=new RegExp("TYP","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	var pattern=new RegExp("RESV","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	var pattern=new RegExp("IP","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['ExecutedOrder']);
		return;
	}
	var pattern=new RegExp("B","i");
	if (pattern.test(frm.OEORIItemStatus.value)) {
		alert(t['CannotRebook']);
		return;
	}
	if (frm.EpisodeID.value == "") {
		alert(t['DiffEpisode']);
		return;
	}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED']);
		if(choice3==false) return;
	}

	var orddoc=parent.frames["TRAK_main"].document;
	var ordfrm=orddoc.getElementById("fOEOrdItem_RadiologyWorkBench");
	var ordtab=orddoc.getElementById("tOEOrdItem_RadiologyWorkBench");
	var waitliststr=""
	if (ordtab) {
		for (var i=1; i<ordtab.rows.length; i++) {
			var obj=orddoc.getElementById("Selectz"+i);
			var wlid=orddoc.getElementById("WaitingListIDz"+i);
			if ((obj)&&(obj.checked)) {
				if ((wlid)&&(wlid.value!="")) {
					if (waitliststr=="") {
						waitliststr=wlid.value
					} else {
						waitliststr=waitliststr+"^"+wlid.value
					}
				}
			}
		}
		frm.WaitingListID.value=waitliststr
	}

	lnk+= "&OEOrdItemID=" + frm.OEOrdItemID.value;
	if (UNAUTH!="") lnk+= "&UNAUTH=1";
	PassDetails(lnk,newwin);
}
//???







//Pacs
var curPrintObject;

function PrintPaidExamItem(lnk,newwin)
{
  var frm = document.forms["fEPRMENU"]; 
  var orddoc=parent.frames["TRAK_main"].document;
  var ordfrm=orddoc.getElementById("fDHCRisWorkBenchEx");
  var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
  
  var Info="";
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        var BillStatus=orddoc.getElementById("TBillStatusz"+i).innerText;
        var OEORIItemStatus=orddoc.getElementById("OEORIItemStatusz"+i).value;
        if ((selectedobj)&&(selectedobj.checked))
        {
	      if (BillStatus=="P")
	      {
	        var regno=orddoc.getElementById("PatientIDz"+i).innerText;
	        var PAPMName=orddoc.getElementById("TPatientNamez"+i).innerText;
	      	var OrdDesc=orddoc.getElementById("ARCIMDescz"+i).innerText;
	      	var price=orddoc.getElementById("TotalFeez"+i).innerText;
	      	var printman=session['LOGON.USERCODE'];
	      	var printdate=DateDemo();
	      	if (Info=="")
	      	{
	        	 Info=regno+"^"+PAPMName+"^"+OrdDesc+"^"+price+"^"+printman+"^"+printdate;
	      	}
	      	else
	      	{
		    	 Info=Info+"&"+regno+"^"+PAPMName+"^"+OrdDesc+"^"+price+"^"+printman+"^"+printdate;
	      	}
	   	   }
	       else
	       {
	         alert(t['cantbill']);
	       }
        } //select
       }// for 
       
    // alert(Info);
    
    if (Info=="")  return
    if (curPrintObject)
     	 curPrintObject.PrintExamItem(t['Tilte'],Info);
     else
     {
     	 curPrintObject= new ActiveXObject("RISPrint.CPrintExamItem");
         curPrintObject.PrintExamItem(t['Tilte'],Info);
     }
     
  }//ord
  
   //PassDetails(lnk,newwin);
}

function DateDemo()
{
   var d, s="";           
   d = new Date();                         
   s += d.getDate() + "/";           
   s += (d.getMonth() + 1) + "/";   
   s += d.getYear();                     
   return(s);                            
}


function CheckItemDetailsBooking(lnk,newwin) {
	
  var frm = document.forms["fEPRMENU"]; 
  var orddocM=parent.frames["TRAK_main"].document;
  orddoc=orddocM.frames["DHCRisWorkBench"].document;
  var ordfrm=orddoc.getElementById("fDHCRisWorkBenchEx");
  var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
  var oeorditemrowid ="";
  var EpisodeID;
  var Num=0
  if (ordtab) 
  {
	 //alert(ordtab.rows.length);
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        var OEORIItemStatus=orddoc.getElementById("OEORIItemStatusz"+i).value;
        if ((selectedobj)&&(selectedobj.checked))
        {
	      if ((OEORIItemStatus=="B")||(OEORIItemStatus=="A"))
	      {
		    var OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
      		EpisodeID=orddoc.getElementById("EpisodeIDz"+i).value;
   
	        if (oeorditemrowid=="")
	      	{
	        	 oeorditemrowid=OEOrdItemID;
	      	}
	      	else
	      	{
		    	 oeorditemrowid=oeorditemrowid+"^"+OEOrdItemID;
	      	}
	      	Num=Num+1
	   	  }
	   	  else
	   	  {
		   	  alert(t['ordstatus']);
		   	  return;
	   	  }
        }//select
      }// for 
    }
    frm.OEOrdItemID.value=oeorditemrowid;
    frm.EpisodeID.value=EpisodeID;
    if (Num>1)
    {
	    alert(t['NoSelectMorePatient']);
	    return;
	} 
      //alert(frm.OEOrdItemID.value);
      //alert(oeorditemrowid)
       if (frm.EpisodeID.value == "")
      {
		alert(t['NoOrderItems']);
		return;
	}
     
	if (frm.OEOrdItemID.value == "")
	{
		alert(t['NoOrderItems']);
		return;
	}
	PassDetails(lnk,newwin);
	
	
}
//////
//////
function CheckItemDetailsCancelBooked(lnk,newwin) {
	
	
  var frm = document.forms["fEPRMENU"]; 
  var orddocM=parent.frames["TRAK_main"].document;
  orddoc=orddocM.frames["DHCRisWorkBench"].document;
  var ordfrm=orddoc.getElementById("fDHCRisWorkBenchEx");
  var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
  var num=0
  
  var oeorditemrowid ="";
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        var OEORIItemStatus=orddoc.getElementById("OEORIItemStatusz"+i).value;
        if ((selectedobj)&&(selectedobj.checked))
        {
	      if (OEORIItemStatus=="B")
	      {
		    var OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
           	var paadmdr=orddoc.getElementById("EpisodeIDz"+i).value
		    num=num+1;
	   	  }
	   	  else
	   	  {
		   	    alert(t['ordstatus']);
		   	    return ;
	   	  }
        }//select
      }// for 
    }
    
    //alert(frm.PatientID.value);
    if ((num>1)||(num==0))
    {
	    //alert(t['CaCancelBooked']);
	   alert(t['NoSelectMorePatient']);
	    return ;
    }
    
    frm.OEOrdItemID.value=OEOrdItemID;
    frm.EpisodeID.value=paadmdr;
     
    //alert(frm.OEOrdItemID.value);
     
	if (frm.OEOrdItemID.value == "")
	{
		alert(t['NoOrderItems']);
		return;
	}
	PassDetails(lnk,newwin);
	
	
}

/////////////


function CheckItemDetailsRegister(lnk,newwin) {

  var frm = document.forms["fEPRMENU"]; 
  var orddoc=parent.frames["TRAK_main"].document;
  var ordtab=orddoc.getElementById("tDHCRisWorkBench");
  var OEOrdItemID ="";
  var paadmdr="",paadmtype
  var num=0;

  
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	      var OEORIItemStatus=orddoc.getElementById("OEORIItemStatusz"+i).value;
	      	//lgl+
	      	var BillStatus=orddoc.getElementById("TBillStatusz"+i).innerText;
		    //var OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
         	//var paadmdr=orddoc.getElementById("EpisodeIDz"+i).value;
         	var paadmtype=orddoc.getElementById("TPatientTypez"+i).innerText;  //lgl xiugai value;
            //alert(BillStatus);

	      if ((OEORIItemStatus=="V")||(OEORIItemStatus=="S")||(OEORIItemStatus=="E"))
	      {
		    //alert("aaa1");
		    var BillStatus=orddoc.getElementById("TBillStatusz"+i).innerText;
		    var OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
         	var paadmdr=orddoc.getElementById("EpisodeIDz"+i).value;
         	var paadmtype=orddoc.getElementById("TPatientTypez"+i).innerText;  //lgl xiugai value;
		    //alert("aaa2");
		    num=num+1;
	      }
	      else
	      {
		      alert(t['cantregister']);
		      return;
		  }
		}//select
      }// for 
    }
    if ((num>1)||(num==0))
    {
	    alert['NoSelectMorePatient'];
	    return ;
    }
    frm.OEOrdItemID.value =OEOrdItemID;
    frm.EpisodeID.value=paadmdr
    if ((BillStatus!="P")&&(paadmtype==t['OUTPAT']))
    {
	 
	    //alert(t['PleaseBilled']);
	    
	    //return ;
    }

     
	if (OEOrdItemID == "")
	{
		alert(t['NoOrderItems']);
		return;
	}

	if (paadmdr == "") {
		alert(t['DiffEpisode']);
		return;
	}
    
	PassDetails(lnk,newwin);
	
	
	
}

function CheckItemDetailsUnRegister(lnk,newwin) {

  var frm = document.forms["fEPRMENU"]; 
  var orddocM=parent.frames["TRAK_main"].document;
  orddoc=orddocM.frames["DHCRisWorkBench"].document;
  var ordfrm=orddoc.getElementById("fDHCRisWorkBenchEx");
  var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
    
  var OEOrdItemID="";
  var paadmdr="";
  var oeorditemrowid ="";
  var num=0;
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
         var OEORIItemStatus=orddoc.getElementById("OEORIItemStatusz"+i).value;
         
         if ((selectedobj)&&(selectedobj.checked))
        {
	      if (OEORIItemStatus=="I")
	      {
		     oeorditemrowid=orddoc.getElementById("OEOrdItemIDz"+i).value;
		     if (OEOrdItemID=="")
		     {
			     OEOrdItemID=oeorditemrowid;
		     }
		     else
		     {
			     OEOrdItemID=OEOrdItemID+"@"+oeorditemrowid;
			     
		     }
    		 paadmdr=orddoc.getElementById("EpisodeIDz"+i).value
      	     num=num+1;
	      }
	      else
	      {
		      alert(t['cantunregister']);
		      return;
		  }
		}//select
      }// for 
    }
    //alert("select!");
    if ((num>1)||(num==0))
    {
	    alert(t['NoSelectMorePatient']);
	    return ;
    }
    frm.OEOrdItemID.value =OEOrdItemID;
    frm.EpisodeID.value=paadmdr
    
       
	if (frm.OEOrdItemID.value == "")
	{
		alert(t['NoOrderItems']);
		return;
	}
	
	if (frm.EpisodeID.value == "") {
		alert(t['DiffEpisode']);
		return;
	}

	PassDetails(lnk,newwin);
	
 }


function GetReportInfo(lnk,newwin) {
 var frm = document.forms["fEPRMENU"]; 
  var orddoc=parent.frames["TRAK_main"].document;
  //var ordfrm=orddoc.getElementById("fDHCRisWorkBench");
  var ordtab=orddoc.getElementById("tDHCRisWorkBench");

  var OEOrdItemID ="";
  var paadmdr=""
  var num=0;
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
       
        if ((selectedobj)&&(selectedobj.checked))
        {
	      var OEORIItemStatus=orddoc.getElementById("OEORIItemStatusz"+i).value;
          if ((OEORIItemStatus=="E")||(OEORIItemStatus=="REP")||(OEORIItemStatus=="RESV"))
	      {
		    var OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
         	var paadmdr=orddoc.getElementById("EpisodeIDz"+i).value
		    num=num+1;
	      }
	      else
	      {
		      alert(t['cantCallReport']);
		      return;
		  }
		}//select
      }// for 
    }
    if ((num>1)||(num==0))
    {
	    alert['NoSelectMorePatient'];
	    return ;
    }
    frm.OEOrdItemID.value =OEOrdItemID;
    frm.EpisodeID.value=paadmdr
    
     
	if (OEOrdItemID == "")
	{
		alert(t['NoOrderItems']);
		return;
	}
	
	if (paadmdr == "") {
		alert(t['DiffEpisode']);
		return;
	}
    
    var userid=session['LOGON.USERID'];
    
    
	var ReportOBJ = new ActiveXObject("ReportDll.CReport.1");	
	ReportOBJ.ShowReport(frm.OEOrdItemID.value,userid);

	
}

//send Film
function CheckSendFilm(lnk,newwin) {

 var frm = document.forms["fEPRMENU"]; 
  var orddocM=parent.frames["TRAK_main"].document;
  orddoc=orddocM.frames["DHCRisWorkBench"].document;
  var ordfrm=orddoc.getElementById("fDHCRisWorkBenchEx");
  var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
 
  var OEOrdItemID ="";
  var paadmdr="",paadmtype
  var num=0;

  
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        if ((selectedobj)&&(selectedobj.checked))
        {
	      var OEORIItemStatus=orddoc.getElementById("OEORIItemStatusz"+i).value;
	      	//lgl+
	      	var BillStatus=orddoc.getElementById("TBillStatusz"+i).innerText;
		    //var OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
         	//var paadmdr=orddoc.getElementById("EpisodeIDz"+i).value;
         	var paadmtype=orddoc.getElementById("TPatientTypez"+i).innerText;  //lgl xiugai value;
            //alert(BillStatus);

	      if ((OEORIItemStatus=="A")||(OEORIItemStatus=="B"))
	      {
		      alert(t['cantsendFilm']);
		      return;
		   }
	      else
	      { 
	       //alert("zz");
	        var BillStatus=orddoc.getElementById("TBillStatusz"+i).innerText;
		    var OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
         	var paadmdr=orddoc.getElementById("EpisodeIDz"+i).value;
         	var paadmtype=orddoc.getElementById("TPatientTypez"+i).innerText;  //lgl xiugai value;
		    //alert("aaa2");
		    num=num+1;
		    
		  }
		}//select
      }// for 
    }
    if ((num>1)||(num==0))
    {
	    alert(t['NoSelectMorePatient']);
	    return ;
    }
    frm.OEOrdItemID.value=OEOrdItemID;
    frm.EpisodeID.value=paadmdr;
       
	if (OEOrdItemID == "")
	{
		alert(t['NoOrderItems']);
		return;
	}

	if (paadmdr == "") {
		alert(t['DiffEpisode']);
		return;
	}
	PassDetails(lnk,newwin);
	
	
	
}

/** modify by wuqk 2010-09-01; code copy from 2010-07-26 xyzh's web scripts,modify by xuqy */
function PrintTemp()
{
   
    // var a="#(RepeatOrdersFromEPR)#"
   //Temp= new ActiveXObject("PrintBar.PrnBar");//TestAx.CLSMAIN
  // var ServerNameSpace="#(ServerNameSpace)#";
   //alert(ServerNameSpace)
   //var ward=WardId;
   //var frm = document.forms["fEPRMENU"];        //090310
   //var EID=frm.EpisodeID.value;                 //090310
   //var serverIp=cspRunServerMethod(GetServerNameSpace);

	var win=top.frames['eprmenu'];
	if (win) {
		var frm=win.document.forms['fEPRMENU'];
	}else{
		var frm=top.document.forms['fEPRMENU'];
	}
	var EID=frm.EpisodeID.value;
	var ward=WardId;
	
	if (ServerNameSpace=="") return;
	if (ward==""){
	   alert("请选择病区");
	   return;
	}
   
	var frameCenter=top.frames['panel_Center'];
	var Temp;
	Temp= new ActiveXObject("ThreeColor.CLSMAIN");//TestAx.CLSMAIN
	Temp.ward = ward;
	Temp.UserId =session['LOGON.USERID'];
	Temp.ConnectString=ServerNameSpace;
	Temp.Show();

}
function PreviewTemp()
{
	var TempPre;
	var frm = document.forms["fEPRMENU"];
	var EID=frm.EpisodeID.value;
	if(isNaN(EID)){
		alert(t['NoEpisode']);
		return;
	}

	if (frm.EpisodeID.value == "") {
		alert(t['NoEpisode']);
		return;
	}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED'])
		if(choice3==false) return;
	}
	TempPre= new ActiveXObject("Temp.ClsTemp");//TestAx.CLSMAIN
	TempPre.Adm = EID;
	TempPre.ConnectString = ServerNameSpace;
	TempPre.patname = ""
	TempPre.bedcode = ""
	TempPre.Show();

}
function BrowseAppBillFunction()
{
  var frm = document.forms["fEPRMENU"]; 
  var orddocM=parent.frames["TRAK_main"].document;
  orddoc=orddocM.frames["DHCRisWorkBench"].document;
  var ordfrm=orddoc.getElementById("fDHCRisWorkBenchEx");
  var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
    
  var OEOrdItemID="";
  var paadmdr="";
  var oeorditemrowid ="";
  var num=0;
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
         var OEORIItemStatus=orddoc.getElementById("OEORIItemStatusz"+i).value;
         
         if ((selectedobj)&&(selectedobj.checked))
         {
	         OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
    		 paadmdr=orddoc.getElementById("EpisodeIDz"+i).value
      	     num=num+1;
	     }
      }// for 
    }
    var link="websys.default.csp?WEBSYS.TCOMPONENT=DHCRisAppBillBrowse"+"&OEOrdItemID="+OEOrdItemID;    
    var mynewlink=open(link,"DHCRisAppBillBrowse","scrollbars=yes,resizable=yes,top=6,left=6,width=1000,height=680");
}
//DHCShowStatusTitle();  //remove by wuqk 2010-08-27
function DHCShowStatusTitle(){
	window.defaultStatus=session['LOGON.USERCODE']+"     "+session['LOGON.USERNAME'] + "    "+session['LOGON.GROUPDESC']+ "    "+LocDesc;	
	var myStatusTip="^"+session['LOGON.USERCODE']+"     "+session['LOGON.USERNAME'] + "    "+session['LOGON.GROUPDESC']+ "    "+LocDesc;
	var myary=top.document.title.split("^");
	top.document.title=myary[0]+ "    "+myStatusTip
}

//sunyi 2011-09-22
function CheckItemStatus(lnk,newwin) 
{
	
  var frm = document.forms["fEPRMENU"]; 
  var orddocM=parent.frames["TRAK_main"].document;
  orddoc=orddocM.frames["DHCRisWorkBench"].document;
  var ordfrm=orddoc.getElementById("fDHCRisWorkBenchEx");
  var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
  var oeorditemrowid ="";
  var EpisodeID;
  var Num=0
  var StudyNo;
  
  if (ordtab) 
  {
	 //alert(ordtab.rows.length);
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
        var Status=orddoc.getElementById("TStatusz"+i).innerText;
     
        if ((selectedobj)&&(selectedobj.checked))
        {
	      if ((Status=="登记")||(Status=="正在检查"))
	      {
		    
		    var OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
      		EpisodeID=orddoc.getElementById("EpisodeIDz"+i).value;
      		//StudyNo=orddoc.getElementById("TStudyNoz"+i).innerText;
      		
	        if (oeorditemrowid=="")
	      	{
	        	 oeorditemrowid=OEOrdItemID;
	      	}
	      	else
	      	{
		    	 oeorditemrowid=oeorditemrowid+"^"+OEOrdItemID;
	      	}
	      	Num=Num+1
	   	  }
	   	  else
	   	  {
		   	  alert(t['ordstatus']);
		   	  return;
	   	  }
        }//select
      }// for 
    }
    frm.OEOrdItemID.value=oeorditemrowid;
    frm.EpisodeID.value=EpisodeID;
    
    if (Num>1)
    {
	    alert(t['NoSelectMorePatient']);
	    return;
	} 
      
    if (frm.EpisodeID.value == "")
    {
		alert(t['NoOrderItems']);
		return;
	}
     
	if (frm.OEOrdItemID.value == "")
	{
		alert(t['NoOrderItems']);
		return;
	}

	PassDetails(lnk,newwin);
	
	
}



//sunyi 2011-12-27
function RejectApplication(lnk,newwin) {

  var frm = document.forms["fEPRMENU"]; 
  var orddocM=parent.frames["TRAK_main"].document;
  orddoc=orddocM.frames["DHCRisWorkBench"].document;
  var ordfrm=orddoc.getElementById("fDHCRisWorkBenchEx");
  var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
    
  var OEOrdItemID="";
  var paadmdr="";
  var oeorditemrowid ="";
  var num=0;
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
         var OEORIItemStatus=orddoc.getElementById("OEORIItemStatusz"+i).value;
         
         if ((selectedobj)&&(selectedobj.checked))
        {
	      if (OEORIItemStatus=="A")
	      {
		     OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
    		 paadmdr=orddoc.getElementById("EpisodeIDz"+i).value
      	     num=num+1;
	      }
	      else
	      {
		      alert(t['NoRejectApp']);
		      return;
		  }
		}//select
      }// for 
    }
    //alert("select!");
    if ((num>1)||(num==0))
    {
	    alert(t['NoSelectMorePatient']);
	    return ;
    }
    frm.OEOrdItemID.value =OEOrdItemID;
    frm.EpisodeID.value=paadmdr
    
       
	if (frm.OEOrdItemID.value == "")
	{
		alert(t['NoOrderItems']);
		return;
	}
	
	if (frm.EpisodeID.value == "") {
		alert(t['DiffEpisode']);
		return;
	}

	PassDetails(lnk,newwin);
	
 }



//sunyi 2011-12-27
function RejectAppBrowse(lnk,newwin) {

  var frm = document.forms["fEPRMENU"]; 
  var orddocM=parent.frames["TRAK_main"].document;
  orddoc=orddocM.frames["DHCRisWorkBench"].document;
  var ordfrm=orddoc.getElementById("fDHCRisWorkBenchEx");
  var ordtab=orddoc.getElementById("tDHCRisWorkBenchEx");
    
  var OEOrdItemID="";
  var paadmdr="";
  var oeorditemrowid ="";
  var num=0;
  if (ordtab) 
  {
     for (var i=1; i<ordtab.rows.length; i++)
     {
        var selectedobj=orddoc.getElementById("TSelectedz"+i);
         var OEORIItemStatus=orddoc.getElementById("OEORIItemStatusz"+i).value;
         
         if ((selectedobj)&&(selectedobj.checked))
        {
	      if (OEORIItemStatus=="R")
	      {
		     OEOrdItemID=orddoc.getElementById("OEOrdItemIDz"+i).value;
    		 paadmdr=orddoc.getElementById("EpisodeIDz"+i).value
      	     num=num+1;
	      }
	      else
	      {
		      alert(t['NoRejectAppBrowse']);
		      return;
		  }
		}//select
      }// for 
    }
    //alert("select!");
    if ((num>1)||(num==0))
    {
	    alert(t['NoSelectMorePatient']);
	    return ;
    }
    frm.OEOrdItemID.value =OEOrdItemID;
    frm.EpisodeID.value=paadmdr
    
       
	if (frm.OEOrdItemID.value == "")
	{
		alert(t['NoOrderItems']);
		return;
	}
	
	if (frm.EpisodeID.value == "") {
		alert(t['DiffEpisode']);
		return;
	}

	PassDetails(lnk,newwin);
	
 }
///护理组医嘱单菜单打开界面方法
function CheckOderSheet(lnk,newwin) {
	//alert("Check Deceased");
	lnk = lnk.replace("http://","");
	var frm = document.forms["fEPRMENU"];
	var EID=frm.EpisodeID.value;
	if(isNaN(EID)){
		alert(t['NoEpisode']);
		return;
	}

	if (frm.EpisodeID.value == "") {
		alert(t['NoEpisode']);
		return;
	}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED'])
		if(choice3==false) return;
	}
	var locId=session['LOGON.CTLOCID'];
	var userId=session['LOGON.USERID'];	
	var webIp = tkMakeServerCall("Nur.DHCMGNurseSet", "getSet").split("^")[1];
	var ServerIP =webIp
	if(ServerNameSpace){
		var httpHead=webIp.split("://")[0];
		var ServerIP = httpHead+"://"+ServerNameSpace.split(":")[1].split("[")[0];
	}
	lnk = webIp+lnk;
	lnk += "&locId="+locId+"&userId="+userId+"&webIp="+ServerIP;
	PassDetails(lnk,newwin);
}
/// 重症监护组, 血液净化增加
function StartICUMonitoring(lnk,newwin){
	var frm = document.forms["fEPRMENU"];
	var EID=frm.EpisodeID.value;
	if(isNaN(EID)){
		alert(t['NoEpisode']);
		return;
	}

	if (frm.EpisodeID.value == "") {
		alert(t['NoEpisode']);
		return;
	}
	var pattern=new RegExp("Y","i");
	if (pattern.test(frm.Decease.value)) {
		var choice3=confirm(t['PAT_DECEASED'])
		if(choice3==false) return;
	}
	//YuanLin 20190725 医生科室需调用护士科室Id
	var monId=""
	var userId=session['LOGON.USERID'];
	var userCtlocId=session['LOGON.CTLOCID']
	var userType=tkMakeServerCall("web.DHCClinicCom", "GetCtcptType",userId)
	if (userType=="NURSE") monId=tkMakeServerCall("web.DHCICUCom", "GetIcuaId",EID,"",userId,"Y","Y",userCtlocId)
	else monId=tkMakeServerCall("web.DHCICUCom", "GetIcuaId",EID,"",userId)
	var ctLocId=tkMakeServerCall("web.DHCICUCom", "GetWardCtlocId","",monId)
	if (ctLocId=="") ctLocId=userCtlocId
	//
	var filePath = window.location.href.split("csp")[0] + "/service/dhcclinic/";
	var icuMonitoringLink = "../service/dhcclinic/app/icu/Main.application?icuaId=" + "&admId=" + EID + "&userId=" + session["LOGON.USERID"] + "&groupId=" + session["LOGON.GROUPID"] + "&locId=" + ctLocId + "&connString=" + ServerNameSpace + "&filePath=" + filePath + "&total=";
	//window.location.href=lnk;
	//window.open(icuMonitoringLink);
	//PassDetails(lnk,newwin);
	var flag = isAccessMP("ICU-01","ICU-02");	
	if (flag==1){
    	window.open(icuMonitoringLink);
	}else{
    	var url = flag.split("^")[1];  //打开受限提示界面
    	websys_lu(url,false,"top=20,left=20,width="+(screen.availWidth-200)+",height="+(screen.availHeight-200));
	}
}
/// 重症监护组, 血液净化
function StartICUStatistic(lnk,newwin){
	var filePath = window.location.href.split("csp")[0] + "/service/dhcclinic/";
	var icuMonitoringLink = "../service/dhcclinic/app/icu/Main.application?icuaId=" + "&admId=" + "&userId=" + session["LOGON.USERID"] + "&groupId=" + session["LOGON.GROUPID"] + "&locId=" + session['LOGON.CTLOCID'] + "&connString=" + ServerNameSpace + "&filePath=" + filePath + "&total=AutoTotalTemplateView";
	//window.location.href=lnk;
	window.open(icuMonitoringLink);
	PassDetails(lnk,newwin);
}
/// 重症监护组,血液净化
function StartBPMonitoring(lnk,newwin){

	if ("undefined"==typeof EnableLocalWeb || 0==EnableLocalWeb ){
    	//未开启使用中间件 或 老项目，然仍用老的方式运行
    	var filePath = window.location.href.split("csp")[0] + "/service/dhcclinic/";
		var bpMonitoringLink = "../service/dhcclinic/app/bp/DHCClinic.BP.Main.application?monId="+"&userId=" + session["LOGON.USERID"] + "&groupId=" + session["LOGON.GROUPID"] + "&ctlocId=" + session['LOGON.CTLOCID'] + "&connString=" + ServerNameSpace + "&filePath=" + filePath ;
		var flag = isAccessMP("BP-01","BP-01");
		if (flag==1){
    		window.open(bpMonitoringLink);
		}else{
    		var url = flag.split("^")[1];  //打开受限提示界面
    		websys_lu(url,false,"top=20,left=20,width="+(screen.availWidth-200)+",height="+(screen.availHeight-200));
		}
	}else{
		//中间件运行,此处的DoctorSheet为配置界面的调用ID
		//var tmpServerNameSpace="cn_iptcp:114.251.235.112[1972]:DHC-APP" //测试写死
		//BloodPurification.Show(session["LOGON.USERID"],session["LOGON.GROUPID"],session['LOGON.CTLOCID'],tmpServerNameSpace);
		BloodPurification.Show(session["LOGON.USERID"],session["LOGON.GROUPID"],session['LOGON.CTLOCID'],ServerNameSpace);
	 }	
}

/// 重症监护组, 重症统计
function StartICUAutoTotal(lnk,newwin){
	var filePath = window.location.href.split("csp")[0] + "/service/dhcclinic/";
	var icuAutoTotalLink = "../service/dhcclinic/app/icu/Main.application?icuaId=" + "&admId=" + "&userId=" + session["LOGON.USERID"] + "&groupId=" + session["LOGON.GROUPID"] + "&locId=" + session['LOGON.CTLOCID'] + "&connString=" + ServerNameSpace + "&filePath=" + filePath + "&total=AutoTotalTemplateView";
	//window.location.href=lnk;
	//window.open(icuMonitoringLink);
	//PassDetails(lnk,newwin);
	var flag = isAccessMP("ICU-01","ICU-03");
	//alert(flag)
	if (flag==1){
    	window.open(icuAutoTotalLink);
	}else{
    	var url = flag.split("^")[1];  //打开受限提示界面
    	websys_lu(url,false,"top=20,left=20,width="+(screen.availWidth-200)+",height="+(screen.availHeight-200));
	}
}
 // C:\\Program Files (x86)\\Microsoft\\OutPatMrEditSetUp\\testOutMr.exe
 // 配置菜单时用 E:/dthealth/app/dthis/web/trakWeb3.exe
function openExpByParam(lnk,newwin,urlParam){
	lnk = lnk.replace(/\//g,"\\"); 
	if (lnk.indexOf(".exe")>-1){
		exec(lnk+" "+urlParam);
	}else{
		//PassDetails(lnk+"?"+urlParam,newwin);
		lnk = lnk+"?"+urlParam;
		if (newwin == "TRAK_hidden"){
			top.frames["TRAK_hidden"].location = lnk;
		}else if (newwin != ""){
			websys_lu(lnk,0,newwin);
		}else{
			//var srcEl = websys_getSrcElement()
			websys_createWindow(lnk,"TRAK_main");	//top.frames["TRAK_main"].location = lnk;
		}
	}
	return ;
}
function linkSysExp(lnk,newwin,valueExp){
	var urlParam = tkMakeServerCall("BSP.SYS.BL.Param","Format",valueExp);
	openExpByParam(lnk,newwin,urlParam);
	return ;	
}
/// "&userid=${}&admno=${}&times=${AdmTimes}
/// 和就诊相关
function linkAdmExp(lnk,newwin,valueExp) {
	var frm = document.forms["fEPRMENU"];
	var EID=frm.EpisodeID.value;
	if(isNaN(EID)){
		if ($.messager){
			$.messager.alert('信息提示',t['NoEpisode'],"info");
		}else{
			alert(t['NoEpisode']);
		}
		return;
	}
	if (EID == "") {
		if ($.messager){
			$.messager.alert('信息提示',t['NoEpisode'],"info");
		}else{
			alert(t['NoEpisode']);
		}
		return;
	}
	var urlParam = tkMakeServerCall("BSP.SYS.BL.Param","Format",valueExp,"",EID);
	openExpByParam(lnk,newwin,urlParam);
	return ;	
} 