/// DHCPEDayListImport.js
/// 创建时间		2008.01.10
/// 创建人			xuwm
/// 主要功能		打印每日体检人员列表
/// 对应表		
/// 最后修改时间
/// 最后修改人

var FMonthSheetName="";
var FExcel;


// 导入每月客户详细数据
function PrintPEDayList(ImportDate) {
	//alert('PrintPEDayList');
	var obj;
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPEDayList.xls';// 月统计报表
	}else{
		alert("无效模板路径");
		return;
	}
	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// 设置导出文件(另村文件名,标题)
		PDLFileChange(objExcel, ImportDate);
		
		ImportPEDayList(objExcel, ImportDate);
		objExcel.Print(false);
		objExcel.Colse(false);
		objExcel=null;
		//alert("打印完成");
	}
}

// 设置导出文件(另村文件名,标题)
function PDLFileChange(objExcel, ImportDate) {
	var PEDate=ImportDate.split('/');
	objExcel.GetSheet('数据');
	var iCol=1;
	var iRow=1;
	var Title=PEDate[2]+'-'+PEDate[1]+'-'+PEDate[0]+objExcel.ReadData(iRow, iCol);
	objExcel.writeData(iRow, iCol, Title);
}

var FRow=3; //
function ImportPEDayList(objExcel, ImportDate) {
	FExcel=objExcel;
	objExcel.GetSheet('数据')
	FRow=3;
	var Instring=ImportDate;
	var Ins=document.getElementById('PEDayListBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'PEDayListToExcel','',Instring)	
	if (""==value) { return false; }
	objExcel.SetPrintArea("$A$1:$F$"+FRow);
}

function PEDayListToExcel(Datas) {
	//alert("StationDayStatisticToExcel\n"+Datas);
	var objExcel=FExcel;
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		objExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	FRow=FRow+1;
}


