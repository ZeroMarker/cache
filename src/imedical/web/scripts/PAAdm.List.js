// Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

function openEpisodeDetails() {
		var eSrc = websys_getSrcElement(e);
		if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc)
		if ((eSrc.tagName=="A") && (eSrc.id.indexOf("PAADMADMNoz")==0)) {
			var currentlink=eSrc.href.split("?");
			var url = "paadm.edit.csp" + "?" + currentlink[1];
			websys_lu(url,false,"width=750,height=750,left=10,top=10");			
			return false;
		}
}

function DocumentLoadHandler() {
	// SB 18/07/03 (36896): needed for RBOperatingRoom.Edit
	var tbl=document.getElementById("tPAAdm_List");
	if (window.opener) {
		var objEp1=window.opener.document.getElementById("EpisodeID")
		if (objEp1 && objEp1.value!="") {
			for (var i=1;i<tbl.rows.length;i++) {
				var objEp2=document.getElementById("EpisodeIDz"+i)
				if ((objEp2) && (objEp1.value==objEp2.value)) {
					var elementid="EpisodeIDz"+i;
					HighlightRow_OnLoad(elementid);
				}
			}
	 	}
	}
	assignClickHandler();
}

function PAAdm_List_SelectRowHandler() {
	var eSrc=window.event.srcElement;
	if (eSrc.tagName=="IMG") eSrc=window.event.srcElement.parentElement;
	var eSrcAry=eSrc.id.split("z");
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	var AddToFavourites=0;
	//log 60540 Bo 14/08/2006: alert if a cancelled episode is selected.
	var visitStatusObj=document.getElementById("HidPAADMVisitStatusz"+row);
	if ((visitStatusObj)&&(visitStatusObj.value=="C")) {
		alert (t['CancelledEpisode']);
		if (eSrc.id.indexOf("UpdRTMasVolAdm")==0) return false;
		}
	// CJB 32430 needed for pamergepatient.editcopyadmission.csp
	var CopyAdmission=""
	if (top.frames["TRAK_main"]) {
		if (top.frames["TRAK_main"].frames['CopyAdmission']) {
			var CopyAdmission=top.frames["TRAK_main"].frames['CopyAdmission'];
		}
	}
	
	// ab 26.09.03 - 37039
	if ((window.opener)&&(window.opener.document.forms["fepr_FavEpisodeList"])) AddToFavourites=1;
	if ((AddToFavourites)&&(row)) {
		EpisodeID=document.getElementById("EpisodeIDz"+row);
		if (EpisodeID) {
			var CONTEXT=window.opener.session["CONTEXT"];
			var ListID=window.opener.document.getElementById("ListID");
			window.opener.location="epr.favepisodelist.csp?AddEpisode="+EpisodeID.value+"&CONTEXT="+CONTEXT+"&ListID="+ListID.value;
			window.close();
			return false;
		}
	}	
	
	if (eSrcAry.length>0) {
		//JW: opens in new window - should not go through workflow
		if (eSrcAry[0]=="PAADMADMNo") {
			var currentlink=eSrc.href.split("?");
			var temp1=currentlink[1].split("&TWKFL")
			var temp2=currentlink[1].split("&ID")
			var url = "paadm.edit.csp?"+temp1[0]+"&ID"+temp2[1];
			websys_lu(url,false,"width=750,height=750,left=10,top=10")
			return false;
		} else if (eSrcAry[0]=="UpdRTMasVolAdm"){
			// ANA Alert Patient if discharged Episode.
			var disDateObj=document.getElementById("PAADMDischgDateCachez"+row);
			if ((disDateObj)&&(disDateObj.value!="")) {
				var proceed=confirm(t['Discharged'])
				if (!proceed) return false;
			}
		//md 21/08/2003 dndbam
		//else if (eSrcAry[0]=="PAADMAdmDateLink"){
		///	// Ask the Question.
		//	var SNAPWardObj=document.getElementById("SNAPWardz"+row);
		//	if ((SNAPWardObj)&&(SNAPWardObj.value!="Y")) {
		//		var proceed=confirm(t['NotSNAPward'])
		//		if (!proceed) return false;
		//}
		//md 21/08/2003 dndbam
		// CJB 32430 needed for pamergepatient.editcopyadmission.csp
		} else if (eSrcAry[0]=="select"){
			//alert("select hit");
			if (CopyAdmission) {
				var EpisodeIDString=CopyAdmission.document.getElementById("EpisodeIDString");
				if (EpisodeIDString) {
					var epi=document.getElementById("EpisodeIDz"+row);
					if (frm.elements["selectz"+row].checked) {
						AddToString(EpisodeIDString,epi.value)
					} else {
						RemoveFromString(EpisodeIDString,epi.value)
					}
				}
			// SB 18/07/03 (36896): needed for RBOperatingRoom.Edit
			} else if (window.opener && window.opener.document.getElementById("EpisodeID") && window.opener.document.getElementById("TFORM").value=="RBOperatingRoom.Edit") {
				var doc=window.opener.document
				//return true;
				if (doc.getElementById("EpisodeID")) doc.getElementById("EpisodeID").value=document.getElementById("EpisodeIDz"+row).value
				if (doc.getElementById("EpisodeNo")) doc.getElementById("EpisodeNo").innerHTML=document.getElementById("DisplayPAADMADMNoz"+row).innerHTML
				if (doc.getElementById("AdmType")) doc.getElementById("AdmType").innerHTML=document.getElementById("PAADMTypez"+row).value
				window.location="websys.close.csp" //window.location="websys.reload.csp?EpisodeID="+document.getElementById("EpisodeIDz"+row).value //window.close();
				
			// cjb 04/11/2005 52701 - if opened from the coding screen and the episode has already been coded, ask the user to confirm.  If cancel, return false, ie untick
			} else if ((window.opener)&&(window.opener.name=="PAAdmDRGCoding")) {
				
				if ((document.getElementById("IsCodedHIDDENz"+row).value==1)&&(frm.elements["selectz"+row].checked)) {
					
					if (confirm(document.getElementById("PAADMADMNoHIDDENz"+row).value+t['AlreadyCoded'])) {
						//alert(row);
					} else {
						return false;
					}
					
				}
			}
		}
	}
}

function AddToString(EpisodeIDString,newvar) {
	
	var AlreadyGotIt=0
	var lu = EpisodeIDString.value.split("^");
	if ((EpisodeIDString)&&(EpisodeIDString.value!="")) {
		for (var i=1;i<lu.length;i++) {
			if (lu[i]==newvar) AlreadyGotIt=1;
		}
	}
	
	if (AlreadyGotIt==0) EpisodeIDString.value=EpisodeIDString.value+"^"+newvar
}

function RemoveFromString(EpisodeIDString,oldvar) {
	
	var lu = EpisodeIDString.value.split("^");
	if ((EpisodeIDString)&&(EpisodeIDString.value!="")) {
		for (var i=1;i<lu.length;i++) {
			if (lu[i]==oldvar) delete lu[i];
		}
	}
	
	EpisodeIDString.value=lu.join("^")
}


function getRow(eSrc) {
	while(eSrc.tagName != "TR") {
		if (eSrc.tagName == "TH") break;
		eSrc=eSrc.parentElement;
	}
	return eSrc;
}

function setRowClass(rowObj) {
	if (rowObj.rowIndex!=selectedRowObj.rowIndex) {
		rowObj.className='clsRowSelected';
		if (selectedRowObj.rowIndex%2==0 && selectedRowObj.rowIndex>0) {cName="RowEven";} else {cName="RowOdd";}
		selectedRowObj.className=cName;
		selectedRowObj=rowObj;
	}
}

function ChangeCode() {
	SelectedEpisodeIDBuilder();
	//ChangeStatus_click();
	var objEpisodesTo=document.getElementById("EpisodesTo");
	var objPatientID=document.getElementById("PatientID");
	var objTWKFL=document.getElementById("TWKFL").value;
	var PatientID="";
	if (objPatientID) PatientID=objPatientID.value;

	if (objEpisodesTo) {
		if (objEpisodesTo.value!="") {
			var EpisodeIDs=objEpisodesTo.value;
			var url="websys.default.csp?WEBSYS.TCOMPONENT=PAAdm.DRGCodingChangeStatus.Edit";
			url += "&dummy=1&EpisodeIDs="+EpisodeIDs+"&PatientID="+PatientID+"&TWKFL="+objTWKFL+"&PatientBanner=1";
			url += "&CONTEXT="+session['CONTEXT'];
			//alert(url);
			//return false;
			window.location.href=url;
			return false;
		} else {
			alert(t['NO_EPISODE_SELECTED']);
			return false;
		}
	}

	//top.frames["TRAK_main"].location.href=lnk;
}

function CopyCodeToEpis() {
	SelectedEpisodeIDBuilder();
	CopyCodetoEpis_click();
}

// GR log 24580 need to get ids for coding module.
function SelectedEpisodeIDBuilder() {
	if ((frm)&&(tbl)) {
		//var aryfound=checkedCheckBoxes(frm,tbl,"Selectz");
		var aryID=new Array(); var aryStat=new Array(); var n=0;
		for (var i=1;i<tbl.rows.length;i++) {
			if ((frm.elements["selectz"+i])&&(frm.elements["selectz"+i].checked)) {
				aryID[n]=frm.elements['EpisodeIDz'+i].value;
				n++;
		 	} else if (tbl.rows[i].className=="clsRowSelected") {
				aryID[n]=frm.elements['EpisodeIDz'+i].value;
				n++;
			}
		}
		//codeidsobj=document.getElementById('EpisodesTo');
		if (codeidsobj) codeidsobj.value=aryID.join("^");
	}
	return;
}


//jpd 7 APR 2005 Log 49890
function BulkMoveClick(){
	var RTMasVolID=document.getElementById('RTMasVolID').value;
	SelectedEpisodeIDBuilder();
	var path="paadm.movebulk.csp?RTMasVolID="+RTMasVolID+"&EpisodesTo="+codeidsobj.value+"&WINNAME="+window.name;
	websys_createWindow(path,"TRAK_hidden");
	BulkMove_click();
}


function assignClickHandler() {
	var tbl=document.getElementById("tPAAdm_List");
	for (var i=1;i<tbl.rows.length;i++) {
		var obj=document.getElementById("GroupNumberz"+i)
		var obj1=document.getElementById("EpisodeIDz"+i)
		if ((obj)&&(obj1)) {
		var val=obj.innerHTML;
		var arylink=new Array();
		if (val!="&nbsp;") { //if val does not contain data it contains &nbsp; 
			var ary=val.split("(");
			val=ary.join("");
			ary=val.split(")");
			val=ary.join("");
			ary=val.split(",");
			val=ary.join(" ");
			multimerge=obj1.value;
			
			
			for (var j=0;j<ary.length;j++) {
				arylink[j]="<A HREF='javascript:goToLinkItB("+'"'+ary[j]+'","'+multimerge+'"'+")'>"+ary[j]+"</A>";
				
			}
			obj.innerHTML=arylink.join(",");
		}
		}
	}
	return;
}

function goToLinkItB(val,val2) {
	var patid=document.getElementById("PatientID").value;
	//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.ListEMR&&EpisodeID='+val2+'&GroupNumber='+val+'&EpisodeIDs='+val2+'&PatientID='+patid+'&PatientBanner=1','merge','top=20,left=20,width=500,height=300');
	websys_lu('websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.ListEMR&&EpisodeID='+val2+'&GroupNumber='+val+'&EpisodeIDs='+val2+'&PatientID='+patid+'&PatientBanner=1',false);			
	
}

/*

function EpisodeIDGetSelected() {
	var arrEpisodeIDs=new Array();
	var eSrc=websys_getSrcElement();
	var tbl=getTable(eSrc);
	var frm=getFrmFromTbl(tbl);
	var selected=0;
	//alert("EpisodeIDGetSelected");
	for (var row=1; row<tbl.rows.length; row++) {
		var cbx=frm.elements["selectz"+row];
		//if (cbx) alert("row number="+row+" cbx.checked= "+cbx.checked+" cbx.disabled="+cbx.disabled);
		if ((cbx.checked) && (!cbx.disabled)) {
			arrEpisodeIDs[selected]=frm.elements["EpisodeIDz"+row].value;
			selected++;
						
			//alert(el.value)
		}
	}
	return arrEpisodeIDs;
}
*/
copycodeobj=document.getElementById('CopyCodetoEpis');
if (copycodeobj) copycodeobj.onclick=CopyCodeToEpis;

changecodeobj=document.getElementById('ChangeStatus');
if (changecodeobj) changecodeobj.onclick=ChangeCode;

var frm=document.forms["fPAAdm_List"];
var tbl=document.getElementById("tPAAdm_List");
if (tbl) tbl.tCompName=frm.id.substring(1,frm.id.length);


try {if (tbl) tbl.onclick=SelectRowAdm;} catch(e) {}
try {if (tbl) tbl.onKeyPress=SelectRowAdm;} catch(e) {}

//jpd 7 APR 2005 Log 49890
var BulkMove=document.getElementById('BulkMove');
if (BulkMove) BulkMove.onclick = BulkMoveClick; 
var codeidsobj=document.getElementById('EpisodesTo');

document.body.onload = DocumentLoadHandler;