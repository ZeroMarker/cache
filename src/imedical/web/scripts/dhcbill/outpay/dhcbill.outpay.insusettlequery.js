/**
 * FileName: dhcbill.outpay.insusettlequery.js
 * Author: LUANZH
 * Date: 2022-12-29
 * Description: ҽ�������ѯ�볷��
 */
$(function() {
	initQueryMenu();
	initinsuSettleList();
	initChargeMenu();
});

function initQueryMenu() {
	$HUI.linkbutton("#btn-readCard", {
		onClick: function() {
			readHFMagCardClick();
		}
	});
	setValueById('stDate', getDefStDate(-5));
	setValueById('edDate', getDefStDate(0));

	//���Żس���ѯ�¼�
	$("#CardNo").focus().keydown(function(e) {
		cardNoKeydown(e);
	});

	//�ǼǺŻس���ѯ�¼�
	$("#patientNo").keydown(function(e) {
		patientNoKeydown(e);
	});

	$HUI.linkbutton('#btn-clear', {
		onClick: function() {
			clearClick();
		}
	});

	//״̬
	$HUI.combobox('#statusType', {
		panelHeight: 'auto',
		data: [{
			value: 'N',
			text: $g('����'),
			selected: true
		}, {
			value: 'A',
			text: $g('����')
		}, {
			value: 'S',
			text: $g('���')
		}, ],
		editable: false,
		valueField: 'value',
		textField: 'text'
	});

	//��������
	$HUI.combobox('#type', {
		panelHeight: 'auto',
		data: [{
			value: 'O',
			text: $g('����'),
			selected: true
		}, {
			value: 'I',
			text: $g('סԺ')
		}],
		editable: false,
		valueField: 'value',
		textField: 'text'
	});

	//�շ�Ա
	$HUI.combobox("#operator", {
		url: $URL + '?ClassName=web.DHCOPBillRefund&QueryName=FindInvUser&ResultSetType=array',
		mode: 'remote',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		onBeforeLoad: function(param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});

	//����ѱ�
	$HUI.combobox("#settleType", {
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QryAdmReason&ResultSetType=array',
		mode: 'remote',
		method: 'GET',
		valueField: 'id',
		textField: 'text',
		blurValidValue: true,
		onBeforeLoad: function(param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onSelect: function(rec) {
			setValueById("admSource", rec.admsource)
			loadInsuCombo(rec.id);
		},
		loadFilter: function(data) {
			return [{
				text: $g('ȫ��'),
				id: ""
			}].concat(data)
		},
		onLoadSuccess: function(data) {
			if (data) {
				setValueById("settleType", '');
			}

		}
	});
}

function initChargeMenu() {
	$("#insuAdmType").combobox("enable");
	//ҽ�����
	$HUI.combobox("#insuAdmType", {
		panelHeight: 150,
		method: 'GET',
		valueField: "cCode",
		textField: "cDesc",
		blurValidValue: true,
		defaultFilter: 4
	});
}

/**
 * ͨ��ҽ�����ʹ������ҽ����𡢲���
 */
function loadInsuCombo(insTypeId) {
	var papmidr = getValueById("PatientID");
	//��ȡҽ�����ʹ���
	$.m({
		ClassName: "web.INSUDicDataCom",
		MethodName: "GetDicByCodeAndInd",
		SysType: "AdmReasonDrToDLLType",
		Code: insTypeId,
		Ind: 6,
		HospDr: PUBLIC_CONSTANT.SESSION.HOSPID
	}, function(insuTypeCode) {
		//ҽ�����
		var url = $URL + "?ClassName=web.INSUDicDataCom&QueryName=QueryDic1&ResultSetType=array&Code=&OPIPFlag=OP&Type=AKA130" + insuTypeCode + "&HospDr=" + PUBLIC_CONSTANT.SESSION.HOSPID;
		$("#insuAdmType").combobox("clear").combobox("reload", url);
	});
}

function initinsuSettleList() {
	var toolbar = [{
		text: '��ӡҽ�����㵥',
		iconCls: 'icon-print',
		handler: function() {
			Expenselist();
		}
	}, {
		text: '��ӡҽ��������ϸ',
		iconCls: 'icon-print',
		handler: function() {
			Medsettle();
		}
	}, {
		text: '������ϸ����',
		iconCls: 'icon-export',
		handler: function() {
			financialexportnew();
		}

	},{
		text: '����ҽ����������',
		iconCls: 'icon-export',
		handler: function() {
			opInsuReimburseExport();
		}
	}
]
	$('#insuSettleList').datagrid({
		border: false,
		toolbar: toolbar,
		autoSizeColumn: false,
		fit: true,
		border: false,
		bodyCls: 'panel-header-gray',
		striped: true,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		singleSelect: true,
		checkOnSelect: false, //���Ϊfalse, ���û����ڵ���ø�ѡ���ʱ��Żᱻѡ�л�ȡ��
		selectOnCheck: false,
		pageSize: 20,
		columns: [
			[{
				field: 'ck',
				title: 'ck',
				checkbox: true
			}, {
				field: 'Rowid',
				title: '����',
				width: 100,
				formatter: function(value, row, index) {
					var btn = '<a href="#"  onclick="settlementDetail(\'' + row["Rowid"] + '\')">' + row.Rowid + '</a>';
					return btn;
				}
			}, {
				field: 'InvNo',
				title: '��Ʊ��',
				width: 100
			}, {
				field: 'PatName',
				title: '��������',
				width: 100
			}, {
				field: 'RegNo',
				title: '�ǼǺ�',
				width: 100
			}, {
				field: 'OptUserDesc',
				title: '�շ�Ա',
				width: 100
			}, {
				field: 'OptDate',
				title: '��������',
				width: 100,
				hidden: true
			}, {
				field: 'OptTime',
				title: '����ʱ��',
				width: 175,
				formatter: function(value, row, index) {
					if (row.OptDate) {
						return row.OptDate + " " + value;
					}
				},
			}, {
				field: 'TotalAmt',
				title: '�ܽ��',
				width: 100,
				align: "right"
			}, {
				field: 'SelfPayAmt',
				title: '����֧�����',
				width: 100,
				align: "right"
			}, {
				field: 'InsuPayAmt',
				title: 'ҽ��������',
				width: 100,
				align: "right"
			}, {
				field: 'InsuAccPayAmt',
				title: 'ҽ�������˻�֧�����',
				width: 100,
				align: "right"
			}, {
				field: 'PaymentType',
				title: '���ʽ',
				width: 100,
				formatter: function(value, row, index) {
					var btn = '<a href="#"  onclick="paymodeClick(\'' + row["PatName"] + '' + "|" + '' + row["TotalAmt"] + "|" + '' + row["InsuPayAmt"] + '\')">' + "���ʽ" + '</a>';
					return btn;
				},
				hidden: true
			}, {
				field: 'PayInfo',
				title: '֧����ʽ',
				width: 100
			}, {
				field: 'ChgedFlagTmp',
				title: '����״̬����',
				width: 100,
				hidden: true
			}, {
				field: 'ChgedFlag',
				title: '����״̬����',
				width: 100
			}, {
				field: 'InsuDivDR',
				title: 'ҽ������ID',
				width: 100,
				hidden: true
			}, {
				field: 'OptUserDR',
				title: '�շ�ԱID',
				width: 100,
				hidden: true
			}, {
				field: 'InsTypeDRTmp',
				title: '����ѱ�ID',
				width: 100,
				hidden: true
			}, {
				field: 'InsTypeDesc',
				title: '����ѱ�',
				width: 100
			}, {
				field: 'YDFlg',
				title: '������ر�ʶ',
				width: 100
			}]
		]
	});
}

/**
 * ����
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	if ($("#btn-readCard").linkbutton("options").disabled) {
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
		getPatInfo();
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
			setValueById("accMRowId", myAry[7]);
			setValueById("CardTypeRowId", myAry[8]);
			break;
		case "-200":
			$.messager.alert("��ʾ", "����Ч", "info", function() {
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
	if (patientId != "") {
		setPatDetail(patientId);
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
	}
}

function getPatInfo() {
	setValueById('EpisodeID', '');
	var patientNo = getValueById("patientNo");
	if (patientNo) {
		var expStr = "";
		$.m({
			ClassName: "web.DHCOPCashierIF",
			MethodName: "GetPAPMIByNo",
			PAPMINo: patientNo,
			ExpStr: expStr
		}, function(papmi) {
			if (!papmi) {
				$.messager.popover({
					msg: "�ǼǺŴ�������������",
					type: "info"
				});
				focusById("patientNo");
			} else {
				setValueById("PatientID", papmi);
				setPatDetail(papmi);
				loadinsuSettleList();
			}
		});
	}
}

function setPatDetail(papmi) {
	setValueById("PatientID", papmi);
	$.m({
		ClassName: "web.DHCOPCashierIF",
		MethodName: "GetPatientByRowId",
		PAPMI: papmi,
		ExpStr: ""
	}, function(rtn) {
		var myAry = rtn.split("^");
		var myname = myAry[2];
		var myPatientNo = myAry[1];
		var myPatType = myAry[7];
		var myAccMRowId = myAry[19];
		setValueById("patientNo", myPatientNo);
		setValueById("patientName", myname);

	});
}

/**
 *��ѯ
 **/
function QryChkPatInfo() {
	getPatInfo();
	loadinsuSettleList();
}

/**
 *�����б�
 */
function loadinsuSettleList() {
	if (getValueById("patientNo")=="") {
		setValueById("PatientID","");
	}
	var queryParams = {
		ClassName: "BILL.OUTPAY.BL.InvPrtCtl",
		QueryName: "OutPayInvPrtInfoQuery",
		StaDate: getValueById("stDate"),
		EndDate: getValueById("edDate"),
		PAPMIDR: getValueById("PatientID"),
		InsTypeDR: getValueById("settleType"),
		IsChged: getValueById("statusType"),
		Type: getValueById("type"),
		UserDr: getValueById("operator"),
		HospDr: PUBLIC_CONSTANT.SESSION.HOSPID,
		PatientName: getValueById("patientName")
	};
	loadDataGridStore("insuSettleList", queryParams);
}

/**
 * ����
 */
function clearClick() {
	setValueById('PatientID', '');
	setValueById('EpisodeID', '');
	$(':text:not(.pagination-num,.combobox-f)').val('');
	$('.numberbox-f').numberbox('clear');
	setValueById('stDate', getDefStDate(-5));
	setValueById('edDate', getDefStDate(0));
	$('.datagrid-f').datagrid('loadData', {
		total: 0,
		rows: []
	});
	setValueById("type","O");
	setValueById("settleType","");
	setValueById("statusType","N");
	//���banner
	showBannerTip();
}

/**
 * ���ʽά��
 */
function paymodeClick(paystr) {
	console.log(paystr)
	var paydata = paystr.split("|");
	var patientname = paydata[0];
	var allmoney = paydata[1];
	var ybmoney = paydata[2];
	var url = "dhcbill.outpay.paymodemaintenance.csp?&PatName=" + patientname + "&TotalAmt=" + allmoney + "&InsuPayAmt=" + ybmoney;
	websys_showModal({
		url: url,
		title: '���ʽά��',
		iconCls: 'icon-w-add',
		width: '34%',
		height: '34.6%',
		top: '41.5%',
		left: '33.8%'
	});
}

//��������
function Refund() {
	var row = $('#insuSettleList').datagrid('getChecked');
	if (row.length != 1) {
		$.messager.confirm('��ʾ', '�빴ѡһ�ŷ�Ʊ', function(r) {
			if (r) {
				return;
			} else {
				return;
			}
		})
	} else {
		$.messager.confirm("ȷ��", "�Ƿ�ȷ�ϳ�����Ʊ?", function(r) {
			if (r) {
				var InsTypeDR = row[0].InsTypeDRTmp;
				var InvPrtRowid = row[0].Rowid;
				var InsuDivDR=row[0].InsuDivDR
				var Handle = ""
				if (InsTypeDR == 1) {
					$.m({
						ClassName: "BILL.OUTPAY.BL.ChargeCtl",
						MethodName: "Refund",
						InvPrtRowid: InvPrtRowid,
						ExpStr: PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID
					}, function(rtn) {
						if ((rtn.indexOf("-") != -1)) {
							$.messager.popover({
								msg: rtn,
								type: 'error'
							});
						} else {
							$.messager.popover({
								msg: "�����ɹ���",
								type: 'success'
							});
							loadinsuSettleList();
						}
					});

				} else {
					var myInsuDivStr = tkMakeServerCall("BILL.OUTPAY.BL.ChargeCtl", "GetOutPayInsuDivInfo",InvPrtRowid);
					var myAry = myInsuDivStr.split("^");
			        var myAdmSource = myAry[2];
					var expStr = ""
					var myYBHand = "0";
					var myStrikeFlag = "N";
					var myInsuNo = "";
					var myCardType = "";
					var myYLLB = getValueById("insuAdmType");
					var accMRowId = getValueById("accMRowId");
					var myDicCode = "";
					var myDicDesc = "";
					var myDYLB = "";
					var myChargeSource = "01";
					var myDBConStr = ""; //���ݿ����Ӵ�
					var myMoneyType = "";
					var selPaymId = "";
					var myLeftAmt = "";
					var myYBExpStr = myStrikeFlag + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + myInsuNo + "^" + myCardType + "^" + myYLLB + "^" + myDicCode + "^" + myDicDesc;
					myYBExpStr += "^" + myLeftAmt + "^" + myChargeSource + "^" + myDBConStr + "^" + myDYLB + "^" + accMRowId + "^" + PUBLIC_CONSTANT.SESSION.HOSPID + "^" + selPaymId + "!" + myLeftAmt + "^" + myMoneyType;
					var myYBRtn = InsuOPOutPayDivideStrike(Handle, PUBLIC_CONSTANT.SESSION.USERID, InsuDivDR, myAdmSource, InsTypeDR, myYBExpStr)
					if (myYBRtn.split("^")[0] != 0) {
						$.messager.alert("��ʾ", "ҽ����������" + myYBRtn, "error");
						return;
					} else {
						$.m({
							ClassName: "BILL.OUTPAY.BL.ChargeCtl",
							MethodName: "Refund",
							InvPrtRowid: InvPrtRowid,
							ExpStr: PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID
						}, function(rtn) {
							if ((rtn.indexOf("-") != -1)) {
								$.messager.popover({
									msg: rtn,
									type: 'error'
								});
							} else {
								$.messager.popover({
									msg: "�����ɹ���",
									type: 'success'
								});
								loadinsuSettleList();
								billOutpayEInvoiceOP(InvPrtRowid);
							}
						});
					}
				}
			}
		});
	}
}

//������ϸ����
function financialexportnew() {
	var rows = $('#insuSettleList').datagrid('getChecked');
	if (rows.length < 1) {
		$.messager.confirm('��ʾ', '�����ٹ�ѡһ�ŷ�Ʊ', function(r) {
			if (r) {
				return;
			} else {
				return;
			}
		})
	} else {
		var rowIdStr = ""
		for (i = rows.length - 1; i >= 0; i--) {
			rowIdStr = rows[i].Rowid + "^" + rowIdStr
		}
		var PrtRowIdStr = rowIdStr;
		var hospdesc = PUBLIC_CONSTANT.SESSION.HOSPDESC;
		var username = PUBLIC_CONSTANT.SESSION.USERNAME;
		var hospitaldr = PUBLIC_CONSTANT.SESSION.HOSPID;
		var fileName = "DHCBILL-OUTPAY-YBCWNew.rpx&PrtRowIdStr=" + PrtRowIdStr;
		fileName += "&USERNAME=" + username + "&HOSPDESC=" + hospdesc;
		var width = $(window).width() * 0.8;
		var height = $(window).height() * 0.8;
		DHCCPM_RQPrint(fileName, width, height);
	}
}

//������ϸ
function settlementDetail(InvRowid) {
	var url = "dhcbill.outpay.settlementDetail.csp?InvRowid=" + InvRowid;
	websys_showModal({
		url: url,
		iconCls: 'icon-w-list',
		title: "������ϸ",
		width: 1100,
		height: 500
	});
}

//��ӡҽ�����㵥
function Expenselist() {

}

//��ӡҽ��������ϸ
function Medsettle() {
	var row = $('#insuSettleList').datagrid('getChecked');
	if (row.length != 1) {
		$.messager.confirm('��ʾ', '�빴ѡһ�ŷ�Ʊ', function(r) {
			if (r) {
				return;
			} else {
				return;
			}
		})
	} else {
		var InvPrtRowid = row[0].Rowid;
		var regno = row[0].RegNo;
		var patname = row[0].PatName;
		var billdr = ""
		console.log(InvPrtRowid)
		var fileName = "DHCBILL-OUTPAY-WYFPBXYBJSMX.rpx&InvPrtRowid=" + InvPrtRowid + "&BillDr=" + billdr + "&RegNo=" + regno + "&PatName=" + patname;
		var width = $(window).width() * 0.8;
		var height = $(window).height() * 0.8;
		DHCCPM_RQPrint(fileName, width, height);
	}
}

/**
 * Creator: suhuide
 * CreatDate: 2021-12-02
 * Desc: ȷ����ɺ���õ��ӷ�Ʊ����ҵ��
 */
function billOutpayEInvoiceOP(prtInvIdStr) {
	var tradeType = "OUTOP"; //ҵ������
	//1����ԱID^2��ȫ��^3����^4Ժ��)
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + "^" + PUBLIC_CONSTANT.SESSION.GROUPID + "^" + PUBLIC_CONSTANT.SESSION.CTLOCID + "^" + PUBLIC_CONSTANT.SESSION.HOSPID;
	var myAry = prtInvIdStr.split("^");
	$.each(myAry, function(index, id) {
		if (id) {
			var eInvFlg = JudgeEInvFlag(tradeType, expStr);
			if (eInvFlg == "Y") { //�Ƿ񿪾ߵ��ӷ�Ʊ Y:���� N:������
				var eInvRtn = EInvoieService(tradeType, id, "InvalidInvSvr", expStr);
				if (eInvRtn.ResultCode != 0) {
					$.messager.alert("��ʾ", eInvRtn.ResultMsg + ",�뵽����Ʊ�ݲ����׽������.", "error");
				}
			}
		}
	});
}

//��������ҽ������
function opInsuReimburseExport() {
	var StaDate = getValueById("stDate");
	var EndDate = getValueById("edDate");
	var InsTypeDR = getValueById("settleType");
	var UserDr = getValueById("operator");
	var ChargeFlag = getValueById("statusType");
	var HospitalDr = PUBLIC_CONSTANT.SESSION.HOSPID;
	var fileName = "BILL.OUTPAY.RPT.OPDIVHZ.rpx&StaDate=" + StaDate + "&EndDate=" + EndDate + "&InsTypeDR=" + InsTypeDR;
		fileName += "&UserDr=" + UserDr + "&ChargeFlag=" + ChargeFlag + "&HospitalDr=" + HospitalDr;
		var width = $(window).width() * 0.8;
		var height = $(window).height() * 0.8;
		DHCCPM_RQPrint(fileName, width, height);
}

