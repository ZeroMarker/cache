/// DHCPEPosQuery.StandardList.js

/// 创建时间		2006.03.16
/// 创建人		xuwm
/// 主要功能		显示站点的列表
/// 对应表		DHC_PE_Station
/// 最后修改时间
/// 最后修改人	

var CurrentSel=0;
var TFORM="tDHCPEPosQuery_StandardList";
function BodyLoadHandler() {
	var obj=document.getElementById("SelectAll");
	if (obj) { obj.onclick=SelectAll; }
	
	// 查询类型?是否只查询符合全部条件的患者
	var obj=document.getElementById("QueryType");
	if (obj) { obj.onclick=SetQueryType; }
	
	obj=document.getElementById("Desc");
	if (obj){
		obj.ondblclick=Desc_dblclick;
		obj.onkeydown = Desc_keydown;
	}
	
	iniForm();
	
}

function iniForm() {

}

function BQuery_click() {
	//window.event.cancelBubble = false;
	var iDesc='', iIllness='Y', iCommonIllness='Y';
	var obj;
	
	obj=document.getElementById("Desc");
	if (obj && ""!=obj.value) { iDesc =obj.value; }
	
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPosQuery.StandardList"
			+"&"+"Desc="+iDesc
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
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

function SetQueryType() {
	var eSrc=window.event.srcElement;
	if (eSrc.checked) { parent.SetQueryType("A"); } // "与"的关系
	else{ parent.SetQueryType("O"); } // "或"的关系
	
}
function SearchARCIM(value){
	var aiList=value.split("^");
	if (""==value){return false}
	else{
		var obj;
		
		obj=document.getElementById("Desc");
		obj.value=aiList[0];

	}
}
function SelectAll() {
	
	var objtbl=document.getElementById(TFORM);
	if (objtbl) { var rows=objtbl.rows.length; }
	else { return false; }
	var CurrentSel=0;
	var Standards='', StandardDescs='';
	var StandardDesc='';
	var eSrc=window.event.srcElement;
	for (iLoop=1;iLoop<=rows-1;iLoop++) {
		CurrentSel=iLoop;
		SelRowObj=document.getElementById('T_Select'+'z'+CurrentSel);
		if (SelRowObj) { SelRowObj.checked=eSrc.checked; }
		
		SelRowObj=document.getElementById('ODS_RowId'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.value) { Standards=Standards+SelRowObj.value+"^"; }
		
		StandardDesc='';
		SelRowObj=document.getElementById('OD_Desc'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.innerText) { StandardDesc=SelRowObj.innerText+'-'; }
		SelRowObj=document.getElementById('ODS_Textval'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.innerText) { StandardDesc=StandardDesc+SelRowObj.innerText; }
		SelRowObj=document.getElementById('ST_Desc'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.innerText) { StandardDesc=StandardDesc+'('+SelRowObj.innerText+')'; }
		if (''!=StandardDesc) { StandardDescs=StandardDescs+StandardDesc+'^'; }
		
	}
	
	if (eSrc && eSrc.checked && ''!=Standards) {
		SetStandardList(Standards,StandardDescs,'A');
	}else{
		SetStandardList(Standards,StandardDescs,'D'); 		
	}	
}

// 向父页传输数据

function SetStandardList(Standards,StandardDescs,operatorType) {
	
	parent.SetStandardList(Standards,StandardDescs,operatorType);
}

/*
	function SetStandardList(StandardDRListList,StandardDescList,operatorType){
		var iStandardDR='';iStandardDesc='';
		var StandardDRs=StandardDRListList.split('^');
		var StandardDescs=StandardDescList.split('^');
		
		var obj=parent.frames["DHCPEPosQuery.PersonList"].document.getElementById('StandardsList');
		if (obj) {
		

			for (var iLoop=0;iLoop<StandardDRs.length;iLoop++) {
								
				if (''!=StandardDRs[iLoop]) {
					if ('A'==operatorType) {
						if (-1==ifexist(StandardDRs[iLoop],obj)) {							
							obj.options[obj.options.length]=new Option(StandardDescs[iLoop], StandardDRs[iLoop]);
						}
					}
					else{
						if (-1!=ifexist(StandardDRs[iLoop],obj)) {
							obj.options[ifexist(StandardDRs[iLoop],obj)]=null;
						}
					}
				}
			}
		}
	}
	
	function ifexist(val,list)
	{
		for (var i=0;i<list.options.length;i++){
			if (list.options[i].value==val)
			{
				return i;
			}
	}
		return -1;
	}	
	
	function SetQueryType(QueryType) {
		var obj=parent.frames["DHCPEPosQuery.PersonList"].document.getElementById('QueryType');
		if (obj) { obj.value=QueryType; }
	}
	*/
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

function ShowCurRecord(CurrentSel) {
	
	var eSrc=window.event.srcElement;
	var Standards='', StandardDesc='', StandardDescs='';
	var SelRowObj;
	//if (-1<eSrc.id.indexOf('T_Select')) {
		
		SelRowObj=document.getElementById('ODS_RowId'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.value) { Standards=Standards+SelRowObj.value+"^"; }
			
		StandardDesc='';
		SelRowObj=document.getElementById('OD_Desc'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.innerText) { StandardDesc=SelRowObj.innerText+'-'; }
		SelRowObj=document.getElementById('ODS_Textval'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.innerText) { StandardDesc=StandardDesc+SelRowObj.innerText; }
		SelRowObj=document.getElementById('ST_Desc'+'z'+CurrentSel);
		if (SelRowObj && ""!=SelRowObj.innerText) { StandardDesc=StandardDesc+'('+SelRowObj.innerText+')'; }
		if (''!=StandardDesc) { StandardDescs=StandardDescs+StandardDesc+'^'; }
		
		SelRowObj=document.getElementById('T_Select'+'z'+CurrentSel);
		if (SelRowObj && SelRowObj.checked) {
			SetStandardList(Standards,StandardDescs,'A');
		}else{ SetStandardList(Standards,StandardDescs,'D'); }
	//}
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
   
//	if (selectrow==CurrentSel) {	    
//		CurrentSel=0
//		return;
//	}

	CurrentSel=selectrow;
    ChangeCheckStatus("T_Select");
	ShowCurRecord(CurrentSel);

}

document.body.onload = BodyLoadHandler;