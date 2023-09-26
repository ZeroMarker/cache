/**
 * FileName: dhcbill.ipbill.deposit.pay.js
 * Anchor: ZhYW
 * Date: 2019-07-03
 * Description: 住院押金充值
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkMaxAmt: {    //校验最大值
	    validator: function(value) {
		    return value < 1000000000;
		},
		message: "金额输入过大"
	}
});

function initPayDepPanel() {
	initPayDepMenu();
	initPayDepList();
}

function initPayDepMenu() {
	$HUI.linkbutton("#btn-pay", {
		onClick: function () {
			payClick();
		}
	});
	
	$HUI.linkbutton("#btn-reprint", {
		onClick: function () {
			reprintClick();
		}
	});
	
	$HUI.linkbutton("#btn-voidInvNo", {
		onClick: function () {
			altVoidInvClick();
		}
	});
	
	$HUI.linkbutton("#btn-abort", {
		onClick: function () {
			abortClick();
		}
	});
	
	getPayRcptNo();
	
	//押金类型
	$HUI.combobox("#payDepositType", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillDeposit&QueryName=FindGrpDepType&ResultSetType=array',
		method: 'GET',
		editable: false,
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function(param) {
			param.groupId = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onChange: function(newValue, oldValue) {
			loadPayDepList();
		}
	});
	
	//银行
	$HUI.combobox("#bank", {
		panelHeight: 150,
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		defaultFilter: 4
	});
	
	//支付方式
	$HUI.combobox("#payMode", {
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCOPGSConfig&QueryName=ReadGSINSPMList&ResultSetType=array",
		method: 'GET',
		editable: false,
		valueField: "CTPMRowID",
		textField: "CTPMDesc",
		onBeforeLoad: function(param) {
			param.GPRowID = PUBLIC_CONSTANT.SESSION.GROUPID;
			param.HospID = PUBLIC_CONSTANT.SESSION.HOSPID;
			param.TypeFlag = "DEP";
		},
		onLoadSuccess: function(data) {
			$.each(data, function (index, item) {
				if (item.selected) {
					selectPayMode(item);
					return false;
				}
			});
		},
		onSelect: function(rec) {
			selectPayMode(rec);
		}
	});
	
	$(".combo-text").keydown(function(e) {
		var key = websys_getKey(e);
		if (key == 13) {
			return focusNextEle($(e.target).parents("td").find("input")[0].id);
		}
	});
}

function selectPayMode(rec) {
	setValueById("requiredFlag", rec.RPFlag);
	if (rec.RPFlag == "Y") {
		enablePayMenu();
	}else {
		disablePayMenu();
	}
}

function disablePayMenu() {
	disableById("checkNo");
	setValueById("checkNo", "");

	disableById("bank");
	setValueById("bank", "");
	
	disableById("bankBranch");
	setValueById("bankBranch", "");
	
	disableById("payAccNo");
	setValueById("payAccNo", "");
	
	disableById("company");
	setValueById("company", "");
}

function enablePayMenu() {
	enableById("checkNo");

	var url = $URL + "?ClassName=web.UDHCOPOtherLB&MethodName=ReadBankListBroker&ResultSetType=array&JSFunName=GetBankToHUIJson";
	$("#bank").combobox("enable").combobox("reload", url);
	enableById("bankBranch");
	
	enableById("payAccNo");
	enableById("company");
}

function initPayDepList() {
	$HUI.datagrid("#payDepList", {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		pagination: true,
		pageSize: 20,
		data: [],
		columns: [[{title: '收款时间', field: 'Tprtdate', width: 155,
				   	formatter: function(value, row, index) {
					   	return value + " " + row.Tprttime;
					}
				   },
				   {title: '金额', field: 'Tpayamt', width: 100, align: 'right'},
				   {title: 'TPaymodeDR', field: 'TPaymodeDR', hidden: true},
				   {title: '支付方式', field: 'Tpaymode', width: 100},
				   {title: 'Tprtstatus', field: 'Tprtstatus', hidden: true},
				   {title: '收据状态', field: 'TStatus', width: 100,
				   	styler: function(value, row, index) {
						if (("^1^4^").indexOf("^" + row.Tprtstatus + "^") == -1) {
							return 'color: #FF0000;';
						}
					}
				   },
				   {title: 'TArrcpId', field: 'TArrcpId', hidden: true},
				   {title: '收据号', field: 'Trcptno', width: 120},
				   {title: '原收据号', field: 'TInitRcptNo', width: 120},
				   {title: 'TAddUserDR', field: 'TAddUserDR', hidden: true},
				   {title: '收款员', field: 'Tadduser', width: 100},
				   {title: '账单号', field: 'Tarpbl', width: 80},
				   {title: 'Tadm', field: 'Tadm', hidden: true},
				   {title: 'Tprtrowid', field: 'Tprtrowid', hidden: true},
				   {title: 'TjkDR', field: 'TjkDR', hidden: true},
				   {title: '是否结账', field: 'Tjkflag', width: 80,
				   	formatter: function (value, row, index) {
					   	if (value) {
						   	return (value == 'Y') ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
						}
					}
				   },
				   {title: 'TDepositTypeDR', field: 'TDepositTypeDR', hidden: true},
				   {title: '押金类型', field: 'TDepositType', width: 100},
				   {title: 'TInitPrtRowId', field: 'TInitPrtRowId', hidden: true},
				   {title: '结算状态', field: 'Tpaystatus', width: 80},
				   {title: '支票号', field: 'Tcardno', width: 100},
				   {title: '单位', field: 'Tcompany', width: 100},
				   {title: '银行', field: 'Tbank', width: 100},
				   {title: '是否到账', field: 'Tbbackflag', width: 80,
				    formatter: function (value, row, index) {
					   	if (value) {
							return (value == 'Y') ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
						}
					}
				   },
				   {title: '到账时间', field: 'Tbbackdate', width: 150,
				    formatter: function (value, row, index) {
					   	if (value) {
							return value + " " + row.Tbbacktime;
						}
					}
				   },
				   {title: '退款原因', field: 'Trefreason', width: 100}
			]]
	});
}

function loadPayDepList() {
	var episodeId = getValueById("episodeId");
	if (episodeId) {
		var queryParams = {
			ClassName: "web.DHCIPBillDeposit",
			QueryName: "FindDeposit",
			adm: episodeId,
			depositType: getValueById("payDepositType")
		}
		loadDataGridStore("payDepList", queryParams);
	}
}

function initPayDepDoc() {
	$("#payDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input:not(#payRcptNo)[id]").each(function(index, item) {
		if ($(this).prop("type") == "text") {
			if ($(this).prop("class").indexOf("combobox-f") != -1) {
				$(this).combobox("clear").combobox("reload");
			}else if($(this).prop("class").indexOf("numberbox-f") != -1) {
				$(this).numberbox("clear");
			}else {
				$(this).val("");
			}
		}
	});
	getPayRcptNo();
	getPayDepConfig();
}

function getPayDepConfig() {
	enableById("btn-pay");
	var episodeId = getValueById("episodeId");
	if (episodeId) {
		var rtn = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "GetOutAdmInOutDateInfo", EpisodeID: episodeId}, false);
		var disChStatus = rtn.split("^")[3];
		if (disChStatus == "护士办理出院") {
			if (IPBILL_CONF.PARAM.DischgPayDep != "Y") {
				$.messager.popover({msg: "该患者已做最终结算，不能交押金", type: "info"});
				disableById("btn-pay");
			} else {
				$.cm({
					ClassName: "web.DHCBillCommon",
					MethodName: "GetClsPropValById",
					clsName: "User.PAAdm",
					id: episodeId
				}, function(jsonObj) {
					if (jsonObj.PAADMBillFlag == "Y") {
						$.messager.popover({msg: "该患者已做财务结算，不能交押金", type: "info"});
						disableById("btn-pay");
					}
				});
			}
		}
	}
}

function reloadPayDepPanel() {
	$("#payDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input:not(#payDepositType)[id]").each(function(index, item) {
		if ($(this).prop("type") == "text") {
			if ($(this).prop("class").indexOf("combobox-f") != -1) {
				$(this).combobox("clear").combobox("reload");
			}else if($(this).prop("class").indexOf("numberbox-f") != -1) {
				$(this).numberbox("clear");
			}else {
				$(this).val("");
			}
		}
	});
	refreshBar(getValueById("papmi"), getValueById("episodeId"));
	getPayRcptNo();
	loadPayDepList();
}

function getPayRcptNo() {
	$.m({
		ClassName: "web.UDHCJFBaseCommon",
		MethodName: "GetRcptNo",
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function (rtn) {
		var myAry = rtn.split("^");
		GV.RcptId = myAry[0];
		GV.EndNo = myAry[1];
		GV.CurrNo = myAry[2];
		GV.Title = myAry[3];
		var leftNum = myAry[4];
		var tipFlag = myAry[6];
		if (!GV.CurrNo) {
			$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
			disableById("btn-pay");
			return;
		}
		if (GV.RcptId) {
			var payRcptNo = GV.Title + "[" + GV.CurrNo + "]";
			setValueById("payRcptNo", payRcptNo);
			var color = "green";
			if ($("#payRcptNo").hasClass("newClsInvalid")) {
				$("#payRcptNo").removeClass("newClsInvalid");
			}
			if (tipFlag == "1") {
				color = "red";
				$("#payRcptNo").addClass("newClsInvalid");
			}
			var content = "该号段可用票据剩余 <font style='font-weight: bold;color: " + color + ";'>" + leftNum + "</font> 张";
			$("#btn-payRcptTip").popover({cache: false, trigger: 'hover', content: content});
		}
	});
}

function payClick() {
	if ($("#btn-pay").hasClass("l-btn-disabled")) {
		return;
	}
	if (!checkData()) {
		return;
	}
	var episodeId = getValueById("episodeId");
	if (!episodeId) {
		$.messager.popover({msg: "请选择患者", type: "info"});
		return;
	}
	var rtn = $.m({ClassName: "web.DHCIPBillDeposit", MethodName: "GetBillFlag", adm: episodeId}, false);
	if (rtn == "Y") {
		$.messager.popover({msg: "该患者已做财务结算，不能交押金", type: "info"});
		return;
	}
	var payDepositType = getValueById("payDepositType");
	if (!payDepositType) {
		$.messager.popover({msg: "请选择押金类型", type: "info"});
		return;
	}
	var payAmt = getValueById("payAmt");
	if (!payAmt) {
		$.messager.popover({msg: "请输入金额", type: "info"});
		focusById("payAmt");
		return;
	}
	if (!(+payAmt > 0)) {
		$.messager.popover({msg: "金额输入错误", type: "info"});
		focusById("payAmt");
		return;
	}
	var payMode = getValueById("payMode");
	if (!payMode) {
		$.messager.popover({msg: "请选择支付方式", type: "info"});
		return;
	}
	if (!GV.CurrNo) {
		$.messager.popover({msg: "没有可用的票据，请先领取", type: "info"});
		return;
	}
	if ((getValueById("requiredFlag") == "Y") && !$.trim(getValueById("checkNo"))) {
		$.messager.popover({msg: "请输入支票号", type: "info"});
		return;
	}
	$.messager.confirm("确认", "收款额：<font style='color:red;'>" + payAmt + "</font> 元，是否确认交款?", function (r) {
		if (r) {
			payDeposit();
		}
	});
}

function payDeposit() {
	var episodeId = getValueById("episodeId");
	var payDepositType = getValueById("payDepositType");
	var payAmt = getValueById("payAmt");
	var payMode = getValueById("payMode");
	var company = getValueById("company");
	var bank = getValueById("bank");
	var checkNo = getValueById("checkNo");
	var payAccNo = getValueById("payAccNo");
	var bankBranch = getValueById("bankBranch");
	var remarks = "";
	var password = "";
	var transferFlag = getValueById("transferFlag");   //转账标识
	
	//第三方支付
	var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID + "^^^^^C";
	var payServRtn = PayService("DEP", payMode, payAmt, expStr);
	if (payServRtn.ResultCode != "00") {
		$.messager.alert("提示", "支付失败：" + payServRtn.ResultMsg, "error");
		return;
	}else {
		GV.ETPRowID = payServRtn.ETPRowID;
	}
	//
	var depStr = payDepositType + "^" + payAmt + "^" + payMode + "^" + company + "^" + bank;
	depStr += "^" + checkNo + "^" + payAccNo + "^" + episodeId + "^" + GV.CurrNo + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID;
	depStr += "^" + PUBLIC_CONSTANT.SESSION.USERID + "^" + GV.EndNo + "^" + GV.Title + "^" + bankBranch + "^" + remarks;
	depStr += "^" + password + "^" + GV.RcptId + "^" + transferFlag + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: "web.DHCIPBillDeposit",
		MethodName: "InsertDeposit",
		depStr: depStr
	}, function(rtn) {
		var myAry = rtn.split("^");
		switch(myAry[0]) {
		case "0":
			var depositId = myAry[1];
			var arrcpId = myAry[2];
			//用于第三方支付接口保存信息
			if (GV.ETPRowID != "") {
				var linkRtn = $.m({
					ClassName: "DHCBILL.Common.DHCBILLCommon",
					MethodName: "RelationOrderToHIS",
					ETPRowID: GV.ETPRowID,
					HisPrtStr: depositId
				}, false);
			}
			//
			$.messager.alert("提示", "交款成功", "success");
			reloadPayDepPanel();
			depositPrint(depositId + "#" + "");
			break;
		case "-1":
			$.messager.popover({msg: "患者已退院，不能交押金", type: "info"});
			break;
		case "-2":
			$.messager.popover({msg: "没有可用收据号，请核实", type: "info"});
			break;
		case "-3":
			$.messager.popover({msg: "收据号与系统实际收据号不符，请核实", type: "info"});
			break;
		case "-4":
			$.messager.popover({msg: "该收据号已经使用过，请刷新界面", type: "info"});
			break;
		default:
			$.messager.popover({msg: "交押金失败：" + rtn, type: "error"});
		}
	});
}

function checkData() {
	var bool = true;
	$(".validatebox-text").each(function(index, item) {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	return bool;
}

function focusNextEle(id) {
	var myIdx = -1;
	var inputAry = $("#payDepList").parents(".layout-panel-center").prev(".layout-panel-north").find("input[id]");
	inputAry.each(function(index, item) {
		if (this.id == id) {
			myIdx = index;
			return false;
		}
	});
	if (myIdx < 0) {
		return true;
	}
	var id = "";
	var $obj = "";
	var nextId = "";
	for (var i = (myIdx + 1); i < inputAry.length; i++) {
		id = inputAry[i].id;
		$obj = $("#" + id);
		if ($obj.parents("tr").is(":hidden")) {
			continue;
		}
		if ($obj.is(":hidden")) {
			if ($obj.next("span").find("input").attr("readonly") == "readonly") {
				continue;
			}
			if ($obj.next("span").find("input").attr("disabled") == "disabled") {
				continue;
			}
		}else {
			if ($obj.attr("disabled") == "disabled") {
				continue;
			}
		}
		nextId = id;
		break;
	}
	if (nextId) {
		focusById(nextId);
		return false;
	}else {
		setTimeout("focusById('btn-pay')", 20);
		return false;
	}
	return true;
}

/**
* 补打押金条
*/
function reprintClick() {
	var row = $("#payDepList").datagrid("getSelected");
	if (!row || !row.Tprtrowid) {
		$.messager.popover({msg: "请选择要补打的押金记录", type: "info"});
		return;
	}
	
	if (row.Tprtstatus != "1") {
		var msg = "该笔押金已退款，";
		if (row.Tprtstatus == "3") {
			msg += "请到【退押金】界面补打";
		}else {
			msg += "不能补打";
		}
		$.messager.popover({msg: msg, type: "info"});
		return;
	}
	
	var recepitNo = row.Trcptno;
	if (!recepitNo) {
		$.messager.popover({msg: "票据号为空，不能补打", type: "info"});
		return;
	}
	var depositId = row.Tprtrowid;
	var reprtFlag = "Y";
	$.messager.confirm("确认", "是否确认补打?", function (r) {
		if (r) {
			depositPrint(depositId + "#" + reprtFlag);
		}
	});
}

/**
* 作废押金
*/
function abortClick() {
	var row = $("#payDepList").datagrid("getSelected");
	if (!row || !row.Tprtrowid) {
		$.messager.popover({msg: "请选择要作废的押金", type: "info"});
		return;
	}
	var billId = row.Tarpbl;
	if (billId) {
		$.messager.popover({msg: "该笔押金已经结算，不能作废", type: "info"});
		return;
	}
	var handinFlag = row.Tjkflag;
	if (handinFlag == "Y") {
		$.messager.popover({msg: "该笔押金已经结账，不能作废", type: "info"});
		return;
	}
	if (row.Tprtstatus != "1") {
		$.messager.popover({msg: "不能作废非正常状态的押金", type: "info"});
		return;
	}
	if (row.TAddUserDR != PUBLIC_CONSTANT.SESSION.USERID) {
		$.messager.popover({msg: "不能作废非本人收的押金", type: "info"});
		return;
	}
	var depositId = row.Tprtrowid;
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	$.messager.confirm("确认", "是否确认作废押金?", function (r) {
		if (r) {
			$.m({
				ClassName: "web.DHCIPBillDeposit",
				MethodName: "RefundDeposit",
				initDepId: depositId,
				userId: PUBLIC_CONSTANT.SESSION.USERID,
				refReasonId: "",
				refModeId: "",
				expstr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == "0") {
					if (IPBILL_CONF.PARAM.AbortDepRenewPrint == "Y") {
						$.m({
							ClassName: "web.DHCIPBillDeposit",
							MethodName: "GetDepositDetail",
							prtRowId: depositId
						}, function(rtn) {
							var myAry = rtn.split("^");
							var depositTypeAry = myAry[0].split("@");
							setValueById("payDepositType", depositTypeAry[0]);
							var payAmt = myAry[1];
							setValueById("payAmt", payAmt);
							var paymAry = myAry[2].split("@");
							setValueById("payMode", paymAry[0]);
							var bankAry = myAry[3].split("@");
							setValueById("bank", bankAry[0]);
							var bankBranch = myAry[4];
							setValueById("bankBranch", bankBranch);
							var company = myAry[5];
							setValueById("company", company);
							var payAccNo = myAry[6];						
							setValueById("payAccNo", payAccNo);
							var checkNo = myAry[7];
							setValueById("checkNo", checkNo);
							
							var password = myAry[8];
							var remarks = myAry[9];
							//setValueById("remarks", remarks);
							payDeposit();   //自动交押金
						});
					}else {
						$.messager.popover({msg: "作废成功", type: "success"});
						reloadPayDepPanel();
					}
				}else {
					$.messager.popover({msg: "作废失败：" + myAry[1], type: "error"});
				}
			});
		}
	});
}

function altVoidInvClick() {
	var payDepositType = $("#payDepositType").combobox("getText");
	var url = "websys.default.hisui.csp?WEBSYS.TCOMPONENT=DHCBillSkipInvoice&receiptType=" + payDepositType;
	websys_showModal({
		width: 520,
		height: 227,
		iconCls: 'icon-skip-no',
		title: '住院押金跳号',
		url: url,
		onClose: function() {
			getPayRcptNo();
		}
	});
}