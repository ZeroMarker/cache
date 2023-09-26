//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objTodayCache="";
var todaycdate=0;
var objTodayCache=document.getElementById("TodayCacheDate");
if (objTodayCache) todaycdate=objTodayCache.value;
var repeatSelectRow=0; var customWindowState=0;

var frm=document.forms["fOEOrdItem_RadiologyWorkBench"];
var tbl=document.getElementById["tOEOrdItem_RadiologyWorkBench"];
var obj=document.getElementById("SelectAll");
if (obj) obj.onclick = SelectAll;


function ResultsLinkHandler(row) { //AmiN Log26100 Dicom Handler
	//JAVA DICOM ResType contains delimited list of "J",PatientID,mradm,catgsID,dfrom,dto,EpisodesAll
		var typeObj=(frm.elements["ResTypez"+row]);
		if (typeObj){
			var typeAry=typeObj.value.split("^");
			var OrderID=typeAry[1];			//=#||#
			var PatientID=typeAry[2];		//=#
			var mradm=typeAry[3];			//=#
			var catgsID=typeAry[4];			//=,#,
			var dfrom=typeAry[5];			//=""
			var dto=typeAry[6];				//=""
			var EpisodesAll=typeAry[7];		//=0
			var url='webtrak.annotate.csp?OrderID='+OrderID+'&PatientID='+PatientID+'&mradm='+mradm+'&catgsID='+catgsID+'&dfrom='+dfrom+'&dto='+dto+'&EpisodesAll='+EpisodesAll
			var size="top=0,left=0,width=" + screen.availWidth + ",height=" + screen.availHeight;
			var features=",toolbar=no,location=no,directories=no,status=yes,menubar=no,scrollbars=yes,resizable=yes";
			websys_createWindow(url,'dicom',size+features);
		}
}

function setRowClass1(rowObj) {
	var cName="";
	if (rowObj.rowIndex>0) {if (rowObj.rowIndex%2==0) {cName="RowEven";} else {cName="RowOdd";}}
	return cName;
}

function SelectRowHandler(evt) {
	var eSrc=websys_getSrcElement(evt);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	var eSrcAry=eSrc.id.split("z");
	//var	row=arry[arry.length-1];
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;

	if (frm.elements['selectz'+row]) {
		//ANA LOG 29174 Put this line back in as Workbench does not want highlighting. However it should still retain the color of the row( dark blue/lite blue)
		rowObj.className=setRowClass1(rowObj);
		//Log 29174 PeterC 04/10/2002 following lines commented due to the loss of "highlight"
		selectedRowObj=new Object(); selectedRowObj=rowObj;
	}
	//alert("eSrcAry.length"+eSrcAry.length);
	if (eSrcAry.length>1) {
		if (eSrcAry[0]=="Dicom") { ResultsLinkHandler(row); return false; }

		if (eSrcAry[0]=="Arrived") {
			var arrAppt=frm.elements['OEORIAPPTDRz'+row].value.split("^");
			var arrArriveOrd=frm.elements['OEORIArriveStatusz'+row].value.split("^");
			//alert("OEORIAPPTDR-0**-1**OEORIArriveStatus ="+"\n"+arrAppt[0]+"^"+arrAppt[1]+"^"+arrArriveOrd[1]);
			if ((arrAppt[0]!="")&&(arrAppt[1]=="P")) {
				//arrive orders with booked appointments
				//Can not mark future appointments as arrived.
				if (arrAppt[2]>todaycdate) {
					alert(t['NoFutureArrival']);
					return false;
				}
			} else if ((arrAppt[0]=="")&&(arrArriveOrd[1]=="")) {
				//arrive orders without appointments
				//Can not mark future orders as arrived.
				if (arrArriveOrd[0]>todaycdate) {
					alert(t['NoFutureArrival']);
					return false;
				}
			} else {
				return true;
			}
  		}
	}
	repeatSelectRow++;
	//alert("Row Count " + repeatSelectRow);
	if (repeatSelectRow%2==1){
		//alert("Repeat");
		SelectRow1(evt);
		repeatSelectRow++;
	}
}

function SelectRow1(evt) {
	//this js may be associated to the parent window and so need to check which child window the event is coming from.
	var ary=window.frames;
	for (var i=0;i<ary.length;i++) {if (ary[i].event) {evt=ary[i].event;}}
	if (!evt) evt=window.event;

	var lastSelectedRow=selectedRowObj;
	var rowObj=getRow(evt.srcElement);
	if (rowObj.tagName != "TH") {
		var winf=EPR_getTopWindow();
		var tblObj=getTable(evt.srcElement);
		//var tblObj=getTable(rowObj);
		//TN:26-Nov-2002:when there are 2 of the same components(table id) on the same window/frame, deselect if they are the same row on the same table
		if ((lastSelectedRow.rowIndex==rowObj.rowIndex)&&(tblObj.id==getTable(lastSelectedRow).id)) {
			rowObj.className=lastSelectedRow.PrevClassName;
			selectedRowObj=new Object(); selectedRowObj.rowIndex="";
			//EPR_ClearSelectedEpisode();
			//TN:24-Apr-2002: when deselecting the last highlighted row, don't clear out all ids for lists that allow multiple checkbox selection
			try {ClearOnMultipleSelection(rowObj,winf);} catch (e) {}
			//KM 23-Mar-2002: If there is an event handler in a table it needs to happen irrespective of whether the row is selected or not.
			if (winf) EPR_SelectEpisodeDetails(f,rowObj.rowIndex,winf);
			//try {returnValue=SelectRowHandler();} catch(e) {}
			try {returnValue=SelectRowHandler2();} catch(e) {}
			try {if (returnValue==false) return false} catch(e) {}
		} else {
			if (rowObj.className!='clsRowDisabled') {
				rowObj.PrevClassName=rowObj.className;
				rowObj.className='clsRowSelected';
				lastSelectedRow.className=lastSelectedRow.PrevClassName;
				//lastSelectedRow.className=setRowClass(lastSelectedRow);
				selectedRowObj=rowObj;
				var f=getFrmFromTbl(tblObj);
				// for nested lists, get the elements directly instead of using the form
				if (!f) getElementsFromRow(rowObj,winf);

				if (winf) EPR_SelectEpisodeDetails(f,rowObj.rowIndex,winf);
				try {returnValue=SelectRowHandler();} catch(e) {}
				try {returnValue=SelectRowHandler2();} catch(e) {}
				try {if (returnValue==false) return false} catch(e) {}
			}
		}
	}
}

function RadiologyWB_AuthoriseHandler(lnk,newwin) {
	//alert("RadiologyWB_AuthoriseHandler");
	//alert("RadiologyWB_AuthoriseHandler");
	var arrIDs=new Array();
	if (document.getElementById("selectz1")) {
		arrIDs=OEOrdItemIDsGetSelected();
	} else {
		if (selectedRowObj.rowIndex!="") {
			//var row=selectedRowObj.rowIndex;
			var row=rowind;
			//alert("row "+row);
			arrIDs[0]=document.getElementById("OEOrdItemIDz"+row).value;
			arrIDs["PatientID"]=document.getElementById("PatientIDz"+row).value;
			arrIDs["EpisodeID"]=document.getElementById("EpisodeIDz"+row).value;
			arrIDs["mradm"]=document.getElementById("mradmz"+row).value;
			arrIDs["OEORIItemStatus"]=document.getElementById("OEORIItemStatusz"+row).innerText;
			arrIDs["WLWaitListStatusDR"]=document.getElementById("WLWaitListStatusDRz"+row).value;
			arrIDs["ARCIMDesc"]=document.getElementById("ARCIMDescHiddenz"+row).value;
			arrIDs["WaitingListID"]=document.getElementById("WaitingListIDz"+row).value;
			arrIDs["EQDesc"]=document.getElementById("EQPDescz"+row).value;
		}
	}
	//if (arrIDs.length==0)
	//alert("arrIDs.length " + arrIDs.length);
	if (arrIDs.length>0) {
		if (arrIDs["EpisodeID"]=="") {
			alert(t['DiffEpisode']);
			return;
		}
		lnk+="&OEOrdItemID="+arrIDs.join("^");   //from Component manager fields
		lnk+="&PatientID="+arrIDs["PatientID"];
		lnk+="&EpisodeID="+arrIDs["EpisodeID"];
		lnk+="&mradm="+arrIDs["mradm"];
		lnk+="&OEORIItemStatus="+arrIDs["OEORIItemStatus"];
		lnk+="&WLWaitListStatusDR="+arrIDs["WLWaitListStatusDR"];
		lnk+="&ARCIMDesc="+arrIDs["ARCIMDesc"];
		lnk+="&WaitingListID="+arrIDs["WaitingListID"];
		//Log 30646 PeterC 05/12/02
		lnk+="&PatientBanner=1";

		//alert("lnk="+lnk);

		//if (arrIDs.length==1) lnk+="&PatientBanner=1";
		if (newwin=="TRAK_hidden") {
			websys_createWindow(lnk,"TRAK_hidden");
		} else if (newwin!="") {
			websys_lu(lnk,false,newwin);
		} else {
			window.location=lnk;
		}
	}
}

function PassOrderDetails(lnk,newwin) {
	var ItemSelected=OEOrdItemRadWB_ChangeStatusHandler();
	if (ItemSelected) {
	  var eSrc=websys_getSrcElement();
	  var tbl=getTableName(eSrc);
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var aryfound=checkedCheckBoxes(f,tbl,"selectz");
		var AryItems=new Array();
		var OEString="";
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var OEItemID=f.elements["OEOrdItemIDz"+count].value;
			if (f.elements["ARCIMDescz"+count]) {var OEItemName=f.elements["ARCIMDescz"+count].innerHTML} else {var OEItemName=""};
			var OEItemStatus=f.elements["ItemStatusCodez"+count].value;
			//var OEItemStatus="";
			//var OEPaid=f.elements["Paidz"+count].value;
			if (OEString=="") {
				//56449 RC Modified to be the same as JDs 55279
				OEString=OEItemID+"*"+OEItemName+"*"+OEItemStatus+"*" //+OEPaid
				//OEString=OEItemID+String.fromCharCode(2)+OEItemName+String.fromCharCode(2)+OEItemStatus+String.fromCharCode(2) //+OEPaid
			} else {
				OEString=OEString+"^"+OEItemID+"*"+OEItemName+"*"+OEItemStatus+"*" //+OEPaid
				//OEString=OEString+String.fromCharCode(1)+OEItemID+String.fromCharCode(2)+OEItemName+String.fromCharCode(2)+OEItemStatus+String.fromCharCode(2) //+OEPaid
			}
		}
		lnk+= "&OrderString=" + escape(OEString);
		//alert(lnk);
		websys_lu(lnk,0,newwin);
	}
}
function OEOrdItemRadWB_ChangeStatusHandler(e) {
	var tbl=getTableName(window.event.srcElement);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"selectz");
	if (aryfound.length==0) {
		alert(t['NoItemSelected']);
		return false;
	}
	if (aryfound.length>0) {
	  //	websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=OEOrder.ChangeStatus&formID='+f.id,'Prompt','');
		return true;
	}
}

function OEOrdItemIDsGetSelected() {
	var arrOEOrdItemIDs=new Array();
	//var arrOEOrdItemStatus=new Array();
	arrOEOrdItemIDs["PatientID"]="";
	arrOEOrdItemIDs["EpisodeID"]="";
	arrOEOrdItemIDs["mradm"]="";
	arrOEOrdItemIDs["OEOrdSubCategID"]="";
	arrOEOrdItemIDs["OEOrdCategID"]="";
	arrOEOrdItemIDs["UNAUTH"]="";
	arrOEOrdItemIDs["OEORIItemStatus"]="";
	//rqg,log25929
	arrOEOrdItemIDs["WLWaitListStatusDR"]="";
	arrOEOrdItemIDs["ARCIMDesc"]="";
	arrOEOrdItemIDs["WaitingListID"]="";
	arrOEOrdItemIDs["ItemApptStatus"]="";
	arrOEOrdItemIDs["Decease"]="";
	// Log 51886 - AI - 11-05-2005 : The list of Radiology Work Bench Result Status for the selected items.
	arrOEOrdItemIDs["RWBResStat"]="";
	// Log 62069 - AI - 08-01-2007 : The list of Non-Standard Result "flags" for the selected items.
	arrOEOrdItemIDs["RWBNSR"]="";
	// Log 62069 - AI - 11-01-2007 : The list of Text "codes" for the selected items.
	//                               "1" - Non-Standard report exists only (NSR = Current Text)
	//                               "2" - Current Text exists only (Current Text)
	//                               "3" - Non-Standard report exists and one Text (Current Text and NSR = Previous Text)
	//                               "4" - Multiple Text exists (Current Text and Previous Text)
	arrOEOrdItemIDs["TextCodes"]="";
	//log 61123 TedT
	arrOEOrdItemIDs["SameResult"]="";
	;
	var ItemApptStatus="";
	var Status="";
	var Decease="";
	// Log 51886 - AI - 11-05-2005 : The list of Radiology Work Bench Result Status for the selected items.
	var RWBResStat="";
	// Log 62069 - AI - 08-01-2007 : The list of Non-Standard Result "flags" for the selected items.
	var RWBNSR="";
	// Log 62069 - AI - 11-01-2007 : The list of Text "codes" for the selected items.
	var TextCodes="";
	//log 61123  TedT
	var results="";
	var sameResult=1;

	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(frm,tbl,"selectz");
	//alert("aryfound = " + aryfound);
	if (aryfound.length>0) {
		arrOEOrdItemIDs["OEORIItemStatus"]="";
		for (i in aryfound) {
			//alert(i)
			//alert("in for "+i+"  "+aryfound);
			var row=aryfound[i];
			//alert("row "+row+"  "+tbl.rows[row].cells[7].innerText)
			arrOEOrdItemIDs[i]=frm.elements["OEOrdItemIDz"+row].value;
			Status=Status+frm.elements["ItemStatusCodez"+row].value+"^";
			ItemApptStatus=ItemApptStatus+frm.elements["ItemApptStatusz"+row].value;
			Decease=Decease+frm.elements["Deceasez"+row].value;
			if (i==0) {
				arrOEOrdItemIDs["PatientID"]=frm.elements["PatientIDz"+row].value;
				arrOEOrdItemIDs["EpisodeID"]=frm.elements["EpisodeIDz"+row].value;
				arrOEOrdItemIDs["mradm"]=frm.elements["mradmz"+row].value;
				arrOEOrdItemIDs["OEOrdSubCategID"]=frm.elements["OEOrdSubCatz"+row].value;
				arrOEOrdItemIDs["WLWaitListStatusDR"]=frm.elements["WLWaitListStatusDRz"+row].value;
				arrOEOrdItemIDs["ARCIMDesc"]=frm.elements["ARCIMDescHiddenz"+row].value;
				arrOEOrdItemIDs["WaitingListID"]=frm.elements["WaitingListIDz"+row].value;
				//alert("WaitingListIDz"+row);
				//alert(frm.elements["WaitingListIDz"+row].value);
			} else {
				if (arrOEOrdItemIDs["PatientID"]!=frm.elements["PatientIDz"+row].value) arrOEOrdItemIDs["PatientID"]="";
				if (arrOEOrdItemIDs["EpisodeID"]!=frm.elements["EpisodeIDz"+row].value) arrOEOrdItemIDs["EpisodeID"]="";
				if (arrOEOrdItemIDs["mradm"]!=frm.elements["mradmz"+row].value) arrOEOrdItemIDs["mradm"]="";
				if (arrOEOrdItemIDs["OEOrdSubCategID"]!=frm.elements["OEOrdSubCatz"+row].value) arrOEOrdItemIDs["OEOrdSubCategID"]="DIFFERENT";
				if (arrOEOrdItemIDs["WLWaitListStatusDR"]!=frm.elements["WLWaitListStatusDRz"+row].value) arrOEOrdItemIDs["WLWaitListStatusDR"]="";
				if (arrOEOrdItemIDs["ARCIMDesc"]!=frm.elements["ARCIMDescHiddenz"+row].value) arrOEOrdItemIDs["ARCIMDesc"]="";
				if (arrOEOrdItemIDs["WaitingListID"]!=frm.elements["WaitingListIDz"+row].value) arrOEOrdItemIDs["WaitingListID"]="";
			}
			if (frm.elements["OEORIAuthorisedDatez"+row].value=="") arrOEOrdItemIDs["UNAUTH"]=frm.elements["OEOrdItemIDz"+row].value;
			// Log 51886 - AI - 11-05-2005 : The list of Radiology Work Bench Result Status for the selected items.
			// Log 62069 - AI - 11-01-2007 : There can be BOTH, so only check Word if Text is blank.
			if (frm.elements["TextResultIDz"+row].value != "") RWBResStat=RWBResStat+"T";
			if ((frm.elements["TextResultIDz"+row].value == "")&&(frm.elements["CurrentResultIDz"+row].value != "")) RWBResStat=RWBResStat+"W";
			// end Log 51886
			// Log 62069 - AI - 08-01-2007 : The list of Non-Standard Result "flags" for the selected items.
			if (frm.elements["CurrResHiddenz"+row].outerHTML.indexOf("Non-Standard Report") != -1) RWBNSR=RWBNSR+"Y";
			if (frm.elements["CurrResHiddenz"+row].outerHTML.indexOf("Non-Standard Report") == -1) RWBNSR=RWBNSR+"N";
			// Log 62069 - AI - 11-01-2007 : The list of Text "codes" for the selected items.
			TextCodes=TextCodes+frm.elements["TextCodez"+row].value;
			// end Log 62069
			//log61123,60189 TedT check if has same linkitem
			if(sameResult==1) {
				if(results=="") results=frm.elements["CurrResHiddenz"+row].value+"^"+frm.elements["voiceFilez"+row].value;
				if(results!=frm.elements["CurrResHiddenz"+row].value+"^"+frm.elements["voiceFilez"+row].value)
					sameResult=0;
			}
		}
		arrOEOrdItemIDs["OEORIItemStatus"]=Status;
		arrOEOrdItemIDs["ItemApptStatus"]=ItemApptStatus;
		arrOEOrdItemIDs["Decease"]=Decease;
		// Log 51886 - AI - 11-05-2005 : The list of Radiology Work Bench Result Status for the selected items.
		arrOEOrdItemIDs["RWBResStat"]=RWBResStat;
		// Log 62069 - AI - 08-01-2007 : The list of Non-Standard Result "flags" for the selected items.
		arrOEOrdItemIDs["RWBNSR"]=RWBNSR;
		// Log 62069 - AI - 11-01-2007 : The list of Text "codes" for the selected items.
		arrOEOrdItemIDs["TextCodes"]=TextCodes;
		//log 61123 TedT check if selected orders has same result
		arrOEOrdItemIDs["SameResult"]=sameResult;
	}
	return arrOEOrdItemIDs;
}
function CTLOCDescLookUpSelect(str) {
	var lu=str.split("^");
	//clear out previous resource
	var obj=document.getElementById("RESCDesc");
	if (obj) obj.value="";
}
function ATTENDLookup(str) {
	var lu=str.split("^");
	var obj=document.getElementById("ATTENDDesc");
	if (obj) obj.value=lu[0];
}
function RESCDescLookUpSelect(str) {
	var lu=str.split("^");
	var obj=document.getElementById("RESCDesc");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("CTLOCDesc");
	if (obj) obj.value=lu[1];
}
function LookUpEpisodeTypeHandler(str) {
	var lu=str.split("^");
	var obj=document.getElementById("EpisodeType");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("EpisodeCode");
	if (obj) obj.value=lu[1];
}
function FindResourceCheck() {
	var msg="";
	var obj=document.getElementById("RESCDesc");
	if ((obj)&&(obj.value!="")) {
		var obj=document.getElementById("CTLOCDesc");
		if ((obj)&&(obj.value!="")) {
		} else { msg=t['ResourceReq'] + "\n"; }
		var obj=document.getElementById("DateFrom");
		if ((obj)&&(obj.value!="")) {
		} else { msg=t['ResourceReq'] + "\n"; }
	}
	return msg;
}
function FindDefaultCheck() {
	var msg="";
	var obj=document.getElementById("RegistrationNo");
	if ((obj)&&(obj.value!="")) {return "";}
	var obj=document.getElementById("TestEpisodeNo");
	if ((obj)&&(obj.value!="")) {return "";}
	var obj=document.getElementById("RESCDesc");
	if ((obj)&&(obj.value!="")) {return "";}

	//forced mandatory if not searching by patient, labepisodeno, or resource.
	var obj=document.getElementById("DateFrom");
	var exe=document.getElementById("executeFrom"); //log 64239
	if (((obj)&&(obj.value!="")) || (exe && exe.value!="")) {} else { msg=t['DateFrom'] +" "+ t['XMISSING'] + "\n"; }

	//commented this out for LOG 31825 so the user can search with a blank recieving location
	/*var objLoc=document.getElementById("CTLOCDesc");
	var objConsDoc=document.getElementById("ConsCTPCPDesc");
	if ((objLoc)&&(objConsDoc)) {
		if ((objLoc.value=="")&&(objConsDoc.value=="")) msg+=t['CTLOCDesc'] +" "+ t['XMISSING'] + "\n";
	} else if ((objLoc)&&(objLoc.value=="")) {
		msg+=t['CTLOCDesc'] +" "+ t['XMISSING'] + "\n";
	} else if ((objConsDoc)&&(objConsDoc.value=="")) {
		msg+=t['ConsCTPCPDesc'] +" "+ t['XMISSING'] + "\n";
	} else {
		msg+=t['CTLOCDesc'] +" "+ t['XMISSING'] + "\n";
	}*/
	return msg;
}
function FindClickHandler(e) {
	var lst=document.getElementById("multiTstEpNo")
	if (lst) {
		var liststring="";
		for (i=0; i<lst.options.length; i++) {
			liststring=liststring+lst.options[i].value+"^";
		}
		document.getElementById("TestEpisodeNo").value=liststring;
	}

	var msg="";
	msg+=FindResourceCheck();
	msg+=FindDefaultCheck();
	if (msg!="") {
		alert(msg);
		return false;
	}
	MultipleStatusListBuilder();
	return find1_click();
}

websys_firstfocus();
function RadWB_BodyLoadHandler() {  //Going to SelectRowHandler first because inherited websys.List.js  took out from component manager.
	EPR_ClearSelectedEpisode();  // Need in websys.List.js will reset last selected patient: mainly for use when first loading up the list ie. event onload
	DisableVIP();
	if (tbl) {
		for (var row=0;row<=tbl.rows.length;row++){
			var btnObj=document.getElementById("Dicomz"+row);
			var typeObj=document.getElementById("ResTypez"+row);
			var aptobj=document.getElementById("APPTTimez"+row)
			var apsobj=document.getElementById("ItemApptStatusz"+row)
			//var curRegNo=document.getElementById("EpisodeIDz"+row);
			//var preRegNo=document.getElementById("PAPMINoz"+(row-1));
			//if (curRegNo.value==preRegNo.value) curRegNo.value="";
			//log 61266 BoC: set row color for different item status
			var colorObj=document.getElementById("Colorz"+row);
			//var ItemStatusObj=document.getElementById("OEORIItemStatusz"+row);
			/*try {
				for (var curr_cell =1; curr_cell<tbl.rows[row].cells.length; curr_cell++) {
					if (colorObj) {
						tbl.rows[row].cells[curr_cell].style.color=colorObj.value;
					}
				}
			}
			catch (e){}*/
			try {
				if ((colorObj)&&(colorObj.value!='')) {
					tbl.rows[row].style.color=colorObj.value;
					}
				}
			catch (e){}
			if ((typeObj)&&(typeObj.value=="")&&(btnObj)) btnObj.style.visibility="hidden";
			//PAPMINo,PAPMIName,PAPMIName2,PAPMISex,PAPMIDOB,PAADMAdmNo,PAADMLocation,EstDOB,OtherBookedAppts,TempLoc
			// LOG 35114 RC 24/04/03 Need to check to see if the appointment value was set to 'Not Attended' as well as
			// 'Cancelled' in regards to striking through the appointment time.
			if (((aptobj)&&(aptobj.innerText!=""))&&((apsobj)&&((apsobj.value=="X")||(apsobj.value=="N")))){
				aptobj.style.textDecoration="line-through";
			}

			var curRes=document.getElementById("CurrResz"+row);
			/*if (row==1) lastRes=document.getElementById("CurrResz"+row);
			if (curRes) {
				if (curRes.innerHTML==lastRes) {
					lastRes=curRes.innerHTML;
					curRes.innerHTML="";
				}
			}*/
			if (curRes) curRes.onclick=OpenCurrentWordResult;
			var ResDeliv=document.getElementById("ResDelivz"+row);
			var stat=document.getElementById("ItemStatusCodez"+row);
			if ((ResDeliv)&&(stat)){
				if (stat.value!="RESV") ResDeliv.onclick=DeliveredClickHandler;
			}

			// Log 62175 - AI - 16-01-2007 : Set up the CurrentText click Handler.
			var curText=document.getElementById("CurrentTextz"+row);
			if (curText) curText.onclick=OpenCurrentTextResult;

		}
	}

	MultipleStatusSelectHandler();

	var obj=document.getElementById("find1");
	if (obj) obj.onclick=FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
	var obj=document.getElementById("TestEpisodeNo");
	if (obj) obj.onblur=TstEpNoBlurHandler;
	var obj=document.getElementById("Delete")
	if (obj) obj.onclick=RemoveListItems;
	TstEpNoStrHandler();

	//log 61268 TedT
	var datefrom=document.getElementById("DateFrom");
	if(datefrom) datefrom=datefrom.value;
	var dateto=document.getElementById("DateTo");
	if(dateto) dateto=dateto.value;

	obj=document.getElementById("nextday");
	if(obj){
		obj.onclick=DayClickHandler
		if(datefrom && dateto && datefrom!=dateto)
			obj.disabled=true;
	}
	obj=document.getElementById("prevday");
	if(obj){
		obj.onclick=DayClickHandler
		if(datefrom && dateto && datefrom!=dateto)
			obj.disabled=true;
	}
	
	//log 64239
	DateFromDateToBlurHandler();
	var dateobj=document.getElementById("DateFrom");
	if(dateobj) dateobj.onblur=DateFromDateToBlurHandler;
	dateobj=document.getElementById("DateTo");
	if(dateobj) dateobj.onblur=DateFromDateToBlurHandler;
	dateobj=document.getElementById("executeFrom");
	if(dateobj) dateobj.onblur=DateFromDateToBlurHandler;
	dateobj=document.getElementById("executeTo");
	if(dateobj) dateobj.onblur=DateFromDateToBlurHandler;
}

function OpenCurrentWordResult(e) {
	var eSrc=websys_getSrcElement(e);
	var eSrcAry=eSrc.id.split("z");
	var row=eSrcAry[eSrcAry.length-1];
	var re=/(\.rtf)/gi;

	//LOG 40023 RC 4/11/03 This 'GetObject' function will try to open an already existing instance of Word to use for
	//the template. If it can't find one, then it will just create a new instance of Word.
	//LOG 55488 JH 7/10/05 Now with new versions of word we can use the create object always without any performance issues -
	//and it fixes the problem that if the user has word open and minimised, the radiology report opens minimised too.
	//try {
	//	var objWrdApp = GetObject("","Word.Application");
	//} catch(e) {
		var objWrdApp = new ActiveXObject("Word.Application");
	//}

	var objSavedFileName=document.getElementById('CurrResz'+row);
	if (objSavedFileName) var strSavedFileName=objSavedFileName.innerHTML;
	if (strSavedFileName.search(re) != -1) {
		if (objWrdApp) {
			objWrdApp.visible=true;
			var strSaveFilePathArray="";
			var objSavedFileName=document.getElementById('CurrResz'+row);
			var objOEStat=document.getElementById('ItemStatusCodez'+row);
			if (objOEStat) strStatus=objOEStat.value;
			var objFilePath=document.getElementById('FilePath');
			if (objFilePath) strSaveFilePathArray=objFilePath.value;
			var strFilePath = mPiece(strSaveFilePathArray,";",0);
			if (strFilePath=="") { strFilePath=strSaveFilePathArray; }
			var objWrdDoc = objWrdApp.Documents.Add(strFilePath+strSavedFileName);
			if (objWrdDoc) {
				objWrdDoc.Variables("OEItemStatus").Value="";
			}
			try {
				objWrdApp.Run("OpenDocument");
				objWrdApp.visible=true;
				objWrdApp.WindowState = 2;
				objWrdApp.WindowState = customWindowState;
			} catch(e) {alert(e.description);} //objWrdApp.Application.Quit();
			return false;
		}
	} else {
		//Open Non-Standard Report component with Result ID.
		var IDObj=document.getElementById("CurrentResultIDz"+row);
		if(IDObj && IDObj.value!="") {
			var ID=IDObj.value;
			var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.NSRTxtResult&ID="+ID;
                        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
			websys_createWindow(path,"","toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
			return false;
		}
	}
}

// Log 62175 - AI - 16-01-2007 : The CurrentText Click Handler. Set up on BodyLoad.
function OpenCurrentTextResult(e) {
	var eSrc=websys_getSrcElement(e);
	var eSrcAry=eSrc.id.split("z");
	var row=eSrcAry[eSrcAry.length-1];

	if (eSrc.innerHTML=="Current Text") {
		//Open Text Result Edit component with all details.
		var valEpID="";
		var valPatID="";
		var valOIID="";
		var valTRIdx="";
		var valContext="";

		var objEpID=document.getElementById("EpisodeIDz"+row);
		if (objEpID) valEpID=objEpID.value;
		var objPatID=document.getElementById("PatientIDz"+row);
		if (objPatID) valPatID=objPatID.value;
		var objOIID=document.getElementById("OEOrdItemIDz"+row);
		if (objOIID) valOIID=objOIID.value;
		var objTRIdx=document.getElementById("CurrTextIdxz"+row);
		if (objTRIdx) valTRIdx=objTRIdx.value;
		var objContext=document.getElementById("CONTEXT");
		if (objContext) valContext=objContext.value;

		if ((objTRIdx)&&(valTRIdx!="")) {
			var path="oeorditem.tabularresultsemr.csp?Counter=&EpisodeID="+valEpID+"&ResultDetails="+valOIID+"||"+valTRIdx+"*T*&PatientBanner=1&PatientID="+valPatID+"&ChartID=&ResultID="+valOIID+"||"+valTRIdx+"&ItemID=&Type=&ResultType=T&CONTEXT="+valContext;
			websys_createWindow(path,"","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes")
			return false;
		}
	}
	if (eSrc.innerHTML=="Non-Standard Report") {
		//Open Non-Standard Report component with Result ID.
		var valCRID="";
		var objCRID=document.getElementById("CurrentResultIDz"+row);
		if (objCRID) valCRID=objCRID.value;

		if ((objCRID)&&(valCRID!="")) {
			var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdItem.NSRTxtResult&ID="+valCRID;
			websys_createWindow(path,"","toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes")
			return false;
		}
	}
}

function DeliveredClickHandler() {
	alert(t["NotVerified"]);
	return false;
}

/*var DelObj=document.getElementById("DeliveryIDz"+row);
var OEIObj=document.getElementById("OEOrdItemIDz"+row);
if(DelObj && OEIObj) {
	var DelID=DelObj.value;
	var OEOrdItemID=OEIObj.value;
	var path="websys.default.csp?WEBSYS.TCOMPONENT=OEOrdCollectionResult.Edit&ID="+DelID+"&OEOrdItemID="+OEOrdItemID+"&OrderID="+mPiece(OEOrdItemID,"||",0)+"&PARREF="+OEOrdItemID+"&PatientID=1";
        //Log 59598 - BC - 30-06-2006 : remove statusbar variable (status=) to display the status bar.
	websys_createWindow(path,"","top=20,left=20,height=400,width=400,toolbar=no,location=no,directories=no,menubar=no,scrollbars=yes,resizable=yes")
	return false;
}*/

function PrintSelectedRowsHandler(tblname,lnk,newwin) {
	var found=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"selectz");
	// HitCount is only required for reports when data is not being refresh automatically due to problems with
	// the Crystal Web Server. See Crystal KnowledgeBase Article c2002771.
	var HitCount=Math.round(Math.random() * 1000);
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PatientID,EpisodeID,OEOrdItemID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["PatientIDz"+row]) continue;
					if (!f.elements["EpisodeIDz"+row]) continue;
					if (!f.elements["OEOrdItemIDz"+row]) continue;
					if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")&&(f.elements["OEOrdItemIDz"+row].value!="")) {
						document.writeln('<INPUT NAME="PatientID" VALUE="' + f.elements["PatientIDz"+row].value + '">');
						document.writeln('<INPUT NAME="EpisodeID" VALUE="' + f.elements["EpisodeIDz"+row].value + '">');
						document.writeln('<INPUT NAME="OEOrdItemID" VALUE="' + f.elements["OEOrdItemIDz"+row].value + '">');
						//alert(f.elements["OEOrdItemIDz"+row].value);
					}
				}
				//Log 63924 - 08.06.2007 - to prevent stack overflow error
				//document.writeln('</FORM><SCR'+'IPT>');
				//document.writeln('window.HFORM.submit();');
				//document.writeln('</SCR'+'IPT></BODY></HTML>');
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
				if (!f.elements["PatientIDz"+row]) continue;
				if (!f.elements["EpisodeIDz"+row]) continue;
				if (!f.elements["OEOrdItemIDz"+row]) continue;
				if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")&&(f.elements["OEOrdItemIDz"+row].value!="")) {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["EpisodeIDz"+row].value,f.elements["PatientIDz"+row].value,f.elements["OEOrdItemIDz"+row].value);
				}
			}
		}

		/*
		//KK 20/Feb/2003 Log 30129 - commented these lines to implement a new logic to print selected rows.
		for (i in aryfound) {
			var row=aryfound[i];
			// check for specific values
			if (!f.elements["PatientIDz"+row]) continue;
			if (!f.elements["EpisodeIDz"+row]) continue;
			if (!f.elements["OEOrdItemIDz"+row]) continue;
			if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")&&(f.elements["OEOrdItemIDz"+row].value!="")) {
				// when the report is not preview i.e. will be inserted in the PrintHistory for the TPS
				if (newwin=="TRAK_hidden") {
					var newlnk=lnk;
					// concatenate specific row parameter values to lnk. this is necessary because the %request
					// variables are lost when the menu is selected. These parameter values will be resolved in
					// the Report Manager definition.
					newlnk=newlnk+"&PatientID="+f.elements["PatientIDz"+row].value;
					newlnk=newlnk+"&EpisodeID="+f.elements["EpisodeIDz"+row].value;
					newlnk=newlnk+"&OEOrdItemID="+f.elements["OEOrdItemIDz"+row].value;
					websys_createWindow(newlnk,"TRAK_hidden");
					// time delaying function to allow proper loading of the TRAK_hidden frame
					CompleteReportLoading();
				} else { 	// when the report is crystal and will be previewed pass these parameters so they can
						// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["PatientIDz"+row].value,f.elements["EpisodeIDz"+row].value,f.elements["OEOrdItemIDz"+row].value);
				}
			}
		}
		*/
	}
}

function MultipleStatusListBuilder() {
	var OSTATString="";
	var objOSTATList=document.getElementById("OSTATList")

	if (objOSTATList) {
		for (var i=0; i<objOSTATList.length; i++) {
			if (objOSTATList.options[i].selected) {
				OSTATString=OSTATString+objOSTATList.options[i].value+"|";
			}
		}
	}
	document.getElementById("hiddenOSTATDesc").value=OSTATString
}

function MultipleStatusSelectHandler() {
	var hiddenOSTATDesc=document.getElementById("hiddenOSTATDesc").value
	var objOSTATList=document.getElementById("OSTATList");
	var stat="";

	if (objOSTATList) {
		//log 61409 TedT bad for loop
		var hidstatarry=hiddenOSTATDesc.split("|");
		for (var j=0;j<hidstatarry.length;j++) {
			stat=hidstatarry[j];
			for (var i=0; i<objOSTATList.length; i++) {
				if (stat==objOSTATList.options[i].value) {
					objOSTATList.options[i].selected=true; break;
				}
			}
		}
	}
}

function PrintSingleReportHandler(tblname,lnk,newwin) {
	var found=0;
	if (tblname=="") {
		var eSrc=websys_getSrcElement();
		if(eSrc) var tbl=getTableName(eSrc);
	} else {
		var tbl=document.getElementById(tblname);
	}
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(f,tbl,"selectz");
	// HitCount is only required for reports when data is not being refresh automatically due to problems with
	// the Crystal Web Server. See Crystal KnowledgeBase Article c2002771.
	var HitCount=Math.round(Math.random() * 1000);
	if (aryfound.length==0) {
		alert(t['NOITEMSSELECTED']);
	} else {
		var PatientIDs=""; var EpisodeIDs=""; var OEOrdItemIDs="";
		if (newwin=="TRAK_hidden") {
			var hiddenwin=window.open('',newwin);
			with (hiddenwin) {
				document.writeln('<HTML><HEAD></HEAD><BODY>');
				document.writeln('<FORM name="HFORM" id="HFORM" method="POST" action="' + lnk + '">');
				document.writeln('<INPUT NAME="MULTI" VALUE="1">');
				document.writeln('<INPUT NAME="MULTIITEMS" VALUE="PatientID,EpisodeID,OEOrdItemID">');
				// for each row selected
				for (i in aryfound) {
					var row=aryfound[i];
					// check for specific values - these values must be hidden in the component
					if (!f.elements["PatientIDz"+row]) continue;
					if (!f.elements["EpisodeIDz"+row]) continue;
					if (!f.elements["OEOrdItemIDz"+row]) continue;
					if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")&&(f.elements["OEOrdItemIDz"+row].value!="")) {
						//Concatenate the IDs into one string
						PatientIDs=PatientIDs+f.elements["PatientIDz"+row].value+","
						EpisodeIDs=EpisodeIDs+f.elements["EpisodeIDz"+row].value+","
						OEOrdItemIDs=OEOrdItemIDs+f.elements["OEOrdItemIDz"+row].value+","
					}
				}
				//Pass the whole string into the report
				document.writeln('<INPUT NAME="PatientID" VALUE="' + PatientIDs + '">');
				document.writeln('<INPUT NAME="EpisodeID" VALUE="' + EpisodeIDs + '">');
				document.writeln('<INPUT NAME="OEOrdItemID" VALUE="' + OEOrdItemIDs + '">');
				document.writeln('</FORM><SCR'+'IPT>');
				document.writeln('window.HFORM.submit();');
				document.writeln('</SCR'+'IPT></BODY></HTML>');
				document.close();
			}
		} else {
			// for each row selected
			for (i in aryfound) {
				var row=aryfound[i];
				// check for specific values - these values must be hidden in the component
				if (!f.elements["PatientIDz"+row]) continue;
				if (!f.elements["EpisodeIDz"+row]) continue;
				if (!f.elements["OEOrdItemIDz"+row]) continue;
				if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")&&(f.elements["OEOrdItemIDz"+row].value!="")) {
					// when the report is crystal and will be previewed pass these parameters so they can
					// be converted to prompt(n) variables.
					//Concatenate the IDs into one string
					PatientIDs=PatientIDs+f.elements["PatientIDz"+row].value+","
					EpisodeIDs=EpisodeIDs+f.elements["EpisodeIDz"+row].value+","
					OEOrdItemIDs=OEOrdItemIDs+f.elements["OEOrdItemIDz"+row].value+","
				}
			}
			//Pass the whole string into the report
			PassReportParametersForPreview(lnk,newwin,EpisodeIDs,PatientIDs,OEOrdItemIDs);
		}

		/*
		//KK 20/Feb/2003 Log 30129 - commented these lines to implement a new logic to print selected rows.
		for (i in aryfound) {
			var row=aryfound[i];
			// check for specific values
			if (!f.elements["PatientIDz"+row]) continue;
			if (!f.elements["EpisodeIDz"+row]) continue;
			if (!f.elements["OEOrdItemIDz"+row]) continue;
			if ((f.elements["EpisodeIDz"+row].value!="")&&(f.elements["PatientIDz"+row].value!="")&&(f.elements["OEOrdItemIDz"+row].value!="")) {
				// when the report is not preview i.e. will be inserted in the PrintHistory for the TPS
				if (newwin=="TRAK_hidden") {
					var newlnk=lnk;
					// concatenate specific row parameter values to lnk. this is necessary because the %request
					// variables are lost when the menu is selected. These parameter values will be resolved in
					// the Report Manager definition.
					newlnk=newlnk+"&PatientID="+f.elements["PatientIDz"+row].value;
					newlnk=newlnk+"&EpisodeID="+f.elements["EpisodeIDz"+row].value;
					newlnk=newlnk+"&OEOrdItemID="+f.elements["OEOrdItemIDz"+row].value;
					websys_createWindow(newlnk,"TRAK_hidden");
					// time delaying function to allow proper loading of the TRAK_hidden frame
					CompleteReportLoading();
				} else { 	// when the report is crystal and will be previewed pass these parameters so they can
						// be converted to prompt(n) variables.
					PassReportParametersForPreview(lnk,newwin,f.elements["PatientIDz"+row].value,f.elements["EpisodeIDz"+row].value,f.elements["OEOrdItemIDz"+row].value);
				}
			}
		}
		*/
	}
}

function PassOrderAddDocDetails(lnk,newwin) {
	var ItemSelected=OEOrdItemRadWB_ChangeStatusHandler();
	if (ItemSelected) {
		var eSrc=websys_getSrcElement();
		var tbl=getTableName(eSrc);
		var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
		var aryfound=checkedCheckBoxes(f,tbl,"selectz");
		var AryItems=new Array();
		var OEString="";
		var selectionmradm="";
		var multiepisode=false;
		for (var i=0;i<aryfound.length;i++) {
			var count=aryfound[i];
			var OEItemID=f.elements["OEOrdItemIDz"+count].value;
			// Log 43116 - AI - 20-04-2004 : Use OrderNameHidden, instead of OrderName. Javascript can't access the
			//				 labels in the same way as the hidden fields, so OEItemName was always blank.
			if (f.elements["ARCIMDescHiddenz"+count]) {var OEItemName=f.elements["ARCIMDescHiddenz"+count].value} else {var OEItemName=""};
			var OEItemStatus=f.elements["ItemStatusCodez"+count].value;
			var OEPaid="";
			//f.elements["Paidz"+count].value;
			if (OEString=="") {
				OEString=OEItemID+String.fromCharCode(2)+OEItemName+String.fromCharCode(2)+OEItemStatus+String.fromCharCode(2)+OEPaid
			} else {
				OEString=OEString+String.fromCharCode(1)+OEItemID+String.fromCharCode(2)+OEItemName+String.fromCharCode(2)+OEItemStatus+String.fromCharCode(2)+OEPaid
			}
			var currentmradm=f.elements["mradmz"+count].value;
			if (selectionmradm=="") selectionmradm=currentmradm;
			if (currentmradm!=selectionmradm) multiepisode=true;
		}
		lnk+= "&OrderString=" + escape(OEString);

		// Log 43116 - AI - 20-04-2004 : Add PARREF, as this is now used by Menu System.OEOrdItem.ListEMR.Admin.AddDocuments.
		if (multiepisode==true) {
			alert(t['DiffEpisode'])
			return false;
		}
		lnk+= "&PARREF=" + currentmradm;
		// end Log 43116

		websys_lu(lnk,0,newwin);
	}
}

function TstEpNoBlurHandler() {
	var TstEpNoObj=document.getElementById("TestEpisodeNo")
	var TstEpNoLst=document.getElementById("multiTstEpNo")
	if ((TstEpNoObj)&&(TstEpNoLst)) {
		var TstEpNo=TstEpNoObj.value
		if (TstEpNo!="") {
			TstEpNoLst.options[TstEpNoLst.options.length] = new Option(TstEpNo,TstEpNo);
			TstEpNoObj.value="";
		}
	}
}

function TstEpNoKeydownHandler(e) {
	var key = websys_getKey(e);
	var obj = websys_getSrcElement(e);
	if ((obj)&&(obj.value!="")&&(key==8)) {
		TstEpNoBlurHandler();
		obj.focus();
	}
}
if ((document.getElementById("TestEpisodeNo"))&&(document.getElementById("multiTstEpNo"))) {
	document.getElementById("TestEpisodeNo").onkeydown=TstEpNoKeydownHandler;
	document.getElementById("TestEpisodeNo").onkeypress=TstEpNoKeydownHandler;
}

function TstEpNoStrHandler() {
	var TstEpNoObj=document.getElementById("TestEpisodeNo")
	var TstEpNoLst=document.getElementById("multiTstEpNo")
	if ((TstEpNoObj)&&(TstEpNoLst)) {
		for (var i=0;;i++) {
			var TstEpNo=mPiece(TstEpNoObj.value,"^",i)
			if (TstEpNo=="") break;
			if (TstEpNo!="") {
				TstEpNoLst.options[TstEpNoLst.options.length] = new Option(TstEpNo,TstEpNo);
			}
		}
		TstEpNoObj.value="";
	}
}

function RemoveListItems() {
	/*var lst=document.getElementById("multiRegNo")
	for (var i=(lst.length-1); i>=0; i--) {
		if (lst.options[i].selected) lst.options[i]=null;
	}*/
	var lst=document.getElementById("multiTstEpNo")
	for (var i=(lst.length-1); i>=0; i--) {
		if (lst.options[i].selected) lst.options[i]=null;
	}
}

function CheckBatchReport(lnk,newwin) {
	var tbl=getTableName(window.event.srcElement);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var arrIDs=checkedCheckBoxes(f,tbl,"selectz");

	if (arrIDs.length==0) {
		alert(t['NOITEMSSELECTED']);
		return false;
	} else {
		var OEItemIDString="";
		for (var i=0;i<arrIDs.length;i++) {
			var count=arrIDs[i];
			var OEItemID=f.elements["OEOrdItemIDz"+count].value;
			var OEItemStatus=f.elements["ItemStatusCodez"+count].value;
			if (OEItemStatus!="E") {
				alert(t["BatRepExe"]);
				return false;
			}
			OEItemIDString=OEItemIDString+OEItemID+"^";
		}
		lnk+="&OEItemIDString="+OEItemIDString
		top.frames["TRAK_main"].location = lnk;
	}
}

function CheckUnlinkOrders(lnk,newwin) {
	var tbl=getTableName(window.event.srcElement);
	var f=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var arrIDs=checkedCheckBoxes(f,tbl,"selectz");
	var param=lnk.split("&"); var sysUnlink="";
	for (var j=0;j<param.length;j++) {
		var vals=param[j].split("=");
		if (vals[0]=="sysUnlink") sysUnlink=vals[1]
	}

	if (arrIDs.length==0) {
		alert(t['NOITEMSSELECTED']);
		return false;
	} else {
		var OEItemIDString="";
		for (var i=0;i<arrIDs.length;i++) {
			var count=arrIDs[i];
			var OEItemID=f.elements["OEOrdItemIDz"+count].value;
			var OEItemStatus=f.elements["ItemStatusCodez"+count].value;
			if ((OEItemStatus=="RESV")&&(sysUnlink!=1)) {
				alert(t["UnlnkOrdResV"]);
				return false;
			}
			OEItemIDString=OEItemIDString+OEItemID+"^";
		}
		lnk+="&OEItemIDString="+OEItemIDString
		websys_lu(lnk,0,newwin);
	}
}

function SelectAll(e) {
	if ((frm)&&(tbl)) {
		var firstcbx=null;
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('selectz'+j);
			if ((obj) && (!obj.disabled)) {
				//for speed issues, just untick checkbox during loop, then at the end, trigger the rowselect
				//obj.click();
				obj.checked=true;
				if (!firstcbx) firstcbx=obj;
			}
		}
		if (firstcbx) {
			//reset to uncheck then trigger the onclick to run the select trigger.
			firstcbx.checked=false;firstcbx.click();
		}
	}
	return false;
}
function UnselectAllClick(e) {
	if ((frm)&&(tbl)) {
		var firstcbx=null;
		for (var j=1;j<tbl.rows.length;j++) {
			var obj=document.getElementById('selectz'+j);
			if ((obj)&&(!obj.disabled)&&(obj.checked)) {
				//for speed issues, just untick checkbox during loop, then at the end, trigger the rowselect
				obj.checked=false;
				if (!firstcbx) firstcbx=obj;
			}
		}
		if (firstcbx) {
			//reset to uncheck then trigger the onclick to run the select trigger.
			firstcbx.checked=true;firstcbx.click();
		}
	}
	return false;
}
var objUnsel=document.getElementById("UnselectAll");if (objUnsel) {objUnsel.onclick=UnselectAllClick;}


function OrderItemLookup(txt) {
	var adata=txt.split("^");
	var iobj=document.getElementById("OrdItemDesc");
	if (iobj) iobj.value=adata[0];
}

function mPiece(s1,sep,n) {
    //Split the array with the passed delimeter
    delimArray = s1.split(sep);
    //If out of range, return a blank string
    if ((n <= delimArray.length-1) && (n >= 0)) {
        return delimArray[n];
    }
}

// cjb 24/01/2006 55848
function DisableVIP() {
	for (var i=1;i<tbl.rows.length;i++) {
		if ((frm.elements['PatientIDz'+i].value=="")&&(frm.elements['EpisodeIDz'+i].value!="")) {
			tbl.rows[i].className="clsRowDisabled";
			var Select=frm.elements["selectz"+i];
			if (Select) Select.disabled=true;
			var obj=document.getElementById('ARCIMDescz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('Arrivedz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('OEORICoverMainInsurz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('OEORIPortableEquipz'+i);
			if (obj) var deletenode=obj.removeNode(false);

			var obj=document.getElementById('APPTTimez'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('Dicomz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('OtherBookedApptsz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('SupResultz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('CurrResz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('ScannedDocz'+i);
			if (obj) var deletenode=obj.removeNode(false);
			var obj=document.getElementById('ResDelivz'+i);
			if (obj) var deletenode=obj.removeNode(false);
		}
	}
	return;
}

//log 61268 TedT
function DayClickHandler() {
	var datefrom=document.getElementById("DateFrom");
	var dateto=document.getElementById("DateTo");
	var currdate="";
	var id=this.id;
	var day=1;

	if(datefrom && dateto && datefrom.value==dateto.value) currdate=datefrom.value;
	if(currdate=="") return false;
	if(id=="prevday") day=-1;
	var newday=AddToDateStrGetDateStr(currdate,"D",day);
	if(newday!="") {
		datefrom.value=newday;
		dateto.value=newday;
		var find=document.getElementById("find1");
		if(find) find.click();
	}
	return false;
}

//log 64239
function DateFromDateToBlurHandler() {
	var datefrom=document.getElementById("DateFrom");
	var dateto=document.getElementById("DateTo");
	var exefrom=document.getElementById("executeFrom");
	var exeto=document.getElementById("executeTo");
	
	if((datefrom && datefrom.value!="") || (dateto && dateto.value!="")) {
		if (exefrom) {
			exefrom.disabled=true;
			exefrom.value="";
		}
		if (exeto) {
			exeto.disabled=true;
			exeto.value="";
		}
	}
	else {
		if (exefrom) exefrom.disabled=false;
		if (exeto) exeto.disabled=false;
	}
	
	if((exefrom && exefrom.value!="") || (exeto && exeto.value!="")) {
		if (datefrom) {
			datefrom.disabled=true;
			datefrom.value="";
		}
		if (dateto) {
			dateto.disabled=true;
			dateto.value="";
		}
	}
	else {
		if (datefrom) datefrom.disabled=false;
		if (dateto) dateto.disabled=false;
	}
}

document.body.onload=RadWB_BodyLoadHandler;
