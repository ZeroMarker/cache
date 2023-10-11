/**
 * 名称:	 门诊配液系统-接收申请
 * 编写人:	 yunhaibao
 * 编写日期: 2019-06-18
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
		title: isTabMenu !== true ? '接收申请' : '',
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
		clearInterval(REC_INTERVAL); // 说不准连续点击会不会重复计时器,不测了,清了
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
				title: '进程号',
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
				title: '提醒',
				width: 75,
				styler: PHA_OPIVAS_COM.Grid.Styler.Warn
			}, {
				field: 'disOpStatusDesc',
				title: '申请状态',
				width: 75,
				align: 'center'
			}, {
				field: 'packFlag',
				title: '打包',
				width: 45,
				align: 'center',
				formatter: PHA_OPIVAS_COM.Grid.Formatter.YesNo,
				styler: PHA_OPIVAS_COM.Grid.Styler.Pack
			}, {
				field: 'doseDateTime',
				title: '用药时间',
				width: 100
			}, {
				field: 'patNo',
				title: '登记号',
				width: 100,
				formatter: function (value, row, index) {
					return PHA_OPIVAS_COM.Grid.Formatter.AdmDetail(value, row, index, 'oeori');
				}
			}, {
				field: 'patName',
				title: '姓名',
				width: 100
			}, {
				field: 'patSex',
				title: '性别',
				width: 45,
				align: 'center'
			}, {
				field: 'patAge',
				title: '年龄'
			}, {
				field: 'oeoriSign',
				title: '组',
				width: 30,
				formatter: PHA_OPIVAS_COM.Grid.Formatter.OeoriSign
			}, {
				field: 'inciDesc',
				title: '药品名称',
				width: 250
			}, {
				field: 'dosage',
				title: '剂量'
			}, {
				field: 'instrucDesc',
				title: '用法',
				width: 75
			}, {
				field: 'freqDesc',
				title: '频次'
			}, {
				field: 'duraDesc',
				title: '疗程',
				width: 75
			}, {
				field: 'oeoriRemark',
				title: '医嘱备注',
				width: 100
			}, {
				field: 'ivgttSpeed',
				title: '滴速',
				width: 80
			}, {
				field: 'docLocDesc',
				title: '医生科室',
				width: 100
			}, {
				field: 'docName',
				title: '医生',
				width: 100
			}, {
				field: 'exceedReason',
				title: '疗程超量原因',
				width: 125
			}, {
				field: 'prescNo',
				title: '处方号',
				width: 125
			}, {
				field: 'disUserName',
				title: '申请人',
				width: 80
			}, {
				field: 'disDateTime',
				title: '申请时间',
				width: 160
			}, {
				field: 'disCUserName',
				title: '取消人',
				width: 80,
				hidden: true
			}, {
				field: 'disCDateTime',
				title: '取消时间',
				width: 160,
				hidden: true
			}, {
				field: 'disOpUserName',
				title: '接收操作人',
				width: 95
			}, {
				field: 'disOpDateTime',
				title: '接收操作时间',
				width: 160
			}, {
				field: 'oeoriStatus',
				title: '医嘱状态',
				width: 70,
				align: 'center'
			}, {
				field: 'oeoreStatus',
				title: '执行记录状态',
				width: 100
			}, {
				field: 'disReqRemark',
				title: '申请原因',
				width: 150
			}, {
				field: 'oeori',
				title: '医嘱ID',
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
 * @param {String} type 操作类型(REC,REF)
 */
function SaveDisHandler(type, pack) {
	var chkDatas = $('#gridRec').datagrid('getChecked');
	if (chkDatas == '') {
		PHA.Popover({
			msg: '请先选择记录',
			type: 'alert'
		});
		return;
	}
	var conInfo = '';
	if (type == 'REC') {
		conInfo = '接收';
		if (pack == 'Y') {
			conInfo = '打包' + conInfo;
		} else if (pack == 'N') {
			conInfo = '配液' + conInfo;
		}
	} else if (type == 'REF') {
		conInfo = '拒绝接收';
	}
	PHA.Confirm('操作提示', '您确认' + conInfo + '吗?', function () {
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
			PHA.Alert('提示', saveInfo, 'warning');
		} else {
			PHA.Popover({
				msg: saveOpt.conInfo + '成功',
				type: 'success'
			});
		}
		Query();
	});
}
/**
 *  清屏
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
//读卡
function ReadCardHandler() {
	PHA_COM.ReadCard({
		CardTypeId: '',
		CardNoId: 'conCardNo',
		PatNoId: 'conPatNo'
	}, Query);
}
