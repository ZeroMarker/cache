/// DHCPEPosQuery.PersonList.js
/// 创建时间		2007.09.06
/// 创建人			xuwm
/// 主要功能		阳性体征查询
/// 对应表		
/// 最后修改时间
/// 最后修改人	

var CurrentSel=0;
var TFORM="tDHCPEPosQuery.PersonList";
function BodyLoadHandler() {
	var obj;
	// 全选/取消
	obj=document.getElementById("BQuery");
	if (obj) { obj.onclick=Find_click; }
	
	obj=document.getElementById("Export");
	if (obj) { obj.onclick=Export_click; }
	
	//obj=document.getElementById("StandardsList");
	//if (obj) { obj.ondblclick=StandardsList_dblclick; }
	
	obj=document.getElementById("Clear");
	if (obj) { obj.onclick=Clear_click; }
	
	// 用按钮删除选择项
	obj=document.getElementById("DeleteItem");
	if (obj) { obj.onclick=DeleteItem_click; }
	
	obj=document.getElementById("GroupDesc");
	if (obj) { obj.onchange=GroupDesc_Change; }

	iniForm();
}

function GroupDesc_Change()
{
	var obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
	var obj=document.getElementById("GroupDesc");
	if (obj) { obj.value=""; }

}

function iniForm() {
	var obj;
	var Standards='', StandardsDescList='';
	obj=document.getElementById('Standards')
	if (obj) { Standards=obj.value; }
	
	obj=document.getElementById('StandardsDescList')
	if (obj) { StandardsDescList=obj.value; }
	
	SetStandards(Standards,StandardsDescList);
}



function Clear_click() {
	var obj;
	
	obj=document.getElementById('StandardsList');
	if (obj) { obj.options.length=0; }
	
	obj=document.getElementById('Standards')
	if (obj) { obj.value=''; }
	
	obj=document.getElementById('StandardsDescList')
	if (obj) { obj.value=''; }	
	
	obj=document.getElementById("DateFrom");
	if (obj) { obj.value=''; }
	
	obj=document.getElementById("DateTo");
	if (obj) { obj.value=''; }

	obj=document.getElementById("QueryType");
	if (obj && obj.checked) { obj.checked=false; }

	obj=document.getElementById("GroupDesc");
	if (obj) { obj.value=""; }
	
    obj=document.getElementById("GroupID");
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("VIPLevel");
	if (obj) { obj.value=""; }


}
/*
function Find_click() {
	var obj;
	
	var iStandards='', iStandardsDescList='';
	var iDateFrom='';	
	var iDateTo='';
	var iQueryType='';
	
	iStandards=GetStandardsList();
	iStandardsDescList=GetStandardsDescList();
	
	obj=document.getElementById("DateFrom");
	if (obj && ""!=obj.value) { iDateFrom = obj.value; }
	
	obj=document.getElementById("DateTo");
	if (obj && ""!=obj.value) { iDateTo = obj.value; }

	obj=document.getElementById("QueryType");
	if (obj && obj.checked) { iQueryType = 'A'; }
	else { iQueryType = 'O'; }

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPosQuery.PersonList"
		+"&"+"Standards="+iStandards
		+"&"+"StandardsDescList="+iStandardsDescList
		+"&"+"DateFrom="+iDateFrom
		+"&"+"DateTo="+iDateTo
		+"&"+"QueryType="+iQueryType
		;
	location.href=lnk;
}*/
function Find_click() {
	var obj;
	
	var iStandards='', iStandardsDescList='';
	var iDateFrom='',iDateTo='',iQueryType='',iVIPLevel='',iGroupID='';
	
	iStandards=GetStandardsList();
	iStandardsDescList=GetStandardsDescList();
	
	obj=document.getElementById("DateFrom");
	if (obj && ""!=obj.value) { iDateFrom = obj.value; }
	
	obj=document.getElementById("DateTo");
	if (obj && ""!=obj.value) { iDateTo = obj.value; }
	
	obj=document.getElementById("QueryType");
	if (obj && obj.checked) { iQueryType = 'A'; }
	else { iQueryType = 'O'; }

	
	obj=document.getElementById("VIPLevel");
	if (obj && ""!=obj.value) { iVIPLevel = obj.value; }


	obj=document.getElementById("GroupID");
	if (obj && ""!=obj.value) { iGroupID = obj.value; }

	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEPosQuery.PersonList"
		+"&"+"Standards="+iStandards
		+"&"+"StandardsDescList="+iStandardsDescList
		+"&"+"DateFrom="+iDateFrom
		+"&"+"DateTo="+iDateTo
		+"&"+"QueryType="+iQueryType
		+"&"+"VIPLevel="+iVIPLevel
		+"&"+"GroupID="+iGroupID
		;
		//alert(lnk)
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
	obj=document.getElementById('StandardsList');
	if (obj && obj.selectedIndex!=-1) {
		selectedIndex=obj.selectedIndex;
		obj.options[obj.selectedIndex]=null;
		if (selectedIndex<obj.options.length) {
			obj.selectedIndex=selectedIndex;
		}else{ obj.selectedIndex=obj.options.length-1; }
	}
	
}

// 双击按钮删除选择项
function StandardsList_dblclick() {
	//var obj=document.getElementById('StandardsList');
	var obj=window.event.srcElement;
	if (obj && obj.selectedIndex!=-1) {
		obj.options[obj.selectedIndex]=null;
	}
}

function GetStandardsList() {
	var StandardsList='';
	var obj=document.getElementById('StandardsList');
	if (obj) {
		for (var iLoop=0;iLoop<obj.options.length;iLoop++) {				
			if (''!=obj.options[iLoop]) { StandardsList=StandardsList+obj.options[iLoop].value+'^'; }
		}
	}
	if (''!=StandardsList) { StandardsList='^'+StandardsList; }
	return StandardsList;

}

function GetStandardsDescList() {
	var StandardsDescList='';
	var obj=document.getElementById('StandardsList');
	if (obj) {
		for (var iLoop=0;iLoop<obj.options.length;iLoop++) {				
			if (''!=obj.options[iLoop].text) {StandardsDescList=StandardsDescList+obj.options[iLoop].text+'^'; }
		}
	}
	if (''!=StandardsDescList) { StandardsDescList='^'+StandardsDescList; }
	return StandardsDescList;

}

function SetStandards(StandardsList,StandardsDescList) {

		var Standards=StandardsList.split('^');
		var StandardsDescs=StandardsDescList.split('^');
		var obj=document.getElementById('StandardsList');
		if (obj) {
			obj.options.length=0;
			for (var iLoop=0;iLoop<Standards.length;iLoop++) {				
				if (''!=Standards[iLoop]) {				
					obj.options[obj.options.length]=new Option(StandardsDescs[iLoop],Standards[iLoop])
				}
			}
		}

}
function SelectGroup(value)
{
	if (value=="") return;
	var ValueArr=value.split("^");
	var obj=document.getElementById("GroupDesc");
	if (obj) obj.value=ValueArr[1];
	var obj=document.getElementById("GroupID");
	if (obj) obj.value=ValueArr[0];
}

function Export_click()
{
	var obj;
	var iStandards='';
	var iDateFrom='';	
	var iDateTo='';
	var iGroupID='';
	var iVIPLevel='';
	obj=document.getElementById("DateFrom");
	if (obj && ""!=obj.value) { iDateFrom = obj.value; }
	
	obj=document.getElementById("DateTo");
	if (obj && ""!=obj.value) { iDateTo = obj.value; }
	iStandards=GetStandardsList();
	
	obj=document.getElementById("GroupID");
	if (obj && ""!=obj.value) { iGroupID = obj.value; }
	
	obj=document.getElementById("VIPLevel");
	if (obj && ""!=obj.value) { iVIPLevel = obj.value; }
	
	
	var ret=tkMakeServerCall("web.DHCPE.Report.PosQuery","ExportItem",iDateFrom,iDateTo,iStandards,iGroupID,iVIPLevel);
	if (ret=="") {
		 alert("无数据!");
	     return false;
	     }
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEExportItemResult.xls';
	}else{
		alert("无效模板路径");
		return;
	}
	xlApp = new ActiveXObject("Excel.Application");
	xlBook = xlApp.Workbooks.Add(Templatefilepath);
	xlsheet = xlBook.WorkSheets("Sheet1");
	var retinfo=ret.split("^")
	
	for (var i=0;i<retinfo.length;i++)
	
	{
		
		var item=tkMakeServerCall("web.DHCPE.Report.PosQuery","ExportItemInfo",retinfo[i]);
		var iteminfo=item.split("^")
		for (var j=0;j<iteminfo.length;j++)
		{
			
			xlsheet.cells(i+2,j+1).Value=iteminfo[j];
			
			
		}
		
	}
	
	xlsheet.saveas("d:\\体征查询统计明细.xls")
	xlBook.Close (savechanges=false);
	xlApp=null;
	xlsheet=null;
	idTmr = window.setInterval("Cleanup();",1);
	alert("导出完成");
	
}
function   Cleanup()   { 
	window.clearInterval(idTmr);   
	CollectGarbage();
  
}

document.body.onload = BodyLoadHandler;