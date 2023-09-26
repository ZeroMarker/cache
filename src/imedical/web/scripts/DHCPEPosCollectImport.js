/// DHCPEPosCollectImport.js
/// 创建时间		2007.09.15
/// 创建人			xuwm
/// 主要功能		阳性体征汇总查询 数据导出到Excel文件
/// 对应表		
/// 最后修改时间
/// 最后修改人

var FExcel;

// 导体检综合查询数据
function PosCollectImport(DataSaveFilePath,Contion) {
	obj=document.getElementById("prnpath")
	if (obj && ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEPoscollect.xls'; // 体检综合查询数据
	}else{
		alert("无效模板路径");
		return;
	}

	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// 设置导出文件(另存文件名,标题)
		PCFileChange(objExcel, DataSaveFilePath);
		// 导体检综合查询
		ImportPosCollect(objExcel,Contion);

		objExcel.Colse(true);
		objExcel=null;
		alert("数据导出完成");
	}

}
// 设置导出文件(另存文件名,标题)
function PCFileChange(objExcel,DataSaveFilePath) {
	objExcel.SaveTo(DataSaveFilePath);
}

// 导体检综合查询
var FIndex=1; 
function ImportPosCollect(objExcel,Contion) {
  
	FExcel=objExcel;
	FIndex=1;
	var Instring=Contion;
	//objExcel.GetSheet('详细信息');
	//objExcel.GetSheet('体征统计');
	var Ins=document.getElementById('PosCollectBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var value=cspRunServerMethod(encmeth,'PosCollectToExcel','',Contion);
	if (""==value) { return false; }

}

// 输出汇总数据到Excel文件,在 ImportPosCollect 中调用
function PosCollectToExcel(Datas) {
	var objExcel=FExcel;
	/*
	objExcel.writeDataToRow(Datas, FIndex, 1);
	FIndex=FIndex+1;
	*/
	objExcel.writeDataToCol(Datas,FIndex,1);
	//objExcel.Borders(2, FIndex, 'LEFT^TOP^BOTTOM^RIGHT^');
	FIndex=FIndex+1;
	return true;
}