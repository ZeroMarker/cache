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
    // 调用平台方法，锁定页面
    setSysMenuDoingSth("正在加载病历...");
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

window.onbeforeunload = function(){
    //关闭时, 调用平台方法
    setSysMenuDoingSth();
    window.close();
}

// 平台调用
function xhrRefresh(obj){
    //obj包含papmi：papmi,adm,mradm：mradm,“AdmType”：“I”
    if (obj.adm === episodeID) return;
    patientID = obj.papmi;
    episodeID = obj.adm;
    initpatientRecord();
}

// 诊疗TAB切换离开时
var chartOnBlur = function () {
    document.getElementById('chartOnBlur').focus();
    //return true;
    return '' === getSysMenuDoingSth();
}

// 诊疗TAB切换进入时
var chartOnFocus = function () {
    return true;
}

function setSysMenuDoingSth(sthmsg) {
    if ('undefined' != typeof dhcsys_getmenuform) {
        var frm = dhcsys_getmenuform();
        if (frm) {
            var DoingSth = frm.DoingSth || '';
            if ('' != DoingSth) DoingSth.value = sthmsg || '';
        }
    }
}

function getSysMenuDoingSth() {
    if ('undefined' != typeof dhcsys_getmenuform) {
        var frm = dhcsys_getmenuform();
        if (frm) {
            var DoingSth = frm.DoingSth || '';
            if ('' != DoingSth) return DoingSth.value || '';
        }
    }

    return '';
}

//关闭病历页签(若阻止关闭，则return false)
function onBeforeCloseTab()
{
    setSysMenuDoingSth();
    return true;
}