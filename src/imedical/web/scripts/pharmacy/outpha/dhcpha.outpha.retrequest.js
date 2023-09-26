/**
 * ģ��:     ������ҩ����(Ѻ��ģʽ)
 * ��д����: 2018-10-22
 * ��д��:   DingHongying
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
	// ����������
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
					title: '������',
					width: 130,
					sortable: true,
					hidden: false
				}, {
					field: 'recLocDesc',
					title: '���տ���',
					width: 100,
					sortable: true
				}, {
					field: 'admDate',
					title: '��������',
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

// ��ȡ����
function QueryParams() {
	var retReason = $('#cmbRetReason').combobox("getValue");
	var patNo = $('#txtPatNo').val().trim();
	var prescNo = $('#cmgPrescNo').combogrid("getValue");
	var patName = $('#txtPatName').val().trim();
	return prescNo;
}
// ��ѯ
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

// ���뵥��ϸ�б�
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
				title: 'ҩ������',
				width: 150,
				align: 'left'
			}, {
				field: 'TPrescNo',
				title: '������',
				width: 150,
				align: 'left'
			}, {
				field: 'TPrtInv',
				title: 'ԭ�վݺ�',
				width: 120,
				hidden: true
			}, {
				field: 'TPhDesc',
				title: 'ҩƷ����',
				width: 240,
				align: 'left'
			}, {
				field: 'TPhQty',
				title: '����',
				width: 90,
				align: 'left'
			}, {
				field: 'TPhPrice',
				title: '����',
				width: 90,
				align: 'right'
			}, {
				field: 'TReqQty',
				title: '��������',
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
				title: '������',
				width: 100,
				align: 'right',
				hidden: true
			}, {
				field: 'TPhUomDesc',
				title: '��λ',
				width: 100,
				align: 'left'
			}, {
				field: 'TCantRetReason',
				title: '������ҩԭ��',
				width: 120,
				align: 'left'
			}, {
				field: 'TCyFlag',
				title: '��ҩ������־',
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
		$.messager.alert("��ʾ", "����ɹ�", "info");
		//Query();
		Clear();
	} else {
		$.messager.alert("��ʾ", "����ʧ�ܣ�ʧ��ԭ��" + retMessage, "warning");
		return;
	}
}
// ��ȡ��Ч��¼
function GetSaveParams() {
	$('#gridRequest').datagrid('endEditing');
	var gridChanges = $('#gridRequest').datagrid('getChanges');
	var gridChangeLen = gridChanges.length;
	if (gridChangeLen == 0) {
		$.messager.alert("��ʾ", "û����Ҫ���������", "info");
		return "";
	}

	var reason = $('#cmbRetReason').combobox("getValue");
	if (reason == "") {
		$.messager.alert("��ʾ", "��ѡ����ҩԭ��", "warning");
		return "";
	}

	//��֤��ҩ�������ܵ�����
	var mainRecLoc = "";
	var mainPhd = "";
	var grids = $("#gridRequest").datagrid('getRows');
	for (var j = 0; j < grids.length; j++) {
		var jData = grids[j];
		var reqQty = jData.TReqQty || "";
		var cyFlag = jData.TCyFlag || "";
		if ((cyFlag == "Y") && ((reqQty == "") || (reqQty == null))) {
			$.messager.alert("��ʾ", "��" + (j + 1) + "����������Ϊ�ջ򲻵��ڷ�ҩ��������ҩ��������ȫ��", "warning");
			return "";
		}
		var cantretreason = jData.TCantRetReason || "";
		if (cantretreason != "") {
			$.messager.alert("��ʾ", "��" + (j + 1) + "��ҩƷά���˲�����ҩԭ��", "warning");
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
		$.messager.alert("��ʾ", "δ��ȡ�������Ľ��տ��һ�ҩ����ID", "warning");
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
		$.messager.alert("��ʾ", "�޿��õ�������ϸ����", "warning");
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

// ������ʹ����չ
function InitExtend() {
	$.extend($.fn.validatebox.defaults.rules, {
		// �Ƿ�����
		CheckNumber: {
			validator: function (value, param) {
				//var regTxt = /^[0-9]+\.?[0-9]{0,9}$/;
				var regTxt = /^[0-9]+\d*$/;
				if (regTxt.test(value) == false) {
					return false;
				} else {
					// ������getSelected
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
			message: '����������Ϊ����0,��С�ڵ��ڿ�����������������'
		},
		// �Ƿ��ҩ�������˲�����
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
			message: '��ҩ�������ܲ�����,��������������ڿ���������'
		}
	});
}
