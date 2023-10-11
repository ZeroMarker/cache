/**
 * FileName: dhcbill.payment.oprefexception.js
 * Author: ZhYW
 * Date: 2022-03-31
 * Description: 门诊第三方退费补交易
 */

$(function () {
	initQueryMenu();
	initExceptionList();
});

function initQueryMenu () {
	$(".datebox-f").datebox("setValue", CV.DefDate);

	$HUI.linkbutton("#btn-find", {
		onClick: function () {
			loadExceptionList();
		}
	});

	$HUI.linkbutton("#btn-clear", {
		onClick: function () {
			clearClick();
		}
	});
	
	//读卡
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
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
	
	//收费员
	var userName = $.m({ClassName: "User.SSUser", MethodName: "GetTranByDesc", Prop: "SSUSRName", Desc: PUBLIC_CONSTANT.SESSION.USERNAME, LangId: PUBLIC_CONSTANT.SESSION.LANGID}, false);
	$HUI.combobox("#user", {
		panelHeight: 150,
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		data: [{id: PUBLIC_CONSTANT.SESSION.USERID, text: userName, selected: true}]
	});
	
	//2022-10-12 ZhYW
	$HUI.combobox("#binsType", {
		panelHeight: 'auto',
		data: [
			   {value: 'CARD', text: $g('卡费')},
			   {value: 'OP', text: $g('挂号收费')},
			   {value: 'PRE', text: $g('门诊预交金')},
			   {value: 'EPDEP', text: $g('留观押金')},
			   {value: 'PEDEP', text: $g('体检预交金')},
			   {value: 'PE', text: $g('体检收费')}
			],
		valueField: 'value',
		textField: 'text',
		defaultFilter: 5,
		blurValidValue: true
	});
}

function readHFMagCardClick() {
	if ($("#btn-readCard").hasClass("l-btn-disabled")) {
		return;
	}
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
			focusById("CardNo");
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
	setValueById("patientId", patientId);
	if (patientId != "") {
		loadExceptionList();
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo = $.m({ClassName: "web.UDHCJFBaseCommon", MethodName: "regnocon", PAPMINo: $(e.target).val()}, false);
		$(e.target).val(patientNo);
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: ""
		}, function(patientId) {
			if (!patientId) {
				$.messager.popover({msg: "登记号错误，请重新输入", type: "info"});
				$(e.target).focus();
			}
			setValueById("patientId", patientId);
			loadExceptionList();
		});
	}
}

function initExceptionList () {
	GV.ExceptionList = $HUI.datagrid("#exceptionList", {
		fit: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		className: "BILL.Payment.BL.OPRefException",
		queryName: "QryExceptionList",
		frozenColumns: [[{title: '操作', field: 'operate', width: 60, align: 'center',
							formatter:function(value, row, index) {
								return "<a href='javascript:;' class='datagrid-cell-img' title='退款' onclick='refundClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>";
				    		}
				   		}
			]],
		onColumnsLoad: function(cm) {
			for (var i = (cm.length - 1); i >= 0; i--) {
				if ($.inArray(cm[i].field, ["prtDate"]) != -1) {
					cm.splice(i, 1);
					continue;
				}
				if ($.inArray(cm[i].field, ["oldPrtRowId", "strikeRowId", "newPrtRowId", "patientId", "paymId", "tradeType"]) != -1) {
					cm[i].hidden = true;
					continue;
				}
				if (cm[i].field == "prtTime") {
					cm[i].formatter = function(value, row, index) {
						return row.prtDate + " " + value;
					}
				}
				if (cm[i].field == "userName") {
					cm[i].title = "操作员";
				}
				if (!cm[i].width) {
					cm[i].width = 100;
					if (cm[i].field == "prtTime") {
						cm[i].width = 155;
					}
				}
			}
		},
		onLoadSuccess: function (data) {
			$(".datagrid-cell-img").tooltip();
		}
	});
}

function loadExceptionList() {
	var queryParams = {
		ClassName: "BILL.Payment.BL.OPRefException",
		QueryName: "QryExceptionList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		patientId: getValueById("patientId"),
		patientName: getValueById("patientName"),
		userId: getValueById("user"),
		binsType: getValueById("binsType"),
		sessionStr: getSessionStr()
	};
	loadDataGridStore("exceptionList", queryParams);
}

/**
* 退费补交易
*/
function refundClick(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!row) {
				$.messager.popover({msg: "请选择需要退费的记录", type: "info"});
				return reject();
			}
			strikeRowId = row.strikeRowId;
			if (strikeRowId == "") {
				$.messager.popover({msg: "退费记录不存在", type: "info"});
				return reject();
			}
			oldPrtRowId = row.oldPrtRowId;
			newPrtRowId = row.newPrtRowId;
			tradeType = row.tradeType;
			refundAmt = row.refAmt;
			if ((tradeType == "OP") && (newPrtRowId > 0)) {
				var newPrtFlag = getPropValById("DHC_INVPRT", newPrtRowId, "PRT_Flag");
				if (newPrtFlag == "TP") {
					$.messager.popover({msg: "该记录对应产生的新票未完成收费，请到【门诊收费异常处理】界面处理", type: "info"});
					return reject();
				}
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", ($g("确认退款") + "<font color=\"red\">" + refundAmt + "</font>" + $g("元") + "？"), function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _refundSrv = function() {
		return new Promise(function (resolve, reject) {
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			var rtnValue = RefundPayService(tradeType, oldPrtRowId, strikeRowId, newPrtRowId, refundAmt, tradeType, expStr);
			if (rtnValue.ResultCode != 0) {
				$.messager.alert("提示", ("退款失败：" + rtnValue.ResultMsg + "，错误代码：" + rtnValue.ResultCode), "error");
				return reject();
			}
			$.messager.popover({msg: rtnValue.ResultMsg, type: "success"});
			resolve();
		});
	};
	
	var _success = function() {
		loadExceptionList();
	};
	
	var $this = $(event.target);
	if ($this.prop("disabled")) {
		return;
	}
	$this.prop("disabled", true);
	
	var oldPrtRowId = "";       //原收费记录Id
	var strikeRowId = "";       //退费记录Id
	var newPrtRowId = "";       //重收记录Id
	var tradeType = "";         //交易类型
	var refundAmt = "";         //退费金额
	
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_refundSrv)
		.then(function() {
			_success();
			$this.removeProp("disabled");
		}, function() {
			$this.removeProp("disabled");
		});
}

function clearClick() {
	focusById("CardNo");
	$(":text:not(.pagination-num,.combo-text)").val("");
	$("#CardTypeRowId").val("");
	$(".combobox-f").combobox("clear");
	setValueById("user", PUBLIC_CONSTANT.SESSION.USERID);
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	GV.ExceptionList.options().pageNumber = 1;   //跳转到第一页
	GV.ExceptionList.loadData({total: 0, rows: []});
}