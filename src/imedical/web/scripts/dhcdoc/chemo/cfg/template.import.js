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
	$("#importNote").click(function () {
		var isCheck = checkFile ();
		if (!isCheck) {
			return false;
		}
		var f = $("#file").filebox("files")[0];
		readWorkbookFromLocalFile(f, function(workbook) {
			storagePlanNote(workbook);
		});
	})
	$("#clean").click(function () {
		$("#file").filebox("reset");
		$("#result").html("");
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
		console.log(excelStr)
		/*var responseText = $.m({
			ClassName: "DHCAnt.KSS.Config.Authority",
			MethodName: "ImportExcel",
			excelStr: excelStr
		},false);
		
		if (responseText != 1) {
			errMsg = '导入失败！失败原因为：<font style="color:red">'+ responseText+"</font>" ;
			break;
		}*/
	}
	if (errMsg == "") {
		$.messager.alert('提示',"导入成功！", "info",function () {
			//parent.reloadAuthGrid();
		});
	} else {
		$.messager.alert('提示',errMsg, "error",function () {
			//parent.reloadAuthGrid();
		});
	}
	
	return true;
	
}



function storageDocAuth(workbook) {
	var sheetNames = workbook.SheetNames;
	if (sheetNames[0]!="化疗方案模板") {
		$.messager.alert('提示', "您所选择的导入模板不匹配，请检查！", "info");
		return false;
	}
	$.messager.progress({
		title: "提示",
		msg: '正在导入数据',
		text: '导入中....'
	});
	var worksheet = workbook.Sheets[sheetNames[0]];
	var csv = XLSX.utils.sheet_to_csv(worksheet);
	var errMsg = "",excelStr="";
	var rows = csv.split('\n');
	rows.pop();
	var totalNum = rows.length;
	//debug(rows.length,"rows.length")
	var PList = [],PlistNew = [];
	var num=0,tempArr=[]
	for (var i=2; i< rows.length; i++) {
		//if(i == 0) continue;
		//debug(i,"i")
		debug(rows[i],"rows[i]")
		var columns = rows[i].split(",");
		var inStr = columns.join(String.fromCharCode(1))
		debug(columns,"columns")
		if (i==2) {
			PList.push(inStr)
			PlistNew.push(inStr)		
			continue;
		} 
		PlistNew.push(inStr)
		num	= num + 1;
		if (num%1000==0) {
			tempArr.push(inStr)
			PList.push(tempArr)
			tempArr = [];
		} else {
			tempArr.push(inStr)
		}
		
	}
	if (tempArr.length>0) {
		PList.push(tempArr)
	}
	debug(PlistNew,"PlistNew")
	if (PlistNew.length<=1) {
		$.messager.alert('提示', "模板没有维护数据！", "info");
		return false;
	}
	
	var start = new Date().getTime();
	
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Ext.Import",
			MethodName: "TPL",
			PList: PlistNew,
			dataType:"text"
		},function(responseText){
			var msg = responseText.split("^")[1],
				code = responseText.split("^")[0];
				
			setTimeout(function () {
				$.messager.progress("close");
				var end = new Date().getTime();
				var time = (end - start)/1000;
				if (code > 0) {
					var successMsg = '导入成功，共导入<i style="color: blue;font-size:1.5em;">&nbsp;' + (num) + '</i>&nbsp;&nbsp;条记录，共耗时<i style="color: blue;font-size:1.5em;">&nbsp;' + time + '</i>&nbsp;&nbsp;秒！'; 
					$.messager.alert('提示', successMsg, "success",function () {
						//parent.reloadAuthGrid();
					});
				} else {
					var errMsg = '导入失败！失败原因为：<font style="color:red">'+ msg+"</font>" ;
					$.messager.alert('提示',errMsg, "error",function () {
						//parent.reloadAuthGrid();
					});
				}
			},50)
		
	});
	
	
	
	return false;
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

function storagePlanNote(workbook) {
	var sheetNames = workbook.SheetNames;
	if (sheetNames[0]!="化疗方案备注") {
		$.messager.alert('提示', "您所选择的导入模板不匹配，请检查！", "info");
		return false;
	}
	$.messager.progress({
		title: "提示",
		msg: '正在导入数据',
		text: '导入中....'
	}); 
	var worksheet = workbook.Sheets[sheetNames[0]];
	var csv = XLSX.utils.sheet_to_csv(worksheet);
	//debug(csv,"csv")
	var errMsg = "",excelStr="";
	var rows = csv.split('\n');
	rows.pop();
	var totalNum = rows.length;
	//debug(rows.length,"rows.length")
	var PList = [],PlistNew = [];
	var num=0,tempArr=[]
	for (var i=1; i< rows.length; i++) {
		//if(i == 0) continue;
		//debug(i,"i")
		//debug(rows[i],"rows[i]")
		var columns = rows[i].split(",");
		var inStr = columns.join(String.fromCharCode(1))
		//debug(columns,"columns")
		if (i==1) {
			PList.push(inStr)
			PlistNew.push(inStr)		
			continue;
		}
		PlistNew.push(inStr)
		num	= num + 1;
		if (num%1000==0) {
			tempArr.push(inStr)
			PList.push(tempArr)
			tempArr = [];
		} else {
			tempArr.push(inStr)
		}
		
	}
	if (tempArr.length>0) {
		PList.push(tempArr)
	}
	debug(PlistNew,"PlistNew")
	if (PlistNew.length<1) {
		$.messager.alert('提示', "模板没有维护数据！", "info");
		return false;
	}
	
	var start = new Date().getTime();
	
	$cm({
			ClassName: "DHCDoc.Chemo.BS.Ext.Import",
			MethodName: "TPLNote",
			PList: PlistNew,
			dataType:"text"
		},function(responseText){
			var msg = responseText.split("^")[1],
				code = responseText.split("^")[0];
				
			setTimeout(function () {
				$.messager.progress("close");
				var end = new Date().getTime();
				var time = (end - start)/1000;
				if (code > 0) {
					var successMsg = '导入成功，共导入<i style="color: blue;font-size:1.5em;">&nbsp;' + (num) + '</i>&nbsp;&nbsp;条记录，共耗时<i style="color: blue;font-size:1.5em;">&nbsp;' + time + '</i>&nbsp;&nbsp;秒！'; 
					$.messager.alert('提示', successMsg, "success",function () {
						//parent.reloadAuthGrid();
					});
				} else {
					var errMsg = '导入失败！失败原因为：<font style="color:red">'+ msg+"</font>" ;
					$.messager.alert('提示',errMsg, "error",function () {
						//parent.reloadAuthGrid();
					});
				}
			},50)
		
	});
	
	
	
	return false;
	
}

/*
 * QP 
 * Excel解析改造
 *  
**/
var qreg = /"/g;
XLSX.utils.sheet_to_csv = sheet_to_csv;
function sheet_to_csv(sheet, opts) {
	var out = [];
	var o = opts == null ? {} : opts;
	if(sheet == null || sheet["!ref"] == null) return "";
	var r = safe_decode_range(sheet["!ref"]);
	var FS = o.FS !== undefined ? o.FS : ",", fs = FS.charCodeAt(0);
	var RS = o.RS !== undefined ? o.RS : "\n", rs = RS.charCodeAt(0);
	//var endregex = new RegExp((FS=="|" ? "\\|" : FS)+"+$");
	var row = "", cols = [];
	o.dense = Array.isArray(sheet);
	var colinfo = o.skipHidden && sheet["!cols"] || [];
	var rowinfo = o.skipHidden && sheet["!rows"] || [];
	for(var C = r.s.c; C <= r.e.c; ++C) if (!((colinfo[C]||{}).hidden)) cols[C] = encode_col(C);
	for(var R = r.s.r; R <= r.e.r; ++R) {
		if ((rowinfo[R]||{}).hidden) continue;
		row = make_csv_row(sheet, r, R, cols, fs, rs, FS, o);
		if(row == null) { continue; }
		if(o.strip) row = row.replace(endregex,"");
		out.push(row + RS);
	}
	delete o.dense;
	return out.join("");
}

function make_csv_row(sheet, r, R, cols, fs, rs, FS, o) {
	var isempty = true;
	var row = [], txt = "", rr = encode_row(R);
	for(var C = r.s.c; C <= r.e.c; ++C) {
		if (!cols[C]) continue;
		var val = o.dense ? (sheet[R]||[])[C]: sheet[cols[C] + rr];
		if(val == null) txt = "";
		else if(val.v != null) {
			isempty = false;
			txt = ''+format_cell(val, null, o);
			for(var i = 0, cc = 0; i !== txt.length; ++i) {
				if((cc = txt.charCodeAt(i)) === fs || cc === rs || cc === 34) {
					if (cc === fs) {
						//txt = txt.replace(qreg, "^");
						txt = txt.replace(/,/g, '^');
					} else {
						txt = "\"" + txt.replace(qreg, '""') + "\""; 
					}
					break; 
				}
			}
			if(txt == "ID") txt = '"ID"';
		} else if(val.f != null && !val.F) {
			isempty = false;
			txt = '=' + val.f; 
			if(txt.indexOf(",") >= 0) {
				//txt = '"' + txt.replace(qreg, '""') + '"';
				txt = txt.replace(qreg, "^");
			}
		} else txt = "";
		/* NOTE: Excel CSV does not support array formulae */
		//txt=txt.replace(/,/g, '^')
		row.push(txt);
	}
	if(o.blankrows === false && isempty) return null;
	return row.join(FS);
}

function encode_row(row) { return "" + (row + 1); }
function decode_col(colstr) { var c = unfix_col(colstr), d = 0, i = 0; for(; i !== c.length; ++i) d = 26*d + c.charCodeAt(i) - 64; return d - 1; }
function encode_col(col) { if(col < 0) throw new Error("invalid column " + col); var s=""; for(++col; col; col=Math.floor((col-1)/26)) s = String.fromCharCode(((col-1)%26) + 65) + s; return s; }
function fix_col(cstr) { return cstr.replace(/^([A-Z])/,"$$$1"); }
function unfix_col(cstr) { return cstr.replace(/^\$([A-Z])/,"$1"); }

function safe_format_cell(cell, v) {
	var q = (cell.t == 'd' && v instanceof Date);
	if(cell.z != null) try { return (cell.w = SSF.format(cell.z, q ? datenum(v) : v)); } catch(e) { }
	try { return (cell.w = SSF.format((cell.XF||{}).numFmtId||(q ? 14 : 0),  q ? datenum(v) : v)); } catch(e) { return ''+v; }
}

function format_cell(cell, v, o) {
	if(cell == null || cell.t == null || cell.t == 'z') return "";
	if(cell.w !== undefined) return cell.w;
	if(cell.t == 'd' && !cell.z && o && o.dateNF) cell.z = o.dateNF;
	if(v == undefined) return safe_format_cell(cell, cell.v);
	return safe_format_cell(cell, v);
}

function safe_decode_range(range) {
	var o = {s:{c:0,r:0},e:{c:0,r:0}};
	var idx = 0, i = 0, cc = 0;
	var len = range.length;
	for(idx = 0; i < len; ++i) {
		if((cc=range.charCodeAt(i)-64) < 1 || cc > 26) break;
		idx = 26*idx + cc;
	}
	o.s.c = --idx;

	for(idx = 0; i < len; ++i) {
		if((cc=range.charCodeAt(i)-48) < 0 || cc > 9) break;
		idx = 10*idx + cc;
	}
	o.s.r = --idx;

	if(i === len || range.charCodeAt(++i) === 58) { o.e.c=o.s.c; o.e.r=o.s.r; return o; }

	for(idx = 0; i != len; ++i) {
		if((cc=range.charCodeAt(i)-64) < 1 || cc > 26) break;
		idx = 26*idx + cc;
	}
	o.e.c = --idx;

	for(idx = 0; i != len; ++i) {
		if((cc=range.charCodeAt(i)-48) < 0 || cc > 9) break;
		idx = 10*idx + cc;
	}
	o.e.r = --idx;
	return o;
}