/**
 * ����:	 ������Һϵͳ-��������
 * ��д��:	 yunhaibao
 * ��д����: 2019-06-18
 */
PHA_COM.App.Csp = 'pha.opivas.v4.rec.csp';
var REC = {
	Default: [{
			conStDate: 't',
			conEdDate: 't',
			conPack: {
				RowId: '',
				Select: false
			},
			conRecStatus: {
				RowId: 'REQ',
				Select: false
			}
		}
	],
	IntervelTime: 30000
};
var REC_INTERVAL_TIME = REC.IntervelTime;
var REC_DEFAULT = REC.Default;
var REC_INTERVAL;

$(function () {
	var isTabMenu = PHA_COM.IsTabsMenu ? PHA_COM.IsTabsMenu() : false;
	$('#panelRec').panel({
		title: isTabMenu !== true ? '��������' : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-drug-audit',
		bodyCls: 'panel-body-gray',
		fit: true
	});

	InitDict();
	InitGridRec();
	$('#btnFind').on('click', Query);
	$('#btnClean').on('click', Clean);
	$('#btnStart').on('click', function () {
		PHA_OPIVAS_UX.AutoGif('Show');
		clearInterval(REC_INTERVAL); // ˵��׼��������᲻���ظ���ʱ��,������,����
		REC_INTERVAL = setInterval(function () {
			var rows = $('#gridRec').datagrid('getRows');
			if (rows.length == 0) {
				Query();
			}
		}, REC_INTERVAL_TIME);
	});
	$('#btnStop').on('click', function () {
		PHA_OPIVAS_UX.AutoGif('Hide');
		clearInterval(REC_INTERVAL);
	});
	$('#btnPass').on('click', function () {
		SaveDisHandler('REC', '');
	});
	$('#btnRefuse').on('click', function () {
		SaveDisHandler('REF', '');
	});
	$('#btnPack').on('click', function () {
		SaveDisHandler('REC', 'Y');
	});
	$('#btnPivas').on('click', function () {
		SaveDisHandler('REC', 'N');
	});
	$('#conCardNo').on('keypress', function (event) {
		if (window.event.keyCode == '13') {
			var cardNo = $.trim($('#conCardNo').val());
			if (cardNo !== '') {
				ReadCardHandler();
			}
		}
	});

	$('#btnReadCard').on('click', ReadCardHandler);
	setTimeout(function () {
		PHA.SetVals(REC_DEFAULT);
	}, 1000);
});

function InitDict() {
	PHA.ComboBox('conPivasLoc', {
		url: PHA_STORE.Pharmacy('OPIVAS').url,
		editable: false,
		panelHeight: 'auto',
		onLoadSuccess: function (data) {
			$(this).combobox('select', data[0].RowId);
		}
	});
	PHA.ComboBox('conDocLoc', {
		url: PHA_STORE.DocLoc().url
	});
	PHA.ComboBox('conEMLGLoc', {
		url: PHA_STORE.EMLGLoc().url
	});

	PHA.ComboBox('conPack', {
		editable: false,
		url: PHA_OPIVAS_STORE.PIVADISPackFlag().url,
		panelHeight: 'auto',
		onSelect: function () {
			Query();
		}
	});
	PHA.ComboBox('conRecStatus', {
		editable: false,
		url: PHA_OPIVAS_STORE.PIVADISRecStatus().url,
		panelHeight: 'auto',
		onSelect: function () {
			Query();
		}
	});
	//	PHA_UX.DHCCardTypeDef({
	//		cardTypeId: "conCardType",
	//		cardNoId: "conCardNo",
	//		patNoId: "conPatNo",
	//		readCardId: "btnReadCard"
	//	}, {
	//		AfterHandler: Query
	//	});
	PHA_OPIVAS_COM.Bind.KeyDown.PatNo('conPatNo', Query);
}

function InitGridRec() {
	var columns = [
		[{
				field: 'pid',
				title: '���̺�',
				width: 75,
				hidden: true
			}, {
				field: 'dspId',
				title: 'dspId',
				width: 75,
				hidden: true
			}, {
				field: 'mDspId',
				title: 'mDspId',
				width: 95,
				hidden: true
			}, {
				field: 'disId',
				title: 'disId',
				width: 95,
				hidden: true
			}, {
				field: 'oeoreChk',
				checkbox: true
			}, {
				field: 'warn',
				title: '����',
				width: 75,
				styler: PHA_OPIVAS_COM.Grid.Styler.Warn
			}, {
				field: 'disOpStatusDesc',
				title: '����״̬',
				width: 75,
				align: 'center'
			}, {
				field: 'packFlag',
				title: '���',
				width: 45,
				align: 'center',
				formatter: PHA_OPIVAS_COM.Grid.Formatter.YesNo,
				styler: PHA_OPIVAS_COM.Grid.Styler.Pack
			}, {
				field: 'doseDateTime',
				title: '��ҩʱ��',
				width: 100
			}, {
				field: 'patNo',
				title: '�ǼǺ�',
				width: 100,
				formatter: function (value, row, index) {
					return PHA_OPIVAS_COM.Grid.Formatter.AdmDetail(value, row, index, 'oeori');
				}
			}, {
				field: 'patName',
				title: '����',
				width: 100
			}, {
				field: 'patSex',
				title: '�Ա�',
				width: 45,
				align: 'center'
			}, {
				field: 'patAge',
				title: '����'
			}, {
				field: 'oeoriSign',
				title: '��',
				width: 30,
				formatter: PHA_OPIVAS_COM.Grid.Formatter.OeoriSign
			}, {
				field: 'inciDesc',
				title: 'ҩƷ����',
				width: 250
			}, {
				field: 'dosage',
				title: '����'
			}, {
				field: 'instrucDesc',
				title: '�÷�',
				width: 75
			}, {
				field: 'freqDesc',
				title: 'Ƶ��'
			}, {
				field: 'duraDesc',
				title: '�Ƴ�',
				width: 75
			}, {
				field: 'oeoriRemark',
				title: 'ҽ����ע',
				width: 100
			}, {
				field: 'ivgttSpeed',
				title: '����',
				width: 80
			}, {
				field: 'docLocDesc',
				title: 'ҽ������',
				width: 100
			}, {
				field: 'docName',
				title: 'ҽ��',
				width: 100
			}, {
				field: 'exceedReason',
				title: '�Ƴ̳���ԭ��',
				width: 125
			}, {
				field: 'prescNo',
				title: '������',
				width: 125
			}, {
				field: 'disUserName',
				title: '������',
				width: 80
			}, {
				field: 'disDateTime',
				title: '����ʱ��',
				width: 160
			}, {
				field: 'disCUserName',
				title: 'ȡ����',
				width: 80,
				hidden: true
			}, {
				field: 'disCDateTime',
				title: 'ȡ��ʱ��',
				width: 160,
				hidden: true
			}, {
				field: 'disOpUserName',
				title: '���ղ�����',
				width: 95
			}, {
				field: 'disOpDateTime',
				title: '���ղ���ʱ��',
				width: 160
			}, {
				field: 'oeoriStatus',
				title: 'ҽ��״̬',
				width: 70,
				align: 'center'
			}, {
				field: 'oeoreStatus',
				title: 'ִ�м�¼״̬',
				width: 100
			}, {
				field: 'disReqRemark',
				title: '����ԭ��',
				width: 150
			}, {
				field: 'oeori',
				title: 'ҽ��ID',
				width: 100,
				formatter: function (value, row, index) {
					return PHA_OPIVAS_COM.Grid.Formatter.OrderDetail(value, row, index, 'oeori');
				}
			}
		]
	];
	var dataGridOption = {
		exportXls: false,
		url: 'pha.opivas.v4.broker.csp',
		queryParams: {
			ClassName: 'PHA.OPIVAS.Rec.Query',
			QueryName: 'Rec',
			GrpField: 'disId'
		},
		pagination: true,
		columns: columns,
		nowrap: true,
		singleSelect: false,
		toolbar: '#gridRecBar',
		onCheck: function (rowIndex, rowData) {
			PHA_OPIVAS_COM.Grid.LinkCheck.Do({
				CurRowIndex: rowIndex,
				GridId: 'gridRec',
				Field: 'disId',
				Check: true,
				Value: rowData.disId
			});
		},
		onUncheck: function (rowIndex, rowData) {
			PHA_OPIVAS_COM.Grid.LinkCheck.Do({
				CurRowIndex: rowIndex,
				GridId: 'gridRec',
				Field: 'disId',
				Check: false,
				Value: rowData.disId
			});
		},
		onLoadSuccess: function (data) {
			var row0Data = data.rows[0];
			if (row0Data) {
				$(this).datagrid('options').queryParams.Pid = row0Data.pid;
			}
			$('#gridRec').datagrid('uncheckAll');
		},
		rowStyler: function (index, rowData) {
			return PHA_OPIVAS_COM.Grid.RowStyler.Person(index, rowData, 'patNo');
		}
	};
	PHA.Grid('gridRec', dataGridOption);
}

/*****************************************************************/
function Query() {
	var valsStr = PHA_OPIVAS_COM.DomData('#qCondition', {
		doType: 'query',
		needId: 'Y'
	});
	KillTmpGloal();
	$('#gridRec').datagrid('query', {
		InputStr: valsStr,
		Pid: ''
	});
}

/**
 *
 * @param {String} type ��������(REC,REF)
 */
function SaveDisHandler(type, pack) {
	var chkDatas = $('#gridRec').datagrid('getChecked');
	if (chkDatas == '') {
		PHA.Popover({
			msg: '����ѡ���¼',
			type: 'alert'
		});
		return;
	}
	var conInfo = '';
	if (type == 'REC') {
		conInfo = '����';
		if (pack == 'Y') {
			conInfo = '���' + conInfo;
		} else if (pack == 'N') {
			conInfo = '��Һ' + conInfo;
		}
	} else if (type == 'REF') {
		conInfo = '�ܾ�����';
	}
	PHA.Confirm('������ʾ', '��ȷ��' + conInfo + '��?', function () {
		var disIdArr = [];
		var dataLen = chkDatas.length;
		for (var i = 0; i < dataLen; i++) {
			var rowData = chkDatas[i];
			var disId = rowData.disId;
			if (disIdArr.indexOf(disId) >= 0) {
				continue;
			}
			disIdArr.push(disId);
		}
		var disIdStr = disIdArr.join('^');
		var saveOpt = {
			disIdStr: disIdStr,
			type: type,
			remark: '',
			pack: pack,
			conInfo: conInfo
		};
		if (type == 'REC') {
			Save(saveOpt);
		} else if (type == 'REF') {
			PHA_OPIVAS_UX.DisRemark(saveOpt, Save);
		}
	});
}

function Save(saveOpt) {
	PHA.Loading('Show');
	$.cm({
		ClassName: 'PHA.OPIVAS.Rec.Save',
		MethodName: 'SaveMulti',
		DisIdStr: saveOpt.disIdStr,
		Type: saveOpt.type,
		LogonStr: PHA_COM.Session.ALL,
		Remark: saveOpt.remark,
		Pack: saveOpt.pack,
		dataType: 'text'
	},
		function (saveRet) {
		PHA.Loading('Hide');
		var saveArr = saveRet.split('^');
		var saveVal = saveArr[0];
		var saveInfo = saveArr[1];
		if (saveVal < 0) {
			PHA.Alert('��ʾ', saveInfo, 'warning');
		} else {
			PHA.Popover({
				msg: saveOpt.conInfo + '�ɹ�',
				type: 'success'
			});
		}
		Query();
	});
}
/**
 *  ����
 */
function Clean() {
	PHA.DomData('#qCondition', {
		doType: 'clear'
	});
	KillTmpGloal();
	$('#gridRec').datagrid('clear');
	PHA.SetVals(REC_DEFAULT);
}

function KillTmpGloal() {
	PHA_OPIVAS_COM.Kill('gridRec', 'PHA.OPIVAS.Rec.Query', 'KillRec');
}
window.onbeforeunload = function () {
	KillTmpGloal();
};
//����
function ReadCardHandler() {
	PHA_COM.ReadCard({
		CardTypeId: '',
		CardNoId: 'conCardNo',
		PatNoId: 'conPatNo'
	}, Query);
}
