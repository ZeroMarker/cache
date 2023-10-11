/** 
 * creator:	   yunhaibao
 * createdate: 2016-12-06
 * ��Ҫ������ scripts\pha\com\v1\js\util.js,20191226,yunhaibao
 * easyui datagrid bootstrap��ʽ����
 */
//exportwayΪ��:����д����,Ϊ1����Ԫ��д����
function ExportAllToExcel(exportGrid) {
	if (exportGrid == "") {
		return;
	}
	if ($('#' + exportGrid).datagrid("getRows").length <= 0) {
		dhcphaMsgBox.alert($g("û������!"));
		return;
	}
	ExportAllToExcelHandler(exportGrid);
}

function ExportAllToExcelHandler(exportGrid, exportway) {
	var _fileName = $g("���ݵ���")+"_" + new Date().getTime() + ".xlsx";
	var exportGridOption = $('#' + exportGrid).datagrid("options")
	var exportGridUrl = exportGridOption.url;
	var ajaxURL = "";
	if (exportGridUrl.indexOf("DHCST.METHOD.BROKER.csp") >= 0) {
		var gridParams = exportGridOption.queryParams;
		var inputParams = "";
		for (var iPara in gridParams) {
			if (inputParams == "") {
				inputParams = iPara + "=" + gridParams[iPara]
			} else {
				inputParams = inputParams + "&" + iPara + "=" + gridParams[iPara]
			}
		}
		ajaxURL = exportGridUrl + "&page=1&rows=9999&" + inputParams;
	} else {
		var exportGridparams = exportGridOption.queryParams.Params;
		var exportGridClassName = exportGridOption.queryParams.ClassName;
		var exportGridQueryName = exportGridOption.queryParams.QueryName;
		ajaxURL = exportGridUrl + "?&page=1&rows=9999&Params=" + exportGridparams +
			"&QueryName=" + exportGridQueryName +
			"&ClassName=" + exportGridClassName;
	}
	var $grid = $('#' + exportGrid);
	var newCols;
	var cols = $grid.datagrid("options").columns[0];
	var frozenCols = $grid.datagrid("options").frozenColumns[0];
	if (frozenCols != undefined) {
		newCols = frozenCols.concat(cols);
	} else {
		newCols = cols;
	}
	var titleObj = {};
	for (var ncI = 0; ncI < newCols.length; ncI++) {
		var colIModal = newCols[ncI];
		if ((colIModal.hidden) || (colIModal.checkbox)) {
			continue;
		}
		titleObj[colIModal.field] = colIModal.title;
	}
	$.messager.progress({
		title: $g('��ȴ�'),
		msg: $g('����������...'),
		text: $g('������.......')
	});
	$.ajax({
		type: "GET",
		url: encodeURI(ajaxURL),
		async: false,
		dataType: "json",
		success: function (exportdata) {
			var rowsData = exportdata.rows;
			PHA_UTIL.LoadJS(["../scripts/pha/com/v1/js/export.js"], function () {
		//	PHA_UTIL.LoadJS(["/imedical/web/scripts/pha/com/v1/js/export.js"], function () {
								
				PHA_EXPORT.XLSX(titleObj, rowsData, _fileName);
				$.messager.progress('close');
			});

		}
	});
}

/// hisui export
function HUIExportToExcel(gridId) {
	var fileName = "���ݵ���_" + new Date().getTime() + ".xlsx";
	if (fileName == '') {
		return;
	}
	if ($('#' + gridId).datagrid("getRows").length <= 0) {
		DHCPHA_HUI_COM.Msg.popover({
			msg: 'û������!',
			type: 'success'
		});
		return;
	}
	var gridOption = $('#' + gridId).datagrid("options")
	var gridUrl = gridOption.url;
	var gridParams = gridOption.queryParams;
	$.messager.progress({
		title: '��ȴ�',
		msg: '����������...',
		text: '������.......'
	});
	var $grid = $('#' + gridId);
	var newCols;
	var cols = $grid.datagrid("options").columns[0];
	var frozenCols = $grid.datagrid("options").frozenColumns[0];
	if (frozenCols != undefined) {
		newCols = frozenCols.concat(cols);
	} else {
		newCols = cols;
	}
	var titleObj = {};
	for (var ncI = 0; ncI < newCols.length; ncI++) {
		var colIModal = newCols[ncI];
		if ((colIModal.hidden) || (colIModal.checkbox)) {
			continue;
		}
		titleObj[colIModal.field] = colIModal.title;
	}
	var inputParams = "";
	for (var iPara in gridParams) {
		if (inputParams == "") {
			inputParams = iPara + "=" + gridParams[iPara]
		} else {
			inputParams = inputParams + "&" + iPara + "=" + gridParams[iPara]
		}
	}
	var newUrl = "";
	// query��ʽ
	if (gridUrl.indexOf("websys.Broker") >= 0) {
		newUrl = gridUrl + "?page=1&rows=9999&" + inputParams;
	} else {
		newUrl = gridUrl + "&page=1&rows=9999&" + inputParams;
	}
	$.ajax({
		type: "GET",
		url: encodeURI(newUrl),
		async: true,
		dataType: "json",
		success: function (exportdata) {
			var rowsData = exportdata.rows;
			PHA_UTIL.LoadJS(["../scripts/pha/com/v1/js/export.js"], function () {
				PHA_EXPORT.XLSX(titleObj, rowsData, fileName);
				$.messager.progress('close');
				DHCPHA_HUI_COM.Msg.popover({
					msg: '�����ɹ�',
					type: 'success'
				});
			});
		}
	});
}

var PHA_UTIL = {
	GetDate: function () {},
	GetTime: function () {},
	Rand: function () {

	},
	// ��̬����JS���Ѵ��ڲ������
	LoadJS: function (srcArr, callBack) {
		var loadCnt = srcArr.length;
		var loadI = 0;
		Create();

		function Create() {
			if (loadI >= loadCnt) {
				callBack(loadI);
				return;
			}
			var src = srcArr[loadI];
			if (IsExist(src) == true) {
				loadI++;
				Create();
			} else {
				var head = document.getElementsByTagName('head')[0];
				var script = document.createElement('script');
				script.type = 'text/javascript';
				script.src = src;
				head.appendChild(script);
				script.onload = function () {
					loadI++;
					Create();
				}
			}
		}

		function IsExist(src) {
			var scriptArr = document.getElementsByTagName('script');
			for (var i = 0; i < scriptArr.length; i++) {
				var tmpSrc=src.replace("/imedical/web/","")
				if ((scriptArr[i].src).indexOf(tmpSrc.replace("../", "")) >= 0) {
					return true;
				}
			}
			return false;
		}
	}
}