/**
 * FileName: dhcbill.pkg.sell.paym.js
 * Anchor: ZhYW
 * Date: 2019-09-23
 * Description: 套餐订购
 */

function initPaymWinMenu() {
	//卡号回车查询事件
	$("#winPreSum").keydown(function(e) {
		preSumKeydown(e);
	});
	
	$HUI.linkbutton("#win-btn-sell", {
		onClick: function () {
			winSellClick();
		}
	});
	enableById("win-btn-sell");
	
	//关闭
	$HUI.linkbutton("#win-btn-close", {
		onClick: function () {
			$("#paymWin").dialog("close");
		}
	});
}

function initPayMList() {
	GV.PayMList = $HUI.datagrid('#paymList', {
		fit: true,
		border: true,
		title: $("#tipDiv").html(),
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		autoRowHeight: false,
		url: $URL,
		toolbar: [],
		pageSize: 999999999,
		columns: [[{
					title: '支付方式',
					field: 'CTPMDesc',
					width: 100,
					editor: {
						type: 'combobox',
						formatter: function (row) {
							var opts = $(this).combobox('options');
							return row[opts.textField];
						},
						options: {
							panelHeight: 'auto',
							valueField: 'CTPMDesc',
							textField: 'CTPMDesc',
							url: $URL + '?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&GPRowID=' + PUBLIC_CONSTANT.SESSION.GROUPID + '&InsType=&TypeFlag=DEP&ResultSetType=array',
							editable: false,
							onLoadSuccess: function () {
								$(this).combobox('showPanel');
							},
							onSelect: function (record) {
								if (GV.EditIndex != undefined) {
									HISUIDataGrid.setFieldValue('CTPMRowID', record.CTPMRowID, GV.EditIndex, 'paymList');
									HISUIDataGrid.setFieldValue('CTPMCode', record.CTPMCode, GV.EditIndex, 'paymList');
									HISUIDataGrid.setFieldValue('RPFlag', record.RPFlag, GV.EditIndex, 'paymList');
									$('#paymList').datagrid('endEditCell', {
										index: GV.EditIndex,
										field: 'CTPMDesc'
									});
								}
							}
						}
					}
				}, {
					title: '金额',
					field: 'CTPMAmt',
					align: 'right',
					width: 120,
					editor: {
						type: 'numberbox',
						options: {
							precision: 2
						}
					}
				}, {
					title: '银行',
					field: 'CTPMBank',
					width: 120,
					editor: {
						type: 'combobox',
						options: {
							panelHeight: 'auto',
							valueField: 'caption',
							textField: 'caption',
							url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QBankList&ResultSetType=array',
							editable: false,
							onLoadSuccess: function () {
								$(this).combobox("showPanel");
							},
							onSelect: function (record) {
								bankComboSelect();
							}
						}
					}
				}, {
					title: '支行',
					field: 'CTPMBankSub',
					hidden: true
				}, {
					title: '支票/卡号',
					field: 'CTPMCheckno',
					width: 100,
					editor: 'text'
				}, {
					title: '支付单位',
					field: 'CTPMUnit',
					width: 100,
					editor: 'text'
				}, {
					title: '账户',
					field: 'CTPMAcount',
					width: 100,
					editor: 'text'
				}, {
					title: 'CTPMRowID',
					field: 'CTPMRowID',
					hidden: true
				}, {
					title: 'CTPMCode',
					field: 'CTPMCode',
					hidden: true
				}, {
					title: 'RPFlag',
					field: 'RPFlag',
					hidden: true
				}
			]],
		queryParams: {
			ClassName: "web.UDHCOPGSConfig",
			QueryName: "ReadGSINSPMList",
			GPRowID: PUBLIC_CONSTANT.SESSION.GROUPID,
			InsType: "",
			TypeFlag: "DEP"
		},
		onLoadSuccess: function (data) {
			onLoadSuccessPaym(data);
		},
		onClickCell: function (index, field, value) {
			paymClickCell(index, field, value);
		},
		onBeginEdit: function (index, row) {
			paymBeginEdit(index, row);
    	},
		onAfterEdit: function (index, rowData, changes) {
			paymAfterEdit();
		}
	});
}

/**
 * 银行下拉框选中事件
 */
function bankComboSelect() {
	if (GV.EditIndex != undefined) {
		var ed = GV.PayMList.getEditor({index: GV.EditIndex, field: "CTPMBank"});
		if (ed) {
			var text = $(ed.target).combobox("getText");
			GV.PayMList.getRows()[GV.EditIndex]["caption"] = text;
		}
	}
}

/**
 * 支付方式列表加载成功
 */
function onLoadSuccessPaym(data) {
	var defAmt = getValueById("winPayAmt");
	var defRowIndex = 0;
	$.each(data.rows, function (index, row) {
		if (row.selected) {
			defRowIndex = index;
			return false;
		}
	});
	
	GV.PayMList.updateRow({
		index: defRowIndex,
		row: {
			CTPMAmt: defAmt
		}
	});
	//改变平衡金额的值(支付方式)
	setBalance();
}

/**
 * 支付方式Grid单元格单击事件
 */
function paymClickCell(index, field, value) {
	paymEditCell(index, field, value);
}

/**
* 单击支付方式单元格
*/
function paymEditCell(index, field, value) {
	GV.PayMList.selectRow(index);   //选中设定行
	var isEdit = isCellAllowedEdit(index, field, value);
	if (!isEdit) {
		return;
	}
	if (endEditing()) {
		GV.PayMList.editCell({
			index: index,
			field: field
		});
		var ed = GV.PayMList.getEditor({
				index: index,
				field: field
			});
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
	var row = GV.PayMList.getRows()[index];
	//走配置 支付方式不能编辑
	if ((field != "CTPMAmt") && (field != "CTPMDesc")) {
		var flag = isPaymRequired(row.CTPMRowID);
		if (flag == 0) {
			return false;
		}
	}
	return true;
}

function paymBeginEdit(index, row) {
	var ed = GV.PayMList.getEditor({index: index, field: "CTPMAmt"});
	if (ed) {
		var maxLen = GV.PayMList.getData().total;
		$(ed.target).keydown(function(e) {
		  	var key = websys_getKey(e);
			if (key == 13) {
				var nextIndex = getNextEditRow();
				$(ed.target).numberbox("setValue", $(this).val());
				GV.PayMList.endEdit(index);
				if (nextIndex < maxLen) {
					paymEditCell(nextIndex, "CTPMAmt", "");
				}else {
					focusById("win-btn-sell");
				}
			}
		});
	}
}

function getNextEditRow() {
	var nextIndex = GV.EditIndex + 1;
	return nextIndex;
}

/**
* 取支付方式是否有必填项 1:必填 0无
*/
function isPaymRequired(paymId) {
	return $.m({ClassName: "web.DHCIPBillCashier", MethodName: "IsRequiredInfo", group: PUBLIC_CONSTANT.SESSION.GROUPID, pmId: paymId}, false);
}

function endEditing() {
	if (GV.EditIndex == undefined) {
		return true;
	}
	if (GV.PayMList.validateRow(GV.EditIndex)) {
		var ed = GV.PayMList.getEditor({
				index: GV.EditIndex,
				field: "CTPMBank"
			});
		if (ed) {
			var text = $(ed.target).combobox("getText");
			GV.PayMList.getRows()[GV.EditIndex]["CTPMBank"]["caption"] = text;
		}
		GV.PayMList.endEdit(GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}

/**
* 设置应填金额
*/
function setTipAmt() {
	if (GV.EditIndex == undefined) {
		return;
	}
	var ed = GV.PayMList.getEditor({
		index: GV.EditIndex,
		field: "CTPMAmt"
	});
	if (ed) {
		var row = GV.PayMList.getSelected();
		var paymAmt = row.CTPMAmt;
		var balanceAmt = getGlobalValue("BalanceAmt");
		var tipAmt = numCompute(paymAmt, balanceAmt, "+");
		$("#tipAmt").html(tipAmt);
	}
}

/**
* 支付方式结束编辑
*/
function paymAfterEdit() {
	GV.EditIndex = undefined;
	setBalance();
}

/**
 * 设置平衡金额
 */
function setBalance() {
	var payAmt = getValueById("winPayAmt");
	var pmAll = getPayMAll();
	var pmBalance = numCompute(payAmt, pmAll, "-");
	setGlobalValue("BalanceAmt", pmBalance);
}

/**
* 获取当前所有支付方式的和
*/
function getPayMAll() {
	var paymAll = 0;
	$.each(GV.PayMList.getRows(), function (index, row) {
		var paymAmt = row.CTPMAmt;
		paymAll = numCompute(paymAll, paymAmt, "+");
	});
	return paymAll;
}

/**
* 点击应填金额时 自动填充到正在编辑的单元格
*/
function setColumnVal() {
	if (GV.EditIndex == undefined) {
		return;
	}
	var tipAmt = $("#tipAmt").text() || 0;
	if (+tipAmt != 0) {
		var ed = GV.PayMList.getEditor({
				index: GV.EditIndex,
				field: "CTPMAmt"
			});
		if (ed) {
			$(ed.target).numberbox("setValue", tipAmt);
		} else {
			GV.PayMList.updateRow({
				index: GV.EditIndex,
				row: {
					CTPMAmt: tipAmt
				}
			});
		}
	}
}

function setGlobalValue(key, value) {
	GV["" + key + ""] = value;
}

function getGlobalValue(key) {
	return GV["" + key + ""] || "";
}

/**
* 实收
*/
function preSumKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var cashAmt = 0;    //收退现金金额
		$.each(GV.PayMList.getRows(), function (index, row) {
			var paymAmt = row.CTPMAmt;
			var paymCode = row.CTPMCode;
			if (paymCode == "CASH") {
				cashAmt = numCompute(cashAmt, paymAmt, "+");
			}
		});
		var preSum = $(e.target).val();
		var change = preSum - cashAmt;
		setValueById("winChange", toNumber(change).toFixed(2));
	}
}

/**
* 订购
*/
function winSellClick() {
	if (!endEditing()) {
		return;
	}
	disableById("win-btn-sell");
	var patientId = getValueById("patientId");
	
	var payInfo = getPayModeList();
	var productStr = getCheckedProIdStr();
	var receiptNo = getValueById("receiptNo");
	var preSum = getValueById("winPreSum");
	var changeAmt = getValueById("winChange");
	var buyerInfo = getValueById("buyUser") + "^" + getValueById("buyTelePhone") + "^" + getValueById("buyWork");
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + receiptNo;
	expStr += "^" + preSum + "^" + changeAmt;
	$.messager.confirm("确认", "确认订购？", function(r) {
		if (r) {
			$.m({
				ClassName: "BILL.PKG.BL.ProductSell",
				MethodName: "ProSell",
				patientId: patientId,
				patType: getValueById("patType"),
				productStr: productStr,
				payInfo: payInfo,
				payAmt: getValueById("salesAmt"),
				guserId: PUBLIC_CONSTANT.SESSION.USERID,
				buyerInfo: buyerInfo,
				expStr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				switch(myAry[0]) {
				case "0":
					var prtRowId = myAry[1];
					$.messager.alert("提示", "订购成功", "success", function() {
						$("#paymWin").dialog("close");
						loadPkgInvList(prtRowId);
						enableById("btn-setHolder");
					});
					break;
				case "-101":
					$.messager.alert("提示", "住院只能订购一个套餐", "error");
					break;
				default:
					enableById("win-btn-sell");
					$.messager.alert("提示", "预售失败，错误代码:" + rtn, "error");
				}
			});
		}else {
			enableById("win-btn-sell");
		}
	});
}

function getPayModeList() {
	var paymAry = [];
	$.each(GV.PayMList.getRows(), function(index, row) {
		var paymAmt = row.CTPMAmt || 0;
		var paymDR = row.CTPMRowID || "";
		var paymCode = row.CTPMCode || "";
		var bankId = row.CTPMBank || "";
		var chequeNo = row.CTPMCheckno || "";
		var payUnit = row.CTPMUnit || "";
		var payAccNo = row.CTPMBankNo || "";
		var chequeDate = "";
		if (+paymAmt != 0) {
			paymAmt = toNumber(paymAmt).toFixed(2);
			//payMId(支付方式id)^payMAmt(支付金额)^bankId(银行id)^chequeNo(支票号/银行卡号)^patUnit(支付单位id)^payAccNo(支票对方账户号)^chequeDate(支票日期)
			var paymStr = paymDR + "^" + paymAmt + "^" + bankId + "^" + chequeNo + "^" + payUnit + "^" + payAccNo + "^" + chequeDate;
			paymAry.push(paymStr);
		}
	});
	var paymStr = paymAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
	
	return paymStr;
}

function toNumber (val) {
  var n = parseFloat(val);
  return isNaN(n) ? val : n;
}