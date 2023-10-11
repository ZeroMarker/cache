/**
 * FileName: dhcbill.opbill.directrefaudit.js
 * Author: ZhYW
 * Date: 2022-03-28
 * Description: 门诊直接退费审核
 */

$(function() {
    initQueryMenu();
	initInvList();
});

function initQueryMenu () {
    $(".datebox-f").datebox("setValue", CV.DefDate);

	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadInvList();
		}
	});

	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});

	//卡号回车查询事件
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});

	//发票回车查询事件
	$("#invNo").keydown(function (e) {
		invNoKeydown(e);
	});
};

function initInvList () {
    GV.InvList = $HUI.datagrid("#invList", {
        fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		columns: [[{title: '发票号', field: 'TINVNO', width: 110},
				   {title: '登记号', field: 'TPatID', width: 110},
				   {title: '患者姓名', field: 'TPatName', width: 100},
				   {title: '费用总额', field: 'TotSum', align: 'right', width: 90},
				   {title: '自付金额', field: 'TAcount', align: 'right', width: 90},
				   {title: '收费员', field: 'TUser', width: 90},
				   {title: '收费时间', field: 'TDate', width: 155,
					formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.TTime;
						}
					}
				   },
				   {title: 'TINVRowid', field: 'TINVRowid', hidden: true},
				   {title: 'TabFlag', field: 'TabFlag', hidden: true},
				   {title: '审核状态', field: 'IsRefAudited', width: 70, align: 'center',
				   	formatter: function (value, row, index) {
					   	return "<img src=\"" + ((row.IsRefAudited == 1) ? "../scripts/dhcbill/themes/default/images/Audited.png" : "../scripts/dhcbill/themes/default/images/Unaudited.png") + "\"/>";
					}
				   },
				   {title: '操作', field: 'Operate', width: 60, align: 'center',
					formatter: function(value, row, index) {
						if (row.IsRefAudited == 1) {
							return "<a href='javascript:;' class='datagrid-cell-img' title='撤销审核' onclick='delAuditClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/audit_x.png'/></a>";
						}
						return "<a href='javascript:;' class='datagrid-cell-img' title='审核' onclick='auditClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/stamp.png'/></a>";
				    }
				   },
				   {title: '审核人', field: 'RefAuditUserName', width: 90},
				   {title: '审核时间', field: 'RefAuditDate', width: 155,
					formatter: function (value, row, index) {
						if (value) {
							return value + " " + row.RefAuditTime;
						}
					}
				   },				   
				   {title: '审核科室', field: 'RefAuditLoc', width: 120},
				   {title: '明细', field: 'OrdDetails', width: 50, align: 'center',
					formatter: function (value, row, index) {
						return "<a href='javascript:;' class='datagrid-cell-img' title='医嘱明细' onclick='openDtlView(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/paper.png'/></a>";
					}
				   },
				   {title: '退费原因', field: 'RefAuditReason', width: 120}
			]],
		onLoadSuccess: function (data) {
			$(".datagrid-cell-img").tooltip();
		}
	});
	
	//头菜单有值时，根据患者登记号查询
	var frm = dhcsys_getmenuform();
	if (frm && frm.PatientID.value) {
		var patientNo = getPropValById("PA_PatMas", frm.PatientID.value, "PAPMI_No");
		loadInvList();
	}
};

function loadInvList () {
	var queryParams = {
		ClassName: "BILL.OP.BL.DirectRefundAudit",
		QueryName: "QryInvList",
		StDate: getValueById("stDate"),
		EndDate: getValueById("endDate"),
		ReceiptNO: getValueById("invNo"),
		PatientNO: getValueById("patientNo"),
		PatientName: getValueById("patName"),
		ChargeUser: getValueById("userName"),
		SessionStr: getSessionStr()
	}
	loadDataGridStore("invList", queryParams);
}

function readHFMagCardClick() {
	DHCACC_GetAccInfo7(magCardCallback);
}

function cardNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cardNo = getValueById("CardNo");
		if (!cardNo) {
			return;
		}
		DHCACC_GetAccInfo("", cardNo, "", "", magCardCallback);
	}
}

function magCardCallback(rtnValue) {
	var patientId = "";
	var myAry = rtnValue.split("^");
	switch (myAry[0]) {
	case "0":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	case "-200":
		$.messager.alert("提示", "卡无效", "info", function () {
			$("#CardNo").focus();
		});
		break;
	case "-201":
		setValueById("CardNo", myAry[1]);
		patientId = myAry[4];
		setValueById("patientNo", myAry[5]);
		setValueById("CardTypeRowId", myAry[8]);
		break;
	default:
	}
	if (patientId != "") {
		loadInvList();
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.UDHCJFBaseCommon",
			MethodName: "regnocon",
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			$(e.target).val(patientNo);
			loadInvList();
		});
	}
}

function invNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: "web.DHCOPBillRefundRequest",
			MethodName: "CheckIsStayInv",
			invNo: $(e.target).val()
		}, function (rtn) {
			if (rtn == "Y") {
				$.messager.popover({msg: "该发票为急诊留观发票，若需退费请停止医嘱", type: "info"});
				return;
			}
			loadInvList();
		});
	}
}

function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num)").val("");
	$(".datebox-f").datebox("setValue", CV.DefDate);
	GV.InvList.options().pageNumber = 1;
	GV.InvList.loadData({total: 0, rows: []});
}

/**
* 审核
*/
function auditClick(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!(invId > 0)) {
				$.messager.popover({msg: "待审核记录不存在", type: "info"});
				return reject();
			}
			var rtn = $.m({ClassName: "BILL.OP.BL.DirectRefundAudit", MethodName: "CheckIsAudited", invId: invId, invType: invType}, false);
			if (rtn == 1) {
				$.messager.popover({msg: "已做直接退费审核，不能重复审核", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	//显示退费原因
    var _showRefReason = function () {
        return new Promise(function (resolve, reject) {
	        var _content = "<div id=\"edit-mod-dlg\">"
							+ "<table class=\"search-table\">"
								+ "<tr>"
									+ "<td class=\"r-label\"><label class=\"clsRequired\">" + $g("退费原因") + "</label></td>"
									+ "<td><input id=\"dlg-refReason\" class=\"textbox\" style=\"width:230px;\"/></td>"
								+ "</tr>"
							+ "</table>"
						+ "</div>";
			$("body").append(_content);
            var modDlgObj = $HUI.dialog("#edit-mod-dlg", {
                title: '请选择退费原因',
                iconCls: 'icon-w-edit',
                closable: false,
                modal: true,
                width: 330,
    			height: 150,
    			onClose: function() {
	                $("body").remove("#edit-mod-dlg");
	                modDlgObj.destroy();
	            },
                buttons: [{
                        text: '确定',
                        handler: function () {
                            var bool = true;
                            $("#edit-mod-dlg .validatebox-text").each(function (index, item) {
                                if (!$(this).validatebox("isValid")) {
                                    $.messager.popover({msg: "<font color='red'>" + $(this).parents("td").prev().text() + "</font>" + "验证不通过", type: "info"});
                                    bool = false;
                                    return false;
                                }
                            });
                            if (!bool) {
                                return;
                            }
                            $.messager.confirm("确认", "是否确认审核？", function (r) {
                           		if (!r) {
                                    return;
                                }
                            	refReason = getValueById("dlg-refReason");
                            	modDlgObj.close();
                            	resolve();
                            });
                        }
                    }, {
                        text: '取消',
                        handler: function () {
	                   		modDlgObj.close();
	                   		reject();
                        }
                    }
                ],
                onBeforeOpen: function () {
                    //退费原因
					$HUI.combobox("#dlg-refReason", {
						panelHeight: 150,
						url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryRefReason&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
						valueField: 'id',
						textField: 'text',
						required: true,
						defaultFilter: 5,
						blurValidValue: true,
						onLoadSuccess: function(data) {
							if (data.length > 0) {
			                    setValueById("dlg-refReason", data[0].id);
			                }
						}
					});
                }
            });
        });
    };
	
	var _audit = function() {
		return new Promise(function (resolve, reject) {
			var invStr = invId + ":" + invType;
			$.m({
				ClassName: "BILL.OP.BL.DirectRefundAudit",
				MethodName: "RefundAudit",
				invStr: invStr,
				reqReason: refReason,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "审核成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "审核失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		loadInvList();
	};
	
	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var invId = row.TINVRowid;
	var invType = row.TabFlag;
	var refReason = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_showRefReason)
		.then(_audit)
		.then(function() {
			_success();
			$this.prop("disabled", false);
		}, function() {
			$this.prop("disabled", false);
		});
}

/**
* 撤销审核
*/
function delAuditClick(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!(invId > 0)) {
				$.messager.popover({msg: "待撤销审核记录不存在", type: "info"});
				return reject();
			}
			var rtn = $.m({ClassName: "BILL.OP.BL.DirectRefundAudit", MethodName: "CheckIsAudited", invId: invId, invType: invType}, false);
			if (rtn != 1) {
				$.messager.popover({msg: "未做直接退费审核，无需撤销", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认撤销审核？", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			var invStr = invId + ":" + invType;
			$.m({
				ClassName: "BILL.OP.BL.DirectRefundAudit",
				MethodName: "CancelAudit",
				invStr: invStr,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "撤销审核成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "撤销审核失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		loadInvList();
	};
	
	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var invId = row.TINVRowid;
	var invType = row.TabFlag;
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_cancel)
		.then(function() {
			_success();
			$this.prop("disabled", false);
		}, function() {
			$this.prop("disabled", false);
		});
}

function openDtlView(row) {
	var argObj = {
		invRowId: row.TINVRowid,
		invType: row.TabFlag
	};
	BILL_INF.showOPChgOrdItm(argObj);
}
