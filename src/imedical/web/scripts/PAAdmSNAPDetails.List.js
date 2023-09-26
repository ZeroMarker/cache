// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.getElementById("fPAAdmSNAPDetails_List");
var tbl=document.getElementById('mPAAdmSNAPDEtails_List')


function PAAdmSNAPEpisodeDetListLoadHandler(e) {
  
}


function NewLinkClicked() {
	//alert("new2 clicked");
	var obj=document.forms['fPAAdmSNAPDetails_List'].elements['TWKFLI'];
	if (obj) obj.value-=1;	
	var PatientID=document.getElementById('PatientID').value;
	var id=""
	var EpisodeID=document.getElementById('EpisodeID').value;
	var CareType=document.getElementById('CARETYPDesc').value;
        var PAADMAdmDate=document.getElementById('PAADMAdmDate').value;
	var PAADMDischgDate=document.getElementById('PAADMDischgDate').value;
	var PatientID=document.getElementById('PatientID').value;
	var SNAPEpisodeID=document.getElementById('SNAPEpisodeID').value;	
	var ADLCareType=document.getElementById('ADLCareType').value;	
	var SNAPDetailShow=document.getElementById('SNAPDetailShow').value;
	location.href="paadmsnapdetailnew.csp?ID="+id+"&PARREF="+SNAPEpisodeID+"&PatientID="+PatientID+"&PARREF="+EpisodeID+"&CARETYPDesc="+CareType+"&PAADMAdmDate="+PAADMAdmDate+"&PAADMDischgDate="+PAADMDischgDate+"&EpisodeID="+EpisodeID+"&SNAPEpisodeID="+SNAPEpisodeID+"&ADLCareType="+ADLCareType+"&SNAPDetailShow="+SNAPDetailShow
	return false;
}


window.document.body.onload=PAAdmSNAPEpisodeDetListLoadHandler;