/**
 * FileName: dhcbill.opbill.billcashcalc.js
 * Anchor: ZhYW
 * Date: 2019-06-13
 * Description: 门诊收费计算器
 */

$(function () {
	initQueryMenu();
	initPaymList();
});

function initQueryMenu() {
	setValueById("currInvNo", getParam("receiptNo"));
	//票据号
	focusById("invNum");
	$("#invNum").keydown(function (e) {
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
		setValueById("invNum", $(e.target).val());  //numberbox 在失去焦点时候才能获取到值，所以这里给其赋值以便能取到
		var invNum = getValueById("invNum");
		if (+invNum < 1) {
			$.messager.popover({msg: "票据张数输入错误", type: "info"});
			$(e.target).focus().select();
			return;
		}
		$.m({
			ClassName: "web.DHCOPBillCalculatorLogic",
			MethodName: "GetInvFeeData",
			Guser: PUBLIC_CONSTANT.SESSION.USERID,
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
		setValueById("getCashAmt", $(e.target).val());  //numberbox 在失去焦点时候才能获取到值，所以这里给其赋值以便能取到
		var getCashAmt = getValueById("getCashAmt");
		var change = numCompute(getCashAmt, getValueById("cashSum"), "-");
		if (+change < 0) {
			$.messager.confirm("确认", "消费金额大于收取金额，是否继续?", function (r) {
				if (r) {
					setValueById("retCashAmt", change);
				}
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
		striped: true,
		singleSelect: true,
		autoRowHeight: false,
		fitColumns: true,
		pageSize: 999999999,
		data: [],
		columns: [[{title: '支付方式', field: 'TpayMDesc', width: 100},
				   {title: '金额', field: 'Tamt', align: 'right', width: 100}		   
			]]
	});
}

function loadPaymList() {
	var queryParams = {
		ClassName: "web.DHCOPBillCalculatorLogic",
		QueryName: "QueryInvPayMDetails",
		Guser: PUBLIC_CONSTANT.SESSION.USERID,
		job: getValueById("job"),
		rows: 99999999
	};
	loadDataGridStore("paymList", queryParams);
}