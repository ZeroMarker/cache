/// DHCPEIllnessStatistic.PersonList.js

/// 创建时间		2006.09.06
/// 创建人			xuwm
/// 主要功能		疾病统计
/// 对应表		
/// 最后修改时间
/// 最后修改人	

var CurrentSel=0;
var TFORM="tDHCPEIllnessStatistic.PersonList";
function BodyLoadHandler() {
	var obj;
	// 全选/取消
	obj=document.getElementById("BQuery");
	if (obj) { obj.onclick=Find_click; }
	
	//obj=document.getElementById("EDList");
	//if (obj) { obj.ondblclick=EDList_dblclick; }
	
	obj=document.getElementById("Clear");
	if (obj) { obj.onclick=Clear_click; }
	
	// 用按钮删除选择项
	obj=document.getElementById("DeleteItem");
	if (obj) { obj.onclick=DeleteItem_click; }
	
	iniForm();
}

function iniForm() {
	var obj;
	var EDIDs='',EDDescList='';
	obj=document.getElementById('EDIDs')
	if (obj) { EDIDs=obj.value; }
	
	obj=document.getElementById('EDDescList')
	if (obj) { EDDescList=obj.value; }
	
	SetEDList(EDIDs,EDDescList);
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

function Clear_click() {
	var obj;

	obj=document.getElementById("PatName");
	if (obj) { obj.value=''; }

	obj=document.getElementById("RegNo");
	if (obj) { obj.value=''; }
	
	obj=document.getElementById("DateFrom");
	if (obj) { obj.value=''; }
	
	obj=document.getElementById("DateTo");
	if (obj) { obj.value=''; }

	obj=document.getElementById("QueryType");
	if (obj && obj.checked) { obj.checked=false; }
	
	obj=document.getElementById('EDList');
	if (obj) { obj.options.length=0; }
	
	obj=document.getElementById('EDIDs')
	if (obj) { obj.value=''; }
	
	obj=document.getElementById('EDDescList')
	if (obj) { obj.value=''; }	
	
}
function Find_click() {
	var obj;
	
	var iEDList='', iEDDescList='';
	var iPatName='';
	var iRegNo='';
	var iDateFrom='';	
	var iDateTo='';
	var iQueryType='';
	
	iEDList=GetEDList();
	iEDDescList=GetEDDescList();
	obj=document.getElementById("PatName");
	if (obj && ""!=obj.value) { iPatName = obj.value; }

	obj=document.getElementById("RegNo");
	if (obj && ""!=obj.value) { iRegNo = obj.value; }
	
	obj=document.getElementById("DateFrom");
	if (obj && ""!=obj.value) { iDateFrom = obj.value; }
	
	obj=document.getElementById("DateTo");
	if (obj && ""!=obj.value) { iDateTo = obj.value; }

	obj=document.getElementById("QueryType");
	if (obj && obj.checked) { iQueryType = 'on'; }
	else { iQueryType = ''; }

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIllnessStatistic.PersonList"
		+"&"+"EDIDs="+iEDList
		+"&"+"EDDescList="+iEDDescList
		+"&"+"PatName="+iPatName
		+"&"+"RegNo="+iRegNo
		+"&"+"DateFrom="+iDateFrom
		+"&"+"DateTo="+iDateTo
		+"&"+"QueryType="+iQueryType
		;
	location.href=lnk;
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

// 点击按钮删除选择项
function DeleteItem_click() {
	var obj;
	var selectedIndex=-1;
	obj=document.getElementById('EDList');
	if (obj && obj.selectedIndex!=-1) {
		selectedIndex=obj.selectedIndex;
		obj.options[obj.selectedIndex]=null;
		if (selectedIndex<obj.options.length) {
			obj.selectedIndex=selectedIndex;
		}else{ obj.selectedIndex=obj.options.length-1; }
	}
	
}

// 双击按钮删除选择项
function EDList_dblclick() {
	var obj;
	obj=document.getElementById('EDList');
	if (obj && obj.selectedIndex!=-1) {
		obj.options[obj.selectedIndex]=null;
	}
}

function GetEDList() {
	var EDList='';
	var obj=document.getElementById('EDList');
	if (obj) {
		for (var iLoop=0;iLoop<obj.options.length;iLoop++) {				
			if (''!=EDList+obj.options[iLoop]) {EDList=EDList+obj.options[iLoop].value+'^'; }
		}
	}
	if (''!=EDList) { EDList='^'+EDList; }
	return EDList;

}

function GetEDDescList() {
	var EDList='';
	var obj=document.getElementById('EDList');
	if (obj) {
		for (var iLoop=0;iLoop<obj.options.length;iLoop++) {				
			if (''!=EDList+obj.options[iLoop]) {EDList=EDList+obj.options[iLoop].text+'^'; }
		}
	}
	if (''!=EDList) { EDList='^'+EDList; }
	return EDList;

}

function SetEDList(EDDRList,EDDescList) {
		var iEDDR='';iEDDesc='';
		var EDDRs=EDDRList.split('^');
		var EDDescs=EDDescList.split('^');
		var obj=document.getElementById('EDList');
		if (obj) {
			obj.options.length=0;
			for (var iLoop=0;iLoop<EDDRs.length;iLoop++) {				
				if (''!=EDDRs[iLoop]) {				
					obj.options[obj.options.length]=new Option(EDDescs[iLoop],EDDRs[iLoop])
				}
			}
		}

}

document.body.onload = BodyLoadHandler;

