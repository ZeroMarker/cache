/* ======================================================================
NAME: DHC.WMR.Discharge.List
AUTHOR: liuxuefeng , Microsoft
DATE  : 2009-6-7
=========================================================================*/

function InitForm()
{
	//var objTable = document.getElementById("tDHC_WMR_Discharge_List");
	//var cnt=objTable.rows.length-1;
	//document.getElementById("DischargeCnt").innerText=cnt;
	//document.getElementById("cDischargeCnt").style.color = "red";
	//document.getElementById("DischargeCnt").style.color = "red";
	var objTable=document.getElementById("tDHC_WMR_Discharge_List");
	var rows=objTable.rows.length;
	if (rows>0){
		for (var i=1;i<rows;i++){
			var chkItem=document.getElementById("chkitemz"+i);
			if (chkItem){chkItem.checked=true;}	
		}	
	}
}
function InitEvent()
{
	var chkSelectAll=document.getElementById("chkall");
	if (chkSelectAll){
		chkSelectAll.onclick=CheckAll_Click;
		chkSelectAll.checked=true;            //Ä¬ÈÏÑ¡ÖÐ	
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
function CheckAll_Click()
{
	var chkSelectAll=document.getElementById("chkall");
	var objTable=document.getElementById("tDHC_WMR_Discharge_List");
	var rows=objTable.rows.length;
	if (rows>0){
		if (chkSelectAll.checked){
			for (var i=1;i<rows;i++){
			  var chkItem=document.getElementById("chkitemz"+i);
			   if (chkItem){chkItem.checked=true;}	
		    }
		}else{
			for (var i=1;i<rows;i++){
			  var chkItem=document.getElementById("chkitemz"+i);
			   if (chkItem){chkItem.checked=false;}	
		    }	
		}
	}
}
InitEvent();
InitForm();
