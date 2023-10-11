/**
 * 名称:   	 药房药库-毒麻药品使用登记
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-07
 * csp:		 pha.in.v1.narcregsimple.csp
 * js:		 pha/in/v1/narcregsimple.js
 */
PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcregsimple.csp';
PHA_COM.App.Name = $g('毒麻药品使用登记[简版]');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};
PHA_COM.VAR.SetDefaultTask = null;

$(function () {
	InitConfig();
	
	$('#panelNarcReg').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('毒麻药品用药登记【简版】') : '',
		headerCls: 'panel-header-gray',
		iconCls: 'icon-template',
		bodyCls: 'panel-body-gray',
		fit: true
	});
	PHA_COM.ResizePhaCol({});

	InitDict();
	InitGridNarcReg();
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
				Description: $g('已发药')
			}, {
				RowId: 'N',
				Description: $g('未发药')
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
	
	// 药品下拉
	var inciOptions = PHA_STORE.INCItm();
	inciOptions.url = $URL;
	inciOptions.width = 145;
	PHA.ComboGrid('inci', inciOptions);
	// 默认开单科室/病区下拉框
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

// 初始化 - 事件绑定
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

// 初始化 - 表格
function InitGridNarcReg() {
	// 批号是否可以编辑
	var batchNoEditor = PHA_GridEditor.ValidateBox({
		required: true,
		disabled: PHA_COM.VAR.CONFIG['Rec.InputBatNo'] == 'N' ? true : false
	});
	var editFieldSort = batchNoEditor 
	? ['inciBatchNo', 'operRoomId', 'narcDocUserId', 'machineCode', 'useQty', 'recFluidQty', 'recQty', 'remarks'] 
	: ['operRoomId', 'narcDocUserId', 'machineCode', 'useQty', 'recFluidQty', 'recQty', 'remarks'];
	
	// 列信息
	var columns = [
		[{
				field: 'tSelect',
				checkbox: true
			}, {
				title: '就诊记录主键',
				field: 'adm',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '医嘱主键',
				field: 'oeore',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '打包表主键',
				field: 'dspId',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '日期',
				field: 'dosingDT',
				width: 150,
				align: 'center'
			}, {
				title: '登记号',
				field: 'patNo',
				width: 110,
				align: 'center',
				formatter: function (value, rowData, index) {
					return '<a style="border:0px;cursor:pointer" onclick="">' + value + '</a>'
				}
			}, {
				title: '患者姓名',
				field: 'patName',
				width: 100
			}, {
				title: '性别',
				field: 'patSex',
				width: 170,
				hidden: true
			}, {
				title: '年龄',
				field: 'patAge',
				width: 170,
				hidden: true
			}, {
				title: '身份证号',
				field: 'IDCard',
				width: 170,
				hidden: true
			}, {
				title: '药品名称',
				field: 'inciDesc',
				width: 200,
				align: 'left',
				showTip: true,
				tipWidth: 200
			}, {
				title: '规格',
				field: 'inciSpec',
				width: 100,
				align: 'center'
			}, {
				title: '单位',
				field: 'dspUomDesc',
				width: 70,
				align: 'center'
			}, {
				title: '数量',
				field: 'dspQty',
				width: 70,
				align: 'center'
			}, {
				title: GetEditTitle('批号'),
				field: 'inciBatchNo',
				width: 100,
				align: 'left',
				editor: batchNoEditor
			}, {
				title: ('手术间'),
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
				title: GetEditTitle('麻醉医师'),
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
					regTxt: '不能为空!',
					mode: 'remote',
					url: PHA_STORE.Url + 'ClassName=PHA.STORE.Org&QueryName=Doctor&HospId=' + session['LOGON.HOSPID'],
					onBeforeLoad: function (param) {
						param.QText = param.q;
					}
				})
			}, {
				title: ('麻醉机编号'),
				field: 'machineCode',
				width: 100,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				title: '处方医师',
				field: 'ordUserName',
				width: 100,
				align: 'left'
			}, {
				title: '剂量单位',
				field: 'doseUomDesc',
				width: 75,
				align: 'left'
			}, {
				title: '医嘱剂量',
				field: 'doseQty',
				width: 75,
				align: 'right'
			}, {
				title: GetEditTitle('实际用药量'),
				field: 'useQty',
				width: 90,
				align: 'right',
				editor: PHA_GridEditor.ValidateBox({
					required: true,
					checkValue: function (val, chkRet) {
						var nVal = parseFloat(val);
						if (isNaN(nVal)) {
							chkRet.msg = "请输入数字！";
							return false;
						}
						if (nVal < 0) {
							chkRet.msg = "请输入大于0的数字！";
							return false;
						}
						return true;
					}
				})
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
						return true;
					}
				})
			}, {
				title: ('备注'),
				field: 'remarks',
				width: 120,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({
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
				title: '频次',
				field: 'freqDesc',
				width: 70
			}, {
				title: '疗程',
				field: 'duratDesc',
				width: 70
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
				title: GetEditTitle('残量处理执行人'),
				field: 'DSCDExeUserId',
				descField: 'DSCDExeUserName',
				width: 120,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['DSCDExeUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: GetEditTitle('残量处理监督人'),
				field: 'DSCDSuperUserId',
				descField: 'DSCDSuperUserName',
				width: 120,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['DSCDSuperUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: GetEditTitle('空安瓿回收(接收)人'),
				field: 'recUserId',
				descField: 'recUserName',
				width: 140,
				align: 'left',
				formatter: function (value, rowData, index) {
					return rowData['recUserName'];
				},
				editor: PHA_GridEditor.ComboBox($.extend({}, GridEditors.UserInfo.options))
			}, {
				title: '临床诊断',
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
			// 当批号为空时，尽管参数设置为N，也能对批号进行修改
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
 * 界面操作
 */
function Query() {
	// 主界面
	var formDataArr = PHA.DomData('#gridNarcRegBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];

	// 默认信息
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
	formData.recState = formData.regState; // 简版 - 登记&回收状态是同步的 TODO...
	formData.hospId = session['LOGON.HOSPID'];
	if (!formData.recLocId) {
		return;
	}
	
	// 查询
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

// 保存 (登记&回收)
function Save() {
	if (PHA_COM.VAR.CONFIG['Rec.UseSimple'] != 'Y') {
		PHA.Alert('提示', '系统未设置使用【简版】登记！', -1);
		return;
	}
	
	PHA_GridEditor.End('gridNarcReg');
	var checkedData = $('#gridNarcReg').datagrid('getChecked');
	if (checkedData == null || checkedData.length == 0) {
		PHA.Popover({
			msg: '请勾选需要登记的执行记录!',
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
			// 登记信息
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
			// 回收信息
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
		PHA.Alert('提示', saveRetArr[1], saveRetArr[0]);
	} else {
		PHA.Popover({
			msg: '登记成功!',
			type: 'success'
		});
		Query();
	}
}

// 撤消回收
function Cancel(){
	PHA_GridEditor.End('gridNarcReg');
	var checkedData = $('#gridNarcReg').datagrid('getChecked');
	if (checkedData == null || checkedData.length == 0) {
		PHA.Popover({
			msg: '请勾选需要撤消的执行记录!',
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
				msg: '您勾选的第' + (i + 1) + '行不是[已登记]状态，无法撤销！',
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
	
	PHA.Confirm("温馨提示", "是否确认撤消登记？", function () {
		var saveRetStr = tkMakeServerCall('PHA.IN.NarcReg.Simple', 'CancelSimple', pJsonStr);
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
	});
}

function Export() {
	var rowsData = $('#gridNarcReg').datagrid('getRows') || [];
	if (rowsData.length == 0) {
		PHA.Popover({
			msg: '没有数据!',
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
			msg: '没有数据!',
			type: 'alert'
		});
		return;
	}
	// 获取参数
	var formDataArr = PHA.DomData('#gridNarcRegBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	// 只能打印已登记的
	var regState = formData.regState || '';
	if (regState == '' || regState == 'N') {
		PHA.Popover({
			msg: '只能打印已登记的，请选择登记状态为已登记!',
			type: 'alert'
		});
		return;
	}
	formData.dateType = 'RegDate';
	formData.recLocId = session['LOGON.CTLOCID'];
	formData.recState = formData.regState; // 简版 - 登记&回收状态是同步的 TODO...
	formData.hospId = session['LOGON.HOSPID'];
	if (!formData.recLocId) {
		return;
	}
	var InputStr = JSON.stringify(formData);

	// 打开选择窗口
	ReportTypeWin({
		width: 220,
		height: 160,
		title: '请选择报表类型',
		radios: [{
				label: '登记报表',
				value: 'PHAIN_NarcReport_Reg.raq',
				checked: true
			}, {
				label: '综合报表',
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
	// 润乾预览打印
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

	// 窗口配置
	_options.closable = true;
	_options.modal = true;
	_options.iconCls = 'icon-w-edit',
	_options.buttons = [{
			text: '确认',
			handler: function () {
				var checkedRadio = $('input[name="' + _radioName + '"]:checked');
				if (checkedRadio.length == 0) {
					$.messager.popover({
						timeout: 1000,
						msg: '请选择表单类型!',
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
			text: '取消',
			handler: function () {
				$('#' + _winId).dialog('close');
			}
		}
	];
	$('#' + _winId).dialog(_options);

	// 加载报表类型
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
 * 回收信息录入弹窗
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
 * 明细信息展示
 */
function OpenDetailWin(index) {
	var rowsData = $('#gridNarcReg').datagrid('getRows');
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

/*
 * Grid Editors for this page
 */
var GridEditors = {
	// 用户
	UserInfo: {
		type: 'combobox',
		options: {
			regExp: /\S/,
			regTxt: '不能为空!',
			valueField: 'RowId',
			textField: 'Description',
			mode: 'remote',
			url: 'websys.Broker.cls?ResultSetType=Array&ClassName=PHA.STORE.Org&QueryName=SSUser&LocId=' + session['LOGON.CTLOCID'],
			onBeforeLoad: function (param) {
				param.QText = param.q;
			}
		}
	},
	// 残量处理意见(公共字典)
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