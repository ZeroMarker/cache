/**
 * FileName: dhcbill.ipbill.intpay.js
 * Author: ZhYW
 * Date: 2019-09-19
 * Description: 中途结算/拆分账单
 */

$(function () {
	initQueryMenu();
});

function initQueryMenu() {
	$("#stTime, #endTime").timespinner("disable");
	$HUI.datebox("#stDate", {
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				$("#stTime").timespinner("clear").timespinner("disable");
			}else {
				$("#stTime").timespinner("enable");
			}
		}
	});
	
	$HUI.datebox("#endDate", {
		onChange: function (newValue, oldValue) {
			if (!newValue) {
				$("#endTime").timespinner("clear").timespinner("disable");
			}else {
				$("#endTime").timespinner("enable");
			}
		}
	});
	
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
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryIPDept&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true,
		filter: function(q, row) {
			var opts = $(this).combobox("options");
			var mCode = false;
			if (row.contactName) {
				mCode = row.contactName.toUpperCase().indexOf(q.toUpperCase()) >= 0
			}
			var mValue = row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
			return mCode || mValue;
		}
	});
	
	//婴儿
	$HUI.combogrid("#baby", {
		panelWidth: 300,
		panelHeight: 150,
		url: $URL + "?ClassName=web.UDHCJFIntBill&QueryName=Baby&BillNo=" + CV.BillID,
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
	var rulesStr = getRulesStr();
	$.m({
		ClassName: "web.UDHCJFIntBill",
		MethodName: "ComputingCOM",
		Bill: CV.BillID,
		RulesStr: rulesStr,
		SessionStr: getSessionStr()
	}, function(amt) {
		setValueById("amount", amt);
	});
}

/**
* 拆分账单
*/
function splitClick() {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (amount == "") {
				$.messager.popover({msg: "请先收集金额", type: "info"});
				return reject();
			}
			if (amount == 0) {
				$.messager.popover({msg: "收集金额为0，不能拆分账单", type: "info"});
				return reject();
			}
			if (isClosedBill()) {
				$.messager.popover({msg: "该账单已封账，不能拆分账单", type: "info"});
				return reject();
			}
			var chargeAmt = Math.abs(intAmt - amount);
			
			var jsonObj = getPersistClsObj("User.DHCPatientBill", CV.BillID);
			var pbSum = jsonObj.PBTotalAmount;
			if (jsonObj.PBPayedFlag == "P") {
				$.messager.popover({msg: "该账单已结算，不能拆分账单", type: "info"});
				return reject();
			}
			if (!(pbSum > 0)) {
				$.messager.popover({msg: "账单不存在或金额为0，不能拆分账单", type: "info"});
				return reject();
			}
			if ((+chargeAmt == +amount) && (+amount == +pbSum)) {
				$.messager.popover({msg: "没有可拆的账单", type: "info"});
				return reject();
			}
			if (+intAmt != 0) {
				var rtn = $.m({ClassName: "web.UDHCJFIntBill", MethodName: "GetIntBillArcim", hospId: PUBLIC_CONSTANT.SESSION.HOSPID}, false);
				if (!rtn) {
					$.messager.popover({msg: "没有维护指定价格自定价医嘱，不能按照指定金额拆分账单", type: "info"});
					setValueById("intAmt", "");
					return reject();
				}
				if (+intAmt > +pbSum) {
					$.messager.popover({msg: "指定金额大于账单总金额，不能按照指定金额拆分账单", type: "info"});
					setValueById("intAmt", "");
					return reject();
				}
				if (chargeAmt > 10) {
					$.messager.popover({msg: "收集金额与拆分金额相差过大，请重新收集金额", type: "info"});
					return reject();
				}
			}
			
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "确认拆分账单？", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _split = function() {
		return new Promise(function (resolve, reject) {
			$.m({
				ClassName: "web.UDHCJFIntBill",
				MethodName: "RINBILLCOM",
				OldBill: CV.BillID,
				RulesStr: rulesStr,
				SessionStr: getSessionStr()
			}, function(rtn) {
				var myAry = rtn.split("^");
				if (myAry[0] == 0) {
					$.messager.alert("提示", "拆分账单成功，请注意进行封账，否则不能账单", "success", function() {
						return resolve();
					});
					return;
				}
				$.messager.popover({msg: "拆分账单失败：" + (myAry[1] || myAry[0]), type: "info"});
				reject();
			});
		});
	};
	
	var _success = function () {
		websys_showModal("options").callbackFunc();
		websys_showModal("close");
	};
	
	if ($("#btn-split").hasClass("l-btn-disabled")) {
		return;
	}
	$("#btn-split").linkbutton("disable");
	
	var amount = getValueById("amount");      //金额
	var intAmt = getValueById("intAmt");      //指定金额
	
	var rulesStr = getRulesStr();
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_split)
		.then(function() {
			_success();
		}, function() {
			$("#btn-split").linkbutton("enable");
		});
}

/**
* 判断账单是否已封账
* true:已封账, false:未封账
*/
function isClosedBill() {
	return ($.m({ClassName: "web.DHCIPBillPBCloseAcount", MethodName: "GetPaidCAcountFlag", BillNo: CV.BillID}, false) == "Y");
}

/**
* 获取拆分规则Json
*/
function getRulesStr() {
	var rulesObj = {
		DateFrom: getValueById("stDate"),
		DateTo: getValueById("endDate"),
		TimeFrom: getValueById("stTime"),
		TimeTo: getValueById("endTime"),
		Amount: getValueById("amount"),
		IntAmt: getValueById("intAmt"),
		InsTypeId: "",
		FullFlag: getValueById("isFullFlag") ? 1 : 0,
		BabyAdm: getValueById("baby"),
		OrdDeptId: getValueById("dept"),
		OrdCatStr: "",
		OrdSubCatStr: "",
		ARCIMStr: "",
		OEORIStr: "",
		PilotFlag: getValueById("isPilotFlag") ? 1 : 0
	};
	return JSON.stringify(rulesObj);
}