/**
 * FileName: dhcbill.ipbill.charge.common.js
 * Author: ZhYW
 * Date: 2019-03-04
 * Description: 住院收费公共js
 */

//全局变量
var GV = {
	PatientID: "",
	EpisodeID: "",
	BillID: "",
	PrtRowID: "",
	OpenPayMWin: "N",        //设置自费患者结算是否弹框结算(Y：弹框，<>Y：不弹框)
	CancelInsuDiv: "Y",      //关闭结算弹窗时是否撤销医保结算(Y：撤销，<>Y：不撤销)
	EditIndex: undefined,    //支付方式grid编辑行索引
	DischgStatAry: ["D", "F", "T"]   //最终结算、护士办理出院、结束费用调整
};

$(function () {
	//结算
	$HUI.linkbutton("#btn-disCharge", {
		onClick: function () {
			sleep(500);
			chargeClick();
		}
	});
	
	//实付回车事件
	$("#patPaidAmt").keydown(function (e) {
		patPaidAmtKeydown(e);
	});

	initPayMList();
	initDepositList();
	
	checkInv();   //设置默认发票号
});

/**
* 初始化支付方式Grid
*/
function initPayMList() {
	var opt = {
		title: '支付信息'
	}
	if (isShowModalWin()) {
		opt = {
			title: $("#tipDiv").html()
		}
	}
	GV.PayMList = $HUI.datagrid("#paymList", {
		fit: true,
		border: true,
		title: opt.title,
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		toolbar: [],
		pageSize: 999999999,
		loadMsg: '',
		columns: [[{title: 'CTPMRowID', field: 'CTPMRowID', hidden: true},
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
				   {title: '金额', field: 'CTPMAmt', width: 100, align: 'right', editor: {
						type: 'numberbox',
						options: {
							precision: 2
						}
					}
				   },
				   {title: 'CTPMBankRowID', field: 'CTPMBankRowID', hidden: true},
				   {title: '银行', field: 'CTPMBank', width: 160, editor: {
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
				 {title: '支票号/卡号', field: 'CTPMCheckNo', width: 140, editor: 'text'},
				 {title: 'CTPMUnitRowID', field: 'CTPMUnitRowID', hidden: true},
				 {title: '公费单位', field: 'CTPMUnit', width: 121, editor: {
						type: 'combobox',
						options: {
							valueField: 'id',
							textField: 'text',
							url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryHCPList&ResultSetType=array&patientId=' + GV.PatientID + '&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
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
					}
				  },
				 {title: '账户', field: 'CTPMAccount', hidden: true},
				 {title: '转账', field: 'CTPMTransFlag', width: 50, align: 'center', hidden: true,
				 	formatter: function(value, row, index) {
					 	return "<input type='checkbox' " + ((value == "Y") ? "checked" : "") + "/>";
					}
				 },
				 {title: 'CTPMInsuFlag', field: 'CTPMInsuFlag', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillCashier",
			QueryName: "ReadPayMList",
			groupId: PUBLIC_CONSTANT.SESSION.GROUPID,
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
			prtRowId: GV.PrtRowID,
			rows: 99999999
		},
		onLoadSuccess: function (data) {
			$("#tipAmt").text("");
			if (!disablePayMGrid()) {
				var success = insuDivide();
				$("#btn-disCharge").linkbutton({disabled: ($("#btn-disCharge").linkbutton("options").disabled || !success)});
			}
			//2023-03-10 Lid 延迟下，要等押金列表先加载完成
			setTimeout(function () {
				onLoadSuccessPaym();
			}, 200);
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
* 初始化押金Grid
*/
function initDepositList() {
	var opt = {
		iconCls: null,
		headerCls: null,
		bodyCls: 'panel-body-gray',
		title: null,
		toolbar: null,
		fitColumns: false
	}
	if (isShowModalWin()) {
		opt = {
			iconCls: 'icon-paper',
			headerCls: 'panel-header-gray',
			bodyCls: null,
			title: '押金列表',
			toolbar: [],
			fitColumns: true
		}
	}
	GV.DepositList = $HUI.datagrid("#depositList", {
		fit: true,
		iconCls: opt.iconCls,
		headerCls: opt.headerCls,
		bodyCls: opt.bodyCls,
		title: opt.title,
		checkOnSelect: false,
		selectOnCheck: false,
		singleSelect: true,
		fitColumns: opt.fitColumns,
		toolbar: opt.toolbar,
		rownumbers: true,
		idField: 'TDepRowId',
		pageSize: 99999999,
		className: "web.DHCIPBillCashier",
		queryName: "FindDepList",
		onColumnsLoad: function(cm) {
			cm.unshift({field: 'ck', checkbox: true});   //往数组开始位置增加一项
			for (var i = (cm.length-1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["TPrtDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["TDepRowId", "TBillFlag", "TUn2PayReason"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "TPrtTime") {
					cm[i].formatter = function (value, row, index) {
						return row.TPrtDate + " " + value;
					};
				}
				if (cm[i].field == "TPrtStatus") {
					cm[i].formatter = function (value, row, index) {
						return (value == 1) ? $g("正常") : value;
					};
				}
				if (cm[i].field == "TIsReverseDep") {
					cm[i].formatter = function (value, row, index) {
						var color = (value == 1) ? "#21ba45" : "#f16e57";
						return "<font color=\"" + color + "\">" + ((value == 1) ? $g("是") : $g("否")) + "</font>";
					};
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "TPrtTime") {
						cm[i].width = 160;
					}
				}
			}
		},
		url: $URL,
		queryParams: {
			ClassName: "web.DHCIPBillCashier",
			QueryName: "FindDepList",
			adm: GV.EpisodeID,
			prtRowId: GV.PrtRowID,
			rows: 99999999
		},
		onBeforeLoad: function(param) {
			$(this).datagrid("getPanel").find(".datagrid-header-row input:checkbox, .datagrid-row input:checkbox").removeAttr("disabled");   //移除disabled属性，防止前一个患者disabled影响本次
			$(this).datagrid("uncheckAll");
		},
		onLoadSuccess: function (data) {
			onLoadSuccessDepList(data);
		},
		onCheckAll: function (rows) {
			if (rows.length == 0) {
				return;
			}
			$.each(rows, function (index, row) {
				if (row.TBillFlag == 0) {
					GV.DepositList.uncheckRow(index);
				}
			});
			changeDeposit();
		},
		onUncheckAll: function (rows) {
			if (rows.length == 0) {
				return;
			}
			changeDeposit();
		},
		onCheck: function (index, row) {
			if (row.TBillFlag == 0) {
				GV.DepositList.uncheckRow(index);
			} else {
				changeDeposit(index);
			}
		},
		onUncheck: function (index, row) {
			if (row.TBillFlag != 0) {
				changeDeposit(index);
			}
		}
	});
}

/**
 * 押金列表加载成功
 */
function onLoadSuccessDepList(data) {
	setDepPanelTitle(data);
	GV.DisabledDepAllRows = isDisableDepAllRows();  //(true:disabled所有行)
	if (data.total == 0) {
		return;
	}
	$.each(data.rows, function (index, row) {
		//判断行是否可勾选
		if ((row.TBillFlag == 0) || GV.DisabledDepAllRows) {
			GV.DepositList.getPanel().find("div.datagrid-cell-check>input:checkbox").eq(index).prop("disabled", true);
		}
		//行不可勾选时，显示不可勾选原因
		if (row.TBillFlag == 0) {
			GV.DepositList.getPanel().find(".datagrid-row[datagrid-row-index=" + index + "]>td>div:not(.datagrid-cell-rownumber,.datagrid-cell-check)").mouseover(function() {
				$(this).popover({
					title: '不能参与结算原因',
					trigger: 'hover',
					content: row.TUn2PayReason
				}).popover("show");
			});
		}
	});
	//有disabled行时,表头也disabled
	if (GV.DepositList.getPanel().find("div.datagrid-cell-check>input:checkbox:disabled").length > 0) {
		GV.DepositList.getPanel().find("div.datagrid-header-check>input:checkbox").eq(0).prop("disabled", true);
	}
	//如果是最终结算的押金也不可选
	GV.AutoSelDepFlag = true;
	GV.DepositList.checkAll();
	GV.AutoSelDepFlag = false;
}

/**
* true: disable所有行
*/
function isDisableDepAllRows() {
	//1.是否可选择押金结算配置
	var disabled = (IPBILL_CONF.PARAM.SelectDepToPay != "Y");   
	if (disabled) {
		return true;
	}
	//2.需要弹窗结算且当前界面非弹窗时disabled
	disabled = disablePayMGrid();
	if (disabled) {
		return true;
	}
	//3.是否最终结算时只有一笔待结算账单
	var admStatusJson = getAdmStatusJson();
	if ($.inArray(admStatusJson.statusCode, GV.DischgStatAry) != -1) {
		var num = $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetNotPayedNum", Adm: GV.EpisodeID}, false);
		disabled = (num <= 1);
	}
	if (disabled) {
		return true;
	}
	//4.账单是否已结算
	disabled = isChgedBill();
	if (disabled) {
		return true;
	}
	return disabled;
}

/**
* 押金支付方式汇总金额
*/
function setDepPanelTitle(data) {
	if (!GV.DepositList.options().title) {
		return;
	}
	var paymObj = {};
	$.each(data.rows, function(index, row) {
		if (!row.TDepRowId) {
			return true;
		}
		paymObj[row.TPayMDesc] = Number(paymObj[row.TPayMDesc] || 0).add(row.TDepAmt).toFixed(2);
	});

	var paymAry = [];
	$.each(Object.keys(paymObj), function(index, prop) {
		paymAry.push(prop + ": " + paymObj[prop]);
	});
	GV.DepositList.getPanel().panel("setTitle", ($g("押金列表") + "<span style=\"margin-left:30px;\">" + paymAry.join("&emsp;") + "</span>"));
}

/**
 * 支付方式列表加载成功
 */
function onLoadSuccessPaymOLD() {
	if (disablePayMGrid()) {
		return;
	}
	if (isChgedBill()) {
		return;
	}
	var defAmt = getBalanceAmt();     //取默认应交费用
	var defPayMIdx = getDefPayMListIdx();
	if (defPayMIdx !== "") {
		var row = GV.PayMList.getRows()[defPayMIdx];
		//判断当前默认支付方式是否有值，如果有值默认+该值
		defAmt = GV.BillID ? Number(defAmt).add(row.CTPMAmt).toFixed(2) : "";
		GV.PayMList.updateRow({
			index: defPayMIdx,
			row: {
				CTPMAmt: defAmt
			}
		});
	}
}

/**
 * 支付方式列表加载成功
 */
function onLoadSuccessPaym() {
	sleep(200);  //2023-03-10 Lid 加载支付方式休眠200ms，等待支付方式列表加载完成
	if (disablePayMGrid()) {
		return;
	}
	if (isChgedBill()) {
		return;
	}
	var defPayMId = getDefPayMId();
	var defAmt = getBalanceAmt();     //取默认应交费用
	//var billInfo = getBillBaseInfo();
	//var billFlag = billInfo ? billInfo.split("^")[15] : "";
	
	//2023-03-09 Lid 根据规则计算支付方式退款金额
	var tmpDefAmt = defAmt;
	var payMRefundList = "";
	
	if(+defAmt < 0) {
		var selDepList = getCheckedDepRowIdStr();
		//1.参与结算的押金列表
		//2.根据规则计算支付方式退款金额
		if(selDepList != "") {
			payMRefundList = tkMakeServerCall("BILL.IP.BL.ChgedRefundDep", "GetDepPayMRefundListNew", selDepList, tmpDefAmt);
		}
	}	
	
	$.each(GV.PayMList.getRows(), function (index, row) {		
		if (row.CTPMInsuFlag == "Y") {
			return true;   //过滤医保支付的
		}
		var rowPmDR = row.CTPMRowID;
		var rowAmt = row.CTPMAmt;
		if (+defAmt >= 0){
			if (rowPmDR == defPayMId) {
				//判断当前默认支付方式是否有值，如果有值默认+该值
				defAmt = GV.BillID ? Number(defAmt).add(row.CTPMAmt).toFixed(2) : "";
				GV.PayMList.updateRow({
					index: index,
					row: {
						CTPMAmt: defAmt
					}
				});
				return false;
			}
		}else{
			if((payMRefundList != "") && (rowPmDR!="")){
				var currPayMAmt = tkMakeServerCall("BILL.IP.BL.ChgedRefundDep", "GetCurrPayMAmt", payMRefundList, rowPmDR);
				if (currPayMAmt != 0){
					GV.PayMList.updateRow({
						index: index,
						row: {
							CTPMAmt: currPayMAmt
						}
					});
				}
			}
		}
	});
}

/**
* 改变押金时，计算费用
*/
function changeDeposit() {
	var rowIndex = arguments[0];   //行号
	if (disablePayMGrid()) {
		return;
	}
	
	//取已选押金
	var selDepSum = getSelDepSum();
	setValueById("selDepAmt", selDepSum);
	
	calcReceRefAmt();  //应收、应退
	
	//清空支付方式列表的值
	if (!GV.AutoSelDepFlag) {
		clearSelfPayMAmt();
		//onLoadSuccessPaym();
	}
	
	//设置必填金额
	setTipAmt();
	
	if (!GV.AutoSelDepFlag) {
		setPayMListFocus();
	}
	
	ctrlDepChecked(rowIndex);   //2022-08-25 ZhYW 控制已选押金足额时，不能再勾选其余押金
	
	setTimeout(function() {
		onLoadSuccessPaym();
	}, 200);
}

/**
* 清除自费支付方式金额
*/
function clearSelfPayMAmt() {
	$.each(GV.PayMList.getRows(), function(index, row) {
		if (row.CTPMInsuFlag == "Y") {
			return true;
		}
		var ed = GV.PayMList.getEditor({index: index, field: "CTPMAmt"});
		if (ed) {
			$(ed.target).numberbox("clear");
			return true;
		}
		GV.PayMList.updateRow({
			index: index,
			row: {
				CTPMAmt: ""
			}
		});
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
 * 获取账单的费别 ID 和 NationalCode
 */
function getAdmReason() {
	if (!GV.BillID) {
		return new Array("", "", "", "");
	}
	var rtn = $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetBillReaNationCode", BillNo: GV.BillID}, false);
	return rtn.split("^");
}

/**
 * 获取账单红冲标识
 */
function getBillRefFlag() {
	return getPropValById("DHC_PatientBill", GV.BillID, "PB_RefundFlag");
}

/**
 * 获取账单号费用信息
 */
function getBillPatFeeInfo() {
	return $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPatFeeByBillNO", billId: GV.BillID, expStr: ""}, false);
}

/**
* 取默认支付方式费用
*/
function getBalanceAmt() {
	var patShareAmt = getValueById("patShareAmt");  //自付金额
	var depositAmt = getValueById("selDepAmt");     //已选押金
	var balanceAmt = Number(patShareAmt).sub(depositAmt).toFixed(2);
	var paymSum = getPayMSum();
	return Number(balanceAmt).sub(paymSum).toFixed(2);
}

/**
* 获取多退少补金额
*/
function getRefOrPayAmt() {
	var patShareAmt = getValueById("patShareAmt");
	var insuAmt = getValueById("insuAmt");
	var selDepSum = getValueById("selDepAmt");
	return Number(Number(patShareAmt).sub(insuAmt).toFixed(2)).sub(selDepSum).toFixed(2);
}

/**
* 获取当前所有支付方式的金额合计
*/
function getPayMSum() {
	return GV.PayMList.getRows().filter(function(row) {
		return (row.CTPMAmt != 0);
	}).reduce(function (total, row) {
        return Number(total).add(row.CTPMAmt).toFixed(2);
    }, 0);
}

/**
* 设置支付方式列表的默认支付方式的行索引
*/
function getDefPayMListIdx() {
	var defPayMId = getDefPayMId();
	var rows = GV.PayMList.getRows();
	var defPayMIdx = (rows.length > 0) ? 0 : "";
	$.each(rows, function (index, row) {
		if (row.CTPMInsuFlag == "Y") {
			return true;   //过滤医保支付的
		}
		if (row.CTPMRowID != defPayMId) {
			return true;
		}
		defPayMIdx = index;
		return false;
	});
	return defPayMIdx;
}

/**
* 设置默认的支付方式列表的焦点
*/
function setPayMListFocus() {
	if (isChgedBill()) {
		return;
	}
	var defPayMIdx = getDefPayMListIdx();
	if (defPayMIdx !== "") {
		paymEditCell(defPayMIdx, "CTPMAmt", "");
	}
}

/**
 * 支付方式Grid单元格单击事件
 */
function onClickCellHandler(index, field, value) {
	if (disablePayMGrid()) {
		return;
	}
	if (!GV.BillID) {
		$.messager.popover({msg: "请先选择账单或此患者为新住院患者", type: "info"});
		return;
	}
	//如果是结算过的，单击不起作用
	if (isChgedBill()) {
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
	//医保支付方式不能编辑
	if (row.CTPMInsuFlag == "Y") {
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

function validatePayMRow() {
	if (!endEditing()) {
		return false;
	}
	
	var bool = true;
	var field = "";
	var existPayMCode = "";
	$.each(GV.PayMList.getRows(), function (index, row) {
		var paymAmt = row.CTPMAmt || 0;
		if (paymAmt == 0) {
			return true;
		}
		if (row.CTPMInsuFlag == "Y") {
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
		}
	});
	
	return bool;
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
		if (row.CTPMInsuFlag == "Y") {
			nextIndex++;
			continue;
		}
		break;
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
			var balanceAmt = getBalanceAmt();
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
	if (disablePayMGrid()) {
		return;
	}	
	var paymId = "";
	var amt = 0;
	var paymDesc = "";
	var mPayMCanRef = 0;
	var callFlag = 0;
	if (GV.EditIndex != undefined) {
		var row = GV.PayMList.getRows()[GV.EditIndex];
		paymId = row.CTPMRowID;
		//判断该支付方式的可退款金额
		var payAry = getExtTradePayList();
		$.each(payAry, function(index, item) {
			if (item.PayMode == paymId) {
				mPayMCanRef = item.RefundAmt;
				return false;
			}
		});
		amt = row.CTPMAmt;
		paymDesc = row.CTPMDesc;
		var rtnValue = tkMakeServerCall("DHCBILL.Common.DHCBILLCommon", "GetCallModeByPayMode", paymId);
		callFlag = rtnValue.split("^")[0];
	}
	if ((callFlag != 0) && (+amt < 0)  && (Number(mPayMCanRef).add(amt) < 0)){
		$.messager.popover({msg: paymDesc + "支付方式不允许退大于" + mPayMCanRef + "的金额", type: "error"});
		GV.PayMList.updateRow({
			index: GV.EditIndex,
			row: {
				CTPMAmt: ""
			}
		});
	}
	GV.EditIndex = undefined;
}

/**
* 设置支付方式列表panel的title
*/
function setPayMPanelTitle(tipAmt) {
	if (disablePayMGrid()) {
		GV.PayMList.getPanel().panel("setTitle", "支付信息");
		return;
	}
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
* 添加医保金额
*/
function addGridInsuInfo(insuDivStr) {
	if (!insuDivStr) {
		return;
	}
	var tmpAry = insuDivStr.split("|");
	if (tmpAry[0] != 0) {
		disableById("disChargeBtn");    //医保结算不成功，"出院结算"按钮变灰
		return;
	}
	//1.首先判断页面上是否已经有了医保要添加的支付方式
	//2.如果有改变原来的值，没有的话再添加
	var insuSum = 0;
	var insuPMErrAry = [];
	var insuDivAry = insuDivStr.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
	for (var i = 1, len = insuDivAry.length; i < len; i++) {
		var insuPMAry = insuDivAry[i].split("^");
		var pmId = insuPMAry[0];
		var pmAmt = insuPMAry[1];             
		if (isInsuPMExist(pmId)) {     //判断页面上是否已经有了医保要添加的支付方式
			return;
		}
		var paymJson = getPersistClsObj("User.CTPayMode", pmId);
		if (!paymJson.ID) {
			insuPMErrAry.push(pmId);
			continue;
		}
		var row = {};
		var val = "";
		$.each(GV.PayMList.getColumnFields(), function (index, item) {
			switch(item) {
			case "CTPMRowID":
				val = pmId;
				break;
			case "CTPMCode":
				val = paymJson.CTPMCode;
				break;
			case "CTPMDesc":
				val = paymJson.CTPMDesc;
				break;
			case "CTPMAmt":
				val = pmAmt;
				break;
			case "CTPMTransFlag":
				val = "N";
				break;
			case "CTPMInsuFlag":
				val = "Y";
				break;
			default:
				val = "";
			}
			row[item] = val;
		});
		GV.PayMList.insertRow({
			index: 0,
			row: row
		});
		insuSum = Number(insuSum).add(pmAmt).toFixed(2);
	}
	//更新医保金额
	setValueById("insuAmt", insuSum);
	calcReceRefAmt();  //应收、应退
	if (insuPMErrAry.length > 0) {
		$.messager.popover({msg: "医保结算支付方式：" + insuPMErrAry.join("，") + "在HIS系统中不存在，请联系信息科", type: "info"});
	}
}

/**
* 判断某个医保支付方式在支付方式列表上已经存在
*/
function isInsuPMExist(pmId) {
	return GV.PayMList.getRows().some(function(row) {
		return ((row.CTPMInsuFlag == "Y") && (row.CTPMRowID == pmId));
	});
}

/**
* 判断支付方式是否有必填项
* true:有 false:无
*/
function isPaymRequired(paymId) {
	return ($.m({ClassName: "web.DHCIPBillCashier", MethodName: "IsRequiredInfo", groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID, paymId: paymId}, false) == 1);
}

/**
* 判断医保是否已经结算
* true:自费或医保已结算，false:医保未结算
*/
function isInsuDivided() {
	return ($.m({ClassName: "web.DHCIPBillCashier", MethodName: "IsInsuDivided", bill: GV.BillID}, false) == 1);
}

/**
* 获取账单状态不为P的账单数量
*/
function getNotPayedBillNum() {
	return $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "JudgeBillNum", Adm: GV.EpisodeID}, false);
}

/**
* 获取婴儿未结算押金
*/
function getBabyDepositNum() {
	return $.m({ClassName: "web.DHCIPBillCashier", MethodName: "JudgeBabyDeposit", Adm: GV.EpisodeID, HospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
}

/**
 * 设置金额信息
 */
function initPatFeeInfo() {
	var rtn = $.m({ClassName: "web.DHCIPBillCashier", MethodName: "GetPatInfo", EpisodeID: GV.EpisodeID, PBRowID: GV.BillID}, false);
	var myAry = rtn.split("$");
	var feeInfoStr = myAry[2];
	var feeInfoArr = feeInfoStr.split("^");
	var totalAmt = feeInfoArr[1];
	var patShareAmt = feeInfoArr[2];
	var discAmt = feeInfoArr[3];
	var payorAmt = feeInfoArr[4];
	var insuAmt = feeInfoArr[8];
	
	var depInfo = getDepositInfo();
	var depAry = depInfo.split("^");
	var selDepAmt = depAry[1];
	
	setValueById("totalAmt", totalAmt);
	setValueById("selDepAmt", selDepAmt);
	setValueById("patShareAmt", patShareAmt);
	setValueById("payorAmt", payorAmt);
	setValueById("discAmt", discAmt);
	setValueById("insuAmt", insuAmt);
	calcReceRefAmt();  //应收、应退
}

/**
* 计算应收应退、金额
* 应收/应退 = 自付 - 医保支付- 押金
*/
function calcReceRefAmt() {
	var amt = getRefOrPayAmt();
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
* 获取全部押金金额
*/
function getAllDepSum() {
    return GV.DepositList.getRows().reduce(function (total, row) {
        return Number(total).add(row.TDepAmt).toFixed(2);
    }, 0);
}

/**
* 获取选择的押金金额
*/
function getSelDepSum() {
    return GV.DepositList.getChecked().reduce(function (total, row) {
        return Number(total).add(row.TDepAmt).toFixed(2);
    }, 0);
}

/**
* 获取选择的押金
*/
function getCheckedDepIdStr() {
    return GV.DepositList.getChecked().map(function (row) {
        return row.TDepRowId;
    }).join("^");
}

/**
* 获取未选押金金额
*/
function getUnSelDepSum() {
	var allDepSum = getAllDepSum();
    var selDepSum = getValueById("selDepAmt"); 
    return Number(allDepSum).sub(selDepSum).toFixed(2);
}

/**
 * 账单
 */
function billClick() {
	if (!GV.EpisodeID) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFORDCHK", "getmotheradm", GV.EpisodeID);
	if (rtn == "true") {
		$.messager.popover({msg: "婴儿不允许做账单", type: "info"});
		return;
	}
	if (isChgedBill()) {
		$.messager.popover({msg: "此账单已结算，不能账单", type: "info"});
		return;
	}
	if (isClosedBill()) {
		$.messager.popover({msg: "此账单已封账，不能账单", type: "info"});
		return;
	}
	var refundFlag = getBillRefFlag();
	if (refundFlag == "B") {
		$.messager.popover({msg: "此账单已经红冲，不能账单", type: "info"});
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "Bill", "", "", GV.EpisodeID, PUBLIC_CONSTANT.SESSION.USERID, GV.BillID, ClientIPAddress);
	var myAry = rtn.split("^");
	if (myAry[0] == 0) {
		$.messager.popover({msg: "账单成功", type: "success"});
		updateBillListData();
		onLoadSuccessPaym();
		if (!isOpenPayMWin()) {
			setPayMListFocus();
		}
		return;
	}
	$.messager.popover({msg: "账单失败：" + (myAry[1] || myAry[0]), type: "error"});
}

/**
* 账单成功后 不刷新界面只更新患者数据
*/
function updateBillListData() {
	if (isChgedBill()) {
		return;
	}
	//未结算记录修改数据
	//押金$c(2)总金额^自付金额^折扣金额^记账金额
	//更新费用信息
	var rtn = getBillPatFeeInfo();
	var tmpAry = rtn.split(PUBLIC_CONSTANT.SEPARATOR.CH2);
	var patFeeAry = tmpAry[1].split("^");
	var insuAmt = tmpAry[3];    //医保金额
	setValueById("totalAmt", patFeeAry[0]);
	setValueById("patShareAmt", patFeeAry[1]);
	setValueById("discAmt", patFeeAry[2]);
	setValueById("payorAmt", patFeeAry[3]);
	calcReceRefAmt();   //应收、应退

	//更新选中记录的数据
	//需更新押金、总金额、自付费用、（折扣费用）
	var selectRow = GV.BillList.getSelected();
	if (!selectRow) {
		return;
	}
	var rowIndex = GV.BillList.getRowIndex(selectRow);
	GV.BillList.updateRow({
		index: rowIndex,
		row: {
			totalamount: patFeeAry[0],
			patientshare: patFeeAry[1],
			discountamount: patFeeAry[2],
			payorshare: patFeeAry[3]
		}
	});
}

/**
* 打印多张发票
*/
function printMultiInv() {
	var url = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvprtzySub&Adm=" + GV.EpisodeID + '&BillNo=' + GV.BillID + '&prtrowid=' + prtRowId;
	websys_showModal({
		url: url,
		title: "打印多张发票",
		iconCls: "icon-w-inv",
		width: "70%",
		height: "70%"
	});
}

/**
* 判断是否在结算前账单后是否又交了押金
* 根据押金列表的金额和后台进行判断，判断总金额和可使用金额，并判断患者信息上的押金额
*/
function judgeDepositSum() {
    //后台获取押金总数和可用押金总数
    var rtn = getDepositInfo();
    var myAry = rtn.split("^");
    var actualAllDep = myAry[0];  //后台总押金
    var actualAvaiDep = myAry[1]; //后台可用押金
    //押金列表总押金
    var thisAllDep = getAllDepSum();

    //押金列表可用押金
    var thisAvaiDep = GV.DepositList.getRows().filter(function (row) {
        return (row.TBillFlag == 1);
    }).reduce(function (total, row) {
        return Number(total).add(row.TDepAmt).toFixed(2);
    }, 0);

    return ((actualAllDep == thisAllDep) && (actualAvaiDep == thisAvaiDep));
}

/**
* 获取可用发票
*/
function checkInv() {
	var insTypeId = getInsTypeId();
	if (!isRequiredInv(insTypeId)) {
		return true;         //不需要打印发票时退出
	}
	var rtn = $.m({ClassName: "web.UDHCJFPAY", MethodName: "ReadReceiptNO", userId: PUBLIC_CONSTANT.SESSION.USERID, insTypeId: insTypeId, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	var myAry = rtn.split("^");
	if (myAry[0] != 0) {
		return false;
	}
	var currNo = myAry[1];
	var rowId = myAry[2];
	var endNo = myAry[3];
	var title = myAry[4];
	var leftNum = myAry[5];
	var tipFlag = myAry[6];
	var receiptNo = title + "[" + currNo + "]";
	setValueById("currentInvId", rowId);
	setValueById("currentInv", receiptNo);
	var color = "green";
	if ($("#currentInv").hasClass("newClsInvalid")) {
		$("#currentInv").removeClass("newClsInvalid");
	}
	if (tipFlag == 1) {
		color = "red";
		$("#currentInv").addClass("newClsInvalid");
	}
	var content = $g("该号段可用票据剩余") + " <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> " + $g("张");
	$("#btn-tip").show().popover({cache: false, trigger: 'hover', content: content});
	return true;
}

/**
* 获取全部押金和可用押金
*/
function getDepositInfo() {
	return $.m({ClassName: "web.DHCIPBillCashier", MethodName: "GetDepositSum", adm: GV.EpisodeID, prtRowId: GV.PrtRowID}, false);
}

/**
* 判断账单费别是否需要发票
* true:需要发票, false:不需要发票
*/
function isRequiredInv(insTypeId) {
	return ($.m({ClassName: "web.UDHCJFPAY", MethodName: "CheckPrtFlag", insTypeId: insTypeId, groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID, printInvFlag: "Y"}, false) == 0);
}

/**
* 判断账单是否已封账
* true:已封账, false:未封账
*/
function isClosedBill() {
	return ($.m({ClassName: "web.DHCIPBillPBCloseAcount", MethodName: "GetPaidCAcountFlag", BillNo: GV.BillID}, false) == "Y");
}

/**
* 获取医保结算信息
* 	1: 医保已上传明细
* 	2: 医保已结算
* 	<0: 医保未结算未上传
*/
function getInsuUpFlag() {
	return $.m({ClassName: "web.DHCIPBillCashier", MethodName: "JudgePBInsuUpFlag", BillNo: GV.BillID, ExpStr: ""}, false)
}

/**
* 费用审核
* 	true: 审核通过
* 	false: 未审核或审核不通过
*/
function isExamPassed() {
	return ($.m({ClassName: "web.UDHCJFBillDetailOrder", MethodName: "GetCodingFlag", Adm: GV.EpisodeID, BillNo: GV.BillID}, false) == "Y");
}

/**
* 根据就诊判断账单是否被拆分
*/
function isSplitByAdm() {
	return ($.m({ClassName: "web.UDHCJFPAY", MethodName: "CheckBillIsSplitByAdm", episodeID: GV.EpisodeID}, false) == "Y");
}

/**
* 获取费别Id
*/
function getInsTypeId() {
	var rtn = $.m({ClassName: "web.DHCIPBillCashier", MethodName: "GetInsTypeInfo", EpisodeID: GV.EpisodeID, BillNo: GV.BillID}, false);
	var myAry = rtn.split("^");
	var insTypeId = myAry[0] || "";
	return insTypeId;
}

/**
* 判断账单是否已结算
*/
function isChgedBill() {
	return ($.m({ClassName: "BILL.IP.COM.Method", MethodName: "GetPrtInvIdByBill", billId: GV.BillID}, false) > 0);
}

/**
 * 判断自费结算时是否取消医保登记
 * false: 未取消, true: 取消
 */
function checkInsuRegIsCancel() {
	var rtn = true;
	var admReasonAry = getAdmReason();
	var nationalCode = admReasonAry[1];
	if (nationalCode > 0) {
		return rtn;      //医保患者退出
	}
	//判断是否拆分账单
	if (isSplitByAdm()) {
		return rtn;
	}
	var insuAdmInfo = $.m({ClassName: "web.DHCINSUPort", MethodName: "GetInsuAdmInfoByAdmDr", PAADMDr: GV.EpisodeID}, false);
	if (insuAdmInfo != "") {
		var myAry = insuAdmInfo.split("^");
		var valid = myAry[10];
		if ($.inArray(valid, ["A", "O"]) != -1) {
			rtn = false;
		}
	}
	return rtn;
}

/**
* 获取就诊状态
*/
function getAdmStatusJson() {
	var json = {
		status: "",
		statusCode: ""
	};
	if (!GV.EpisodeID) {
		return json;
	}
	var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetOutAdmInOutDateInfo", EpisodeID: GV.EpisodeID}, false);
	var myAry = rtn.split("^");
	json.status = myAry[3];
	json.statusCode = myAry[8];
	return json;
}

/**
 * 重新生成账单
 */
function rebillClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: "请选择需要重新生成的账单", type: "info"});
				return reject();
			}
			if (isChgedBill()) {
				$.messager.popover({msg: "此账单已结算，不能重新生成账单", type: "info"});
				return reject();
			}
			if (isClosedBill()) {
				$.messager.popover({msg: "此账单已封账，不能重新生成账单", type: "info"});
				return reject();
			}
			var insuUpFlag = getInsuUpFlag();
			if ($.inArray(insuUpFlag, ["1", "2"]) != -1) {
				$.messager.popover({msg: "此账单已医保" + ((insuUpFlag == 1) ? "上传" : "结算") + "，不能重新生成账单", type: "info"});
				return reject();
			}
			var babyDepNum = getBabyDepositNum();
			if (babyDepNum > 0) {
				$.messager.popover({msg: "婴儿有未结算押金，请先退婴儿押金", type: "info"});
				return reject();
			}
			notPayedNum = getNotPayedBillNum();
			if (notPayedNum == 0) {
				$.messager.popover({msg: "患者没有未结算状态的账单，不能重新生成账单", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			var msg = ((notPayedNum == 1) ? "" : "患者有多个未结算的账单，") + "是否确认重新生成账单？";
			$.messager.confirm("确认", msg, function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _rebill = function() {
		return new Promise(function (resolve, reject) {
			$.messager.progress({title: "提示",	msg: "重新生成账单中...."});
			$.m({
				ClassName: "web.UDHCJFREBILL",
				MethodName: "REBILL",
				adm: GV.EpisodeID,
				bill: GV.BillID,
				user: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				$.messager.progress("close");
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.popover({msg: "重新生成账单成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "重新生成账单失败：" + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	/**
	* 重新生成账单成功后重新加载账单列表
	*/
	var _success = function () {
		loadBillList();
	};
	
	var $this = $(this);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var notPayedNum = 0;
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_rebill)
		.then(function() {
			_success();
			$this.removeProp("disabled");
		}, function() {
			$this.removeProp("disabled");
		});
}

/**
 * 结算
 */
function charge() {
	/**
	* 2022-08-09
	* ZhYW
	* 押金找平
	*/
	var _chkAmtToPay = function() {
		return new Promise(function (resolve, reject) {
			if (amtToPay == 0) {
				return resolve();
			}
			if (!isBalanceByDepMode()) {
				return resolve();
			}
			//交押金
			if (amtToPay > 0) {
				$.messager.alert("提示", ($g("请收押金：") + "<font style=\"color:red;font-weight:bold;\">" + Math.abs(amtToPay).toFixed(2) + "</font> " + $g("元")), "info", function() {
					var argObj = {
						EpisodeID: GV.EpisodeID,
						PayAmt: Math.abs(amtToPay).toFixed(2)
					};
					BILL_INF.showPayDeposit(argObj).then(function () {
						_reloadNeceEle();
						reject();
				    });
				});
				return;
			}
			
			//退押金
			$.messager.alert("提示", ($g("请退押金：") + "<font style=\"color:red;font-weight:bold;\">" + Math.abs(amtToPay).toFixed(2) + "</font> " + $g("元")), "info", function() {
				var argObj = {
					EpisodeID: GV.EpisodeID,
					RefundAmt: Math.abs(amtToPay).toFixed(2)
				};
				BILL_INF.showRefDeposit(argObj).then(function () {
					_reloadNeceEle();
					reject();
			    });
			});
		});
	};
	
	/**
	* 2022-08-09
	* ZhYW
	* 交/退押金后刷新界面必要元素
	*/
	var _reloadNeceEle = function() {
		loadPayMList();
		loadDepositList();
		initPatFeeInfo();
		setPayMPanelTitle();
	};
	
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			//判断是否有发票
			var hasInv = checkInv();
			if (!hasInv) {
				$.messager.popover({msg: "您没有可用发票，请先领取发票", type: "info"});
				return reject();
			}
			if (!validatePayMRow()) {
				return reject();
			}
			if (isChgedBill()) {
				$.messager.popover({msg: "此账单已结算，不能重复结算", type: "info"});
				return reject();
			}
			//判断账单状态
			var refundFlag = getBillRefFlag();
			if (refundFlag == "B") {
				$.messager.popover({msg: "此账单已经红冲，不允许结算", type: "info"});
				return reject();
			}
			//判断医保是否已结算
			if (!isInsuDivided()) {
				$.messager.popover({msg: "医保患者，请先做医保结算", type: "info"});
				return reject();
			}
			//账单后的押金总额和押金列表的押金总额是否一致，不一致提示重新选择患者或重新账单
			var depositFlag = judgeDepositSum();
			if (!depositFlag) {
				$.messager.popover({msg: "再次收退押金导致押金列表显示不完全，请再次账单", type: "info"});
				return reject();
			}
			//判断平衡金额
			var balanceAmt = getBalanceAmt();
			if (balanceAmt != 0) {
				$.messager.popover({msg: "平衡金额不为0，不能结算",	type: "info"});
				return reject();
			}
			//根据费别判断押金不足是否允许结算
			if ((amtToPay > 0) && (isChrgInsTypeLowDepAmt(insTypeId))) {
				$.messager.popover({msg: "此费别押金不足不允许结算", type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _depCfr = function() {
		return new Promise(function (resolve, reject) {
			var unSelDepSum = getUnSelDepSum();   //未选押金金额
			if (unSelDepSum == 0) {
				depFlag = 1;
				return resolve();
			}
			var msg = $g("患者押金总额和要结算的押金总额不一致，未选择的押金为") + " <font color='red'>" + unSelDepSum + "</font>，" + $g("是否确认结算？");
			$.messager.confirm("确认", msg, function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _paySrv = function () {
	    return new Promise(function (resolve, reject) {
		  	var payMAry = [];
	        var _check = function () {
		   		var paymIdAry = [];
		   		var errMsg = "";
		   		var leftAmt = 0;
	            $.each(GV.PayMList.getRows(), function (index, row) {
					if (row.CTPMInsuFlag == "Y") {
						return true;
					}
					var paymAmt = row.CTPMAmt || 0;
					if (paymAmt == 0) {
						return true;
					}
					if (!_needPaySrv(row.CTPMCode)) {
						return true;
					}
					if ($.inArray(row.CTPMRowID, paymIdAry) != -1) {
						errMsg = $g("不能选择多个") + " <font color=\"red\">" + row.CTPMDesc + "</font> " + $g("结算");
		                return false;
		            }
		            paymIdAry.push(row.CTPMRowID);
	                if (paymAmt > 0) {
	                    var myObj = {};
	                    myObj[row.CTPMRowID] = paymAmt;
	                    payMAry.push(myObj);
	                    return true;
	                }
	                leftAmt = getPayMLeftAmt(row.CTPMRowID, unpayDepIdStr);
	             	if (Math.abs(paymAmt) > leftAmt) {
		             	errMsg = row.CTPMDesc + $g("最多可退") + " <font color=\"red\">" + leftAmt + "</font> " + $g("元");
		             	return false;
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
	            var arrcpStr = "";
	            var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	            expStr += "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + GV.PatientID + "^" + GV.EpisodeID;
	            expStr += "^" + arrcpStr + "^^C";
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
	        * 获取未勾选的押金RowId串
	        */
	        var _getUncheckedDepIdStr = function () {
			    return GV.DepositList.getRows().filter(function (row, index) {
			        return !GV.DepositList.getPanel().find("div.datagrid-cell-check>input:checkbox").eq(index).is(":checked");
			    }).map(function (row) {
			        return row.TDepRowId;
			    }).join("^");
			};
			
			var unpayDepIdStr = _getUncheckedDepIdStr();   //不参与结算的押金RowId串(以"^"分割)

	        _check();
	    });
	};
	
	/**
	* 是否打印多张发票
	*/
	var _multiInvCfr = function () {
		return new Promise(function (resolve, reject) {
			if (IPBILL_CONF.PARAM.MultiPrintInv != "Y") {
				return resolve();
			}
			$.messager.confirm("确认", "是否打印多张发票？", function(r) {
				if (r) {
					isPrtMultiInv = "Y";
				}
				resolve();
			});
		});
	};
	
	/**
	* 获取结算信息串
	*/
	var _getPayStr = function () {
	    var selDepRalStr = getCheckedDepIdStr();   //选中的要参与结算的押金串
	    return GV.BillID + "&" + selDepRalStr + "&" + depFlag + "&" + amtToPay
	     + "&" + GV.EpisodeID + "&" + ClientIPAddress + "&" + patShareAmt + "&" + depositAmt
	     + "&" + isPrtMultiInv;
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
			var myCTPMTransFlag = _getPayMTransFlag(index, "CTPMTransFlag");
			if (myCTPMTransFlag == "Y") {
				transferFlag = true;
			}
			var paymId = row.CTPMRowID;
			var ETPRowID = payMConETP[paymId] || "";   //第三方支付交易表RowID
			//+2022-09-15 ZhYW 根据订单表RowID获取第三方支付方式ID
			if (ETPRowID > 0) {
				paymId = GetETPPayModeID(ETPRowID) || paymId;    //DHCBillPayService.js
			}
			//支付方式ID^银行^支票号/卡号^IPM_Unit_DR^IPM_PayAccNo^金额^IPM_TransFlag^IPM_InsuFlag^IPM_ETP_DR
			myStr = paymId + "^" + row.CTPMBankRowID + "^" + row.CTPMCheckNo + "^" + row.CTPMUnitRowID;
			myStr += "^" + row.CTPMAccount + "^" + paymAmt + "^" + myCTPMTransFlag + "^" + row.CTPMInsuFlag;
			myStr += "^" + ETPRowID;
			paymAry.push(myStr);
		});
		var paymStr = paymAry.join(PUBLIC_CONSTANT.SEPARATOR.CH2);
		return paymStr;
	};
	
	/**
	* 结算
	*/
	var _paybill = function () {
		return new Promise(function (resolve, reject) {
			var payStr = _getPayStr();          //结算信息串
			var paymStr = _getPayModeList();    //支付方式串

			$.messager.progress({title: "提示",	msg: "结算中...."});
			$.m({
				ClassName: "web.UDHCJFPAY",
				MethodName: "paybill0",
				payStr: payStr,
				paymStr: paymStr,
				sessionStr: getSessionStr()
			}, function(rtn) {
				$.messager.progress("close");
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					prtRowId = myAry[1];
					GV.PrtRowID = prtRowId;
					$.messager.popover({msg: "结算成功", type: "success"});
					return resolve();
				}
				$.messager.popover({msg: "结算失败：" + (myAry[1] || myAry[0]), type: "error"});
				return reject();
			});
		});
	};
	
	var _success = function() {
		return new Promise(function (resolve, reject) {
			setPayMPanelTitle();
			//设置新的发票号
			checkInv();
			if (!isShowModalWin()) {
				if (getValueById("status") != "paid") {
					$("#status").combobox("select", "paid");
				} else {
					loadBillList();
				}
				return resolve();
			}
			loadGridData();    //弹框界面刷新
			return resolve();
		});
	};
	
	/**
	* 打印发票
	*/
	var _printInv = function() {
		return new Promise(function (resolve, reject) {
			var invPrintFlag = getPropValById("DHC_INVPRTZY", prtRowId, "PRT_INVPrintFlag");
			if (invPrintFlag == "P") {
				inpatInvPrint(prtRowId + "#" + "");
				return resolve();
			}
			if (isPrtMultiInv == "Y") {
				printMultiInv();
				return resolve();
			}
			return resolve();
		});
	};
	
	/**
	* 第三方支付退款
	*/
	var _refundSrv = function() {
		return new Promise(function (resolve, reject) {
			var notRefAmt = getNotRefundAmt(prtRowId);
			if (notRefAmt == 0) {
				return resolve();
			}
			$.messager.alert("提示", ("需退第三方支付：<font color=\"red\">" + notRefAmt + "</font>元"), "info", function() {
				if (isShowChrgRefDepWin()) {
					//弹出第三方支付退款界面
					refundSrv(prtRowId).then(resolve);
				}else {
					//程序计算自动退款
					refundSrvAutoRef(prtRowId).then(resolve);
				}
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
			if (rtnValue.ResultCode != 0){
				$.messager.popover({msg: "第三方支付撤销失败，请联系工程师处理", type: "error"});
			}
        });
	};
	
	/**
	* 转账 自动打开交押金的界面
	*/
	var _transferDeposit = function () {
		return new Promise(function (resolve, reject) {
			if (!transferFlag) {
				return resolve();
			}
			var payAmt = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetTDepositByPaid", PrtRowID: prtRowId}, false);
			var argObj = {
				EpisodeID: GV.EpisodeID,
				PayAmt: Math.abs(payAmt),
				TransferFlag: "Y"
			};
			return BILL_INF.showPayDeposit(argObj).then(function() {
		        resolve();
		    }, function() {
		        reject();
		    });
		});
	};
	
	//获取应收应退金额 自付金额 选择的押金金额
	var patShareAmt = getValueById("patShareAmt");  //自付费用
	var depositAmt = getValueById("selDepAmt");
	var insuAmt = getValueById("insuAmt");
	//patShareAmt-depositAmt-insuAmt
	var amtToPay = Number(Number(patShareAmt).sub(depositAmt).toFixed(2)).sub(insuAmt).toFixed(2);
	var admReaAry = getAdmReason();
	var insTypeId = admReaAry[0];
	
	var prtRowId = "";
	var transferFlag = false;    //是否有中途结算转账(中途结算后退费，用于补交押金)
	var depFlag = 0;
	var isPrtMultiInv = "N";
	var payMConETP = {};      //存放支付方式关联第三方支付订单
	
	var promise = Promise.resolve();
	return promise
		.then(_chkAmtToPay)
		.then(_validate)
		.then(_depCfr)
		.then(_paySrv)
		.then(_multiInvCfr)
		.then(_paybill)
		.then(_success)
		.then(_printInv)
		.then(_refundSrv)
		.then(_transferDeposit)
		.then(null, function() {
			_cancelPaySrv();
		});
}

/**
* 医保结算
*/
function insuDivide() {
	if (!GV.EpisodeID) {
		return false;
	}
	if (!GV.BillID) {
		return false;
	}
	var admReaAry = getAdmReason();
	var insTypeId = admReaAry[0];
	var nationalCode = admReaAry[1];
	if (!(nationalCode > 0)) {
		return true;
	}
	if (isChgedBill()) {
		$.messager.popover({msg: "此账单已经结算，不能医保结算", type: "info"});
		return false;
	}
	var admStatusJson = getAdmStatusJson();
	if (($.inArray(admStatusJson.statusCode, GV.DischgStatAry) == -1) && (IPBILL_CONF.PARAM.InsuIntPay != "Y")) {
		$.messager.popover({msg: ($g("医保患者是") + admStatusJson.status + $g("状态") + "，" + $g("不能医保结算")), type: "info"});
		return false;
	}
	//费用审核
	if ((IPBILL_CONF.PARAM.ConfirmPatFee == "Y") && (!isExamPassed())) {
		$.messager.popover({msg: "此患者费用还未审核通过，不能医保结算", type: "info"});
		return false;
	}
	//测试串
	//var insuDivStr = "0|0^1234^200^279243" + PUBLIC_CONSTANT.SEPARATOR.CH2 + "6^600" + PUBLIC_CONSTANT.SEPARATOR.CH2 + "33^700";
	var insuDivStr = InsuIPDivide(0, PUBLIC_CONSTANT.SESSION.USERID, GV.BillID, nationalCode, insTypeId, "");
	var myAry = String(insuDivStr).split("|");
	if (myAry[0] == 0) {
		//医保结算成功后插入医保支付方式
		addGridInsuInfo(insuDivStr);
		return true;
	}
	$.messager.popover({msg: "医保结算失败：" + myAry[0], type: "error"});
	return false;
}

/**
* 判断医保患者是否能够中途结算
*/
function canIntPayForInsu() {
	if (IPBILL_CONF.PARAM.InsuIntPay == "Y") {
		return true;
	}
	var admReasonAry = getAdmReason();
	var nationalCode = admReasonAry[1];
	if (nationalCode > 0) {
		return false;
	}
	return true;
}

/**
 * 医保预结算
 */
function insuPreDivClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!GV.EpisodeID) {
				$.messager.popover({msg: "请选择患者", type: "info"});
				return reject();
			}
			if (!GV.BillID) {
				$.messager.popover({msg: "请选择账单", type: "info"});
				return reject();
			}
			if (isChgedBill()) {
				$.messager.popover({msg: "此账单已结算，不能医保预结算", type: "info"});
				return reject();
			}
			var admReaAry = getAdmReason();
			insTypeId = admReaAry[0];
			nationalCode = admReaAry[1];
			if (!(nationalCode > 0)) {
				$.messager.popover({msg: "非医保患者，不能医保预结算", type: "info"});
				return reject();
			}
			var isLock = lockAdm(GV.EpisodeID, true);   //2023-02-22 ZhYW 对当前结算就诊解锁
			if (isLock) {
		        return reject();
		    }
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认医保预结算？", function (r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _preDiv = function() {
		return new Promise(function (resolve, reject) {
			InsuIPDividePre(0, PUBLIC_CONSTANT.SESSION.USERID, GV.BillID, nationalCode, insTypeId, "");
			return resolve();
		});
	};
	
	if ($("#btn-insuPreCharge").linkbutton("options").disabled) {
		return;
	}
	$("#btn-insuPreCharge").linkbutton("disable");
	
	var insTypeId = "";
	var nationalCode = "";
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_preDiv)
		.then(function() {
			lockAdm(GV.EpisodeID, false);   //2023-02-22 ZhYW 对当前结算就诊解锁
			$("#btn-insuPreCharge").linkbutton("enable");
		}, function() {
			lockAdm(GV.EpisodeID, false);   //2023-02-22 ZhYW 对当前结算就诊解锁
			$("#btn-insuPreCharge").linkbutton("enable");
		});
}

/**
* 取消医保结算
*/
function insuCancelDivide() {
	var rtn = 0;
	var admReaAry = getAdmReason();
	var insTypeId = admReaAry[0];
	var nationalCode = admReaAry[1];
	if (!(nationalCode > 0)) {
		return rtn;
	}
	if (!isInsuDivided()) {
		return rtn;
	}
	rtn = InsuIPDivideCancle(0, PUBLIC_CONSTANT.SESSION.USERID, GV.BillID, nationalCode, insTypeId, "");
	var msg = "取消医保结算" + ((rtn == 0) ? "成功" : ("失败：" + rtn));
	var type = (rtn == 0) ? "success" : "error";
	$.messager.popover({msg: msg, type: type});
	return rtn;
}

/**
* 打印医保结算单
*/
function printInsuJSDClick() {
	if (!GV.EpisodeID) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!GV.BillID) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var admReaAry = getAdmReason();
	var insTypeId = admReaAry[0];
	var nationalCode = admReaAry[1];
	if (!(nationalCode > 0)) {
		$.messager.popover({msg: "非医保患者，不能打印医保结算单", type: "info"});
		return;
	}
	if (!isChgedBill()) {
		$.messager.popover({msg: "此账单未结算，不能打印医保结算单", type: "info"});
		return;
	}
	InsuIPJSDPrint(0, PUBLIC_CONSTANT.SESSION.USERID, GV.BillID, nationalCode, insTypeId, "");
}

/**
* 加载界面Grid数据
*/
function loadGridData() {
	loadPayMList();
	loadDepositList();
	loadCateList();
}

/**
* 加载支付方式数据
*/
function loadPayMList() {
	if (!GV.PayMList) {
		return;
	}
	GV.PayMList.load({
		ClassName: "web.DHCIPBillCashier",
		QueryName: "ReadPayMList",
		groupId: PUBLIC_CONSTANT.SESSION.GROUPID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		prtRowId: GV.PrtRowID,
		rows: 99999999
	});
}

/**
* 加载押金列表数据
*/
function loadDepositList() {
	if (!GV.DepositList) {
		return;
	}
	GV.DepositList.load({
		ClassName: "web.DHCIPBillCashier",
		QueryName: "FindDepList",
		adm: GV.EpisodeID,
		prtRowId: GV.PrtRowID,
		rows: 99999999
	});
}

/**
* 加载分类信息列表数据
*/
function loadCateList() {
	if (!GV.CateList) {
		return;
	}
	GV.CateList.load({
		ClassName: "web.DHCIPBillCashier",
		QueryName: "GetCateList",
		bill: GV.BillID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		totalFields: "CateAmt",
		totalFooter: "\"CateDesc\":" + "\"" + $g("合计") + "\"",
		rows: 99999999
	});
}

/**
* 是否允许当前界面支付方式Grid编辑
*  1.已结算不能编辑
*  2.需要弹窗结算且当前界面非弹窗时不能编辑
*/
function disablePayMGrid() {
	return (GV.PrtRowID || ((!isShowModalWin()) && isOpenPayMWin())) ? true : false;
}

/**
* 是否弹框结算
*/
function isOpenPayMWin() {
	if (GV.OpenPayMWin == "Y") {
		return true;
	}
	var admReaAry = getAdmReason();
	var nationalCode = admReaAry[1];
	return (nationalCode > 0);
}

/**
* 判断当前窗口是否是弹出结算窗
*/
function isShowModalWin() {
	return (this.location.pathname.search(CV.PayMURL) > 0);
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

/**
* 是否是使用押金找平后再结算模式
* true:是，false:否
*/
function isBalanceByDepMode() {
	return ($.m({ClassName: "web.DHCIPBillCashier", MethodName: "IsBalanceByDepMode", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}

/**
* 2022-08-25
* ZhYW
* 控制已选押金足额时，不能再勾选其余押金
*/
function ctrlDepChecked(rowIndex) {
	if (GV.DisabledDepAllRows) {
		return;
	}
	var isChecked = (typeof rowIndex != undefined) ? GV.DepositList.getPanel().find("div.datagrid-cell-check>input:checkbox").eq(rowIndex).is(":checked") : false;
	var refOrPayAmt = getRefOrPayAmt();   //多退少补金额
	GV.DepositList.getRows().filter(function (row) {
        return (row.TBillFlag == 1);
    }).forEach(function (row) {
        var idx = GV.DepositList.getRowIndex(row);
        if (rowIndex == idx) {
			return true;
		}
		if (isChecked && (refOrPayAmt <= 0)) {
			GV.DepositList.getPanel().find("div.datagrid-cell-check>input:checkbox").eq(idx).prop("disabled", true);
			return true;
		}
		GV.DepositList.getPanel().find("div.datagrid-cell-check>input:checkbox").eq(idx).prop("disabled", false);
    });
	//有disabled行时,表头也disabled
    if (GV.DepositList.getPanel().find("div.datagrid-cell-check>input:checkbox:disabled").length > 0) {
		GV.DepositList.getPanel().find("div.datagrid-header-check>input:checkbox").eq(0).prop("disabled", true);
	}
}

/**
* 是否允许中途结算
* true:是，false:否
*/
function isAllowedIntPay() {
	return ($.m({ClassName: "web.UDHCJFPAY", MethodName: "IsAllowedIntPay", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}

/**
* 获取费别对应押金不足不允许结算配置
* true:是，false:否
*/
function isChrgInsTypeLowDepAmt(insTypeId) {
	return ($.m({ClassName: "web.DHCIPBillCashier", MethodName: "IsChrgInsTypeLowDepAmt", insTypeId: insTypeId, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}

/**
* 获取住院审核标识
* true:通过(允许住院结算)，false:未通过(不允许结算)
*/
function isInsuAudited() {
	return ($.m({ClassName: "web.DHCIPBillCashier", MethodName: "GetInsuCheckFlag", adm: GV.EpisodeID, bill: GV.BillID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}

/**
* 结算后第三方支付退款-不弹出退款窗口，系统自动循环调用第三方接口退款，如有退款失败时，需要到补退款接口做补退操作。
*/
function refundSrvAutoRef(prtRowId) {
	return new Promise(function (resolve, reject) {
		var errorAry = [];
		var successAry = [];
		var refList = tkMakeServerCall("BILL.IP.BL.ChgedRefundDep", "GetRefundList", prtRowId);
		var paymAry = refList.split("!");
		var len = paymAry.length;
		for(var i = 0; i < len; i++) {
			//set list = list_"!"_rcptRowId_"^"_arrcp_"^"_refundAmt_"^"_tradeType
			var tmpAry =  paymAry[i].split("^");
			var rcptRowId = tmpAry[0];
			//var arrcp = tmpAry[1];  //老版本用，新版本用发票rowid
			var refundAmt = tmpAry[2];
			var tradeType = tmpAry[3];
			var RRN = tmpAry[4];
			var paymDesc = tmpAry[5];
			if(rcptRowId == "") {
				continue;
			}
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			var rtnValue = RefundPayService("IP", rcptRowId, prtRowId, "", refundAmt, tradeType, expStr);
			if (rtnValue.ResultCode != 0) {
				errorAry.push("第 " + (i+1) + " 笔订单退款失败：（" + paymDesc + "支付订单（"+ RRN +"）应退款：" + refundAmt +" 元。） ");
			}else{				
				successAry.push("第 " + (i+1) + " 笔：（" + paymDesc + "支付订单（"+ RRN +"）退款：" + refundAmt +" 元。）");	
			}
		}
		if(errorAry.length > 0){
			var errorMsg = "<p class=\"fail-Cls\">" + "以下 " + errorAry.length + " 笔订单，退款失败，请核实：</p>";
			$.each(errorAry, function(index, item) {
				errorMsg += "<p class=\"fail-Cls\">" + item + "</p>";
			});
			$.messager.alert("提示", errorMsg, "error", function() {
				return resolve();
			});
		}else {
			var successMsg = "<p class=\"succ-Cls\">" + "第三方支付退款成功，共退 " + successAry.length + " 笔：</p><br/>";
			$.each(successAry, function(index, item) {
				successMsg += "<p class=\"succ-Cls\">" + item + "</p><br/>";
			});
			successMsg += "<p class=\"succ-Cls\"> 请患者核实是否到账！</p><br/>";
			$.messager.alert("提示", successMsg, "info", function() {
				return resolve();
			});
		}
	});
}

function sleep(delay) {
	for(var t = Date.now(); Date.now() - t <= delay;);
}

function getCheckedDepRowIdStr() {
	return GV.DepositList.getChecked().map(function (row) {
        return row.TDepRowId;
    }).join("^");
}

///获取各种支付方式的可退金额，根据押金列表及历史补退款记录统一计算，这里主要时针对对三方支付，用来控制退费金额不能大于收费金额
function getExtTradePayList() {
	var selDepList = getCheckedDepRowIdStr();
	var payAry = $.cm({ClassName: "BILL.IP.BL.ChgedRefundDep", MethodName: "GetExtTradePayList", adm: GV.EpisodeID, selDepList: selDepList}, false);
	return payAry;
}

/**
* 2023-04-18
* ZhYW
* 结算时安全组是否弹出第三方支付退款界面
*/
function isShowChrgRefDepWin() {
	return ($.m({ClassName: "BILL.IP.BL.ChgedRefundDep", MethodName: "IsShowRefDepWinByGroupId", groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false) == 1);
}