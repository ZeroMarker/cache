var MainGrid, ItemGrid, SelectIndex;
var init = function() {
	var DispLocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#CleanLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + DispLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function() {
			var Loc = $('#CleanLoc').combobox('getValue');
			var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId, SupLocId: Loc }));
			var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterMachine&ResultSetType=array&type=sterilizer&Params=' + Params;
			$('#SterMachine').combobox('clear').combobox('reload', url);
		}
	});

	var ReqLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#ToLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var PackTypePData = [
		{ 'RowId': 1, 'Description': '标牌追溯包' },
		{ 'RowId': 2, 'Description': '普通循环包' }
		//, { 'RowId': 10, 'Description': '专科器械包' }
	];

	$HUI.combobox('#AttributeCode', {
		valueField: 'RowId',
		textField: 'Description',
		data: PackTypePData
	});

	$HUI.combobox('#CompFlag', {
		valueField: 'RowId',
		textField: 'Description',
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '完成' }, { 'RowId': 'N', 'Description': '未完成' }]
	});

	var BDPParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#PkgClass', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array&Params=' + BDPParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2', CreateLocId: gLocId }));
	$HUI.combobox('#Pkg', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		onShowPanel: function() {
			var PackTypeDetailVal = $('#AttributeCode').combobox('getValue');
			if (isEmpty(PackTypeDetailVal)) {
				PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: PackTypeDetailVal, CreateLocId: gLocId }));
				$(this).combobox('reload', $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams);
			}
		}
	});

	$('#CodeDict').keyup(function(e) {
		var curKey = e.which;
		if (curKey === 13) {
			var CodeDict = $('#CodeDict').val();
			if (!isEmpty(CodeDict)) {
				Query();
			}
		}
	});

	$HUI.combobox('#PackChkUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + BDPParams,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});

	$HUI.combobox('#PackUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + BDPParams,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});

	$HUI.combobox('#Packer', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + BDPParams,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});

	$HUI.combobox('#SterUser', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + BDPParams,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'Code'
	});

	var Material = $HUI.combobox('#Material', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetBindMaterials&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});

	var ToLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#PackLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ToLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	$HUI.combobox('#SterMachine', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterMachine&ResultSetType=array&type=sterilizer&Params=' + BDPParams,
		valueField: 'RowId',
		textField: 'Description',
		enterNullValueClear: false,
		spellField: 'MachineNo'
	});

	function Query() {
		$UI.clear(MainGrid);
		$UI.clear(ItemGrid);
		SelectIndex = '';
		var ParamsObj = $UI.loopBlock('Conditions');
		if (isEmpty(ParamsObj.CleanLoc)) {
			$UI.msg('alert', '发放科室不能为空！');
			return;
		}
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '起始日期不能为空！');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空！');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		MainGrid.load({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'SelectColCheck',
			Params: Params
		});
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultData();
		}
	});

	$UI.linkbutton('#PackClearBT', {
		onClick: function() {
			$UI.clearBlock('#PackConditions');
			$UI.clear(ItemGrid);
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});

	$UI.linkbutton('#CreateBT', {
		onClick: function() {
			var MainObj = $UI.loopBlock('PackConditions');
			if (isEmpty(MainObj.PackChkUser)) {
				$UI.msg('alert', '审核人不能为空！');
				return;
			}
			if (isEmpty(MainObj.PackUser)) {
				$UI.msg('alert', '包装人不能为空！');
				return;
			}
			if ((PackParamObj.IsPackUser === 'Y') && (isEmpty(MainObj.Packer))) {
				$UI.msg('alert', '配包人不能为空！');
				return;
			}
			var Rows = MainGrid.getSelections();
			if (isEmpty(Rows)) {
				$UI.msg('alert', '请选择需要生成标签的消毒包！');
				return;
			}
			var Num = MainObj.LabelQty;
			var ErrStr = '', UnPackQtyZero = '';
			if (!isEmpty(Num)) {
				var Length = Rows.length;
				for (var i = 0; i < Length; i++) {
					var PkgDesc = Rows[i]['PkgDesc'];
					var UnPackQty = Rows[i]['UnCreateQty'];
					var IsAllCrLbl = Rows[i]['IsAllCrLbl'];
					if (IsAllCrLbl === 'Y') {
						$UI.msg('alert', '标签生成完成不允许重复生成！');
						return;
					}
					if (Number(UnPackQty) === 0) {
						UnPackQtyZero = UnPackQtyZero + ' ' + UnPackQty;
					}
					if (Number(Num) > Number(UnPackQty)) {
						ErrStr = ErrStr + ' ' + PkgDesc;
					}
				}
			}
			if (!isEmpty(UnPackQtyZero)) {
				$UI.msg('alert', UnPackQtyZero + ' 未生成数为0，请重新选择或查询！');
				return;
			}
			if (!isEmpty(ErrStr)) {
				$UI.confirm(ErrStr + ' 生成数大于未生成数，超出消毒包会按照未生成数生成标签，是否继续？', '', '', Create, '', '', '', '', '');
			} else {
				Create();
			}
		}
	});

	function Create() {
		var rowData = MainGrid.getSelections();
		var Conditions = $UI.loopBlock('PackConditions');
		Conditions['CleanItmStr'] = rowData[0]['CleanItmStr'];
		var Main = JSON.stringify(Conditions);
		var Detail = JSON.stringify(rowData);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			MethodName: 'jsCreateColPack',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				SelectIndex = MainGrid.getRowIndex(rowData[0]);
				MainGrid.commonReload();
			} else {
				$UI.msg('alert', jsonData.msg);
			}
		});
	}

	function Print() {
		var MainRow = MainGrid.getSelected();
		var IsLowerSter = MainRow.IsLowerSter;	// 后台增加取值
		var IsSter = MainRow.IsSter;		// 后台增加取值
		var IsExt = MainRow.IsExt;

		var Rows = ItemGrid.getSelections();
		var Length = Rows.length;
		if (Length <= 0) {
			$UI.msg('alert', '请选择要打印的标签');
			return;
		}
		for (var i = 0; i < Length; i++) {
			var Label = Rows[i]['Label'];
			if (IsExt === 'W') {
				printExt(Label, '');
			} else if (IsLowerSter == 'Y') {	// 低温灭菌打印
				printlower(Label, '');
			} else if (IsSter == 'N') {	// 消毒类
				printoutXD(Label, '');
			} else {	// 高温灭菌打印
				printout(Label, '');
			}
		}
		SelectIndex = MainGrid.getRowIndex(MainRow);
		MainGrid.commonReload();
	}

	function PrintNot() {
		var MainRow = MainGrid.getSelected();
		var IsExt = MainRow.IsExt;

		var Rows = ItemGrid.getSelections();
		var Length = Rows.length;
		if (Length <= 0) {
			$UI.msg('alert', '请选择要打印的标签');
			return;
		}
		for (var i = 0; i < Length; i++) {
			var Label = Rows[i]['Label'];
			if (IsExt === 'W') {
				printExtNotDetail(Label, '');
			} else {
				printoutnotitm(Label, '');
			}
		}
		SelectIndex = MainGrid.getRowIndex(MainRow);
		MainGrid.commonReload();
	}

	function FindItem(PkgId, PkgNum, ToLocId, CleanItmStr) {
		var ParamsObj = {
			PkgId: PkgId,
			PkgNum: PkgNum,
			ToLocId: ToLocId,
			CleanItmStr: CleanItmStr
		};
		var Params = JSON.stringify(ParamsObj);
		ItemGrid.load({
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'SelectColPackItm',
			Params: Params
		});
	}

	var MainCm = [[
		{
			title: '操作',
			field: 'Icon',
			width: 60,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				str = str + '<div href="#" title="查看图片" class="col-icon icon-img" onclick="ViewPic(' + row.PkgId + ')"></div>'
					+ '<div href="#" title="查看包明细" class="col-icon icon-paper-info" onclick="FindPackageItem(' + row.PkgId + ',' + row.CleanItmStr + ')"></div>';
				return str;
			}
		}, {
			title: 'CleanItmStr',
			field: 'CleanItmStr',
			saveCol: true,
			width: 100,
			hidden: true
		}, {
			title: 'PkgNum',
			field: 'PkgNum',
			width: 100,
			hidden: true
		}, {
			title: '完成标志',
			field: 'IsAllCrLbl',
			width: 80,
			align: 'center',
			styler: function(value) {
				if (value === 'Y') {
					return 'color:white;background:' + GetColorCode('green');
				} else {
					return 'color:white;background:' + GetColorCode('red');
				}
			},
			formatter: function(value) {
				var status = '';
				if (value === 'Y') {
					status = '已完成';
				} else {
					status = '未完成';
				}
				return status;
			}
		}, {
			title: '消毒包id',
			field: 'PkgId',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 100,
			sortable: true
		}, {
			title: '接收科室id',
			field: 'ToLocId',
			width: 140,
			hidden: true
		}, {
			title: '接收科室',
			field: 'ToLocDesc',
			width: 100,
			sortable: true
		}, {
			title: '未生成数量',
			field: 'UnCreateQty',
			width: 80,
			align: 'right'
		}, {
			title: '总数量',
			field: 'CleanQty',
			width: 80,
			align: 'right'
		}, {
			title: '已生成数量',
			field: 'CreateQty',
			width: 80,
			align: 'right'
		}, {
			title: '已打印数量',
			field: 'PrintCount',
			width: 80,
			align: 'right'
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 100
		}, {
			title: '包属性',
			field: 'AttributeCode',
			width: 100,
			hidden: true
		}, {
			title: '包属性',
			field: 'AttributeDesc',
			width: 100
		}, {
			title: '包分类',
			field: 'PkgClassDesc',
			width: 100
		}, {
			title: '是否低温灭菌',
			field: 'IsLowerSter',
			width: 100
		}, {
			title: '是否灭菌',
			field: 'IsSter',
			width: 100
		}, {
			title: '是否外来器械',
			field: 'IsExt',
			width: 100
		}
	]
	];

	MainGrid = $UI.datagrid('#MainGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			QueryName: 'SelectColCheck'
		},
		columns: MainCm,
		pagination: true,
		onClickRow: function(index, row) {
			MainGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				if (!isEmpty(SelectIndex)) {
					MainGrid.selectRow(SelectIndex);
					SelectIndex = '';
				} else if (CommParObj.SelectFirstRow === 'Y') {
					MainGrid.selectRow(0);
				}
			} else {
				SelectIndex = '';
			}
		},
		onSelect: function(index, rowData) {
			SelectIndex = index;
			var PkgId = rowData.PkgId;
			var PkgNum = rowData.PkgNum;
			var ToLocId = rowData.ToLocId;
			var CleanItmStr = rowData.CleanItmStr;
			if (!isEmpty(PkgId) && !isEmpty(CleanItmStr)) {
				var MaterialUrl = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetBindMaterials&ResultSetType=array&packageDr=' + PkgId;
				Material.clear();
				Material.reload(MaterialUrl);
				FindItem(PkgId, PkgNum, ToLocId, CleanItmStr);
			}
		}
	});

	var ItemCm = [[
		{
			title: '',
			field: 'ck',
			checkbox: true,
			width: 50
		}, {
			title: '操作',
			field: 'Icon',
			width: 100,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '';
				str = str + '<div href="#" title="删除" class="col-icon icon-cancel" onclick="ItemGrid.commonDeleteRow(true,' + index + ');"></div>';
				if (row.LevelFlag === '1') {
					str = str + '<div href="#" title="紧急" class="col-icon icon-emergency"></div>';
				}
				return str;
			}
		}, {
			title: 'RowId',
			field: 'RowId',
			saveCol: true,
			width: 100,
			hidden: true
		}, {
			title: '清洗单明细Id',
			field: 'CleanItmId',
			saveCol: true,
			width: 100,
			hidden: true
		}, {
			title: '打印',
			field: 'IsPrint',
			width: 80,
			styler: function(value) {
				if (value === 'Y') {
					return 'color:white;background:' + GetColorCode('green');
				} else {
					return 'color:white;background:' + GetColorCode('red');
				}
			},
			formatter: function(value) {
				var status = '';
				if (value === 'Y') {
					status = '是';
				} else {
					status = '否';
				}
				return status;
			}
		}, {
			title: '科室',
			field: 'PackLocDesc',
			width: 100,
			hidden: true
		}, {
			title: '消毒包',
			field: 'PkgId',
			width: 150,
			showTip: true,
			tipWidth: 200,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			saveCol: true,
			width: 150
		}, {
			title: '审核人',
			field: 'PackChkUserName',
			width: 100
		}, {
			title: '包装人',
			field: 'PackUserName',
			width: 100
		}, {
			title: '配包人',
			field: 'PackerName',
			width: 100
		}, {
			title: '灭菌人',
			field: 'SterUserName',
			width: 100
		}, {
			title: '包装材料',
			field: 'MaterialDesc',
			width: 100
		}, /* {
			title: "备注",
			field: 'Remark',
			width: 160,
			saveCol: true,
			editor: {
				type: 'text'
			}
		},*/{
			title: '紧急标志',
			field: 'LevelFlag',
			width: 100,
			hidden: true
		}
	]];

	ItemGrid = $UI.datagrid('#ItemGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			MethodName: 'SelectColPackItm'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.Pack.CleanPackLabel',
			MethodName: 'jsDelete'
		},
		columns: ItemCm,
		pagination: false,
		singleSelect: false,
		sortName: 'RowId',
		sortOrder: 'desc',
		toolbar: [
			{
				text: '打印',
				iconCls: 'icon-print',
				handler: function() {
					Print();
				}
			}, {
				text: '无明细打印',
				iconCls: 'icon-print-box',
				handler: function() {
					PrintNot();
				}
			}
		],
		onClickRow: function(index, row) {
			ItemGrid.commonClickRow(index, row);
		},
		afterDelFn: function() {
			MainGrid.commonReload();
		}
	});

	var DefaultData = function() {
		// /设置初始值 考虑使用配置
		$UI.clearBlock('#Conditions');
		$UI.clear(MainGrid);
		$UI.clear(ItemGrid);
		SelectIndex = '';
		var DefaultValue = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			CleanLoc: gLocObj,
			CompFlag: 'N'
		};
		if (PackParamObj.IsPackUser !== 'Y') {
			$('#Packer').combobox({ disabled: true });
		}
		$UI.fillBlock('#Conditions', DefaultValue);
	};
	DefaultData();
	Query();
};
$(init);