/// DHCPEIllnessCollect.GList.js
/// 创建时间		2007.01.05
/// 创建人			xuwm
/// 主要功能		显示团体的列表-疾病汇总/体征汇总
/// 对应表		
/// 最后修改时间
/// 最后修改人	

var CurrentSel=0;
var TFORM='tDHCPEIllnessStatistic_GList';
function BodyLoadHandler() {
	
	// 全选/取消
	//var obj=document.getElementById("SelectAll");
	//if (obj) { obj.onclick=SelectAll; }

	iniForm();
	
}

function iniForm() {

}


function SelectRecord(RowVal) {

	var RowVals=RowVal.split('^');
	var iGid=0,iTid=0,iSelect=0;
	if (RowVals[0]) { iGid=RowVals[0]; }
	else { return false;}
	if (RowVals[1]) { iTid=RowVals[1]; }
	else { return false;}
	if (RowVals[1]) { iSelect=RowVals[2]; }
	else { return false;}
	
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
	if (1==iSelect) {
		
		for (var iLoop=1;iLoop<=rows-1;iLoop++) {							
			if (1==iTid) {
				// 选择的是团体组
				SelRowObj=document.getElementById('TGRowId'+'z'+iLoop);
				if (SelRowObj && iGid==SelRowObj.value) {
					SelRowObj=document.getElementById('TTRowId'+'z'+iLoop);
					if (SelRowObj && ''==SelRowObj.value) {
						SelRowObj=document.getElementById('T_Select'+'z'+iLoop);
						if (SelRowObj) { SelRowObj.checked=false; }
					}
				}
			}
			else{
				// 选择的是团体
				SelRowObj=document.getElementById('TGRowId'+'z'+iLoop);
				if (SelRowObj && iGid==SelRowObj.value) {					
					SelRowObj=document.getElementById('TTRowId'+'z'+iLoop);
					if (SelRowObj && ''!=SelRowObj.value) {
						SelRowObj=document.getElementById('T_Select'+'z'+iLoop);
						if (SelRowObj) { SelRowObj.checked=false; }
					}
				}	
			}			
		}
	}

	var GList='';
	var TList='';
	for (var iLoop=1;iLoop<=rows-1;iLoop++) {
		SelRowObj=document.getElementById('T_Select'+'z'+iLoop);
		if (SelRowObj && SelRowObj.checked) {
			SelRowObj=document.getElementById('TTRowId'+'z'+iLoop);
			if (SelRowObj && ""!=SelRowObj.value) { TList=TList+SelRowObj.value+"^"; }
			else {
				SelRowObj=document.getElementById('TGRowId'+'z'+iLoop);
				if (SelRowObj && ""!=SelRowObj.value) { GList=GList+SelRowObj.value+"^"; }			
			}
		}
	}
	parent.SetGroupList(GList,TList);
}

function ShowCurRecord(CurrentSel) {
	
	var Gid=-1;
	var Tid=0;
	var iSelect=0;
	var RowVal='';
	
	var SelRowObj;
	
	//
	SelRowObj=document.getElementById('T_Select'+'z'+CurrentSel);
	if (SelRowObj && SelRowObj.checked) {  iSelect=1; }	
	
	//
	SelRowObj=document.getElementById('TGRowId'+'z'+CurrentSel);
	if (SelRowObj && ""!=SelRowObj.value) { Gid=SelRowObj.value; }
	
	//
	SelRowObj=document.getElementById('TTRowId'+'z'+CurrentSel);
	if (SelRowObj && ""!=SelRowObj.value) { Tid=1; }
	
	RowVal=Gid+'^'+Tid+'^'+iSelect;
	SelectRecord(RowVal);

}

function SelectRowHandler() {

	var eSrc=window.event.srcElement;

	var objtbl=document.getElementById(TFORM);

	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
	
	var lastrowindex=rows - 1;
	
	var rowObj=getRow(eSrc);
	
	var selectrow=rowObj.rowIndex;
	//

//	if (!selectrow) return;

//	if (selectrow==CurrentSel) {
//		CurrentSel=0
//		return;
//	}

	CurrentSel=selectrow;

	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;

