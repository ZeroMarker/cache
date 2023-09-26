//文件	DHCPEReportCheck.js
//组件	DHCPEReportCheck
//对象	
//功能	检查报告预览
//创建	xuwm
//时间	2006/05/17
//状态	

var CurrentSel=0
function BodyLoadHandler() {
	var obj;
	
	obj=document.getElementById("BPreview");
	if (obj){ obj.onclick=BPreview_click; }
	
	//iniForm();
	//Clear_click();
	//ShowCurRecord(1);

}

function iniForm(){
	
}

function BPreview_click() {

	var curEPRObject = new ActiveXObject("ReportDll.CReport.1");	
	curEPRObject.ShowReport("47835||1","9648");
	
}

function Delete_click() {
	var curEPRObject = new ActiveXObject("ReportDll.CReport.1");	
	curEPRObject.ShowReport(frm.OEOrdItemID.value,userid);
}


function ShowCurRecord(CurRecord) {

}

function Clear_click() {
	var obj;	  
}			
function SelectRowHandler() {

	var eSrc=window.event.srcElement;

	var objtbl=document.getElementById('tDHCPEReportCheck');
	
	if (objtbl) { var rows=objtbl.rows.length; }

	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;
	    
	if (selectrow==CurrentSel)
	{	    
	
	    Clear_click();
	    CurrentSel=0;
	    return;
	}

	CurrentSel=selectrow;
	
	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;

