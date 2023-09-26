/// DHCPEIllnessCollectImport.js

///体检疾病汇总查询 数据导出到Excel文件

var FExcel;

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

// 导体检综合查询数据
function IllnessCollectImport(DataSaveFilePath) {
	//alert('IllnessCollectImport');
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEIllnessCollect.xls'; // 体检综合查询数据
	}else{
		alert("无效模板路径");
		return;
	}
	
	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// 设置导出文件(另村文件名,标题)
		ISFileChange(objExcel,DataSaveFilePath);
		
		// 导体检综合查询
		ImportIllnessCollect(objExcel);
		objExcel.Colse(true);
		objExcel=null;
		alert("数据导出完成");

	}

}
// 设置导出文件(另村文件名,标题)
function ISFileChange(objExcel,DataSaveFilePath) {
		//var importMonth=ImportDate.substring(ImportDate.indexOf('-')+1,ImportDate.length);
		//var importYear=ImportDate.substring(0,ImportDate.indexOf('-'));
		//objExcel.GetSheet('汇总');
		//var iCol=1;
		//var iRow=1;
		//objExcel.writeData(iRow, iCol, importMonth+"月份体检中心业务收入汇总");
		objExcel.SaveTo(DataSaveFilePath);
}

// 导体检综合查询
var FRow=2; // 
var OldSheetName='';
function ImportIllnessCollect(objExcel) {
	//alert(ImportIllnessCollect);
	FExcel=objExcel;
	FRow=2;
	var Instring='';
	OldSheetName='';
	var obj=document.getElementById('DSJ');
	if (obj) { Instring=obj.value; }
	var Ins=document.getElementById('IllnessCollectBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'IllnessCollectToExcel','','0')	
	if (""==value) { return false; }
	OldSheetName='';
}

// 输出导体检综合查询数据到Excel文件,在 ImportPEPersonStatistic 中调用
function IllnessCollectToExcel(SheetName,Datas) {
	//alert(SheetName+'\n'+Datas);
	//return ;
	var objExcel=FExcel;
	if (OldSheetName!=SheetName) 
	{
		objExcel.GetSheet(SheetName);
		OldSheetName=SheetName;
	}
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	//alert("StationDayStatisticToExcel\n"+Datas+"\n"+DayData.length);
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		objExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	FRow=FRow+1;
}


