/// 
//名称	DHCPEStationIncomeStatistic.js
//功能	科室收入统计
//组件	
//对象	
//创建	2008.01.07
//最后修改时间	
//最后修改人	
//完成
//

var TFORM="";
function BodyLoadHandler() {
	var obj;

	obj=document.getElementById("LocDesc");
	if (obj) {
		obj.onchange=LocDesc_change;
		obj.onblur=LocDesc_blur;
	}
	
	obj=document.getElementById("OEItemDesc");
	if (obj) {
		obj.onchange=OEItemDesc_change;
		obj.onblur=OEItemDesc_blur;
	}
	
	obj=document.getElementById("Group");
	if (obj) {
		obj.onchange=Group_change;
	}
	
	//导出
	obj=document.getElementById("BExport") 
	if (obj) { obj.onclick=BExport_click; } 

	iniForm();
}

function iniForm(){
	var obj
	return;
	obj=document.getElementById("DateBegin");
	if (obj){
		obj.value='t';
		DateBegin_lookupSelect();
	}
	
	obj=document.getElementById("DateEnd");
	if (obj){
		obj.value='t';
		DateEnd_lookuphandler();
	}
}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];

}

// ////////////////////////////////////////////////////////////////////////////

function LocDesc_blur() {
		return;
		var obj;
		//obj=document.getElementById('LocDesc_change');
		//if (obj && ""==obj.value) {
			obj=document.getElementById('LocDR');
			if (obj) { obj.value=""; }
		//}
		//else { return false; }
}

function LocDesc_change() {

	var obj;

	obj=document.getElementById('LocDR');
	if (obj) { obj.value="";}
}

function GetLoc(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("LocDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("LocDR");
	if (obj) { obj.value=aiList[2]; }
}

// ////////////////////////////////////////////////////////////////////////////

function OEItemDesc_blur() {
	return
	var obj;
	obj=document.getElementById('OEItemDesc');
	if (obj && ""==obj.value) {
		obj=document.getElementById('OEItemDR');
		if (obj) { obj.value=""; }
	}
	else { return false; }
}

function OEItemDesc_change() {
		var obj;
		obj=document.getElementById('OEItemDR');
		if (obj) { obj.value=""; }
}

function GetOEItem(value){
	var aiList=value.split("^");
	if (""==value){return false;}

	obj=document.getElementById("OEItemDesc");
	if (obj) { obj.value=aiList[1]; }
	
	obj=document.getElementById("OEItemDR");
	if (obj) { obj.value=aiList[2]; }
}

// ////////////////////////////////////////////////////////////////////////////

function Group_change() {
	var obj;
	obj=document.getElementById('GroupDR');
	if (obj) { obj.value="";}
}

function GetGroupID(value){
	if ("^^"==value) { return false; }
	var aiList=value.split("^");
	
    obj=document.getElementById("GroupDR");
	if (obj) { obj.value=aiList[2]; }
	
	obj=document.getElementById("Group");
	if (obj) { obj.value=aiList[0]; }
}

function BExport_click()
{ 
    try{
	    
		var obj;
		var User=session['LOGON.USERID']
		obj=document.getElementById("Prnpath");
		if (obj && ""!=obj.value) {
			var prnpath=obj.value;
			var Templatefilepath=prnpath+'DHCPEStationIncomeStatistic.xls';
		}else{
			alert("无效模板路径");
			return;
		}
		xlApp = new ActiveXObject("Excel.Application"); 
		xlApp.UserControl = true;
       	xlApp.visible = true; //显示 
		xlBook = xlApp.Workbooks.Add(Templatefilepath); 
		xlsheet = xlBook.WorkSheets("Sheet1"); 

		
		 var Num=tkMakeServerCall("web.DHCPE.Report.StationIncomeStatistic","GetStationIncomeStatisticRows",User)
	
		var k=2;
		for (j=1;j<=Num;j++)
		{ 
			    
		    	var DataStr=tkMakeServerCall("web.DHCPE.Report.StationIncomeStatistic","GetStationIncomeStatisticRowsInfo",User,j)
		     	var Data=DataStr.split("^")
		     	xlsheet.cells(k+j,1)=Data[0]
		     	xlsheet.cells(k+j,2)=Data[1] 
				xlsheet.cells(k+j,3)=Data[2] 
				xlsheet.cells(k+j,4)=Data[3]
		     	xlsheet.cells(k+j,5)=Data[4] 
				xlsheet.cells(k+j,6)=Data[5]
				xlsheet.cells(k+j,7)=Data[6] 
			xlsheet.Range( xlsheet.Cells(k+j,1),xlsheet.Cells(k+j,7)).Borders.LineStyle = 1
			   
		} 
	
  
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

document.body.onload = BodyLoadHandler;