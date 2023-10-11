/**
 * ����:   	 ҩ��ҩ�� - ����ҩƷ����
 * ��д��:   Huxiaotian
 * ��д����: 2020-08-07
 * csp:		 pha.in.v1.narcrec.csp
 * js:		 pha/in/v1/narcrec.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narcrec.csp';
PHA_COM.App.Name = $g('����ҩƷ����');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	InitConfig();
	
	var isTabMenu = PHA_COM.IsTabsMenu();
	$('#panelNarcRec').panel({
		title: isTabMenu !== true ? $g('����ҩƷ����') : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-template',
		bodyCls: 'panel-body-gray',
		fit: true,
		tools: [{
				iconCls: 'icon-help',
				handler: showHelpWin
			}
		]
	});
	if (isTabMenu == true) {
		var tipsHtml = '';
		tipsHtml += '<div class="pha-col" style="position:absolute;right:10px;top:18px;">';
		tipsHtml += '	<img id="btnHelp" src="../scripts_lib/hisui-0.1.0/dist/css/icons/help.png" style="cursor:pointer;" />';
		tipsHtml += '</div>';
		$('#gridNarcRecBar-row1').append(tipsHtml);
		$('#btnHelp').on('click', showHelpWin);
	}

	InitDict();
	InitGridNarcRec();
	InitEvents();
	
	
	// ��ʾ¼�����
	if (PHA_COM.VAR.CONFIG['Rec.ShowWin'] == 'Y') {
		InputRecInfo();
	}
	// �Զ���ѯ
	if (patNo != '') {
		Query();
	}
});

// ��ʼ�� - ���ֵ�
function InitDict() {
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Rec.StDate']));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Rec.EdDate']));
	$('#patNo').val(patNo);
	
	PHA.ComboBox('recLocId', {
		disabled: true,
		url: PHA_STORE.CTLoc().url,
		onLoadSuccess: function (data) {
			if (!data || data.length == 0) {
				return;
			}
			for (var i = 0; i < data.length; i++) {
				var rowId = data[i].RowId;
				if (rowId == session['LOGON.CTLOCID']) {
					$('#recLocId').combobox('setValue', rowId);
					break;
				}
			}
		}
	});
	PHA.ComboBox('recState', {
		width: 150,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=RecStatus',
		panelHeight: 'auto'
	});
	PHA.ComboBox('wardLocId', {
		width: 140,
		url: PHA_STORE.CTLoc().url + '&TypeStr=W'
	});
	PHA.ComboBox('docLocId', {
		width: 140,
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboGrid('inci', {
		width: 160,
		panelWidth: 450,
		url: $URL + '?ClassName=PHA.IN.Narc.Com&QueryName=INCItm&HospId=' + session['LOGON.HOSPID'],
		idField: 'inci',
		textField: 'inciDesc',
		columns: [[{
					field: 'inci',
					title: '�����ID',
					width: 60,
					hidden: true
				}, {
					field: 'inciCode',
					title: '����',
					width: 120
				}, {
					field: 'inciDesc',
					title: '����',
					width: 200
				}, {
					field: 'inciSpec',
					title: '���',
					width: 100
				}
			]
		],
		onLoadSuccess: function () {
			return false;
		}
	});
	PHA.ToggleButton('BMore', {
		buttonTextArr: [$g('����'), $g('����')],
		selectedText: $g('����'),
		onClick: function (oldText, newText) {
			if (oldText == $g('����')) {
				$('#gridNarcRecBar-row2').show();
				$('#gridNarcRecBar-row3').show();
			} else {
				$('#gridNarcRecBar-row2').hide();
				$('#gridNarcRecBar-row3').hide();
			}
			$('#layout').layout('resize');
		}
	});

	InitDictVal();
}
function InitDictVal() {
	$('#recState').combobox('setValue', 'N');
}

// ��ʼ�� - �¼���
function InitEvents() {
	$('#btnFind').on('click', Query);
	$('#btnClear').on('click', Clear);
	$('#btnSave').on('click', Save);
	$('#btnInput').on('click', InputRecInfo);
	$('#btnCancel').on('click', Cancel);

	// ����
	$('#btnReadCard').on('click', ReadCard);
	$('#cardNo').on('keydown', function (e) {
		if (e.keyCode == 13) {
			ReadCard();
		}
	});
	// �ǼǺ�
	$('#patNo').on('keydown', function (e) {
		if (e.keyCode == 13) {
			var tPatNo = $('#patNo').val() || '';
			if (tPatNo == '') {
				return;
			}
			var nPatNo = PHA_COM.FullPatNo(tPatNo);
			$('#patNo').val(nPatNo);
			Query();
		}
	});
	// ��ҩ����
	$('#dspBatchNo').on('keydown', function (e) {
		if (e.keyCode == 13) {
			Query();
		}
	});
	// �Ǽ�����
	$('#regBatchNo').on('keydown', function (e) {
		if (e.keyCode == 13) {
			Query();
		}
	});
}

// ��ʼ�� - ���
function InitGridNarcRec() {
	// �����Ƿ���Ա༭
	var batchNoEditor = PHA_GridEditor.ValidateBox({
		required: true
	});
	batchNoEditor = PHA_COM.VAR.CONFIG['Rec.InputBatNo'] == 'N' ? null : batchNoEditor;
	var editFieldSort = batchNoEditor ? ['recBatchNo', 'recFluidQty', 'recQty'] : ['recFluidQty', 'recQty'];
	
	// ����Ϣ
	var columns = [
		[{
				field: 'tSelect',
				checkbox: true
			}, {
				title: '����',
				field: 'pinr',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '����ID',
				field: 'adm',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '�ǼǺ�',
				field: 'patNo',
				width: 100,
				align: 'left',
				formatter: function (value, rowData, index) {
					return '<a style="border:0px;cursor:pointer" onclick="">' + value + '</a>';
				}
			}, {
				title: '��������',
				field: 'patName',
				width: 100,
				align: 'left'
			}, {
				title: '�Ա�',
				field: 'patSex',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '����',
				field: 'patAge',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: 'ҩƷ����',
				field: 'inciCode',
				width: 120,
				align: 'left',
				hidden: true
			}, {
				title: 'ҩƷ����',
				field: 'inciDesc',
				width: 200,
				align: 'left',
				showTip: true,
				tipWidth: 200
			}, {
				title: '����ҩƷ���',
				field: 'inciNo',
				width: 100,
				align: 'left'
			}, {
				title: '�Ǽ�����',
				field: 'inciBatchNo',
				width: 100,
				align: 'left'
			}, {
				title: GetEditTitle('��������'),
				field: 'recBatchNo',
				width: 90,
				align: 'left',
				editor: batchNoEditor
			}, {
				title: '��ҩ����',
				field: 'dspQty',
				width: 75,
				align: 'right'
			}, {
				title: '��ҩ��λ',
				field: 'dspUomDesc',
				width: 75,
				align: 'center'
			}, {
				title: '������λ',
				field: 'doseUomDesc',
				width: 75,
				align: 'center'
			}, {
				title: 'ʵ������',
				field: 'useQty',
				width: 75,
				align: 'right'
			}, {
				title: GetEditTitle('Һ�����'),
				field: 'recFluidQty',
				width: 75,
				align: 'right',
				editor: PHA_GridEditor.ValidateBox({
					required: true,
					checkValue: function (val, chkRet) {
						if (isNaN(val)) {
							chkRet.msg = "����������!";
							return false;
						}
						val = parseFloat(val);
						if (val < 0) {
							chkRet.msg = "����С��0!";
							return false;
						}
						return true;
					}
				})
			}, {
				title: GetEditTitle('�հ������'),
				field: 'recQty',
				width: 90,
				align: 'right',
				editor: PHA_GridEditor.ValidateBox({
					required: true,
					checkValue: function (val, chkRet) {
						if (isNaN(val)) {
							chkRet.msg = "����������!";
							return false;
						}
						val = parseFloat(val);
						if (val < 0) {
							chkRet.msg = "����С��0!";
							return false;
						}
						if (parseFloat(val.toString().split('.')[1]) > 0) {
							chkRet.msg = "������С��";
							return false;
						}
						return true;
					},
					onBeforeNext: function (val, gridRowData, gridRowIdex) {
						// ���һ�����һ��
						if (PHA_GridEditor.IsLastRow()) {
							PHA_GridEditor.End('gridNarcRec');
							return false;
						}
						return true;
					}
				})
			}, {
				title: ('���պ˶���'),
				field: 'recCheckUserId',
				descField: 'recCheckUserName',
				width: 100,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['recCheckUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: ('���ս�����'),
				field: 'recFromUserName',
				width: 100,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				title: ('��������ϵ��ʽ'),
				field: 'recFromUserTel',
				width: 120,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				title: ('������Դ����'),
				field: 'recOriType',
				descField: 'recOriTypeDesc',
				width: 100,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['recOriTypeDesc'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.recOriType.options))
			}, {
				title: ('������Դ����'),
				field: 'recOriLocId',
				descField: 'recOriLocDesc',
				width: 120,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData.recOriLocDesc;
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.LocInfo.options))
			}, {
				title: ('�����������'),
				field: 'DSCD',
				descField: 'DSCDDesc',
				width: 160,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['DSCDDesc'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.DSCD.options))
			}, {
				title: ('��������ִ����'),
				field: 'DSCDExeUserId',
				descField: 'DSCDExeUserName',
				width: 120,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['DSCDExeUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: ('��������ල��'),
				field: 'DSCDSuperUserId',
				descField: 'DSCDSuperUserName',
				width: 120,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['DSCDSuperUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: '����״̬',
				field: 'recStateDesc',
				width: 75,
				align: 'center'
			}, {
				title: '���տ���',
				field: 'recLocDesc',
				width: 130,
				align: 'left'
			}, {
				title: '������',
				field: 'recUserName',
				width: 100,
				align: 'left'
			}, {
				title: '��������',
				field: 'recDate',
				width: 100,
				align: 'center'
			}, {
				title: '����ʱ��',
				field: 'recTime',
				width: 90,
				align: 'center'
			}, {
				title: 'Ԥ��ִ��ʱ��',
				field: 'dosingDT',
				width: 150,
				align: 'center'
			}, {
				title: '��ʿִ��ʱ��',
				field: 'exeDT',
				width: 150,
				align: 'center'
			}, {
				title: '������',
				field: 'cancelUserName',
				width: 100,
				align: 'center'
			}, {
				title: '����ʱ��',
				field: 'cancelDT',
				width: 150,
				align: 'center'
			}, {
				title: 'ִ�м�¼ID',
				field: 'oeore',
				width: 100,
				align: 'left',
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.NarcRec.Query',
			QueryName: 'NarcRec'
		},
		singleSelect: false,
		pagination: true,
		columns: columns,
		toolbar: '#gridNarcRecBar',
		isCellEdit: false,
		isAutoShowPanel: true,
		editFieldSort: editFieldSort,
		onClickCell: function (index, field, value) {
			if (field == 'patNo') {
				OpenDetailWin(index);
				return;
			}
			if (!PHA_GridEditor.End('gridNarcRec')) {
				return;
			}
			if (editFieldSort.indexOf(field) < 0) {
				return;
			}
			PHA_GridEditor.Edit({
				gridID: 'gridNarcRec',
				index: index,
				field: field
			});
		},
		onLoadSuccess: function (data) {
			PHA_GridEditor.End('gridNarcRec');
			$(this).datagrid('uncheckAll');
		}
	};
	PHA.Grid('gridNarcRec', dataGridOption);
}

/*
 * �������
 */
function Query() {
	// ��ѯ����
	var formDataArr = PHA.DomData('#gridNarcRecBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	// ��δ����
	formData.destroyState = 'N';
	// Ĭ�ϻ�����Ϣ
	var winFormDataArr = PHA.DomData('#win_layout', {
		doType: 'query',
		retType: 'Json'
	});
	var winFormData = winFormDataArr[0];
	for (var k in winFormData) {
		if (!formData[k]) {
			formData[k] = winFormData[k];
		}
	}
	formData.hospId = session['LOGON.HOSPID'];
	var InputStr = JSON.stringify(formData);
	// ��ѯ
	$('#gridNarcRec').datagrid('query', {
		InputStr: InputStr
	});
}

function Clear() {
	PHA.DomData('#gridNarcRecBar', {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Rec.StDate']));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Rec.EdDate']));
	$('#gridNarcRec').datagrid('clear');
	InitDictVal();
}

function Save() {
	if (checkAuth() == false) {
		return;
	}
	
	// ��ȡ��������
	PHA_GridEditor.End('gridNarcRec');
	var checkedData = $('#gridNarcRec').datagrid('getChecked');
	if (checkedData == null || checkedData.length == 0) {
		PHA.Popover({
			msg: '�빴ѡ��Ҫ���յ�ִ�м�¼!',
			type: 'alert'
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridNarcRec', checkedData);
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	var recLocId = $('#recLocId').combobox('getValue') || '';
	if (recLocId == '') {
		PHA.Popover({
			msg: '��ѡ����տ���!',
			type: 'alert'
		});
		return;
	}
	var recUserId = session['LOGON.USERID'];
	var saveData = [];
	for (var i = 0; i < checkedData.length; i++) {
		var oneChekedData = checkedData[i];
		oneChekedData.recLocId = recLocId;
		oneChekedData.recUserId = recUserId;
		saveData.push(oneChekedData);
	}
	var jsonDataStr = JSON.stringify(saveData);
	var saveRetStr = tkMakeServerCall('PHA.IN.NarcRec.Save', 'SaveMulti', jsonDataStr);
	var saveRetArr = saveRetStr.split('^');
	if (saveRetArr[0] < 0) {
		PHA.Alert('��ʾ', saveRetArr[1], saveRetArr[0]);
	} else {
		PHA.Popover({
			msg: '���ճɹ�!',
			type: 'success'
		});
		Query();
	}
}

function Cancel() {
	if (checkAuth() == false) {
		return;
	}
	
	PHA_GridEditor.End('gridNarcRec');
	var checkedData = $('#gridNarcRec').datagrid('getChecked');
	if (checkedData == null || checkedData.length == 0) {
		PHA.Popover({
			msg: '�빴ѡ��Ҫ������ִ�м�¼!',
			type: 'alert'
		});
		return;
	}
	var recLocId = $('#recLocId').combobox('getValue') || '';
	if (recLocId == '') {
		PHA.Popover({
			msg: '��ѡ����տ���!',
			type: 'alert'
		});
		return;
	}
	var recUserId = session['LOGON.USERID'];

	var pJsonArr = [];
	for (var i = 0; i < checkedData.length; i++) {
		var oneRowData = checkedData[i];
		var recState = oneRowData.recState;
		if (recState != 'Y') {
			PHA.Popover({
				msg: '��' + (i + 1) + "��,����״̬�����ѻ���,�޷��������գ�",
				type: 'alert'
			});
			return;
		}
		pJsonArr.push({
			pinr: oneRowData.pinr,
			userId: recUserId,
			locId: recLocId
		});
	}
	var pJsonStr = JSON.stringify(pJsonArr);

	var saveRetStr = tkMakeServerCall('PHA.IN.NarcRec.Save', 'CancelRecMulti', pJsonStr);
	var saveRetArr = saveRetStr.split('^');
	if (saveRetArr[0] < 0) {
		PHA.Alert('��ʾ', saveRetArr[1], saveRetArr[0]);
	} else {
		PHA.Popover({
			msg: '�����ɹ�!',
			type: 'success'
		});
		Query();
	}
}

function OpenDetailWin(index) {
	var rowsData = $('#gridNarcRec').datagrid('getRows');
	var rowData = rowsData[index];
	var oeore = rowData.oeore || '';
	PHA_UX.DetailWin({
		id: 'PHA_WIN_INFO',
		title: 'ҽ����ϸ��Ϣ',
		width: 500,
		height: 560,
		labelWidth: 120,
		queryParams: {
			ClassName: 'PHA.IN.Narc.Com',
			MethodName: 'GetOrderWinInfo',
			oeore: oeore
		}
	});
}

function ReadCard() {
	PHA_COM.ReadCard({
		CardNoId: 'cardNo',
		PatNoId: 'patNo'
	}, function (readRet) {
		Query();
	});
}

/*
 * Grid Editors for this page
 */
var GridEditors = {
	// ������Դ����
	recOriType: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=OriType',
		}
	},
	// �û�
	UserInfo: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: PHA_STORE.Url + 'ClassName=PHA.STORE.Org&QueryName=SSUser&LocId=' + session['LOGON.CTLOCID'],
			onBeforeLoad: function (param) {
				param.QText = param.q;
			}
		}
	},
	// ��������
	LocInfo: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: PHA_STORE.CTLoc().url,
			onBeforeLoad: function (param) {
				param.QText = param.q;
			}
		}
	},
	// ����������� (�����ֵ�)
	DSCD: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=ComDic',
			onBeforeLoad: function (param) {
				var scdiType = 'NARCDealAdvice';
				var valType = 'RowId';
				var QText = param.q || '';
				param.InputStr = scdiType + '^' + valType + '^' + QText;
			}
		}
	}
}

function InputRecInfo() {
	var winId = 'Win_Input';
	var winContentId = 'Win_Input_Content';
	if ($('#' + winId).length == 0) {
		$('<div id="' + winId + '"></div>').appendTo('body');
		$('#' + winId).dialog({
			width: 320,
			height: 407,
			modal: true,
			title: '¼�������Ϣ',
			iconCls: 'icon-w-edit',
			content: $('#win_content_html').html(),
			closable: true,
			onClose: function () {},
			buttons: [{
					text: 'ȷ��',
					handler: function () {
						$('#' + winId).dialog('close');
						Query();
					}
				}, {
					text: '��¼',
					handler: ClearWinDict
				}
			]
		});
		// ��ʽ�޸�
		var dialogBody = $('#' + winId).dialog('body').children().eq(0).children().eq(0).children().eq(0);
		dialogBody.parent().addClass('pha-scrollbar-hidden');
		dialogBody.addClass('pha-body');
		dialogBody.addClass('pha-scrollbar-hidden-chl');
		dialogBody.parent().css('overflow', 'hidden');
		// ��ʼ����
		InitWinDict();
	}
	$('#' + winId).dialog('open');
}
function InitWinDict() {
	// ���պ˶���
	PHA.ComboBox('recCheckUserId', {
		url: PHA_STORE.Url + 'ClassName=PHA.STORE.Org&QueryName=SSUser&LocId=' + session['LOGON.CTLOCID'],
		onHidePanel: function () {
			var recCheckUserId = $('#recCheckUserId').combobox('getValue');
			if (recCheckUserId != '') {
				$('#recFromUserName').focus();
			}
		}
	});
	// ������
	$('#recFromUserName').on('keydown', function (e) {
		if (e.keyCode == 13 && $('#recFromUserName').val() != '') {
			$('#recFromUserTel').focus();
		}
	});
	// ��������ϵ��ʽ
	$('#recFromUserTel').on('keydown', function (e) {
		if (e.keyCode == 13 && $('#recFromUserTel').val() != '') {
			$('#recOriType').next().children().eq(0).focus();
			$('#recOriType').combobox('showPanel');
		}
	});
	// ������Դ����
	PHA.ComboBox('recOriType', $.extend({}, GridEditors.recOriType.options, {
			onShowPanel: function () {},
			onSelect: function () {
				var recOriType = $('#recOriType').combobox('getValue');
				if (recOriType != '') {
					$('#recOriLocId').next().children().eq(0).focus();
					$('#recOriLocId').combobox('showPanel');
				}
			}
		})
	);
	// ������Դ����
	PHA.ComboBox('recOriLocId', $.extend({}, GridEditors.LocInfo.options, {
			onShowPanel: function () {},
			onSelect: function () {
				var recOriType = $('#recOriLocId').combobox('getValue');
				if (recOriType != '') {
					$('#DSCD').next().children().eq(0).focus();
					$('#DSCD').combobox('showPanel');
				}
			}
		})
	);
	// ������Դ����
	PHA.ComboBox('DSCD', $.extend({}, GridEditors.DSCD.options, {
			onShowPanel: function () {},
			onSelect: function () {
				var DSCD = $('#DSCD').combobox('getValue');
				if (DSCD != '') {
					$('#DSCDExeUserId').next().children().eq(0).focus();
					$('#DSCDExeUserId').combobox('showPanel');
				}
			}
		})
	);
	// ����ִ����
	PHA.ComboBox('DSCDExeUserId', $.extend({}, GridEditors.UserInfo.options, {
			onShowPanel: function () {},
			onSelect: function () {
				var DSCDCheckUserId = $('#DSCDExeUserId').combobox('getValue');
				if (DSCDCheckUserId != '') {
					$('#DSCDSuperUserId').next().children().eq(0).focus();
					$('#DSCDSuperUserId').combobox('showPanel');
				}
			}
		})
	);
	// ���ռල��
	PHA.ComboBox('DSCDSuperUserId', $.extend({}, GridEditors.UserInfo.options, {
			onShowPanel: function () {},
			onHidePanel: function () {}
		})
	);
}
function ClearWinDict() {
	PHA.DomData('#win_layout', {
		doType: 'clear'
	});
}

// ������Ȩ��
function checkAuth(){
	// ��֤�ٴ����ҵĻ���Ȩ��
	var locType = tkMakeServerCall('PHA.IN.Narc.Com', 'GetLocType', session['LOGON.CTLOCID']);
	if (PHA_COM.VAR.CONFIG['Rec.DocRec'] != 'Y') {
		if (locType != 'D') {
			PHA.Alert('��ʾ', 'ϵͳ�������ٴ����Ҳ�������գ��������û��չ�������ϵ��Ϣ�ơ�', -1);
			return false;
		}
	}
	if (PHA_COM.VAR.CONFIG['Rec.UseSimple'] == 'Y') {
		//if (locType != 'D') {
			PHA.Alert('��ʾ', 'ϵͳ�������ٴ�����ʹ�á���桿�Ǽǲ����գ�����Ҫ�������գ�', -1);
			return false;
		//}
	}
	true;
}

// ������Ϣ
function showHelpWin() {
	var winId = 'Win_Help';
	var winContentId = 'Win_Help_Content';
	if ($('#' + winId).length == 0) {
		$('<div id="' + winId + '"></div>').appendTo('body');
		$('#' + winId).dialog({
			width: 990,
			height: 640,
			modal: true,
			title: '������Ϣ',
			iconCls: 'icon-w-list',
			content: GetHelpContentHtml(),
			closable: true,
			onClose: function () {}
		});
		// ��ʽ�޸�
		var dialogBody = $('#' + winId).dialog('body').children().eq(0).children().eq(0).children().eq(0);
		dialogBody.parent().addClass('pha-scrollbar-hidden');
		//dialogBody.addClass('pha-body');
		dialogBody.css('padding', 10);
		//dialogBody.addClass('pha-scrollbar-hidden-chl');
		dialogBody.children().eq(0).width(dialogBody.width() - 22);
	}
	$('#' + winId).dialog('open');
}
function GetHelpContentHtml() {
	var contentHtml = '';
	contentHtml += '<div class="hisui-panel" style="padding:0 10px 10px 10px;">';
	// ��������
	contentHtml += '	<div class="kw-chapter"><a></a>' + $g('��������') + '</div><div class="kw-line"></div>';
	contentHtml += '	<b>' + $g('¼�������Ϣ') + '</b> ';
	contentHtml += '	<label style="color:red">��</label> <b>' + $g('��ѯ') + '</b> ';
	contentHtml += '	<label style="color:red">��</label> <b>' + $g('�˶Լ��޸ı���еĻ�����Ϣ') + '</b> ';
	contentHtml += '	<label style="color:red">��</label> <b>' + $g('����') + '</b> ';
	contentHtml += '	<br/>';
	//contentHtml += '	<br/>';
	// ��ѯ˵��
	contentHtml += '	<div class="kw-chapter"><a></a>' + $g('��ѯ') + '</div><div class="kw-line"></div>';
	contentHtml += '	' + $g('��ѯ��������,���ʵ����������') + ' <br/>';
	contentHtml += '	1��' + $g('�Ƿ�����ҩ�Ǽǣ��ý���ֻ��ѯ�Ѿ���ҩ�Ǽǵ�ִ�м�¼���ݣ������Խ���ѡ�������Ϊ׼��') + ' <br/>';
	contentHtml += '	2��' + $g('���տ��ң������տ����Ƿ���ȷ��') + ' <br/>';
	contentHtml += '	3��' + $g('����״̬��������״̬�Ƿ���ȷ��') + ' <br/>';
	contentHtml += '	4��' + $g('�ǼǺ�/���ţ����ǼǺŻ��߿����Ƿ���ȷ��') + ' <br/>';
	contentHtml += '	5��' + $g('�������ң����ѡ��Ŀ��������Ƿ���ȷ��') + ' <br/>';
	contentHtml += '	6��' + $g('ҩƷ��ҩƷ���ƣ�') + ' <br/>';
	contentHtml += '	7��' + $g('���ţ���ҩʱ¼������Ż�����ҩ�Ǽǵ����ţ�') + ' <br/>';
	contentHtml += '	8��' + $g('��������ҽ��ʱ�������ڵĲ����Ƿ���ȷ��') + ' <br/>';
	contentHtml += '	' + $g('�����ѯ��ǰ���ۺϲ�ѯ���档') + '<br/>';
	//contentHtml += '	<br/>';
	// ����˵��
	contentHtml += '	<div class="kw-chapter"><a></a>' + $g('����') + '</div><div class="kw-line"></div>';
	contentHtml += '	' + $g('����֮ǰ��Ҫ¼��������'+GetEditTitle("")+'���ֶΣ�����Ϊ˵��') + '��<br/>';
	contentHtml += '	1��' + $g('�������ţ������ֶΣ�Ĭ��Ϊ��ҩ�Ǽ�ʱ��д�����ţ�Ҳ�����Լ��ֶ����룻���ֶο����ڲ�����������Ϊ������¼�롣') + ' <br/>';
	contentHtml += '	2��' + $g('�հ�������������ֶΣ���ʾ���յĿհ�곻������������λΪ������λ��') + ' <br/>';
	contentHtml += '	3��' + $g('Һ������������ֶΣ���ʾ����ҩƷ����ʱ�Ĳ���������λΪ������λ��Ĭ��Ϊ��ҩ����-��ҽ��������') + ' <br/>';
	//contentHtml += '	<br/>';
	// ����˵��
	contentHtml += '	<div class="kw-chapter"><a></a>' + $g('����') + '</div><div class="kw-line"></div>';
	contentHtml += '	1��' + $g('���յĶ��󣺻��յĶ�����Ҫ�ǿհ��/�����Ͳ���ҩҺ������ҽԺ����ҩҺ��ʹ��֮��ֱ�Ӵ���������գ�') + ' <br/>';
	contentHtml += '	2��' + $g('�հ�곣��հ����װҺ���඾��ҩƷ��������һ��Сƿ�ӣ�') + ' <br/>';
	contentHtml += '	3��' + $g('�������ǿڷ���Ķ���ҩƷ���磺��̫��͸Ƥ������ʹ�ú�����һ��������') + ' <br/>';
	contentHtml += '	4��' + $g('����һ��գ������������һ��գ�����ÿ�����Ҷ�ֻ�������һ�Ρ���: ����ƻ��������һ���֮�󣬽��հ������ҩ����ҩ�������ٴβ������ա�') + ' <br/>';
	contentHtml += '</div>';

	return contentHtml;
}

function GetEditTitle(title) {
	return title;
}

function InitConfig() {
	PHA_COM.VAR.CONFIG = $.cm({
		ClassName: 'PHA.IN.Narc.Com',
		MethodName: 'GetConfigParams',
		InputStr: PHA_COM.Session.ALL
	}, false);
}