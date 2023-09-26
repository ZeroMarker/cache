// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.getElementById("fPAAdmSNAPEpisode_List");
var tbl=document.getElementById('tPAAdmSNAPEpisode_List')
	

function PAAdmSNAPEpisodeListLoadHandler(e) {
 
	var obj = document.getElementById("New1")
	obj.onclick = NewClickHandler;
	if (tsc['New1']) websys_sckeys[tsc['New1']]=NewClickHandler;
}

function NewClickHandler() {
	
   	var id="";
	var epi="";
	var pat=document.getElementById('PatientID').value;
	var epi=document.getElementById('EpisodeID').value;
		
	//var fa=document.getElementById("fPAAdm_List");
	//var tbla=document.getElementById('tPAAdm_List')
	//if ((fa)&&(tbla)&&(epi==""))
	//{
	//var numRows=tbla.rows.length;
	 // for (i=1;i<numRows;i++)
  	//	{
	//	select=document.getElementById("selectz"+i);
	//	if ((select)&&(select.checked==true)) {epi=document.getElementById("EpisodeIDz"+i);}
   	//	if (tbla.rows[i].className=="clsRowSelected") {epi=document.getElementById("EpisodeIDz"+i);}
	//	}
	//}
	if ((epi)&&(epi!="")&&(pat)&&(pat!=""))
	{
	//epi=epi.value;
	//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAAdmSNAP.Edit&ID='+id+'&PatientID='+pat+'&EpisodeID='+epi+'&PARREF='+epi+'&PatientBanner=1','','width=600,height=500');
	//websys_createWindow('paadmsnapep.csp?ID='+id+'&PatientID='+pat+'&EpisodeID='+epi+'&admstring='+epi+'&PARREF='+epi+'&PatientBanner=1','','width=800,height=650');
	window.location='paadmsnapep.csp?PAADMSNAPID='+id+'&PatientID='+pat+'&EpisodeID='+epi+'&PARREF='+epi+'&PatientBanner=1';
	}
	else { alert(t['NoEpisodeSelected']);}
	return false; 	
}
function SelectRowHandler(evt) {
	//websys.List.js has already set the selected row into a variable called selectedRowObj
	var url="",objType,objID;
	var eSrc=websys_getSrcElement(evt);
	//alert(eSrc.tagName);
	if (eSrc.tagName=="IMG") eSrc=websys_getParentElement(eSrc);
	if (eSrc.href) {
		var temp1=eSrc.href.split("&TWKFL")
		var temp2=eSrc.href.split("&ID")
		var url = temp1[0] + "&ID" + temp2[1];
			}
	if (eSrc.tagName=="A") {
			 if (eSrc.id.indexOf("SNAPDatez")==0) {
				var eSrcAry=eSrc.id.split("z");
			                                      }
	                       }	
	else{
		if (eSrc.tagName=="TD") eSrc=eSrc.firstChild;
		var eSrcAry=eSrc.id.split("z");
		if (eSrc.children.length>0) {
			var eSrc=eSrc.firstChild;
			eSrcAry=eSrc.id.split("z");
		                            }
	    }
	if (eSrcAry.length<=1) return false;
	var ID=document.getElementById('SNAPRowIdz'+eSrcAry[1]).value;
	var EpisodeID=document.getElementById('EpisodeID').value;
	var PatientID=document.getElementById('PatientID').value;
	var TWKFL=document.getElementById('TWKFL').value;
	var TWKFLI=document.getElementById('TWKFLI').value;
	if (TWKFLI!="") {TWKFLI=TWKFLI-1;}
	//alert(TWKFLI);
	if (TWKFL=="") {location.href="paadmsnapep.csp?ID="+ID+"&PatientID="+PatientID+"&PARREF="+EpisodeID+"&EpisodeID="+EpisodeID+"&PAADMSNAPID="+ID;}
	if (TWKFL!="") {location.href="websys.csp?ID="+ID+"&PatientID="+PatientID+"&PARREF="+EpisodeID+"&EpisodeID="+EpisodeID+"&TWKFL="+TWKFL+"&TWKFLI="+TWKFLI+"&PAADMSNAPID="+ID;}
	return false;
}





window.document.body.onload=PAAdmSNAPEpisodeListLoadHandler;