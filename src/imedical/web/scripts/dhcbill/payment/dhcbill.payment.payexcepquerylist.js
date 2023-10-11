/**
 * FileName: dhcbill.payment.payexcepquerylist.js
 * Author: zhenghao
 * Date: 2022-08-29
 * Description: ������������֤
 */

$(function () {
	initQueryMenu();
	initExceptionList();
});

function initQueryMenu () {
	$(".datebox-f").datebox("setValue", CV.DefDate);
	
	$("#tradeType").combobox({
		valueField: 'value',
		textField: 'text',
		data:[{
			value: '',
			text: 'ȫ��',
			selected: true			
		},{
			value: 'PRE',
			text: 'Ԥ����'
		},{
			value: 'DEP',
			text: 'סԺѺ��'
		},{
			value: 'OP',
			text: '�����շ�'
		},{
			value: 'CARD',
			text: '����'
		}]
	});

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
	
	//����
	$HUI.linkbutton("#btn-readCard", {
		onClick: function () {
			readHFMagCardClick();
		}
	});
	
	//���Żس���ѯ�¼�
	$("#CardNo").focus().keydown(function (e) {
		cardNoKeydown(e);
	});

	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function (e) {
		patientNoKeydown(e);
	});
	
	//�շ�Ա
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
 * ����
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
		$.messager.alert("��ʾ", "����Ч", "info", function () {
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
				$.messager.popover({msg: "�ǼǺŴ�������������", type: "info"});
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
		frozenColumns: [[{title: '����', field: 'operate', width: 60, align: 'center',
							formatter:function(value, row, index) {
								return "<a href='javascript:;' class='datagrid-cell-img' title='��֤' onclick='checkPaySrv(" + JSON.stringify(row) + ")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/back.png'/></a>";
						    }
						 }
			]],
		columns: [[{title: '����ID', field: 'ETPId', width: 120},
				   {title: 'PatientId', field: 'PatientId', hidden: true},
				   {title: '�ǼǺ�', field: 'PatientNo', width: 120},
				   {title: '��������', field: 'PatName', width: 100},
				   {title: '�Ա�', field: 'Sex', width: 60},
				   {title: 'ETPUserDR', field: 'ETPUserDR', hidden: true},
				   {title: '����Ա', field: 'ETPUser', width: 80},
				   {title: '����/�˻���', field: 'ETPPan', width: 110},
				   {title: '������ˮ��', field: 'ETPRRN', width: 110},
				   {title: '�����ն˺�', field: 'ETPTerminalNo', width: 110},
				   {title: '֧������', field: 'ETPExtTradeChannel', width: 80},
				   {title: '���׶�����', field: 'ExtTradeNo', width: 120},
				   {title: 'ETPPayMDR', field: 'ETPPayMDR', hidden: true},
				   {title: '֧����ʽ', field: 'PayMDesc', width: 100},
				   {title: '֧�����', field: 'ETPExtAmt', width: 120, align: 'right'},
				   {title: '֧��ʱ��', field: 'ExtDate', width: 155,
				   	formatter: function (value, row, index) {
						return value + " " + row.ExtTime;
					}
				   },
				   {title: 'ETPTradeType', field: 'ETPTradeType', hidden: true},
				   {title: 'ҵ������', field: 'BizType', width: 80},
				   {title: 'HIS������', field: 'HISTradeNo', width: 120},
				   {title: 'HIS������ʱ��', field: 'TradeDate', width: 155,
				   	formatter: function (value, row, index) {
						return value + " " + row.TradeTime;
					}
				   },
				   {title: '��������', field: 'ETPTradeChannel', width: 80}
			]],
		onLoadSuccess: function (data) {
			$(".datagrid-cell-img").tooltip();
		}
	});
}

function loadExceptionList() {
	var queryParams = {
		ClassName: "BILL.Payment.BL.PayException",
		QueryName: "CheckExceptionList",
		stDate: getValueById("stDate"),
		endDate: getValueById("endDate"),
		patientId: getValueById("patientId"),
		patientName: getValueById("patientName"),
		userId: getValueById("user"),
		tradeType: getValueById("tradeType"),
		cardno: getValueById("CardNo"),
		sessionStr: getSessionStr()
	};
	loadDataGridStore("exceptionList", queryParams);
}

/**
* ������֧����֤
*/
function checkPaySrv(row) {
	var _validate = function() {
		return new Promise(function (resolve, reject) {
			if (!row) {
				$.messager.popover({msg: "��ѡ����Ҫ��֤�ļ�¼", type: "info"});
				return reject();
			}
			ETPRowId = row.ETPId;
			if (!(ETPRowId > 0)) {
				$.messager.popover({msg: "���׶���������", type: "info"});
				return reject();
			}
			
			resolve();
		});
	};
	
	var _cfr = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("ȷ��", "�Ƿ�ȷ�ϲ�֤��", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _check = function() {
		return new Promise(function (resolve, reject) {
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			var rtnValue = CheckPayService(ETPRowId);
			if (rtnValue.ResultCode != 0) {
				$.messager.popover({msg: "������֧��ʧ�ܲ���Ҫ����", type: "success"});
				return reject();
			}
			resolve();
		});
	};
	
	var _cfrCancel = function() {
		return new Promise(function (resolve, reject) {
			$.messager.confirm("ȷ��", "�Ƿ����������˿", function(r) {
				return r ? resolve() : reject();
			});
		});
	};
	
	var _cancel = function() {
		return new Promise(function (resolve, reject) {
			var expStr = PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.USERID;
			var rtnValue = CancelPayService(ETPRowId, expStr);
			if (rtnValue.ResultCode != 0) {
				$.messager.popover({msg: "������֧������ʧ�ܣ�����ϵ����������", type: "error"});
				return reject();
			}
			$.messager.popover({msg: "�����ɹ�", type: "success"});
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
		.then(_check)
		.then(_cfrCancel)
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
	
	GV.ExceptionList.options().pageNumber = 1;   //��ת����һҳ
	GV.ExceptionList.loadData({total: 0, rows: []});
}