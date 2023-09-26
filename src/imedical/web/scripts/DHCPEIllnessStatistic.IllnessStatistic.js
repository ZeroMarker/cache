/// DHCPEIllnessStatistic.IllnessStatistic.js

/// 创建时间		2006.09.06
/// 创建人			xuwm
/// 主要功能		疾病统计-人员列表
/// 对应表		
/// 最后修改时间
/// 最后修改人	

var CurrentSel=0;
var TFORM="tDHCPEIllnessStatistic_IllnessStatistic";
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
	
	obj=document.getElementById("RegNo");
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	obj=document.getElementById("PatName");
	if (obj) {obj.onkeydown=RegNo_keydown; }
	
	var obj=document.getElementById("BExport")
	if (obj) obj.onclick=BExport_click;

	iniForm();
}
function EndDate(){
   var s=""; 
 	var date = new Date(); 
    var y = date.getFullYear(); 
    var m = date.getMonth()+1; 
    var d = date.getDate(); 
    var dtformat=tkMakeServerCall("web.DHCPE.DHCPECommon","GetSYSDatefomat")
		if (dtformat=="YMD"){
			var s=y+"-"+m+"-"+d;
		}else if (dtformat=="DMY"){
			var s=d+"/"+m+"/"+y;
		} 
   return(s); 
}

function BExport_click()
{
	try{
		var User=session['LOGON.USERID']
		var RowsStr=tkMakeServerCall("web.DHCPE.Report.IllnessStatistic","GetIllnessRows",User);
		
		var Rows=RowsStr.split("^")[0];
		var TotalInfo=RowsStr.split("^")[1];
		if(Rows=="0"){
			alert("没有要导出的数据")
			return 
		}
		
		var obj,iBeginDate="",iEndDate="";
		obj=document.getElementById("DateFrom");
		if (obj){ iBeginDate=obj.value; }
		obj=document.getElementById("DateTo");
		if (obj){ iEndDate=obj.value; }
	 	if (iEndDate==""){ iEndDate=EndDate();}

		var prnpath=tkMakeServerCall("web.DHCPE.Report.MonthStatistic","getpath");
	    var Templatefilepath=prnpath+'DHCPEIllnessStatistic.xls';
	   
	    xlApp = new ActiveXObject("Excel.Application"); //固定
	    xlApp.UserControl = true;
        xlApp.visible = true; 
		xlBook = xlApp.Workbooks.Add(Templatefilepath); //固定
		xlsheet = xlBook.WorkSheets("Sheet1"); //Excel下标的名称
		
	
		xlsheet.cells(1,1)=iBeginDate+"--"+iEndDate+"疾病统计结果";
		
	
		for (var i=1;i<=Rows;i++){
			var Datas=tkMakeServerCall("web.DHCPE.Report.IllnessStatistic","GetIllnessData",User,i)

			var DayData=Datas.split("^");
			for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
				xlsheet.cells(i+3, iDayLoop+1)=DayData[iDayLoop];
			}

		} 
		xlsheet.cells(2,1)=TotalInfo;
		xlsheet.Range(xlsheet.Cells(4,1),xlsheet.Cells(parseInt(Rows)+3,6)).Borders.LineStyle=1; 
		xlBook.Close(savechanges = true);
		xlApp.Quit();
		xlApp = null;
		xlsheet = null;

   	}
	catch(e)
	{
		alert(e+"^"+e.message);
	}

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

	obj=document.getElementById("SexDR")
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("Sex")
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("AgeFrom")
	if (obj) { obj.value=""; }
	
	obj=document.getElementById("AgeTo")
	if (obj) { obj.value=""; }

	
}

function RegNo_keydown(e){
	
	var Key=websys_getKey(e);
	if ((13==Key)) {
		Find_click();
	}
}

function Find_click() {
	var obj;
	
	var iEDList='', iEDDescList='';
	var iPatName='',iRegNo='',iDateFrom='',iDateTo='',iQueryType='';iSex='',iAgeFrom='',iAgeTo='';
	
	iEDList=GetEDList();
	iEDDescList=GetEDDescList();
	obj=document.getElementById("PatName");
	if (obj && ""!=obj.value) { iPatName = obj.value; }

	var RegNoLength=tkMakeServerCall("web.DHCPE.DHCPECommon","GetRegNoLength");
	obj=document.getElementById("RegNo");
	if (obj){ 
		iRegNo=obj.value;
		if (iRegNo.length<RegNoLength && iRegNo.length>0) { iRegNo=RegNoMask(iRegNo);}
	}
	
	obj=document.getElementById("DateFrom");
	if (obj && ""!=obj.value) { iDateFrom = obj.value; }
	
	obj=document.getElementById("DateTo");
	if (obj && ""!=obj.value) { iDateTo = obj.value; }

	obj=document.getElementById("QueryType");
	if (obj && obj.checked) { iQueryType = 'on'; }
	else { iQueryType = ''; }
     
	obj=document.getElementById("SexDR");
	if (obj){ iSex=obj.value; }

	obj=document.getElementById("AgeFrom");
	if (obj && ""!=obj.value) { iAgeFrom = obj.value; }
	
	obj=document.getElementById("AgeTo");
	if (obj && ""!=obj.value) { iAgeTo = obj.value; }
	var lnk="websys.default.csp?WEBSYS.TCOMPONENT="+"DHCPEIllnessStatistic.IllnessStatistic"
		+"&"+"EDIDs="+iEDList
		+"&"+"EDDescList="+iEDDescList
		+"&"+"PatName="+iPatName
		+"&"+"RegNo="+iRegNo
		+"&"+"DateFrom="+iDateFrom
		+"&"+"DateTo="+iDateTo
		+"&"+"QueryType="+iQueryType
		+"&"+"AgeFrom="+iAgeFrom
		+"&"+"AgeTo="+iAgeTo
		+"&"+"SexDR="+iSex
		;
	
	location.href=lnk;
}

///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////

// 点击按钮删除选择项
// modified by wangfujian 2009-05-15
function DeleteItem_click() {
	var obj;
	obj=document.getElementById('EDList');

	var len=obj.options.length;
	
	var j=0;
	for (var i=0;i<len;i++)
	{	
	
		if (obj&&obj.options[j].selected) {
			
			obj.options[j]=null;
		}else{
			j++;
		}		
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
