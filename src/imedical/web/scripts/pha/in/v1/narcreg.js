/**
 * 名称:   	 药房药库-毒麻药品使用登记
 * 编写人:   Huxiaotian
 * 编写日期: 2020-08-07
 * csp:		 pha.in.v1.narcreg.csp
 * js:		 pha/in/v1/narcreg.js
 */

PHA_COM.App.ProCode = 'IN';
PHA_COM.App.ProDesc = '药库';
PHA_COM.App.Csp = 'pha.in.v1.narcreg.csp';
PHA_COM.App.Name = $g('毒麻药品使用登记');
PHA_COM.App.ParamMethod = '';
PHA_COM.ResizePhaColParam.auto = true;
PHA_COM.VAR = {};
PHA_COM.VAR.SetDefaultTask = null;

$(function () {
	$('#panelNarcReg').panel({
		title: PHA_COM.IsTabsMenu() !== true ? $g('毒麻药品用药登记') : '',
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

// 初始化 - 表单字典
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
				Description: $g('已发药')
			}, {
				RowId: 'N',
				Description: $g('未发药')
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

	// 药品下拉
	var inciOptions = PHA_STORE.INCItm();
	inciOptions.url = $URL;
	inciOptions.width = 160;
	PHA.ComboGrid('inci', inciOptions);
	
	InitDictVal();
}
function InitDictVal(){
	PHA.SetComboVal('regState', 'N');
}

// 初始化 - 事件绑定
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

// 初始化 - 表格
function InitGridNarcReg() {
	var columns = [
		[{
				field: 'tSelect',
				checkbox: true
			}, {
				title: '就诊ID',
				field: 'adm',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '医嘱ID',
				field: 'oeori',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '执行记录ID',
				field: 'oeore',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '打包表ID',
				field: 'dspId',
				width: 100,
				align: 'left',
				hidden: true
			}, {
				title: '登记号',
				field: 'patNo',
				width: 110,
				align: 'center',
				formatter: function (value, rowData, index) {
					return '<a style="border:0px;cursor:pointer" onclick="">' + value + '</a>';
				}
			}, {
				title: '患者姓名',
				field: 'patName',
				width: 100,
				align: 'center'
			}, {
				title: '患者身份证',
				field: 'IDCard',
				width: 170,
				align: 'left',
				hidden: true
			}, {
				title: '药品代码',
				field: 'inciCode',
				width: 120,
				align: 'center',
				hidden: true
			}, {
				title: '药品名称',
				field: 'inciDesc',
				width: 200,
				align: 'left',
				showTip: true,
				tipWidth: 200
			}, {
				title: '发药数量',
				field: 'dspQty',
				width: 70,
				align: 'center'
			}, {
				title: '单位',
				field: 'dspUomDesc',
				width: 70,
				align: 'center'
			}, {
				title: '毒麻药品编号',
				field: 'inciNo',
				width: 100,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				title: GetEditTitle('药品批号'),
				field: 'inciBatchNo',
				width: 100,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({
					required: true
				})
			}, {
				title: '手术间',
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
				title: '麻醉医师',
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
				title: '剂量单位',
				field: 'doseUomDesc',
				width: 75,
				align: 'center'
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
				title: ('麻醉机编号'),
				field: 'machineCode',
				width: 100,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({})
			}, {
				title: ('备注'),
				field: 'remarks',
				width: 120,
				align: 'left',
				editor: PHA_GridEditor.ValidateBox({
					onBeforeNext: function (val, gridRowData, gridRowIdex) {
						// 最后一行最后一列
						if (PHA_GridEditor.IsLastRow()) {
							PHA_GridEditor.End('gridNarcReg');
							return false;
						}
						return true;
					}
				})
			}, {
				title: '计划执行时间',
				field: 'dosingDT',
				width: 150,
				align: 'center'
			}, {
				title: '发药状态',
				field: 'dspStatusDesc',
				width: 75,
				align: 'center'
			}, {
				title: '登记状态',
				field: 'regStateDesc',
				width: 75,
				align: 'center'
			}, {
				title: '登记科室',
				field: 'regLocDesc',
				width: 140,
				align: 'left'
			}, {
				title: '登记人',
				field: 'regUserName',
				width: 100,
				align: 'left'
			}, {
				title: '登记日期',
				field: 'regDate',
				width: 90,
				align: 'left'
			}, {
				title: '登记时间',
				field: 'regTime',
				width: 90,
				align: 'left'
			}, {
				title: '护士执行时间',
				field: 'exeDT',
				width: 150,
				align: 'center'
			}, {
				title: '处方医生',
				field: 'ordUserName',
				width: 100,
				align: 'center'
			}, {
				title: '开单科室',
				field: 'docLocDesc',
				width: 110,
				align: 'center'
			}, {
				title: '病区',
				field: 'wardLocDesc',
				width: 110,
				align: 'center'
			}, {
				title: '就诊类型',
				field: 'admType',
				width: 75,
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
				title: '主键',
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
 * 界面操作
 */
function Query() {
	// 获取参数
	var formDataArr = PHA.DomData('#gridNarcRegBar', {
		doType: 'query',
		retType: 'Json'
	});
	if (formDataArr.length == 0) {
		return;
	}
	var formData = formDataArr[0];
	formData.hospId = session['LOGON.HOSPID'];
	// 查询
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
		//PHA.Alert('提示', '系统已设置为发药自动登记，无法手动添加！', -1);
		//return;
	}
	if (PHA_COM.VAR.CONFIG['Rec.UseSimple'] == 'Y') {
		PHA.Alert('提示', '系统已设置为使用【简版】登记！', -1);
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
		PHA.Alert('提示', saveRetArr[1], saveRetArr[0]);
	} else {
		PHA.Popover({
			msg: '登记成功!',
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
			msg: '请勾选需要撤消的执行记录!',
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
				msg: '第' + (i + 1) + "行,登记状态不是已登记,无法撤消登记！",
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
	
	PHA.Confirm("温馨提示", "是否确认撤消登记？", function () {
		var saveRetStr = tkMakeServerCall('PHA.IN.NarcReg.Save', 'CancelRegMulti', pJsonStr);
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

function InitConfig() {
	$.cm({
		ClassName: 'PHA.IN.Narc.Com',
		MethodName: 'GetConfigParams',
		InputStr: PHA_COM.Session.ALL
	}, function (retJson) {
		// 传递给全局
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
		// 自动查询
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