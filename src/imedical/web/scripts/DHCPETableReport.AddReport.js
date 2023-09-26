/// DHCPETableReport.AddReport.js
/// 创建时间		2008.04.08
/// 创建人		xuwm
/// 主要功能		套打报告模板文件处理
/// 对应表		
/// 最后修改时间	
/// 最后修改人	
/// 完成

var CurrentSel=0
function BodyLoadHandler() {

	var obj;
	obj=document.getElementById("Update");
	if (obj){ obj.onclick=Update_click; }
	
	obj=document.getElementById("Delete");
	if (obj){ obj.onclick=Delete_click; }
	
	iniForm();


}

function iniForm(){

}

function trim(s) {
	if (""==s) { return ""; }
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}

//验证是否为浮点数
function IsFloat(Value) {
	
	var reg;
	
	if(""==trim(Value)) { 
		//容许为空
		return true; 
	}else { Value=Value.toString(); }
	
	reg=/^((-?|\+?)\d+)(\.\d+)?$/;
	if ("."==Value.charAt(0)) {
		Value="0"+Value;
	}
	
	var r=Value.match(reg);
	if (null==r) { return false; }
	else { return true; }
}

function Update_click() {
	
	var iReportName='',iTemplateFile='';
	var iRowStar='',iRowEnd='',iColStar='',iColEnd='';
	var obj;
	// 报告名称
	obj=document.getElementById('TemplateFile');
	if (obj){ iTemplateFile=obj.value; }
	
	// 报告名称
	obj=document.getElementById('ReportName');
	if (obj){ iReportName=obj.value; }
		
	// 
	obj=document.getElementById('DataRowStar');
	if (obj){ iRowStar=obj.value; }

	// 
	obj=document.getElementById('DataColStar');
	if (obj){ iColStar=obj.value; } 

	// 
	obj=document.getElementById('DataRowEnd');
	if (obj){ iLRowEnd=obj.value; } 

	// 
	obj=document.getElementById('DataColEnd');
	if (obj){ iColEnd=obj.value; }	

	HandelTemplateFile(iReportName,iTemplateFile,parseInt(iRowStar),parseInt(iColStar),parseInt(iLRowEnd),parseInt(iColEnd));
	
	alert('模板文件:'+iTemplateFile+" 处理完毕");
	
	//刷新页面
	//location.reload();
}

function Delete_click() {

}

var FMonthSheetName="";
var FExcel;

// 导入每月客户详细数据
function HandelTemplateFile(ReportName,Templatefilepath,RowStar,ColStar,RowEnd,ColEnd) {
	
	var objExcel= new DHCPEExcel(Templatefilepath, false);
	if (objExcel)
	{
		// 生成模板文件
		var NewTemplatefilepath=Templatefilepath.split('.xls')[0]+'_Template.xls';
		
		objExcel.SaveTo(NewTemplatefilepath);
		var objoutput=document.getElementById('output');
		if (objoutput) { objoutput.value=''; }
		objExcel.GetSheet("Sheet1");
		
		var strLine='';
		var value='';
		var iRow=1;
		for (iRow=RowStar; iRow<=RowEnd; iRow++) {
			var iCol=1;
			for (iCol=ColStar; iCol<=ColEnd; iCol++) {
				value=objExcel.ReadData(iRow,iCol);
				if (('undefined'!=typeof(value))&&(value.length>1)&&(value.indexOf('##')>-1)) {
					value=value.substring(2,value.length);
					strLine=strLine
							+ReportName				//	Report
							+'^'+'' //				//	RowId
							+'^'+'' //'-1||'		//	ODDR
							+'^'+value				//	Label
							+'^'+iRow+','+iCol		//	Coordinate
							+';'
							;
					objExcel.writeData(iRow,iCol,'');
					if (objoutput) { objoutput.value=objoutput.value+value+'\t\t:'+iRow+','+iCol+'\n'; }
					if (strLine.length>512) {
						SaveTemplate(strLine);
						strLine='';
					}
					
				}
				
			}
		}
		if (''!=strLine) {
			SaveTemplate(strLine);
		}
		
		objExcel.Colse(true);
		objExcel=null;	
	}

}

function SaveTemplate(Instring) {
	
	var Ins=document.getElementById('ClassBox');
	if (Ins) {var encmeth=Ins.value; } else {var encmeth=''; };
	var flag=cspRunServerMethod(encmeth,'','',Instring)

	if (flag.indexOf('错误')>-1) {
		alert(flag);
		return false;
	}
	return true;
}


document.body.onload = BodyLoadHandler;

