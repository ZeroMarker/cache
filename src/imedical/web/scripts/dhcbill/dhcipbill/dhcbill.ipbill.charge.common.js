/**
 * FileName: dhcbill.ipbill.charge.common.js
 * Anchor: ZhYW
 * Date: 2019-03-04
 * Description: 住院收费公共js
 */

//存放全局变量
var GV = {
	PatientID: "",
	EpisodeID: "",
	BillID: "",
	ARRCPRowID: "",
	PrtRowID: "",
	BalanceAmt: "",
	ClickBill: "",
	OpenPayMWin: "N",        //设置自费患者结算是否弹框结算(Y：弹框，<>Y：不弹框)
	CancelInsuDiv: "Y",      //关闭结算弹窗时是否撤销医保结算(Y：撤销，<>Y：不撤销)
	depositArray: [],
	BillList: {},
	PayMList: {},
	DepositList: {},
	EditIndex: undefined    //支付方式grid编辑行索引
};

/**
* 初始化支付方式Grid
*/
function initPayMList() {
	GV.PayMList = $HUI.datagrid("#tPaymList", {
		fit: true,
		border: true,
		title: '支付信息',
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		autoRowHeight: false,
		toolbar: [],
		pageSize: 999999999,
		loadMsg: '',
		columns: [[{title: '支付方式', field: 'CTPMDesc', width: 100,
					editor: {
						type: 'combobox',
						options: {
							valueField: 'caption',
							textField: 'caption',
							url: $URL + "?ClassName=web.DHCIPBillCashier&QueryName=ReadPMList&ResultSetType=array",
							required: false,
							editable: false,
							onBeforeLoad: function(param) {
								param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
								param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
								param.prtRowId = getGlobalValue("PrtRowID");
							},
							onLoadSuccess: function () {
								$(this).combobox("showPanel");
							},
							onSelect: function (rec) {
								paymComboSelect(rec);
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
				   {title: '银行', field: 'CTPMBank', width: 160,
					editor: {
						type: 'combobox',
						options: {
							valueField: 'caption',
							textField: 'caption',
							url: $URL + "?ClassName=web.DHCBillOtherLB&QueryName=QBankList&ResultSetType=array",
							editable: false,
							onLoadSuccess: function () {
								$(this).combobox("showPanel");
							},
							onSelect: function (rec) {
								bankComboSelect();
							},
							onHidePanel: function () {
								bankComboHidePanel();
							}
						}
					}},
				 {title: '支行', field: 'CTPMBankSub', hidden: true},
				 {title: '支票/卡号', field: 'CTPMCheckno', width: 160, editor: 'text'},
				 {title: '卡号', field: 'CTPMBankNo', hidden: true},
				 {title: '支付单位', field: 'CTPMUnit', width: 160, editor: 'text'},
				 {title: '账户', field: 'CTPMAcount', hidden: true},
				 {title: 'CTPMCode', field: 'CTPMCode', hidden: true},
				 {title: '转账', field: 'pmck', checkbox: true, hidden: true},
				 {title: 'CTPMRowID', field: 'CTPMRowID', hidden: true},
				 {title: 'ybFlag', field: 'ybFlag', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$("#tipAmt").text("");
			if (!disablePayMGrid()) {
				var success = insuDivide();
				$("#btn-disCharge").linkbutton({disabled: !success});
			}
			onLoadSuccessPaym();
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
 * 押金列表加载成功
 */
function onLoadSuccessDepList(data) {
	if (data.total == 0) {
		return;
	}
	//加载成功后设置选中状态
	$("#tDepositList").parent().find("input:checkbox").removeAttr("disabled"); //清除checkbox状态，需要设置！避免列标题的checkbox保持不可编辑状态
	if (disablePayMGrid()) {
		$("#tDepositList").parent().find("input:checkbox").attr("disabled", "disabled");
	}
	//配置不可选择押金
	if (IPBILL_CONF.PARAM.SelectDepToPay != "Y") {
		$("#tDepositList").parent().find("input:checkbox").attr("disabled", "disabled");
	}
	//如果是最终结算的押金也不可选
	var admStatus = getAdmStatus();
	setGlobalValue("AutoSelDepFlag", true);
	GV.DepositList.checkAll();
	if ((admStatus == "最终结算") || (admStatus == "护士办理出院") || (admStatus == "结束费用调整")) {
		var num = getBillNum();
		if (+num <= 1) {
			$("#tDepositList").parent().find("input:checkbox").attr("disabled", "disabled");
		}
	}
	var billInfo = getBillBaseInfo();
	if (billInfo) {
		var billFlag = billInfo.split("^")[15];
		if (billFlag == "P") {
			$("#tDepositList").parent().find("input:checkbox").attr("disabled", "disabled");
		}
	}
	setDepositArray();
	setGlobalValue("AutoSelDepFlag", false);
}

/**
 * 押金列表全选事件
 */
function onCheckAllDepList(rows) {
	$.each(rows, function (index, row) {
		if (row.TBillFlag == 0) {
			GV.DepositList.uncheckRow(index);
		}
	});
	changeDeposit();
}

/**
 * 押金列表取消全选事件
 */
function onUncheckAllDepList() {
	changeDeposit();
}

/**
 * 押金列表勾选行事件
 */
function onCheckDepList(index, rowData) {
	if (rowData.TBillFlag == 0) {
		$.messager.popover({msg: "该项不可选，请确认该笔钱是否已到账", type: "info"});
		GV.DepositList.uncheckRow(index);
	} else {
		changeDeposit();
	}
}

/**
 * 押金列表取消勾选行事件
 */
function onUncheckDepList(index, rowData) {
	if (rowData.TBillFlag != 0) {
		changeDeposit();
	}
}

/**
 * 支付方式下拉框选中事件
 */
function paymComboSelect(rec) {
	if (GV.EditIndex != undefined) {
		//更新datagrid行的默认信息
		var comboValue = rec.value;
		var comboPmId = comboValue.split("^")[0];
		var comboPmCode = comboValue.split("^")[1];
		GV.PayMList.getRows()[GV.EditIndex]["CTPMCode"] = comboPmCode;
		GV.PayMList.getRows()[GV.EditIndex]["CTPMRowID"] = comboPmId;
		GV.PayMList.endEditCell({index: GV.EditIndex, field: "CTPMDesc"});
	}
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
 * 银行下拉框面板隐藏事件
 */
function bankComboHidePanel() {
	if (GV.EditIndex != undefined) {
		//返回第一个被选中的行或如果没有选中的行则返回null
		GV.PayMList.selectRow(GV.EditIndex);
		var row = GV.PayMList.getRows()[GV.EditIndex];
		var paymCode = row.CTPMCode;
		paymEditCell(GV.EditIndex, "CTPMCheckno", "");
	}
}

/**
 * 支付方式列表加载成功
 */
function onLoadSuccessPaym() {
	if (disablePayMGrid()) {
		return;
	}
	var defPaymStr = getDefPaym();
	var defPaymArr = defPaymStr.split("^");
	var defPaymDr = defPaymArr[0];
	var defPaymDesc = defPaymArr[1];
	var defAmt = getBalanceAmt();   //取默认应交费用
	var admReaAry = getAdmReason();
	var admReaId = admReaAry[0];
	var admReaNationalCode = admReaAry[1];
	var billInfo = getBillBaseInfo();
	var billFlag = billInfo ? billInfo.split("^")[15] : "";
	$.each(GV.PayMList.getRows(), function (index, row) {
		var rowPmDR = row.CTPMRowID;
		var rowAmt = row.CTPMAmt;
		if ((rowPmDR == defPaymDr) && (billFlag != "P")) {
			//判断当前默认支付方式是否有值，如果有值默认+该值
			defAmt = getGlobalValue("BillID") ? numCompute(defAmt, rowAmt, "+") : "";
			GV.PayMList.updateRow({
				index: index,
				row: {
					CTPMAmt: defAmt
				}
			});
			return false;
		}
	});
	//改变平衡金额的值(支付方式)
	setBalance();
}

/**
* 改变押金时，计算费用
*/
function changeDeposit() {
	if (disablePayMGrid()) {
		return;
	}
	//取已选押金
	var selDepSum = getSelDepSum();
	setValueById("selDepAmt", selDepSum);
	
	//应收应退
	var patShareAmt = getValueById("patShareAmt");
	var insuAmt = getValueById("insuAmt");
	//应收/应退款 = 自付 - 医保支付 - 押金
	var amt = numCompute(numCompute(patShareAmt, insuAmt, "-"), selDepSum, "-");
	setValueById("receAmt", ((+amt >= 0) ? amt : 0));            //应收
	setValueById("refAmt", ((+amt < 0) ? Math.abs(amt) : 0));    //应退
	
	//清空支付方式列表的值
	if (!getGlobalValue("AutoSelDepFlag")) {
		clearUnderRow(0);
		onLoadSuccessPaym();
	}
	
	//改变平衡金额的值(支付方式)
	setBalance();
	//设置必填金额
	setTipAmt();

	var hasClickBill = checkBillClick();
	if ((hasClickBill) && (!getGlobalValue("AutoSelDepFlag"))) {
		setPayMListFocus();
	}
}

/**
* 清除支付方式Grid当前行以下金额
*/
function clearUnderRow(index) {
	var maxLen = GV.PayMList.getData().total;
	for (var i = index; i < maxLen; i++) {
		var ed = GV.PayMList.getEditor({index: i, field: "CTPMAmt"});
		if (ed) {
			$(ed.target).numberbox("setValue", "");
		} else {
			GV.PayMList.updateRow({
				index: i,
				row: {
					CTPMAmt: ""
				}
			});
		}
	}
	setBalance();
}

/**
 * 获得第一行支付方式，没有取门诊配置
 */
function getDefPaym() {
	var paymStr = $.m({ClassName: "web.DHCIPBillCashier", MethodName: "GetPaymDefSequence", groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	var paymAry = paymStr.split("^");
	var paymDr = paymAry[0];
	var paymDesc = paymAry[1];
	return paymDr + "^" + paymDesc;
}

/**
 * 获取账单的费别 ID 和 NationalCode
 */
function getAdmReason() {
	if (getGlobalValue("BillID") == "") {
		return new Array("", "", "", "");
	}
	var rtn = tkMakeServerCall("web.UDHCJFPAY", "GetBillReaNationCode", getGlobalValue("BillID"));
	var admReaAry = rtn.split("^");
	return admReaAry;
}

/**
 * 获取账单基本字段信息
 */
function getBillBaseInfo() {
	return tkMakeServerCall("web.DHCIPBillCashier", "GetBillBaseInfo", getGlobalValue("BillID"));
}

/**
 * 设置平衡金额
 */
function setBalance() {
	var balanceAmt = getStAmt();
	var paymAll = getPayMAll();
	var pmBalance = numCompute(balanceAmt, paymAll, "-");
	setGlobalValue("BalanceAmt", pmBalance);
}

/**
* 取默认支付方式费用
*/
function getBalanceAmt() {
	var depositAmt = getValueById("selDepAmt");     //已选押金
	var patShareAmt = getValueById("patShareAmt");  //自付金额
	var paymAll = getPayMAll();
	var balanceAmt = numCompute(patShareAmt, depositAmt, "-");
	balanceAmt = numCompute(balanceAmt, paymAll, "-");
	return balanceAmt;
}

/**
* 获取收退金额
*/
function getStAmt() {
	var patShareAmt = getValueById("patShareAmt");
	var depositAmt = getValueById("selDepAmt");  //已选押金
	return numCompute(patShareAmt, depositAmt, "-");
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
* 设置默认的支付方式列表的焦点
*/
function setPayMListFocus() {
	var defPaymStr = getDefPaym();
	var defPaymArr = defPaymStr.split("^");
	var defPaymDr = defPaymArr[0];
	var defPaymDesc = defPaymArr[1];
	var billInfo = getBillBaseInfo();
	var billFlag = "";
	if (billInfo != "") {
		billFlag = billInfo.split("^")[15];
	}
	if ((billFlag == "P") || (billFlag == "")) {
		return;
	}
	var defPaymIndex = 0;
	$.each(GV.PayMList.getRows(), function (index, row) {
		if (row.CTPMRowID == defPaymDr) {
			defPaymIndex = index;
			return false;
		}
	});
	paymEditCell(defPaymIndex, "CTPMAmt", "");
}

/**
 * 支付方式Grid单元格单击事件
 */
function paymClickCell(index, field, value) {
	if (disablePayMGrid()) {
		return;
	}
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请先选择账单或此患者为新住院患者", type: "info"});
		return;
	}
	//编辑时 未账单不可编辑 中途结算的除外
	var hasClickBill = checkBillClick();
	if (!hasClickBill) {
		$.messager.popover({msg: "请先账单", type: "info"});
		return;
	}
	//如果是结算过的单击不起作用
	var billInfo = getBillBaseInfo();
	if (billInfo != "") {
		var billFlag = billInfo.split("^")[15];
		if (billFlag == "B") {
			paymEditCell(index, field, value);
		}
	}
}

/**
* 判断是否账单
*/
function checkBillClick() {
	return true;   //Lid 2018-03-27 交付中心要求,在输入登记号后,查询出患者信息时,直接账单,不用每次点击结算时再账单,方便收费员操作

	//判断是否是中途结算的，中途结算的不需要账单
	var billFlag = "";
	var billInfo = getBillBaseInfo();
	if (billInfo != "") {
		billFlag = billInfo.split("^")[15];
	}
	var billNum = getBillNum();
	if (+billNum == 1) {
		if (!getGlobalValue("ClickBill")) {
			return false;
		}
		if ((getGlobalValue("EpisodeID") != getGlobalValue("ClickBill")) && (billFlag != "P")) {
			return false;
		} else {
			return true;
		}
	} else {
		return true;
	}
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
	if (!getGlobalValue("BillID")) {
		return false;
	}
	var row = GV.PayMList.getRows()[index];
	if (!row) {
		return false;
	}
	var ybFlag = row.ybFlag;
	//医保支付方式不能编辑
	if (ybFlag == "Y") {
		return false;
	}
	//走配置 支付方式不能编辑
	if ((field != "CTPMAmt") && (field != "CTPMDesc")) {
		var paymRequired = isPaymRequired(row.CTPMRowID);
		if (!paymRequired) {
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
		var ed = GV.PayMList.getEditor({index: GV.EditIndex, field: "CTPMBank"});
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

function paymBeginEdit(index, row) {
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
				}else {
					focusById("patPaidAmt");
				}
			}
		});
	}
}

function getNextEditRow() {
	var nextIndex = GV.EditIndex + 1;
	var maxLen = GV.PayMList.getData().total;
	while (nextIndex < maxLen) {
		var row = GV.PayMList.getRows()[nextIndex];
		if (row.ybFlag == "Y") {
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
	if (GV.EditIndex != undefined) {
		var ed = GV.PayMList.getEditor({index: GV.EditIndex, field: "CTPMAmt"});
		if (ed) {
			var row = GV.PayMList.getSelected();
			var paymAmt = row.CTPMAmt;
			var balanceAmt = getGlobalValue("BalanceAmt");
			var tipAmt = numCompute(paymAmt, balanceAmt, "+");
			setPayMPanelTitle(tipAmt);
		}
	} else {
		setPayMPanelTitle("");
	}
}

/**
* 支付方式结束编辑
*/
function paymAfterEdit() {
	if (disablePayMGrid()) {
		return;
	}
	GV.EditIndex = undefined;
	setBalance();
}

/**
* 设置支付方式列表panel的title
*/
function setPayMPanelTitle(tipAmt) {
	if (disablePayMGrid()) {
		GV.PayMList.getPanel().panel("setTitle", "支付信息");
	}else {
		$("#tipAmt").text(tipAmt);
		GV.PayMList.getPanel().panel("setTitle", $("#tipDiv").html());
	}
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
		var ed = GV.PayMList.getEditor({index: GV.EditIndex, field: "CTPMAmt"});
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
	//1,首先判断页面上是否已经有了医保要添加的支付方式
	//2,如果有改变原来的值，没有的话再添加
	var CH2 = PUBLIC_CONSTANT.SEPARATOR.CH2;
	var myIndex = 0;
	var myInsuAmt = 0;
	var insuChargeFlag = true;
	var insuPmErrStr = "";
	var insuPmLen = insuDivStr.split(CH2).length;
	for (var i = 1; i <= insuPmLen - 1; i++) {
		var pmId = insuDivStr.split(CH2)[i].split("^")[0];
		var pmAmt = insuDivStr.split(CH2)[i].split("^")[1];
		var checkInfo = checkPmExist(pmId);         //判断页面上是否已经有了医保要添加的支付方式
		var checkFlag = checkInfo.split("^")[0];
		var checkAmt = checkInfo.split("^")[1];
		var checkIndex = checkInfo.split("^")[2];
		var checkYbFlag = checkInfo.split("^")[3];  //是否医保支付标识
		if ((checkFlag == "1") && (checkYbFlag == "Y")) {
			return;
		} else {
			//获取code和desc
			var pmInfo = tkMakeServerCall("web.DHCIPBillCashier", "getPaymInfo", pmId);
			var pmAry = pmInfo.split("^");
			var pmFlag = pmAry[0];
			var pmCode = pmAry[1];
			var pmDesc = pmAry[2];
			if (pmFlag != 0) {
				insuChargeFlag = false;
				insuPmErrStr = (insuPmErrStr == "") ? pmId : (insuPmErrStr + "," + pmId);
				continue;
			}
			GV.PayMList.insertRow({
				index: 0, //索引从0开始
				row: {
					CTPMRowID: pmId,
					CTPMAmt: pmAmt,
					CTPMCode: pmCode,
					CTPMDesc: pmDesc,
					CTPMAcount: "",
					CTPMBank: "",
					CTPMBankSub: "",
					CTPMBankNo: "",
					CTPMUnit: "",
					CTPMCheckno: "",
					transFlag: "N",
					ybFlag: "Y"
				}
			});
			myIndex++;
			myInsuAmt = numCompute(myInsuAmt, pmAmt, "+");
		}
	}
	//更新医保金额
	setValueById("insuAmt", myInsuAmt);
	var receAmt = getValueById("receAmt");
	var refAmt = getValueById("refAmt");
	if (numCompute(receAmt, myInsuAmt, "-") <= 0) {
		setValueById("refAmt", numCompute(refAmt, myInsuAmt, "+"));     //应退
	}else {
		setValueById("receAmt", numCompute(receAmt, myInsuAmt, "-"));   //应收
	}
	//改变默认金额的值、平衡金额的值(支付方式)
	if (!insuChargeFlag) {
		$.messager.popover({msg: "医保结算支付方式" + insuPmErrStr + "在HIS系统中不存在，请联系信息科", type: "info"});
	}
	return;
}

/**
* 判断某个支付方式在支付方式列表上是否存在, 若存在时的金额及Index
*/
function checkPmExist(pmId) {
	var pmFlag = 0;
	var myPmAmt = 0;
	var myIndex = 0;
	var ybFlag = "";
	$.each(GV.PayMList.getRows(), function (index, row) {
		var paymAmt = row.CTPMAmt || 0;
		var myPmId = row.CTPMRowID;
		var myYbFlag = row.ybFlag;
		if (myPmId == pmId) {
			pmFlag = 1;
			ybFlag = myYbFlag;
			myPmAmt = paymAmt;
			myIndex = index;
			return false;      //退出循环
		}
	});
	var rtn = pmFlag + "^" + myPmAmt + "^" + myIndex + "^" + ybFlag;
	return rtn;
}

/**
* 判断支付方式是否有必填项
* true:有 false:无
*/
function isPaymRequired(paymId) {
	return ($.m({ClassName: "web.DHCIPBillCashier", MethodName: "IsRequiredInfo", groupId: PUBLIC_CONSTANT.SESSION.GROUPID, hospId: PUBLIC_CONSTANT.SESSION.HOSPID, paymId: paymId}, false) == 1);
}

/**
* 获取就诊未结算的账单数量
*/
function getBillNum() {
	return $.m({ClassName: "web.UDHCJFPAY", MethodName: "GetNotPayedNum", Adm: getGlobalValue("EpisodeID")}, false);
}

/**
* 判断医保是否已经结算
* ture：医保未结算，false：自费或医保已结算
*/
function checkInsuCharge() {
	return ($.m({ClassName: "web.DHCIPBillCashier", MethodName: "IsDisableInsuChargeBtn", bill: getGlobalValue("BillID")}, false) == 0);
}

/**
 * 设置金额信息
 */
function initPatFeeInfo() {
	var rtn = $.m({ClassName: "web.DHCIPBillCashier", MethodName: "GetPatInfo", EpisodeID: getGlobalValue("EpisodeID"), PBRowID: getGlobalValue("BillID"), PrtRowID: getGlobalValue("PrtRowID")}, false);
	var myAry = rtn.split("$");
	var patInfoStr = myAry[0];
	var admInfoStr = myAry[1];
	var feeInfoStr = myAry[2];
	var feeInfoArr = feeInfoStr.split("^");
	var deposit = feeInfoArr[0];
	var totalAmt = feeInfoArr[1];
	var patShareAmt = feeInfoArr[2];
	var discAmt = feeInfoArr[3];
	var payorShareAmt = feeInfoArr[4];
	var stAmt = feeInfoArr[5];
	var ysAmt = feeInfoArr[6];
	var ytAmt = feeInfoArr[7];
	var insuAmt = feeInfoArr[8];
	var zfAmt = feeInfoArr[9];
	var yeAmt = feeInfoArr[10];
	var depInfo = getDepositInfo();
	var totalDepAmt = depInfo.split("^")[0];
	var selDepAmt = depInfo.split("^")[1];

	setValueById("totalDepAmt", totalDepAmt);
	setValueById("totalAmt", totalAmt);
	setValueById("selDepAmt", selDepAmt);
	setValueById("patShareAmt", patShareAmt);
	setValueById("payorShareAmt", payorShareAmt);
	setValueById("discAmt", discAmt);
	setValueById("insuAmt", insuAmt);
	//应收/应退 = 自付 - 医保支付 - 押金
	setValueById("receAmt", ((+stAmt >= 0) ? stAmt : 0));            //应收
	setValueById("refAmt", ((+stAmt < 0) ? Math.abs(stAmt) : 0));    //应退
}

/**
* 计算收退金额
*/
function patPaidAmtKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patPaidAmt = getValueById("patPaidAmt");
		var cashAmt = 0;    //收退现金金额
		$.each(GV.PayMList.getRows(), function (index, row) {
			var paymAmt = row.CTPMAmt;
			var paymCode = row.CTPMCode;
			var ybFlag = row.ybFlag || "";
			if ((ybFlag != "Y") && (paymCode == "CASH")) {
				cashAmt = numCompute(cashAmt, paymAmt, "+");
			}
		});
		setValueById("recOrBackMoney", numCompute(patPaidAmt, cashAmt, "-"));
	}
}

/**
* 获取选择的押金金额
*/
function getSelDepSum() {
	var depositSum = 0;
	$.each(GV.DepositList.getChecked(), function (index, row) {
		var depAmt = row.TDepAmt;
		depositSum = numCompute(depositSum, depAmt, "+");
	});
	return depositSum;
}

/**
* 设置选择的押金数组
*/
function setDepositArray() {
	GV.depositArray = [];
	$.each(GV.DepositList.getChecked(), function (index, row) {
		var depId = row.TPayMRowid;
		GV.depositArray.push(depId);
	});
}

/**
 * 账单
 */
function billClick() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var rtn = tkMakeServerCall("web.UDHCJFORDCHK", "getmotheradm", getGlobalValue("EpisodeID"));
	if (rtn == "true") {
		$.messager.popover({msg: "婴儿不允许做账单", type: "info"});
		return;
	}
	var billInfo = getBillBaseInfo();
	if (billInfo) {
		var billAry = billInfo.split("^");
		var refundFlag = billAry[16];        //红冲标志
		var payedFlag = billAry[15];         //计费状态
		if (refundFlag == "B") {
			$.messager.popover({msg: "此账单已经红冲，不能账单", type: "info"});
			return;
		}
		if (payedFlag == "P") {
			$.messager.popover({msg: "此账单已结算或已封账，不能账单", type: "info"});
			return;
		}
	}
	var rtn = tkMakeServerCall("web.UDHCJFBaseCommon", "Bill", "", "", getGlobalValue("EpisodeID"), PUBLIC_CONSTANT.SESSION.USERID, getGlobalValue("BillID"), ClientIPAddress);
	switch (rtn) {
	case "0":
		setGlobalValue("ClickBill", getGlobalValue("EpisodeID"));
		$.messager.popover({msg: "账单成功", type: "success"});
		updateFootData();
		//重新加载押金列表数据，防止交押金后不显示,但是会把收费员以前选择的押金给取消了
		//如果勾掉了押金后再来账单 要先初始化全局变量，否则会出现押金显示金额和勾选金额不一致
		GV.depositArray = [];
		loadDepositList();
		onLoadSuccessPaym();
		if (!isOpenPayMWin()) {
			setPayMListFocus();
		}
		break;
	case "2":
		$.messager.popover({msg: "该患者有多个未结账单，不能账单", type: "info"});
		break;
	case "AdmNull":
		$.messager.popover({msg: "就诊号为空", type: "info"});
		break;
	case "PBNull":
		$.messager.popover({msg: "账单号为空", type: "info"});
		break;
	default:
		$.messager.popover({msg: "账单失败：" + rtn, type: "error"});
	}
}

/**
* 账单成功后 不刷新界面只更新患者数据
*/
function updateFootData() {
	//根据账单号,获取账单后的结算数据
	var expStr = "";
	var payedFlag = "";
	var billInfo = getBillBaseInfo();
	if (!billInfo) {
		return false;
	}
	var billFlag = billInfo.split("^")[15];
	if (billFlag === "B") {
		payedFlag = "B";
	} else {
		payedFlag = "P";
	}
	//未结算记录修改数据
	var CH2 = PUBLIC_CONSTANT.SEPARATOR.CH2;
	if (payedFlag === "B") {
		//押金$c(2)总金额^自付金额^折扣金额^记账金额
		//更新费用信息
		var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetPatFeeByBillNO", BillNO: getGlobalValue("BillID"), PayedFlag: payedFlag, ExpStr: expStr}, false);
		var tmpAry = rtn.split(CH2);
		var deposit = tmpAry[0];
		var patfeeInfo = tmpAry[1].split("^");
		var stAmt = tmpAry[2];
		var insuAmt = tmpAry[3];   //医保金额
		setValueById("totalAmt", patfeeInfo[0]);
		setValueById("patShareAmt", patfeeInfo[1]);
		setValueById("discAmt", patfeeInfo[2]);
		setValueById("payorShareAmt", patfeeInfo[3]);
		
		//更新押金金额
		var depInfo = getDepositInfo();
		var allDepAmt = depInfo.split("^")[0];
		var selDepAmt = depInfo.split("^")[1];
		setValueById("totalDepAmt", allDepAmt);
		setValueById("selDepAmt", selDepAmt);
		setValueById("insuAmt", insuAmt);  //更新医保金额

		//更新选中记录的数据
		//需更新押金、总金额、自付费用、（折扣费用）
		var selectRow = GV.BillList.getSelected();
		var rowIndex = GV.BillList.getRowIndex(selectRow);
		if (selectRow) {
			GV.BillList.updateRow({
				index: rowIndex,
				row: {
					deposit: deposit,
					totalamount: patfeeInfo[0],
					patientshare: patfeeInfo[1],
					discountamount: patfeeInfo[2],
					payorshare: patfeeInfo[3],
					ybfee: insuAmt
				}
			});
		}
	}
}

/**
 * 打印收据
 */
function printFPClick() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "账单号为空，不能打印", type: "info"});
		return;
	}
	//判断就诊状态
	var admStatus = getAdmStatus();
	if (admStatus == "退院") {
		$.messager.popover({msg: "该患者已退院，不能打印", type: "info"});
		return;
	}
	//这里用不用判断欠费结算，即如果在支付方式里有欠费的，是不是判断是否欠费打发票?
	var requiredInv = isReaRequiredInv();
	var hasInv = checkInv();
	if (requiredInv && !hasInv) {
		$.messager.popover({msg: "您没有可用发票，请先领取发票", type: "info"});
		return;
	}
	var billInfo = getBillBaseInfo();
	if (!billInfo) {
		$.messager.popover({msg: "获取账单信息失败", type: "info"});
		return;
	}
	var billAry = billInfo.split("^");
	var payedFlag = billAry[15];         //计费状态
	var refundFlag = billAry[16];        //红冲标志
	if (refundFlag == "B") {
		$.messager.popover({msg: "此账单已经红冲，不能打印", type: "info"});
		return;
	}
	if (isClosedBill()) {
		$.messager.popover({msg: "此账单已封帐，不能打印", type: "info"});
		return;
	}
	var prtRowId = printClick();
	if (!isShowModalWin() && prtRowId) {
		loadBillList();
	}
}

/**
 * 打印
 */
function printClick() {
	var prtRowId = "";
	var requiredInv = isReaRequiredInv();
	var hasInv = checkInv();
	if (requiredInv && !hasInv) {
		$.messager.popover({msg: "您没有可用发票，请先领取发票", type: "info"});
		return prtRowId;
	}
	var billInfo = getBillBaseInfo();
	if (!billInfo) {
		$.messager.popover({msg: "获取账单信息失败", type: "info"});
		return prtRowId;
	}
	var billAry = billInfo.split("^");
	var payedFlag = billAry[15];
	if (payedFlag != "P") {
		$.messager.popover({msg: "该账单没有结算，不能打印发票", type: "info"});
		return prtRowId;
	}
	var prtFlag = tkMakeServerCall("web.UDHCJFPAY", "CheckPrtInvByBill", getGlobalValue("BillID"));
	if (prtFlag == "Y") {
		var rtn = tkMakeServerCall("web.UDHCJFPAY", "GetPrtRowIdByBill", getGlobalValue("BillID"));
		var myAry = rtn.split("^");
		if (myAry[1] != "Y") {
			$.messager.popover({msg: "该账单已经打印发票或为欠费结算", type: "info"});
			return prtRowId;
		} else {
			prtRowId = myAry[0];
			printMoreInv(prtRowId);
		}
	} else {
		var prtMultiInvFlag = "N";
		if (IPBILL_CONF.PARAM.MultiPrintInv == "Y") {
			var isQFCharge = $.m({ClassName: "web.UDHCJFPAY", MethodName: "IsQFCharge", billId: getGlobalValue("BillID")}, false);
			if ((+isQFCharge == 0) || (IPBILL_CONF.PARAM.PrintQFInv == "Y"))  {
				/*
				if (dhcsys_confirm("是否打印多张发票?")) {
					prtMultiInvFlag = "Y";
				}
				*/
			}
		}
		var rtn = $.m({ClassName: "web.UDHCJFPAY", MethodName: "SaveInv", billId: getGlobalValue("BillID"), multiInvFlag: prtMultiInvFlag, sessionStr: getSessionStr()}, false);
		var myAry = rtn.split("^");
		var errCode = myAry[0];
		switch (errCode) {
		case "0":
			prtRowId = myAry[1];
			var prtInvFlag =  myAry[2];
			setGlobalValue("PrtRowID", prtRowId);
			//设置新的发票号
			checkInv();
			if (+prtInvFlag == 0) {
				inpatInvPrint(prtRowId + "#" + "");
			}
			if (prtMultiInvFlag == "Y") {
				printMoreInv(prtRowId);
			}
			break;
		case "INV":
			$.messager.popover({msg: "此发票号码已经使用", type: "info"});
			break;
		case "InsuErr":
			$.messager.popover({msg: "医保未结算", type: "info"});
			break;
		default:
			$.messager.popover({msg: "打印失败：" +errCode, type: "error"});
		}
	}
	return prtRowId;
}

/**
* 打印多张发票
*/
function printMoreInv(prtRowId) {
	if (!prtRowId) {
		return;
	}
	var url = "websys.default.csp?WEBSYS.TCOMPONENT=UDHCJFInvprtzySub&Adm=" + getGlobalValue("EpisodeID") + '&BillNo=' + getGlobalValue("BillID") + '&prtrowid=' + prtRowId;
	websys_showModal({
		url: url,
		title: "打印多张发票",
		iconCls: "icon-w-inv",
		width: "70%",
		height: "70%"
	});
}

/**
* 验证支付方式输入合法性
*/
function isValidPayMList() {
	var bool = true;
	var existPayMCode = "";
	$.each(GV.PayMList.getRows(), function (index, row) {
		var paymAmt = row.CTPMAmt || 0;
		if (+paymAmt == 0) {
			return true;
		}
		var paymCode = row.CTPMCode;
		//欠费、结存支付方式判断
		if ($.inArray(paymCode, ["QF", "JC"]) != -1) {
			if (existPayMCode && (existPayMCode != paymCode)) {
				$.messager.popover({msg: "不能同时按【欠费】和【结存】结算", type: "info"});
				bool = false;
				return false;
			}
			existPayMCode = paymCode;
			if ((paymCode == "QF") && (+paymAmt < 0)) {
				$.messager.popover({msg: "欠费金额必须大于0", type: "info"});
				bool = false;
				return false;
			}
			if ((paymCode == "JC") && (+paymAmt > 0)) {
				$.messager.popover({msg: "结存金额必须小于0", type: "info"});
				bool = false;
				return false;
			}
		}
	});
	return bool;
}

/**
* 获取支付方式串
*/
function getPayModeList() {
	var paymInfoAry = [];
	$.each(GV.PayMList.getRows(), function (index, row) {
		var paymAmt = row.CTPMAmt || 0;
		var paymDr = row.CTPMRowID;
		var paymCode = row.CTPMCode;
		var paymBank = row.CTPMBank;
		var paymBankSub = row.CTPMBankSub;
		var paymCheck = row.CTPMCheckno;
		var paymBankno = row.CTPMBankNo;
		var pmck = row.pmck;
		var transFlag = row.transFlag;
		var paymAccount = row.CTPMAcount;
		var paymUnit = row.CTPMUnit;
		var ybFlag = row.ybFlag;
		var paymDesc = row.CTPMDesc;
		paymBankno = paymCheck;    //设置为支票号
		if (paymAmt != 0) {
			//支付方式ID^银行@子行^卡号支票号^PAYM_GovernNo^PAYM_AuthorCode^金额^PAYM_Branch
			var paymStr = paymDr + "^" + paymBank + "@" + paymBankSub + "^" + paymBankno + "^" + paymUnit + "^" + paymAccount + "^" + formatAmt(paymAmt) + "^" + transFlag + "^" + ybFlag;
			paymInfoAry.push(paymStr);
		}
	});
	
	var paymStr = paymInfoAry.join("&");
	
	return paymStr;
}

/**
* 判断平衡金额
*/
function checkBalance() {
	var flag1 = 0;
	var flag2 = 0;
	var myBalance = getBalanceAmt();
	if (myBalance == 0) {
		flag1 = 1;
	}
	var balance = getGlobalValue("BalanceAmt");
	if (balance == 0) {
		flag2 = 1;
	}
	if ((flag1 = 1) && (flag2 == 1)) {
		return true;
	} else {
		return false;
	}
}

/**
* 判断是否在结算前账单后是否又交了押金
* 根据押金列表的金额和后台进行判断，判断总金额和可使用金额，并判断患者信息上的押金额
*/
function judgeDepositSum() {
	var flag1 = 0;
	var flag2 = 0;
	//后台获取押金总数和可用押金总数
	var rtn = getDepositInfo();
	var myAry = rtn.split("^");
	var actualAllDep = myAry[0];
	var actualAvaiDep = myAry[1];
	var thisAllDep = 0;
	var thisAvaiDep = 0;
	$.each(GV.DepositList.getRows(), function (index, row) {
		var depAmt = row.TDepAmt;
		thisAllDep = numCompute(thisAllDep, depAmt, "+");
		if (row.TBillFlag == 1) {
			thisAvaiDep = numCompute(thisAvaiDep, depAmt, "+");
		}
	});
	var pageAllDep = getValueById("totalDepAmt");
	var pageAvaiDep = getValueById("selDepAmt");
	actualAllDep = formatAmt(actualAllDep);    //后台总押金
	actualAvaiDep = formatAmt(actualAvaiDep);  //后台可用押金
	thisAllDep = formatAmt(thisAllDep);        //押金列表总押金
	thisAvaiDep = formatAmt(thisAvaiDep);      //押金列表可用押金
	pageAllDep = formatAmt(pageAllDep);        //界面押金总额
	pageAvaiDep = formatAmt(pageAvaiDep);      //界面可用押金

	if (IPBILL_CONF.PARAM.CheckPayOrNot == "Y") {
		if (+actualAllDep == +thisAllDep) {
			flag1 = 1;
		}
	} else {
		if (+actualAvaiDep == +thisAvaiDep) {
			flag1 = 1;
		}
	}

	if ((+actualAllDep == +thisAllDep) && (+actualAvaiDep == +thisAvaiDep)) {
		flag2 = 1;
	}
	if ((flag1 == 1) && (flag2 == 1)) {
		return true;
	}
	
	return false;
}

/**
* 获取押金串
*/
function getDepoistStr() {
	return GV.depositArray.join("^");
}

/**
* 判断当前票号和界面是否一致
*/
function checkInvSame() {
	var insTypeStr = $.m({ClassName: "web.DHCIPBillCashier", MethodName: "GetInsTypeInfo", EpisodeID: "", BillNo: getGlobalValue("BillID")}, false);
	if (!insTypeStr) {
		return false;
	}
	var insTypeAry = insTypeStr.split("^");
	var insTypeId = insTypeAry[0];
	var rtn = $.m({ClassName: "web.UDHCJFPAY", MethodName: "ReadReceiptNO", userId: PUBLIC_CONSTANT.SESSION.USERID, insTypeId: insTypeId, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	var myAry = rtn.split("^");
	var rowId = myAry[2] || "";
	return (rowId == getValueById("currentInvId"));
}

/**
* 获取可用发票
*/
function checkInv() {
	var insTypeId = "";
	if (getGlobalValue("BillID")) {
		var insTypeStr = $.m({ClassName: "web.DHCIPBillCashier", MethodName: "getInsTypeInfo", EpisodeID: "", BillNo: getGlobalValue("BillID")}, false);
		if (!insTypeStr) {
			return false;
		}
		var insTypeAry = insTypeStr.split("^");
		insTypeId = insTypeAry[1];
	}
	var rtn = $.m({ClassName: "web.UDHCJFPAY", MethodName: "ReadReceiptNO", userId: PUBLIC_CONSTANT.SESSION.USERID, insTypeId: insTypeId, hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
	var myAry = rtn.split("^");
	if (myAry[0] == "0") {
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
		if (tipFlag == "1") {
			color = "red";
			$("#currentInv").addClass("newClsInvalid");
		}
		var content = "该号段可用票据剩余 <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> 张";
		$("#btn-tip").popover({cache: false, trigger: 'hover', content: content});
		return true;
	}else {
		return false;
	}
}

/**
* 获取发票头和发票号
*/
function getCurrentInv() {
	try {
		var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCINVOICE", id: getValueById("currentInvId")}, false);
		var title = jsonObj.INVtitle;
		var invNo = jsonObj.INVLastNum;
		return title + "^" + invNo;
	}catch(e) {
		return "^";
	}
}

/**
* 获取全部押金和可用押金
*/
function getDepositInfo() {
	return $.m({ClassName: "web.DHCIPBillCashier", MethodName: "GetDepositSum", admId: getGlobalValue("EpisodeID"), billId: getGlobalValue("BillID")}, false);
}

/**
* 判断账单费别是否需要发票
* true:需要发票, false:不需要发票
*/
function isReaRequiredInv() {
	return ($.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetReaIPInvPrtFlag", BillNo: getGlobalValue("BillID")}, false) == 0);
}

/**
* 判断账单是否已封账
* true:已封账, false:未封账
*/
function isClosedBill() {
	return ($.m({ClassName: "web.DHCIPBillPBCloseAcount", MethodName: "GetPaidCAcountFlag", BillNo: getGlobalValue("BillID")}, false) == "Y");
}

/**
* 获取医保结算信息
* 	1: 医保已上传明细
* 	2: 医保已结算
* 	<0: 医保未结算未上传
*/
function getInsuUpFlag() {
	return $.m({ClassName: "web.DHCIPBillCashier", MethodName: "JudgePBInsuUpFlag", BillNo: getGlobalValue("BillID"), ExpStr: ""}, false)
}

/**
 * 判断自费结算时是否取消医保登记
 * false: 未取消, true: 取消
 */
function checkInsuRegIsCancel() {
	var rtn = true;
	var admReasonAry = getAdmReason();
	var admReaId = admReasonAry[0];
	var admNationalCode = admReasonAry[1];
	if (+admNationalCode > 0) {
		return rtn;      //医保患者退出
	}
	//判断是否拆分账单
	var splitFlag = tkMakeServerCall("web.UDHCJFPAY", "CheckBillIsSplitByAdm", getGlobalValue("EpisodeID"));
	if (splitFlag == "Y") {
		return rtn;
	}
	var insuAdmInfo = tkMakeServerCall("web.DHCINSUPort", "GetInsuAdmInfoByAdmDr", getGlobalValue("EpisodeID"));
	if (insuAdmInfo != "") {
		var myAry = insuAdmInfo.split("^");
		var valid = myAry[10];
		var myStr = "AO";
		if (myStr.search(valid) != -1) {
			rtn = false;
		}
	}
	return rtn;
}

/**
* 获取就诊状态
*/
function getAdmStatus() {
	if (!getGlobalValue("EpisodeID")) {
		return "";
	}
	var admInOutDateInfo = tkMakeServerCall("web.UDHCJFBaseCommon", "GetOutAdmInOutDateInfo", getGlobalValue("EpisodeID"));
	var admInOutDateAry = admInOutDateInfo.split("^");
	var admStatus = admInOutDateAry[3];
	return admStatus;
}

/**
 * 重新生成账单
 */
function rebillClick() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择需要重新生成的账单", type: "info"});
		return;
	}
	if (isClosedBill()) {
		$.messager.popover({msg: "此账单已封帐，不能重新生成账单", type: "info"});
		return;
	}
	var insuUpFlag = getInsuUpFlag();
	if (insuUpFlag == 1) {
		$.messager.popover({msg: "账单医保已上传，不能重新生成账单", type: "info"});
		return;
	} else if (insuUpFlag == 2) {
		$.messager.popover({msg: "账单医保已结算，不能重新生成账单", type: "info"});
		return;
	}
	var babyDepNum = tkMakeServerCall("web.DHCIPBillCashier", "JudgeBabyDeposit", getGlobalValue("EpisodeID"), PUBLIC_CONSTANT.SESSION.HOSPID);
	if (+babyDepNum > 0) {
		$.messager.popover({msg: "婴儿有未结算押金，如需重新生成账单请退婴儿押金", type: "info"});
		return;
	}
	var num = tkMakeServerCall("web.UDHCJFBaseCommon", "JudgeBillNum", getGlobalValue("EpisodeID"));
	switch (num) {
	case "0":
		$.messager.popover({msg: "患者没有未结算账单，请确认该条记录是否已结算", type: "info"});
		break;
	default:
		var msg = ((+num == 1) ? "" : "患者有多个未结算的账单，") + "是否确认重新生成账单?";
		$.messager.confirm("确认", msg, function (r) {
			if (r) {
				$.m({
					ClassName: "web.UDHCJFREBILL",
					MethodName: "REBILL",
					adm: getGlobalValue("EpisodeID"),
					bill: getGlobalValue("BillID"),
					user: PUBLIC_CONSTANT.SESSION.USERID
				}, function (rtn) {
					switch (rtn) {
					case "0":
						$.messager.popover({msg: "重新生成账单成功", type: "success"});
						loadBillList();
						break;
					case "-1":
						$.messager.popover({msg: "账单已结算，不能重新生成账单", type: "info"});
						break;
					case "ExtItmErr":
						$.messager.popover({msg: "账单中执行记录有附加的收费项目，不能重新生成账单", type: "info"});
						break;
					case "BabyErr":
						$.messager.popover({msg: "请选择母亲账单进行重新生成账单", type: "info"});
						break;
					default:
						$.messager.popover({msg: "重新生成账单失败：" + rtn, type: "error"});
					}
				});
			}
		});
	}
}

/**
 * 结算
 */
function charge() {
	endEditing();
	//判断账单状态
	var billInfo = getBillBaseInfo();
	if (!billInfo) {
		$.messager.popover({msg: "获取账单信息失败", type: "info"});
		return;
	}
	var billAry = billInfo.split("^");
	var refundFlag = billAry[16];        //红冲标志
	var payedFlag = billAry[15];         //计费状态
	if (refundFlag == "B") {
		$.messager.popover({msg: "此账单已经红冲，不允许结算", type: "info"});
		return;
	}
	if (payedFlag == "P") {
		$.messager.popover({msg: "此账单已结算或已封账", type: "info"});
		return;
	}
	//判断当前票号和界面是否一致
	var sameFlag = checkInvSame();
	if (!sameFlag) {
		$.messager.popover({msg: "发票号和后台查询不一致，请刷新界面后再试", type: "info"});
		return;
	}
	//判断医保是否结算
	var insuChargeFlag = checkInsuCharge();
	if (insuChargeFlag) {
		$.messager.popover({msg: "医保患者，请先做医保结算", type: "info"});
		return;
	}
	//账单后的押金总额和押金列表的押金总额是否一致，不一致提示重新选择患者或重新账单
	var depositFlag = judgeDepositSum();
	if (!depositFlag) {
		$.messager.popover({msg: "再次收退押金导致押金列表显示不完全，请再次账单", type: "info"});
		return;
	}
	//判断平衡金额
	if (+getGlobalValue("BalanceAmt") != 0) {
		$.messager.popover({msg: "平衡金额不为0，不能结算",	type: "info"});
		return;
	}
	//验证支付方式金额
	if (!isValidPayMList()) {
		return;
	}
	
	//获取应收应退金额 自付金额 选择的押金金额
	var patShareAmt = getValueById("patShareAmt"); //自付费用
	var depositAmt = getValueById("selDepAmt");
	var insuAmt = getValueById("insuAmt");
	//patShareAmt-depositAmt-insuAmt
	var amtToPay = numCompute(numCompute(patShareAmt, depositAmt, "-"), insuAmt, "-");

	//获取支付方式串 支付方式和 押金串 所选押金和 押金全选标志
	var paymStr = getPayModeList();
	paymStr = amtToPay + "&" + paymStr;
	var paymAll = getPayMAll();
	var selDepStr = getDepoistStr();                            //选择的押金串
	var totalDepAmt = getValueById("totalDepAmt");              //界面所有押金
	var selDepAmt = getValueById("selDepAmt");                  //界面押金金额
	var selDepSum = getSelDepSum();                             //计算出来的已选押金
	if (+selDepAmt != +selDepSum) {
		$.messager.popover({msg: "已选押金和结算押金金额不平", type: "info"});
		return;
	}
	var unSelDepSum = numCompute(totalDepAmt, selDepAmt, "-");  //未选押金
	//再次判断发票号
	var requiredInv = isReaRequiredInv();
	var currentInvId = getValueById("currentInvId");
	if (requiredInv && !currentInvId) {
		$.messager.popover({msg: "没有可用的收据号", type: "info"});
		return;
	}
	//再次判断平衡金额
	var balanceFlag = checkBalance();
	if (!balanceFlag) {
		$.messager.popover({msg: "平衡金额不为0，不能结算",	type: "info"});
		return;
	}
	var depFlag = 0;
	if (+totalDepAmt != +selDepAmt) {
		var msg = "患者押金总额和要结算的押金总额不一致，未选择的金额为" + unSelDepSum + "，是否确认结算?";
		$.messager.confirm("确认", msg, function (r) {
			if (r) {
				_pay();
			}
		});
	} else {
		depFlag = 1;
		_pay();
	}
	
	function _pay() {
		//获取计算机名
		var p1 = getGlobalValue("BillID") + "&" + PUBLIC_CONSTANT.SESSION.USERID + "&" + PUBLIC_CONSTANT.SESSION.CTLOCID;
		p1 += "&" + selDepStr + "&" + depFlag + "&" + amtToPay + "&" + getGlobalValue("EpisodeID");
		p1 += "&" + ClientIPAddress + "&" + patShareAmt + "&" + selDepAmt + "&" + paymAll + "&" + selDepAmt;
		var p2 = paymStr;
		$.m({
			ClassName: "web.UDHCJFPAY",
			MethodName: "paybill0",
			val1: p1,
			val2: p2
		}, function(rtn) {
			var myAry = rtn.split("^");
			if (myAry[0] == "0") {
				$.messager.popover({msg: "结算成功", type: "success"});
				var arrcp = myAry[1];
				setGlobalValue("ARRCPRowID", arrcp);
				setPayMPanelTitle("");
				printClick();   //保存并打印发票
				if (!isShowModalWin()) {
					if (getValueById("status") != "paid") {
						$("#status").combobox("select", "paid");
					} else {
						loadBillList();
					}
				}else {
					loadGridData();    //弹框界面刷新
				}
				transferDeposit();     //转账自动打开交押金的界面
			} else {
				switch (myAry[0]) {
				case "B":
					$.messager.popover({msg: "患者正在进行费用调整，不能结算", type: "info"});
					break;
				case "-2":
					$.messager.popover({msg: "帐单金额不符，请重新生成帐单", type: "info"});
					break;
				case "-3":
					$.messager.popover({msg: "界面金额与实际账单金额不符，请重新刷新界面再进行结算", type: "info"});
					break;
				case "-4":
					$.messager.popover({msg: "要结算的押金金额与实际的押金金额不符", type: "info"});
					break;
				case "-5":
					$.messager.popover({msg: "支付的金额与实际要支付的金额不一致，不能结算", type: "info"});
					break;
				case "-6":
					$.messager.popover({msg: "账单已经结算，不能再结算", type: "info"});
					break;
				case "-1001":
					$.messager.popover({msg: "收费员选择的押金与后台结算的押金不等", type: "info"});
					break;
				case "-1002":
					$.messager.popover({msg: "支付方式金额，账单金额，结算押金不平", type: "info"});
					break;
				default:
					$.messager.popover({msg: "结算失败：" + myAry[0], type: "error"});
				}
			}
		});		
	}
}

/**
* 医保结算
*/
function insuDivide() {
	if (!getGlobalValue("EpisodeID")) {
		return false;
	}
	if (!getGlobalValue("BillID")) {
		return false;
	}
	var admReaAry = getAdmReason();
	var admReaId = admReaAry[0];
	var admReaNationalCode = admReaAry[1];
	if (!(+admReaNationalCode > 0)) {
		return true;
	}
	var billInfo = getBillBaseInfo();
	if (!billInfo) {
		$.messager.popover({msg: "获取账单信息失败", type: "info"});
		return false;
	}
	var billFlag = billInfo.split("^")[15];
	if (billFlag == "P") {
		$.messager.popover({msg: "该账单已经结算，不能医保结算", type: "info"});
		return false;
	}
	var admStatus = getAdmStatus();
	if ((admStatus != "护士办理出院") && (admStatus != "结束费用调整")) {
		if ((+admReaNationalCode > 0) && (IPBILL_CONF.PARAM.InsuIntPay != "Y")) {
			$.messager.popover({msg: "医保患者是" + admStatus + "状态，不能医保结算", type: "info"});
			return false;
		}
	}
	//费用审核
	if (IPBILL_CONF.PARAM.ConfirmPatFee == "Y") {
		var rtn = tkMakeServerCall("web.UDHCJFBillDetailOrder", "GetCodingFlag", getGlobalValue("EpisodeID"), getGlobalValue("BillID"));
		if (rtn != "Y") {
			$.messager.popover({msg: "此患者费用还未审核通过，不能医保结算", type: "info"});
			return false;
		}
	}
	/*
	//测试串
	var CH2 = PUBLIC_CONSTANT.SEPARATOR.CH2;
	var insuDivStr = "0|0^1234^200^279243" + CH2 + "6^600" + CH2 + "33^700";
	*/
	var insuDivStr = InsuIPDivide(0, PUBLIC_CONSTANT.SESSION.USERID, getGlobalValue("BillID"), admReaNationalCode, admReaId, "");
	var myAry = insuDivStr.toString().split("|");
	if (myAry[0] == 0) {
		//医保结算成功后插入医保支付方式
		addGridInsuInfo(insuDivStr);
		return true;
	}
	
	$.messager.popover({msg: "医保结算失败：" + myAry[0], type: "error"});
	return false;
}

/**
 * 医保预结算
 */
function insuPreDivideClick() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var billInfo = getBillBaseInfo();
	if (!billInfo) {
		$.messager.popover({msg: "获取账单信息失败", type: "info"});
		return;
	}
	var billFlag = billInfo.split("^")[15];
	if (billFlag == "P") {
		$.messager.popover({msg: "该账单已经结算，不能医保预结算", type: "info"});
		return;
	}
	if (!checkBillClick()) {
		$.messager.popover({msg: "请先做账单", type: "info"});
		return;
	}
	var num = getBillNum();
	switch (num) {
	case "0":
		$.messager.popover({msg: "患者没有未结算账单，不能医保预结算", type: "info"});
		break;
	case "1":
		var admReaAry = getAdmReason();
		var admReaId = admReaAry[0];
		var admReaNationalCode = admReaAry[1];
		if (+admReaNationalCode > 0) {
			InsuIPDividePre("0", PUBLIC_CONSTANT.SESSION.USERID, getGlobalValue("BillID"), admReaNationalCode, admReaId, "");
		} else {
			$.messager.popover({msg: "非医保患者，不能医保预结算", type: "info"});
		}
		break;
	default:
		$.messager.popover({msg: "患者有两个未结算的账单，如需医保预结算，请撤消中途结算", type: "info"});
	}
}

/**
* 取消医保结算
*/
function insuCancelDivide() {
	var rtn = 0;
	if (checkInsuCharge()) {
		return rtn;
	}
	var admReaAry = getAdmReason();
	var admReaId = admReaAry[0];
	var admReaNationalCode = admReaAry[1];
	if (+admReaNationalCode > 0) {
		rtn = InsuIPDivideCancle(0, PUBLIC_CONSTANT.SESSION.USERID, getGlobalValue("BillID"), admReaNationalCode, admReaId, "");
		if (rtn == 0) {
			$.messager.popover({msg: "取消医保结算成功", type: "success"});
		}else {
			$.messager.popover({msg: "取消医保结算失败：" + rtn, type: "error"});
		}
	}
	return rtn;
}

/**
* 打印医保结算单
*/
function printInsuJSDClick() {
	if (!getGlobalValue("EpisodeID")) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var admReaAry = getAdmReason();
	var admReaId = admReaAry[0];
	var admReaNationalCode = admReaAry[1];
	if (+admReaNationalCode == 0) {
		$.messager.popover({msg: "非医保患者，不能打印医保结算单", type: "info"});
		return;
	}
	InsuIPJSDPrint("0", PUBLIC_CONSTANT.SESSION.USERID, getGlobalValue("BillID"), admReaNationalCode, admReaId, "");
}

/**
 * 作废收据
 */
function abortFPClick() {
	if (!getGlobalValue("PrtRowID")) {
		$.messager.popover({msg: "没有打印数据", type: "info"});
		return;
	}
	if (!getGlobalValue("BillID")) {
		$.messager.popover({msg: "请选择账单", type: "info"});
		return;
	}
	var currentInvStr = getCurrentInv();
	var currentInvArr = currentInvStr.split("^");
	var currentInvNo = currentInvArr[0] + currentInvArr[1];
	//判断作废收据需不需要发票
	if (IPBILL_CONF.PARAM.AbortInvRenewPrint == "Y") {
		var requiredInv = isReaRequiredInv();
		var hasInv = checkInv();
		if (requiredInv && !hasInv) {
			$.messager.popover({msg: "您没有可用发票，请先领取发票", type: "info"});
			return;
		}
	}
	var jsonStr = tkMakeServerCall("web.DHCBillCommon", "GetClsPropValById", "User.DHCINVPRTZY", getGlobalValue("PrtRowID"));
	var jsonObj = JSON.parse(jsonStr);
	if (!jsonObj.PRTinv) {
		$.messager.popover({msg: "发票号为空，不能作废", type: "info"});
		return;
	}
	if ("NI".search(jsonObj.PRTFlag) == -1) {
		$.messager.popover({msg: "该票据已作废或红冲", type: "info"});
		return;
	}
	var p1 = jsonObj.PRTinv + "^" + currentInvNo + "^" + getGlobalValue("BillID") + "^" + PUBLIC_CONSTANT.SESSION.USERID;
	$.m({
		ClassName: "web.UDHCJFPAY",
		MethodName: "Abort0",
		val: p1
	}, function(rtn) {
		switch (rtn) {
		case "0":
			$.messager.popover({msg: "作废成功", type: "success"});
			if (!isShowModalWin()) {
				loadBillList();
			}
			if ((IPBILL_CONF.PARAM.AbortInvRenewPrint == "Y") && (IPBILL_CONF.PARAM.MultiPrintInv != "Y")) {
				printClick();
			}
			break;
		case "1":
			$.messager.popover({msg: "收费员已经结算，不能作废", type: "info"});
			break;
		case "2":
			$.messager.popover({msg: "不是该收款员打印的发票，不能作废", type: "info"});
			break;
		case "3":
			$.messager.popover({msg: "该发票已经取消结算，不能作废", type: "info"});
			break;
		case "4":
			$.messager.popover({msg: "该发票已经红冲，不能作废", type: "info"});
			break;
		default:
			$.messager.popover({msg: "作废失败：" + rtn, type: "error"});
		}
	});	
}

/**
* 加载支付方式Grid数据
*/
function loadPayMList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCashier",
		QueryName: "ReadPMSequence",
		groupId: PUBLIC_CONSTANT.SESSION.GROUPID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID,
		prtRowId: getGlobalValue("PrtRowID"),
		billId: getGlobalValue("BillID"),
		rows: 99999999
	}
	$.extend(GV.PayMList.options(), {url: $URL});
	GV.PayMList.load(queryParams);
}

/**
* 加载押金列表Grid数据
*/
function loadDepositList() {
	var queryParams = {
		ClassName: "web.DHCIPBillCashier",
		QueryName: "depositlist",
		Adm: getGlobalValue("EpisodeID"),
		Bill: getGlobalValue("BillID"),
		rows: 99999999
	}
	$.extend(GV.DepositList.options(), {url: $URL});
	GV.DepositList.load(queryParams);
}

/**
 * 转账 自动打开交押金的界面
 */
function transferDeposit() {
	var flag = getValueById("transferflag");
	if (!flag) {
		return;
	}
	if (getGlobalValue("PrtRowID")) {
		var payAmt = tkMakeServerCall("web.UDHCJFBaseCommon", "GetTDepositByPaid", getGlobalValue("PrtRowID"));
		var url = "dhcbill.ipbill.deposit.pay.if.csp?&EpisodeID=" + getGlobalValue("EpisodeID") + "&PayAmt=" + Math.abs(payAmt) + "&TransferFlag=Y";
		websys_showModal({
			url: url,
			title: "交押金",
			iconCls: "icon-w-find",
			width: "85%",
			height: "85%"
		});
	}
}

/**
* 是否允许当前界面支付方式Grid编辑
*  1.已结算不能编辑
*  2.需要弹窗结算且当前界面非弹窗时不能编辑
*/
function disablePayMGrid() {
	return (getGlobalValue("ARRCPRowID") || ((!isShowModalWin()) && isOpenPayMWin())) ? true : false;
}

/**
* 是否弹框结算
*/
function isOpenPayMWin() {
	if (getGlobalValue("OpenPayMWin") == "Y") {
		return true;
	}
	var admReaAry = getAdmReason();
	var admReaNationalCode = admReaAry[1];
	if (+admReaNationalCode > 0) {
		return true;
	}
	return false;
}

/**
* 判断当前窗口是否是弹出结算窗
*/
function isShowModalWin() {
	return (this.location.pathname.search("dhcbill.ipbill.charge.paym.csp") > 0) ? true : false;
}

function setGlobalValue(key, value) {
	GV["" + key + ""] = value;
}

function getGlobalValue(key) {
	return GV["" + key + ""] || "";
}