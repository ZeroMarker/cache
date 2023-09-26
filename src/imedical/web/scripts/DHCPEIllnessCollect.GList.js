/// DHCPEIllnessCollect.GList.js
/// 创建时间		2007.01.05
/// 创建人			xuwm
/// 主要功能		显示团体的列表-疾病汇总/体征汇总
/// 对应表		
/// 最后修改时间
/// 最后修改人	    yupeng

var CurrentSel=0;
var TFORM='tDHCPEIllnessCollect_GList';
function BodyLoadHandler() 
{
	// 全选/取消
	var obj=document.getElementById("SelectAll");
	if (obj) { obj.onclick=SelectAll; }

	
}



function SelectRecord(RowVal) 
{

	var RowVals=RowVal.split('^');
	var iGid=0,iSelect=0;
	if (RowVals[0]) { iGid=RowVals[0]; }
	else { return false;}
	if (RowVals[1]) { iSelect=RowVals[1]; }
	else { return false;}
	
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
	

	var GList='';
	for (var iLoop=1;iLoop<=rows-1;iLoop++) {
		SelRowObj=document.getElementById('T_Select'+'z'+iLoop);
		if (SelRowObj && SelRowObj.checked) {
			SelRowObj=document.getElementById('TGRowId'+'z'+iLoop);
			if (SelRowObj && ""!=SelRowObj.value) { GList=GList+SelRowObj.value+"^"; }		
		}
	}
	parent.SetGroupList(GList);
}

function ShowCurRecord(CurrentSel) 
{
	var Gid=-1;
	var iSelect=0;
	var RowVal='';
	
	var SelRowObj;
	
	SelRowObj=document.getElementById('T_Select'+'z'+CurrentSel);
	if (SelRowObj && SelRowObj.checked) {  iSelect=1; }	
	
	SelRowObj=document.getElementById('TGRowId'+'z'+CurrentSel);
	if (SelRowObj && ""!=SelRowObj.value) { Gid=SelRowObj.value; }
	
	RowVal=Gid+'^'+iSelect;
	SelectRecord(RowVal);

}

function SelectRowHandler() 
{
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	CurrentSel=selectrow;
    ChangeCheckStatus("T_Select");
	ShowCurRecord(CurrentSel);

}

function SelectAll()
{
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
	var eSrc=window.event.srcElement;
	for (var iLoop=1;iLoop<=rows-1;iLoop++)
	{
		var SelRowObj=document.getElementById('T_Select'+'z'+iLoop);
	    if (SelRowObj) { SelRowObj.checked=eSrc.checked; }	
		ShowCurRecord(iLoop);
	}
}

document.body.onload = BodyLoadHandler;

