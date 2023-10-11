(function(){
	var EXCEL_CONTENTTYPE = "application/vnd.ms-excel;",
		EXCEL_URI = 'data:application/vnd.ms-excel;base64,',
		EXCE_TEMPLATE = '<html><head><meta charset="UTF-8"></head><body>{html}</body></html>',
		__PREVFIX = "\uFEFF",
		ieVersion = window.navigator.userAgent.toLowerCase().match(/(msie\s|Trident.*rv:)([\w.]+)/),
		useIE = ieVersion && ieVersion[2] < 10,
		isIE1011 = ieVersion && ieVersion[2] > 9;
	//�����ie�汾�ж�������,Ŀǰ���ж�ie11
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
					//IE11��,ʹ��XLSX�����ڴ治������,ֻ��ʹ����һ��ķ���
					datas = datasArr;
					//ԭ����ie�µ���office�򿪱���,ʹ��wpsû������
					Export.__ieExport(datas, fName);
					//Export.__oTherExport(datas, fName);  //�޸ĺ�׺ΪxlsӦ��Ҳ����ʹ��
					
					//DownLoadExcelByXLSX(datas, fName);
				} else{
					//�Ƽ�ʹ��XLSX�������
					DownLoadExcelByXLSX(datas, fName);
					
					//datas = datasArr;		//ʹ��idʱ,���׳��ְ������
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
				//��д����֧��xls��ʽ				 
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
 * ʹ��XLSX.js����Excel������
 * @param {} DomId
 * @param {} FileName
 */
function DownLoadExcelByXLSX(DomId, FileName) {
	var ExcelTable = document.querySelector(DomId);
	var ExcelSheet = XLSX.utils.table_to_sheet(ExcelTable,{raw:true});//��һ��table����ת����һ��sheet����
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

// ��һ��sheetת�����յ�excel�ļ���blob����Ȼ������URL.createObjectURL����
function sheet2blob(sheet, sheetName) {
	sheetName = sheetName || 'sheet1';
	var workbook = {
		SheetNames: [sheetName],
		Sheets: {}
	};
	workbook.Sheets[sheetName] = sheet; // ����excel��������

	var wopts = {
		bookType: 'xlsx', // Ҫ���ɵ��ļ�����
		bookSST: false, // �Ƿ�����Shared String Table���ٷ������ǣ�������������ٶȻ��½������ڵͰ汾IOS�豸���и��õļ�����
		type: 'binary'
	};
	var wbout = XLSX.write(workbook, wopts);
	var blob = new Blob([s2ab(wbout)], {
		type: "application/octet-stream"
	});
	// �ַ���תArrayBuffer
	function s2ab(s) {
		var buf = new ArrayBuffer(s.length);
		var view = new Uint8Array(buf);
		for (var i = 0; i != s.length; ++i) view[i] = s.charCodeAt(i) & 0xFF;
		return buf;
	}
	return blob;
}