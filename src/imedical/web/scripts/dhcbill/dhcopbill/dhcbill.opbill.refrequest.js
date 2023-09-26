/**
 * FileName: dhcbill.opbill.refrequest.js
 * Anchor: ZhYW
 * Date: 2018-10-10
 * Description: 门诊退费申请
 */

var GV = {
	EditIndex: undefined,
	SelRowIndex: undefined,
	AlreadyReqSum: 0,
	RowsAry: []
};

/*
 * 验证正整数
 */
$.extend($.fn.validatebox.defaults.rules, {
	integer: {
		validator: function (value, param) {
			var bool = true;
			var curRow = $(this).parents('.datagrid-row').attr('datagrid-row-index') || '';
			if (curRow != '') {
				var reg = /^[1-9]\d*$/;
				if (!reg.test(value)) {
					bool = false;
				} else {
					var rowData = $('#ordItmList').datagrid('getRows')[curRow];
					var canRetQty = rowData.canRetQty;
					if (+value > +canRetQty) {
						bool = false;
					}
				}
				setOrdItmRowChecked(curRow, bool);
				calcRefAmt();
			}
			return bool;
		},
		message: $g('须为小于等于可退数量的正整数')
	}
});

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initInvList();
	initOrdItmList();
});

function initQueryMenu() {
	var defDate = getDefStDate(0);
	$('#stDate, #endDate').datebox('setValue', defDate);

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
		invNoKeydown(e);
	});

	$HUI.linkbutton('#btn-request', {
		onClick: function () {
			requestClick();
		}
	});

	$HUI.linkbutton('#btn-cancel', {
		onClick: function () {
			cancelClick();
		}
	});
	
	$HUI.linkbutton('#btn-print', {
		onClick: function () {
			printClick();
		}
	});

	$('#more-container').click(function () {
		var t = $(this);
		if (t.find('.arrows-b-text').text() == $g('更多')) {
			t.find('.arrows-b-text').text($g('收起'));
			t.find('.spread-b-down').removeClass('spread-b-down').addClass('retract-b-up');
			$('tr.display-more-tr').slideDown('normal', setHeight(40));
		} else {
			t.find('.arrows-b-text').text($g('更多'));
			t.find('.retract-b-up').removeClass('retract-b-up').addClass('spread-b-down');
			$('tr.display-more-tr').slideUp('fast', setHeight(-40));
		}
	});

	//卡类型
	$HUI.combobox('#cardType', {
		panelHeight: 'auto',
		url: $URL + '?ClassName=web.DHCBillOtherLB&QueryName=QCardTypeDefineList&ResultSetType=array',
		editable: false,
		valueField: 'value',
		textField: 'caption',
		onLoadSuccess: function () {
			var cardType = $(this).combobox('getValue');
			initReadCard(cardType);
		},
		onSelect: function (record) {
			var cardType = record.value;
			initReadCard(cardType);
		}
	});
	
	//退费原因
	$HUI.combobox('#refReason', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCOPBillRefundRequest&QueryName=ReadRefReason&ResultSetType=array',
		editable: false,
		valueField: 'id',
		textField: 'text',
		defaultFilter: 4,
		blurValidValue: true,
		onBeforeLoad: function(param) {
			param.expStr = PUBLIC_CONSTANT.SESSION.HOSPID + "^" + PUBLIC_CONSTANT.SESSION.LANGID;
		},
		onLoadSuccess: function(data) {
			if (data.length > 0) {
				setValueById('refReason', data[0].id);
			}
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
			$('#cardNo').val(myAry[1]);
			$('#patientNo').val(myAry[5]);
			loadInvList();
			break;
		case '-200':
			$.messager.alert('提示', '卡无效', 'info', function () {
				$('#btn-readCard').focus();
			});
			break;
		case '-201':
			$('#cardNo').val(myAry[1]);
			$('#patientNo').val(myAry[5]);
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
			var cardNo = $('#cardNo').val();
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
				$('#cardNo').val(myAry[1]);
				$('#patientNo').val(myAry[5]);
				loadInvList();
				break;
			case '-200':
				setTimeout(function () {
					$.messager.alert('提示', '卡无效', 'info', function () {
						$('#cardNo').focus();
					});
				}, 300);
				break;
			case '-201':
				$('#cardNo').val(myAry[1]);
				$('#patientNo').val(myAry[5]);
				loadInvList();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

function invNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		$.m({
			ClassName: 'web.DHCOPBillRefundRequest',
			MethodName: 'CheckIsStayInv',
			invNo: $(e.target).val()
		}, function (rtn) {
			if (rtn == 'Y') {
				$.messager.alert('提示', '该发票为急诊留观发票,若需退费请停止医嘱', 'info');
				return;
			} else {
				loadInvList();
			}
		});
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
			$('#btn-readCard').linkbutton('disable');
			$('#cardNo').attr('readOnly', false);
		} else {
			$('#btn-readCard').linkbutton('enable');
			$('#cardNo').val('');
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

function initInvList() {
	$HUI.datagrid('#invList', {
		fit: true,
		border: false,
		striped: true,
		selectOnCheck: true,
		checkOnSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
				   {title: '发票号', field: 'TINVNO', width: 100},
				   {title: '登记号', field: 'TPatID', width: 100},
				   {title: '患者姓名', field: 'TPatName', width: 80},
				   {title: '费用总额', field: 'TotSum', align: 'right', width: 80},
				   {title: '自付金额', field: 'TAcount', align: 'right', width: 80},
				   {title: '收费员', field: 'TUser', width: 70},
				   {title: '收费时间', field: 'TDate', width: 155,
					formatter: function (value, row, index) {
						if (value) {
							return value + ' ' + row.TTime;
						}
					}
				   },
				   {title: 'TINVRowid', field: 'TINVRowid', hidden: true},
				   {title: 'TabFlag', field: 'TabFlag', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$(this).datagrid('clearChecked');
		},
		onCheck: function (rowIndex, rowData) {
			initReqPanel();
		},
		onUncheck: function (rowIndex, rowData) {
			initReqPanel();
		},
		onCheckAll: function (rows) {
			initReqPanel();
		},
		onUncheckAll: function (rows) {
			initReqPanel();
		}
	});
}

function loadInvList() {
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + '^' + PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
	var queryParams = {
		ClassName: 'web.DHCOPBillRefundRequest',
		QueryName: 'FindInvInfo',
		StDate: getValueById('stDate'),
		EndDate: getValueById('endDate'),
		ReceiptNO: getValueById('invNo'),
		PatientNO: getValueById('patientNo'),
		PatientName: getValueById('patName'),
		ChargeUser: getValueById('userName'),
		ExpStr: expStr
	}
	loadDataGridStore('invList', queryParams);
}

function initOrdItmList() {
	$HUI.datagrid('#ordItmList', {
		fit: true,
		striped: true,
		iconCls: 'icon-paper',
		headerCls: 'panel-header-gray',
		singleSelect: true,
		checkOnSelect: false,
		selectOnCheck: false,
		pageSize: 999999999,
		toolbar: [],
		data: [],
		columns: [[{title: 'ck', field: 'ck', checkbox: true},
		           {title: '医嘱', field: 'arcimDesc', width: 180},
		           {title: '申请部位', field: 'repPartTar', width: 80, align: 'center',
					formatter: function (value, row, index) {
						//检查申请单全部执行时不能退
						if ((row.isAppRep == 'Y') && (row.select == 1)) {
							return "<a href='javascript:;' class='editCls' onclick=\"openPartWinOnClick(\'" + row.oeori + "', '" + index + "\')\">部位</a>";
						}
					}
				   },
				   {title: '金额', field: 'billAmt', align: 'right', width: 60},
				   {title: '数量/单位', field: 'billQty', width: 85,
					formatter: function (value, row, index) {
						return value + '/' + row.packUom;
					}
				   },
				   {title: '可退数量', field: 'canRetQty', width: 80},
				   {title: '申请数量', field: 'reqQty', width: 80,
					editor: {
						type: 'numberbox',
						options: {
							validType: 'integer'
						}
					}
				   },
				   {title: '已申请数量', field: 'alreadyReqQty', width: 95},
				   {title: '处方号', field: 'prescNo', width: 130},
				   {title: '接收科室', field: 'recDept', width: 120},
				   {title: '执行情况', field: 'execInfo', width: 160},
				   {title: '不可退药原因', field: 'cantRetReason', width: 105},
				   {title: '医嘱ID', field: 'oeori', width: 80},
				   {title: 'select', field: 'select', hidden: true},
				   {title: 'isExecute', field: 'isExecute', hidden: true},
				   {title: 'price', field: 'price', hidden: true},
				   {title: 'confac', field: 'confac', hidden: true},
				   {title: 'prtId', field: 'prtId', hidden: true},
				   {title: 'pboId', field: 'pboId', hidden: true},
				   {title: 'dspbId', field: 'dspbId', hidden: true},
				   {title: 'phdicId', field: 'phdicId', hidden: true},
				   {title: 'arcim', field: 'arcim', hidden: true},
				   {title: 'ordCateType', field: 'ordCateType', hidden: true},
				   {title: 'refRepPart', field: 'refRepPart', hidden: true},
				   {title: 'repPartAmt', field: 'repPartAmt', hidden: true}, 
				   {title: 'isEdit', field: 'isEdit', hidden: true},
				   {title: 'isAppRep', field: 'isAppRep', hidden: true},
				   {title: 'isCNMedItem', field: 'isCNMedItem', hidden: true},
				   {title: 'isOweDrug', field: 'isOweDrug', hidden: true}
			]],
		onLoadSuccess: function (data) {
			$('.editCls').linkbutton({text: $g('部位')});
			$(this).datagrid('clearChecked');
			GV.EditIndex = undefined;
			var hasDisabledRow = false;
			var CNMedPrescObj = {};
			$.each(data.rows, function (index, row) {
				if (+row.select != 1) {
					hasDisabledRow = true;
					$("#ordItmList").parent().find(".datagrid-row[datagrid-row-index=" + index + "] input:checkbox")[0].disabled = true;
				}
				//控制草药一条医嘱disable时，整个处方医嘱都disable，后台循环输出麻烦，先在前台控制
				if (row.isCNMedItem == 1) {
					if (typeof CNMedPrescObj["" + row.prescNo + ""] == 'undefined') {
						CNMedPrescObj["" + row.prescNo + ""] = index;
					}else {
						CNMedPrescObj["" + row.prescNo + ""] = CNMedPrescObj["" + row.prescNo + ""] + "^" + index;
					}
					if (+row.select != 1) {
						CNMedPrescObj[row.prescNo + "CNMEDPRESC"] = true;   //草药处方能否退费申请?
					}
				}
			});
			
			//控制草药处方disable
			$.each(CNMedPrescObj, function (key, value) {
				if (CNMedPrescObj[key + "CNMEDPRESC"]) {
					var myAry = value.split("^");
					$.each(myAry, function (idx, rowIdx) {
						HISUIDataGrid.setFieldValue('select', 0, rowIdx, 'ordItmList');
						$("#ordItmList").parent().find(".datagrid-row[datagrid-row-index=" + rowIdx + "] input:checkbox")[0].disabled = true;
					});
				}
			});
			
			//有disabled行时,表头也disabled
			$("#ordItmList").parent().find(".datagrid-header-row input:checkbox")[0].disabled = hasDisabledRow;
		},
		onClickRow: function (index, row) {
			if ((GV.EditIndex != index) && (canEdit(row))) {
				if (endEditing()) {
					$(this).datagrid('selectRow', index).datagrid('beginEdit', index);
					GV.EditIndex = index;
					reqQtyFocus(index);
				} else {
					$(this).datagrid('selectRow', GV.EditIndex);
				}
			}
		},
		onCheck: function (index, row) {
			setRowsAry(row, true);
			if (GV.SelRowIndex !== undefined) {
				return;
			}
			if (canEdit(row)) {
				reqQtyFocus(index);
				HISUIDataGrid.setFieldValue('reqQty', row.canRetQty, index, 'ordItmList');
			}
			if (!canCheck(row)) {
				$(this).datagrid('uncheckRow', index);
			} else {
				controlCNMedItm(index, row);
				calcRefAmt();
			}
		},
		onUncheck: function (index, row) {
			setRowsAry(row, false);
			if (GV.SelRowIndex !== undefined) {
				return;
			}
			if (!canCheck(row)) {
				return;
			}
			if (canEdit(row)) {
				HISUIDataGrid.setFieldValue('reqQty', '', index, 'ordItmList');
			}
			controlCNMedItm(index, row);
			calcRefAmt();
		},
		onCheckAll: function (rows) {
			var objGrid = $HUI.datagrid('#ordItmList');
			$.each(rows, function (index, row) {
				if (!canCheck(row)) {
					objGrid.uncheckRow(index);
				}
				if (canEdit(row)) {
					HISUIDataGrid.setFieldValue('reqQty', row.canRetQty, index, 'ordItmList');
				}
			});
			GV.RowsAry = objGrid.getChecked();
			calcRefAmt();
		},
		onUncheckAll: function (rows) {
			GV.RowsAry = [];
			$.each(rows, function (index, row) {
				if (canEdit(row)) {
					HISUIDataGrid.setFieldValue('reqQty', '', index, 'ordItmList');
				}
			});
			calcRefAmt();
		}
	});
}

function endEditing() {
	if (GV.EditIndex == undefined) {
		return true;
	}
	if ($('#ordItmList').datagrid('validateRow', GV.EditIndex)) {
		$('#ordItmList').datagrid('endEdit', GV.EditIndex);
		GV.EditIndex = undefined;
		return true;
	} else {
		return false;
	}
}

/**
 * 判断行能否被勾选
 */
function canCheck(row) {
	var select = row.select;
	if (+select != 1) {
		return false;
	}
	var isAppRep = row.isAppRep;
	var refRepPart = row.refRepPart;
	if ((isAppRep == 'Y') && (refRepPart == '')) {
		return false;
	}
	return true;
}

/**
 * 判断行能否被编辑
 */
function canEdit(row) {
	var select = row.select;
	if (+select != 1) {
		return false;
	}
	var isEdit = row.isEdit;
	if (+isEdit != 1) {
		return false;
	}
	return true;
}

/**
 * 申请退费数量编辑框获取焦点
 */
function reqQtyFocus(index) {
	var objGrid = $HUI.datagrid('#ordItmList');
	var ed = objGrid.getEditor({
			index: index,
			field: 'reqQty'
		});
	if (ed) {
		$(ed.target).focus();
		$(ed.target).select();
		$(ed.target).bind('keyup', function (e) {
			var key = websys_getKey(e);
			if (key == 8) {
				if ($(ed.target).val() == '') {
					objGrid.uncheckRow(index);
				}
			}
		});
	}
}

/**
 * 计算退费金额
 */
function calcRefAmt() {
	var refSum = GV.AlreadyReqSum;
	var objGrid = $HUI.datagrid('#ordItmList');
	$.each(GV.RowsAry, function (idx, row) {
		var index = objGrid.getRowIndex(row);
		var ed = objGrid.getEditor({
			index: index,
			field: 'reqQty'
		});
		var reqQty = (ed) ? $(ed.target).val() : row.reqQty;
		reqQty = reqQty * row.confac;
		var reqAmt = (row.isAppRep == 'Y') ? (row.repPartAmt || 0) : round(reqQty * row.price);
		refSum = parseFloat(refSum) + parseFloat(reqAmt);
	});
	refSum = parseFloat(refSum).toFixed(2);
	setValueById('refAmt', refSum);
}

function initReqPanel() {
	getAlreadyReqAmt();
	loadOrdItmList();
}

function loadOrdItmList() {
	var invStr = getCheckedInvStr();
	var expStr = PUBLIC_CONSTANT.SESSION.USERID + '^' + PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID + '^' + PUBLIC_CONSTANT.SESSION.LANGID;
	var queryParams = {
		ClassName: 'web.DHCOPBillRefundRequest',
		QueryName: 'FindOrdItm',
		invStr: invStr,
		expStr: expStr,
		rows: 999999999
	}
	loadDataGridStore('ordItmList', queryParams);
}

/**
* 新版检查申请单获取部位
*/
function openPartWinOnClick(oeori, index) {
	var url = 'dhcapp.repparttarwin.csp?oeori=' + oeori;
	websys_showModal({
		url: url,
		title: '部位列表',
		width: 640,
		height: 400,
		callBackFunc: function(rtn) {
			var repReqItmIdAry = [];
			$.each(rtn.split('!!'), function(idx, item) {
				var id = item.split('^')[0];
				repReqItmIdAry.push(id);
			});
			arReqItmIdStr = repReqItmIdAry.join('!!');

			HISUIDataGrid.setFieldValue('refRepPart', arReqItmIdStr, index, 'ordItmList');
			
			if (arReqItmIdStr != '') {
				setOrdItmRowChecked(index, true);
			} else {
				setOrdItmRowChecked(index, false);
			}

			//计算按部位退费金额
			$.m({
				ClassName: 'web.DHCOPBillRefund',
				MethodName: 'GetRepPartRefAmt',
				oeitm: oeori,
				pbo: $('#ordItmList').datagrid('getRows')[index].pboId,
				arReqItmIdStr: arReqItmIdStr
			}, function (repPartAmt) {
				HISUIDataGrid.setFieldValue('repPartAmt', repPartAmt, index, 'ordItmList');
				calcRefAmt();
			});
		}
	});
}

/**
 * 申请
 */
function requestClick() {
	if (!endEditing()) {
		return;
	}
	GV.EditIndex = undefined;
	$('#ordItmList').datagrid('acceptChanges');
	if (GV.RowsAry == '') {
		return;
	}
	var reqDrugAry = [];
	var reqOtherAry = [];
	$.each(GV.RowsAry, function (index, row) {
		var prtId = row.prtId;
		var pboId = row.pboId;
		var oeori = row.oeori;
		var reqQty = (row.reqQty * row.confac); //转换为基本单位数量
		var price = row.price;
		var refSum = (row.isAppRep == 'Y') ? (refSum = row.repPartAmt || 0) : round(price * reqQty);
		var dspbId = row.dspbId;
		var isOweDrug = row.isOweDrug;
		var phdicId = row.phdicId;
		var isExecute = row.isExecute;
		var refRepPart = row.refRepPart;
		var ordCateType = row.ordCateType;
		var reqStr = prtId + '^' + pboId + '^' + oeori + '^' + reqQty + '^' + refSum;
		if (ordCateType == 'R') {
			reqStr += '^' + dspbId + '^' + isOweDrug + '^' + phdicId + '^' + isExecute;
			reqDrugAry.push(reqStr);
		} else {
			reqStr += '^' + '' + '^' + refRepPart;
			reqOtherAry.push(reqStr);
		}
	});
	var reqDrugStr = reqDrugAry.join(String.fromCharCode(2));
	var reqOtherStr = reqOtherAry.join(String.fromCharCode(2));
	var refReason = getValueById('refReason') || '';
	if (refReason == '') {
		$.messager.alert('提示', '请选择退费原因', 'info');
		return;
	}
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: 'web.DHCOPBillRefundRequest',
		MethodName: 'RefundRequest',
		ReqUser: PUBLIC_CONSTANT.SESSION.USERID,
		ReqDrugInfo: reqDrugStr,
		ReqNonDrugInfo: reqOtherStr,
		ReqReason: refReason,
		ExpStr: expStr
	}, function (rtn) {
		var myAry = rtn.split('^');
		var err = myAry[0];
		var desc = myAry[1];
		if (err == 0) {
			$.messager.popover({msg: desc, type: 'success'});
			$('#ordItmList').datagrid('reload');
			getAlreadyReqAmt();
		}else {
			$.messager.popover({msg: desc, type: 'info'});
		}
	});
}

/**
 * 撤销申请
 */
function cancelClick() {
	var rows = $('#invList').datagrid('getChecked');
	if (rows == '') {
		return;
	}
	var invAry = [];
	$.each(rows, function (index, row) {
		var prtRowId = row.TINVRowid;
		var sFlag = row.TabFlag;
		var tmpStr = prtRowId + ':' + sFlag;
		invAry.push(tmpStr);
	});
	var invStr = invAry.join('^');
	
	var expStr = PUBLIC_CONSTANT.SESSION.GROUPID + '^' + PUBLIC_CONSTANT.SESSION.CTLOCID + '^' + PUBLIC_CONSTANT.SESSION.HOSPID;
	$.m({
		ClassName: 'web.DHCOPBillRefundRequest',
		MethodName: 'CancelRequest',
		CancelReqInfo: invStr,
		User: PUBLIC_CONSTANT.SESSION.USERID,
		ExpStr: expStr
	}, function (rtn) {
		var myAry = rtn.split('^');
		var err = myAry[0];
		var desc = myAry[1];
		if (err == 0) {
			$.messager.popover({msg: desc, type: 'success'});
			$('#ordItmList').datagrid('reload');
			getAlreadyReqAmt();
		}else {
			$.messager.popover({msg: desc, type: 'info'});
		}
	});
}

/**
 * 模拟##class(web.UDHCJFBILL).round()方法四舍五入
 */
function round(num) {
	return ((+num > 0) && (+num < 0.01)) ? 0.01 : parseFloat(num).toFixed(2);
}

/**
 * 取勾选中的票据Id串
 */
function getCheckedInvStr() {
	var invAry = [];
	var rows = $('#invList').datagrid('getChecked');
	$.each(rows, function (index, row) {
		var prtRowId = row.TINVRowid;
		var sFlag = row.TabFlag;
		var tmpStr = prtRowId + ':' + sFlag;
		invAry.push(tmpStr);
	});
	var invStr = invAry.join('^');
	return invStr;
}

/**
* 取已申请退费金额
*/
function getAlreadyReqAmt() {
	var invStr = getCheckedInvStr();
	$.m({
		ClassName: 'web.DHCOPBillRefundRequest',
		MethodName: 'GetAlreadyReqAmt',
		invStr: invStr
	}, function (refSum) {
		GV.AlreadyReqSum = refSum;
		setValueById('refAmt', refSum);
	});
}

/**
 * 控制草药按处方退费
 */
function controlCNMedItm(index, row) {
	var prescNo = row.prescNo;
	var isCNMedItem = row.isCNMedItem;
	if ((prescNo == '') || (isCNMedItem != 1)) {
		return;
	}
	var rows = $('#ordItmList').datagrid('getRows');
	$.each(rows, function (idx, row) {
		if ((index == idx) || (prescNo != row.prescNo)) {
			return true;
		}
		setOrdItmRowChecked(idx, getOrdItmRowChecked(index));
	});
}

/**
 * 获取医嘱明细datagrid勾选/不勾选状态
 */
function getOrdItmRowChecked(index) {
	return getColumnValue(index, 'ck', 'ordItmList') == 1 ? true : false;
}

/**
 * 设置医嘱明细datagrid勾选/不勾选状态
 */
function setOrdItmRowChecked(index, checked) {
	GV.SelRowIndex = index;
	var objGrid = $HUI.datagrid('#ordItmList');
	if (checked) {
		objGrid.checkRow(index);
	}else {
		objGrid.uncheckRow(index);
	}
	GV.SelRowIndex = undefined;
}

function setRowsAry(row, checked) {
	if (checked) {
		if ($.inArray(row, GV.RowsAry) == -1) {
			GV.RowsAry.push(row);
		}
	}else {
		if ($.inArray(row, GV.RowsAry) != -1) {
			GV.RowsAry.splice($.inArray(row, GV.RowsAry), 1);
		}
	}
}

/**
 * 清屏
 */
function clearClick() {
	$(':text:not(.pagination-num)').val("");
	$('#cardType, #refReason').combobox('reload');
	var defDate = getDefStDate(0);
	$('#stDate').datebox('setValue', defDate);
	$('#endDate').datebox('setValue', defDate);
	$('#invList').datagrid('load', {
		ClassName: 'web.DHCOPBillRefundRequest',
		QueryName: 'FindInvInfo',
		StDate: '',
		EndDate: '',
		ReceiptNO: '',
		PatientNO: '',
		PatientName: '',
		ChargeUser: '',
		ExpStr: ''
	});
	$('#ordItmList').datagrid('loadData', {
		total: 0,
		rows: []
	});
}

/**
 * 打印退费单
 */
function printClick() {
	var reqInvAry = getReqInvStr();
	if (reqInvAry.length == 0) {
		$.messager.alert('提示', '请先做退费申请.', 'info');
		return;
	}
	refReqListPrint(reqInvAry);
}

/**
* 获取已申请的发票
*/
function getReqInvStr() {
	var reqInvAry = [];
	var invStr = getCheckedInvStr();
	if (invStr == '') {
		return reqInvAry;
	}
	var myInvAry = invStr.split('^');
	$.each(myInvAry, function (index, itm) {
		var rtn = $.m({
			ClassName: 'web.DHCOPBillRefundRequest',
			MethodName: 'CheckInvIsReqById',
			prtRowId: itm.split(':')[0],
			invType: itm.split(':')[1]
		}, false);
		if (+rtn == 1) {
			reqInvAry.push(itm);
		}
	});
	return reqInvAry;
}