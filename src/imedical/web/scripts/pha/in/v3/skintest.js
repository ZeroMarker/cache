/**
 * ����:	 ҩ��ҩ�� - Ƥ��ҩƷ����
 * ��д��:   Huxt
 * ��д����: 2020-03-19
 * js: 		 pha/in/v3/skintest.js
 */
PHA_COM.App.Csp = "pha.in.v3.skintest.csp";
PHA_COM.Temp = {}

$(function () {
	PHA_COM.ResizePanel({
		layoutId: 'layout-first',
		region: 'north',
		height: 0.5
	});
	InitHosp();
	InitDict();
	InitGridAlg();
	InitGridSkinTest();
	InitGridSkinTestItm();
	InitEvents();
});

/**
 * @description: �¼��󶨳�ʼ��
 */
function InitEvents() {
	$("#btnFindAlg").on('click', QueryAlg);
	$("#btnSaveAlg").on('click', SaveAlg);
	$("#btnAdd").on('click', Add);
	$("#btnSave").on('click', Save);
	$("#btnDelete").on('click', Delete);
	$("#btnAddItm").on('click', AddItm);
	$("#btnSaveItm").on('click', SaveItm);
	$("#btnDeleteItm").on('click', DeleteItm);
}

/**
 * @description: ��ʼ���ֵ�
 */
function InitDict() {}

/**
 * @description: ��� - ����ԭ
 */
function InitGridAlg() {
	var columns = [
		[{
				field: "alg",
				title: 'alg',
				width: 100,
				hidden: true
			}, {
				field: "algDesc",
				title: $g('����ԭ����'),
				width: 160
			}, {
				field: "rlaAlg",
				descField: 'rlaAlgDesc',
				title: $g('��Ŀ'),
				title: $g('��������ԭ'),
				width: 160,
				formatter: function (value, rowData, index) {
					return rowData['rlaAlgDesc'];
				},
				editor: PHA_GridEditor.ComboBox({
					url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=RelaAlg&ResultSetType=array'
				})
			}, {
				field: "algTypeId",
				title: 'algTypeId',
				width: 100,
				hidden: true
			}, {
				field: "algTypeDesc",
				title: $g('����'),
				width: 80
			}, {
				field: 'startDate',
				title: $g('��ʼ����'),
				width: 100
			}, {
				field: 'endDate',
				title: $g('��ֹ����'),
				width: 100
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.SkinTest.Query',
			QueryName: 'PHAINAlg'
		},
		fit: true,
		border: false,
		displayMsg: "",
		pagination: false,
		columns: columns,
		rownumbers: true,
		fitColumns: true,
		onSelect: function (rowIndex, rowData) {},
		onClickRow: function (rowIndex, rowData) {
			GridEndEidting('gridAlg');
			ShowSelectedItem({});
			Query();
			$("#gridSkinTestItm").datagrid("clear");
		},
		onDblClickCell: function (index, field, value) {
			if (field == 'rlaAlg') {
				PHA_GridEditor.Edit({
					gridID: "gridAlg",
					index: index,
					field: field
				});
			}
		},
		toolbar: "#gridAlgBar"
	};
	PHA.Grid("gridAlg", dataGridOption);
}

/**
 * @description: ��� - Ƥ��ҩƷ
 */
function InitGridSkinTest() {
	var columns = [
		[{
				field: "pist",
				title: 'pist',
				width: 100,
				hidden: true
			}, {
				field: "alg",
				title: 'alg',
				width: 100,
				hidden: true
			}, {
				field: "algDesc",
				title: $g('����ԭ'),
				width: 100,
				hidden: true
			}, {
				field: "itemCode",
				title: $g('��Ŀ����'),
				width: 120
			}, {
				field: "itemId",
				descField: 'itemDesc',
				title: $g('��Ŀ'),
				width: 320,
				formatter: function (value, rowData, index) {
					return rowData['itemDesc']
				},
				editor: PHA_GridEditor.ComboBox({
					url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=QueryItem&ResultSetType=array',
					onBeforeLoad: function (param) {
						var itemType = GetItemType();
						if (itemType == false) {
							return;
						}
						var hospId = $('#_HospList').combogrid('getValue') || "";
						if (hospId == "") {
							return;
						}
						param.hospId = hospId;
						param.QText = param.q;
						if (typeof(param.QText) == "undefined") {
							var selectedRow = $("#gridSkinTest").datagrid("getSelected") || {};
							param.QText = selectedRow.itemDesc || "";
						}
						param.inputStr = itemType;
					}
				})
			}, {
				field: "itemType",
				title: $g('��Ŀ����'),
				align: "center",
				width: 50,
				hidden: true
			}, {
				field: "validTime",
				title: $g('Ƥ��ʱЧ(h)'),
				align: "center",
				width: 90,
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: "desensitFlag",
				title: $g('��������'),
				align: "center",
				width: 70,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "noTestFlag",
				title: $g('��������'),
				align: "center",
				width: 70,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "defNoTest",
				title: $g('Ĭ������'),
				align: "center",
				width: 70,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "exceptionFlag",
				title: $g('��������'),
				align: "center",
				width: 70,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "startDate",
				title: $g('��ʼ����'),
				align: "center",
				width: 100,
				editor: PHA_GridEditor.DateBox({})
			}, {
				field: "endDate",
				title: $g('��������'),
				align: "center",
				width: 100,
				editor: PHA_GridEditor.DateBox({})
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.SkinTest.Query',
			QueryName: 'PHAINSkinTest'
		},
		fit: true,
		border: false,
		rownumbers: false,
		displayMsg: "",
		pagination: false,
		columns: columns,
		fitColumns: false,
		isAutoShowPanel: true,
		editFieldSort: ["itemId", "validTime", "desensitFlag", "noTestFlag", "exceptionFlag", "startDate", "endDate"],
		onDblClickCell: function (index, field, value) {
			if (field == 'itemCode') {
				return;
			}
			PHA_GridEditor.Edit({
				gridID: "gridSkinTest",
				index: index,
				field: field
			});
		},
		onClickRow: function (rowIndex, rowData) {
			GridEndEidting('gridSkinTest');
			ShowSelectedItem(rowData);
			QueryItm(rowIndex);
		},
		toolbar: "#gridSkinTestBar"
	};
	PHA.Grid("gridSkinTest", dataGridOption);
}

/**
 * @description: ��� - Ƥ�Թ���ҩƷ
 */
function InitGridSkinTestItm() {
	var columns = [
		[{
				field: "pisti",
				title: 'pisti',
				width: 100,
				hidden: true
			}, {
				field: "admType",
				descField: 'admTypeDesc',
				title: $g('��������'),
				width: 100,
				formatter: function (value, rowData, index) {
					return rowData['admTypeDesc']
				},
				editor: PHA_GridEditor.ComboBox({
					url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=AdmType&ResultSetType=array',
					panelHeight: 'auto'
				})
			}, {
				field: "locID",
				descField: 'locDesc',
				title: $g('����'),
				width: 180,
				formatter: function (value, rowData, index) {
					return rowData['locDesc'];
				},
				editor: PHA_GridEditor.ComboBox({
					url: PHA_STORE.CTLoc().url,
					onBeforeLoad: function (param) {
						param.QText = param.q;
					}
				})
			}, {
				field: "itemType",
				descField: 'itemTypeDesc',
				title: $g('��Ŀ����'),
				width: 100,
				formatter: function (value, rowData, index) {
					return rowData['itemTypeDesc'];
				},
				editor: PHA_GridEditor.ComboBox({
					url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=ItemType&ResultSetType=array',
					panelHeight: 'auto',
					onBeforeNext: function (cmbRowData, gridRowData, gridRowIndex) {
						gridRowData.autoInsFlag = cmbRowData.RowId == 'G' ? 'N' : 'Y';
						
						$('#gridSkinTestItm').datagrid('updateRowData', {
							index: gridRowIndex,
							row: gridRowData
						});
					}
				})
			}, {
				field: "itemId",
				descField: 'itemDesc',
				title: $g('��Ŀ'),
				width: 320,
				formatter: function (value, rowData, index) {
					return rowData['itemDesc'];
				},
				editor: PHA_GridEditor.ComboBox({
					url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=QueryItem&ResultSetType=array',
					onBeforeLoad: function (param) {
						var hospId = $('#_HospList').combogrid('getValue') || "";
						if (hospId == "") {
							return false;
						}
						param.hospId = hospId;
						param.QText = param.q;
						var selectedRow = $("#gridSkinTestItm").datagrid("getSelected") || {};
						if (typeof(param.QText) == "undefined") {
							param.QText = selectedRow.itemDesc || "";
						}
						param.inputStr = selectedRow.itemType || "";
					}
				})
			}, {
				field: "resultFlag",
				title: $g('�����־'),
				align: "center",
				width: 80,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "priID",
				descField: 'priDesc',
				title: $g('���ȼ�'),
				align: "center",
				width: 130,
				formatter: function (value, rowData, index) {
					return rowData['priDesc'];
				},
				editor: PHA_GridEditor.ComboBox({
					url: PHA_STORE.OECPriority().url,
					onBeforeLoad: function (param) {
						param.QText = param.q;
					}
				})
			}, {
				field: "doseQty",
				title: $g('����'),
				align: "center",
				width: 80,
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: "unitID",
				descField: 'unitDesc',
				title: $g('������λ'),
				align: "center",
				width: 80,
				formatter: function (value, rowData, index) {
					return rowData['unitDesc'];
				},
				editor: PHA_GridEditor.ComboBox({
					url: $URL + '?ClassName=PHA.IN.SkinTest.Query&QueryName=DoseUom&ResultSetType=array',
					panelHeight: 'auto',
					onBeforeLoad: function (param) {
						var selectedRow = $("#gridSkinTestItm").datagrid("getSelected") || {};
						param.inputStr = selectedRow.itemId || "";
					}
				}),
			}, {
				field: "freqID",
				descField: 'freqDesc',
				title: $g('Ƶ��'),
				align: "center",
				width: 130,
				formatter: function (value, rowData, rowIndex) {
					return rowData['freqDesc'];
				},
				editor: PHA_GridEditor.ComboBox({
					url: PHA_STORE.PHCFreq().url,
					onBeforeLoad: function (param) {
						param.QText = param.q;
					}
				})
			}, {
				field: "instID",
				descField: 'instDesc',
				title: $g('�÷�'),
				align: "center",
				width: 120,
				formatter: function (value, rowData, index) {
					return rowData['instDesc'];
				},
				editor: PHA_GridEditor.ComboBox({
					url: PHA_STORE.PHCInstruc().url,
					onBeforeLoad: function (param) {
						param.QText = param.q;
					}
				}),
			}, {
				field: "seqNo",
				title: $g('����'),
				align: "center",
				width: 80,
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: "autoInsFlag",
				title: $g('�Զ�����'),
				align: "center",
				width: 80,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "startDate",
				title: $g('��ʼ����'),
				align: "center",
				width: 120,
				editor: PHA_GridEditor.DateBox({})
			}, {
				field: "endDate",
				title: $g('��ֹ����'),
				align: "center",
				width: 120,
				editor: PHA_GridEditor.DateBox({})
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.SkinTest.Query',
			QueryName: 'PHAINSkinTestItm'
		},
		fit: true,
		border: false,
		rownumbers: false,
		displayMsg: "",
		pagination: false,
		columns: columns,
		fitColumns: false,
		isAutoShowPanel: true,
		editFieldSort: ["itemType", "itemId", "resultFlag", "priID", "doseQty", "unitID", "freqID", "instID", "seqNo", "autoInsFlag", "startDate", "endDate"],
		onDblClickCell: function (index, field, value) {
			PHA_GridEditor.Edit({
				gridID: "gridSkinTestItm",
				index: index,
				field: field
			});
		},
		toolbar: "#gridSkinTestItmBar"
	};
	PHA.Grid("gridSkinTestItm", dataGridOption);
}

/**
 * @description: ����ԭCRUD����
 */
function QueryAlg() {
	$("#gridAlg").datagrid('reload');
}
function SaveAlg() {
	if (GridEndEidting("gridAlg") == false) {
		return;
	}
	var changeData = GetChangeData("gridAlg");
	if (changeData.length == 0) {
		return;
	}
	var jsonDataStr = JSON.stringify(changeData);
	// ����
	var retStr = $.cm({
		ClassName: 'PHA.IN.SkinTest.Save',
		MethodName: 'SaveAlgMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	AfterRunServer(retStr, QueryAlg);
}

/**
 * @description: Ƥ��ҩƷCRUD����
 */
function Query() {
	// ��ȡҽԺ
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		return false;
	}
	var selectedRow = $("#gridAlg").datagrid("getSelected") || {};
	var alg = selectedRow.alg || "";
	if (alg == "") {
		return false;
	}
	var inputStr = alg;
	$("#gridSkinTest").datagrid('query', {
		inputStr: inputStr,
		hospId: hospId
	});
	// ��ѡ
	var algMaintainType = tkMakeServerCall("PHA.IN.SkinTest.Query", "GetAlgMaintainType", (selectedRow.alg || ""));
	if (algMaintainType != "") {
		$("input[name='itemType']").radio('disable');
		$("input[name='itemType'][value='" + algMaintainType + "']").radio('setValue', true);
	} else {
		$("input[name='itemType']").radio('enable');
	}
}

function Add() {
	$("input[name='itemType']").radio('disable');
	var selectedRow = $("#gridAlg").datagrid("getSelected") || {};
	var alg = selectedRow.alg || "";
	if (alg == "") {
		PHA.Popover({
			msg: $g("��ѡ�����ԭ!"),
			type: "alert"
		});
		return false;
	}
	var algDesc = selectedRow.algDesc || "";
	var itemType = GetItemType();
	if (itemType == false) {
		return;
	}
	var startDate = tkMakeServerCall("PHA.IN.SkinTest.Query", "GetDate", "t");
	
	PHA_GridEditor.Add({
		gridID: 'gridSkinTest',
		field: 'itemId',
		rowData: {
			itemType: itemType,
			alg: alg,
			validTime: '72',
			desensitFlag: 'N',
			noTestFlag: 'N',
			exceptionFlag: 'N',
			startDate: startDate
		}
	});
}

function Save() {
	// ��ȡҽԺ
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: $g("��ѡ����ҪҽԺ!"),
			type: "alert"
		});
		return false;
	}
	// ǰ̨��֤
	if (GridEndEidting("gridSkinTest") == false) {
		return;
	}
	var changeData = GetChangeData("gridSkinTest");
	if (changeData.length == 0) {
		return;
	}
	var jsonDataStr = JSON.stringify(changeData);
	// ����
	var retStr = $.cm({
		ClassName: 'PHA.IN.SkinTest.Save',
		MethodName: 'SaveMulti',
		jsonDataStr: jsonDataStr,
		hospId: hospId,
		dataType: 'text'
	}, false);
	AfterRunServer(retStr, function () {
		Query();
		ShowSelectedItem({});
		$("#gridSkinTestItm").datagrid("clear");
	});
}

function Delete() {
	// ��ȡҽԺ
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: $g("��ѡ����ҪҽԺ!"),
			type: "alert"
		});
		return false;
	}
	// Ҫɾ����ID
	var selectedRow = $("#gridSkinTest").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: $g("��ѡ����Ҫɾ������Ŀ!"),
			type: "alert"
		});
		return;
	}
	var pist = selectedRow.pist || "";
	// ɾ��ȷ��
	PHA.Confirm($g("ɾ����ʾ"), $g("�Ƿ�ȷ��ɾ������Ŀ?"), function () {
		if (pist == "") {
			var rowIndex = $("#gridSkinTest").datagrid('getRowIndex', selectedRow);
			$("#gridSkinTest").datagrid('deleteRow', rowIndex);
			var rowsData = $("#gridSkinTest").datagrid('getRows') || [];
			if (rowsData.length == 0) {
				Query();
			}
			return;
		}
		var retStr = $.cm({
			ClassName: 'PHA.IN.SkinTest.Save',
			MethodName: 'Delete',
			pist: pist,
			hospId: hospId,
			dataType: 'text'
		}, false);
		AfterRunServer(retStr, function () {
			Query();
			ShowSelectedItem({});
			$("#gridSkinTestItm").datagrid("clear");
		});
	});
}

/**
 * @description: ����Ƥ����ҩCRUD����
 */
function QueryItm(rowIndex) {
	var pist = "";
	if (rowIndex >= 0) {
		var rowsData = $("#gridSkinTest").datagrid("getRows") || [];
		if (rowsData.length > rowIndex) {
			pist = rowsData[rowIndex]["pist"] || "";
		}
	} else {
		var selectedRow = $("#gridSkinTest").datagrid("getSelected") || {};
		pist = selectedRow.pist || "";
	}
	if (pist == "") {
		return;
	}
	var inputStr = pist;
	$("#gridSkinTestItm").datagrid('query', {
		inputStr: inputStr
	});
}

function AddItm() {
	var selectedRow = $("#gridSkinTest").datagrid("getSelected") || {};
	var pist = selectedRow.pist || "";
	if (pist == "") {
		PHA.Popover({
			msg: $g("δѡ����Ŀ��ѡ�����Ŀû�б���!"),
			type: "alert"
		});
		return;
	}
	var startDate = tkMakeServerCall("PHA.IN.SkinTest.Query", "GetDate", "t");
	
	PHA_GridEditor.Add({
		gridID: 'gridSkinTestItm',
		field: 'itemType',
		rowData: {
			pist: pist,
			resultFlag: 'Y',
			autoInsFlag: 'Y',
			startDate: startDate
		}
	});
}

function SaveItm() {
	// ǰ̨��֤
	if (GridEndEidting("gridSkinTestItm") == false) {
		return;
	}
	var changeData = GetChangeData("gridSkinTestItm");
	if (changeData.length == 0) {
		return;
	}
	// ȡ�������(���ں�̨��֤�������)
	var rowsData = $("#gridSkinTestItm").datagrid('getRows');
	var maxRows = rowsData.length;
	for (var i = 0; i < changeData.length; i++) {
		changeData[i].maxRows = maxRows;
	}
	var jsonDataStr = JSON.stringify(changeData);
	// ����
	var retStr = $.cm({
		ClassName: 'PHA.IN.SkinTest.Save',
		MethodName: 'SaveItmMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	AfterRunServer(retStr, QueryItm);
}

function DeleteItm() {
	// Ҫɾ����ID
	var selectedRow = $("#gridSkinTestItm").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: $g("��ѡ����Ҫɾ������Ŀ!"),
			type: "alert"
		});
		return;
	}
	var pisti = selectedRow.pisti || "";
	// ɾ��ȷ��
	PHA.Confirm($g("ɾ����ʾ"), $g("�Ƿ�ȷ��ɾ������Ŀ?"), function () {
		var rowIndex = $("#gridSkinTestItm").datagrid('getRowIndex', selectedRow);
		if (pisti == "") {
			$("#gridSkinTestItm").datagrid('deleteRow', rowIndex);
			return;
		}
		var retStr = $.cm({
			ClassName: 'PHA.IN.SkinTest.Save',
			MethodName: 'DeleteItm',
			pisti: pisti,
			rowIndex: rowIndex,
			dataType: 'text'
		}, false);
		AfterRunServer(retStr, QueryItm);
	});
}

/**
 * @description: ����Ϊ�������̷���
 */
function GetItemType() {
	var checkedRadioObj = $("input[name='itemType']:checked");
	var itemType = checkedRadioObj == undefined ? "" : checkedRadioObj.val();
	if (itemType == "" || itemType == undefined) {
		PHA.Popover({
			msg: $g("��ѡ�񱣴�����!"),
			type: "alert",
			timeout: 1000
		});
		return false;
	}
	return itemType;
}

function GridEndEidting(_gridID) {
	var isEndEidting = $("#" + _gridID).datagrid("endEditing");
	if (!isEndEidting) {
		PHA.Popover({
			msg: $g("δ���������,�޷���ɱ༭!"),
			type: "alert",
			timeout: 1000
		});
		return false;
	}
	return true;
}

function GetChangeData(_gridID) {
	var changeData = $("#" + _gridID).datagrid("getChanges") || [];
	if (changeData.length == 0) {
		PHA.Popover({
			msg: $g("û����Ҫ���������!"),
			type: "error",
			timeout: 1000
		});
		return [];
	}
	return changeData;
}

function AfterRunServer(retStr, succCallFn, errCallFn) {
	var retArr = retStr.split("^");
	var retVal = retArr[0];
	var retInfo = retArr[1];
	if (retVal < 0) {
		PHA.Alert($g("��ʾ"), retInfo, retVal);
		if (errCallFn) {
			errCallFn();
		}
	} else {
		PHA.Popover({
			msg: retInfo || $g("�ɹ�!"),
			type: "success",
			timeout: 500
		});
		if (succCallFn) {
			succCallFn();
		}
	}
}

// ��ʾ��ǰ��Ŀ
function ShowSelectedItem(rowData) {
	var curSelectedItem = $g("��ǰѡ����Ŀ: ");
	var itemDesc = rowData.itemDesc || "";
	if (itemDesc != "") {
		curSelectedItem += itemDesc;
	}
	$("#curSelectedItem").text(curSelectedItem);
}

/*
 * ���¶�����༭��
 */
function CheckBoxEditor() {
	return {
		type: 'icheckbox',
		options: {
			on: 'Y',
			off: 'N'
		}
	}
}
function CheckBoxFormatter(val, rowData, rowIndex) {
	if (val == "Y") {
		return PHA_COM.Fmt.Grid.Yes.Chinese;
	} else {
		return PHA_COM.Fmt.Grid.No.Chinese;
	}
}

/*
 * @description: ��Ժ������ - ���س�ʼ��ҽԺ
 */
function InitHosp() {
	var hospComp = GenHospComp("PHAIN_SkinTest");
	hospComp.options().onSelect = function (record) {
		console.log(record);
		var selectedRow = $('#gridAlg').datagrid('getSelected');
		if (selectedRow == null) {
			var rowsData = $('#gridAlg').datagrid('getRows');
			if (rowsData.length == 0) {
				return;
			}
			$('#gridAlg').datagrid('selectRow', 0);
		}
		Query();
	}
}

/*
 * @description: ����������Ϣ
 */
function OpenHelpWin(helpInfo) {
	var hasScroll = false;
	if (helpInfo == 1) {
		helpInfo = GetSkinTestHelpHtml();
		hasScroll = true;
	}
	if (helpInfo == 2) {
		helpInfo = GetSkinTestItmHelpHtml();
		hasScroll = true;
	}
	var winId = "skintest_helpWin";
	var winContentId = "skintest_helpWin" + "_" + "content";
	if ($('#' + winId).length == 0) {
		$("<div id='" + winId + "'></div>").appendTo("body");
		$('#' + winId).dialog({
			width: 600,
			height: 400,
			modal: true,
			title: $g('����'),
			iconCls: 'icon-w-list',
			content: "<div id='" + winContentId + "'style='margin:5px 10px 0px 10px;'></div>",
			closable: true
		});
	}
	$('#' + winContentId).width($('#' + winContentId).parent().width() - (hasScroll ? 38 : 20));
	$('#' + winContentId).height($('#' + winContentId).parent().height() - 20);
	$('#' + winContentId).html(helpInfo);
	$('#' + winId).dialog('open');
}

function GetSkinTestHelpHtml() {
	var skinTestHelpHtml = "";
	skinTestHelpHtml += GetTitle($g("1����Ŀ���ƣ�"));
	skinTestHelpHtml += GetContent($g("����ԭ�°�����ЩҩƷ�����԰�ҽ����壬Ҳ���԰�ͨ�������壬����ֻ�ܰ�һ�ֶ��壬����ͬʱ���塣"));
	skinTestHelpHtml += GetTitle($g("2��ʱЧ��"));
	skinTestHelpHtml += GetContent($g("��ҩƷ�ж϶೤ʱ���ڵ�Ƥ�Խ������ҩ��¼��"));
	skinTestHelpHtml += GetTitle($g("3������������"));
	skinTestHelpHtml += GetContent($g("��ҩƷ�Ƿ�����������ơ�"));
	skinTestHelpHtml += GetTitle($g("4���������ԣ�"));
	skinTestHelpHtml += GetContent($g("��ҩƷ�Ƿ�������ԡ�"));
	skinTestHelpHtml += GetTitle($g("5��Ĭ�����ԣ�"));
	skinTestHelpHtml += GetContent($g("��ҽ������Ƥ�Կ�ʱ��Ĭ�Ϲ�ѡ���ԣ������ý����������Ե�����²��ܹ�ѡ��������Ƥ�����Լ�¼�������¼��������ͬҩѧ����Ĺ�����¼���Ƚ������Ƶ��������Ч��"));
	skinTestHelpHtml += GetTitle($g("6���������⣺"));
	skinTestHelpHtml += GetContent($g("��ѡ������ҩƷ����Ƥ�Խ���Կ��Խɷ�/��ҩ�����������˷���ҩƷ��ȡһֻ����Ƥ�ԣ�ʣ�µļ������ơ�"));
	return skinTestHelpHtml;
}

function GetSkinTestItmHelpHtml() {
	var skinTestHelpHtml = "";
	skinTestHelpHtml += GetTitle($g("1���������ͣ�"));
	skinTestHelpHtml += GetContent($g("�����򣬿���ѡ�񡰿�/����/����/סԺ��,Ϊ��ʱ����˹���������ȫԺ��ѡ������/����/סԺ�������������õľ������ͣ�������/����/סԺ���͡��ա��Ĺ������ͬʱ���ڣ���ǰ�����ȼ����ߡ�"));
	skinTestHelpHtml += GetTitle($g("2�����ң�"));
	skinTestHelpHtml += GetContent($g("����ѡ��գ���ȫԺ�������߾��忪�����ң����ά���˿��ҵ�����ȡ���Ҷ����Ƥ����ҩ������ȡ�յļ�¼��"));
	skinTestHelpHtml += GetTitle($g("3�����ͣ�"));
	skinTestHelpHtml += GetContent($g("����ҽ����/ͨ������"));
	skinTestHelpHtml += GetTitle($g("4����Ŀ���ƣ�"));
	skinTestHelpHtml += GetContent($g("�ֵ��ͣ�ҽ����Ŀ��ͨ�����������Զ������Ϸ�ͨ������ҽ����ʵ�ֽ�����ϵ�ͨ������ҽ���Ҳ���Զ��忪������ҩʱ�Զ������Ƥ����ҩ��"));
	skinTestHelpHtml += GetTitle($g("5�������־��"));
	skinTestHelpHtml += GetContent($g("��ѡ�򣬹�ѡ��ҩƷ���Զ�����ʱ�����ϡ�Ƥ�Ա�־����OE_OrdItem - OEORI_AdministerSkinTest��,�ǻ�ʿ������Ƥ�Խ����ҽ�������Խ����ý���磺�Ȼ���ע��Һ10ml������Ҫ��Ƥ�Խ����һ��������ҩÿ�־������͹�����Ƥ����ҩ�ġ������־������Ϊ�գ�������һ��ҩƷά������ѡ�˽����־�Ĳ��ܺ��Ϸ���ͨ����/ҽ����ʵ��Ƥ�Խ����ͬ����"));
	skinTestHelpHtml += GetTitle($g("6��ҽ�����ȼ���"));
	skinTestHelpHtml += GetContent($g("�����򣬿���ѡ����ʱҽ��/��ʱ���С����Զ�����Ƥ��ҩƷ��ҽ�����ȼ���Ƥ����ҩ��Ҫ�����շ���ҩ����Ϊ����ʱҽ�������������Ҫ������Ϊ����ʱ���С���"));
	skinTestHelpHtml += GetTitle($g("7��������"));
	skinTestHelpHtml += GetContent($g("��ֵ���ı����Զ�������Ƥ����ҩ�ļ�����"));
	skinTestHelpHtml += GetTitle($g("8����λ��"));
	skinTestHelpHtml += GetContent($g("������ȡ����ҩƷ�ĵ�Ч��λ��"));
	skinTestHelpHtml += GetTitle($g("9��Ƶ�Σ�"));
	skinTestHelpHtml += GetContent($g("�����򣬿���ѡ��ONCE/ST�����Զ�������Ƥ����ҩ��Ƶ�Ρ�"));
	skinTestHelpHtml += GetTitle($g("10��������ţ�"));
	skinTestHelpHtml += GetContent($g("��������ͬ�֡��������͡������ã�Ƥ��ҩƷ������Ҫ����ϡ�����ã����Խ���Զ������ĳ���Ƥ����ҩ�Ĺ�����ϵ��"));
	skinTestHelpHtml += GetTitle($g("11���Զ����룺"));
	skinTestHelpHtml += GetContent($g("ֻ��ҽ�����������Ϊ�Զ����롣����Ϊ�Զ�����ı���ά�����ȼ���������Ƶ�Ρ��÷�����λ�ȡ�"));
	return skinTestHelpHtml;
}

function GetTitle(str, falg) {
	return "<p style='line-height:28.5px'><b>" + str + "</b></p>";
}

function GetContent(str) {
	return "<p style='line-height:28.5px'>&nbsp;&nbsp;&nbsp;&nbsp;" + str + "</p>";
}
