/// DHCPEGCashierDetailPrint.js
/// 创建时间		2007.12.10
/// 创建人			xuwm
/// 主要功能		打印团体费用明细
/// 对应表		
/// 最后修改时间
/// 最后修改人

var FExcel;

// 导出数据
function PrintGCashierDetail() {
	
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGCashierDetailPrint.xls'; // 模版文件
	}else{
		alert("无效模板路径");
		return;
	}

	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// 设置导出文件(另村文件名,标题)
		PGDFileChange(objExcel);

		// 导体检综合查询
		ImportGCashierDetail(objExcel);
		var IsPreview=false;
		
		objExcel.Print(IsPreview);
		var IsSave=false;
		
		objExcel.Colse(IsSave);
		objExcel=null;
		alert("费用打印完毕.");
	}

}

function PGDFileChange(objExcel) {
		var obj;
		var Title='';
		obj=document.getElementById('Desc');
		if (obj) { Title=obj.value+'费用明细'; }

		var iCol=1;
		var iRow=1;
		objExcel.writeData(iCol, iRow, Title);
}

// 
var FRow=3;
function ImportGCashierDetail(objExcel) {
	//alert('ImportGCashierDetail');
	
	var obj;
	var GDR='';
	obj=document.getElementById('ID');
	if (obj) { GDR=obj.value; }
	FRow=3;
	objExcel.GetSheet('GCashierDetail');
	FExcel=objExcel;
	var Instring=GDR;
	var Ins=document.getElementById('GCashierDetailBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var retvalue=cspRunServerMethod(encmeth,'GCashierDetailToExcel','',Instring)	
	if (""==retvalue) { return false; }
	//FExcel=null;
}

// 
function GCashierDetailToExcel(Datas) {
	//alert(Datas);
	var DayDatas=Datas.split("^");
	
	var iCol=0,iRow=FRow;
	for (var iCol=1;iCol<=DayDatas.length;iCol++) {
		FExcel.writeData(iRow, iCol, DayDatas[iCol-1]);
		if (""!=DayDatas[0]) { FExcel.Borders(iRow,iCol,'TOP^'); }
	}
	
	FRow=FRow+1;
}