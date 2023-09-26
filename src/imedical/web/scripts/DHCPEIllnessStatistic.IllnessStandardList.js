/// DHCPEIllnessStatistic.IllnessStandardList.js
/// 创建时间		2007.12.19
/// 创建人		xuwm
/// 主要功能		显示疾病的列表-疾病汇总/疾病统计
/// 对应表		
/// 最后修改时间
/// 最后修改人	

var CurrentSel=0;
var TFORM="tDHCPEIllnessStatistic_IllnessStandardList"
function BodyLoadHandler() {
	
	// 全选/取消
	var obj=document.getElementById("SelectAll");
	if (obj) { obj.onclick=SelectAll; }
	
	obj=document.getElementById("BQuery");
	if (obj){ obj.onclick=BQuery_click; }
	
	obj=document.getElementById("EDorILLAlias");
	if (obj){
		obj.ondblclick=AddDiagnosis_dblclick;
		obj.onkeydown = AddDiagnosis_keydown;
	}
    obj=document.getElementById("CommonILL");
	if (obj){obj.onclick=BQuery_click;}
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
	var iAddDiagnosis='', iIllness='Y', iCommonIllness='N';
	var obj;
	
	obj=document.getElementById("EDorILLAlias");
	if (obj && ""!=obj.value) { iAddDiagnosis =obj.value; }

	obj=document.getElementById("CommonILL");
	if (obj && obj.checked) { iCommonIllness="Y"; }
	else { iCommonIllness="N"; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIllnessStatistic.IllnessStandardList"
			+"&"+"EDorILLAlias="+iAddDiagnosis		
			+"&"+"Illness="+iIllness
			+"&"+"CommonIllness="+iCommonIllness
			
		
 
	location.href=lnk;	

	
}

function AddDiagnosis_dblclick() {
	var src=window.event.srcElement;
	src.value="";
}

function AddDiagnosis_keydown(e) {

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
	
	var ISIDs='',ISDescs='';
	
	for (iLoop=1;iLoop<=rows-1;iLoop++) {
		
		SelRowObj=document.getElementById('IS_Select'+'z'+iLoop);
		if (SelRowObj) { SelRowObj.checked=eSrc.checked; }
		
		SelRowObj=document.getElementById('IS_RowId'+'z'+iLoop);
		if (SelRowObj && ""!=SelRowObj.value) { ISIDs=ISIDs+SelRowObj.value+"^"; }
			
		SelRowObj=document.getElementById('IS_Code'+'z'+iLoop);
		if (SelRowObj && ""!=SelRowObj.innerText) { ISDescs=ISDescs+SelRowObj.innerText+"^"; }
			
		
	}
	//alert('ISIDs:'+ISIDs+'\n'+'ISDescs:'+ISDescs);
	if (eSrc.checked) {
		SetIllnessStandardList(ISIDs, ISDescs,'A');
	}else{
		SetIllnessStandardList(ISIDs, ISDescs,'D');
	}
}


function SetIllnessStandardList(ISDRList,ISDescList,operatorType) {
	// 疾病列表
	parent.SetIllnessStandardList(ISDRList,ISDescList,operatorType);
}

function ShowCurRecord(CurrentSel) {
	//alert('ShowCurRecord');
	var ISIDs='', ISDescs='';
	var eSrc=window.event.srcElement;
	
	if (-2<eSrc.id.indexOf('IS_Select')) {
		var SelRowObj;
		SelRowObj=document.getElementById('IS_RowId'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.value) { ISIDs=ISIDs+SelRowObj.value+"^"; }
			
		SelRowObj=document.getElementById('IS_Code'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.value) { ISDescs=ISDescs+SelRowObj.innerText+"^"; }

	}
	
	//add by wangfujian  2009-05-31
	if(-1==eSrc.id.indexOf('IS_Select'))
	{	//如果单击一行?改变前面的选择框?方法在DHCPE.Toolets.Common.JS
		ChangeCheckStatus("IS_Select");
	}
	//add++
	//alert('ISIDs:'+ISIDs+'\n'+'ISDescs:'+ISDescs);
	SelRowObj=document.getElementById('IS_Select'+'z'+CurrentSel);
	
	if (SelRowObj && SelRowObj.checked) {
		SetIllnessStandardList(ISIDs,ISDescs,'A');
	}else{ SetIllnessStandardList(ISIDs,ISDescs,'D'); }
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

