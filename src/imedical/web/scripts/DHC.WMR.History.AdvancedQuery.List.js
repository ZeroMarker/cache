/* ======================================================================

JScript Source File -- Created with SAPIEN Technologies PrimalScript 4.1

NAME: DHC.WMR.History.AdvancedQuery.List.js

AUTHOR: LiYang , Microsoft
DATE  : 2007-3-21
========================================================================= */
var intSelectRow = -1;

function SelectRowHandler()	{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHC_WMR_History_AdvancedQuery_List');
	var rows=objtbl.rows.length;
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (!selectrow) 
	{
		intSelectRow = -1;
	}
	else
	{
		intSelectRow = selectrow;
		document.getElementById("txtRowID").value = document.getElementById("RowIDz" + intSelectRow).value;
	}	
	var paadm="",patientId="";
	var obj=document.getElementById("paadmz"+intSelectRow);
	if (obj){
		paadm=obj.value;	
	}
	var obj=document.getElementById("PatientIdz"+intSelectRow);
	if (obj){patientId=obj.value}
	var frm=parent.parent.parent.document.forms['fEPRMENU'];
	//var frm =dhcsys_getmenuform();
	//alert(frm);
	var frmEpisodeID=frm.EpisodeID;
	var frmPatientID=frm.PatientID;
	var frmmradm=frm.mradm;
	frmEpisodeID.value=paadm;
}

