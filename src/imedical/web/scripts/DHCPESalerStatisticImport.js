/// DHCPESalerStatisticImport.js
/// 创建时间		2007.08.03
/// 创建人			xuwm
/// 主要功能		业务员业务汇总
/// 对应表		
/// 最后修改时间
/// 最后修改人

var FMonthSheetName="";
var FExcel;


// 导入每月客户详细数据
function SalerStatisticImport(ImportDate,DataSaveFilePath) {
	//alert('MonthStatisticImport');
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPESalerStatistic.xls';// 月统计报表
	}else{
		alert("无效模板路径");
		return;
	}
	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// 设置导出文件(另村文件名,标题)
		SSFileChange(objExcel,ImportDate,DataSaveFilePath);
		
		// 业务员业务汇总
		ImportSalerStatistic(objExcel, ImportDate);
		objExcel.Colse(true);
		objExcel=null;
		alert("数据导出完成");		
	}

}
// 设置导出文件(另村文件名,标题)
function SSFileChange(objExcel,ImportDate,DataSaveFilePath) {
		var importMonth=ImportDate.substring(ImportDate.indexOf('-')+1,ImportDate.length);
		var importYear=ImportDate.substring(0,ImportDate.indexOf('-'));
		objExcel.GetSheet('汇总');
		var iCol=1;
		var iRow=1;
		objExcel.writeData(iRow, iCol, importMonth+"月份体检中心业务收入汇总");
		objExcel.SaveTo(DataSaveFilePath);
}
// 科室每天统计数据导出
var FRow=1; // 
function ImportSalerStatistic(objExcel, ImportDate) {
	FExcel=objExcel;
	FRow=3;
	var Instring=ImportDate;
	var Ins=document.getElementById('SalerStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'SalerStatisticToExcel','',Instring)
    if (value=="请输入正确的日期")	{
		alert("请输入正确的日期");
		return false; 
	}
	if (""==value) { return false; }
}

// 输出科室每天统计数据到Excel文件,在ImportStationDayStatistic中调用
function SalerStatisticToExcel(Datas) {
	//alert("StationDayStatisticToExcel\n"+Datas);
	var objExcel=FExcel;
	objExcel.GetSheet("汇总");
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


