/**
 * FileName: dhcbill.payment.payexceptionlist.js
 * Author: ZhYW
 * Date: 2022-02-25
 * Description: 第三方支付异常订单退费
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

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
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
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		frozenColumns: [[{title: '操作', field: 'operate', width: 60, align: 'center',
							formatter: function(value, row, index) {
								return "<a href='javascript:;' class='datagrid-cell-img' title='撤销' onclick='cancelPaySrv(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>";
						    }
						 }
			]],
		columns: [[{title: 'ETPId', field: 'ETPId', hidden:true},
				   {title: 'PatientId', field: 'PatientId', hidden: true},
				   {title: '登记号', field: 'PatientNo', width: 120},
				   {title: '患者姓名', field: 'PatName', width: 100},
				   {title: '性别', field: 'Sex', width: 60},
				   {title: 'ETPUserDR', field: 'ETPUserDR', hidden: true},
				   {title: '操作员', field: 'ETPUser', width: 80},
				   {title: '卡号/账户号', field: 'ETPPan', width: 110},
				   {title: '交易流水号', field: 'ETPRRN', width: 110},
				   {title: '交易终端号', field: 'ETPTerminalNo', width: 110},
				   {title: '支付渠道', field: 'ETPExtTradeChannel', width: 80},
				   {title: '交易订单号', field: 'ExtTradeNo', width: 120},
				   {title: 'ETPPayMDR', field: 'ETPPayMDR', hidden: true},
				   {title: '支付方式', field: 'PayMDesc', width: 100},
				   {title: '支付金额', field: 'ETPExtAmt', width: 120, align: 'right'},
				   {title: '支付时间', field: 'ExtDate', width: 155,
				   	formatter: function (value, row, index) {
						return value + " " + row.ExtTime;
					}
				   },
				   {title: 'ETPTradeType', field: 'ETPTradeType', hidden: true},
				   {title: '业务类型', field: 'BizType', width: 80},
				   {title: 'HIS订单号', field: 'HISTradeNo', width: 120},
				   {title: 'HIS发起交易时间', field: 'TradeDate', width: 155,
				   	formatter: function (value, row, index) {
						return value + " " + row.TradeTime;
					}
				   },
				   {title: '交易渠道', field: 'ETPTradeChannel', width: 80}
			]],
		onLoadSuccess: function (data) {
			$(".datagrid-cell-img").tooltip();
		}
	});
}

function loadExceptionList() {
	var queryParams = {
		ClassName: "BILL.Payment.BL.PayException",
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
* 第三方支付冲销
*/
function cancelPaySrv(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!row) {
				$.messager.popover({msg: "请选择需要冲销的记录", type: "info"});
				return reject();
			}
			ETPRowId = row.ETPId;
			if (!(ETPRowId > 0)) {
				$.messager.popover({msg: "交易订单不存在", type: "info"});
				return reject();
			}
			var rtn = $.m({ClassName: "BILL.Payment.BL.PayException", MethodName: "ValidateCancel", ETPRowId: ETPRowId, UserId: PUBLIC_CONSTANT.SESSION.USERID}, false);
			var myAry = rtn.split("^");
			if (myAry[0] != 0) {
				$.messager.popover({msg: (myAry[1] || myAry[0]), type: "info"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("确认", "是否确认撤销？", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			var rtnValue = CancelPayService(ETPRowId, expStr);
			if (rtnValue.ResultCode != 0) {
				$.messager.popover({msg: "第三方支付撤销失败，请联系工程师处理", type: "error"});
				return reject();
			}
			$.messager.popover({msg: "撤销成功", type: "success"});
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

	var ETPRowId = "";
	var promise = Promise.resolve();
	promise
		.then(_validate)
		.then(_cfr)
		.then(_cancel)
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