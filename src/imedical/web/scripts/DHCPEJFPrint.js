/// DHCPEInvRcptPayDetailPrint.js
/// 创建时间		2007.10.26
/// 创建人			xuwm
/// 主要功能		打印 体检收费员统计 数据导出到Excel文件
/// 对应表		
/// 最后修改时间
/// 最后修改人

var FExcel;

// 导出数据到文件
function InvRcptPayDetailPrint(aUserID, aBeginDate, aEndDate, aPayMode, aPayModeDesc) {
	//alert('InvRcptPayDetailPrint');
	var obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPInvRcptPayPrint.xls'; // 模板文件
	}else{
		alert("无效模板路径");
		return;
	}
	
	var objExcel= new DHCPEExcel(Templatefilepath,false);
	if (objExcel)
	{
		// 设置导出文件(另村文件名,标题)
		IPDFileChange(objExcel, aBeginDate, aEndDate, aPayModeDesc);
		
		// 导出数据
		ImportInvRcptPayDetail(objExcel, aUserID, aBeginDate, aEndDate, aPayMode, aPayModeDesc);
		
		var IsPreview=false;
		objExcel.SetPrintArea('$A$1:$H$'+(FRow-1)); //
		objExcel.Print(IsPreview); //不预览
		objExcel.Colse(false); // 不保存
	}

}
// 设置导出文件(另村文件名,标题)
function IPDFileChange(objExcel, aBeginDate, aEndDate, aPayModeDesc) {
		objExcel.GetSheet('报表');
		
		var iCol=1;
		var iRow=1;
		var headLine='体检'+aPayModeDesc+'报账表';
		objExcel.writeData(iRow, iCol, headLine);
		
		var iCol=2;
		var iRow=2;
		var headLine='查询日期 '+aBeginDate+' 至 '+aEndDate;
		objExcel.writeData(iRow, iCol, headLine);
		//objExcel.SaveTo(DataSaveFilePath);
}
// 导体检综合查询
var FRow=3; // 
function ImportInvRcptPayDetail(objExcel, aUserID, aBeginDate, aEndDate, aPayMode, aPayModeDec)
{
	// objExcel.GetSheet('报表');
	FExcel=objExcel;
	FRow=3;
	
	var Instring=aUserID+'^'+aBeginDate+'^'+aEndDate+'^'+aPayMode;
	var Ins=document.getElementById('InvRcptPayDetailBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	
	var value=cspRunServerMethod(encmeth,'InvRcptPayDetailToExcel', '', Instring);
	//alert("hhhh");
	//var value=cspRunServerMethod(encmeth,'', '', Instring);
	//alert("gggg");
	//alert(value);
	if (""==value) { return false; }

}

// 输出导体检综合查询数据到Excel文件,在 ImportPEPersonStatistic 中调用
function InvRcptPayDetailToExcel(Datas) {
	var DayData=null;
	var iRow=FRow,iCol=0;
	DayData=Datas.split("^");
	//alert("InvRcptPayDetailToExcel \n"+Datas+"\n"+DayData.length);
	for (var iDayLoop=0;iDayLoop<DayData.length;iDayLoop++) {
		iCol=iDayLoop;
		FExcel.writeData(iRow, iCol+1, DayData[iCol]);
	}
	FRow=FRow+1;
}



