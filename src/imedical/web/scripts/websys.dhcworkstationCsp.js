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
		{ field: 'CTLOCDesc', title: '��������', width: 250 },
		{ field: 'CTLOCCode', title: '���Ҵ���', width: 250 },
		{ field: 'CTLOCRowID', title: '����ID', width: 50, hidden: true }
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
		{ field: 'SSGRPDesc', title: '��ȫ������', width: 250 },
		// {field:'Code',title:'����',width:100},  // ��ȫ��û��code��ֻ��desc 
		{ field: 'SSGRPRowId', title: '��ȫ��ID', width: 50, hidden: true }
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
		//$('#group').lookup('setText',rowData.HIDDEN+"-"+rowData.Description);  //textField����Description����onSelect������Լ�����ʾ��ֵ �����ֲ�����Ҫ�Լ�����ò�ѯ������Ĺ�ϵ
	},
	isCombo: true,
	a: 1
});
var defaultCallBack = function (rtn, type) {
	if (rtn > 0) {
		$.messager.popover({ msg: "�ɹ���", type: 'success' });
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
			$.messager.popover({ msg: "ʧ�ܣ�", type: 'error' });
		}
	}
}

var createLinkDataGrid = function () {
	$(LinkDataGradId).mgrid({
		className: "websys.DHCWorkstationLnkGrp",
		editGrid: true,
		key: dataGradId.substr(1, dataGradId.length - 5), // div id + "Grid"
		// title:"��׼�����б�",
		fit: true,
		pageSize: 10,
		rownumbers: false,
		onBeforeLoad: function (p) {
			p.WSLGWSDr = stationId;
			p.TWSLGGrpDr1 = $("#group").lookup("getValue");
			p.TWSLGLocDr1 = $("#loc").lookup("getValue");
		},
		columns: [[
			{ field: 'ID', title: 'ID', hidden: true } // ������ť��Ҫ���д��ڡ�
			, { field: 'TWSLGRowId', title: 'TWSLGRowId', width: 100 }
			, { field: 'TWSLGGrpDr', title: 'TWSLGGrpDr', hidden: true }
			, { field: 'TWSLGGrpDesc', title: '��ȫ��', width: 100, editor: { type: 'text' } }
			, { field: 'TWSLGLocDr', title: 'TWSLGLocDr', hidden: true }
			, { field: 'TWSLGLocDesc', title: '����', width: 100, editor: { type: 'text' } }
		]],
		insReq: { hidden: true },
		updReq: { hidden: true },
		saveReq: { hidden: true },
		delHandler: function (row) {
			$.messager.confirm("ɾ��", "ȷ��ɾ��?", function (r) {
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
		// title:"��׼�����б�",
		fit: true,
		pageSize: 10,
		rownumbers: false,
		onBeforeLoad: function (p) {
			p.WSCode = getValueById("WSCode");
			p.WSDesc = getValueById("WSDesc");
		},
		columns: [[
			{ field: 'ID', title: 'ID', hidden: true } // ������ť��Ҫ���д��ڡ�
			, { field: 'TWSRowId', title: 'TWSRowId', width: 100 }
			, { field: 'TWSCode', title: '����վ����', width: 100, editor: { type: 'text' } }
			, { field: 'TWSDesc', title: '����վ����', width: 100, editor: { type: 'text' } }
			// ,{field:'TWSType', title:'����', width:100, 
			// 	formatter:function(value, row, index){
			// 		if(!!row.TWSRowId) {
			// 			var str = '<a href="#" onclick="associate(' + row.TWSRowId + ')" >����</a>';
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
			$.messager.confirm("ɾ��", "ȷ��ɾ��?", function (r) {
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
	$.messager.progress({ title: "��ʾ", text: '��ѯ��....' });
	$(dataGradId).datagrid('load');
	stationId = "";
	$(LinkDataGradId).datagrid('load');
});
$('#WSCode').keypress(function (event) {
	// ��ѯ input �� Enter�� ֮��
	if (event.keyCode == "13") {
		$('#FindBtn').click();
	}
});
$('#WSDesc').keypress(function (event) {
	// ��ѯ input �� Enter�� ֮��
	if (event.keyCode == "13") {
		$('#FindBtn').click();
	}
});
function validateData(row) {
	if (!row.TWSCode) {
		$.messager.popover({ msg: "���벻��Ϊ�գ�", type: 'info' });
		return false;
	}
	return true;
}
$('#FindLinkBtn').click(function () {
	if (!stationId) {
		$.messager.popover({ msg: "����ѡ�����Ĺ���վ", type: 'error' });
		//$.messager.progress({title: "��ʾ",text: '����ѡ�����Ĺ���վ'});
		return;
	}
	$.messager.progress({ title: "��ʾ", text: '��ѯ��....' });
	$(LinkDataGradId).datagrid('load');
});
$('#SaveLinkBtn').click(function () {
	if (!stationId) {
		$.messager.popover({ msg: "����ѡ�����Ĺ���վ", type: 'error' });
		//$.messager.progress({title: "��ʾ",text: '����ѡ�����Ĺ���վ'});
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
		$.messager.popover({ msg: "���ܱ��������", type: 'error' });
		return;
	}
	var WSLGWSDr = stationId;
	var WSLGRowId = $(LinkDataGradId).datagrid('getSelected') ? $(LinkDataGradId).datagrid('getSelected').TWSLGRowId : "";

	var rtn = tkMakeServerCall("websys.DHCWorkstationLnkGrp", "Save", WSLGRowId, WSLGWSDr, WSLGGrpDr, WSLGLocDr);
	defaultCallBack(rtn, 2);
});