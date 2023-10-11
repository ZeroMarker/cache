/**
 * FileName: dhcbill.opbill.billcashcalc.js
 * Author: ZhYW
 * Date: 2019-06-13
 * Description: 门诊收费计算器
 */

$(function () {
	initQueryMenu();
	initPaymList();
});

function initQueryMenu() {
	//票据号
	setValueById("currInvNo", CV.ReceiptNo);
	
	$("#invNum").focus().keydown(function (e) {
		invNumKeydown(e);
	});
	
	//收取现金回车查询事件
	$("#getCashAmt").keydown(function (e) {
		getCashAmtKeydown(e);
	});
}

function invNumKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		var invNum = $(e.target).val();
		if (invNum < 1) {
			$.messager.popover({msg: "票据张数输入错误", type: "info"});
			$(e.target).focus().select();
			return;
		}
		$.m({
			ClassName: "web.DHCOPBillCalculatorLogic",
			MethodName: "GetInvFeeData",
			Guser: PUBLIC_CONSTANT.SESSION.USERID,
			HospId: PUBLIC_CONSTANT.SESSION.HOSPID,
			CurrentNO: "",
			InvNum: invNum
		}, function(rtn) {
			var myAry = rtn.split("^");
			setValueById("job", myAry[0]);
			setValueById("chargeSum", myAry[2]);
			setValueById("roundErrAmt", myAry[5]);
			setValueById("cashSum", myAry[7]);
			setValueById("getCashAmt", "");
			setValueById("retCashAmt", "");
			focusById("getCashAmt");
			loadPaymList();
		});
	}
}

function getCashAmtKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		if (!$(e.target).val()) {
			return;
		}
		var getCashAmt = $(e.target).val();
		var cashSum = getValueById("cashSum");
		var change = Number(getCashAmt).sub(cashSum);
		if (change < 0) {
			$.messager.confirm("确认", "消费金额大于收取金额，是否继续?", function (r) {
				if (!r) {
					return;
				}
				setValueById("retCashAmt", change);
			});
		}else {
			setValueById("retCashAmt", change);
		}
	}
}

function initPaymList() {
	$HUI.datagrid("#paymList", {
		fit: true,
		border: false,
		singleSelect: true,
		fitColumns: true,
		pageSize: 999999999,
		className: "web.DHCOPBillCalculatorLogic",
		queryName: "QryInvPayMDetails",
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if (!cm[i].width) {
					cm[i].width = 100;
				}
			}
		}
	});
}

function loadPaymList() {
	var queryParams = {
		ClassName: "web.DHCOPBillCalculatorLogic",
		QueryName: "QryInvPayMDetails",
		Guser: PUBLIC_CONSTANT.SESSION.USERID,
		job: getValueById("job"),
		rows: 99999999
	};
	loadDataGridStore("paymList", queryParams);
}