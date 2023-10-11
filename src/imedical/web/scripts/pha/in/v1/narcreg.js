/**
 * ����:   	 ҩ��ҩ��-����ҩƷʹ�õǼ�
 * ��д��:   Huxiaotian
 * ��д����: 2020-08-07
 * csp:		 pha.in.v1.narcreg.csp
 * js:		 pha/in/v1/narcreg.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = 'ҩ��';
PHA_COM.App.Csp = 'pha.in.v1.narcreg.csp';
PHA_COM.App.Name = $g('����ҩƷʹ�õǼ�');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};
PHA_COM.VAR.SetDefaultTask = null;

$(function () {
	$('#panelNarcReg').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('����ҩƷ��ҩ�Ǽ�') : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-template',
		bodyCls: 'panel-body-gray',
		fit: true
	});

	InitDict();
	InitGridNarcReg();
	InitEvents();
	InitConfig();
});

// ��ʼ�� - ���ֵ�
function InitDict() {
	$('#patNo').val(patNo);
	PHA.ComboBox('docLocId', {
		width: 154,
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox('wardLocId', {
		url: PHA_STORE.CTLoc().url + '&TypeStr=W&HospId=' + session['LOGON.HOSPID']
	});
	PHA.ComboBox('phLocId', {
		width: 154,
		url: PHA_STORE.CTLoc().url + '&TypeStr=D&HospId=' + session['LOGON.HOSPID']
	});
	PHA.ComboBox("regState", {
		url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=RegStatus',
		panelHeight: 'auto'
	});
	PHA.ComboBox('dspState', {
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

	PHA.ComboBox('poisonIdStr', {
		url: PHA_STORE.PHCPoison().url,
		multiple: true,
		rowStyle: 'checkbox',
		selectOnNavigation: false,
		onLoadSuccess: function (data) {
			var thisOpts = $('#poisonIdStr').combobox('options');
			thisOpts.isLoaded = true;
		}
	});

	// ҩƷ����
	var inciOptions = PHA_STORE.INCItm();
	inciOptions.url = $URL;
	inciOptions.width = 160;
	PHA.ComboGrid('inci', inciOptions);
	
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('regState', 'N');
}

// ��ʼ�� - �¼���
function InitEvents() {
	$('#btnFind').on('click', Query);
	$('#btnClear').on('click', Clear);
	$('#btnSave').on('click', Save);
	$('#btnCancel').on('click', Cancel);

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
}

// ��ʼ�� - ���
function InitGridNarcReg() {
	var columns = [
		[{
				field: 'tSelect',
				checkbox: true
			}, {
				title: '����ID',
				field: 'adm',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: 'ҽ��ID',
				field: 'oeori',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: 'ִ�м�¼ID',
				field: 'oeore',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '�����ID',
				field: 'dspId',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '�ǼǺ�',
				field: 'patNo',
				width: 110,
				align: 'center',
				formatter: function (value, rowData, index) {
					return '<a style="border:0px;cursor:pointer" onclick="">' + value + '</a>';
				}
			}, {
				title: '��������',
				field: 'patName',
				width: 100,
				align: 'center'
			}, {
				title: '�������֤',
				field: 'IDCard',
				width: 170,
				align: 'left',
				hidden: true
			}, {
				title: 'ҩƷ����',
				field: 'inciCode',
				width: 120,
				align: 'center',
				hidden: true
			}, {
				title: 'ҩƷ����',
				field: 'inciDesc',
				width: 200,
				align: 'left',
				showTip: true,
				tipWidth: 200
			}, {
				title: '��ҩ����',
				field: 'dspQty',
				width: 70,
				align: 'center'
			}, {
				title: '��λ',
				field: 'dspUomDesc',
				width: 70,
				align: 'center'
			}, {
				title: '����ҩƷ���',
				field: 'inciNo',
				width: 100,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				title: GetEditTitle('ҩƷ����'),
				field: 'inciBatchNo',
				width: 100,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}, {
				title: '������',
				field: 'operRoomId',
				descField: 'operRoom',
				width: 100,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['operRoom'];
				},
				editor: PHA_GridEditor.ComboBox({
					mode: 'remote',
					url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=OPRoom&HospId=' + session['LOGON.HOSPID'],
					onBeforeLoad: function (param) {
						param.QText = param.q;
					}
				})
			}, {
				title: '����ҽʦ',
				field: 'narcDocUserId',
				descField: 'narcDocUserName',
				width: 100,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['narcDocUserName'];
				},
				editor: PHA_GridEditor.ComboBox({
					mode: 'remote',
					url: PHA_STORE.Url + 'ClassName=PHA.STORE.Org&QueryName=Doctor&HospId=' + session['LOGON.HOSPID'],
					onBeforeLoad: function (param) {
						param.QText = param.q;
					}
				})
			}, {
				title: '������λ',
				field: 'doseUomDesc',
				width: 75,
				align: 'center'
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
				title: ('��������'),
				field: 'machineCode',
				width: 100,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				title: ('��ע'),
				field: 'remarks',
				width: 120,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({
					onBeforeNext: function (val, gridRowData, gridRowIdex) {
						// ���һ�����һ��
						if (PHA_GridEditor.IsLastRow()) {
							PHA_GridEditor.End('gridNarcReg');
							return false;
						}
						return true;
					}
				})
			}, {
				title: '�ƻ�ִ��ʱ��',
				field: 'dosingDT',
				width: 150,
				align: 'center'
			}, {
				title: '��ҩ״̬',
				field: 'dspStatusDesc',
				width: 75,
				align: 'center'
			}, {
				title: '�Ǽ�״̬',
				field: 'regStateDesc',
				width: 75,
				align: 'center'
			}, {
				title: '�Ǽǿ���',
				field: 'regLocDesc',
				width: 140,
				align: 'left'
			}, {
				title: '�Ǽ���',
				field: 'regUserName',
				width: 100,
				align: 'left'
			}, {
				title: '�Ǽ�����',
				field: 'regDate',
				width: 90,
				align: 'left'
			}, {
				title: '�Ǽ�ʱ��',
				field: 'regTime',
				width: 90,
				align: 'left'
			}, {
				title: '��ʿִ��ʱ��',
				field: 'exeDT',
				width: 150,
				align: 'center'
			}, {
				title: '����ҽ��',
				field: 'ordUserName',
				width: 100,
				align: 'center'
			}, {
				title: '��������',
				field: 'docLocDesc',
				width: 110,
				align: 'center'
			}, {
				title: '����',
				field: 'wardLocDesc',
				width: 110,
				align: 'center'
			}, {
				title: '��������',
				field: 'admType',
				width: 75,
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
				title: '����',
				field: 'pinr',
				width: 100,
				align: 'left',
				hidden: true
			}
		]
	];
	var dataGridOption = {
		url: $URL,
		queryParams: {
			ClassName: 'PHA.IN.NarcReg.Query',
			QueryName: 'NarcReg'
		},
		singleSelect: false,
		pagination: true,
		columns: columns,
		toolbar: '#gridNarcRegBar',
		isCellEdit: false,
		isAutoShowPanel: true,
		editFieldSort: ['inciNo', 'inciBatchNo', 'operRoomId', 'narcDocUserId', 'useQty', 'machineCode', 'remarks'],
		onClickCell: function (index, field, value) {
			if (field == 'patNo') {
				OpenDetailWin(index);
				return;
			}
			if (!PHA_GridEditor.End('gridNarcReg')) {
				return;
			}
			PHA_GridEditor.Edit({
				gridID: 'gridNarcReg',
				index: index,
				field: field
			});
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
	// ��ȡ����
	var formDataArr = PHA.DomData('#gridNarcRegBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	formData.hospId = session['LOGON.HOSPID'];
	// ��ѯ
	var InputStr = JSON.stringify(formData); ;
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
	InitDictVal();
	$('#gridNarcReg').datagrid('clear');
}

function Save() {
	if (PHA_COM.VAR.CONFIG['Reg.AutoReg'] == 'Y') {
		//PHA.Alert('��ʾ', 'ϵͳ������Ϊ��ҩ�Զ��Ǽǣ��޷��ֶ���ӣ�', -1);
		//return;
	}
	if (PHA_COM.VAR.CONFIG['Rec.UseSimple'] == 'Y') {
		PHA.Alert('��ʾ', 'ϵͳ������Ϊʹ�á���桿�Ǽǣ�', -1);
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
	var regLocId = session['LOGON.CTLOCID'];
	var regUserId = session['LOGON.USERID'];
	var saveData = [];
	for (var i = 0; i < checkedData.length; i++) {
		var oneChekedData = checkedData[i];
		oneChekedData.regLocId = regLocId;
		oneChekedData.regUserId = regUserId;
		saveData.push(oneChekedData);
	}
	var jsonDataStr = JSON.stringify(saveData);
	var saveRetStr = tkMakeServerCall('PHA.IN.NarcReg.Save', 'SaveMulti', jsonDataStr);
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

function Cancel() {
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

	var pJsonArr = [];
	for (var i = 0; i < checkedData.length; i++) {
		var oneRowData = checkedData[i];
		var regState = oneRowData.regState;
		if (regState != 'Y') {
			PHA.Popover({
				msg: '��' + (i + 1) + "��,�Ǽ�״̬�����ѵǼ�,�޷������Ǽǣ�",
				type: 'alert'
			});
			return;
		}
		pJsonArr.push({
			pinr: oneRowData.pinr,
			userId: recUserId
		});
	}
	var pJsonStr = JSON.stringify(pJsonArr);
	
	PHA.Confirm("��ܰ��ʾ", "�Ƿ�ȷ�ϳ����Ǽǣ�", function () {
		var saveRetStr = tkMakeServerCall('PHA.IN.NarcReg.Save', 'CancelRegMulti', pJsonStr);
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

function InitConfig() {
	$.cm({
		ClassName: 'PHA.IN.Narc.Com',
		MethodName: 'GetConfigParams',
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// ���ݸ�ȫ��
		PHA_COM.VAR.CONFIG = retJson;
		$('#startDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.StDate']));
		$('#endDate').datebox('setValue', PHA_UTIL.SysDate(PHA_COM.VAR.CONFIG['Reg.EdDate']));
		PHA.SetComboVal('poisonIdStr', PHA_COM.VAR.CONFIG['Com.PoisonIdStr'] || '');
		if (PHA_COM.VAR.CONFIG['Reg.NeedDisp'] == 'Y') {
			$('#dspState').combobox('disable');
			$('#dspState').combobox('setValue', 'Y');
		}
		if (PHA_COM.VAR.CONFIG["WardFlag"] === "Y"){
			$('#wardLocId').combobox('setValue', session['LOGON.CTLOCID']);
		} else if (PHA_COM.VAR.CONFIG["LocType"] !== "D"){
			$('#docLocId').combobox('setValue', session['LOGON.CTLOCID']);
		}
		// �Զ���ѯ
		if (patNo != '') {
			Query();
		}
	}, function (error) {
		console.dir(error);
		alert(error.responseText);
	});
}

function GetEditTitle(title) {
	return title;
	//return '<label style="color:red;">*</label>' + $g(title);
}