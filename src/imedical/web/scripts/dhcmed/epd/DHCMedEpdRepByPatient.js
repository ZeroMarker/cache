function initForm()
{
	var obj=document.getElementById("btnNewRep");
	if (obj){
		obj.onclick=btnNewRep_Click;
	}
}

function btnNewRep_Click(){
	//Add By LiYang 2012-02-15   FixBug:无法获取参数的错误,没有给PatientID,EpisodeID变量赋值
	var PatientID = document.getElementById("hdnPatientID").value;
	var EpisodeID = document.getElementById("hdnEpisodeID").value;
	//==========
	var lnk="dhcmed.epd.report.csp?&1=1&PatientID="+PatientID+"&EpisodeID="+EpisodeID+"&ReportID=";
	window.showModalDialog(lnk,"","dialogWidth=950px;dialogHeight=630px;status=no");
	window.location.reload();  //Add By LiYang 2012-02-15  报告完后刷新列表
}

initForm();