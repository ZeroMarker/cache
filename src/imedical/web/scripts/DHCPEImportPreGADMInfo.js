/// DHCPEImportPreGADMInfo.js
/// 创建时间		2008.01.21
/// 创建人		xuwm
/// 主要功能		为厦门实现的功能:导出预约团体的详细数据
/// 备注			与宁波的需求有冲突:宁波的需求是当前功能的子集
/// 			人员导出部分与?体检月工作量统计?的名单部分类似
/// 对应表		
/// 最后修改时间
/// 最后修改人

var FExcel;
   
	var btnobj=document.getElementById("PrintGPerson");
	if (btnobj){ btnobj.onclick=PrintGPerson_Click; }
	
function PrintGPerson_Click() {

	var iRowId='', iName='';
	var obj;
	//团体编码
	obj=document.getElementById('RowId');
	if (obj) { iRowId=obj.value;  }
	if (""==iRowId) { return false; }
	
	//团体名称
	obj=document.getElementById('RowId_Name');
	if (obj) { iName=obj.value;  }
	if (""==iName) { return false; }

	ImportPreGADMInfo(iRowId,iName);
}	
	
// 导入每月客户详细数据
function ImportPreGADMInfo(ID,Name) {
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEImportPreGADMInfo.xls';// 月统计报表
	}else{ alert("无效模板路径"); }
	
	var objExcel= new DHCPEExcel(Templatefilepath);
	if (objExcel)
	{
		PGIFileChange(objExcel,ID,Name);
		PGIToExcel(objExcel,ID);
		alert("数据导出完成");
		objExcel.Colse(true);
		objExcel=null;
	}

}
// 处理模板文件,另存为,输出Title
function PGIFileChange(objExcel,ID,Name) {
		var today=new Date();
		var DataSaveFilePath='D:\\'+Name+'('+today.getTime()+').xls';
		objExcel.SaveTo(DataSaveFilePath);
}
var FRow=1;
// 获取数据
function PGIToExcel(objExcel,ID) {
	
	var Instring=ID;
	var Ins=document.getElementById('PreGADMInfoBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	
	FExcel=objExcel;
	FRow=2;
	objExcel.GetSheet("GroupInfo");
	var retvalue=cspRunServerMethod(encmeth,'PreGADMInfoToExcel','',Instring+'^1');
	if (""!=retvalue) { FExcel.SetSheet("GroupInfo",retvalue); }
	
	//FExcel=objExcel;
	FRow=1;
	objExcel.GetSheet("PersonList");
	var retvalue=cspRunServerMethod(encmeth,'PreGADMPersonListToExcel','',Instring+'^2');
	if (""!=retvalue) { FExcel.SetSheet("PersonList",retvalue); }

	
	//FExcel=objExcel;
	FRow=1;
	objExcel.GetSheet("FeeDetail");
	var retvalue=cspRunServerMethod(encmeth,'PreGADMFeeToExcel','',Instring+'^3');
	if (""!=retvalue) { FExcel.SetSheet("FeeDetail",retvalue); }
	
	FExcel=null;
}


// 导出团体统计数据到Excel文件
function PreGADMInfoToExcel(Datas) {
	//alert(' PreGADMInfoToExcel \n'+Datas);
	var objExcel=FExcel;

	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	//alert("StationDayStatisticToExcel\n"+Datas+"\n"+DayData.length);
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		objExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	objExcel.Borders(iRow,2,'BOTTOM^');
	FRow=FRow+1;
}

// 导出客户信息到Excel文件
function PreGADMPersonListToExcel(Datas) {
	//alert(' PreGADMPersonListToExcel \n'+Datas);
	var objExcel=FExcel;

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

// 导出客户费用信息到Excel文件
function PreGADMFeeToExcel(Datas) {
	var objExcel=FExcel;

	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	//alert("StationDayStatisticToExcel\n"+Datas+"\n"+DayData.length);
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		objExcel.writeData(iRow, iCol+1, DayData[iCol]);
		if (''!=DayData[1]) { objExcel.Borders(iRow,iCol+1,'TOP^'); }
	}
	
	FRow=FRow+1;
}