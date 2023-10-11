/**
 * FileName: dhcbill.ipbill.chequeback.js
 * Author: ZhYW
 * Date: 2020-01-02
 * Description: 支票到账
 */

$(function () {
	initQueryMenu();
	initChequeList();
});

function initQueryMenu() {
	$(".datebox-f").datebox("setValue", CV.DefDate);

	$HUI.linkbutton("#btn-export", {
		onClick: function () {
			exportClick();
		}
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			var patientId = getPatIDByPatNo($("#patientNo").val(), $("#medicareNo").val());
			$('#patientId').val(patientId);
			loadChequeList();
		}
	});

	$HUI.linkbutton("#btn-insert", {
		onClick: function () {
			insertClick();
		}
	});

	$HUI.linkbutton("#btn-update", {
		onClick: function () {
			updateClick();
		}
	});

	//修改押金支票信息
	$HUI.linkbutton("#btn-edit", {
		onClick: function () {
			editClick();
		}
	});

	//登记号
	$("#patientNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			$("#medicareNo").val("");
			var patientNo = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "regnocon", PAPMINo: $(e.target).val()}, false);
			$("#patientNo").val(patientNo); 
			var patientId = getPatIDByPatNo($(e.target).val(), "");
			$('#patientId').val(patientId);
			loadChequeList();
		}
	});

	//病案号
	$("#medicareNo").keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			$("#patientNo").val("");
			var patientId = getPatIDByPatNo("", $(e.target).val());
			$('#patientId').val(patientId);
			loadChequeList();
		}
	});

	//支付方式
	$HUI.combobox("#paymode", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCJFBankback&QueryName=QryPayMode&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5
	});

	//是否到账
	$HUI.combobox("#backFlag", {
		panelHeight: 'auto',
		blurValidValue: true,
		valueField: 'value',
		textField: 'text',
		data: [{value: '0', text: $g('是')},
			  {value: '1', text: $g('否')}
		]
	});
}

/**
* 初始化表格
*/
function initChequeList() {
	GV.ChequeList = $HUI.datagrid("#chequeList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		toolbar: '#list-tb',
		className: "web.UDHCJFBankback",
		queryName: "MoneyDetail",
		onColumnsLoad: function (cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["Tcreatdate", "Tdate", "Tupddate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TpaymId", "TdepId", "Tbankbrowid", "TbankDR"]) != -1) {
					cm[i].hidden = true;
				}
				if (cm[i].field == "Tcreattime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tcreatdate + " " + value;
					}
				}
				if (cm[i].field == "Ttime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tdate + " " + value;
					}
				}
				if (cm[i].field == "Tupdatetime") {
					cm[i].formatter = function (value, row, index) {
						return row.Tupddate + " " + value;
					}
				}
				if (cm[i].field == "TFlagId") {
					cm[i].formatter = function (value, row, index) {
						if (value) {
							var color = (value == 0) ? "#21ba45" : "#f16e57";
							return "<font color=\"" + color + "\">" + ((value == 0) ? $g("是") : $g("否")) + "</font>";
						}
					}
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if ($.inArray(cm[i].field, ["Tcreatdate", "Ttime", "Tupdatetime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		onSelect: function (index, row) {
			selectRowHandler(index, row);
		}
	});
}

function selectRowHandler(index, row) {
	setValueById("paymode", row.TpaymId);
	setValueById("remark", row.Tnote);
	setValueById("chequeNo", row.TchequeNo);
	setValueById("backFlag", row.TFlagId);
}

/**
* 加载表格数据
*/
function loadChequeList() {
	var queryParams = {
		ClassName: "web.UDHCJFBankback",
		QueryName: "MoneyDetail",
		stdate: getValueById("stDate"),
		enddate: getValueById("endDate"),
		chequeNo: getValueById("chequeNo"),
		paymode: getValueById("paymode"),
		payflag: getValueById("backFlag"),
		patientId: getValueById("patientId"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore("chequeList", queryParams);
}

/**
* 根据登记号/病案号获取患者主索引
*/
function getPatIDByPatNo(patientNo, medicareNo) {
	return $.m({ ClassName: "web.DHCIPBillReg", MethodName: "GetPatientID", patientNo: patientNo, medicareNo: medicareNo, hospId: PUBLIC_CONSTANT.SESSION.HOSPID }, false);
}

/**
* 到账
*/
function insertClick() {
	var row = GV.ChequeList.getSelected();
	if (!row) {
		$.messager.popover({msg: '请选择支票信息', type: 'info'});
		return;
	}
	var depId = row.TdepId;
	if (!depId) {
		$.messager.popover({msg: '请选择支票信息', type: 'info'});
		return;
	}
	var bankRowId = row.Tbankbrowid;
	if (bankRowId && row.TFlagId == 0) {
		$.messager.popover({msg: '已经有支票到账信息不能再到账', type: 'info'});
		return;
	}
	var backFlag = getValueById("backFlag");
	if (!backFlag) {
		$.messager.popover({msg: '到账标志不能为空', type: 'info'});
		return;
	}
	var depStatus = getPropValById("dhc_sfprintdetail", depId, "prt_status");
	if (depStatus != 1) {
		$.messager.popover({msg: '非正常押金不能到账', type: 'info'});
		return;
	}
	var remark = getValueById("remark");
	var invRowId = "";
	var str = depId + "^" + invRowId + "^" + backFlag + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + remark;
	$.messager.confirm("确认", "确认保存？", function (r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.UDHCJFBankback",
			MethodName: "insertbankb",
			str: str
		}, function (rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: '保存成功', type: 'success'});
				GV.ChequeList.reload();
				return;
			}
			$.messager.popover({msg: '保存失败：' + (myAry[1] || myAry[0]), type: 'error'});
		});
	});
}

/**
* 修改
*/
function updateClick() {
	var row = GV.ChequeList.getSelected();
	if (!row) {
		$.messager.popover({msg: '请选择支票信息', type: 'info'});
		return;
	}
	var bankRowId = row.Tbankbrowid;
	if (!bankRowId) {
		$.messager.popover({msg: '没有支票到账信息不能修改', type: 'info'});
		return;
	}
	var backFlag = getValueById("backFlag");
	if (!backFlag) {
		$.messager.popover({msg: '到账标志不能为空', type: 'info'});
		return;
	}
	var remark = getValueById("remark");
	var str = bankRowId + "^" + backFlag + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + remark;
	$.messager.confirm("确认", "确认修改？", function (r) {
		if (!r) {
			return;
		}
		$.m({
			ClassName: "web.UDHCJFBankback",
			MethodName: "updatebankb",
			str: str
		}, function (rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == 0) {
				$.messager.popover({msg: '修改成功', type: 'success'});
				GV.ChequeList.reload();
				reutrn;
			}
			$.messager.popover({msg: '修改失败：' + (myAry[1] || myAry[0]), type: 'error'});
		});
	});
}

/**
* 修改支票信息
*/
function editClick() {
	var row = GV.ChequeList.getSelected();
	if (!row) {
		$.messager.popover({msg: '请选择要修改的行', type: 'info'});
		return;
	}
	if (row.Tbankbrowid && row.TFlagId == 0) {
		$.messager.popover({msg: '已经到账的信息不允许修改', type: 'info'});
		return;
	}
	var depStatus = getPropValById("dhc_sfprintdetail", row.TdepId, "prt_status");
	if (depStatus != 1) {
		$.messager.popover({msg: '只能修改状态为[正常]的数据', type: 'info'});
		return;
	}
	openAppendDlg(row);
}

//初始化押金支票信息修改对话框
function openAppendDlg(row) {
	$('#appendDlg').dialog({
			title: '支票信息',
			iconCls: 'icon-w-edit',
			width: 400,
			height: 270,
			modal: true,
			onBeforeOpen: function () {
				$HUI.combobox("#WinBank", {
					panelHeight: 150,
					url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QBankList&ResultSetType=array',
					method: 'GET',
					valueField: 'id',
					textField: 'text',
					blurValidValue: true,
					defaultFilter: 5,
					loadFilter: function (data) {
						return data.filter(function (item) {
							return (item.id > 0);
						});
					}
				});
			},
			onOpen: function () {
				setValueById("WinChequeNo", row.TchequeNo);
				setValueById("WinChequeDate", row.TChequeDate);
				setValueById("WinBank", row.TbankDR);
				setValueById("WinAccNo", row.TaccNo);
			},
			buttons: [
				{
					text: '保存',
					handler: function () {
						var bool = true;
                        var id = "";
                        $("#appendDlg label.clsRequired").each(function (index, item) {
                            id = $($(this).parent().next().find("input"))[0].id;
                            if (!id) {
                                return true;
                            }
                            if (!getValueById(id)) {
                                bool = false;
                                focusById(id);
                                $.messager.popover({msg: "请输入<font color=\"red\">" + $(this).text() + "</font>", type: "info"});
                                return false;
                            }
                        });
                        if (!bool) {
                            return;
                        }
						$.messager.confirm("确认", "确认保存？", function (r) {
							if (!r) {
								return;
							}
							var depId = row.TdepId;
							var chequeNo = getValueById("WinChequeNo");
							var chequeDate = getValueById("WinChequeDate");
							var bankId = getValueById("WinBank");
							var accNo = getValueById("WinAccNo");
							var json = {
								Id: depId,
								chequeNo: chequeNo,
								chequeDate: chequeDate,
								bankId: bankId,
								accNo: accNo
							};
							var rtn = $.m({
								ClassName: "web.UDHCJFBankback",
								MethodName: "UpdtDepChequeInfo",
								depStr: JSON.stringify(json),
								sessionStr: getSessionStr()
							}, false);
							var myAry = rtn.split('^');
							if (myAry[0] != 0) {
								$.messager.popover({msg: '保存失败：' + (myAry[1] || myAry[0]), type: 'error'});
								return;
							}
							$.messager.popover({msg: '保存成功', type: 'success'});
							loadChequeList();
							$('#appendDlg').dialog('close');
						});
					}
				},
				{
					text: '关闭',
					handler: function () {
						$('#appendDlg').dialog('close');
					}
				}
			]
		}
	).show();
}

/**
* 导出
*/
function exportClick() {
	//window.open("websys.query.customisecolumn.csp?CONTEXT=Kweb.UDHCJFBankback:MoneyDetail&PREFID=0&PAGENAME=" + page);
	$.cm({
		ResultSetType: "ExcelPlugin",
		ExcelName: "支票到账",
		PageName: page,
		ClassName: "web.UDHCJFBankback",
		QueryName: "MoneyDetail",
		stdate: getValueById("stDate"),
		enddate: getValueById("endDate"),
		chequeNo: getValueById("chequeNo"),
		paymode: getValueById("paymode"),
		payflag: getValueById("backFlag"),
		patientId: getValueById("patientId"),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, false);
}
