$(function(){
	//加载患者列表
	initPatientList();
	initpatientRecord();
});

//Desc:患者列表
function initPatientList()
{
    var patientList= '<iframe id="framePatientList" src="emr.patientlistseek.csp" width="100%" height="100%"'+
                     'marginheight="0" marginwidth="0" scrolling="no" align="middle"></iframe>'	
    $('#patientList').append(patientList);                
}

//Desc:病历信息
function initpatientRecord()
{
	var patientRecord = '<iframe id="framePatient"src="emr.record.browse.patient.csp?PatientID=' + patientID + 
                        '&EpisodeID=' + episodeID +'" width="100%" height="100%" marginheight="0"' + 
                        'marginwidth="0" scrolling="no" align="middle"></iframe>'; 
    $('#browseList').append(patientRecord);                   
}

//获取头菜单信息
function getMenuForm() {
    var win = top.frames['eprmenu'];
    if (win) {
        var frm = win.document.forms['fEPRMENU'];
        return frm;
    }

    var frm = parent.frames[0].document.forms["fEPRMENU"];
    if (frm) return frm;
    frm = top.document.forms["fEPRMENU"];
    return frm
}

//Desc:切换患者
function doSwitch(PatientID,EpisodeID,mradm) {
	var frm = getMenuForm();
	if (frm)
	{
		var frmEpisodeID = frm.EpisodeID;
		var frmPatientID = frm.PatientID;
		var frmmradm = frm.mradm;
		frmPatientID.value = PatientID;
		frmEpisodeID.value = EpisodeID;
		frmmradm.value = mradm;
	}
	var src = "emr.record.browse.patient.csp?PatientID=" + PatientID + "&EpisodeID=" + EpisodeID;
	$('#framePatient').attr("src",src);
	$('.easyui-layout').layout('collapse','west');
}
