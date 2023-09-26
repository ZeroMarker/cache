/**
 * FileName: dhcbill.opbill.invQuery.js
 * Anchor: ZhYW
 * Date: 2018-10-13
 * Description: 门诊收据查询
 */

var GV = {};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initInvList();
});

function initQueryMenu() {
	var defDate = getDefStDate(0);
	$('#stDateTime').datetimebox('setValue', (defDate + ' ' + '00:00:00'));
	$('#endDateTime').datetimebox('setValue', (defDate + ' ' + '23:59:59'));

	$HUI.linkbutton('#btn-readCard', {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			loadInvList();
		}
	});
	
	$HUI.linkbutton('#btn-clear', {
		onClick: function () {
			clearClick();
		}
	});
	
	//卡号回车查询事件
	$('#cardNo').keydown(function (e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$('#patientNo').keydown(function (e) {
		patientNoKeydown(e);
	});

	//发票回车查询事件
	$('#invNo').keydown(function (e) {
		var key = websys_getKey(e);
		if (key == 13) {
			loadInvList();
		}
	});

	//卡类型
	$HUI.combobox('#cardType', {
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onChange: function (newValue, oldValue) {
			initReadCard(newValue);
		}
	});

	$HUI.combobox('#guser', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.udhcOPQUERY&QueryName=FindInvUser&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		mode: 'remote',
		method: 'GET',
		blurValidValue: true,
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});

	$HUI.combobox('#invFlag', {
		panelHeight: 'auto',
		data: [{value: 'A', text: '作废'},
			   {value: 'S', text: '红冲'}
			],
		valueField: 'value',
		textField: 'text'
	});

	$HUI.combobox('#footFlag', {
		panelHeight: 'auto',
		data: [{value: 'Y', text: '已结'},
			   {value: 'N', text: '未结'}
			],
		valueField: 'value',
		textField: 'text'
	});

	$HUI.combobox('#paymode', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.UDHCOPOtherLB&QueryName=ReadCTPayMode&ResultSetType=array',
		valueField: 'CTPM_RowId',
		textField: 'CTPM_Desc',
		defaultFilter: 4
	});

	$HUI.combobox('#admReason', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.udhcOPQUERY&QueryName=FindAdmReason&ResultSetType=array',
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		onBeforeLoad: function (param) {
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	try {
		var cardType = getValueById('cardType');
		var cardTypeDR = cardType.split('^')[0];
		var myRtn = '';
		if (cardTypeDR == '') {
			myRtn = DHCACC_GetAccInfo();
		} else {
			myRtn = DHCACC_GetAccInfo(cardTypeDR, cardType);
		}
		var myAry = myRtn.toString().split('^');
		var rtn = myAry[0];
		switch (rtn) {
		case '0':
			setValueById('cardNo', myAry[1]);
			setValueById('patientNo', myAry[5]);
			loadInvList();
			break;
		case '-200':
			$.messager.alert('提示', '卡无效', 'info', function () {
				focusById('btn-readCard');
			});
			break;
		case '-201':
			setValueById('cardNo', myAry[1]);
			setValueById('patientNo', myAry[5]);
			loadInvList();
			break;
		default:
		}
	} catch (e) {
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: 'web.UDHCJFBaseCommon',
			MethodName: 'regnocon',
			PAPMINo: $(e.target).val()
		}, function (patientNo) {
			$(e.target).val(patientNo);
			loadInvList();
		});
	}
}

function cardNoKeydown(e) {
	try {
		var key = websys_getKey(e);
		if (key == 13) {
			var cardNo = getValueById('cardNo');
			if (!cardNo) {
				return;
			}
			var cardType = getValueById('cardType');
			cardNo = formatCardNo(cardType, cardNo);
			var cardTypeAry = cardType.split('^');
			var cardTypeDR = cardTypeAry[0];
			var myRtn = DHCACC_GetAccInfo(cardTypeDR, cardNo, '', 'PatInfo');
			var myAry = myRtn.toString().split('^');
			var rtn = myAry[0];
			switch (rtn) {
			case '0':
				setValueById('cardNo', myAry[1]);
				setValueById('patientNo', myAry[5]);
				loadInvList();
				break;
			case '-200':
				setTimeout(function () {
					$.messager.alert('提示', '卡无效', 'info', function () {
						focusById('cardNo');
					});
				}, 300);
				break;
			case '-201':
				setValueById('cardNo', myAry[1]);
				setValueById('patientNo', myAry[5]);
				loadInvList();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

/**
 * 初始化卡类型时卡号和读卡按钮的变化
 * @method initReadCard
 * @param {String} cardType
 * @author ZhYW
 */
function initReadCard(cardType) {
	try {
		var cardTypeAry = cardType.split('^');
		var readCardMode = cardTypeAry[16];
		if (readCardMode == 'Handle') {
			disableById('btn-readCard');
			$('#cardNo').attr('readOnly', false);
		} else {
			enableById('btn-readCard');
			setValueById('cardNo', '');
			$('#cardNo').attr('readOnly', true);
		}
	} catch (e) {
	}
}

function initInvList() {
	var toolbar = [{
			text: '导出',
			iconCls: 'icon-export',
			handler: function () {
				exportClick();
			}
		}, {
			text: '打印清单',
			iconCls: 'icon-print',
			handler: function () {
				printClick();
			}
		}
	];
	
	GV.InvList = $HUI.datagrid('#invList', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		selectOnCheck: false,
		checkOnSelect: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: toolbar,
		data: [],
		frozenColumns: [[{title: 'ck', field: 'ck', checkbox: true}]],
		columns: [[{title: '导航号', field: 'TINVRowid', width: 80,
					formatter: function (value, row, index) {
						if (value) {
							return "<a href='javascript:;' onclick=\"orderDetail(\'" + value + "', '" + row.TabFlag + "\')\">" + value + "</a>";
						}
					}
				   },
				   {title: '发票号', field: 'TINVNO', width: 100},
				   {title: '登记号', field: 'TPatID', width: 100},
				   {title: '患者姓名', field: 'TPatName', width: 80},
				   {title: '票据金额', field: 'TAcount', align: 'right', width: 100},
				   {title: '作废', field: 'TAbort', width: 50,
					formatter: function (value, row, index) {
						return (+value == 1) ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
					}
				   },
				   {title: '红冲', field: 'TRefund', width: 50,
					formatter: function (value, row, index) {
						return (+value == 1) ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
					}
				   },
				   {title: '结算', field: 'THandin', width: 50,
					formatter: function (value, row, index) {
						return (+value == 1) ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
					}
				   },
				   {title: '收费员', field: 'TUser', width: 70},
				   {title: '收费时间', field: 'TTime', width: 150,
				    formatter: function (value, row, index) {
						return row.TDate + ' ' + value;
					}
				   },
				   {title: '费用总额', field: 'TotSum', align: 'right', width: 100},
				   {title: '支付方式', field: 'TPayMode', width: 180},
				   {title: '废票时间', field: 'TParkTime', width: 150,
				    formatter: function (value, row, index) {
						return row.TParkDate + ' ' + value;
					}
				   },
				   {title: '作废人员', field: 'TParUName', width: 80},
				   {title: '作废发票号', field: 'TInitInvNo', width: 100},
				   {title: '医保支付额', field: 'TYBSum', align: 'right', width: 95},
				   {title: '原发票号', field: 'OldInvNo', width: 100},
				   {title: '记账金额', field: 'TPayorShare', align: 'right', width: 80},
				   {title: '折扣金额', field: 'TDiscAmount', align: 'right', width: 80},
				   {title: '票据类型', field: 'TabFlag', width: 80}
			]],
		onLoadSuccess: function (data) {
			$(this).datagrid('clearChecked');
			var hasDisabledRow = false;
			$.each(data.rows, function (index, row) {
				if ((+row.TAbort == 1) || (+row.TRefund == 1)) {
					hasDisabledRow = true;
					$("#invList").parent().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = true; //退费票据不能被选中
				}
			});
			//有disabled行时,表头也disabled
			$("#invList").parent().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		onCheckAll: function (rows) {
			$.each(rows, function (index, row) {
				if ((+row.TAbort == 1) || (+row.TRefund == 1)) {
					GV.InvList.uncheckRow(index);
				}
			});
		}
	});
}

function clearClick() {
	$(":text:not(.pagination-num)").val("");
	$(".combobox-f:not(#cardType)").combobox("clear");
	$("#cardType").combobox("reload");
	$(".datetimebox-f").datetimebox("setValue", " ");   //先清空日期，防止后台加载数据
	loadInvList();
	
	var defDate = getDefStDate(0);
	$('#stDateTime').datetimebox('setValue', (defDate + ' ' + '00:00:00'));
	$('#endDateTime').datetimebox('setValue', (defDate + ' ' + '23:59:59'));
}

function loadInvList() {
	var stDateTime = $('#stDateTime').datetimebox('getValue');
	var stDate = stDateTime.split(' ')[0];
	var stTime = stDateTime.split(' ')[1];
	var endDateTime = $('#endDateTime').datetimebox('getValue');
	var endDate = endDateTime.split(' ')[0];
	var endTime = endDateTime.split(' ')[1];
	var queryParams = {
		ClassName: 'web.udhcOPQUERY',
		QueryName: 'INVQUERY11',
		ReceipNO: getValueById('invNo'),
		PatientNO: getValueById('patientNo'),
		PatientName: getValueById('patName'),
		StartDate: stDate,
		StTime: stTime,
		EndDate: endDate,
		EndTime: endTime,
		INVStatus: getValueById('invFlag') || '',
		userID: getValueById('guser') || '',
		INVFootFlag: getValueById('footFlag') || '',
		CardNo: getValueById('cardNo'),
		PayModeId: getValueById('paymode') || '',
		admReason: getValueById('admReason') || '',
		HospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore('invList', queryParams);
}

function orderDetail(prtRowId, invType) {
	var url = 'dhcbill.opbill.invoeitm.csp?&invRowId=' + prtRowId + '&invType=' + invType;
	websys_showModal({
		url: url,
		title: '医嘱明细',
		iconCls: 'icon-w-list'
	});
}

/**
 * 导出
 */
function exportClick() {
	var stDateTime = $('#stDateTime').datetimebox('getValue');
	var stDate = stDateTime.split(' ')[0];
	var stTime = stDateTime.split(' ')[1];
	var endDateTime = $('#endDateTime').datetimebox('getValue');
	var endDate = endDateTime.split(' ')[0];
	var endTime = endDateTime.split(' ')[1];
	var fileName = 'DHCBILL-OPBILL-SJMX.rpx' + '&ReceipNO=' + getValueById('invNo') + '&PatientNO=' + getValueById('patientNo');
	fileName += '&PatientName=' + getValueById('patName') + '&StartDate=' + stDate + '&StTime=' + stTime + '&EndDate=' + endDate + '&EndTime=' + endTime;
	fileName += '&INVStatus=' + (getValueById('invFlag') || '') + '&userID=' + (getValueById('guser') || '') + '&INVFootFlag=' + (getValueById('footFlag') || '');
	fileName += '&CardNo=' + getValueById('cardNo') + '&PayModeId=' + (getValueById('paymode') || '') + '&admReason=' + (getValueById('admReason') || '');
	fileName += '&HospId=' + PUBLIC_CONSTANT.SESSION.HOSPID;
	var maxHeight = ($(window).height() || 550) * 0.8;
	var maxWidth = ($(window).width() || 1366) * 0.8;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}

/**
 * 打印
 */
function printClick() {
	var invAry = [];
	$.each(GV.InvList.getChecked(), function (index, row) {
		var prtRowId = row.TINVRowid;
		var sFlag = row.TabFlag;
		var tmpStr = prtRowId + ':' + sFlag;
		invAry.push(tmpStr);
	});
	if (invAry.length == 0) {
		$.messager.alert('提示', '请选择需要打印的记录', 'info');
		return;
	}
	var invStr = invAry.join("!");
	$.m({
		ClassName: 'web.DHCBillDtlListPrtLog',
		MethodName: 'SavePrtLog',
		userId: PUBLIC_CONSTANT.SESSION.USERID,
		invStr: invStr
	}, function (rtn) {
		if (rtn != '0') {
			$.messager.alert('提示', '保存日志失败', 'info');
			return;
		}
		fileName = "{DHCBILL-OPBILL-FYQD.rpx(invStr=" + invStr + ")}";
		DHCCPM_RQDirectPrint(fileName);
	});
}