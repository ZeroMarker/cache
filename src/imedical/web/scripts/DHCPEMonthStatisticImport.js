/// DHCPEMonthStatisticImport.js
/// 创建时间		2007.07.13
/// 创建人			xuwm
/// 主要功能		实现导出月报表的功能
/// 对应表			需要 DHCPEExcelPublic.js 文件实现EXCEL操作
/// 最后修改时间
/// 最后修改人

var FMonthSheetName="";
var FExcel;

// 导入每月客户详细数据
function MonthStatisticImport(ImportDate,DataSaveFilePath) {
	
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEMonthStatistic.xls';// 月统计报表
	}else{
		alert("无效模板路径");
		return;
	}
	
	var objExcel= new DHCPEExcel(Templatefilepath, false);

	if (objExcel)
	{
         
		// 设置导出文件(另存为文件名,标题)
		MSFileChange(objExcel,ImportDate,DataSaveFilePath);
	
		
		// 月工作量(及每天体检人员情况)导出
		MonthStatisticDataToExcel(objExcel, ImportDate, FMonthSheetName);
	
		
		// 科室月工作量导出
		StationStatisticToExcel(objExcel, ImportDate);
		
		
		// 科室每天(按月)工作量导出
		ImportStationDayStatistic(objExcel, ImportDate);
		
		// 医生每天(按月)工作量导出
		ImportDayDoctorStatistic(objExcel, ImportDate);
		
		// 体检项目每天(按月)工作量导出
		ImportDayOEItemStatistic(objExcel, ImportDate);
		objExcel.Colse(true);
		objExcel=null;
		alert("数据导出完成");
		
		
	}

}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

// 设置导出文件(另存文件名,标题)
function MSFileChange(objExcel,ImportDate,DataSaveFilePath) {
		//alert('ImportDate'+ImportDate+"  DataSaveFilePath"+DataSaveFilePath);
		var ImportDateArr=ImportDate.split("^");
		var ImportDateStr=ImportDateArr[0];
		var importMonth=ImportDateStr.substring(ImportDateStr.indexOf('-')+1,ImportDateStr.length);
		var importYear=ImportDateStr.substring(0,ImportDateStr.indexOf('-'));
		objExcel.GetSheet('月份人数统计');
		objExcel.SetSheet('月份人数统计',importMonth+'月份人数统计');
		objExcel.GetSheet(importMonth+'月份人数统计');
		FMonthSheetName=importMonth+'月份人数统计';
		var iCol=1;
		var iRow=1;
		
		objExcel.writeData(iRow, iCol, importMonth+objExcel.ReadData(iCol, iRow));
		objExcel.SaveTo(DataSaveFilePath);
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////


// 导出月统计数据(每天的工作量?科室工作量)到Excel文件
var FRow=5; // 从第五行开始导入数据
function MonthStatisticDataToExcel(objExcel, ImportDate) {
	//alert('MonthStatisticDataToExcel'+ImportDate);
	
	FExcel=objExcel;
	var Instring=ImportDate;
	FRow=5;
	var Ins=document.getElementById('MonthStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	//										每天体检人员信息导出
	var retvalue=cspRunServerMethod(encmeth,'MonthPEIADMToExcel','',Instring)	
	if (""==retvalue) { return false; }
	else{
		var ListTitle=ImportDate+"月名单";
		objExcel.GetSheet("名单");
		objExcel.writeData(1, 1, ListTitle);
	}
	
	/*
	var  retvalue='1^2007/04/1^45;'
				+'2^2007/04/2^51;'
				+'7^2007/04/7^12;'
				+'10^2007/04/10^45;'
				+'13^2007/04/13^32;'
				+'15^2007/04/15^21;'
				+'16^2007/04/16^52;'
				+'23^2007/04/23^101;'
				+'29^2007/04/29^85;'
				+'30^2007/04/30^96;'
	*/
	
	// 每天的工作量
	objExcel.GetSheet(FMonthSheetName);
	var DayDatas=retvalue.split(";")
	var DayData=null;
	var Num,mDay,mAumont;
	var iCol,iRow;
	var ColCount=16; // 数据行数
	for (var iDayLoop=0;iDayLoop<DayDatas.length-1;iDayLoop++) {
		
		DayData=DayDatas[iDayLoop].split("^");
		
		Num=parseInt(DayData[0],10);		
		iRow=((Num-1) % ColCount)+5;
		iCol=(parseInt((Num-1) / ColCount))*2+1;
		mDay=DayData[1];		
		objExcel.writeData(iRow, iCol, mDay);
		mAumont=parseFloat(DayData[2]);
		//objExcel.writeData(iRow, iCol+1, Num+"("+iRow+","+iCol+')-('+(Num % ColCount)+','+parseInt(Num / ColCount)+')---'+DayDatas[iDayLoop]);
		objExcel.writeData(iRow, iCol+1, mAumont);
	}
	
}

// 导出每天体检人员信息,由MonthStatisticDataToExcel调用
function MonthPEIADMToExcel(Datas) {
	//alert("MonthPEIADMToExcel\n"+Datas);
	var objExcel=FExcel;
	var DayDatas=Datas.split(";");
	//alert("MonthPEIADMToExcel GetSheet");
	objExcel.GetSheet("名单");
	
	var DayData=null;
	var Num,mDay,mAumont;
	var iCol,iRow=FRow;
	//alert("MonthPEIADMToExcel for");
	for (var iDayLoop=0;iDayLoop<DayDatas.length-1;iDayLoop++) {

		DayData=DayDatas[iDayLoop].split("^");
		objExcel.writeData(iRow, 1, DayData[0]); // 日期
		objExcel.writeData(iRow, 2, DayData[1]); // 业务员
		objExcel.writeData(iRow, 3, DayData[2]); // 套餐
		objExcel.writeData(iRow, 4, DayData[3]); // 价格
		objExcel.writeData(iRow, 5, DayData[4]); // 姓名
		objExcel.writeData(iRow, 6, DayData[5]); // 单位
		objExcel.writeData(iRow, 7, DayData[6]); // 电话
		objExcel.writeData(iRow, 8, DayData[7]); // 收费情况-金额
		objExcel.writeData(iRow, 9, DayData[8]); // 收费情况-款到日期
		objExcel.writeData(iRow, 10, DayData[9]); // 加项项目
		objExcel.writeData(iRow, 11, DayData[10]); // 加项收费
		objExcel.writeData(iRow, 12, DayData[11]); // 折扣
		objExcel.writeData(iRow, 13, DayData[12]); // 备注
		
		iRow=iRow+1;
	}
	FRow=iRow;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

// 导出每月科室统计数据到Excel文件
function StationStatisticToExcel(objExcel,ImportDate) {
	
	var Instring=ImportDate;
	var Ins=document.getElementById('StationStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'','',Instring)	
	objExcel.GetSheet(FMonthSheetName);
	var DayDatas=value.split(";")
	var iCol=1,iRow=1;
	for (var iDayLoop=0;iDayLoop<DayDatas.length-1;iDayLoop++) {
		iRow=iDayLoop+21;
		mDay=1;
		objExcel.writeData(iRow, iCol, DayDatas[iDayLoop]);
	}
}


/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////


// 科室每天统计数据导--------科室计数
var FRow=1; // 
function ImportStationDayStatistic(objExcel, ImportDate) {
	//alert('ImportStationDayStatistic'+ImportDate)
	FExcel=objExcel;
	FRow=1;
	var Instring=ImportDate;
	var Ins=document.getElementById('StationDayStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'StationDayStatisticToExcel','',Instring)	
	//alert("value:"+value)
	if (""==value) { return false; }
}

// 输出科室每天统计数据到Excel文件,在 ImportStationDayStatistic 中调用
function StationDayStatisticToExcel(Datas) {
	//alert("StationDayStatisticToExcel\n"+Datas);
	var objExcel=FExcel;
	objExcel.GetSheet("科室计数");
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		if (DayData[iCol]&&''!=DayData[iCol]) { objExcel.writeData(iRow, iCol+1, DayData[iCol]); }
	}
	FRow=FRow+1;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
var FCol=1;
// 医生每天统计数据导--------医生计数
function ImportDayDoctorStatistic(objExcel, ImportDate) {
	//alert('ImportStationDayStatistic'+ImportDate)
	FExcel=objExcel;
	FCol=1;
	var Instring=ImportDate;
	var Ins=document.getElementById('DayDoctorWorkStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'DayDoctorStatisticToExcel','',Instring)	
	if (""==value) { return false; }
}
// 输出医生每天的工作量统计数据到Excel文件在 ImportDayDoctorStatistic 中调用
function DayDoctorStatisticToExcel(Datas) {
	//alert("DayDoctorStatisticToExcel \n"+Datas);
	var objExcel=FExcel;
	objExcel.GetSheet("医生计数");
	var DayData=null;
	var iRow=0,iCol=FCol;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iRow=iDayLoop;
		if (DayData[iRow]&&''!=DayData[iRow]) { objExcel.writeData(iRow+1, iCol, DayData[iRow]); }
		
	}
	FCol=FCol+1;
}

/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////

function ImportDayOEItemStatistic(objExcel, ImportDate) {
	//alert('ImportStationDayStatistic'+ImportDate)
	FExcel=objExcel;
	FRow=1;
	var Instring=ImportDate;
	var Ins=document.getElementById('DayOEItemWorkStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'DayOEItemStatisticToExcel','',Instring)	
	if (""==value) { return false; }
}


// 输出医生每天的工作量统计数据到Excel文件在 ImportDayOEItemStatistic 中调用
function DayOEItemStatisticToExcel(Datas) {
	//alert("StationDayStatisticToExcel\n"+Datas);
	var objExcel=FExcel;
	objExcel.GetSheet("项目计数");
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		if (DayData[iCol]&&''!=DayData[iCol]) { objExcel.writeData(iRow, iCol+1, DayData[iCol]); }
	
	}
	FRow=FRow+1;
}




