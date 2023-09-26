/**
 * 模块:     留观退药申请(押金模式)
 * 编写日期: 2018-10-22
 * 编写人:   DingHongying
 */
var SessionLoc = session['LOGON.CTLOCID'];
var SessionUser = session['LOGON.USERID'];
var PatNoLen = DHCPHA_STORE.Constant.PatNoLen;
$(function () {
	if (LoadAdmId != "") {
		var patInfo = tkMakeServerCall("PHA.COM.Order", "GetPatByAdm", LoadAdmId);
		$("#txtPatNo").val(patInfo.split("^")[0] || "");
		$("#txtPatName").val(patInfo.split("^")[1] || "");
	}
	InitDict();
	InitExtend();
	InitGridRequest();
	$('#txtPatNo').on('keypress', function (event) {
		if (window.event.keyCode == "13") {
			var patNo = $.trim($("#txtPatNo").val());
			if (patNo != "") {
				var newPatNo = DHCPHA_TOOLS.PadZero(patNo, PatNoLen);
				$(this).val(newPatNo);
				var patInfo = tkMakeServerCall("PHA.COM.Order", "GetPatByNo", newPatNo);
				$("#txtPatName").val(patInfo.split("^")[0] || "");
			} else {
				$("#txtPatName").val("");
			}
			$("#cmgPrescNo").combogrid("grid").datagrid("reload");

		}
	});
	$("#btnFind").on("click", Query);
	$("#btnClear").on("click", Clear);
	$("#btnRefund").on("click", Refund);
	window.resizeTo(screen.availWidth - 6, (screen.availHeight - 100));
	window.moveTo(3, 90);
});

function InitDict() {
	DHCPHA_HUI_COM.ComboBox.Init({
		Id: 'cmbRetReason',
		Type: 'RetReason'
	}, {
		width: 154,
		onBeforeLoad: function (param) {}
	});
	// 处方号下拉
	var prescOpts = {
		QueryParams: {
			ClassName: "PHA.OP.RetReq.Query",
			QueryName: "GetPrescForReq",
			inputStr: $("#txtPatNo").val() + "^" + session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID']
		},
		pageNumber: 0,
		panelWidth: 400,
		pagination: true,
		columns: [
			[{
					field: 'prescNo',
					title: '处方号',
					width: 130,
					sortable: true,
					hidden: false
				}, {
					field: 'recLocDesc',
					title: '接收科室',
					width: 100,
					sortable: true
				}, {
					field: 'admDate',
					title: '就诊日期',
					width: 100,
					sortable: true
				},
			]
		],
		idField: 'prescNo',
		textField: 'prescNo',
		editable: false,
		onBeforeLoad: function (param) {
			param.inputStr = $("#txtPatNo").val() + "^" + session['LOGON.USERID'] + "^" + session['LOGON.CTLOCID'];
		},
		onSelect: function (rowIndex, rowData) {
			Query();
		}
	}
	DHCPHA_HUI_COM.ComboGrid.Init({
		Id: 'cmgPrescNo'
	}, prescOpts);
}

// 获取参数
function QueryParams() {
	var retReason = $('#cmbRetReason').combobox("getValue");
	var patNo = $('#txtPatNo').val().trim();
	var prescNo = $('#cmgPrescNo').combogrid("getValue");
	var patName = $('#txtPatName').val().trim();
	return prescNo;
}
// 查询
function Query() {
	var params = QueryParams();
	$('#gridRequest').datagrid({
		url: $URL,
		queryParams: {
			ClassName: "PHA.OP.RetReq.Query",
			QueryName: "QueryRequest",
			CPrtInv: "",
			CPresc: params
		}
	});
}

// 申请单明细列表
function InitGridRequest() {
	var columns = [
		[{
				field: 'TPhdRowid',
				title: 'TPhdRowid',
				width: 150,
				hidden: true
			}, {
				field: 'TPhLoc',
				title: 'TPhLoc',
				width: 150,
				hidden: true
			}, {
				field: 'TPrt',
				title: 'TPrt',
				width: 150,
				hidden: true
			}, {
				field: 'TNewPrt',
				title: 'TNewPrt',
				width: 150,
				hidden: true
			}, {
				field: 'TPhdSub',
				title: 'TPhdSub',
				width: 150,
				hidden: true
			}, {
				field: 'TPhLocDesc',
				title: '药房名称',
				width: 150,
				align: 'left'
			}, {
				field: 'TPrescNo',
				title: '处方号',
				width: 150,
				align: 'left'
			}, {
				field: 'TPrtInv',
				title: '原收据号',
				width: 120,
				hidden: true
			}, {
				field: 'TPhDesc',
				title: '药品名称',
				width: 240,
				align: 'left'
			}, {
				field: 'TPhQty',
				title: '数量',
				width: 90,
				align: 'left'
			}, {
				field: 'TPhPrice',
				title: '单价',
				width: 90,
				align: 'right'
			}, {
				field: 'TReqQty',
				title: '申请数量',
				width: 100,
				align: 'left',
				editor: {
					type: 'validatebox',
					options: {
						required: true,
						validType: ['CheckNumber', 'CheckCyPresc']
					}
				}
			}, {
				field: 'TReqMoney',
				title: '申请金额',
				width: 100,
				align: 'right',
				hidden: true
			}, {
				field: 'TPhUomDesc',
				title: '单位',
				width: 100,
				align: 'left'
			}, {
				field: 'TCantRetReason',
				title: '不可退药原因',
				width: 120,
				align: 'left'
			}, {
				field: 'TCyFlag',
				title: '草药处方标志',
				width: 30,
				align: 'left',
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: "",
		fit: true,
		border: false,
		singleSelect: false,
		selectOnCheck: false,
		checkOnSelect: false,
		rownumbers: false,
		columns: columns,
		pageSize: 50,
		pageList: [50, 100, 300, 500],
		pagination: true,
		toolbar: '#gridRequestBar',
		onClickRow: function (rowIndex, rowData) {
			$(this).datagrid('beginEditRow', {
				rowIndex: rowIndex,
				editField: 'TReqQty'
			});
		},
		onSelect: function (rowIndex, rowData) {},
		onUnselect: function (rowIndex, rowData) {},
		onLoadSuccess: function () {
			$('#gridRequest').datagrid('uncheckAll');
		}
	}

	DHCPHA_HUI_COM.Grid.Init("gridRequest", dataGridOption);

}

function Refund() {
	var paramsStr = GetSaveParams();
	if (paramsStr == "") {
		return;
	}
	var saveRetArr = paramsStr.split("&&");
	var mainStr = saveRetArr[0];
	var detailStr = saveRetArr[1];
	var saveRet = tkMakeServerCall("PHA.OP.RetReq.OperTab", "Save", mainStr, detailStr);
	var retCode = saveRet.split("^")[0];
	var retMessage = saveRet.split("^")[1];
	if (retCode > 0) {
		$.messager.alert("提示", "申请成功", "info");
		//Query();
		Clear();
	} else {
		$.messager.alert("提示", "申请失败，失败原因：" + retMessage, "warning");
		return;
	}
}
// 获取有效记录
function GetSaveParams() {
	$('#gridRequest').datagrid('endEditing');
	var gridChanges = $('#gridRequest').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("提示", "没有需要保存的数据", "info");
		return "";
	}

	var reason = $('#cmbRetReason').combobox("getValue");
	if (reason == "") {
		$.messager.alert("提示", "请选择退药原因", "warning");
		return "";
	}

	//验证草药处方不能单条退
	var mainRecLoc = "";
	var mainPhd = "";
	var grids = $("#gridRequest").datagrid('getRows');
	for (var j = 0; j < grids.length; j++) {
		var jData = grids[j];
		var reqQty = jData.TReqQty || "";
		var cyFlag = jData.TCyFlag || "";
		if ((cyFlag == "Y") && ((reqQty == "") || (reqQty == null))) {
			$.messager.alert("提示", "第" + (j + 1) + "条申请数量为空或不等于发药数量，草药处方必须全退", "warning");
			return "";
		}
		var cantretreason = jData.TCantRetReason || "";
		if (cantretreason != "") {
			$.messager.alert("提示", "第" + (j + 1) + "条药品维护了不可退药原因", "warning");
			return "";
		}
		var phd = jData.TPhdRowid || "";
		if (mainPhd == "") {
			mainPhd = phd;
		}
		var recloc = jData.TPhLoc || "";
		if (mainRecLoc == "") {
			mainRecLoc = recloc;
		}
	}

	if ((mainRecLoc == "") || (mainPhd == "")) {
		$.messager.alert("提示", "未获取到处方的接收科室或发药主表ID", "warning");
		return "";
	}

	var retReason = $('#cmbRetReason').combobox("getValue");
	var prescNo = $('#cmgPrescNo').combogrid("getValue");
	var userId = SessionUser;
	var appType = "OUTPH";
	var mainStr = prescNo + "^" + retReason + "^" + userId + "^" + appType + "^" + mainRecLoc + "^" + mainPhd;
	var paramsStr = "";
	for (var i = 0; i < gridChangeLen; i++) {
		var iData = gridChanges[i];
		var phdItmLbId = iData.TPhdSub || "";
		var reqQty = iData.TReqQty || "";
		if (reqQty == 0) {
			continue;
		}
		var staus = "";
		var InsRowID = "";
		var iParams = staus + "^" + phdItmLbId + "^" + reqQty + "^" + InsRowID;
		paramsStr = (paramsStr == "") ? iParams : paramsStr + "," + iParams;
	}
	if (paramsStr == "") {
		$.messager.alert("提示", "无可用的申请明细数据", "warning");
		return "";
	}
	return mainStr + "&&" + paramsStr;
}

function Clear() {
	$("#gridRequest").datagrid("clear");
	$("#cmbRetReason").combobox("setValue", "");
	$("#cmgPrescNo").combogrid("clear");
	$("#cmgPrescNo").combogrid("grid").datagrid("reload");
}

// 本界面使用扩展
function InitExtend() {
	$.extend($.fn.validatebox.defaults.rules, {
		// 是否正数
		CheckNumber: {
			validator: function (value, param) {
				//var regTxt = /^[0-9]+\.?[0-9]{0,9}$/;
				var regTxt = /^[0-9]+\d*$/;
				if (regTxt.test(value) == false) {
					return false;
				} else {
					// 不能用getSelected
					var curRow = $("[class='datagrid-editable-input validatebox-text']").parents(".datagrid-row").attr("datagrid-row-index") || "";
					if (curRow == "") {
						return true;
					}
					var rowData = $("#gridRequest").datagrid("getRows")[curRow];
					var cyFlag = rowData.TCyFlag;
					if (cyFlag == "Y") {
						return true;
					}
					var canRetQty = rowData.TPhQty;
					if ((1 * value) > (1 * canRetQty)) {
						return false;
					}
					return true;
				}
			},
			message: '申请数量需为大于0,且小于等于可退数量的正整数！'
		},
		// 是否草药处方作了部分退
		CheckCyPresc: {
			validator: function (value, param) {
				var curRow = $("[class='datagrid-editable-input validatebox-text']").parents(".datagrid-row").attr("datagrid-row-index") || "";
				if (curRow == "") {
					return true;
				}
				var rowData = $("#gridRequest").datagrid("getRows")[curRow];
				var cyFlag = rowData.TCyFlag;
				if (cyFlag != "Y") {
					return true;
				}
				var canRetQty = rowData.TPhQty;
				if ((cyFlag == "Y") && ((1 * value) != (1 * canRetQty))) {
					return false;
				}
				return true;
			},
			message: '草药处方不能部分退,申请数量必须等于可退数量！'
		}
	});
}
