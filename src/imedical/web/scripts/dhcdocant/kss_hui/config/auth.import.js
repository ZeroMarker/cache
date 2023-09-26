/**
 * auth.import.js - KJ Import 
 * 
 * Copyright (c) 2019-2090 QiuPeng. All rights reserved.
 * 
 * CREATED BY QP 2019-11-27
 * 
 */
$(function(){
	$("#file").filebox({
		onChange: function (newVal,oldVal) {
			var isCheck = checkFile ();
			if (!isCheck) {
				return false;
			}
			var f = $("#file").filebox("files")[0];
			readWorkbookFromLocalFile(f, function(workbook) {
				readWorkbook(workbook);
			});
		}
	})
	$("#import").click(function () {
		var isCheck = checkFile ();
		if (!isCheck) {
			return false;
		}
		var f = $("#file").filebox("files")[0];
		readWorkbookFromLocalFile(f, function(workbook) {
			storageDocAuth(workbook);
		});
	})
})

function checkFile () {
	var files = $("#file").filebox("files");
	var options = $("#file").filebox("options");
	if (files.length == 0) {
		$.messager.alert("提示", "请选择模版!", 'info');
		return false;
	}
	var f = files[0];
	if(!/\.xlsx$/g.test(f.name)) {
		$.messager.alert("提示", "仅支持读取xlsx格式!", 'info');
		return false;
	}
	return true;
}

function readWorkbookFromLocalFile(file, callback) {
	var reader = new FileReader();
	if (reader.readAsBinaryString) {
		reader.onload = function(e) {
			var data = e.target.result;
			var workbook = XLSX.read(data, {type: 'binary'});
			if(callback) callback(workbook);
		};
		reader.readAsBinaryString(file);
	} else {
		reader.onload = function(e) {
			var data = e.target.result;
			var workbook = XLSX.read(data, {type: 'array'});
			if(callback) callback(workbook);
		};
		reader.readAsArrayBuffer(file);
	}
}


function readWorkbook(workbook) {
	var sheetNames = workbook.SheetNames;
	var worksheet = workbook.Sheets[sheetNames[0]];
	var csv = XLSX.utils.sheet_to_csv(worksheet);
	document.getElementById('result').innerHTML = csv2table(csv);
}

function csv2table(csv) {
	var html = '<table>';
	var rows = csv.split('\n');
	rows.pop();
	rows.forEach(function(row, idx) {
		var columns = row.split(',');
		columns.unshift(idx+1);
		if(idx == 0) {
			html += '<tr>';
			for(var i=0; i<columns.length; i++) {
				html += '<th>' + (i==0?'':String.fromCharCode(65+i-1)) + '</th>';
			}
			html += '</tr>';
		}
		html += '<tr>';
		columns.forEach(function(column) {
			html += '<td>'+column+'</td>';
		});
		html += '</tr>';
	});
	html += '</table>';
	return html;
}

function storageDocAuth2(workbook) {
	var sheetNames = workbook.SheetNames;
	var worksheet = workbook.Sheets[sheetNames[0]];
	var csv = XLSX.utils.sheet_to_csv(worksheet);
	var errMsg = "";
	
	var rows = csv.split('\n');
	rows.pop();
	
	for (var i=0; i< rows.length; i++) {
		if(i == 0) continue;
		var columns = rows[i].split(",");
		var excelStr = columns.join("^")
		var responseText = $.m({
			ClassName: "DHCAnt.KSS.Config.Authority",
			MethodName: "ImportExcel",
			excelStr: excelStr
		},false);
		
		if (responseText != 1) {
			errMsg = '导入失败！失败原因为：<font style="color:red">'+ responseText+"</font>" ;
			break;
		}
	}
	if (errMsg == "") {
		$.messager.alert('提示',"导入成功！", "info",function () {
			parent.reloadAuthGrid();
		});
	} else {
		$.messager.alert('提示',errMsg, "error",function () {
			parent.reloadAuthGrid();
		});
	}
	
	return true;
	
}

function storageDocAuth(workbook) {
	$.messager.progress({
		title: "提示",
		msg: '正在导入数据',
		text: '导入中....'
	});
	var sheetNames = workbook.SheetNames;
	var worksheet = workbook.Sheets[sheetNames[0]];
	var csv = XLSX.utils.sheet_to_csv(worksheet);
	var errMsg = "",excelStr="";
	
	var rows = csv.split('\n');
	rows.pop();
	var totalNum = rows.length;
	
	for (var i=0; i< rows.length; i++) {
		if(i == 0) continue;
		var columns = rows[i].split(",");
		var inStr = columns.join("^")
		if (excelStr == "") excelStr = inStr;
		else  excelStr = excelStr + "!" + inStr;
	}
	var start = new Date().getTime();
	$cm({
		ClassName:"DHCAnt.KSS.Config.Authority",
		MethodName:"ImportTotalExcel",
		excelStr:excelStr,
		dataType:"text"
	},function(responseText){
		setTimeout(function () {
			$.messager.progress("close");
			var end = new Date().getTime();
			var time = (end - start)/1000;
			if (responseText == 1) {
				var successMsg = '导入成功，共导入<i style="color: blue;font-size:1.5em;">&nbsp;' + (totalNum-1) + '</i>&nbsp;&nbsp;条记录，共耗时<i style="color: blue;font-size:1.5em;">&nbsp;' + time + '</i>&nbsp;&nbsp;秒！'; 
				$.messager.alert('提示', successMsg, "success",function () {
					parent.reloadAuthGrid();
				});
			} else {
				var errMsg = '导入失败！失败原因为：<font style="color:red">'+ responseText+"</font>" ;
				$.messager.alert('提示',errMsg, "error",function () {
					parent.reloadAuthGrid();
				});
			}
		},50)
		
	})
	
	return true;
	
}
