/**
 * FileName: dhcbill.payment.iprefexception.js
 * Author: ZhYW
 * Date: 2022-04-06
 * Description: 住院第三方退费补交易
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
		frozenColumns: [[{title: '操作', field: 'operate', width: 60, align: 'center',
							formatter:function(value, row, index) {
								return "<a href='javascript:;' class='datagrid-cell-img' title='退费' onclick='refundClick(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>";
						    }
						 }
			]],
		columns: [[{title: 'oldPrtRowId', field: 'oldPrtRowId', hidden:true},
		           {title: 'strikeRowId', field: 'strikeRowId', hidden: true},
				   {title: 'newPrtRowId', field: 'newPrtRowId', hidden: true},
				   {title: 'adm', field: 'adm', hidden: true},
				   {title: 'patientId', field: 'patientId', hidden: true},
				   {title: '登记号', field: 'patientNo', width: 100},
				   {title: '病案号', field: 'medicareNo', width: 100},
				   {title: '患者姓名', field: 'patName', width: 100},
				   {title: '性别', field: 'sex', width: 50},
				   {title: '费别', field: 'insTypeDesc', width: 80},
				   {title: '科室病区', field: 'dept', width: 120,
				    formatter: function (value, row, index) {
						return value + " " + row.ward;
					}
				   },
				   {title: '床号', field: 'bed', width: 50},
				   {title: '操作员', field: 'userName', width: 100},
				   {title: '业务类型', field: 'bizType', width: 110},
				   {title: '退费时间', field: 'prtDate', width: 155,
				   	formatter: function (value, row, index) {
						return value + " " + row.prtTime;
					}
				   },
				   {title: 'paymId', field: 'paymId', hidden: true},
				   {title: '退费方式', field: 'paymDesc', width: 120},
				   {title: '退费金额', field: 'refAmt', width: 120, align: 'right'},
				   {title: 'tradeType', field: 'tradeType', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$(".datagrid-cell-img").tooltip();
		}
	});
}

function loadExceptionList() {
	var queryParams = {
		ClassName: "BILL.Payment.BL.IPRefException",
		QueryName: "QryExceptionList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		patientId: getValueById("patientId"),
		patientName: getValueById("patientName"),
		userId: getValueById("user"),
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
			if (!(strikeRowId > 0)) {
				$.messager.popover({msg: "退费记录不存在", type: "info"});
				return reject();
			}
			oldPrtRowId = row.oldPrtRowId;
			newPrtRowId = row.newPrtRowId;
			tradeType = row.tradeType;
			refundAmt = row.refAmt;
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
	var refundAmt = "";         //退款金额
	
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
	$(":text:not(.pagination-num)").val("");
	$("#CardTypeRowId").val("");
	setValueById("user", PUBLIC_CONSTANT.SESSION.USERID);
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	GV.ExceptionList.options().pageNumber = 1;   //跳转到第一页
	GV.ExceptionList.loadData({total: 0, rows: []});
}