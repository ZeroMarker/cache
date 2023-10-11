// websys.dhcworkstationCsp.js
$(init);
var dataGradId = "#workstationListGrid";
var LinkDataGradId = "#workstatioLinkListGrid";
var stationId = "";
function init() {
	createDataGrid();
	createLinkDataGrid();
}
$("#loc").lookup({
	width: 100, panelWidth: 350, panelHeight: 400,
	url: $URL,
	mode: 'remote',
	idField: 'CTLOCRowID',
	textField: 'CTLOCDesc',
	columns: [[
		{ field: 'CTLOCDesc', title: '科室名称', width: 250 },
		{ field: 'CTLOCCode', title: '科室代码', width: 250 },
		{ field: 'CTLOCRowID', title: '科室ID', width: 50, hidden: true }
	]],
	queryParams: {
		"ClassName": "web.DHCBL.CT.CTLoc"
		, "QueryName": "GetDataForCmb1"
		, "desc": ""
	},
	onBeforeLoad: function (param) {
		param.desc = param.q ? param.q : "";
	},
	pagination: true,
	rownumbers: false,
	onSelect: function (index, rowData) {
		console.log("index=" + index + ",rowData=", rowData);
	},
});
$("#group").lookup({
	width: 100, panelWidth: 350, panelHeight: 400,
	url: $URL,
	mode: 'remote',
	idField: 'SSGRPRowId',
	textField: 'SSGRPDesc',
	columns: [[
		{ field: 'SSGRPDesc', title: '安全组名称', width: 250 },
		// {field:'Code',title:'代码',width:100},  // 安全组没有code；只有desc 
		{ field: 'SSGRPRowId', title: '安全组ID', width: 50, hidden: true }
	]],
	queryParams: {
		"ClassName": "web.DHCBL.CT.SSGroup"
		, "QueryName": "GetDataForCmb1"
		, "desc": ""
	},
	onBeforeLoad: function (param) {
		param.desc = param.q ? param.q : "";
	},
	pagination: true,
	rownumbers: false,
	onSelect: function (index, rowData) {
		console.log("index=" + index + ",rowData=", rowData);
		//$('#group').lookup('setText',rowData.HIDDEN+"-"+rowData.Description);  //textField虽是Description，在onSelect这可以自己改显示的值 但此种操作需要自己处理好查询条件间的关系
	},
	isCombo: true,
	a: 1
});
var defaultCallBack = function (rtn, type) {
	if (rtn > 0) {
		$.messager.popover({ msg: "成功！", type: 'success' });
		if (!!type) {
			$("#group").lookup("setValue", "");
			$("#loc").lookup("setValue", "");
			$("#group").lookup("setText", "");
			$("#loc").lookup("setText", "");
			$(LinkDataGradId).datagrid('load');
		} else {
			$('#FindBtn').click();
		}
	} else {
		var rtnArr = rtn.split("^");
		if (rtnArr.length > 1) {
			$.messager.popover({ msg: rtnArr[1], type: 'error' });
		} else {
			$.messager.popover({ msg: "失败！", type: 'error' });
		}
	}
}

var createLinkDataGrid = function () {
	$(LinkDataGradId).mgrid({
		className: "websys.DHCWorkstationLnkGrp",
		editGrid: true,
		key: dataGradId.substr(1, dataGradId.length - 5), // div id + "Grid"
		// title:"标准类型列表",
		fit: true,
		pageSize: 10,
		rownumbers: false,
		onBeforeLoad: function (p) {
			p.WSLGWSDr = stationId;
			p.TWSLGGrpDr1 = $("#group").lookup("getValue");
			p.TWSLGLocDr1 = $("#loc").lookup("getValue");
		},
		columns: [[
			{ field: 'ID', title: 'ID', hidden: true } // 撤销按钮需要此列存在。
			, { field: 'TWSLGRowId', title: 'TWSLGRowId', width: 100 }
			, { field: 'TWSLGGrpDr', title: 'TWSLGGrpDr', hidden: true }
			, { field: 'TWSLGGrpDesc', title: '安全组', width: 100, editor: { type: 'text' } }
			, { field: 'TWSLGLocDr', title: 'TWSLGLocDr', hidden: true }
			, { field: 'TWSLGLocDesc', title: '科室', width: 100, editor: { type: 'text' } }
		]],
		insReq: { hidden: true },
		updReq: { hidden: true },
		saveReq: { hidden: true },
		delHandler: function (row) {
			$.messager.confirm("删除", "确定删除?", function (r) {
				if (r) {
					var rtn = tkMakeServerCall("websys.DHCWorkstationLnkGrp", "Delete", row.TWSLGRowId);
					defaultCallBack(rtn, 2);
				} else {
					return;
				}
			});

		},
		onLoadSuccess: function (data) {
			$.messager.progress("close");
		},
		onSelect: function (rowIndex, rowData) {
			$("#group").lookup("setValue", rowData.TWSLGGrpDr);
			$("#loc").lookup("setValue", rowData.TWSLGLocDr);
			$("#group").lookup("setText", rowData.TWSLGGrpDesc);
			$("#loc").lookup("setText", rowData.TWSLGLocDesc);
		},
		a: 1
	});
}
var createDataGrid = function () {
	$(dataGradId).mgrid({
		className: "websys.DHCWorkstation",
		editGrid: true,
		key: dataGradId.substr(1, dataGradId.length - 5), // div id + "Grid"
		// title:"标准类型列表",
		fit: true,
		pageSize: 10,
		rownumbers: false,
		onBeforeLoad: function (p) {
			p.WSCode = getValueById("WSCode");
			p.WSDesc = getValueById("WSDesc");
		},
		columns: [[
			{ field: 'ID', title: 'ID', hidden: true } // 撤销按钮需要此列存在。
			, { field: 'TWSRowId', title: 'TWSRowId', width: 100 }
			, { field: 'TWSCode', title: '工作站代码', width: 100, editor: { type: 'text' } }
			, { field: 'TWSDesc', title: '工作站描述', width: 100, editor: { type: 'text' } }
			// ,{field:'TWSType', title:'关联', width:100, 
			// 	formatter:function(value, row, index){
			// 		if(!!row.TWSRowId) {
			// 			var str = '<a href="#" onclick="associate(' + row.TWSRowId + ')" >关联</a>';
			// 			return str;
			// 		}
			// 	}
			// }
		]],
		insOrUpdHandler: function (row) {
			var param = {
				"WSRowId": row.TWSRowId, "WSCode": row.TWSCode, "WSDesc": row.TWSDesc
			};
			param.WSRowId = !param.WSRowId ? "" : param.WSRowId;
			if (!validateData(row)) return false;
			var rtn = tkMakeServerCall("websys.DHCWorkstation", "Save", param.WSRowId, param.WSCode, param.WSDesc, "");
			defaultCallBack(rtn);
		},
		delHandler: function (row) {
			$.messager.confirm("删除", "确定删除?", function (r) {
				if (r) {
					var rtn = tkMakeServerCall("websys.DHCWorkstation", "Delete", row.TWSRowId);
					defaultCallBack(rtn);
				} else {
					return;
				}
			});
		},
		getNewRecord: function () {
			return { "ID": "", "WSRowId": "", "WSCode": "", "WSDesc": "", "WSType": "" };
		},
		//delReq:{hidden:true},
		onLoadSuccess: function (data) {
			$.messager.progress("close");
		},
		onSelect: function (rowIndex, rowData) {
			$("#group").lookup("setValue", "");
			$("#loc").lookup("setValue", "");
			$("#group").lookup("setText", "");
			$("#loc").lookup("setText", "");
			stationId = rowData.TWSRowId;
			$(LinkDataGradId).datagrid('load');
		},
		a: 1
	});
}

$('#ClearBtn').click(function () {
	$("#WSCode").val("");
	$("#WSDesc").val("");
});
$('#FindBtn').click(function () {
	$.messager.progress({ title: "提示", text: '查询中....' });
	$(dataGradId).datagrid('load');
	stationId = "";
	$(LinkDataGradId).datagrid('load');
});
$('#WSCode').keypress(function (event) {
	// 查询 input 框 Enter键 之后
	if (event.keyCode == "13") {
		$('#FindBtn').click();
	}
});
$('#WSDesc').keypress(function (event) {
	// 查询 input 框 Enter键 之后
	if (event.keyCode == "13") {
		$('#FindBtn').click();
	}
});
function validateData(row) {
	if (!row.TWSCode) {
		$.messager.popover({ msg: "代码不能为空！", type: 'info' });
		return false;
	}
	return true;
}
$('#FindLinkBtn').click(function () {
	if (!stationId) {
		$.messager.popover({ msg: "请先选择左侧的工作站", type: 'error' });
		//$.messager.progress({title: "提示",text: '请先选择左侧的工作站'});
		return;
	}
	$.messager.progress({ title: "提示", text: '查询中....' });
	$(LinkDataGradId).datagrid('load');
});
$('#SaveLinkBtn').click(function () {
	if (!stationId) {
		$.messager.popover({ msg: "请先选择左侧的工作站", type: 'error' });
		//$.messager.progress({title: "提示",text: '请先选择左侧的工作站'});
		return;
	}
	var WSLGGrpDr = $("#group").lookup("getValue");
	var WSLGLocDr = $("#loc").lookup("getValue");
	var WSLGGrpDesc = $("#group").lookup("getText");
	var WSLGLocDesc = $("#loc").lookup("getText");
	if (WSLGGrpDesc == "") {
		WSLGGrpDr = "";
	}
	if (WSLGLocDesc == "") {
		WSLGLocDr = "";
	}
	if (WSLGGrpDr == "" && WSLGLocDr == "") {
		$.messager.popover({ msg: "不能保存空数据", type: 'error' });
		return;
	}
	var WSLGWSDr = stationId;
	var WSLGRowId = $(LinkDataGradId).datagrid('getSelected') ? $(LinkDataGradId).datagrid('getSelected').TWSLGRowId : "";

	var rtn = tkMakeServerCall("websys.DHCWorkstationLnkGrp", "Save", WSLGRowId, WSLGWSDr, WSLGGrpDr, WSLGLocDr);
	defaultCallBack(rtn, 2);
});