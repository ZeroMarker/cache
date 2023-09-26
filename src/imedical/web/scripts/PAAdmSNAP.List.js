// Copyright (c) 2003 TrakHealth Pty Limited. ALL RIGHTS RESERVED. 

var f=document.getElementById("fPAAdmSNAP_List");
var tbl=document.getElementById('tPAAdmSNAP_List')
	

function PAAdmSNAPListLoadHandler(e) {
 
	var obj = document.getElementById("New1")
	obj.onclick = NewClickHandler;
	if (tsc['New1']) websys_sckeys[tsc['New1']]=NewClickHandler;
}

function NewClickHandler() {
	
   	var id="";
	var epi="";
	var pat=document.getElementById('PatientID').value;
	var epi=document.getElementById('EpisodeID').value;
		
	var fa=document.getElementById("fPAAdm_List");
	var tbla=document.getElementById('tPAAdm_List')
	if ((fa)&&(tbla)&&(epi==""))
	{
	var numRows=tbla.rows.length;
	  for (i=1;i<numRows;i++)
  		{
		select=document.getElementById("selectz"+i);
		if ((select)&&(select.checked==true)) {epi=document.getElementById("EpisodeIDz"+i);}
   		if (tbla.rows[i].className=="clsRowSelected") {epi=document.getElementById("EpisodeIDz"+i);}
		}
	}
	if ((epi)&&(epi.value!="")&&(pat)&&(pat.value!=""))
	{
	epi=epi.value;
	//websys_createWindow('websys.default.csp?WEBSYS.TCOMPONENT=PAAdmSNAP.Edit&ID='+id+'&PatientID='+pat+'&EpisodeID='+epi+'&PARREF='+epi+'&PatientBanner=1','','width=600,height=500');
	websys_createWindow('paadmsnapep.csp?ID='+id+'&PatientID='+pat+'&EpisodeID='+epi+'&admstring='+epi+'&PARREF='+epi+'&PatientBanner=1','','width=800,height=650');
	//window.location='paadmsnapep.csp?ID='+id+'&PatientID='+pat+'&EpisodeID='+epi+'&admstring='+epi+'&PARREF='+epi+'&PatientBanner=1';
	}
	else { alert(t['NoEpisodeSelected']);}
	return false; 	
}




window.document.body.onload=PAAdmSNAPListLoadHandler;