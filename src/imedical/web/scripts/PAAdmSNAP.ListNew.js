// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.getElementById("fPAAdmSNAP_ListNew");
var tbl=document.getElementById('tPAAdmSNAP_ListNew')


function PAAdmSNAPListNewLoadHandler(e) {
  //var numRows=tbl.rows.length;
  var NewLinkobj=document.getElementById("New1");
  var CheckIncomplete=document.getElementById("IncompleteSNAP");
  if ((CheckIncomplete)&&(CheckIncomplete.value!="0")&&(NewLinkobj)) 
	{
	NewLinkobj.disabled=true;
	NewLinkobj.onclick=LinkDisable;
	}
  //var Updatelinkobj=document.getElementById("update2");
  //if (Updatelinkobj) { Updatelinkobj.onclick=UpdatelinkClicked;}


}
function SelectRowHandler(evt) {
	//websys.List.js has already set the selected row into a variable called selectedRowObj
	var url="",objType,objID;
	var eSrc=websys_getSrcElement(evt);
	//alert(eSrc.tagName);
	var PatientID=document.getElementById('PatientID').value;
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	if (eSrc.href) {
		var temp1=eSrc.href.split("&TWKFL")
		var temp2=eSrc.href.split("&ID")
		var url = temp1[0] + "&ID" + temp2[1];
			}
	if (eSrc.tagName=="A") {
			if (eSrc.id.indexOf("delete1z")==0) {
				var proceed=confirm(t['DeleteSNAP'])
				if (proceed) {
				return true;
				}
			        if (!proceed) {return false;}
				}
				if (eSrc.id.indexOf("delete2z")==0) {
				return true;
				}
				else {
				 return true;
				      }	
				}
	else
	{
	if (eSrc.tagName=="TD") eSrc=eSrc.firstChild;
	var eSrcAry=eSrc.id.split("z");
	if ((eSrc.children.length>0)&&(eSrc.tagName!="A")) var eSrc=eSrc.firstChild;
	var eSrcAry=eSrc.id.split("z");
	if (eSrcAry.length<=1) return false;
	var SNAPEpisodeID=document.getElementById('SNAPRowIdz'+eSrcAry[1]).value;
	var ADLCareType=document.getElementById('ADLCTCodez'+eSrcAry[1]).value;
	var EpisodeID=document.getElementById('EpisodeID').value;
	var CareType=document.getElementById('IPATDesc').value;
        var PAADMAdmDate=document.getElementById('PAADMAdmDate').value;
	var PAADMDischgDate=document.getElementById('PAADMDischgDate').value;
	var PatientID=document.getElementById('PatientID').value;
	var IPATCode=document.getElementById('IPATCode').value;
	var TWKFL=document.getElementById('TWKFL').value;
	var TWKFLI=document.getElementById('TWKFLI').value;
	var TWKFLL=document.getElementById('TWKFLL').value;
	TWKFLI=TWKFLI-1;
	if (TWKFL=="") {location.href="paadmsnapepnew.csp?SNAPEpisodeID="+SNAPEpisodeID+"&PatientID="+PatientID+"&PARREF="+EpisodeID+"&CARETYPDesc="+CareType+"&PAADMAdmDate="+PAADMAdmDate+"&PAADMDischgDate="+PAADMDischgDate+"&EpisodeID="+EpisodeID+"&ADLCareType="+ADLCareType+"&SNAPDetailShow="+SNAPEpisodeID+"&IPATCode="+IPATCode;}
	else {location.href="websys.csp?SNAPEpisodeID="+SNAPEpisodeID+"&PatientID="+PatientID+"&PARREF="+EpisodeID+"&IPATDesc="+CareType+"&PAADMAdmDate="+PAADMAdmDate+"&PAADMDischgDate="+PAADMDischgDate+"&EpisodeID="+EpisodeID+"&ADLCareType="+ADLCareType+"&SNAPDetailShow="+SNAPEpisodeID+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&TWKFLL="+TWKFLL+"&IPATCode="+IPATCode+"&SNAPWFFlag="+IPATCode;}
	}
	return false;
}
	try {if (tbl) tbl.onclick=SelectRowHandler;} catch(e) {}

function NewLinkClicked() {
	var obj=document.forms['fPAAdmSNAP_ListNew'].elements['TWKFLI'];
	if (obj) obj.value-=1;	
	var PatientID=document.getElementById('PatientID').value;
	var id=""
	var EpisodeID=document.getElementById('EpisodeID').value;
	var CareType=document.getElementById('CARETYPDesc').value;
        var PAADMAdmDate=document.getElementById('PAADMAdmDate').value;
	var PAADMDischgDate=document.getElementById('PAADMDischgDate').value;
	var PatientID=document.getElementById('PatientID').value;
	location.href="paadmsnapdetailnew.csp?ID="+id+"&PARREF="+EpisodeID+"&PatientID="+PatientID+"&PARREF="+EpisodeID+"&CARETYPDesc="+CareType+"&PAADMAdmDate="+PAADMAdmDate+"&PAADMDischgDate="+PAADMDischgDate+"&EpisodeID="+EpisodeID
	return false;
}

function UpdatelinkClicked() {
	var TWKFL=document.getElementById('TWKFL').value;
	var TWKFLI=document.getElementById('TWKFLI').value;
	//TWKFLI=TWKFLI-1;
	var ID=document.getElementById('EpisodeID').value;
	var EpisodeID=document.getElementById('EpisodeID').value;
	//
	var PatientID=document.getElementById('PatientID').value;
	//
	if (TWKFL=="") {return true;}
	else {location.href="websys.csp?ID="+ID+"&EpisodeID="+EpisodeID+"&PatientID="+PatientID+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&PAADMCONTCAREID="+ID;}
	//else {location.href="websys.csp?&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI;}
	return false;
}

function LinkDisable(evt) {
	var el = websys_getSrcElement(evt);
	if (el.disabled) { 
		return false;
	}
	return true;
}


window.document.body.onload=PAAdmSNAPListNewLoadHandler;