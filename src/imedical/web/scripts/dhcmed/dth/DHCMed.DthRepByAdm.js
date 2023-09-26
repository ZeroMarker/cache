	var PatientID="",EpisodeID="";
	var obj=document.getElementById("PatientID");
	if (obj) PatientID=obj.value;
	
	var obj=document.getElementById("EpisodeID");
	if (obj) EpisodeID=obj.value;
	var obj=document.getElementById("NewDMRep");
	if (obj){
		obj.onclick=NewDMRep_Click;
	}
function NewDMRep_Click(){
	var lnk="dhcmed.ss.clinreptoadm.csp?1=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&ReportID=";
	window.showModalDialog(lnk,"","dialogWidth=920px;dialogHeight=640px;status=no");
	window.location.reload(); 
}

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) {
		intSelectRow = -1;
	}else{
		intSelectRow = selectrow;
	}
	var ReportID="";
	var obj=document.getElementById("DMRepRowidz" + intSelectRow);
	if (obj) ReportID=obj.innerText;
	
	var t=new Date();
	t=t.getTime();
	var lnk="dhcmed.dth.report.csp?1=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&CTLocID="+session['LOGON.CTLOCID']+"&ReportID="+ReportID+"&menuId=&t="+t;
	var ret=window.open(lnk,'deathreport11','height=695,width=1010,top=0,left=150,toolbar=no,menubar=no,scrollbars=no, resizable=no,location=no,status=no')
	window.location.reload(); 
}
