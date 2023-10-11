/**
 * 医生站公共 Excel 导入
 * ../scripts/dhcdoc/common/excel.import.js
 */

var PageLogicObj = {
	m_MethodNameTemplate: (ServerObj.mMethodNameTemplate == "") ? ServerObj.mMethodName + "Template" : ServerObj.mMethodNameTemplate,
	m_IsValidQueryTemplate: "0"
}

$(function(){
	// 页面元素初始化
	PageHandle()
	
	// 页面数据初始化
	Init()
	
	// 事件初始化
	InitEvent()
})

function PageHandle() {
	var isValidQueryTemplate = $cm({
		ClassName: "DHCDoc.Common.ExcelImport",
		MethodName: "IsValidQueryTemplate",
		mClassName: ServerObj.mClassName,
		mMethodNameTemplate: PageLogicObj.m_MethodNameTemplate,
		dataType: "text"
	}, false)
	if (isValidQueryTemplate == "0") {
		$("#excelTemplateDown").hide()
	}
	PageLogicObj.m_IsValidQueryTemplate = isValidQueryTemplate
}

function Init() {
}

function InitEvent() {
	$("#checkFile").filebox({
		onChange: function(newVal, oldVal) {
			var file = $(this).filebox("files")[0];
			readWorkbookFromLocal(file, showWorkbook)
		}, onClickButton: function() {
			$(this).filebox("clear")
			$('#excelDetail').html("")
		}
	})
	$("#import").click(function() {
		var files = $("#checkFile").filebox("files")
		if (files.length == 0) {
			$.messager.alert("提示", "请选择 Excel 文件!", 'info')
			return false
		}
		readWorkbookFromLocal(files[0], importExcelToServer)
	})
	$("#clear").click(function(){
		$('#checkFile').filebox("clear")
		$('#excelDetail').html("")
	})
	$("#excelTemplateDown").click(downloadExcelTemplate)
}

function readWorkbookFromLocal(file, callBackFun) {
	var reader = new FileReader()
	if (reader.readAsBinaryString) {
		reader.readAsBinaryString(file)
		reader.onload = function(e) {
			const data = e.target.result
			var workbook = XLSX.read(data, { type: 'binary' })
            callBackFun(workbook)
		}
	} else {
		reader.readAsArrayBuffer(file)
		reader.onload = function(e) {
			const data = e.target.result
			var workbook = XLSX.read(data, { type: 'array' })
			callBackFun(workbook)
		}
	}
}

function showWorkbook(workbook) {
	if (ServerObj.mShowExcelDetail == 1) {
		var sheetNames = workbook.SheetNames
		var worksheet = workbook.Sheets[sheetNames[0]]
		var csv = XLSX.utils.sheet_to_csv(worksheet)
		// var json = XLSX.utils.sheet_to_json(worksheet)
		// var json0 = JSON.stringify(json[0])
		$('#excelDetail').html(csv2Table(csv))
		return true
	} else {
		return false
	}
}

function csv2Table(csv) {
	var html = "<table>"
	var rows = csv.split("\n")
	rows.pop()
	rows.forEach(function(row, index){
		var cols = row.split(",")
		html += "<tr>"
		if (index == 0) {
			cols.unshift("")
			cols.forEach(function(col) {
				html += "<th>" + col + "</th>"
			})
		} else {
			cols.unshift(index)
			cols.forEach(function(col) {
				html += "<td>" + col + "</td>"
			})
		}
		html += "</tr>"
	})
	html += "</table>"
	return html;
}

function importExcelToServer(workbook) {
	$.messager.progress({
		title: "提示",
		msg: '正在导入数据',
		text: '导入中....'
	})
	var checkBlankLine = "";
	var blackLines = [];
	for (var i=0; i< 100; i++) {
		checkBlankLine += "^"
	}
	var sheetNames = workbook.SheetNames
	var worksheet = workbook.Sheets[sheetNames[0]]
	var csv = XLSX.utils.sheet_to_csv(worksheet)
	
	var excelRows = []
	var excelRow = ""
	var rows = csv.split("\n")
	rows.pop()
	rows.forEach(function(row, index) {
		var cols = row.split(",")
		if (index == 0) {
		} else {
			excelRow = cols.join("^")
			if (checkBlankLine.indexOf(excelRow) > -1) {
				blackLines.push(index);
			}
			excelRows.push(excelRow)
		}
	})
	if (blackLines.length > 0 ) {
		$.messager.alert('提示', "有" + blackLines.length + "空行，请先处理Excel空行！", "info")
		$.messager.progress("close");
		return false;
	}
	var sessionStr = GetSessionStr()
	saveDataToServer(excelRows, sessionStr)
	function saveDataToServer(excelRows, sessionStr) {
		$cm({
			ClassName: "DHCDoc.Common.ExcelImport",
			MethodName: "ImportDataToServer",
			excelRows: excelRows,
			sessionStr: sessionStr,
			mClassName: ServerObj.mClassName,
			mMethodName: ServerObj.mMethodName,
			mCheckBefore: ServerObj.mCheckBefore,
			_headers: { 'X-Accept-Tag': 1 },
			dataType: "text"
		}, function(ret) {
			$.messager.progress("close");
			var retArr = ret.split("^")
			if (retArr[0] != 0) {
				$.messager.alert('提示', ret.split("^")[1], "error")
			} else {
				$.messager.alert('提示', "导入成功", "success", function() {
					if(websys_showModal('options') && websys_showModal('options').callbackFun){
						websys_showModal('options').callbackFun()
					}
					if (ServerObj.mImportSuccessClose != "0") {
						websys_showModal('close')
					}
				})
			}
		})
		
	}
	return true;
}

function downloadExcelTemplate() {
	if (PageLogicObj.m_IsValidQueryTemplate == "0") {
		return
	}
	var excelName = "Excel导入模板"
	var setPageName = ""
	var setPageName = ServerObj.mClassName + ":" + PageLogicObj.m_MethodNameTemplate
	$cm({
		ResultSetType: "ExcelPlugin",  		// 表示通过DLL生成Excel，可支持IE与Chrome系。Chrome系浏览器请安装中间件
		// ResultSetTypeDo:"Print",    		// 默认Export，可以设置为：PRINT , PREVIEW
		localDir: "Self",	      			// D:\\tmp\\表示固定文件路径, "Self"表示用户导出时选择保存路径，默认保存到桌面
		ExcelName: excelName,
		PageName: setPageName,	
		ClassName: ServerObj.mClassName,
		QueryName: PageLogicObj.m_MethodNameTemplate,
	    rows:10
	},function(data){
		$.messager.popover({
			msg: '模板下载成功，请留意任务栏！',
			type: 'success',
			timeout: 2000,
			showType: 'slide'
		})
	})
}