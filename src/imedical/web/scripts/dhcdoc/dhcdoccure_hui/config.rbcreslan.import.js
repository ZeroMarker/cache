
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
		},onClickButton:function(){
			$(this).filebox("clear")
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
	if(ServerObj.NotShowDetail=="Y"){
		return;
	}
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
			ClassName: "DHCDoc.DHCDocCure.RBCResPlan",
			MethodName: "ImportExcel",
			excelStr: excelStr
		},false);
		
		if (responseText != 0) {
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
	
	var excelStrArr=[];
	var mSplitCount=100;
	if(ServerObj.SplitCount!=""){
		mSplitCount=ServerObj.SplitCount;
	}
	if(ServerObj.sheetType=="JSON"){
		var errMsg = "",excelStr="";
		var json = XLSX.utils.sheet_to_json(worksheet);
		var totalNum = json.length+1;
		for (var i=0; i< json.length; i++) {
			var columns = JSON.stringify(json[i]);
			if (excelStr == "") excelStr = columns;
			else  excelStr = excelStr + "!" + columns;
			if(i%mSplitCount==0){
				excelStrArr.push(excelStr);
				excelStr=""	
			}
		}
		if(excelStr!=""){
			excelStrArr.push(excelStr);	
		}
	}else{
		var errMsg = "",excelStr="";
		var csv = XLSX.utils.sheet_to_csv(worksheet);
		var rows = csv.split('\n');
		rows.pop();
		var totalNum = rows.length;
	
		for (var i=0; i< rows.length; i++) {
			if(i == 0) continue;
			var columns = rows[i].split(",");
			var inStr = columns.join("^")
			if (excelStr == "") excelStr = inStr;
			else  excelStr = excelStr + "!" + inStr;
			if(i%mSplitCount==0){
				excelStrArr.push(excelStr);
				excelStr=""	
			}
		}
		if(excelStr!=""){
			excelStrArr.push(excelStr);	
		}
	}
	var start = new Date().getTime();
	var ExpStr=parent.Util_GetSelHospID()+"^"+ServerObj.ForLocID;
	mexport(excelStrArr,ExpStr,"");
	
	function mexport(excelStrArr,ExpStr,IgnoreRepeat){
		$.cm({
			ClassName:(ServerObj.mClassName=="")?"DHCDoc.DHCDocCure.RBCResPlan":ServerObj.mClassName,
			MethodName:(ServerObj.mMethodName=="")?"ImportTotalExcel":ServerObj.mMethodName,
			excelStrArr:excelStrArr,
			ExpStr:ExpStr,
			_headers:{'X-Accept-Tag':1},
			IgnoreRepeat:IgnoreRepeat,
			dataType:"text"
		},function(responseText){
			if(responseText.indexOf("Repeat")>-1){
				var RepeatCodeStr=responseText.split("^")[1];
				$.messager.confirm("提示","表单代码【"+RepeatCodeStr+"】存在重复记录，是否覆盖",function(r){
					if(r){
						mexport(excelStrArr,ExpStr,"Y");	
					}else{
						$.messager.progress("close");
					}
				})
			}else{
				setTimeout(function () {
					$.messager.progress("close");
					var end = new Date().getTime();
					var time = (end - start)/1000;
					if (responseText == 0) {
						var successMsg = '导入成功，共导入<i style="color: blue;font-size:1.5em;">&nbsp;' + (totalNum-1) + '</i>&nbsp;&nbsp;条记录，共耗时<i style="color: blue;font-size:1.5em;">&nbsp;' + time + '</i>&nbsp;&nbsp;秒！'; 
						$.messager.alert('提示', successMsg, "success",function () {
							if(parent && parent.LoadCureRBCResPlanDataGrid){
								parent.LoadCureRBCResPlanDataGrid(true);
							}
						});
					} else {
						var errMsg = '导入失败！失败原因为：<font style="color:red">'+ responseText+"</font>" ;
						$.messager.alert('提示',errMsg, "error",function () {
							//parent.reloadAuthGrid();
						});
					}
				},50)
			}
		})
	}
	
	return true;
	
}
