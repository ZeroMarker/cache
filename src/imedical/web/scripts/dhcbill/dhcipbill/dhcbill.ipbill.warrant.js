/**
 * FileName: dhcbill.ipbill.warrant.js
 * Anchor: ZhYW
 * Date: 2019-10-09
 * Description: 住院担保
 */

$.extend($.fn.validatebox.defaults.rules, {
	checkMaxAmt: {    //校验最大值
	    validator: function(value) {
		    return value < 1000000000;
		},
		message: "金额输入过大"
	}
});

var GV = {
	PatType: 'I'
};

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initWarrList();
});

function initQueryMenu() {
	setValueById('stDate', getDefStDate(0));

	$HUI.linkbutton('#btn-readCard', {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton('#btn-add, #btn-update', {
		onClick: function () {
			saveClick(this.id);
		}
	});
	
	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			loadWarrList();
		}
	});
	
	$HUI.linkbutton('#btn-clear', {
		onClick: function () {
			clearClick();
		}
	});

	$HUI.linkbutton('#btn-print', {
		onClick: function () {
			printClick();
		}
	});
	
	//卡号回车查询事件
	$('#cardNo').keydown(function(e) {
		cardNoKeydown(e);
	});

	//登记号回车查询事件
	$('#patientNo').keydown(function(e) {
		patientNoKeyDown(e);
	});

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

	$HUI.combobox('#warrStatus', {
		panelHeight: 'auto',
		multiple: false,
		data: [{value: 'Y', text: '有效'},
			   {value: 'N', text: '无效'}
		],
		editable: false,
		valueField: 'value',
		textField: 'text',
		value: 'Y'
	});

	$HUI.combogrid('#admList', {
		panelWidth: 420,
		panelHeight: 200,
		striped: true,
		fitColumns: true,
		delay: 300,
		idField: 'adm',
		textField: 'adm',
		columns: [[{field: 'adm', title: '就诊号', width: 60},
				   {field: 'admDate', title: '就诊时间', width: 150,
				    formatter: function(value, row, index) {
						return value + " " + row.admTime;
					}
				   },
				   {field: 'admDept', title: '就诊科室', width: 150}
			]],
		onLoadSuccess: function (data) {
			$(this).combogrid('clear');
			if (data.total == 1) {
				setValueById('admList', data.rows[0].adm);
			}
		},
		onSelect: function (index, row) {
			var adm = row.adm;
			setBannerPatPayInfo(adm);
			setValueById('EpisodeID', adm);
		}
	});
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
			focusById('cardNo');
		} else {
			enableById('btn-readCard');
			setValueById('cardNo', '');
			$('#cardNo').attr('readOnly', true);
			focusById('btn-readCard');
		}
	} catch (e) {
	}
}

function reloadWarrList(episodeId) {
	setValueById('EpisodeID', episodeId);
	loadWarrList();
}

/**
 * 读卡
 * @method readHFMagCardClick
 * @author ZhYW
 */
function readHFMagCardClick() {
	try {
		var cardType = getValueById('cardType');
		var cardTypeAry = cardType.split('^');
		var cardTypeDR = cardTypeAry[0];
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
			setValueById('PatientID', '');
			$.messager.alert('提示', '卡无效', 'info', function() {
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

function patientNoKeyDown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		getPatInfo();
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
				getPatInfo();
				break;
			case '-200':
				setValueById('PatientID', '');
				setTimeout(function() {
					$.messager.alert('提示', '卡无效', 'info', function() {
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

function getPatInfo() {
	$('#admList').combogrid('clear');
	setValueById('EpisodeID', '');
	var patientNo = getValueById('patientNo');
	setBannerPatInfo(patientNo);
	$.m({
		ClassName: 'web.DHCOPBillWarrant',
		MethodName: 'GetPatInfoByRegNo',
		patientNo: patientNo
	}, function (rtn) {
		var myAry = rtn.split('^');
		setValueById('PatientID', myAry[0]);
		setValueById('patientNo', myAry[1]);
		if (!myAry[0]) {
			$.messager.popover({msg: "登记号无效", type: "info"});
		}else {
			loadAdmList();
			loadWarrList();
		}
	});
}

function initWarrList() {
	GV.WarrList = $HUI.datagrid('#warrList', {
		fit: true,
		border: false,
		striped: true,
		singleSelect: true,
		fitColumns: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		data: [],
		columns: [[{field: 'regNo', title: '登记号', width: 100},
				   {field: 'patName', title: '患者姓名', width: 80},
				   {field: 'admDept', title: '就诊科室', width: 100},
				   {field: 'warrDate', title: '担保时间', width: 150,
				   formatter: function(value, row, index) {
						return value + " " + row.warrTime;
					}
				   },
				   {field: 'warrtor', title: '担保人', width: 80},
				   {field: 'warrAmt', title: '担保金额', align: 'right', width: 100, formatter: formatAmt},
				   {field: 'warrEndDate', title: '结束日期', width: 100},
				   {field: 'status', title: '是否有效', width: 80,
					formatter: function(value, row, index) {
						return (value == 'Y') ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
					}
				   },
				   {field: 'userName', title: '操作员', width: 100},
				   {field: 'remark', title: '备注', width: 100},
				   {field: 'adm', title: '就诊号', width: 70},
				   {field: 'papmi', title: 'papmi', hidden: true},
				   {field: 'warrId', title: 'warrId', hidden: true}
			]],
		onSelect: function (index, row) {
			selectRowHandler(row);
		}
	});
}

function selectRowHandler(row) {
	setValueById('patientNo', row.regNo);
	setValueById('EpisodeID', row.adm);
	setValueById('PatientID', row.papmi);
	setValueById('stDate', row.warrDate);
	setValueById('endDate', row.warrEndDate);
	
	loadAdmList();
	
	setValueById('warrAmt', row.warrAmt);
	setValueById('warrtor', row.warrtor);
	setValueById('remark', row.remark);
	
	setValueById('remark', row.remark);
	setValueById('warrStatus', row.status);
	setBannerPatInfo(row.regNo);
}

function loadWarrList() {
	var queryParams = {
		ClassName: 'web.DHCOPBillWarrant',
		QueryName: 'FindWarrInfo',
		stDate: getValueById('stDate'),
		endDate: getValueById('endDate'),
		episodeId: getValueById('EpisodeID'),
		papmiId: getValueById('PatientID'),
		patType: GV.PatType,
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore('warrList', queryParams);
}

/**
 * 加载就诊列表
 */
function loadAdmList() {
	var queryParams = {
		ClassName: "web.UDHCJFZYDB",
		QueryName: "FindAdmInfo",
		papmiId: getValueById('PatientID'),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	}
	loadComboGridStore("admList", queryParams);
}

function saveClick(btnId) {
	var episodeId = getValueById('EpisodeID');
	if (!episodeId) {
		$.messager.popover({msg: "请选择就诊", type: "info"});
		return;
	}
	
	if (!checkData()) {
		return;
	}
	
	var warrStatus = getValueById('warrStatus');
	var warrId = '';
	var row = GV.WarrList.getSelected();
	if (btnId == 'btn-update') {
		if ((!row)||(!row.warrId)) {
			$.messager.popover({msg: "请选择担保记录", type: "info"});
			return;
		}else {
			warrId = row.warrId;
			if (row.status == 'N') {
				$.messager.popover({msg: "已失效的记录不能修改", type: "info"});
				return;
			}
		}
	}else {
		if (warrStatus != 'Y') {
			$.messager.popover({msg: "担保状态不能为无效", type: "info"});
			return;
		}
	}
	var warrAmt = getValueById('warrAmt');
	var warrtor = $.trim(getValueById('warrtor'));
	var stDate = getValueById('stDate');
	var endDate = getValueById('endDate');
	var remark = getValueById('remark');
	var guarantId = "";
	var warrItem = "";
	var warrInfo = warrId + '&' + episodeId + '&' + stDate + '&' + endDate + '&' + warrtor + '&' + warrAmt + '&' + warrStatus;
	warrInfo += '&' + remark + '&' + PUBLIC_CONSTANT.SESSION.USERID + '&' + GV.PatType + '&' + guarantId + '&' + warrItem;
	warrInfo += '&' + PUBLIC_CONSTANT.SESSION.HOSPID;
	if (warrInfo.indexOf('^') != -1) {
		$.messager.alert('提示', '输入有特殊字符', 'info');
		return;
	}
	var msg = "担保 <font style='color:red;'>" + warrAmt + "</font> 元，是否确认?";
	if (warrId) {
		msg = "是否确认修改?";
	}
	$.messager.confirm("确认", msg, function (r) {
		if (r) {
			$m({
				ClassName: 'web.DHCOPBillWarrant',
				MethodName: "SaveWarrant",
				warrInfo: warrInfo,
			}, function(rtn) {
				var myAry = rtn.split('^');
				$.messager.alert('提示', myAry[1], 'info');
				if (myAry[0] == 0) {
					setBannerPatPayInfo(episodeId);
					
					$('#warrAmt').numberbox('clear');
					setValueById('warrStatus', 'Y');
					setValueById('warrtor', '');
					setValueById('remark', '');
					
					loadWarrList();
				}
			});
		}
	});
}

function checkData() {
	var bool = true;
	$(".validatebox-text").each(function(index, item) {
		if (!$(this).validatebox("isValid")) {
			bool = false;
			return false;
		}
	});
	if (!bool) {
		return false;
	}
	
	var id = "";
	$("label.clsRequired").each(function(index, item) {
		id = $($(this).parent().next().find("input"))[0].id;
		if (!id) {
			return true;
		}
		if (!getValueById(id)) {
			bool = false;
			$.messager.popover({msg: "请输入<font color=red>" + $(this).text() + "</font>", type: "info"});
			return false;
		}
	});
	
	return bool;
}

function clearClick() {
	setValueById('PatientID', '');
	setValueById('EpisodeID', '');
	$(":text:not(.pagination-num)").val("");
	$(".numberbox-f").numberbox("clear");
	setValueById('warrStatus', 'Y');
	$('#cardType').combobox('reload');
	setValueById('stDate', getDefStDate(0));
	setValueById('endDate', '');
	
	$('#admList').combogrid('clear');
	$(".datagrid-f").datagrid("loadData", {
		total: 0,
		rows: []
	});

	//清除banner
	$('#bn-sex').removeClass();
	$('.patientInfo>[id]').text('');
}

/**
* 打印
*/
function printClick() {
	var row = GV.WarrList.getSelected();
	if (!row) {
		$.messager.popover({msg: "请选择担保记录", type: "info"});
		return;
	}
	var warrStatus = row.status;
	if (warrStatus != 'Y') {
		$.messager.popover({msg: "担保无效，不能打印", type: "info"});
		return;
	}
	
	var warrId = row.warrId;
	var fileName = 'DHCBILL-OPBILL-担保单.raq&warrId=' + warrId;
	var maxWidth = $(window).width() || 1366;
	var maxHeight = $(window).height() || 550;
	DHCCPM_RQPrint(fileName, maxWidth, maxHeight);
}