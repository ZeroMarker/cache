/// DHCPEGOEFeeDetailPrint.js

/// 打印团体医嘱费用明细
var TFORM="tDHCPEPreGADM_Find"
var FExcel;
var CurrentSel=0;
var objExcel=new Object();
// 导出数据
function PrintGOEFeeDetail() {
	
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEGOEFeeDetailPrint.xls'; // 模版文件
	}else{
		alert("无效模板路径");
		return;
	}
	var Ins=document.getElementById('GOEFeeDetailBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var obj=document.getElementById("RowId");
    if(obj)  {var GDR=obj.value;} 
   var retvalue=cspRunServerMethod(encmeth,'','',GDR)	
	alert(retvalue)
	objExcel= new DHCPEExcel(Templatefilepath, true);
	if (objExcel)
	{
		// 设置导出文件(另村文件名,标题)
		POFDFileChange(objExcel);
		// 导体检综合查询
	
		ImportGOEFeeDetail(objExcel);
		//var IsPreview=false;
		 objExcel.xlApp.Visible = true;
		//objExcel.Print(IsPreview);
		var IsSave=false; // 
		//objExcel.Colse(IsSave);
		objExcel=null;
	
		//alert("费用打印完毕.");
	}

}

function POFDFileChange(objExcel) {
	
	var obj;
	var Title='';
	obj=document.getElementById('RowId_Name');
	if (obj) { 
	 Title=obj.value+'体检项目费用明细'; }
	var iCol=1;
	var iRow=2;
	objExcel.GetSheet('明细');
	objExcel.writeData( iRow,iCol, Title);
	//objExcel.SaveTo('d:\\'+Title+'.xls');

}

var FRow=3;
function ImportGOEFeeDetail(objExcel) {
	
	var obj;
	var GDR='';
	//obj=document.getElementById('ID');
	//if (obj) { GDR=obj.value; }
	var obj=document.getElementById("RowId");
    if(obj)  {var GDR=obj.value;} 
	FRow=3;
	objExcel.GetSheet('明细');
	FExcel=objExcel;
	var Instring=GDR;
	var Ins=document.getElementById('GOEFeeDetailBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var retvalue=cspRunServerMethod(encmeth,'GOEFeeDetailToExcel','',Instring)	
	alert(retvalue)
	if (""==retvalue) { return false; }
	
	FExcel.Merge('A'+FRow,'F'+FRow);
	var note=' ';
	FExcel.writeData(FRow, 1, note);
	FExcel=null;
}

// 
function GOEFeeDetailToExcel(Datas) {
	
	var DayDatas=Datas.split("^");
	var iCol=0,iRow=FRow;
	for (var iCol=1;iCol<=DayDatas.length;iCol++) {
		FExcel.writeData(iRow, iCol, DayDatas[iCol-1]);
	
	   objExcel.Borders(iRow,iCol,'LEFT^'+'TOP^'+'BOTTOM^'+'RIGHT^')
	    
       
	}
	
	FRow=FRow+1;
}

