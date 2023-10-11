/**
 * 名称:	 药房药库 - 皮试药品配置
 * 编写人:   Huxt
 * 编写日期: 2020-03-19
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
 * @description: 事件绑定初始化
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
 * @description: 初始化字典
 */
function InitDict() {}

/**
 * @description: 表格 - 过敏原
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
				title: $g('过敏原名称'),
				width: 160
			}, {
				field: "rlaAlg",
				descField: 'rlaAlgDesc',
				title: $g('项目'),
				title: $g('关联过敏原'),
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
				title: $g('类型'),
				width: 80
			}, {
				field: 'startDate',
				title: $g('开始日期'),
				width: 100
			}, {
				field: 'endDate',
				title: $g('截止日期'),
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
 * @description: 表格 - 皮试药品
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
				title: $g('过敏原'),
				width: 100,
				hidden: true
			}, {
				field: "itemCode",
				title: $g('项目代码'),
				width: 120
			}, {
				field: "itemId",
				descField: 'itemDesc',
				title: $g('项目'),
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
				title: $g('项目类型'),
				align: "center",
				width: 50,
				hidden: true
			}, {
				field: "validTime",
				title: $g('皮试时效(h)'),
				align: "center",
				width: 90,
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: "desensitFlag",
				title: $g('允许脱敏'),
				align: "center",
				width: 70,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "noTestFlag",
				title: $g('允许免试'),
				align: "center",
				width: 70,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "defNoTest",
				title: $g('默认免试'),
				align: "center",
				width: 70,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "exceptionFlag",
				title: $g('控制例外'),
				align: "center",
				width: 70,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "startDate",
				title: $g('开始日期'),
				align: "center",
				width: 100,
				editor: PHA_GridEditor.DateBox({})
			}, {
				field: "endDate",
				title: $g('结束日期'),
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
 * @description: 表格 - 皮试关联药品
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
				title: $g('就诊类型'),
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
				title: $g('科室'),
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
				title: $g('项目类型'),
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
				title: $g('项目'),
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
				title: $g('结果标志'),
				align: "center",
				width: 80,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "priID",
				descField: 'priDesc',
				title: $g('优先级'),
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
				title: $g('剂量'),
				align: "center",
				width: 80,
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: "unitID",
				descField: 'unitDesc',
				title: $g('剂量单位'),
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
				title: $g('频次'),
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
				title: $g('用法'),
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
				title: $g('关联'),
				align: "center",
				width: 80,
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				field: "autoInsFlag",
				title: $g('自动插入'),
				align: "center",
				width: 80,
				formatter: CheckBoxFormatter,
				editor: PHA_GridEditor.CheckBox({})
			}, {
				field: "startDate",
				title: $g('开始日期'),
				align: "center",
				width: 120,
				editor: PHA_GridEditor.DateBox({})
			}, {
				field: "endDate",
				title: $g('截止日期'),
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
 * @description: 过敏原CRUD操作
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
	// 保存
	var retStr = $.cm({
		ClassName: 'PHA.IN.SkinTest.Save',
		MethodName: 'SaveAlgMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	AfterRunServer(retStr, QueryAlg);
}

/**
 * @description: 皮试药品CRUD操作
 */
function Query() {
	// 获取医院
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
	// 单选
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
			msg: $g("请选择过敏原!"),
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
	// 获取医院
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: $g("请选择需要医院!"),
			type: "alert"
		});
		return false;
	}
	// 前台验证
	if (GridEndEidting("gridSkinTest") == false) {
		return;
	}
	var changeData = GetChangeData("gridSkinTest");
	if (changeData.length == 0) {
		return;
	}
	var jsonDataStr = JSON.stringify(changeData);
	// 保存
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
	// 获取医院
	var hospId = $('#_HospList').combogrid('getValue') || "";
	if (hospId == "") {
		PHA.Popover({
			msg: $g("请选择需要医院!"),
			type: "alert"
		});
		return false;
	}
	// 要删除的ID
	var selectedRow = $("#gridSkinTest").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: $g("请选择需要删除的项目!"),
			type: "alert"
		});
		return;
	}
	var pist = selectedRow.pist || "";
	// 删除确认
	PHA.Confirm($g("删除提示"), $g("是否确认删除该项目?"), function () {
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
 * @description: 关联皮试用药CRUD操作
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
			msg: $g("未选择项目或选择的项目没有保存!"),
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
	// 前台验证
	if (GridEndEidting("gridSkinTestItm") == false) {
		return;
	}
	var changeData = GetChangeData("gridSkinTestItm");
	if (changeData.length == 0) {
		return;
	}
	// 取最大行数(用于后台验证关联序号)
	var rowsData = $("#gridSkinTestItm").datagrid('getRows');
	var maxRows = rowsData.length;
	for (var i = 0; i < changeData.length; i++) {
		changeData[i].maxRows = maxRows;
	}
	var jsonDataStr = JSON.stringify(changeData);
	// 保存
	var retStr = $.cm({
		ClassName: 'PHA.IN.SkinTest.Save',
		MethodName: 'SaveItmMulti',
		jsonDataStr: jsonDataStr,
		dataType: 'text'
	}, false);
	AfterRunServer(retStr, QueryItm);
}

function DeleteItm() {
	// 要删除的ID
	var selectedRow = $("#gridSkinTestItm").datagrid("getSelected");
	if (selectedRow == null) {
		PHA.Popover({
			msg: $g("请选择需要删除的项目!"),
			type: "alert"
		});
		return;
	}
	var pisti = selectedRow.pisti || "";
	// 删除确认
	PHA.Confirm($g("删除提示"), $g("是否确认删除该项目?"), function () {
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
 * @description: 以下为公共过程方法
 */
function GetItemType() {
	var checkedRadioObj = $("input[name='itemType']:checked");
	var itemType = checkedRadioObj == undefined ? "" : checkedRadioObj.val();
	if (itemType == "" || itemType == undefined) {
		PHA.Popover({
			msg: $g("请选择保存类型!"),
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
			msg: $g("未填入必填项,无法完成编辑!"),
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
			msg: $g("没有需要保存的数据!"),
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
		PHA.Alert($g("提示"), retInfo, retVal);
		if (errCallFn) {
			errCallFn();
		}
	} else {
		PHA.Popover({
			msg: retInfo || $g("成功!"),
			type: "success",
			timeout: 500
		});
		if (succCallFn) {
			succCallFn();
		}
	}
}

// 显示当前项目
function ShowSelectedItem(rowData) {
	var curSelectedItem = $g("当前选择项目: ");
	var itemDesc = rowData.itemDesc || "";
	if (itemDesc != "") {
		curSelectedItem += itemDesc;
	}
	$("#curSelectedItem").text(curSelectedItem);
}

/*
 * 以下定义表格编辑器
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
 * @description: 多院区配置 - 加载初始化医院
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
 * @description: 帮助窗口信息
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
			title: $g('帮助'),
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
	skinTestHelpHtml += GetTitle($g("1、项目名称："));
	skinTestHelpHtml += GetContent($g("过敏原下包含哪些药品，可以按医嘱项定义，也可以按通用名定义，但是只能按一种定义，不能同时定义。"));
	skinTestHelpHtml += GetTitle($g("2、时效："));
	skinTestHelpHtml += GetContent($g("该药品判断多长时间内的皮试结果或用药记录。"));
	skinTestHelpHtml += GetTitle($g("3、允许脱敏："));
	skinTestHelpHtml += GetContent($g("该药品是否可以脱敏治疗。"));
	skinTestHelpHtml += GetTitle($g("4、允许免试："));
	skinTestHelpHtml += GetContent($g("该药品是否可以免试。"));
	skinTestHelpHtml += GetTitle($g("5、默认免试："));
	skinTestHelpHtml += GetContent($g("开医嘱弹出皮试框时会默认勾选免试，该配置仅在允许免试的情况下才能勾选。当存在皮试阳性记录或过敏记录（不包括同药学分类的过敏记录）等禁用治疗的情况下无效。"));
	skinTestHelpHtml += GetTitle($g("6、控制例外："));
	skinTestHelpHtml += GetContent($g("勾选后治疗药品不置皮试结果仍可以缴费/发药。适用于破伤风类药品，取一只先做皮试，剩下的继续治疗。"));
	return skinTestHelpHtml;
}

function GetSkinTestItmHelpHtml() {
	var skinTestHelpHtml = "";
	skinTestHelpHtml += GetTitle($g("1、就诊类型："));
	skinTestHelpHtml += GetContent($g("下拉框，可以选择“空/门诊/急诊/住院”,为空时代表此规则适用于全院，选择“门诊/急诊/住院”代表规则仅适用的就诊类型，“门诊/急诊/住院”和“空”的规则可以同时存在，但前者优先级更高。"));
	skinTestHelpHtml += GetTitle($g("2、科室："));
	skinTestHelpHtml += GetContent($g("可以选择空（即全院），或者具体开单科室，如果维护了科室的优先取科室定义的皮试用药，否则取空的记录。"));
	skinTestHelpHtml += GetTitle($g("3、类型："));
	skinTestHelpHtml += GetContent($g("包含医嘱项/通用名。"));
	skinTestHelpHtml += GetTitle($g("4、项目名称："));
	skinTestHelpHtml += GetContent($g("字典型（医嘱项目或通用名），可以定义与上方通用名或医嘱项实现结果互认的通用名或医嘱项；也可以定义开治疗用药时自动插入的皮试用药。"));
	skinTestHelpHtml += GetTitle($g("5、结果标志："));
	skinTestHelpHtml += GetContent($g("单选框，勾选的药品在自动产生时会置上“皮试标志”（OE_OrdItem - OEORI_AdministerSkinTest）,是护士操作置皮试结果的医嘱，用以解决溶媒（如：氯化钠注射液10ml）不需要置皮试结果。一个治疗用药每种就诊类型关联的皮试用药的“结果标志”不能为空，至少有一种药品维护。勾选了结果标志的才能和上方的通用名/医嘱项实现皮试结果的同步。"));
	skinTestHelpHtml += GetTitle($g("6、医嘱优先级："));
	skinTestHelpHtml += GetContent($g("下拉框，可以选择“临时医嘱/临时嘱托”，自动产生皮试药品的医嘱优先级，皮试用药需要单独收费领药配置为“临时医嘱”，如果不需要则设置为“临时嘱托”。"));
	skinTestHelpHtml += GetTitle($g("7、剂量："));
	skinTestHelpHtml += GetContent($g("数值型文本框，自动产生的皮试用药的剂量。"));
	skinTestHelpHtml += GetTitle($g("8、单位："));
	skinTestHelpHtml += GetContent($g("下拉框，取配置药品的等效单位。"));
	skinTestHelpHtml += GetTitle($g("9、频次："));
	skinTestHelpHtml += GetContent($g("下拉框，可以选择“ONCE/ST”，自动产生的皮试用药的频次。"));
	skinTestHelpHtml += GetTitle($g("10、关联序号："));
	skinTestHelpHtml += GetContent($g("仅适用于同种“就诊类型”的配置，皮试药品多数需要糖盐稀释配置，用以解决自动产生的成组皮试用药的关联关系。"));
	skinTestHelpHtml += GetTitle($g("11、自动插入："));
	skinTestHelpHtml += GetContent($g("只有医嘱项才能配置为自动插入。配置为自动插入的必须维护优先级、剂量、频次、用法、单位等。"));
	return skinTestHelpHtml;
}

function GetTitle(str, falg) {
	return "<p style='line-height:28.5px'><b>" + str + "</b></p>";
}

function GetContent(str) {
	return "<p style='line-height:28.5px'>&nbsp;&nbsp;&nbsp;&nbsp;" + str + "</p>";
}
