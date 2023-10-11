/**
 * 名称:   	 药房药库 - 毒麻药品回收
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-07
 * csp:		 pha.in.v1.narcrec.csp
 * js:		 pha/in/v1/narcrec.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcrec.csp';
PHA_COM.App.Name = $g('毒麻药品回收');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};

$(function () {
	InitConfig();
	
	var isTabMenu = PHA_COM.IsTabsMenu();
	$('#panelNarcRec').panel({
		title: isTabMenu !== true ? $g('毒麻药品回收') : '',
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
	
	
	// 显示录入界面
	if (PHA_COM.VAR.CONFIG['Rec.ShowWin'] == 'Y') {
		InputRecInfo();
	}
	// 自动查询
	if (patNo != '') {
		Query();
	}
});

// 初始化 - 表单字典
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
					title: '库存项ID',
					width: 60,
					hidden: true
				}, {
					field: 'inciCode',
					title: '代码',
					width: 120
				}, {
					field: 'inciDesc',
					title: '名称',
					width: 200
				}, {
					field: 'inciSpec',
					title: '规格',
					width: 100
				}
			]
		],
		onLoadSuccess: function () {
			return false;
		}
	});
	PHA.ToggleButton('BMore', {
		buttonTextArr: [$g('更多'), $g('隐藏')],
		selectedText: $g('隐藏'),
		onClick: function (oldText, newText) {
			if (oldText == $g('更多')) {
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

// 初始化 - 事件绑定
function InitEvents() {
	$('#btnFind').on('click', Query);
	$('#btnClear').on('click', Clear);
	$('#btnSave').on('click', Save);
	$('#btnInput').on('click', InputRecInfo);
	$('#btnCancel').on('click', Cancel);

	// 读卡
	$('#btnReadCard').on('click', ReadCard);
	$('#cardNo').on('keydown', function (e) {
		if (e.keyCode == 13) {
			ReadCard();
		}
	});
	// 登记号
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
	// 发药批号
	$('#dspBatchNo').on('keydown', function (e) {
		if (e.keyCode == 13) {
			Query();
		}
	});
	// 登记批号
	$('#regBatchNo').on('keydown', function (e) {
		if (e.keyCode == 13) {
			Query();
		}
	});
}

// 初始化 - 表格
function InitGridNarcRec() {
	// 批号是否可以编辑
	var batchNoEditor = PHA_GridEditor.ValidateBox({
		required: true
	});
	batchNoEditor = PHA_COM.VAR.CONFIG['Rec.InputBatNo'] == 'N' ? null : batchNoEditor;
	var editFieldSort = batchNoEditor ? ['recBatchNo', 'recFluidQty', 'recQty'] : ['recFluidQty', 'recQty'];
	
	// 列信息
	var columns = [
		[{
				field: 'tSelect',
				checkbox: true
			}, {
				title: '主键',
				field: 'pinr',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '就诊ID',
				field: 'adm',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '登记号',
				field: 'patNo',
				width: 100,
				align: 'left',
				formatter: function (value, rowData, index) {
					return '<a style="border:0px;cursor:pointer" onclick="">' + value + '</a>';
				}
			}, {
				title: '患者姓名',
				field: 'patName',
				width: 100,
				align: 'left'
			}, {
				title: '性别',
				field: 'patSex',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '年龄',
				field: 'patAge',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '药品代码',
				field: 'inciCode',
				width: 120,
				align: 'left',
				hidden: true
			}, {
				title: '药品名称',
				field: 'inciDesc',
				width: 200,
				align: 'left',
				showTip: true,
				tipWidth: 200
			}, {
				title: '毒麻药品编号',
				field: 'inciNo',
				width: 100,
				align: 'left'
			}, {
				title: '登记批号',
				field: 'inciBatchNo',
				width: 100,
				align: 'left'
			}, {
				title: GetEditTitle('回收批号'),
				field: 'recBatchNo',
				width: 90,
				align: 'left',
				editor: batchNoEditor
			}, {
				title: '发药数量',
				field: 'dspQty',
				width: 75,
				align: 'right'
			}, {
				title: '发药单位',
				field: 'dspUomDesc',
				width: 75,
				align: 'center'
			}, {
				title: '用量单位',
				field: 'doseUomDesc',
				width: 75,
				align: 'center'
			}, {
				title: '实际用量',
				field: 'useQty',
				width: 75,
				align: 'right'
			}, {
				title: GetEditTitle('液体残量'),
				field: 'recFluidQty',
				width: 75,
				align: 'right',
				editor: PHA_GridEditor.ValidateBox({
					required: true,
					checkValue: function (val, chkRet) {
						if (isNaN(val)) {
							chkRet.msg = "请输入数字!";
							return false;
						}
						val = parseFloat(val);
						if (val < 0) {
							chkRet.msg = "不能小于0!";
							return false;
						}
						return true;
					}
				})
			}, {
				title: GetEditTitle('空安瓿数量'),
				field: 'recQty',
				width: 90,
				align: 'right',
				editor: PHA_GridEditor.ValidateBox({
					required: true,
					checkValue: function (val, chkRet) {
						if (isNaN(val)) {
							chkRet.msg = "请输入数字!";
							return false;
						}
						val = parseFloat(val);
						if (val < 0) {
							chkRet.msg = "不能小于0!";
							return false;
						}
						if (parseFloat(val.toString().split('.')[1]) > 0) {
							chkRet.msg = "不能是小数";
							return false;
						}
						return true;
					},
					onBeforeNext: function (val, gridRowData, gridRowIdex) {
						// 最后一行最后一列
						if (PHA_GridEditor.IsLastRow()) {
							PHA_GridEditor.End('gridNarcRec');
							return false;
						}
						return true;
					}
				})
			}, {
				title: ('回收核对人'),
				field: 'recCheckUserId',
				descField: 'recCheckUserName',
				width: 100,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['recCheckUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: ('回收交回人'),
				field: 'recFromUserName',
				width: 100,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				title: ('交回人联系方式'),
				field: 'recFromUserTel',
				width: 120,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				title: ('回收来源类型'),
				field: 'recOriType',
				descField: 'recOriTypeDesc',
				width: 100,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['recOriTypeDesc'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.recOriType.options))
			}, {
				title: ('回收来源科室'),
				field: 'recOriLocId',
				descField: 'recOriLocDesc',
				width: 120,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData.recOriLocDesc;
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.LocInfo.options))
			}, {
				title: ('残量处理意见'),
				field: 'DSCD',
				descField: 'DSCDDesc',
				width: 160,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['DSCDDesc'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.DSCD.options))
			}, {
				title: ('残量处理执行人'),
				field: 'DSCDExeUserId',
				descField: 'DSCDExeUserName',
				width: 120,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['DSCDExeUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: ('残量处理监督人'),
				field: 'DSCDSuperUserId',
				descField: 'DSCDSuperUserName',
				width: 120,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['DSCDSuperUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: '回收状态',
				field: 'recStateDesc',
				width: 75,
				align: 'center'
			}, {
				title: '回收科室',
				field: 'recLocDesc',
				width: 130,
				align: 'left'
			}, {
				title: '回收人',
				field: 'recUserName',
				width: 100,
				align: 'left'
			}, {
				title: '回收日期',
				field: 'recDate',
				width: 100,
				align: 'center'
			}, {
				title: '回收时间',
				field: 'recTime',
				width: 90,
				align: 'center'
			}, {
				title: '预计执行时间',
				field: 'dosingDT',
				width: 150,
				align: 'center'
			}, {
				title: '护士执行时间',
				field: 'exeDT',
				width: 150,
				align: 'center'
			}, {
				title: '撤消人',
				field: 'cancelUserName',
				width: 100,
				align: 'center'
			}, {
				title: '撤消时间',
				field: 'cancelDT',
				width: 150,
				align: 'center'
			}, {
				title: '执行记录ID',
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
 * 界面操作
 */
function Query() {
	// 查询条件
	var formDataArr = PHA.DomData('#gridNarcRecBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	// 仅未销毁
	formData.destroyState = 'N';
	// 默认回收信息
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
	// 查询
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
	
	// 获取界面数据
	PHA_GridEditor.End('gridNarcRec');
	var checkedData = $('#gridNarcRec').datagrid('getChecked');
	if (checkedData == null || checkedData.length == 0) {
		PHA.Popover({
			msg: '请勾选需要回收的执行记录!',
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
			msg: '请选择回收科室!',
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
		PHA.Alert('提示', saveRetArr[1], saveRetArr[0]);
	} else {
		PHA.Popover({
			msg: '回收成功!',
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
			msg: '请勾选需要撤消的执行记录!',
			type: 'alert'
		});
		return;
	}
	var recLocId = $('#recLocId').combobox('getValue') || '';
	if (recLocId == '') {
		PHA.Popover({
			msg: '请选择回收科室!',
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
				msg: '第' + (i + 1) + "行,回收状态不是已回收,无法撤消回收！",
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
		PHA.Alert('提示', saveRetArr[1], saveRetArr[0]);
	} else {
		PHA.Popover({
			msg: '撤消成功!',
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
		title: '医嘱明细信息',
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
	// 回收来源类型
	recOriType: {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: PHA_STORE.Url + 'ClassName=PHA.IN.Narc.Com&QueryName=DictTmp&dicType=OriType',
		}
	},
	// 用户
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
	// 科室下拉
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
	// 残量处理意见 (公共字典)
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
			title: '录入回收信息',
			iconCls: 'icon-w-edit',
			content: $('#win_content_html').html(),
			closable: true,
			onClose: function () {},
			buttons: [{
					text: '确认',
					handler: function () {
						$('#' + winId).dialog('close');
						Query();
					}
				}, {
					text: '重录',
					handler: ClearWinDict
				}
			]
		});
		// 样式修改
		var dialogBody = $('#' + winId).dialog('body').children().eq(0).children().eq(0).children().eq(0);
		dialogBody.parent().addClass('pha-scrollbar-hidden');
		dialogBody.addClass('pha-body');
		dialogBody.addClass('pha-scrollbar-hidden-chl');
		dialogBody.parent().css('overflow', 'hidden');
		// 初始化表单
		InitWinDict();
	}
	$('#' + winId).dialog('open');
}
function InitWinDict() {
	// 回收核对人
	PHA.ComboBox('recCheckUserId', {
		url: PHA_STORE.Url + 'ClassName=PHA.STORE.Org&QueryName=SSUser&LocId=' + session['LOGON.CTLOCID'],
		onHidePanel: function () {
			var recCheckUserId = $('#recCheckUserId').combobox('getValue');
			if (recCheckUserId != '') {
				$('#recFromUserName').focus();
			}
		}
	});
	// 交回人
	$('#recFromUserName').on('keydown', function (e) {
		if (e.keyCode == 13 && $('#recFromUserName').val() != '') {
			$('#recFromUserTel').focus();
		}
	});
	// 交回人联系方式
	$('#recFromUserTel').on('keydown', function (e) {
		if (e.keyCode == 13 && $('#recFromUserTel').val() != '') {
			$('#recOriType').next().children().eq(0).focus();
			$('#recOriType').combobox('showPanel');
		}
	});
	// 回收来源类型
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
	// 回收来源科室
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
	// 回收来源科室
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
	// 回收执行人
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
	// 回收监督人
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

// 检查操作权限
function checkAuth(){
	// 验证临床科室的回收权限
	var locType = tkMakeServerCall('PHA.IN.Narc.Com', 'GetLocType', session['LOGON.CTLOCID']);
	if (PHA_COM.VAR.CONFIG['Rec.DocRec'] != 'Y') {
		if (locType != 'D') {
			PHA.Alert('提示', '系统已设置临床科室不允许回收！如需启用回收功能请联系信息科。', -1);
			return false;
		}
	}
	if (PHA_COM.VAR.CONFIG['Rec.UseSimple'] == 'Y') {
		//if (locType != 'D') {
			PHA.Alert('提示', '系统已设置临床科室使用【简版】登记并回收！不需要单独回收！', -1);
			return false;
		//}
	}
	true;
}

// 帮助信息
function showHelpWin() {
	var winId = 'Win_Help';
	var winContentId = 'Win_Help_Content';
	if ($('#' + winId).length == 0) {
		$('<div id="' + winId + '"></div>').appendTo('body');
		$('#' + winId).dialog({
			width: 990,
			height: 640,
			modal: true,
			title: '帮助信息',
			iconCls: 'icon-w-list',
			content: GetHelpContentHtml(),
			closable: true,
			onClose: function () {}
		});
		// 样式修改
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
	// 操作步骤
	contentHtml += '	<div class="kw-chapter"><a></a>' + $g('操作步骤') + '</div><div class="kw-line"></div>';
	contentHtml += '	<b>' + $g('录入回收信息') + '</b> ';
	contentHtml += '	<label style="color:red">→</label> <b>' + $g('查询') + '</b> ';
	contentHtml += '	<label style="color:red">→</label> <b>' + $g('核对及修改表格中的回收信息') + '</b> ';
	contentHtml += '	<label style="color:red">→</label> <b>' + $g('回收') + '</b> ';
	contentHtml += '	<br/>';
	//contentHtml += '	<br/>';
	// 查询说明
	contentHtml += '	<div class="kw-chapter"><a></a>' + $g('查询') + '</div><div class="kw-line"></div>';
	contentHtml += '	' + $g('查询存在问题,请核实以下条件：') + ' <br/>';
	contentHtml += '	1、' + $g('是否已用药登记：该界面只查询已经用药登记的执行记录数据，日期以界面选择的日期为准；') + ' <br/>';
	contentHtml += '	2、' + $g('回收科室：检查回收科室是否正确；') + ' <br/>';
	contentHtml += '	3、' + $g('回收状态：检查回收状态是否正确；') + ' <br/>';
	contentHtml += '	4、' + $g('登记号/卡号：检查登记号或者卡号是否正确；') + ' <br/>';
	contentHtml += '	5、' + $g('开单科室：检查选择的开单科室是否正确；') + ' <br/>';
	contentHtml += '	6、' + $g('药品：药品名称；') + ' <br/>';
	contentHtml += '	7、' + $g('批号：发药时录入的批号或者用药登记的批号；') + ' <br/>';
	contentHtml += '	8、' + $g('病区：开医嘱时患者所在的病区是否正确；') + ' <br/>';
	contentHtml += '	' + $g('更多查询请前往综合查询界面。') + '<br/>';
	//contentHtml += '	<br/>';
	// 回收说明
	contentHtml += '	<div class="kw-chapter"><a></a>' + $g('回收') + '</div><div class="kw-line"></div>';
	contentHtml += '	' + $g('回收之前需要录入表格标题带'+GetEditTitle("")+'的字段，以下为说明') + '：<br/>';
	contentHtml += '	1、' + $g('回收批号：必填字段，默认为用药登记时填写的批号，也可以自己手动填入；此字段可以在参数配置设置为不允许录入。') + ' <br/>';
	contentHtml += '	2、' + $g('空安瓿数量：必填字段，表示回收的空安瓿或废贴数量，单位为基本单位；') + ' <br/>';
	contentHtml += '	3、' + $g('液体残量：必填字段，表示毒麻药品回收时的残余量，单位为基本单位，默认为发药数量-开医嘱剂量。') + ' <br/>';
	//contentHtml += '	<br/>';
	// 其他说明
	contentHtml += '	<div class="kw-chapter"><a></a>' + $g('其他') + '</div><div class="kw-line"></div>';
	contentHtml += '	1、' + $g('回收的对象：回收的对象主要是空安瓿/废贴和残余药液；部分医院残余药液在使用之后直接处理不参与回收；') + ' <br/>';
	contentHtml += '	2、' + $g('空安瓿：空安瓿是装液体类毒麻药品容器，是一个小瓶子；') + ' <br/>';
	contentHtml += '	3、' + $g('废贴：非口服类的毒麻药品，如：芬太尼透皮贴剂，使用后会产生一个废贴；') + ' <br/>';
	contentHtml += '	4、' + $g('多科室回收：回收允许多科室回收，但是每个科室都只允许回收一次。如: 麻醉科或者手术室回收之后，将空安瓿送至药房，药房可以再次操作回收。') + ' <br/>';
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