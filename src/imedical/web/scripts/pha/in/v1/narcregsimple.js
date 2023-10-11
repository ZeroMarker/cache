/**
 * ����:   	 ҩ��ҩ��-����ҩƷʹ�õǼ�
 * ��д��:   Huxiaotian
 * ��д����: 2020-08-07
 * csp:		 pha.in.v1.narcregsimple.csp
 * js:		 pha/in/v1/narcregsimple.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narcregsimple.csp';
PHA_COM.App.Name = $g('����ҩƷʹ�õǼ�[���]');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};
PHA_COM.VAR.SetDefaultTask = null;

$(function () {
	InitConfig();
	
	$('#panelNarcReg').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('����ҩƷ��ҩ�Ǽǡ���桿') : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-template',
		bodyCls: 'panel-body-gray',
		fit: true
	});
	PHA_COM.ResizePhaCol({});

	InitDict();
	InitGridNarcReg();
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
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.StDate']));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.EdDate']));
	$('#patNo').val(patNo);
	
	PHA.ComboBox('docLocId', {
		width: 145,
		url: PHA_STORE.DocLoc().url
	});
	
	PHA.ComboBox('wardLocId', {
		width: 145,
		url: PHA_STORE.CTLoc().url + '&TypeStr=W&HospId=' + session['LOGON.HOSPID']
	});
	
	PHA.ComboBox('phLocId', {
		width: 145,
		url: PHA_STORE.CTLoc().url + '&TypeStr=D&HospId=' + session['LOGON.HOSPID']
	});
	
	PHA.ComboBox('regState', {
		width: 145,
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=RegStatus',
		panelHeight: 'auto'
	});
	
	PHA.ComboBox('dspState', {
		width: 145,
		data: [{
				RowId: 'Y',
				Description: $g('�ѷ�ҩ')
			}, {
				RowId: 'N',
				Description: $g('δ��ҩ')
			}
		],
		panelHeight: 'auto'
	});
	if (PHA_COM.VAR.CONFIG['Reg.NeedDisp'] == 'Y') {
		$('#dspState').combobox('disable');
		$('#dspState').combobox('setValue', 'Y');
	}
	
	PHA.ComboBox('poisonIdStr', {
		width: 145,
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false,
		onLoadSuccess: function (data) {
			var thisOpts = $('#poisonIdStr').combobox('options');
			thisOpts.isLoaded = true;
		}
	});
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr'] || '');
	
	// ҩƷ����
	var inciOptions = PHA_STORE.INCItm();
	inciOptions.url = $URL;
	inciOptions.width = 145;
	PHA.ComboGrid('inci', inciOptions);
	// Ĭ�Ͽ�������/����������
	if (PHA_COM.VAR.CONFIG["WardFlag"] === "Y"){
		$('#wardLocId').combobox('setValue', session['LOGON.CTLOCID']);
	} else if (PHA_COM.VAR.CONFIG["LocType"] !== "D"){
		$('#docLocId').combobox('setValue', session['LOGON.CTLOCID']);
	}	

	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('regState', 'N');
}

// ��ʼ�� - �¼���
function InitEvents() {
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

	$('#btnFind').on('click', Query);
	$('#btnClear').on('click', Clear);
	$('#btnExport').on('click', Export);
	$('#btnPrint').on('click', Print);

	$('#btnSave').on('click', Save);
	$('#btnCancel').on('click', Cancel);
	$('#btnInput').on('click', InputRecInfo);
}

// ��ʼ�� - ���
function InitGridNarcReg() {
	// �����Ƿ���Ա༭
	var batchNoEditor = PHA_GridEditor.ValidateBox({
		required: true,
		disabled: PHA_COM.VAR.CONFIG['Rec.InputBatNo'] == 'N' ? true : false
	});
	var editFieldSort = batchNoEditor 
	? ['inciBatchNo', 'operRoomId', 'narcDocUserId', 'machineCode', 'useQty', 'recFluidQty', 'recQty', 'remarks'] 
	: ['operRoomId', 'narcDocUserId', 'machineCode', 'useQty', 'recFluidQty', 'recQty', 'remarks'];
	
	// ����Ϣ
	var columns = [
		[{
				field: 'tSelect',
				checkbox: true
			}, {
				title: '�����¼����',
				field: 'adm',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: 'ҽ������',
				field: 'oeore',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '���������',
				field: 'dspId',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '����',
				field: 'dosingDT',
				width: 150,
				align: 'center'
			}, {
				title: '�ǼǺ�',
				field: 'patNo',
				width: 110,
				align: 'center',
				formatter: function (value, rowData, index) {
					return '<a style="border:0px;cursor:pointer" onclick="">' + value + '</a>'
				}
			}, {
				title: '��������',
				field: 'patName',
				width: 100
			}, {
				title: '�Ա�',
				field: 'patSex',
				width: 170,
				hidden: true
			}, {
				title: '����',
				field: 'patAge',
				width: 170,
				hidden: true
			}, {
				title: '���֤��',
				field: 'IDCard',
				width: 170,
				hidden: true
			}, {
				title: 'ҩƷ����',
				field: 'inciDesc',
				width: 200,
				align: 'left',
				showTip: true,
				tipWidth: 200
			}, {
				title: '���',
				field: 'inciSpec',
				width: 100,
				align: 'center'
			}, {
				title: '��λ',
				field: 'dspUomDesc',
				width: 70,
				align: 'center'
			}, {
				title: '����',
				field: 'dspQty',
				width: 70,
				align: 'center'
			}, {
				title: GetEditTitle('����'),
				field: 'inciBatchNo',
				width: 100,
				align: 'left',
				editor: batchNoEditor
			}, {
				title: ('������'),
				field: 'operRoomId',
				descField: 'operRoom',
				width: 100,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['operRoom'];
				},
				editor: PHA_GridEditor.ComboBox({
					mode: 'remote',
					url: $URL + '?ClassName=PHA.IN.Narc.Com&QueryName=OPRoom&ResultSetType=array&HospId=' + session['LOGON.HOSPID'],
					onBeforeLoad: function (param) {
						param.QText = param.q;
					}
				})
			}, {
				title: GetEditTitle('����ҽʦ'),
				field: 'narcDocUserId',
				descField: 'narcDocUserName',
				width: 100,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['narcDocUserName'];
				},
				editor: PHA_GridEditor.ComboBox({
					required: true,
					regExp: /\S/,
					regTxt: '����Ϊ��!',
					mode: 'remote',
					url: PHA_STORE.Url + 'ClassName=PHA.STORE.Org&QueryName=Doctor&HospId=' + session['LOGON.HOSPID'],
					onBeforeLoad: function (param) {
						param.QText = param.q;
					}
				})
			}, {
				title: ('��������'),
				field: 'machineCode',
				width: 100,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				title: '����ҽʦ',
				field: 'ordUserName',
				width: 100,
				align: 'left'
			}, {
				title: '������λ',
				field: 'doseUomDesc',
				width: 75,
				align: 'left'
			}, {
				title: 'ҽ������',
				field: 'doseQty',
				width: 75,
				align: 'right'
			}, {
				title: GetEditTitle('ʵ����ҩ��'),
				field: 'useQty',
				width: 90,
				align: 'right',
				editor: PHA_GridEditor.ValidateBox({
					required: true,
					checkValue: function (val, chkRet) {
						var nVal = parseFloat(val);
						if (isNaN(nVal)) {
							chkRet.msg = "���������֣�";
							return false;
						}
						if (nVal < 0) {
							chkRet.msg = "���������0�����֣�";
							return false;
						}
						return true;
					}
				})
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
						return true;
					}
				})
			}, {
				title: ('��ע'),
				field: 'remarks',
				width: 120,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({
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
				title: 'Ƶ��',
				field: 'freqDesc',
				width: 70
			}, {
				title: '�Ƴ�',
				field: 'duratDesc',
				width: 70
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
				title: GetEditTitle('��������ִ����'),
				field: 'DSCDExeUserId',
				descField: 'DSCDExeUserName',
				width: 120,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['DSCDExeUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: GetEditTitle('��������ල��'),
				field: 'DSCDSuperUserId',
				descField: 'DSCDSuperUserName',
				width: 120,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['DSCDSuperUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: GetEditTitle('�հ�곻���(����)��'),
				field: 'recUserId',
				descField: 'recUserName',
				width: 140,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['recUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: '�ٴ����',
				field: 'MRDiagnos',
				width: 180,
				align: 'left'
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.NarcReg.Simple',
			QueryName: 'NarcRegSimple'
		},
		singleSelect: false,
		pagination: true,
		columns: columns,
		toolbar: '#gridNarcRegBar',
		isCellEdit: false,
		isAutoShowPanel: true,
		editFieldSort: editFieldSort,
		onClickCell: function (index, field, value) {
			if (field == 'patNo') {
				OpenDetailWin(index);
				return;
			}
			if (!PHA_GridEditor.End('gridNarcReg')) {
				return;
			}
			if (editFieldSort.indexOf(field) < 0) {
				return;
			}
			PHA_GridEditor.Edit({
				gridID: 'gridNarcReg',
				index: index,
				field: field
			});
			// ������Ϊ��ʱ�����ܲ�������ΪN��Ҳ�ܶ����Ž����޸�
			if ((value === "") && (PHA_COM.VAR.CONFIG['Rec.InputBatNo'] == 'N')){
				var batchNoEd = $(this).datagrid('getEditor', {
					index: index,
					field: "inciBatchNo"
				});
				$(batchNoEd.target).validatebox({"disabled": false});
			}
		},
		onLoadSuccess: function (data) {
			PHA_GridEditor.End('gridNarcReg');
			$(this).datagrid('uncheckAll');
		}
	};
	PHA.Grid('gridNarcReg', dataGridOption);
}

/*
 * �������
 */
function Query() {
	// ������
	var formDataArr = PHA.DomData('#gridNarcRegBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];

	// Ĭ����Ϣ
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
	formData.recLocId = session['LOGON.CTLOCID'];
	formData.recState = formData.regState; // ��� - �Ǽ�&����״̬��ͬ���� TODO...
	formData.hospId = session['LOGON.HOSPID'];
	if (!formData.recLocId) {
		return;
	}
	
	// ��ѯ
	var InputStr = JSON.stringify(formData);
	$('#gridNarcReg').datagrid('query', {
		InputStr: InputStr
	});
}

function Clear() {
	PHA.DomData('#gridNarcRegBar', {
		doType: 'clear'
	});
	$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.StDate']));
	$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.EdDate']));
	PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr'] || '');
	if (PHA_COM.VAR.CONFIG['Reg.NeedDisp'] == 'Y') {
		$('#dspState').combobox('disable');
		$('#dspState').combobox('setValue', 'Y');
	}
	$('#gridNarcReg').datagrid('clear');
	InitDictVal();
}

// ���� (�Ǽ�&����)
function Save() {
	if (PHA_COM.VAR.CONFIG['Rec.UseSimple'] != 'Y') {
		PHA.Alert('��ʾ', 'ϵͳδ����ʹ�á���桿�Ǽǣ�', -1);
		return;
	}
	
	PHA_GridEditor.End('gridNarcReg');
	var checkedData = $('#gridNarcReg').datagrid('getChecked');
	if (checkedData == null || checkedData.length == 0) {
		PHA.Popover({
			msg: '�빴ѡ��Ҫ�Ǽǵ�ִ�м�¼!',
			type: 'alert'
		});
		return;
	}
	var chkRetStr = PHA_GridEditor.CheckValues('gridNarcReg', checkedData);
	if (chkRetStr != '') {
		PHA.Popover({
			msg: chkRetStr,
			type: 'alert'
		});
		return;
	}
	
	var sessionLocId = session['LOGON.CTLOCID'];
	var sessionUserId = session['LOGON.USERID'];
	var saveData = [];
	for (var i = 0; i < checkedData.length; i++) {
		var oneChekedData = checkedData[i];
		saveData.push({
			// �Ǽ���Ϣ
			operRoomId: oneChekedData.operRoomId,
			operRoom: oneChekedData.operRoom,
			narcDocUserId: oneChekedData.narcDocUserId,
			useQty: oneChekedData.useQty,
			inciNo: '',
			inciBatchNo: oneChekedData.inciBatchNo,
			dspId: oneChekedData.dspId,
			regLocId: sessionLocId,
			regUserId: sessionUserId,
			isNotCheckRec: 'Y',
			machineCode: oneChekedData.machineCode,
			// ������Ϣ
			oeore: oneChekedData.oeore,
			recOriType: '',
			recOriLocId: '',
			recLocId: sessionLocId,
			recQty: oneChekedData.recQty,
			recFluidQty: oneChekedData.recFluidQty,
			recUserId: oneChekedData.recUserId,
			recCheckUserId: '',
			recFromUserName: '',
			recFromUserTel: '',
			recBatchNo: oneChekedData.inciBatchNo,
			DSCD: oneChekedData.DSCD,
			DSCDExeUserId: oneChekedData.DSCDExeUserId,
			DSCDSuperUserId: oneChekedData.DSCDSuperUserId,
			remarks: oneChekedData.remarks
		});
	}
	var jsonDataStr = JSON.stringify(saveData);

	var saveRetStr = tkMakeServerCall('PHA.IN.NarcReg.Simple', 'SaveSimple', jsonDataStr);
	var saveRetArr = saveRetStr.split('^');
	if (saveRetArr[0] < 0) {
		PHA.Alert('��ʾ', saveRetArr[1], saveRetArr[0]);
	} else {
		PHA.Popover({
			msg: '�Ǽǳɹ�!',
			type: 'success'
		});
		Query();
	}
}

// ��������
function Cancel(){
	PHA_GridEditor.End('gridNarcReg');
	var checkedData = $('#gridNarcReg').datagrid('getChecked');
	if (checkedData == null || checkedData.length == 0) {
		PHA.Popover({
			msg: '�빴ѡ��Ҫ������ִ�м�¼!',
			type: 'alert'
		});
		return;
	}
	var recUserId = session['LOGON.USERID'];
	var recLocId = session['LOGON.CTLOCID'];
	
	var pJsonArr = [];
	for (var i = 0; i < checkedData.length; i++) {
		var oneRowData = checkedData[i];
		var regState = oneRowData.regState;
		console.log(regState)
		if (regState != 'Y') {
			PHA.Popover({
				msg: '����ѡ�ĵ�' + (i + 1) + '�в���[�ѵǼ�]״̬���޷�������',
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
	
	PHA.Confirm("��ܰ��ʾ", "�Ƿ�ȷ�ϳ����Ǽǣ�", function () {
		var saveRetStr = tkMakeServerCall('PHA.IN.NarcReg.Simple', 'CancelSimple', pJsonStr);
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
	});
}

function Export() {
	var rowsData = $('#gridNarcReg').datagrid('getRows') || [];
	if (rowsData.length == 0) {
		PHA.Popover({
			msg: 'û������!',
			type: 'alert'
		});
		return;
	}
	PHA_COM.ExportGrid('gridNarcReg');
}

function Print() {
	var rowsData = $('#gridNarcReg').datagrid('getRows') || [];
	if (rowsData.length == 0) {
		PHA.Popover({
			msg: 'û������!',
			type: 'alert'
		});
		return;
	}
	// ��ȡ����
	var formDataArr = PHA.DomData('#gridNarcRegBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	// ֻ�ܴ�ӡ�ѵǼǵ�
	var regState = formData.regState || '';
	if (regState == '' || regState == 'N') {
		PHA.Popover({
			msg: 'ֻ�ܴ�ӡ�ѵǼǵģ���ѡ��Ǽ�״̬Ϊ�ѵǼ�!',
			type: 'alert'
		});
		return;
	}
	formData.dateType = 'RegDate';
	formData.recLocId = session['LOGON.CTLOCID'];
	formData.recState = formData.regState; // ��� - �Ǽ�&����״̬��ͬ���� TODO...
	formData.hospId = session['LOGON.HOSPID'];
	if (!formData.recLocId) {
		return;
	}
	var InputStr = JSON.stringify(formData);

	// ��ѡ�񴰿�
	ReportTypeWin({
		width: 220,
		height: 160,
		title: '��ѡ�񱨱�����',
		radios: [{
				label: '�ǼǱ���',
				value: 'PHAIN_NarcReport_Reg.raq',
				checked: true
			}, {
				label: '�ۺϱ���',
				value: 'PHAIN_NarcReport_Com.raq'
			}
		],
		onClickSure: function (radioIndex, radioVal, radios) {
			var reportName = radioVal;
			PrintReport(reportName, {
				InputStr: InputStr,
				startDate: formData.startDate,
				endDate: formData.endDate
			});
		}
	});
}

function PrintReport(reportName, args) {
	// ��ǬԤ����ӡ
	var fileName = reportName;
	for (var p in args) {
		fileName += '&' + p + '=' + args[p];
	}
	DHCCPM_RQPrint(fileName, 1280, 640);
}

function ReportTypeWin(_options) {
	var _radiosArr = _options.radios || [];
	var _radioName = 'report_type_radio';
	var _winId = 'report_type_win';
	if ($('#' + _winId).length == 0) {
		$('body').append('<div id="' + _winId + '"></div>');
	}

	// ��������
	_options.closable = true;
	_options.modal = true;
	_options.iconCls = 'icon-w-edit',
	_options.buttons = [{
			text: 'ȷ��',
			handler: function () {
				var checkedRadio = $('input[name="' + _radioName + '"]:checked');
				if (checkedRadio.length == 0) {
					$.messager.popover({
						timeout: 1000,
						msg: '��ѡ�������!',
						type: 'alert'
					});
					return;
				}
				$('#' + _winId).dialog('close');
				var rowIndex = checkedRadio.attr('radioIndex');
				rowIndex = parseInt(rowIndex);
				var radioVal = checkedRadio.val();
				_options.onClickSure && _options.onClickSure(rowIndex, radioVal, _radiosArr);
			}
		}, {
			text: 'ȡ��',
			handler: function () {
				$('#' + _winId).dialog('close');
			}
		}
	];
	$('#' + _winId).dialog(_options);

	// ���ر�������
	var dialogOpts = $('#' + _winId).dialog('options');
	if (!dialogOpts.isLoaded) {
		var dialogBody = $('#' + _winId).dialog('body').children().eq(0).children().eq(0);
		dialogBody.css('margin-left', 71);

		for (var i = 0; i < _radiosArr.length; i++) {
			var oneRadio = _radiosArr[i];
			var radioHtml = '';
			radioHtml += '<div style="margin-top:10px;"><input class="hisui-radio" type="radio" ';
			radioHtml += 'label="' + oneRadio.label + '" ';
			radioHtml += 'value="' + oneRadio.value + '" ';
			radioHtml += 'name="' + _radioName + '" ';
			radioHtml += 'radioIndex="' + i + '" ';
			radioHtml += 'data-options="checked:' + (oneRadio.checked ? 'true' : 'false') + '" ';
			radioHtml += '/> </div>';
			dialogBody.append(radioHtml);
		}
		$.parser.parse('#' + _winId);
		dialogOpts.isLoaded = true;
	}
}

/**
 * ������Ϣ¼�뵯��
 */
function InputRecInfo() {
	var winId = 'Win_Input';
	var winContentId = 'Win_Input_Content';
	if ($('#' + winId).length == 0) {
		$('<div id="' + winId + '"></div>').appendTo('body');
		$('#' + winId).dialog({
			width: 330,
			height: 247,
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
	PHA.ComboBox('DSCDSuperUserId', $.extend({}, GridEditors.UserInfo.options, {
			onShowPanel: function () {},
			onSelect: function () {
				var DSCDSuperUserId = $('#DSCDSuperUserId').combobox('getValue');
				if (DSCDSuperUserId != '') {
					$('#recUserId').next().children().eq(0).focus();
					$('#recUserId').combobox('showPanel');
				}
			}
		})
	);
	PHA.ComboBox('recUserId', {
		url: 'websys.Broker.cls?ResultSetType=Array&ClassName=PHA.STORE.Org&QueryName=SSUser&LocId=' + session['LOGON.CTLOCID'],
		onHidePanel: function () {}
	});
}

function ClearWinDict() {
	PHA.DomData('#win_layout', {
		doType: 'clear'
	});
}

/**
 * ��ϸ��Ϣչʾ
 */
function OpenDetailWin(index) {
	var rowsData = $('#gridNarcReg').datagrid('getRows');
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

/*
 * Grid Editors for this page
 */
var GridEditors = {
	// �û�
	UserInfo: {
		type: 'combobox',
		options: {
			regExp: /\S/,
			regTxt: '����Ϊ��!',
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: 'websys.Broker.cls?ResultSetType=Array&ClassName=PHA.STORE.Org&QueryName=SSUser&LocId=' + session['LOGON.CTLOCID'],
			onBeforeLoad: function (param) {
				param.QText = param.q;
			}
		}
	},
	// �����������(�����ֵ�)
	DSCD: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: $URL + '?ClassName=PHA.IN.Narc.Com&QueryName=ComDic&ResultSetType=array',
			onBeforeLoad: function (param) {
				var scdiType = 'NARCDealAdvice';
				var valType = 'RowId';
				var QText = param.q || '';
				param.InputStr = scdiType + '^' + valType + '^' + QText;
			}
		}
	}
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