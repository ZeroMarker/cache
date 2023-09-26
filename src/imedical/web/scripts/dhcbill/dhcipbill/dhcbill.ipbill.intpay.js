/**
 * FileName: dhcbill.ipbill.intpay.js
 * Anchor: ZhYW
 * Date: 2019-09-19
 * Description: 中途结算/拆分账单
 */

var GV = {
	BillID: getParam("BillID")
};

$(function () {
	initQueryMenu();
});


function initQueryMenu() {
	$HUI.linkbutton("#btn-calc", {
		onClick: function () {
			calcClick();
		}
	});
	
	$HUI.linkbutton("#btn-split", {
		onClick: function () {
			splitClick();
		}
	});
	
	//科室
	$HUI.combobox("#dept", {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillCashier&QueryName=FindDept&ResultSetType=array',
		mode: 'remote',
		method: 'get',
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
	
	//婴儿
	$HUI.combogrid("#baby", {
		panelWidth: 300,
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCJFIntBill&QueryName=Baby&BillNo=" + GV.BillID,
		mode: 'remote',
		method: 'get',
		idField: 'Adm',
		textField: 'Adm',
		blurValidValue: true,
		pageSize: 999,
		lazy: true,
		columns: [[{field: 'Adm', title: '就诊ID', width: 70},
			 	   {field: 'PatNo', title: '登记号', width: 110},
			       {field: 'PatName', title: '婴儿姓名', width: 100}
		  ]]
	});
}

/**
* 收集金额
*/
function calcClick() {
	$.m({
		ClassName: "web.UDHCJFIntBill",
		MethodName: "ComputingCOM",
		billno: GV.BillID,
		frmdat: getValueById("stDate"),
		todat: getValueById("endDate"),
		ordcatstr: "",
		ordsubcatstr: "",
		arcitemstr: "",
		orderstr: "",
		frmtime: getValueById("stTime"),
		totime: getValueById("endTime"),
		locid: getValueById("dept"),
		Flag: getValueById("isFullFlag") ? 1 : 0,
		BabyAdm: getValueById("baby"),
		IsPilotFlag: getValueById("isPilotFlag") ? 1 : 0
	}, function(amt) {
		setValueById("amount", amt);
	});
}

/**
* 拆分账单
*/
function splitClick() {
	var amount = getValueById("amount");      //金额
	if (amount == "") {
		$.messager.popover({msg: "请先收集金额", type: "info"});
		return;
	}
	if (+amount == 0) {
		$.messager.popover({msg: "收集金额为0，不能拆分账单", type: "info"});
		return;
	}
	var intAmt = getValueById("intAmt");       //指定金额
	var chargeAmt = Math.abs(intAmt - amount);

	var jsonObj = $.cm({ClassName: "web.DHCBillCommon", MethodName: "GetClsPropValById", clsName: "User.DHCPatientBill", id: GV.BillID}, false);
	var pbSum = jsonObj.PBTotalAmount;
	if (jsonObj.PBPayedFlag == "P") {
		var closeFlag = $.m({ClassName: "web.DHCIPBillPBCloseAcount", MethodName: "GetPaidCAcountFlag", BillNo: GV.BillID}, false);
		if (closeFlag == "Y") {
			$.messager.popover({msg: "该账单已封账，不能拆分账单", type: "info"});
		}else {
			$.messager.popover({msg: "该账单已结算，不能拆分账单", type: "info"});
		}
		return;
	}
	if (!(+pbSum > 0)) {
		$.messager.popover({msg: "账单不存在或金额为0，不能拆分账单", type: "info"});
		return;
	}
	if ((+chargeAmt == +amount) && (+amount == +pbSum)) {
		$.messager.popover({msg: "没有可拆的账单", type: "info"});
		return;
	}
	if (+intAmt != 0) {
		var rtn = $.m({ClassName: "web.UDHCJFIntBill", MethodName: "GetIntBillArcim", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
		if (!rtn) {
			$.messager.popover({msg: "没有维护指定价格自定价医嘱，不能按照指定金额拆分账单", type: "info"});
			setValueById("intAmt", "");
			return;
		}
		if (+intAmt > +pbSum) {
			$.messager.popover({msg: "指定金额大于账单总金额，不能按照指定金额拆分账单", type: "info"});
			setValueById("intAmt", "");
			return;
		}
		if (+chargeAmt > 10) {
			$.messager.popover({msg: "收集金额与拆分金额相差过大，请重新收集金额", type: "info"});
			return;
		}
	}

	var stDate = getValueById("stDate");
	var endDate = getValueById("endDate");
	var stTime = getValueById("stTime");
	var endTime = getValueById("endTime");
	var dateStr = stDate + "^" + endDate + "^" + stTime + "^" + endTime;
	var expStr = amount + "^" + intAmt;
	$.messager.confirm("确认", "确认拆分账单？", function(r) {
		if (r) {
			$.m({
				ClassName: "web.UDHCJFIntBill",
				MethodName: "RINBILLCOM",
				OldBill: GV.BillID,
				iDateStr: dateStr,
				iOrderStr: "",
				Payor: "",
				ordcatstr: "",
				ordsubcatstr: "",
				arcitemstr: "",
				orderstr: "",
				locid: getValueById("dept"),
				Flag: getValueById("isFullFlag") ? 1 : 0,
				BabyAdm: getValueById("baby"),
				SessionStr: getSessionStr(),
				IsPilotFlag: getValueById("isPilotFlag") ? 1 : 0,
				ExpStr: expStr
			}, function(rtn) {
				var myAry = rtn.split("^");
				switch(myAry[0]) {
				case "0":
					$.messager.alert("提示", "拆分账单成功，请注意进行封账，否则不能账单", "success", function() {
						websys_showModal("options").callbackFunc();
						websys_showModal("close");
					});
					break;
				default:
					$.messager.popover({msg: "拆分账单失败：" + myAry[0], type: "info"});
					break;
				}
			});
		}
	});
}