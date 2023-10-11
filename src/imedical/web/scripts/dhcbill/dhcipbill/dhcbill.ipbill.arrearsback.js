/**
 * FileName: dhcbill.ipbill.arrearsback.js
 * Author: ZhYW
 * Date: 2021-05-26
 * Description: 住院欠费补回
 */

$(function () {
	initQueryMenu();
	initQFPayList();
	initPayMList();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-restore", {
		onClick: function () {
			restoreClick();
		}
	});
	
	//实付回车
	$("#patPaidAmt").keydown(function (e) {
		patPaidAmtKeydown(e);
	});
	
	$("#stDate, #endDate").datebox({
		onSelect: function(date) {
			GV.QFPayList.reload();
		}
	});
	
	//就诊科室
	initAdmList();
	
	getReceiptNo();
}

/**
* 就诊下拉数据表格
*/
function initAdmList() {
	$HUI.combogrid("#admList", {
		panelWidth: 530,
		panelHeight: 200,
		idField: 'TAdm',
		textField: 'TDept',
		columns: [[{field: 'TAdm', title: 'TAdm', hidden: true},
				   {field: 'TAdmDate', title: '入院时间', width: 150,
				    formatter: function(value, row, index) {
					    if (value) {
							return value + " " + row.TAdmTime;
						}
					}
				   },
				   {field: 'TDept', title: '就诊科室', width: 90},
				   {field: 'TWard', title: '就诊病区', width: 130},
				   {field: 'TDischDate', title: '出院时间', width: 150,
				   	formatter: function(value, row, index) {
					    if (value) {
							return value + " " + row.TDischTime;
						}
					}
				   }
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillCashier",
			QueryName: "SearchAdm",
			papmi: CV.PatientId,
			sessionStr: getSessionStr()
		},
		onChange: function (newValue, oldValue) {
			GV.QFPayList.reload();
		}
	});
}

function getReceiptNo() {
	var insTypeId = "";
	if (!isRequiredInv(insTypeId)) {
		return;         //不需要打印发票时退出
	}
	$.m({
		ClassName: "web.UDHCJFPAY",
		MethodName: "ReadReceiptNO",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		insTypeId: insTypeId,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(rtn) {
		var myAry = rtn.split("^");
		if (myAry[0] != 0) {
			$("#btn-restore").linkbutton("disable");
			$.messager.popover({msg: "没有可用发票，请先领取", type: "info"});
			return;
		}
		var currNo = myAry[1];
		var rowId = myAry[2];
		var endNo = myAry[3];
		var title = myAry[4];
		var leftNum = myAry[5];
		var tipFlag = myAry[6];
		var receiptNo = title + "[" + currNo + "]";
		setValueById("receiptNo", receiptNo);
		var color = "green";
		if ($("#receiptNo").hasClass("newClsInvalid")) {
			$("#receiptNo").removeClass("newClsInvalid");
		}
		if (tipFlag == 1) {
			color = "red";
			$("#receiptNo").addClass("newClsInvalid");
		}
		var content = $g("该号段可用票据剩余") + " <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> " + $g("张");
		$("#btn-tip").show().popover({cache: false, trigger: 'hover', content: content});
	});
}

function initQFPayList() {
	var _clearSelected = function (index, row) {
		delete GV.EpisodeID;
		delete GV.BillID;
		delete GV.PrtRowID;
		GV.PayMList.getPanel().panel("setTitle", "支付信息");
		$(".numberbox-f").numberbox("clear");
		$("#patPaidAmt").val();
		loadPayMList();
	}
	
	GV.QFPayList = $HUI.datagrid("#payList", {
		fit: true,
		border: false,
		singleSelect: true,
		rownumbers: false,
		pageSize: 999999999,
		idField: 'prtRowId',
		className: 'BILL.IP.BL.ArrearsBack',
		queryName: 'FindQFPayList',
		frozenColumns: [[{field: 'ck', checkbox: true}]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["prtDate", "ward", "admDate", "disDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["prtRowId", "adm", "bill", "insTypeDR"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "prtTime") {
					cm[i].formatter = function(value, row, index) {
						return row.prtDate + " " + value;
					};
				}
				if (cm[i].field == "depositAmt") {
					cm[i].formatter = function(value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick='depositListDtl(" + JSON.stringify(row) + ")'>" + value + "</a>";
						}
					};
				}
				if (cm[i].field == "dept") {
					cm[i].title = "科室病区";
					cm[i].formatter = function(value, row, index) {
						return value + " " + row.ward;
					};
				}
				if (cm[i].field == "admTime") {
					cm[i].formatter = function(value, row, index) {
						return row.admDate + " " + value;
					};
				}
				if (cm[i].field == "disTime") {
					cm[i].formatter = function(value, row, index) {
						return row.disDate + " " + value;
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "dept") {
						cm[i].width = 200;
					}
					if ($.inArray(cm[i].field, ["prtTime", "admTime", "disTime"]) != -1) {
						cm[i].width = 160;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "BILL.IP.BL.ArrearsBack",
			QueryName: "FindQFPayList",
			patientId:  CV.PatientId,
			episodeId: $("#admList").combogrid("getValue"),
			stDate: getValueById("stDate"),
			endDate: getValueById("endDate"),
			sessionStr: getSessionStr(),
			rows: 99999999
		},
		onLoadSuccess: function() {
			$("#btn-restore").linkbutton("disable");
			GV.QFPayList.clearChecked();
			_clearSelected();
		},
		onCheck: function (index, row) {
			GV.EpisodeID = row.adm;
			GV.BillID = row.bill;
			GV.PrtRowID = row.prtRowId;
			$("#btn-restore").linkbutton("enable");
			$("#patPaidAmt").val();
			$("#recOrBackMoney").numberbox("clear");
			loadPayMList();
			initPatFeeInfo();
			setPayMPanelTitle();
		}
	});
}

function depositListDtl(row) {
	var argObj = {
		EpisodeID: row.adm,
		PrtRowId: row.prtRowId
	};
	BILL_INF.showChgedDepList(argObj);
}

function initPayMList() {
	GV.PayMList = $HUI.datagrid("#paymList", {
		fit: true,
		border: true,
		title: '支付信息',
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		toolbar: [],
		pageSize: 999999999,
		loadMsg: '',
		columns: [[{title: 'PMSubRowID', field: 'PMSubRowID', hidden: true},
				   {title: 'CTPMRowID', field: 'CTPMRowID', hidden: true},
				   {title: 'CTPMCode', field: 'CTPMCode', hidden: true},
				   {title: '支付方式', field: 'CTPMDesc', width: 100,
					editor: {
						type: 'combobox',
						options: {
							valueField: 'CTPMRowID',
							textField: 'CTPMDesc',
							url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array',
							editable: false,
							onBeforeLoad: function(param) {
								param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
								param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
								param.TypeFlag = "FEE";
							},
							loadFilter: function(data) {
								return data;
								data = $.grep(data, function(item) {
									return ($.inArray(item.CTPMCode, ['QF', 'JC']) == -1);
								});
								return data;
							},
							onLoadSuccess: function () {
								$(this).combobox("showPanel");
							},
							onShowPanel: function() {
								if (GV.EditIndex == undefined) {
									return;
								}
								var row = GV.PayMList.getRows()[GV.EditIndex];
								$(this).combobox("setValue", row.CTPMRowID);
							},
							onHidePanel: function() {
								endEditing();
							},
							onSelect: function (rec) {
								if (GV.EditIndex == undefined) {
									return;
								}
								var row = GV.PayMList.getRows()[GV.EditIndex];
								row.CTPMRowID = rec.CTPMRowID;
								row.CTPMCode = rec.CTPMCode;
								
								//以下控制先写死
								if (rec.RPFlag != "Y") {
									if (rec.CTPMCode != "ZP") {
										row.CTPMBankRowID = "";
										row.CTPMBank = "";
										row.CTPMCheckNo = "";
									}
									if (rec.CTPMCode != "CCP") {
										row.CTPMUnitRowID = "";
										row.CTPMUnit = "";
									}
								}
							}
						}
					}},
				   {title: '金额', field: 'CTPMAmt', width: 120, align: 'right', formatter: formatAmt,
					editor: {
						type: 'numberbox',
						options: {
							precision: 2
						}
					}},
				   {title: 'CTPMBankRowID', field: 'CTPMBankRowID', hidden: true},
				   {title: '银行', field: 'CTPMBank', width: 160,
					editor: {
						type: 'combobox',
						options: {
							valueField: 'id',
							textField: 'text',
							url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QBankList&ResultSetType=array',
							editable: false,
							onLoadSuccess: function () {
								$(this).combobox("showPanel");
							},
							onShowPanel: function() {
								if (GV.EditIndex == undefined) {
									return;
								}
								var row = GV.PayMList.getRows()[GV.EditIndex];
								$(this).combobox("setValue", row.CTPMBankRowID);
							},
							onHidePanel: function () {
								if (GV.EditIndex == undefined) {
									return;
								}
								//支票号/卡号编辑状态
								paymEditCell(GV.EditIndex, "CTPMCheckNo", "");
							},
							onSelect: function (rec) {
								if (GV.EditIndex == undefined) {
									return;
								}
								var row = GV.PayMList.getRows()[GV.EditIndex];
								row.CTPMBankRowID = rec.id;
							}
						}
					}
				 },
				 {title: '支票号/卡号', field: 'CTPMCheckNo', width: 160, editor: 'text'},
				 {title: 'CTPMUnitRowID', field: 'CTPMUnitRowID', hidden: true},
				 {title: '公费单位', field: 'CTPMUnit', width: 160,
				  editor: {
						type: 'combobox',
						options: {
							valueField: 'id',
							textField: 'text',
							url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryHCPList&ResultSetType=array&patientId=' + CV.PatientId + '&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
							editable: false,
							onLoadSuccess: function () {
								$(this).combobox("showPanel");
							},
							onShowPanel: function() {
								if (GV.EditIndex == undefined) {
									return;
								}
								var row = GV.PayMList.getRows()[GV.EditIndex];
								$(this).combobox("setValue", row.CTPMUnitRowID);
							},
							onSelect: function (rec) {
								if (GV.EditIndex == undefined) {
									return;
								}
								var row = GV.PayMList.getRows()[GV.EditIndex];
								row.CTPMUnitRowID = rec.id;
							}
						}
					}},
				 {title: '账户', field: 'CTPMAccount', hidden: true},
				 {title: '转账', field: 'CTPMTransFlag', width: 50, align: 'center', hidden: true,
				 	formatter: function(value, row, index) {
					 	return "<input type='checkbox' " + (value == "Y" ? "checked" : "") + "/>";
					}
				 },
				 {title: 'CTPMInsuFlag', field: 'CTPMInsuFlag', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: "BILL.IP.BL.ArrearsBack",
			QueryName: "ReadPayMList",
			prtRowId: (GV.PrtRowID || ""),
			sessionStr: getSessionStr(),
			rows: 99999999
		},
		onLoadSuccess: function (data) {
			$("#tipAmt").text("");
			onLoadSuccessPaym();
		},
		onClickCell: function (index, field, value) {
			onClickCellHandler(index, field, value);
		},
		onBeginEdit: function (index, row) {
			onBeginEditHandler(index, row);
    	},
    	onEndEdit: function(index, row, changes) {
			onEndEditHandler(index, row);
		},
		onAfterEdit: function (index, row, changes) {
			onAfterEditHandler();
		}
	});
}

/**
* 加载支付方式Grid数据
*/
function loadPayMList() {
	GV.PayMList.load({
		ClassName: "BILL.IP.BL.ArrearsBack",
		QueryName: "ReadPayMList",
		prtRowId: (GV.PrtRowID || ""),
		sessionStr: getSessionStr(),
		rows: 99999999
	});
}

/**
 * 支付方式列表加载成功
 */
function onLoadSuccessPaym() {
	var defPayMId = getDefPayMId();
	var defAmt = getBalanceAmt();     //取默认应交费用
	$.each(GV.PayMList.getRows(), function (index, row) {
		if (row.PMSubRowID || (row.CTPMRowID != defPayMId)) {
			return true;
		}
		//判断当前默认支付方式是否有值，如果有值默认+该值
		defAmt = GV.BillID ? Number(defAmt).add(row.CTPMAmt).toFixed(2) : "";
		GV.PayMList.updateRow({
			index: index,
			row: {
				CTPMAmt: defAmt
			}
		});
		return false;
	});
	//改变平衡金额的值(支付方式)
	setBalance();
}

/**
 * 支付方式Grid单元格单击事件
 */
function onClickCellHandler(index, field, value) {
	if (!GV.PrtRowID) {
		$.messager.popover({msg: "请先选择结算记录", type: "info"});
		return;
	}
	paymEditCell(index, field, value);
}

/**
* 单击支付方式单元格
*/
function paymEditCell(index, field, value) {
	GV.PayMList.selectRow(index);   //选中设中行
	var isEdit = isCellAllowedEdit(index, field, value);
	if (!isEdit) {
		return;
	}
	if (endEditing()) {
		GV.PayMList.editCell({index: index, field: field});
		var ed = GV.PayMList.getEditor({index: index, field: field});
		if (ed) {
			$(ed.target).focus().select();
		}
		GV.EditIndex = index;
		setTipAmt();
	}
}

/**
* 单元格是否可编辑
* true: 可编辑, false: 不可编辑
*/
function isCellAllowedEdit(index, field, value) {
	if (!GV.BillID) {
		return false;
	}
	var row = GV.PayMList.getRows()[index];
	if (!row) {
		return false;
	}
	//正常的支付方式不能编辑
	if (row.PMSubRowID) {
		return false;
	}
	//走配置 支付方式不能编辑
	if (["CTPMDesc", "CTPMAmt"].indexOf(field) == -1) {
		var isRequired = isPaymRequired(row.CTPMRowID);
		if (!isRequired) {
			return false;
		}
	}
	return true;
}

function endEditing() {
	if (GV.EditIndex == undefined) {
		return true;
	}
	if (GV.PayMList.validateRow(GV.EditIndex)) {
		GV.PayMList.endEdit(GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	}
	return false;
}

function onBeginEditHandler(index, row) {
	var ed = GV.PayMList.getEditor({index: index, field: "CTPMAmt"});
	if (ed) {
		var maxLen = GV.PayMList.getData().total;
		$(ed.target).keydown(function (e) {
			var key = websys_getKey(e);
			if (key == 13) {
				var nextIndex = getNextEditRow();
				$(ed.target).numberbox("setValue", $(ed.target).val());
				GV.PayMList.endEdit(index);
				if (nextIndex < maxLen) {
					paymEditCell(nextIndex, "CTPMAmt", "");
					return;
				}
				focusById("patPaidAmt");
			}
		});
	}
}

function getNextEditRow() {
	var nextIndex = GV.EditIndex + 1;
	var maxLen = GV.PayMList.getData().total;
	while (nextIndex < maxLen) {
		var row = GV.PayMList.getRows()[nextIndex];
		if (row.PMSubRowID) {
			nextIndex++;
		}else {
			break;
		}
	}
	return nextIndex;
}

/**
* 设置应填金额
*/
function setTipAmt() {
	var tipAmt = "";
	if (GV.EditIndex != undefined) {
		var ed = GV.PayMList.getEditor({index: GV.EditIndex, field: "CTPMAmt"});
		if (ed) {
			var row = GV.PayMList.getSelected();
			var balanceAmt = (GV.BalanceAmt || 0);
			tipAmt = Number(row.CTPMAmt).add(balanceAmt).toFixed(2);
		}
	}
	setPayMPanelTitle(tipAmt);
}

function onEndEditHandler(index, row) {
	var ed = GV.PayMList.getEditor({index: index, field: "CTPMDesc"});
	if (ed) {
		row.CTPMDesc = $(ed.target).combobox("getText");
	}
	var ed = GV.PayMList.getEditor({index: index, field: "CTPMBank"});
	if (ed) {
		row.CTPMBank = $(ed.target).combobox("getText");
	}
	var ed = GV.PayMList.getEditor({index: index, field: "CTPMUnit"});
	if (ed) {
		row.CTPMUnit = $(ed.target).combobox("getText");
	}
}

/**
* 支付方式结束编辑
*/
function onAfterEditHandler() {
	GV.EditIndex = undefined;
	setBalance();
}

/**
* 设置支付方式列表panel的title
*/
function setPayMPanelTitle(tipAmt) {
	$("#tipAmt").text(tipAmt || "");
	GV.PayMList.getPanel().panel("setTitle", $("#tipDiv").html());
}

/**
* 点击应填金额时 自动填充到正在编辑的单元格
*/
function setColumnVal() {
	if (GV.EditIndex == undefined) {
		return;
	}
	var tipAmt = $("#tipAmt").text() || 0;
	if (tipAmt == 0) {
		return;
	}
	var ed = GV.PayMList.getEditor({index: GV.EditIndex, field: "CTPMAmt"});
	if (ed) {
		$(ed.target).numberbox("setValue", tipAmt);
		return;
	}
	GV.PayMList.updateRow({
		index: GV.EditIndex,
		row: {
			CTPMAmt: tipAmt
		}
	});
}

/**
 * 获得配置的默认支付方式，没有默认时取第一行支付方式
 */
function getDefPayMId() {
	var row = GV.PayMList.getRows()[0];
	return CV.DefPayMId || (row ? row.CTPMRowID: "");
}

/**
* 取默认支付方式费用
*/
function getBalanceAmt() {
	var depositAmt = getValueById("selDepAmt");     //已选押金
	var patShareAmt = getValueById("patShareAmt");  //自付金额
	var balanceAmt = Number(patShareAmt).sub(depositAmt).toFixed(2);
	var paymSum = getPayMSum();
	return Number(balanceAmt).sub(paymSum).toFixed(2);
}

/**
* 判断支付方式是否有必填项
* true:有 false:无
*/
function isPaymRequired(paymId) {
	return ($.m({ClassName: "web.DHCIPBillCashier", MethodName: "IsRequiredInfo", groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID, paymId: paymId}, false) == 1);
}

/**
* 判断账单费别是否需要发票
* true:需要发票, false:不需要发票
*/
function isRequiredInv(insTypeId) {
	return ($.m({ClassName: "web.UDHCJFPAY", MethodName: "CheckPrtFlag", insTypeId: insTypeId, groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID, printInvFlag: "Y"}, false) == 0);
}

/**
 * 获取账单基本字段信息
 */
function getBillRefFlag() {
	return getPropValById("DHC_PatientBill", (GV.BillID || ""), "PB_RefundFlag");
}

/**
* 判断账单是否已结算
*/
function isChgedBill() {
	return ($.m({ClassName: "BILL.IP.COM.Method", MethodName: "GetPrtInvIdByBill", billId: GV.BillID}, false) > 0);
}

/**
 * 设置金额信息
 */
function initPatFeeInfo() {
	var rtn = $.m({ClassName: "web.DHCIPBillCashier", MethodName: "GetPatInfo", EpisodeID: GV.EpisodeID, PBRowID: GV.BillID}, false);
	var myAry = rtn.split("$");
	var patInfoStr = myAry[0];
	var admInfoStr = myAry[1];
	var feeInfoStr = myAry[2];
	var feeInfoArr = feeInfoStr.split("^");
	var depAmt = feeInfoArr[0];
	var totalAmt = feeInfoArr[1];
	var patShareAmt = feeInfoArr[2];
	var discAmt = feeInfoArr[3];
	var payorAmt = feeInfoArr[4];
	var stAmt = feeInfoArr[5];
	var ysAmt = feeInfoArr[6];
	var ytAmt = feeInfoArr[7];
	var insuAmt = feeInfoArr[8];
	var zfAmt = feeInfoArr[9];
	var yeAmt = feeInfoArr[10];
	
	setValueById("selDepAmt", depAmt);
	setValueById("totalAmt", totalAmt);
	setValueById("patShareAmt", patShareAmt);
	setValueById("payorAmt", payorAmt);
	setValueById("discAmt", discAmt);
	setValueById("insuAmt", insuAmt);
	
	calcReceRefAmt();   //应收、应退
}

/**
* 计算应收应退、金额
* 应收/应退 = 自付 - 医保支付- 押金
*/
function calcReceRefAmt() {
	var patShareAmt = getValueById("patShareAmt");
	var insuAmt = getValueById("insuAmt");
	var selDepSum = getValueById("selDepAmt");
	var amt = Number(Number(patShareAmt).sub(insuAmt).toFixed(2)).sub(selDepSum).toFixed(2);
	setValueById("receAmt", ((amt >= 0) ? amt : 0));            //应收
	setValueById("refAmt", ((amt < 0) ? Math.abs(amt) : 0));    //应退
}

/**
* 计算找零金额
*/
function patPaidAmtKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patPaidAmt = getValueById("patPaidAmt");
		var cashAmt = 0;    //收退现金金额
		$.each(GV.PayMList.getRows(), function (index, row) {
			if ((row.CTPMInsuFlag != "Y") && (row.CTPMCode == "CASH")) {
				cashAmt = Number(cashAmt).add(row.CTPMAmt).toFixed(2);
			}
		});
		setValueById("recOrBackMoney", Number(patPaidAmt).sub(cashAmt).toFixed(2));
	}
}

/**
 * 设置平衡金额
 */
function setBalance() {
	var balanceAmt = getStAmt();
	var paymSum = getPayMSum();
	GV.BalanceAmt = Number(balanceAmt).sub(paymSum).toFixed(2);
}

/**
* 获取收退金额
*/
function getStAmt() {
	var patShareAmt = getValueById("patShareAmt");
	var depositAmt = getValueById("selDepAmt");  //已选押金
	return Number(patShareAmt).sub(depositAmt).toFixed(2);
}

/**
* 获取当前所有支付方式的金额合计
*/
function getPayMSum() {
	return GV.PayMList.getRows().reduce(function (total, row) {
        return Number(total).add(row.CTPMAmt).toFixed(2);
    }, 0);
}

/**
* 欠费补回
*/
function restoreClick() {
	var _validate = function () {
		return new Promise(function (resolve, reject) {
			var row = GV.QFPayList.getSelected();
			if (!row || !row.prtRowId) {
				$.messager.popover({msg: "请选择需要补回的记录", type: "info"});
				return reject();
			}
			if (!validatePayMRow()) {
				return reject();
			}
			if (!isChgedBill()) {
				$.messager.popover({msg: "此账单未结算，不能补回", type: "info"});
				return reject();
			}
			var refundFlag = getBillRefFlag();  //红冲标识
			if (refundFlag == "B") {
				$.messager.popover({msg: "此账单已经红冲，不允许结算", type: "info"});
				return reject();
			}
			//判断平衡金额
			var isBalance = checkBalance();
			if (!isBalance) {
				$.messager.popover({msg: "平衡金额不为0，不能补回",	type: "info"});
				return reject();
			}
			prtRowId = row.prtRowId;
			resolve();
		});
	};
	
	var _cfr = function () {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认补回？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	/**
	* 第三方支付
	*/
	var _paySrv = function () {
	    return new Promise(function (resolve, reject) {
		  	var payMAry = [];
	        var _check = function () {
		   		var payMId = "";
		   		var errMsg = "";
		   		var leftAmt = 0;
	            $.each(GV.PayMList.getRows(), function (index, row) {
		            if (!row.PMSubRowID) {
						return true;   //原结算记录使用了第三方支付的不再扣费
					}
					if (row.CTPMInsuFlag == "Y") {
						return true;
					}
					if (!row.CTPMAmt || !_needPaySrv(row.CTPMCode)) {
						return true;
					}
					if (payMId == row.CTPMRowID) {
						errMsg = $g("不能选择多个") + "<font color=\"red\">" + row.CTPMDesc + "</font>" + $g("结算");
		                return false;
		            }
	                payMId = row.CTPMRowID;
	                if (row.CTPMAmt > 0) {
	                    var myObj = {};
	                    myObj[row.CTPMRowID] = row.CTPMAmt;
	                    payMAry.push(myObj);
	                }else {
		             	leftAmt = getPayMLeftAmt(row.CTPMRowID, unpayDepIdStr);
		             	if (Math.abs(row.CTPMAmt) > leftAmt) {
			             	errMsg = row.CTPMDesc + $g("最多可退") + "<font color=\"red\">" + leftAmt + "</font>" + $g("元");
			             	return false;
			            }
		            }
	            });
	            if (errMsg) {
		            $.messager.popover({msg: errMsg, type: "info"});
		            return reject();
		        }
	            //使用队列"先进先出"方法调用第三方支付接口
	            _shiftPay();
	        };

	        var _needPaySrv = function (paymCode) {
		        return ($.inArray(paymCode, CV.CallPMCodeAry) != -1);
	        };

	        var _shiftPay = function () {
	            //payMAry.length == 0时表示全部交易成功，则返回主界面
	            if (payMAry.length > 0) {
	                var obj = payMAry[0]; //每次取数组第1项
	                $.each(Object.keys(obj), function (index, prop) {
	                    _pay(prop, obj[prop]);
	                });
	                return;
	            }
	            resolve();
	        };

	        var _pay = function (payMode, payMAmt) {
	            var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	            expStr += "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + CV.PatientId + "^" + GV.EpisodeID;
	            expStr += "^" + prtRowId + "^^C";
	            PayService("IP", payMode, payMAmt, expStr, _callback);
	        };

	        var _callback = function (rtnValue) {
	            if (rtnValue.ResultCode == 0) {
	              	payMConETP[rtnValue.PayMode] = rtnValue.ETPRowID; //将交易流水表RowId放入payMConETP
	                payMAry.shift(); //成功时删除第一项
	                setTimeout(function () {
	                    _shiftPay();
	                }, (1000 * ((payMAry.length > 0) ? 1 : 0)));
	                return;
	            }
	            $.messager.popover({msg: rtnValue.ResultMsg, type: "error"});
	        	reject();
	        };
	        
	        /**
	        * 获取押金RowId串
	        */
	        var _getUnChgedDepIdStr = function () {
		        return $.m({ClassName: "BILL.IP.BL.ArrearsBack", MethodName: "GetUnChgedDepIdStr", prtRowId: prtRowId}, false);
			};
			
			var unpayDepIdStr = _getUnChgedDepIdStr();   //不参与结算的押金RowId串(以"^"分割)
			
	        _check();
	    });
	};
	
	/**
	* 获取转账标识checkbox值
	*/
	var _getPayMTransFlag = function(index, field) {
		var checked = GV.PayMList.getPanel().find(".datagrid-view2 tr.datagrid-row[datagrid-row-index=" + index + "] td[field=" + field + "] input:checkbox").is(":checked");
		return checked ? "Y" : "N";
	};
	
	/**
	* 获取支付方式串
	*/
	var _getPayModeList = function () {
		var paymAry = [];
		var myStr = "";
		$.each(GV.PayMList.getRows(), function (index, row) {
			var paymAmt = row.CTPMAmt || 0;
			if (paymAmt == 0) {
				return true;
			}
			paymAmt = Number(paymAmt).toFixed(2);
			myCTPMTransFlag = _getPayMTransFlag(index, "CTPMTransFlag");
			if (myCTPMTransFlag == "Y") {
				transferFlag = true;
			}
			var ETPRowID = (!row.PMSubRowID) ? (payMConETP[row.CTPMRowID] || "") : "";
			
			//原支付方式RowId+String.fromCharCode(3)+支付方式ID^银行^支票号/卡号^IPM_Unit_DR^IPM_PayAccNo^金额^IPM_TransFlag^IPM_InsuFlag^IPM_ETP_DR
			myStr = row.PMSubRowID + PUBLIC_CONSTANT.SEPARATOR.CH3;
			myStr += row.CTPMRowID + "^" + row.CTPMBankRowID + "^" + row.CTPMCheckNo + "^" + row.CTPMUnitRowID;
			myStr += "^" + row.CTPMAccount + "^" + paymAmt + "^" + myCTPMTransFlag + "^" + row.CTPMInsuFlag;
			myStr += "^" + ETPRowID;
			paymAry.push(myStr);
		});
		var paymStr = paymAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
		return paymStr;
	};
	
	var _restore = function () {
		return new Promise(function (resolve, reject) {
			//支付方式串
			var paymStr = _getPayModeList();
			$.m({
				ClassName: "BILL.IP.BL.ArrearsBack",
				MethodName: "Restoring",
				prtRowId: prtRowId,
				paymStr: paymStr,
				sessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.alert("提示", "补回成功", "success", function() {
						newPrtRowId = myAry[1];
						return resolve();
					});
					return;
				}
				$.messager.popover({msg: "补回失败：" + (myAry[1] || myAry[0]), type: "error"});
				reject();
			});
		});
	};
	
	var _success = function() {
		return new Promise(function (resolve, reject) {
			getReceiptNo();
			GV.QFPayList.reload();
			return resolve();
		});
	};
	
	/**
	* 打印发票
	*/
	var _printInv = function() {
		return new Promise(function (resolve, reject) {
			var invPrintFlag = getPropValById("DHC_INVPRTZY", newPrtRowId, "PRT_INVPrintFlag");
			if (invPrintFlag == "P") {
				inpatInvPrint(newPrtRowId + "#" + "");
			}
			return resolve();
		});
	};
	
	/**
	* 第三方支付退款
	*/
	var _refundSrv = function() {
		return new Promise(function (resolve, reject) {
			var notRefAmt = getNotRefundAmt(newPrtRowId);
			if (notRefAmt == 0) {
				return resolve();
			}
			var msg = "需退第三方支付：<font color='red'>" + notRefAmt + "</font>元";
			$.messager.alert("提示", msg, "info", function() {
				refundSrv(newPrtRowId).then(resolve);
			});
		});
	};
	
	/**
	* 撤销第三方交易
	*/
	var _cancelPaySrv = function () {
		var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
		$.each(Object.keys(payMConETP), function (index, prop) {
            var rtnValue = CancelPayService(payMConETP[prop], expStr);
			if (rtnValue.ResultCode != 0) {
				$.messager.popover({msg: "第三方支付撤销失败，请联系工程师处理", type: "error"});
			}
        });
	};
	
	/**
	* 转账 自动打开交押金的界面
	*/
	var _transferDeposit = function () {
		if (!transferFlag) {
			return;
		}
		var payAmt = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetTDepositByPaid", PrtRowID: newPrtRowId}, false);
		var url = "dhcbill.ipbill.deposit.pay.if.csp?&EpisodeID=" + GV.EpisodeID + "&PayAmt=" + Math.abs(payAmt) + "&TransferFlag=Y";
		websys_showModal({
			url: url,
			title: '交押金',
			iconCls: 'icon-w-new',
			width: '85%',
			height: '85%'
		});
	};
	
	if ($("#btn-restore").hasClass("l-btn-disabled")) {
		return;
	}
	
	$("#btn-restore").linkbutton("disable");
	
	var prtRowId = "";
	var transferFlag = false;    //是否有中途结算转账(中途结算后退费，用于补交押金)
	var newPrtRowId = "";
	var payMConETP = {};  //存放支付方式关联第三方支付订单
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_paySrv)
		.then(_restore)
		.then(_success)
		.then(_printInv)
		.then(_refundSrv)
		.then(function() {
			_transferDeposit();
			$("#btn-restore").linkbutton("enable");
		}, function() {
			_cancelPaySrv();
			$("#btn-restore").linkbutton("enable");
		});
}

function validatePayMRow() {
	if (!endEditing()) {
		return false;
	}
	
	var bool = true;
	var norPMCount = 0;
	var field = "";
	var existPayMCode = "";
	$.each(GV.PayMList.getRows(), function (index, row) {
		var paymAmt = row.CTPMAmt || 0;
		if (paymAmt == 0) {
			return true;
		}
		if (row.PMSubRowID) {
			return true;
		}
		var isRequired = isPaymRequired(row.CTPMRowID);
		if (isRequired) {
			//以下控制先写死
			switch(row.CTPMCode) {
			case "ZP":
				field = "CTPMCheckNo";
				if (!row.CTPMCheckNo) {
					bool = false;
				}
				break;
			case "CCP":
				field = "CTPMUnit";
				if (!row.CTPMUnitRowID) {
					bool = false;
				}
				break;
			default:
			}
			if (!bool) {
				$.messager.popover({msg: "选择" + row.CTPMDesc + "时，" + GV.PayMList.getColumnOption(field).title + "不能为空", type: "alert"});
				return false;
			}
		}
		
		//欠费、结存支付方式判断
		if ($.inArray(row.CTPMCode, ["QF", "JC"]) != -1) {
			if (existPayMCode && (existPayMCode != row.CTPMCode)) {
				$.messager.popover({msg: "不能同时按【欠费】和【结存】结算", type: "info"});
				bool = false;
				return false;
			}
			existPayMCode = row.CTPMCode;
			if ((row.CTPMCode == "QF") && (paymAmt < 0)) {
				$.messager.popover({msg: "欠费金额必须大于0", type: "info"});
				bool = false;
				return false;
			}
			if ((row.CTPMCode == "JC") && (paymAmt > 0)) {
				$.messager.popover({msg: "结存金额必须小于0", type: "info"});
				bool = false;
				return false;
			}
		}else {
			++norPMCount;
		}
	});
	if (!bool) {
		return;
	}
	
	if (norPMCount == 0) {
		$.messager.popover({msg: "没有补回金额", type: "info"});
		bool = false;
		return false;
	}
	
	return bool;
}

/**
* 判断平衡金额
*/
function checkBalance() {
	var myBalance = getBalanceAmt();
	return (myBalance == 0) ? (GV.BalanceAmt == 0) : false;
}

/**
* 结算后第三方支付退款
*/
function refundSrv(prtRowId) {
	return new Promise(function (resolve, reject) {
		var url = "dhcbill.ipbill.chgedrefdep.csp?PrtRowId=" + prtRowId;
	    websys_showModal({
			url: url,
			title: '结算退款',
			iconCls: 'icon-w-list',
			width: 1200,
			height: 600,
			onClose: function() {
				var notRefAmt = getNotRefundAmt(prtRowId);
				if (notRefAmt != 0) {
					$.messager.alert("提示", "尚有待退的第三方支付：<font color='red'>" + notRefAmt + "</font>元", "info", function() {
						return resolve();
					});
					return;
				}
				return resolve();
			}
		});
	});
}

/**
* 获取结算后第三方支付未退金额
*/
function getNotRefundAmt(prtRowId) {
	var refundInfo = $.m({ClassName: "BILL.IP.BL.ChgedRefundDep", MethodName: "GetPrtRefundInfo", prtRowId: prtRowId}, false);
	var myAry = refundInfo.split("^");
    var notRefAmt = myAry[1];   //未退金额
    return notRefAmt;
}

/**
* 获取该支付方式的可退金额
*/
function getPayMLeftAmt(paymId, unpayDepIdStr) {
	return $.m({ClassName: "BILL.IP.BL.ChgedRefundDep", MethodName: "GetPayMLeftAmt", adm: GV.EpisodeID, paymId: paymId, unpayDepIdStr: unpayDepIdStr}, false);
}