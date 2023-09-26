/// DHCPEIllnessStatistic.ExpertDiagnosisList.js

///显示疾病的列表-疾病汇总/疾病统计

var CurrentSel=0;
var TFORM="tDHCPEIllnessStatistic_ExpertDiagnosisList"
function BodyLoadHandler() {
	
	// 全选/取消
	var obj=document.getElementById("SelectAll");
	if (obj) { obj.onclick=SelectAll; }
	
	obj=document.getElementById("BQuery");
	if (obj){ obj.onclick=BQuery_click; }
	
	obj=document.getElementById("Desc");
	if (obj){
		obj.ondblclick=Desc_dblclick;
		obj.onkeydown = Desc_keydown;
	}

	iniForm();
}

function iniForm() {

}

////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////
function BQuery_click() {
	//window.event.cancelBubble = false;
	var iDesc='', iIllness='Y', iCommonIllness='Y';
	var obj;
	
	obj=document.getElementById("Desc");
	if (obj && ""!=obj.value) { iDesc =obj.value; }
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIllnessStatistic.ExpertDiagnosisList"
			+"&"+"Desc="+''
			+"&"+"AliasText="+iDesc			
			+"&"+"Illness="+iIllness
			+"&"+"CommonIllness="+iCommonIllness
			;
	location.href=lnk;		
	
}

function Desc_dblclick() {
	var src=window.event.srcElement;
	src.value="";
}

function Desc_keydown(e) {
	
	var key=websys_getKey(e);
	if (key==13) {
		BQuery_click();
		return false;
	}
}

///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////

function SelectAll() {
	var eSrc=window.event.srcElement;
	
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
	
	var EDIDs='',EDDescs='';
	
	for (iLoop=1;iLoop<=rows-1;iLoop++) {
		
		SelRowObj=document.getElementById('ED_Select'+'z'+iLoop);
		if (SelRowObj) { SelRowObj.checked=eSrc.checked; }
		
		SelRowObj=document.getElementById('ED_RowId'+'z'+iLoop);
		if (SelRowObj && ""!=SelRowObj.value) { EDIDs=EDIDs+SelRowObj.value+"^"; }
			
		SelRowObj=document.getElementById('ED_DiagnoseConclusion'+'z'+iLoop);
		if (SelRowObj && ""!=SelRowObj.innerText) { EDDescs=EDDescs+SelRowObj.innerText+"^"; }
			
		
	}
	
	if (eSrc.checked) {
		SetExpertDiagnosisList(EDIDs,EDDescs,'A');
	}else{
		SetExpertDiagnosisList(EDIDs,EDDescs,'D');
	}
}


function SetExpertDiagnosisList(EDIDs,EDDescs,operatorType) {
	// 疾病列表
	parent.SetExpertDiagnosisList(EDIDs,EDDescs,operatorType);
}

function ShowCurRecord(CurrentSel) {
	var EDIDs='', EDDescs='';
	var eSrc=window.event.srcElement;
	
	if (-1<eSrc.id.indexOf('ED_Select')) {
		var SelRowObj;
		SelRowObj=document.getElementById('ED_RowId'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.value) { EDIDs=EDIDs+SelRowObj.value+"^"; }
			
		SelRowObj=document.getElementById('ED_DiagnoseConclusion'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.value) { EDDescs=EDDescs+SelRowObj.innerText+"^"; }

	}

	SelRowObj=document.getElementById('ED_Select'+'z'+CurrentSel);
	if (SelRowObj && SelRowObj.checked) {
		SetExpertDiagnosisList(EDIDs,EDDescs,'A');
	}else{ SetExpertDiagnosisList(EDIDs,EDDescs,'D'); }
}
	
function SelectRowHandler() {

	var eSrc=window.event.srcElement;

	var objtbl=document.getElementById(TFORM);

	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;

	if (!selectrow) return;

	//if (selectrow==CurrentSel) {
	//	CurrentSel=0;
	//	return;
	//}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;

