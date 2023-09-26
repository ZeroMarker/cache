$(function(){
	InitPatientList();
});
//Desc:病人列表信息
function InitPatientList()
{
	var inPatTabTitle = "在院患者";
	var inPat = '<iframe id = "frameinPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="emr.patientlist.inpat.csp?Title='+ inPatTabTitle +'"></iframe>';
    addTab("inPatTab",inPatTabTitle,inPat,false,true);

	var outPatTabTitle = "出院患者";
	var outPat = '<iframe id = "frameoutPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="emr.patientlist.outpat.csp?Title='+ outPatTabTitle +'"></iframe>';
    addTab("outPatTab",outPatTabTitle,outPat,false,false);
	
	var transPatTabTitle = "转出患者";
	var transPat = '<iframe id = "frametransPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="emr.patientlist.transpat.csp?Title='+ transPatTabTitle +'"></iframe>';
    addTab("transPatTab",transPatTabTitle,transPat,false,false);
	
	var operationPatTabTitle = "手术患者";
	var operationPat = '<iframe id = "frameoperationPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="emr.patientlist.operationpat.csp?Title='+ operationPatTabTitle +'"></iframe>';
    addTab("operationPatTab",operationPatTabTitle,operationPat,false,false);
	
	var criticallyPatTabTitle = "危重患者";
	var criticallyPat = '<iframe id = "framecriticallyPat" frameborder="0" style="width:100%; height:100%;scrolling:no;" src="emr.patientlist.criticallypat.csp?Title='+ criticallyPatTabTitle +'"></iframe>';
    addTab("criticallyPatTab",criticallyPatTabTitle,criticallyPat,false,false);

}

function addTab(tabId,tabTitle,content,closable,selected)
{
	$('#patientTabs').tabs('add',{
	    id:       tabId,
		title:    tabTitle,
		content:  content,
		closable: closable,
		selected: selected
   });	
}
/*
// 切换tab页签，重新加载数据
$('#patientTabs').tabs({
	onSelect: function(title,index)
		{
			var SelectedTab = $('#patientTabs').tabs('getSelected');
			if (SelectedTab.attr("id") == "inPatTab")
			{
				$('#frameinPat').attr("src","emr.patientlist.inpat.csp");
			}
			else if (SelectedTab.attr("id") == "outPatTab")
			{
				$('#frameoutPat').attr("src","emr.patientlist.outpat.csp");
			}
			else if (SelectedTab.attr("id") == "transPatTab")
			{
				$('#frametransPat').attr("src","emr.patientlist.transpat.csp");
			}
			else if (SelectedTab.attr("id") == "operationPatTab")
			{
				$('#frameoperationPat').attr("src","emr.patientlist.operationpat.csp");
			}
			else if (SelectedTab.attr("id") == "criticallyPatTab")
			{
				$('#framecriticallyPat').attr("src","emr.patientlist.criticallypat.csp");
			}
		}
});
*/
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
	
	parent.episodeID = EpisodeID;
	//刷新医嘱单界面信息
	try { parent.parent.refreshBar();} catch (e) {} 
	
	var src = "emr.record.csp?PatientID=" + PatientID + "&EpisodeID=" + EpisodeID;
	parent.$('#framePatientRecord').attr("src",src);
	parent.$('.easyui-layout').layout('collapse','west');
}


