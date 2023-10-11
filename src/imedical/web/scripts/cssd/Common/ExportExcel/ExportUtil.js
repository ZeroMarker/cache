(function(){
	var EXCEL_CONTENTTYPE = "application/vnd.ms-excel;",
		EXCEL_URI = 'data:application/vnd.ms-excel;base64,',
		EXCE_TEMPLATE = '<html><head><meta charset="UTF-8"></head><body>{html}</body></html>',
		__PREVFIX = "\uFEFF",
		ieVersion = window.navigator.userAgent.toLowerCase().match(/(msie\s|Trident.*rv:)([\w.]+)/),
		useIE = ieVersion && ieVersion[2] < 10,
		isIE1011 = ieVersion && ieVersion[2] > 9;
	//上面的ie版本判断有问题,目前仅判断ie11
	var isIE11 = ((a = navigator.userAgent) && /Trident/.test(a) && /rv:11/.test(a)) ? true : false;
	
	var Export = {
		/*
		 *@param datas Two-dimensional array : datas, export only with data
					   or String : DOM id, export html content
		 *@param fileName export file name
		 */
		toExcel: function(datas, datasArr, fName){

			var isId = typeof datas === 'string';
			if(isId || datas instanceof Array){
				if(useIE){
					Export.__ieExport(datas, fName);
				}else if(isIE11){
					//IE11下,使用XLSX存在内存不足的情况,只能使用老一点的方法
					datas = datasArr;
					//原方法ie下导出office打开报错,使用wps没有问题
					Export.__ieExport(datas, fName);
					//Export.__oTherExport(datas, fName);  //修改后缀为xls应该也可以使用
					
					//DownLoadExcelByXLSX(datas, fName);
				} else{
					//推荐使用XLSX插件功能
					DownLoadExcelByXLSX(datas, fName);
					
					//datas = datasArr;		//使用id时,容易出现白屏情况
					//Export.__oTherExport(datas, fName);
				}
			} else{
				alert("datas params need Two-dimensional array or String.");
			}
		},
		__ieExport : function(datas, fileName){
			var oXL = new ActiveXObject("Excel.Application"),
				oWB = oXL.Workbooks.Add(),
				oSheet = oWB.ActiveSheet,
				i = 0,
				j;
			oSheet.Columns.NumberFormatLocal = "@";

			if(typeof datas === 'string'){
				var elem = document.getElementById(datas);
				var sel = document.body.createTextRange();
				sel.moveToElementText(elem);
				try{
					sel.select();  //there ie10,11 will be error, i don't know why, but also can export 
				} catch(e){}
				sel.execCommand("Copy");
				oSheet.Paste();
			} else {
				for(; i < datas.length; i++){
					var row = datas[i];
					for (j = 0; j < row.length; j++) {
						oSheet.Cells(i + 1, j + 1).value = row[j];
					}
				}
			}
			oSheet.Columns.AutoFit;
			oXL.ActiveWindow.Zoom = 75;
			oXL.Visible = true;
			oWB.SaveAs(fileName);			
		},
		__oTherExport : function(datas, fileName){
			if(typeof datas === 'string'){
				var elem = document.getElementById(datas),
					content = EXCE_TEMPLATE.replace("{html}", elem.outerHTML);
				//TODO: need test large amount of data
				//此写法仅支持xls格式				 
				window.location.href = EXCEL_URI + window.btoa(unescape(encodeURIComponent(content)));
			} else {
				var blob,
					i = 0,
					j,
					str = __PREVFIX;
				for(; i < datas.length; i++){
					var row = datas[i];
					// the value add double quotation marks on both sides, for separate values. 
					str += "\""+ row.join("\",\"") + "\"\n";
				}
				//on safari:  TypeError: '[object BlobConstructor]' is not a constructor (evaluating 'new Blob([str],{
				//import Blob.js to fix, but still have a problem : the fileName will be 'Unknown' , but if you add suffix name, content can be seen.
				blob = new Blob([str],{
					type: EXCEL_CONTENTTYPE
				});
				saveAs(blob, fileName || "Download.xlsx");
			}
		}
	}

	window.ExportUtil = Export;
})();
/**
 * 使用XLSX.js生成Excel并下载
 * @param {} DomId
 * @param {} FileName
 */
function DownLoadExcelByXLSX(DomId, FileName) {
	var ExcelTable = document.querySelector(DomId);
	var ExcelSheet = XLSX.utils.table_to_sheet(ExcelTable,{raw:true});//将一个table对象转换成一个sheet对象
	var FileBlob = sheet2blob(ExcelSheet);
	if (window.navigator && window.navigator.msSaveOrOpenBlob) {
		// for IE
		window.navigator.msSaveOrOpenBlob(FileBlob, FileName);
	} else {
		// for Non-IE (chrome, firefox etc.)
		var a = document.createElement("a");
		document.body.appendChild(a);
		a.style = "display:none";
		var csvUrl = URL.createObjectURL(FileBlob);
		a.href = csvUrl;
		a.download = FileName;
		a.click();
		URL.revokeObjectURL(a.href);
		a.remove();
	}
}

// 将一个sheet转成最终的excel文件的blob对象，然后利用URL.createObjectURL下载
function sheet2blob(sheet, sheetName) {
	sheetName = sheetName || 'sheet1';
	var workbook = {
		SheetNames: [sheetName],
		Sheets: {}
	};
	workbook.Sheets[sheetName] = sheet; // 生成excel的配置项

	var wopts = {
		bookType: 'xlsx', // 要生成的文件类型
		bookSST: false, // 是否生成Shared String Table，官方解释是，如果开启生成速度会下降，但在低版本IOS设备上有更好的兼容性
		type: 'binary'
	};
	var wbout = XLSX.write(workbook, wopts);
	var blob = new Blob([s2ab(wbout)], {
		type: "application/octet-stream"
	});
	// 字符串转ArrayBuffer
	function s2ab(s) {
		var buf = new ArrayBuffer(s.length);
		var view = new Uint8Array(buf);
		for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
		return buf;
	}
	return blob;
}