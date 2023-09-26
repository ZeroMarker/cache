/* ======================================================================
/// 名称: DHC.WMR.MerLateTo.List.js 
/// Creator：     liulan
/// CreatDate：   2012-11-24
/// Description:  病案迟归查询:查询病案未按时完成汇总表

=========================================================================*/

function InitForm()
{
	var objTable=document.getElementById("tDHC_WMR_MerLateTo_List");
	var rows=objTable.rows.length;
	if (rows>0){
		for (var i=1;i<rows;i++){
			var chkItem=document.getElementById("chkitemz"+i);
			if (chkItem){chkItem.checked=true;}	
		}	
	}
}
function SelectRowHandler(){
	var eSrc=window.event.srcElement;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) 
	{
		intSelectRow = -1;
	}
	else
	{
		intSelectRow = selectrow;
	} 
	var paadm="",patientId="";
	var obj=document.getElementById("paadmIdz"+intSelectRow);
	if (obj){
		paadm=obj.value;	
	}
	var obj=document.getElementById("PatientIdz"+intSelectRow);
	if (obj){patientId=obj.value}
	//var frm =dhcsys_getmenuform();
	var frm=parent.parent.parent.document.forms['fEPRMENU'];
	var frmEpisodeID=frm.EpisodeID;
	var frmPatientID=frm.PatientID;
	var frmmradm=frm.mradm;
	frmEpisodeID.value=paadm;
	
}

InitForm();
