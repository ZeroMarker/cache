/**
 * FileName: dhcbill.preipadmtrans.js
 * Anchor: ZhYW
 * Date: 2018-06-30
 * Description: 预住院转门诊/住院
 */

$(function () {
	$(document).keydown(function (e) {
		banBackSpace(e);
	});
	initQueryMenu();
	initPreIPAdmList();
});

function initQueryMenu() {
	setValueById('stDate', getDefStDate(-7));
	setValueById('endDate', getDefStDate(0));
	
	$HUI.linkbutton('#btn-readCard', {
		onClick: function () {
			readHFMagCardClick();
		}
	});

	$HUI.linkbutton('#btn-find', {
		onClick: function () {
			loadPreIPAdmList();
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
	
	//当前病区
	$HUI.combobox('#curWard', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillPreIPAdmTrans&QueryName=FindWard&ResultSetType=array',
		editable: true,
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		}
	});

	//科室
	$HUI.combobox('#dept', {
		panelHeight: 150,
		url: $URL + '?ClassName=web.DHCBillPreIPAdmTrans&QueryName=FindDept&ResultSetType=array',
		editable: true,
		mode: 'remote',
		valueField: 'id',
		textField: 'text',
		onBeforeLoad: function (param) {
			param.desc = param.q;
			param.hospId = PUBLIC_CONSTANT.SESSION.HOSPID;
		},
		onChange: function(newValue, oldValue) {
			$('#ward').combobox('clear');
			if (newValue) {
				var url = $URL + '?ClassName=web.DHCBillPreIPAdmTrans&QueryName=FindLinkedWard&ResultSetType=array&docIPBookId=&deptId=' + newValue;
				$('#ward').combobox('reload', url);
			}
		}
	});

	$HUI.combobox('#ward', {
		panelHeight: 150,
		multiple: false,
		valueField: 'id',
		textField: 'text'
	});
}

function initPreIPAdmList() {
	var toolbar = [{
			text: '转门诊',
			iconCls: 'icon-outpatient',
			handler: function () {
				transClick('O', '');
			}
		}, {
			text: '转住院',
			iconCls: 'icon-inpatient',
			handler: function () {
				transClick('I', '');
			}
		}, {
			text: '转常规手术',
			iconCls: 'icon-pat-opr',
			handler: function () {
				transClick('I', 'Y');
			}
		}, {
			text: '转门诊审核',
			iconCls: 'icon-stamp',
			handler: function () {
				auditClick();
			}
		}, {
			text: '撤销审核',
			iconCls: 'icon-stamp-cancel',
			handler: function () {
				cancelAuditClick();
			}
		}
	];
	$HUI.datagrid("#preIPAdmList", {
		fit: true,
		striped: true,
		border: false,
		singleSelect: true,
		pagination: true,
		rownumbers: true,
		pageSize: 20,
		toolbar: toolbar,
		columns: [[{title: '登记号', field: 'RegNo', width: 100},
		           {title: '病案号', field: 'MedicareNo', width: 100},
		           {title: '患者姓名', field: 'PatName', width: 100},
		           {title: '性别', field: 'PatSex', width: 50},
		           {title: '年龄', field: 'PatAge', width: 50},
		           {title: '就诊时间', field: 'AdmDatTime', width: 155},
		           {title: '科室', field: 'Dept', width: 130},
		           {title: '病区', field: 'Ward', width: 130},
		           {title: '费别', field: 'AdmReaDesc', width: 80},
		           {title: '押金', field: 'Deposit', align: 'right', width: 100, formatter: formatAmt},
		           {title: '诊断', field: 'MRDiagnos', width: 170},
		           {title: '是否审核', field: 'AuditFlag', width: 80,
					formatter: function (value, row, index) {
						return (value == 'Y') ? '<font color="#21ba45">是</font>' : '<font color="#f16e57">否</font>';
					}
				   },
				   {title: 'DocIPBookId', field: 'DocIPBookId', hidden: true},
				   {title: '床位预约状态', field: 'CurrStateDesc', width: 100},
				   {title: 'Adm', field: 'Adm', hidden: true},
				   {title: 'PatientId', field: 'PatientId', hidden: true}
			]],
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCBillPreIPAdmTrans',
			QueryName: 'FindAdmInfo',
			stDate: getValueById('stDate'),
			endDate: getValueById('endDate'),
			wardId: getValueById('curWard') || '',
			patientId: getValueById('patientId'),
			episodeId: getParam('EpisodeID'),
			hospId: PUBLIC_CONSTANT.SESSION.HOSPID
		},
		onSelect: function (index, row) {
			setMenuVal(row.Adm, row.PatientId);
			if (row.DocIPBookId) {
				$.m({
					//调用接口获取住院证上的科室和病区
					ClassName: 'web.DHCDocIPBookNew',
					MethodName: 'GetBookMesage',
					BookID: row.DocIPBookId
				}, function (rtn) {
					var myAry = rtn.split('^');
					setValueById('dept', myAry[13]);
					var url = $URL + '?ClassName=web.DHCBillPreIPAdmTrans&QueryName=FindLinkedWard&ResultSetType=array&docIPBookId=' + row.DocIPBookId + '&deptId=';
					$('#ward').combobox('reload', url);
				});
			}
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
			$('#btn-readCard').linkbutton('disable');
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
			setValueById('patientId', myAry[4]);
			setValueById('patientNo', myAry[5]);
			loadPreIPAdmList();
			break;
		case '-200':
			$.messager.alert('提示', '卡无效', 'info', function() {
				$('#btn-readCard').focus();
			});
			break;
		case '-201':
			setValueById('cardNo', myAry[1]);
			setValueById('patientId', myAry[4]);
			setValueById('patientNo', myAry[5]);
			loadPreIPAdmList();
			break;
		default:
		}
	} catch (e) {
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
				setValueById('patientId', myAry[4]);
				setValueById('patientNo', myAry[5]);
				loadPreIPAdmList();
				break;
			case '-200':
				setTimeout(function() {
					$.messager.alert('提示', '卡无效', 'info', function() {
						focusById('cardNo');
					});
				}, 300);
				break;
			case '-201':
				setValueById('cardNo', myAry[1]);
				setValueById('patientId', myAry[4]);
				setValueById('patientNo', myAry[5]);
				loadPreIPAdmList();
				break;
			default:
			}
		}
	} catch (e) {
	}
}

function patientNoKeydown(e) {
	var key = websys_getKey(e);
	if (key == 13) {
		var patientNo = getValueById('patientNo');
		$.m({
			ClassName: 'web.DHCBillPreIPAdmTrans',
			MethodName: 'GetPatInfoByPatientNo',
			patientNo: patientNo
		}, function (rtn) {
			var myAry = rtn.split('^');
			setValueById('patientId', myAry[0]);
			setValueById('patientNo', myAry[1]);
			if (myAry[0]) {
				loadPreIPAdmList();
			}else {
				$.messager.alert('提示', '此登记号不存在', 'error', function() {
					setValueById('patientNo', '');
				});
			}
		});
	}else {
		setValueById('patientId', '');
	}
}

function loadPreIPAdmList() {
	var queryParams = {
		ClassName: 'web.DHCBillPreIPAdmTrans',
		QueryName: 'FindAdmInfo',
		stDate: getValueById('stDate'),
		endDate: getValueById('endDate'),
		wardId: getValueById('curWard') || '',
		patientId: getValueById('patientId'),
		episodeId: getParam('EpisodeID'),
		hospId: PUBLIC_CONSTANT.SESSION.HOSPID
	};
	loadDataGridStore('preIPAdmList', queryParams);
}

/**
 * 转门诊审核
 */
function auditClick() {
	var row = $('#preIPAdmList').datagrid('getSelected');
	if ((!row) || (!row.Adm)) {
		$.messager.popover({msg: '请选择预住院就诊记录', type: 'info'});
		return;
	}
	var adm = row.Adm;
	$.messager.confirm('提示', '确认要转门诊审核?', function (r) {
		if (r) {
			$.m({
				ClassName: 'web.DHCBillPreIPAdmTrans',
				MethodName: 'Audit',
				episodeId: adm,
				userId: PUBLIC_CONSTANT.SESSION.USERID
			}, function (rtn) {
				var myAry = rtn.split("^");
				var success = myAry[0];
				var msg = myAry[1];
				var type = (success == '0') ? 'success' : 'error';
				$.messager.alert('提示', msg, type, function () {
					if (success == '0') {
						$('#preIPAdmList').datagrid('reload');
					}
				});
			});
		}
	});
}

/**
 * 撤销审核
 */
function cancelAuditClick() {
	var row = $('#preIPAdmList').datagrid('getSelected');
	if ((!row) || (!row.Adm)) {
		$.messager.popover({msg: '请选择已审核的预住院就诊记录', type: 'info'});
		return;
	}
	var adm = row.Adm;
	$.messager.confirm('提示', '确认要撤销审核?', function (r) {
		if (r) {
			$.m({
				ClassName: 'web.DHCBillPreIPAdmTrans',
				MethodName: 'CancelAudit',
				episodeId: adm
			}, function (rtn) {
				var myAry = rtn.split("^");
				var success = myAry[0];
				var msg = myAry[1];
				var type = (success == '0') ? 'success' : 'error';
				$.messager.alert('提示', msg, type, function () {
					if (success == '0') {
						$('#preIPAdmList').datagrid('reload');
					}
				});
			});
		}
	});
}

/**
 * 转门诊/住院
 */
function transClick(transType, norOperFlag) {
	var row = $('#preIPAdmList').datagrid('getSelected');
	if ((!row) || (!row.Adm)) {
		$.messager.popover({msg: '请选择预住院就诊记录', type: 'info'});
		return;
	}
	var typeDesc = '住院';
	if (transType == 'O') {
		typeDesc = '门诊';
	}
	if (norOperFlag == 'Y') {
		typeDesc = '常规手术';
	}
	var adm = row.Adm;
	$.messager.confirm('提示', '确认转' + typeDesc + '？', function (r) {
		if (r) {
			$.m({
				ClassName: 'web.DHCBillPreIPAdmTrans',
				MethodName: 'AdmTrans',
				episodeId: adm,
				transType: transType,
				deptId: getValueById('dept'),
				wardId: getValueById('ward'),
				norOperFlag: norOperFlag,
				sessionStr: getSessionStr()
			}, function (rtn) {
				var myAry = rtn.split("^");
				var success = myAry[0];
				var msg = myAry[1];
				var type = (success == '0') ? 'success' : 'error';
				$.messager.alert('提示', msg, type, function () {
					if (success == '0') {
						setMenuVal('', '');          //转后清头菜单传值
						$('#preIPAdmList').datagrid('load');
					}
				});
			});
		}
	});
}

function setMenuVal(episodeId, patientId) {
	var frm = top.document.forms['fEPRMENU'];
	if (frm) {
		var frmEpisodeID = frm.EpisodeID;
		if (frmEpisodeID) {
			frmEpisodeID.value = episodeId;
		}
		var frmPatientID = frm.PatientID;
		if (frmPatientID) {
			frmPatientID.value = patientId;
		}
	}
}