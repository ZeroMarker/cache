/// DHCPEPersonStatisticImport.js
/// 创建时间		2007.08.30
/// 创建人			xuwm
/// 主要功能		体检综合查询 数据导出到Excel文件
/// 对应表		
/// 最后修改时间
/// 最后修改人

var FExcel;

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

// 导出数据
function PersonStatisticImport(DataSaveFilePath) {

	var obj;
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPersonStatistic.xls'; // 模版文件
		
	}else{
		alert("无效模板路径");
		return;
	}
	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// 设置导出文件(另村文件名,标题)
		PSFileChange(objExcel,DataSaveFilePath);
		// 导体检综合查询
		ImportPEPersonStatistic(objExcel);
		objExcel.Colse(true);
		objExcel=null;
		alert("数据导出完成");
	}

}
// 设置导出文件(另村文件名,标题)
function PSFileChange(objExcel,DataSaveFilePath) {
		//var importMonth=ImportDate.substring(ImportDate.indexOf('-')+1,ImportDate.length);
		//var importYear=ImportDate.substring(0,ImportDate.indexOf('-'));
		objExcel.GetSheet('汇总');
		//var iCol=1;
		//var iRow=1;
		//objExcel.writeData(iRow, iCol, importMonth+"月份体检中心业务收入汇总");
		objExcel.SaveTo(DataSaveFilePath);
		
}
function EndDate(){
   var d,  s="";    // 声明变量。
   d = new Date();                                    
   s += d.getDate() + "/";                            
   s += (d.getMonth() + 1)+ "/"; 
   s += d.getYear()
             
   return(s);                               
}
// 导体检综合查询
var FRow=4; // 
function ImportPEPersonStatistic(objExcel) {
	objExcel.GetSheet("汇总");
	FExcel=objExcel;

	var iBeginDate=document.getElementById('PEBeginDate').value;
	var iEndDate=document.getElementById('PEEndDate').value;
    if (iEndDate=="")
	{ iEndDate=EndDate()}
   
   //var iEndDate=iEndDate.split("/")[2]+"-"+iEndDate.split("/")[1]+"-"+iEndDate.split("/")[0]; 
   //if (iBeginDate!="") {iBeginDate=iBeginDate.split("/")[2]+"-"+iBeginDate.split("/")[1]+"-"+iBeginDate.split("/")[0];}
   //if (iBeginDate=="") 
    //{iBeginDate=document.getElementById('PESystemStartDate').value;}
  
	FExcel.writeData(1, 2, iBeginDate);
	FExcel.writeData(2, 2, iEndDate);
	
	var Ins=document.getElementById('PEPersonStatisticBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'PEPersonStatisticToExcel','','');
	if (""==value) { return false; }
	FExcel=null;
}

// 输出导体检综合查询数据到Excel文件,在 ImportPEPersonStatistic 中调用
function PEPersonStatisticToExcel(Datas) {
	var DayData=null;	
	var iCol=0, iRow=FRow;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		FExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	FRow=FRow+1;
}


/*
// 导体检综合查询
var FRow=2; // 
function ImportPEPersonStatistic(objExcel) {
	FExcel=objExcel;
	var iRow=0;
	var Data='';
	var SelRowObj;
	var obj;
		
	obj=document.getElementById("TFORM");
	if (obj){ tForm=obj.value; }
	
	var objtbl=document.getElementById('t'+tForm);
	if (objtbl) { var rows=objtbl.rows.length; }
	//var lastrowindex=rows - 1;
	for (iRow=1;iRow<rows;iRow++) {
		Data='';
		
		// 登记号
		SelRowObj=document.getElementById('PA_RegNo'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}
		
		// 姓名
		SelRowObj=document.getElementById('PA_Name'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}
		
		// 登记日期
		SelRowObj=document.getElementById('PA_AdmDate'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// 状态
		SelRowObj=document.getElementById('PA_Status'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// 报告状态
		SelRowObj=document.getElementById('PA_ReportStatus'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// 应收金额
		SelRowObj=document.getElementById('PA_AccountAmount'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// 优惠金额
		SelRowObj=document.getElementById('PA_DiscountedAmount'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// 已收金额
		SelRowObj=document.getElementById('PA_Payed'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// 未收金额
		SelRowObj=document.getElementById('PA_UnPayed'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// 体检号
		SelRowObj=document.getElementById('PA_ADMNo'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// 单位
		SelRowObj=document.getElementById('PA_Company'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// 团体
		SelRowObj=document.getElementById('PA_GDesc'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}

		// 业务员
		SelRowObj=document.getElementById('PA_Saler'+'z'+iRow);
		if (SelRowObj) { Data=Data+trim(SelRowObj.innerText)+'^'; }
		else{ Data=Data+'^';}


		PEPersonStatisticToExcel(Data,iRow+1)
	}
	
}

// 输出导体检综合查询数据到Excel文件,在 ImportPEPersonStatistic 中调用
function PEPersonStatisticToExcel(Datas,iRow) {
	var objExcel=FExcel;
	objExcel.GetSheet("汇总");
	var DayData=null;
	var iCol=0;
	DayData=Datas.split("^");
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		objExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
}

*/
