function initForm()
{
	var obj=document.getElementById("btnNewRep");
	if (obj){
		obj.onclick=btnNewRep_Click;
	}
}

function btnNewRep_Click(){
	//Add By LiYang 2012-02-15   FixBug:�޷���ȡ�����Ĵ���,û�и�PatientID,EpisodeID������ֵ
	var PatientID = document.getElementById("hdnPatientID").value;
	var EpisodeID = document.getElementById("hdnEpisodeID").value;
	//==========
	var lnk="dhcmed.epd.report.csp?&1=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&ReportID=";
	window.showModalDialog(lnk,"","dialogWidth=950px;dialogHeight=630px;status=no");
	window.location.reload();  //Add By LiYang 2012-02-15  �������ˢ���б�
}

initForm();