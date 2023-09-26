//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

var objTodayCache="";
var todaycdate=0;	
var objTodayCache=document.getElementById("TodayCacheDate");
if (objTodayCache) todaycdate=objTodayCache.value;

var frm=document.forms["fOEOrdItem_RadiologyWorkBench"];
var tbl=document.getElementById["tOEOrdItem_RadiologyWorkBench"];
	
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
			var url='webtrakviewer.csp?OrderID='+OrderID+'&PatientID='+PatientID+'&mradm='+mradm+'&catgsID='+catgsID+'&dfrom='+dfrom+'&dto='+dto+'&EpisodesAll='+EpisodesAll
			var features='scrollbars=auto,toolbar=no,resizable=yes'

			websys_createWindow(url,'dicom',features)
		}
}

function SelectRowHandler(evt) {	
	var eSrc=websys_getSrcElement(evt);	
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);		
	var eSrcAry=eSrc.id.split("z");  //id="Dicomz1" = Dicom,1	
	
	var rowObj=getRow(eSrc);
	var row=rowObj.rowIndex;
	if (frm.elements['selectz'+row]) {
		rowObj.className=setRowClass(rowObj);
		selectedRowObj=new Object(); selectedRowObj.rowIndex="";
	} 
 if (eSrcAry.length>1) {
	if (eSrcAry[0]=="Dicom") { ResultsLinkHandler(row); return false; }	
	
	if (eSrcAry[0]=="Arrived") {		
			var arrAppt=frm.elements['OEORIAPPTDRz'+row].value.split("^");
			var arrArriveOrd=frm.elements['OEORIArriveStatusz'+row].value.split("^");
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
}

function RadiologyWB_AuthoriseHandler(lnk,newwin) {
	//alert("RadiologyWB_AuthoriseHandler");
	var arrIDs=new Array();
	if (document.getElementById("selectz1")) {
		arrIDs=OEOrdItemIDsGetSelected();
	} else {
		if (selectedRowObj.rowIndex!="") {
			var row=selectedRowObj.rowIndex;
			arrIDs[0]=document.getElementById("OEOrdItemIDz"+row).value;
			arrIDs["PatientID"]=document.getElementById("PatientIDz"+row).value;
			arrIDs["EpisodeID"]=document.getElementById("EpisodeIDz"+row).value;
			arrIDs["mradm"]=document.getElementById("mradmz"+row).value;
			arrIDs["OEORIItemStatus"]=document.getElementById("OEORIItemStatusz"+row).innerText;
			arrIDs["WLWaitListStatusDR"]=document.getElementById("WLWaitListStatusDRz"+row).value;
			arrIDs["ARCIMDesc"]=document.getElementById("ARCIMDescHiddenz"+row).value;
			arrIDs["WaitingListID"]=document.getElementById("WaitingListIDz"+row).value;			
		}
	}
	//if (arrIDs.length==0) 
	if (arrIDs.length>0) {		
		lnk+="&OEOrdItemID="+arrIDs.join("^");   //from Component manager fields
		lnk+="&PatientID="+arrIDs["PatientID"];
		lnk+="&EpisodeID="+arrIDs["EpisodeID"];
		lnk+="&mradm="+arrIDs["mradm"];
		lnk+="&OEORIItemStatus="+arrIDs["OEORIItemStatus"];
		lnk+="&WLWaitListStatusDR="+arrIDs["WLWaitListStatusDR"];
		lnk+="&ARCIMDesc="+arrIDs["ARCIMDesc"];
		lnk+="&WaitingListID="+arrIDs["WaitingListID"];
		if (arrIDs.length==1) lnk+="&PatientBanner=1";
		if (newwin=="TRAK_hidden") {
			websys_createWindow(lnk,"TRAK_hidden");
		} else if (newwin!="") {
			websys_lu(lnk,false,newwin);
		} else {
			window.location=lnk;
		}
		//alert("link="+link);
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
	var Status="";
	var eSrc=websys_getSrcElement();
	var tbl=getTableName(eSrc);
	var frm=document.getElementById("f"+tbl.id.substring(1,tbl.id.length));
	var aryfound=checkedCheckBoxes(frm,tbl,"selectz");
	if (aryfound.length>0) {
		arrOEOrdItemIDs["OEORIItemStatus"]="";
		for (i in aryfound) {
			//alert(i)
			//alert("in for "+i+"  "+aryfound);
			var row=aryfound[i];
			//alert("row "+row+"  "+tbl.rows[row].cells[7].innerText)
			arrOEOrdItemIDs[i]=frm.elements["OEOrdItemIDz"+row].value;
			Status=frm.elements["ItemStatusCodez"+row].value+" "+Status

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
		}
		arrOEOrdItemIDs["OEORIItemStatus"]=Status;
	} 
	return arrOEOrdItemIDs;
}
function CTLOCDescLookUpSelect(str) {
	var lu=str.split("^");
	//clear out previous resource
	var obj=document.getElementById("RESCDesc");
	if (obj) obj.value="";
}
function RESCDescLookUpSelect(str) {
	var lu=str.split("^");
	var obj=document.getElementById("RESCDesc");
	if (obj) obj.value=lu[0];
	var obj=document.getElementById("CTLOCDesc");
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
	if ((obj)&&(obj.value!="")) {} else { msg=t['DateFrom'] +" "+ t['XMISSING'] + "\n"; }

	var objLoc=document.getElementById("CTLOCDesc");
	var objConsDoc=document.getElementById("ConsCTPCPDesc");
	if ((objLoc)&&(objConsDoc)) {
		if ((objLoc.value=="")&&(objConsDoc.value=="")) msg+=t['CTLOCDesc'] +" "+ t['XMISSING'] + "\n";
	} else if ((objLoc)&&(objLoc.value=="")) {
		msg+=t['CTLOCDesc'] +" "+ t['XMISSING'] + "\n";
	} else if ((objConsDoc)&&(objConsDoc.value=="")) {
		msg+=t['ConsCTPCPDesc'] +" "+ t['XMISSING'] + "\n";
	} else {
		msg+=t['CTLOCDesc'] +" "+ t['XMISSING'] + "\n";
	}
	return msg;
}
function FindClickHandler(e) {
	var msg="";
	msg+=FindResourceCheck();
	msg+=FindDefaultCheck();
	if (msg!="") {
		alert(msg);
		return false;
	}
	return find1_click();
}

websys_firstfocus();
function BodyLoadHandler() {  //Going to SelectRowHandler first because inherited websys.List.js  took out from component manager. 
	EPR_ClearSelectedEpisode();  // Need in websys.List.js will reset last selected patient: mainly for use when first loading up the list ie. event onload
	if (tbl) {
		for (var row=0;row<=tbl.rows.length;row++){
			var btnObj=document.getElementById("Dicomz"+row);
			var typeObj=document.getElementById("ResTypez"+row);		
			if ((typeObj)&&(typeObj.value=="")&&(btnObj)) btnObj.style.visibility="hidden";
	
		}
	}
	var obj=document.getElementById("find1");
	if (obj) obj.onclick=FindClickHandler;
	if (tsc['find1']) websys_sckeys[tsc['find1']]=FindClickHandler;
}

document.body.onload=BodyLoadHandler;

