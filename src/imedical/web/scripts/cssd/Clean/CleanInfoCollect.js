// 清洗制单
var CleanList, ItemListGrid;
var CurrMainId;
var init = function() {
	// 获取页面传参
	function getQueryVariable(variable) {
		var query = window.location.search.substring(1);
		var vars = query.split('&');
		for (var i = 0; i < vars.length; i++) {
			var pair = vars[i].split('=');
			if (pair[0] === variable) {
				return pair[1];
			}
		}
		return (false);
	}
	var IsManualTemp = '';
	var ParamsTB = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	var CleanLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#CleanLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + CleanLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var CleanTypeId = $('#CleanType').combobox('getValue');
			var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TempType: CleanTypeId, SupLocId: record.RowId }));
			var Url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&ResultSetType=array&type="washer"&Params=' + Params;
			$('#CleanMachine').combobox('reload', Url).combobox('clear');
		}
	});
	$HUI.combobox('#CleanType', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCleanType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code',
		onSelect: function(record) {
			IsManualTemp = record.IsManualTemp;	// 是否手工清洗
			if (IsManualTemp === 'Y') {
				$('#CleanMachine').combobox('disable');
				$('#CleanMachine').combobox('setValue', '');
				$('#CleanStro').combobox('disable');
				$('#CleanStro').combobox('setValue', '');
			} else {
				$('#CleanMachine').combobox('enable');
				$('#CleanStro').combobox('enable');
				var MachineId = $('#CleanMachine').combobox('getValue');
				if ((CleanParamObj.IsMachineBindType == 'Y') && isEmpty(MachineId)) {		// 清洗机与清洗方式是一对一绑定
					var CleanTypeId = record.RowId;
					var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TempType: CleanTypeId }));
					var Url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&ResultSetType=array&type="washer"&Params=' + Params;
					$('#CleanMachine').combobox('reload', Url).combobox('clear');
				}
			}
		},
		onBeforeLoad: function(param) {
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		},
		onShowPanel: function(record) {
			$('#CleanMachine').combobox('enable');
			$('#CleanStro').combobox('enable');
		}

	});

	$('#CleanType').combobox('textbox').keyup(function(event) {
		var curKey = event.which;
		if (curKey == 13) {
			var CleanTypeVal = $('#CleanType').combobox('getText');
			if (isEmpty(CleanTypeVal)) {
				$UI.msg('alert', '请录入清洗方式!');
				return;
			}
			var CleanTypeObj = $.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'GetCleanType',
				CleanCode: CleanTypeVal,
				Params: ParamsTB
			}, false);
			var CleanTypeId = CleanTypeObj['CleanTypeId'];
			if (isEmpty(CleanTypeId)) {
				$UI.msg('alert', '请录入可用的清洗方式!');
				$('#CleanType').combobox('setText', '');
				$('#CleanType').combobox('textbox').focus();
				return;
			}
			$('#CleanType').combobox('setValue', CleanTypeId);
			IsManualTemp = CleanTypeObj['CleanTypeIsManualTemp'];
			SetFocusAdd();
		}
	});

	$HUI.combobox('#CleanMachine', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		onSelect: function(record) {
			if (CleanParamObj.IsMachineBindType == 'Y') {
				$('#CleanType').combobox('setValue', record['TempType']);
			}
		},
		onBeforeLoad: function(param) {
			param.type = 'washer';
			var CleanTypeId = $('#CleanType').combobox('getValue');
			var SupLocId = $('#CleanLoc').combobox('getValue');
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TempType: CleanTypeId, SupLocId: SupLocId }));
		}
	});

	$('#CleanMachine').combobox('textbox').keyup(function(event) {
		if (event.which == 13) {
			var MachineVal = $('#CleanMachine').combobox('getText');
			if (isEmpty(MachineVal)) {
				$UI.msg('alert', '请录入清洗机！');
				return;
			}
			var CleanTypeId = $('#CleanType').combobox('getValue');
			var SupLocId = $('#CleanLoc').combobox('getValue');
			var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TempType: CleanTypeId, SupLocId: SupLocId }));
			var MachineObj = $.cm({
				ClassName: 'web.CSSDHUI.Common.Dicts',
				MethodName: 'GetMachineNo',
				Type: 'washer',
				MachineNo: MachineVal,
				Params: Params
			}, false);
			var MachineId = MachineObj['ID'];
			if (isEmpty(MachineId)) {
				$UI.msg('alert', '请录入可用的清洗机!');
				$('#CleanMachine').combobox('setValue', '');
				$('#CleanMachine').combobox('textbox').focus();
				return;
			}
			$('#CleanMachine').combobox('setValue', MachineId);
			if (CleanParamObj.IsMachineBindType == 'Y') {
				$('#CleanType').combobox('setValue', MachineObj['TempType']);
			}
			IsManualTemp = 'N';
			SetFocusAdd();
		}
	});

	var CleanType = '1001';	// 清洗程序
	$HUI.combobox('#CleanStro', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetProCom&ResultSetType=array&type=' + CleanType,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code',
		onBeforeLoad: function(param) {
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		}
	});

	$('#CleanStro').combobox('textbox').keyup(function(event) {
		var CurKey = event.which;
		if (CurKey == 13) {
			var CleanStroVal = $('#CleanStro').combobox('getText');
			if (isEmpty(CleanStroVal)) {
				$UI.msg('alert', '请录入清洗程序！');
				return;
			}
			var CleanStroObj = $.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'GetCleanPro',
				CleanCode: CleanStroVal,
				Params: ParamsTB
			}, false);
			var CleanProId = CleanStroObj['CleanProId'];
			if (isEmpty(CleanProId)) {
				$UI.msg('alert', '请录入可用的清洗程序!');
				$('#CleanStro').combobox('setValue', '');
				$('#CleanStro').combobox('textbox').focus();
				return;
			}
			$('#CleanStro').combobox('setValue', CleanProId);
			SetFocusAdd();
		}
	});

	// 清洗架
	var PackTypeDetail = '3';
	$HUI.combobox('#CleanBasket', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllSterCar&ResultSetType=array&PackTypeDetail=' + PackTypeDetail + '&Params=' + ParamsTB,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code',
		onSelect: function(record) {
			Query();
		}
	});

	$('#CleanBasket').combobox('textbox').keyup(function(event) {
		if (event.which == 13) {
			var BasketVal = $('#CleanBasket').combobox('getText');
			if (BasketVal !== '') {
				var CleanObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetSterCar',
					type: '3',
					SterCar: BasketVal,
					Params: ParamsTB
				}, false);
				if (isEmpty(CleanObj['DictId'])) {
					$UI.msg('alert', '未获取到可用的清洗架！');
					$('#CleanBasket').combobox('setValue', '');
					$('#CleanBasket').combobox('textbox').focus();
					return;
				}
				$('#CleanBasket').combobox('setValue', CleanObj['DictId']);
			}
		}
	});

	$('#StartTime').focus(function(enent) {
		var value = $('#StartTime').timespinner('getValue');
		if (isEmpty(value)) {
			var Time = GetNowTime();
			$('#StartTime').timespinner('setValue', Time);
		}
	});

	$HUI.combobox('#Cleaner', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code',
		onBeforeLoad: function(param) {
			param.Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
		}
	});

	$('#Cleaner').combobox('textbox').keyup(function(event) {
		if (event.keyCode == 13) {
			var CleanerVal = $('#Cleaner').combobox('getText');
			if (isEmpty(CleanerVal)) {
				if (CleanParamObj.IsGetCleanUserByLogin == 'Y') {
					$('#Cleaner').combobox('setValue', gUserId);
				} else {
					$UI.msg('alert', '请录入清洗人！');
					return;
				}
			} else {
				var UserObj = $.cm({
					ClassName: 'web.CSSDHUI.Common.Dicts',
					MethodName: 'GetUserByCodeJson',
					userCode: CleanerVal,
					Params: ParamsTB
				}, false);
				var UserId = UserObj['RowId'];
				if (isEmpty(UserId)) {
					$UI.msg('alert', '请录入正确的清洗人！');
					$('#Cleaner').combobox('setValue', '');
					$('#Cleaner').combobox('textbox').focus();
					return;
				}
				$('#Cleaner').combobox('setValue', UserId);
			}
			SetFocusAdd();
		}
	});

	function SetFocusAdd() {
		if (IsManualTemp == 'Y') {
			$('#CleanMachine').combobox('disable');
			$('#CleanMachine').combobox('setValue', '');
			$('#CleanStro').combobox('disable');
			$('#CleanStro').combobox('setValue', '');
		}
		if (isEmpty($('#CleanType').combobox('getValue'))) {
			IsManualTemp = '';
			$('#CleanType').combobox('textbox').focus();
			return;
		}
		if ((IsManualTemp == 'N') && (isEmpty($('#CleanMachine').combobox('getValue')))) {
			if (CleanParamObj.IsMachineBindType == 'Y') {		// 清洗机与清洗方式是一对一绑定
				var CleanTypeId = $('#CleanType').combobox('getValue');
				var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TempType: CleanTypeId }));
				var Url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&ResultSetType=array&type="washer"&Params=' + Params;
				$('#CleanMachine').combobox('reload', Url).combobox('clear');
			}
			$('#CleanMachine').combobox('textbox').focus();
			return;
		}
		if ((IsManualTemp == 'N') && (isEmpty($('#CleanStro').combobox('getValue')))) {
			$('#CleanStro').combobox('textbox').focus();
			return;
		}
		if (isEmpty($('#Cleaner').combobox('getValue'))) {
			$('#Cleaner').combobox('textbox').focus();
			return;
		}
		Add();
	}

	function Add() {
		var MainObj = $UI.loopBlock('#CleanTable');
		if (isEmpty(MainObj.CleanLoc)) {
			$UI.msg('alert', '请选择清洗科室！');
			$('#CleanLoc').combobox('textbox').focus();
			return;
		}
		if (isEmpty(MainObj.CleanType)) {
			$UI.msg('alert', '请选择清洗方式！');
			$('#CleanType').combobox('textbox').focus();
			return;
		}
		if (IsManualTemp == 'N') {
			if (isEmpty(MainObj.CleanMachine)) {
				$UI.msg('alert', '请选择清洗机！');
				$('#CleanMachine').combobox('textbox').focus();
				return;
			}
			if (isEmpty(MainObj.CleanStro)) {
				$UI.msg('alert', '请选择清洗程序！');
				$('#CleanStro').combobox('textbox').focus();
				return;
			}
		}
		if (isEmpty(MainObj.Cleaner)) {
			if (CleanParamObj.IsGetCleanUserByLogin == 'Y') {
				MainObj.Cleaner = gUserId;
			} else {
				$UI.msg('alert', '请录入清洗人！');
				$('#Cleaner').combobox('textbox').focus();
				return;
			}
		}
		var Params = JSON.stringify(MainObj);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsSaveClean',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				CurrMainId = jsonData.rowid;
				Default();
				if (!isEmpty(jsonData.rowid)) {
					Query(jsonData.rowid);
				}
				$('#CodeDictId').val('').focus();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#AddBT', {
		onClick: function() {
			Add();
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('CleanTable');
			if (isEmpty(ParamsObj.CleanLoc)) {
				$UI.msg('alert', '科室不能为空！');
				return;
			} else if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '开始日期不能为空！');
				return;
			} else if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空！');
				return;
			} else {
				Query();
			}
		}
	});

	function Query(RowId) {
		$UI.clear(CleanList);
		$UI.clear(ItemListGrid);
		var ParamsObj = $UI.loopBlock('CleanTable');
		if (!isEmpty(RowId)) {
			ParamsObj.CleanId = RowId;
		}
		var Params = JSON.stringify(ParamsObj);
		CleanList.load({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectAll',
			Params: Params
		});
	}

	function CmtEnterMachine(ComParamsObj) {
		var Params = JSON.stringify(ComParamsObj);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsCmtEnterMachine',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				CleanList.reload();
				CurrMainId = jsonData.rowid;
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#CommitBT', {
		onClick: function() {
			var Rows = CleanList.getSelected();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要确认清洗的记录！');
				return;
			}
			if (Rows.IsCmtEnterMachine == '1') {
				$UI.msg('alert', '已经确认清洗，不能再次进行清洗操作！');
				return;
			}
			if (ItemListGrid.getRows() == '') {
				$UI.msg('alert', '没有明细不能进行清洗操作！');
				return;
			}
			var ParamsObj = $UI.loopBlock('#CleanTable');
			var StartTime = ParamsObj.StartTime;
			var CurTime = GetNowTime();
			var ComParamsObj = { Id: Rows.RowId, StartTime: StartTime };
			if (!isEmpty(StartTime) && (StartTime > CurTime)) {
				$UI.confirm('所选清洗时间晚于当前时间,是否继续执行?', '', '', CmtEnterMachine, '', '', '', '', ComParamsObj);
			} else if (isEmpty(StartTime)) {
				$UI.confirm('清洗时间为空，是否继续执行清洗操作?', '', '', CmtEnterMachine, '', '', '', '', ComParamsObj);
			} else {
				CmtEnterMachine(ComParamsObj);
			}
		}
	});

	$UI.linkbutton('#CancelBT', {
		onClick: function() {
			var Rows = CleanList.getSelected();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要撤销清洗的记录！');
				return;
			}
			if (Rows.IsCmtEnterMachine == '0') {
				$UI.msg('alert', '未确认清洗，不能撤销清洗操作！');
				return;
			}
			if (Rows.IsCheck !== '') {
				$UI.msg('alert', '该清洗单据已验收，不能撤销清洗操作！');
				return;
			}
			var Params = JSON.stringify({ CleanId: Rows.RowId });
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.Clean.CleanInfo',
				MethodName: 'jsCancelEnterMachine',
				Params: Params
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					CleanList.reload();
					CurrMainId = Rows.RowId;
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	function flagColor(val, row, index) {
		if (val === '1') {
			return 'color:white;background:' + GetColorCode('green');
		} else if (val === '0') {
			return 'color:white;background:' + GetColorCode('red');
		}
	}

	var Cm = [
		[{
			title: '操作',
			field: 'MachineN',
			width: 120,
			frozen: true,
			align: 'center',
			formatter: function(val, row, index) {
				var str = '';
				if (row.IsCmtEnterMachine !== '1') {
					str = str + '<div class="icon-cancel col-icon"  href="#"  title="删除" onclick="CleanList.commonDeleteRow(true,' + index + ');"></div>';
				}
				if (row.LevelFlag === '1') {
					str = str + '<div href="#" class="icon-emergency col-icon" title="紧急"></div>';
				}
				if (row.BeInfected === 'Y') {
					str = str + '<div href="#" class="icon-virus col-icon" title="感染"></div>';
				}
				// 清洗信息记录
				str = str + '<div href="#" class="icon-paper-info col-icon" title="清洗信息" onclick="SetleanTypeDetail(' + row.RowId + ');"></div>';
				return str;
			}
		}, {
			title: '清洗科室',
			field: 'CleanLoc',
			width: 100
		}, {
			title: '确认清洗',
			field: 'IsCmtEnterMachine',
			width: 70,
			styler: flagColor,
			formatter: function(value) {
				var status = '';
				if (value === '1') {
					status = '已确认';
				} else {
					status = '未确认';
				}
				return status;
			}
		}, {
			title: '验收结果',
			field: 'IsCheck',
			width: 70,
			align: 'center',
			styler: flagColor,
			formatter: function(value) {
				var status = '';
				if (value === '1') {
					status = '合格';
				} else if (value === '0') {
					status = '不合格';
				} else {
					status = '未验收';
				}
				return status;
			}
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '清洗批号',
			field: 'CleanNum',
			width: 140
		}, {
			title: '清洗机',
			field: 'MachineAlias',
			width: 60,
			align: 'center'
		}, {
			title: '清洗架',
			field: 'CleanBasketDesc',
			width: 180
		}, {
			title: '清洗方式',
			field: 'CleanTypeDesc',
			width: 100
		}, {
			title: '清洗程序',
			field: 'CleanProDesc',
			width: 100
		}, {
			title: '日期',
			field: 'CleanDate',
			width: 160
		}, {
			title: '时间',
			field: 'CleanTime',
			width: 100,
			hidden: true
		}, {
			title: '清洗人',
			field: 'CleanerName',
			width: 100
		}, {
			title: '验收人',
			field: 'ChkerName',
			width: 100
		}, {
			title: '是否验收',
			field: 'IsCheck',
			width: 80,
			hidden: true
		}, {
			title: '感染标志',
			field: 'BeInfected',
			width: 50,
			hidden: true
		}
		]
	];

	CleanList = $UI.datagrid('#CleanList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectAll',
			Params: ParamsTB
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsDeleteMain'
		},
		columns: Cm,
		sortName: 'RowId',
		sortOrder: 'desc',
		pagination: true,
		remoteSort: false,
		onClickRow: function(index, row) {
			CleanList.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				var GridListIndex = '';
				if (!isEmpty(CurrMainId)) {
					var Rows = $('#CleanList').datagrid('getRows');
					$.each(Rows, function(index, item) {
						if (item.RowId == CurrMainId) {
							GridListIndex = index;
							return false;
						}
					});
					CurrMainId = '';
				} else if (CommParObj.SelectFirstRow == 'Y') {
					GridListIndex = 0;
				}
				if (!isEmpty(GridListIndex)) {
					$('#CleanList').datagrid('selectRow', GridListIndex);
				}
			}
		},
		afterDelFn: function() {
			$UI.clear(ItemListGrid);
		},
		onSelect: function(index, rowData) {
			var Row = CleanList.getRows()[index];
			var Id = Row.RowId;
			var IsCmt = Row.IsCmtEnterMachine;
			if (!isEmpty(Id)) {
				FindItemByF(Id);
			}
		}
	});

	/* ----------明细------------*/
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '2' }));
	$HUI.combobox('#CommonPkg', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	// 方式一：普通循环包
	$UI.linkbutton('#ComPkgCreateBT', {
		onClick: function() {
			CommonPackageAdd();
		}
	});

	$('#ComPkgNum').keypress(function(event) {
		if (event.which === 13) {
			CommonPackageAdd();
		}
	});

	function CommonPackageAdd() {
		var row = $('#CleanList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要添加的清洗单据!');
			return;
		}
		if (row.IsCmtEnterMachine === 1) {
			$UI.msg('alert', '已经确认清洗无法继续添加明细!');
			$('#CommonPkg').combobox('setValue', '');
			$('#ComPkgNum').numberbox('setValue', '');
			return;
		}
		var PkgId = $('#CommonPkg').combobox('getValue');
		var Num = $('#ComPkgNum').val();
		if (isEmpty(PkgId)) {
			$UI.msg('alert', '请选择需要添加的普通循环包!');
			return;
		}
		if (isEmpty(Num)) {
			$UI.msg('alert', '请输入合适的数量!');
			return;
		}
		var Params = JSON.stringify(addSessionParams({ MainId: row.RowId, PkgId: PkgId, PkgNum: Num }));
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'JsSaveCommonPackage',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				ItemListGrid.reload();
				$UI.clearBlock('#CleanDetailTable');
			} else {
				$UI.msg('error', jsonData.msg);
			}
			$('#CommonPkg').combobox('setValue', '');
			$('#ComPkgNum').numberbox('setValue', '');
		});
	}

	// 方式二：扫码动作（标牌追溯包，清洗筐）
	$('#CodeDictId').keyup(function(event) {
		if (event.which === 13) {
			AddCleanItem();
		}
	}).focus(function(event) {
		$('#CodeDictId').val('');
		$('#BarCodeHidden').val('');
		var ReadOnly = $('#CodeDictId').attr('readonly');
		if (ReadOnly === 'readonly') {
			$('#BarCodeHidden').focus();
		}
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});

	$('#BarCodeHidden').keyup(function(event) {
		if (event.which === 13) {
			var HiddenVal = $('#BarCodeHidden').val();
			$('#CodeDictId').val(HiddenVal);
			$('#BarCodeHidden').val('');
			AddCleanItem();
		}
	}).focus(function(enent) {
		InitScanIcon();
	}).blur(function(event) {
		InitScanIcon();
	});

	// 控制是否允许编辑
	$('#BarCodeSwitchBT').linkbutton({
		iconCls: 'icon-w-switch',
		onClick: function() {
			var ReadOnly = $('#CodeDictId').attr('readonly');
			if (ReadOnly === 'readonly') {
				$('#CodeDictId').attr({ readonly: false });
				SetLocalStorage('BarCodeHidden', '');
			} else {
				$('#CodeDictId').attr({ readonly: true });
				SetLocalStorage('BarCodeHidden', 'Y');
			}
			$('#CodeDictId').focus();
		}
	});

	// 控制扫码图标
	function InitScanIcon() {
		var ElementId = document.activeElement.id;
		var ReadOnly = $('#CodeDictId').attr('readonly');
		if (ElementId === 'BarCodeHidden') {
			// 扫描icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-scanning' });
		} else if (ReadOnly === 'readonly') {
			// 只读icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-gray-edit' });
		} else {
			// 可编辑icon
			$('#UseBarCodeBT').linkbutton({ iconCls: 'icon-blue-edit' });
		}
	}
	if (GetLocalStorage('BarCodeHidden') === 'Y') {
		$('#CodeDictId').attr({ 'readonly': true });
	} else {
		$('#CodeDictId').attr({ 'readonly': false });
	}
	InitScanIcon();

	function AddCleanItem() {
		var label = $('#CodeDictId').val();
		var row = $('#CleanList').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择需要添加的清洗单据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '请选择清洗单据!');
			return;
		}
		if (row.IsCmtEnterMachine === 1) {
			$UI.msg('alert', '已经确认清洗无法继续添加明细!');
			$('#CodeDictId').val('');
			return;
		}
		if (isEmpty(label)) {
			$UI.msg('alert', '未获取到扫描的标签!');
			return;
		}
		var ParamsObj = $UI.loopBlock('CleanDetailTable');
		ParamsObj.MainId = row.RowId;
		showMask();
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		$.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsSaveCleanDetail',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				ItemListGrid.reload();
				if (!isEmpty(jsonData.rowid)) {
					CurrMainId = jsonData.rowid;
				}
			} else {
				$UI.msg('error', jsonData.msg);
			}
			$('#CodeDictId').val('').focus();
		});
	}

	// 待清洗公用包-按回收记录
	$UI.linkbutton('#AddCallBackBT', {
		onClick: function() {
			var row = $('#CleanList').datagrid('getSelected');
			if (!isEmpty(row)) {
				if (row.IsCmtEnterMachine === 1) {
					$UI.msg('alert', '已经确认清洗无法继续添加明细!');
					return;
				}
			}
			CallBackCleanOrdWin(FindItemByF);
		}
	});

	// 待清洗不合格包添加弹出框按钮
	$UI.linkbutton('#AddUnPassCleanBtn', {
		onClick: function() {
			var row = $('#CleanList').datagrid('getSelected');
			if (!isEmpty(row)) {
				if (row.IsCmtEnterMachine === 1) {
					$UI.msg('alert', '已经确认清洗无法继续添加明细!');
					return;
				}
			}
			UnPassCleanWin(FindItemByF);
		}
	});

	// 待灭菌不合格包添加弹出框按钮
	$UI.linkbutton('#AddUnPassSterBtn', {
		onClick: function() {
			var row = $('#CleanList').datagrid('getSelected');
			if (!isEmpty(row)) {
				if (row.IsCmtEnterMachine === 1) {
					$UI.msg('alert', '已经确认清洗无法继续添加明细!');
					return;
				}
			}
			UnPassSterWin(FindItemByF);
		}
	});

	// 待添加外来器械包添加弹出框按钮
	$UI.linkbutton('#AddExtBT', {
		onClick: function() {
			var row = $('#CleanList').datagrid('getSelected');
			if (!isEmpty(row)) {
				if (row.IsCmtEnterMachine === 1) {
					$UI.msg('alert', '已经确认清洗无法继续添加明细!');
					return;
				}
			}
			UnCleanExtWin(FindItemByF);
		}
	});

	// 紧急包（绿色通道）
	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			var row = $('#CleanList').datagrid('getSelected');
			if (!isEmpty(row)) {
				if (row.IsCmtEnterMachine === 1) {
					$UI.msg('alert', '已经确认清洗无法继续添加明细!');
					return;
				}
			}
			SelCallBackItm(FindItemByF);
		}
	});

	// 待清洗过期处理包添加弹出框按钮
	$UI.linkbutton('#AddExpireDealBtn', {
		onClick: function() {
			var row = $('#CleanList').datagrid('getSelected');
			if (!isEmpty(row)) {
				if (row.IsCmtEnterMachine === 1) {
					$UI.msg('alert', '已经确认清洗无法继续添加明细!');
					return;
				}
			}
			ExpireDealWin(FindItemByF);
		}
	});

	function FindItemByF(Id) {
		ItemListGrid.load({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			QueryName: 'SelectCleanDetail',
			Params: Id,
			rows: 99999
		});
	}

	var ItemCm = [
		[{
			field: 'ck',
			checkbox: true,
			frozen: true,
			width: 50
		}, {
			field: 'operate',
			title: '操作',
			align: 'center',
			width: 90,
			frozen: true,
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				if (row.Iscmt == '0') {
					str = str + '<div class="col-icon icon-cancel"  href="#"  title="删除" onclick="ItemListGrid.commonDeleteRow(false,' + index + ');"></div>';
				}
				if (row.LevelFlag == '1') {
					str = str + '<div href="#" class="col-icon icon-emergency" title="紧急"></div>';
				}
				if (row.BeInfected == 'Y') {
					str = str + '<div href="#" class="col-icon icon-virus" title="感染"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 120,
			showTip: true,
			tipWidth: 200
		}, {
			title: '标牌',
			field: 'CodeDictId',
			width: 100
		}, {
			title: '数量',
			field: 'TotalQty',
			width: 50,
			align: 'right'
		}, {
			title: '回收单号',
			field: 'ApplyNo',
			width: 120
		}, {
			title: '科室',
			field: 'BackLocDesc',
			width: 100
		}, {
			title: '是否清洗',
			field: 'Iscmt',
			width: 100,
			hidden: true
		}, {
			title: '紧急状态',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}, {
			title: '感染标志',
			field: 'BeInfected',
			width: 50,
			hidden: true
		}
		]
	];
	ItemListGrid = $UI.datagrid('#ItemList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'SelectCleanDetail',
			rows: 99999
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'jsDelete'
		},
		toolbar: [{
			id: 'DeleteAll',
			text: '删除',
			iconCls: 'icon-cancel',
			handler: function() {
				ItemListGrid.commonDeleteRow(true);
			}
		}],
		columns: ItemCm,
		pagination: false,
		singleSelect: false,
		remoteSort: false,
		sortName: 'RowId',
		sortOrder: 'asc',
		onLoadSuccess: function(data) {
			GetMarkQty();
		}
	});

	// 显示数量角标
	function GetMarkQty() {
		var ParamsObj = {};
		ParamsObj.StartDate = DefaultStDate();
		ParamsObj.EndDate = DefaultEdDate();
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		var MarkQtyObj = $.cm({
			ClassName: 'web.CSSDHUI.Clean.CleanInfo',
			MethodName: 'GetMarkQty',
			Params: Params
		}, false);
		$('#CallBackNum').html(MarkQtyObj.CallBackNum);
		$('#CreateNum').html(MarkQtyObj.CreateNum);
		$('#OprNum').html(MarkQtyObj.OprNum);
		$('#ExtNum').html(MarkQtyObj.ExtNum);
		$('#UnPassCleanNum').html(MarkQtyObj.UnPassCleanNum);
		$('#UnPassSterNum').html(MarkQtyObj.UnPassSterNum);
		$('#ExpireDealNum').html(MarkQtyObj.ExpireDealNum);
	}

	var Default = function() {
		var StartDate = getQueryVariable('StartDate');
		$UI.clearBlock('#CleanTable');
		$UI.clear(CleanList);
		$UI.clear(ItemListGrid);
		IsManualTemp = '';
		$('#CleanMachine').combobox('enable');
		$('#CleanType').combobox('enable');
		$('#CleanStro').combobox('enable');
		var DefaultValue = {
			StartDate: StartDate,
			EndDate: DefaultEdDate(),
			CleanLoc: gLocId
		};
		$UI.fillBlock('#CleanTable', DefaultValue);
		$('#CleanMachine').combobox('textbox').focus();
	};
	Default();
	Query();
	GetMarkQty();
};
$(init);

function SetleanTypeDetail(RowId) {
	SetCleanTypeDetailWin(RowId);
}