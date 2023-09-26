/**
 * FileName: dhcbill.ipbill.patordfee.js
 * Anchor: ZhYW
 * Date: 2018-06-21
 * Description: 医嘱费用查询
 */

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initOrdItmList();
	initOEItmList();
	initTarItmList();
	//将链接过来的就诊号赋给episodeId
	var episodeId = getParam('EpisodeID');
	$.m({
		ClassName: 'web.DHCIPBillPatOrdFee',
		MethodName: 'GetAdmType',
		episodeId: episodeId
	}, function (rtn) {
		if (rtn == 'I') {
			$('#episodeId').combogrid('setValue', episodeId);
			getPatInfoByAdm(episodeId);  //dhcbill.inpatient.banner.csp
			setTimeout('loadOrdItmList()', 50);
		} else {
			$.messager.alert('提示', '非住院患者', 'info');
		}
	});
});

function initQueryMenu() {
	$HUI.linkbutton('#btn-readCard', {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			findClick();
		}
	});

	$HUI.linkbutton('#btn-bill', {
		onClick: function () {
			billClick();
		}
	});

	$HUI.linkbutton('#btn-execFind', {
		onClick: function () {
			loadOEItmList();
		}
	});

	$HUI.linkbutton('#btn-depDtl', {
		onClick: function () {
			depDtlClick();
		}
	});

	$HUI.linkbutton('#btn-feeDtl', {
		onClick: function () {
			feeDtlClick();
		}
	});

	$HUI.linkbutton('#btn-checkfee', {
		onClick: function () {
			checkFeeClick();
		}
	});

	$HUI.linkbutton('#btn-preInsuCharge', {
		onClick: function () {
			preInsuChargeClick();
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

	//病案号回车查询事件
	$('#medicareNo').keydown(function (e) {
		medicareNoKeydown(e);
	});

	$('#more-container').click(function () {
		var t = $(this);
		if (t.find('.arrows-b-text').text() == '更多') {
			t.find('.arrows-b-text').text('收起');
			t.find('.spread-b-down').removeClass('spread-b-down').addClass('retract-b-up');
			$('tr.display-more-tr').slideDown('normal', setHeight(80));
		} else {
			t.find('.arrows-b-text').text('更多');
			t.find('.retract-b-up').removeClass('retract-b-up').addClass('spread-b-down');
			$('tr.display-more-tr').slideUp('fast', setHeight(-80));
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

	$HUI.combogrid('#episodeId', {
		panelWidth: 400,
		panelHeight: 200,
		fitColumns: true,
		editable: false,
		url: $URL + '?ClassName=web.DHCIPBillPatOrdFee&QueryName=FindAdm',
		delay: 300,
		idField: 'adm',
		textField: 'adm',
		mode: 'remote',
		lazy: true,
		columns: [[{field: 'adm', title: '就诊号', width: 60},
				   {field: 'admDatTime', title: '入院时间', width: 150},
				   {field: 'admDept', title: '就诊科室', width: 120}
			]],
		onBeforeLoad: function (param) {
			param.patientNo = getValueById('patientNo');
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});

	//医嘱大类
	$HUI.combobox('#ordCate', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillPatOrdFee&QueryName=FindOrdCate&ResultSetType=array&hospId=' + PUBLIC_CONSTANT.SESSION.HOSPID,
		valueField: 'id',
		textField: 'cate',
		defaultFilter: 4
	});

	//医嘱项
	$HUI.combobox('#arcItm', {
		panelHeight: 150,
		url: $URL + '?ClassName=DHCDoc.DHCDocConfig.ArcItemConfig&QueryName=FindAllItem&ResultSetType=array',
		mode: 'remote',
		method: 'get',
		delay: 500,
		valueField: 'ArcimRowID',
		textField: 'ArcimDesc',
		onBeforeLoad: function (param) {
			param.Alias = param.q;
			param.HospId = PUBLIC_CONSTANT.SESSION.HOSPID
		}
	});

	//开单科室, 医嘱接收科室
	$HUI.combobox('#userDept, #ordRecDept', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCIPBillPatOrdFee&QueryName=FindDept&ResultSetType=array',
		mode: 'remote',
		valueField: 'id',
		textField: 'dept',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});

	$HUI.combobox('#billStatus', {
		panelHeight: 'auto',
		editable: false,
		valueField: 'value',
		textField: 'text',
		data: [{value: '', text: '全部'},
		       {value: '0', text: '未结算'},
		       {value: '1', text: '已结算'},
		       {value: '2', text: '未计费医嘱'}
		]
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
			getPatInfo();
			break;
		case '-200':
			$.messager.alert('提示', '卡无效', 'info', function () {
				$('#btn-readCard').focus();
			});
			break;
		case '-201':
			setValueById('cardNo', myAry[1]);
			setValueById('patientNo', myAry[5]);
			getPatInfo();
			break;
		default:
		}
	} catch (e) {
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById('medicareNo', '');
		getPatInfo();
	}
}

function medicareNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		setValueById('patientNo', '');
		getPatInfo();
	}
}

function getPatInfo() {
	$.m({
		ClassName: 'web.DHCIPBillPatOrdFee',
		MethodName: 'GetPatCurrAdm',
		patientNo: getValueById('patientNo'),
		medicareNo: getValueById('medicareNo'),
		sessionStr: getSessionStr()
	}, function (episodeId) {
		$('#episodeId').combogrid('setValue', episodeId);
		getPatInfoByAdm(episodeId);   //dhcbill.inpatient.banner.csp
		findClick();
	});
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
				getPatInfo();
				break;
			case '-200':
				setTimeout(function () {
					$.messager.alert('提示', '卡无效', 'info', function () {
						$('#cardNo').focus();
					});
				}, 300);
				break;
			case '-201':
				setValueById('cardNo', myAry[1]);
				setValueById('patientNo', myAry[5]);
				getPatInfo();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

function initOrdItmList() {
	$HUI.datagrid('#ordItmList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: [],
		data: [],
		frozenColumns: [[{title: '医嘱名称', field: 'arcimDesc', width: 150,
							styler: function (value, row, index) {
								if (row.notBillNum > 0) {
									return 'font-weight: bold;color:#FF0000';
								}
							}
						 }
			]],
		columns: [[{title: '医嘱序号', field: 'seqNo', width: 70},
		           {title: '医嘱日期', field: 'datTime', width: 150},
		           {title: '开单医生', field: 'docName', width: 80},
		           {title: '医嘱状态', field: 'status', width: 80},
		           {title: '数量', field: 'billQty', width: 80},
		           {title: '小计', field: 'itmTotalAmt', align: 'right', width: 100},
		           {title: '药房打包', field: 'phQty', width: 80},
		           {title: '未发药数量', field: 'drugTCQty', width: 80},
		           {title: '退药数量', field: 'phReturnQty', width: 80},
		           {title: '医嘱优先级', field: 'priorty', width: 80},
		           {title: '医嘱大类', field: 'itmCatDesc', width: 80},
		           {title: '处方号', field: 'prescno', width: 120},
		           {title: '接收科室', field: 'recDeptName', width: 120},
		           {title: '开单科室', field: 'userDeptName', width: 120},
		           {title: '发药状态', field: 'dspStatus', width: 80},
		           {title: '未计费执行记录数量', field: 'notBillNum', width: 140},
		           {title: '频次', field: 'phFreq', width: 50},
		           {title: '自付费用', field: 'patShareAmt', align: 'right', width: 80},
		           {title: '记账费用', field: 'payOrShareAmt', align: 'right', width: 80},
		           {title: '折扣费用', field: 'discAmt', align: 'right', width: 80},
		           {title: '计费点', field: 'billCondition', width: 60},
		      	   {title: '医嘱ID', field: 'ordItm', width: 80},
		           {title: '费用来源', field: 'feeSource', width: 70}
			]],
		onSelect: function (rowIndex, rowData) {
			//清空收费项
			$('#tarItmList').datagrid('loadData', {
				total: 0,
				rows: []
			});
			loadOEItmList();
		},
		rowStyler: function (index, row) {
			if (row.arcimDesc.indexOf("合计") != -1) {
				return 'font-weight: bold';
			}
		}
	});
}

function initOEItmList() {
	$HUI.datagrid('#oeItmList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper-tri',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		fitColumns: false,
		pagination: true,
		rownumbers: true,
		pageSize: 10,
		pageList: [10, 15, 20],
		toolbar: '#oeItmToolBar',
		data: [],
		columns: [[{title: '账单状态', field: 'billFlag', width: 70,
					styler: function (value, row, index) {
						if ((row.billFlag == '未计费') || ((row.billFlag == '已计费') && (+row.billTotalAmt == 0))) {
							return 'font-weight: bold;color:#FF0000';
						}
					}
				   },
				   {title: '执行状态', field: 'execStatus', width: 70},
				   {title: '金额', field: 'billTotalAmt', align: 'right', width: 80},
				   {title: '发药数量', field: 'phQty', width: 70},
				   {title: '退药数量', field: 'phReturnQty', width: 70},
				   {title: '要求执行时间', field: 'execStDatTime', width: 150},
				   {title: '执行时间', field: 'execDatTime', width: 150},
				   {title: '执行人', field: 'execUserName', width: 80},
				   {title: '账单医嘱ID', field: 'pboRowId', width: 100},
				   {title: '执行记录ID', field: 'oeore', width: 100}
			]],
		onSelect: function (rowIndex, rowData) {
			loadTarItmList();
		}
	});
}

function initTarItmList() {
	$HUI.datagrid('#tarItmList', {
		fit: true,
		striped: true,
		iconCls: 'icon-fee',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		fitColumns: false,
		rownumbers: true,
		pageSize: 999999999,
		toolbar: [],
		data: [],
		columns: [[{title: '收费项名称', field: 'tarItmDesc', width: 150},
				   {title: '单位', field: 'uomDesc', width: 50},
				   {title: '单价', field: 'price', align: 'right', width: 70},
				   {title: '数量', field: 'qty', width: 70},
				   {title: '金额', field: 'totalAmt', align: 'right', width: 70},
				   {title: '自付金额', field: 'patShareAmt', align: 'right', width: 70},
				   {title: '折扣金额', field: 'discAmt', align: 'right', width: 70},
				   {title: '记账金额', field: 'payorShareAmt', align: 'right', width: 70},
				   {title: '计费日期', field: 'billDate', width: 150}
			]]
	});
}

/**
 * 查询按钮点击事件
 * @method findClick
 * @author ZhYW
 */
function findClick() {
	//清空执行记录
	$('#oeItmList').datagrid('loadData', {
		total: 0,
		rows: []
	});
	//清空收费项
	$('#tarItmList').datagrid('loadData', {
		total: 0,
		rows: []
	});
	loadOrdItmList();
}

/**
 * 重新加载明细grid
 * @method loadOrdItmList
 * @author ZhYW
 */
function loadOrdItmList() {
	var queryParams = {
		ClassName: 'web.DHCIPBillPatOrdFee',
		QueryName: 'FindOrdDetail',
		episodeId: $('#episodeId').combogrid('getValue'),
		itmCateId: getValueById('ordCate') || '',
		arcimId: getValueById('arcItm') || '',
		recDeptId: getValueById('ordRecDept') || '',
		userDeptId: getValueById('userDept') || '',
		stDate: getValueById('stDate'),
		endDate: getValueById('endDate'),
		billStatus: getValueById('billStatus') || '',
		sessionStr: getSessionStr()
	};
	loadDataGridStore('ordItmList', queryParams);
}

/**
 * 加载执行记录grid
 * @method loadOEItmList
 * @author ZhYW
 */
function loadOEItmList() {
	var ordItm = '';
	var rowData = $('#ordItmList').datagrid('getSelected');
	if ((rowData) && (rowData.ordItm)) {
		ordItm = rowData.ordItm;
	}
	var queryParams = {
		ClassName: 'web.DHCIPBillPatOrdFee',
		QueryName: 'FindOrdExecInfo',
		ordItm: ordItm,
		stDate: getValueById('execStDate'),
		endDate: getValueById('execEndDate')
	};
	loadDataGridStore('oeItmList', queryParams);
}

/**
 * 加载收费项明细grid
 * @method loadTarItmList
 * @author ZhYW
 */
function loadTarItmList() {
	var pboRowId = '';
	var rowData = $('#oeItmList').datagrid('getSelected');
	if ((rowData) && (rowData.pboRowId)) {
		pboRowId = rowData.pboRowId;
	}
	var queryParams = {
		ClassName: 'web.DHCIPBillPatOrdFee',
		QueryName: 'FindTarInfo',
		pboRowId: pboRowId,
		rows: 99999999
	};
	loadDataGridStore('tarItmList', queryParams);
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

/**
 * 重置layout高度
 * @method setHeight
 * @param {int} num
 * @author ZhYW
 */
function setHeight(num) {
	var l = $('#head-menu');
	var n = l.layout('panel', 'north');
	var nh = parseInt(n.outerHeight()) + parseInt(num);
	n.panel('resize', {
		height: nh
	});
	if (+num > 0) {
		$('tr.display-more-tr').show();
	} else {
		$('tr.display-more-tr').hide();
	}
	var c = l.layout('panel', 'center');
	var ch = parseInt(c.panel('panel').outerHeight()) - parseInt(num);
	c.panel('resize', {
		height: ch,
		top: nh
	});
}

/**
 * 账单
 * @method billClick
 * @author ZhYW
 */
function billClick() {
	var episodeId = $('#episodeId').combogrid('getValue');
	if (!episodeId) {
		$.messager.alert('提示', '就诊号为空', 'info');
		return;
	}
	$.m({
		ClassName: 'web.DHCIPBillPatOrdFee',
		MethodName: 'GetBilledByAdm',
		episodeId: episodeId
	}, function (billed) {
		if (billed == 'Y') {
			$.messager.alert('提示', '已做财务结算,不能账单', 'info');
			return;
		}
		$.m({
			ClassName: 'web.DHCIPBillPatOrdFee',
			MethodName: 'GetMotherAdmByBabyAdm',
			episodeId: episodeId
		}, function (rtn) {
			var myAry = rtn.split('^');
			var babyFlag = myAry[0];
			if (babyFlag == 'true') {
				$.messager.alert('提示', '此患者为婴儿不允许做账单', 'info');
				return;
			}
			//同步调用账单
			$.m({
				ClassName: 'web.UDHCJFBILL',
				MethodName: 'BILLN',
				adm: episodeId,
				billuser: PUBLIC_CONSTANT.SESSION.USERID,
				ordstr: '',
				flag: 0
			}, function (rtn) {
				switch (rtn) {
				case '0':
					$.messager.alert('提示', '账单成功', 'success', function () {
						findClick();
					});
					break;
				case '2':
					$.messager.alert('提示', '同时存在两个未付账单，不允许做账单', 'info');
					break;
				case 'AdmNull':
					$.messager.alert('提示', '就诊号为空', 'info');
					break;
				case 'PBNull':
					$.messager.alert('提示', '账单号为空，账单失败', 'info');
					break;
				case 'OrdNull':
					$.messager.alert('提示', '该患者没有医嘱，不能账单', 'info');
					break;
				default:
					$.messager.alert('提示', '账单失败：' + rtn, 'error');
				}
			});
		});
	});
}

/**
 * 押金明细dialog
 * @method depDtlClick
 * @author ZhYW
 */
function depDtlClick() {
	var episodeId = $('#episodeId').combogrid('getValue');
	if (!episodeId) {
		$.messager.alert('提示', '就诊号为空', 'info');
		return;
	}
	var depositTypeId = $.m({ClassName: 'web.DHCIPBillDeposit', MethodName: 'GetIPDepositTypeId'}, false);
	var url = 'dhcbill.ipbill.depositlist.csp?&EpisodeID=' + episodeId + '&DepositType=' + depositTypeId;
	websys_showModal({
		url: url,
		title: '押金明细',
		iconCls: 'icon-w-list'
	});
}

/**
 * 费用明细查询
 * @method feeDtlClick
 * @author ZhYW
 */
function feeDtlClick() {
	var episodeId = $('#episodeId').combogrid('getValue');
	if (!episodeId) {
		$.messager.alert('提示', '就诊号为空', 'info');
		return;
	}
	$.m({
		ClassName: 'web.DHCIPBillPatOrdFee',
		MethodName: 'GetValidPBInfo',
		episodeId: episodeId
	}, function (rtn) {
		var myAry = rtn.split('^');
		var num = myAry[0];
		var bill = myAry[1];
		var url = '';
		switch (num) {
		case '1':
			if (!bill) {
				$.messager.alert('提示', '账单号为空', 'info');
				break;
			}
			url = 'dhcbill.ipbill.billdtl.csp?&EpisodeID=' + episodeId + '&BillRowId=' + bill;
			websys_showModal({
				url: url,
				title: '费用明细',
				iconCls: 'icon-w-list',
				width: '85%'
			});
			break;
		default:
			url = 'dhcbill.ipbill.billselect.csp?&EpisodeID=' + episodeId;
			websys_showModal({
				url: url,
				title: '账单列表',
				iconCls: 'icon-w-list',
				height: 400,
				width: 800
			});
		}
	});
}

/**
 * 医嘱费用核对
 * @method checkFeeClick
 * @author ZhYW
 */
function checkFeeClick() {
	var episodeId = $('#episodeId').combogrid('getValue');
	if (!episodeId) {
		$.messager.alert('提示', '就诊号为空', 'info');
		return;
	}
	$.m({
		ClassName: 'web.DHCIPBillPatOrdFee',
		MethodName: 'GetValidPBInfo',
		episodeId: episodeId
	}, function (rtn) {
		var myAry = rtn.split('^');
		var num = myAry[0];
		var bill = myAry[1];
		var url = '';
		switch (num) {
		case '1':
			if (!bill) {
				$.messager.alert('提示', '账单号为空', 'info');
				break;
			}
			url = 'dhcbill.ipbill.billorder.csp?EpisodeID=' + episodeId + '&BillRowId=' + bill;
			websys_showModal({
				url: url,
				title: '费用核对',
				iconCls: 'icon-w-stamp',
				width: '90%'
			});
			break;
		default:
			url = 'dhcbill.ipbill.billselect.csp?&EpisodeID=' + episodeId;
			websys_showModal({
				url: url,
				title: '账单列表',
				iconCls: 'icon-w-list',
				height: 400,
				width: 800
			});
		}
	});
}

/**
 * 医保预结算
 * @method preInsuChargeClick
 * @author ZhYW
 */
function preInsuChargeClick() {
	var episodeId = $('#episodeId').combogrid('getValue');
	if (!episodeId) {
		$.messager.alert('提示', '就诊号为空', 'info');
		return;
	}
	$.m({
		ClassName: 'web.DHCIPBillPatOrdFee',
		MethodName: 'GetUnPayedPBInfo',
		episodeId: episodeId
	}, function (rtn) {
		var myAry = rtn.split('^');
		var num = myAry[0];
		var bill = myAry[1];
		switch (num) {
		case '0':
			$.messager.alert('提示', '没有未结算的账单，不能预结算', 'info');
			break;
		case '1':
			if (!bill) {
				$.messager.alert('提示', '账单号为空', 'info');
				break;
			}
			$.m({
				ClassName: 'web.UDHCJFPAY',
				MethodName: 'GetBillReaNationCode',
				BillNo: bill
			}, function (admReasonStr) {
				var myAry = admReasonStr.split('^');
				var admReasonDR = myAry[0];
				var nationalCode = myAry[1];
				if (+nationalCode > 0) {
					var rtn = InsuIPDividePre('0', PUBLIC_CONSTANT.SESSION.USERID, bill, nationalCode, admReasonDR, '');
				} else {
					$.messager.alert('提示', '非医保患者，不能医保预结算', 'info');
				}
			});
			break;
		default:
			$.messager.alert('提示', '患者有多个未结算的账单，不允许医保预结算', 'info');
		}
	});
}