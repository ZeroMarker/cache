
// ps: 使用高值的时候, 需要过滤掉HVFlag="Y"的
// 切换科室时要处理datagrid数据?清空?
var init = function() {
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		if (isEmpty(ParamsObj['ToLoc'])) {
			$UI.msg('alert', '接收科室不可为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByLim',
			QueryName: 'RecLocItmForTransfer',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('Conditions');
			$UI.clear(DetailGrid);
			SetDefaValues();
		}
	});
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		var Detail = DetailGrid.getRowsData();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '没有需要保存的数据!');
			return;
		}
		var InitFrLoc = $('#FrLoc').combobox('getValue');
		if (isEmpty(InitFrLoc)) {
			$UI.msg('alert', '科室不可为空!');
			return;
		}
		var InitToLoc = $('#ToLoc').combobox('getValue');
		if (isEmpty(InitToLoc)) {
			$UI.msg('alert', '接收科室不可为空!');
			return;
		}
		if (InitFrLoc == InitToLoc) {
			$UI.msg('alert', '出库科室不允许与接收科室相同!');
			return;
		}
		var InitScg = $('#ScgId').combobox('getValue');
		
		var MainObj = { InitFrLoc: InitFrLoc, InitToLoc: InitToLoc, InitComp: 'N', InitState: '10', InitUser: gUserId,
			InitScg: InitScg };
		var Main = JSON.stringify(addSessionParams(MainObj));
		
		if (Detail === false) {
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			MethodName: 'jsSave',
			Main: Main,
			Detail: JSON.stringify(Detail)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.clear(DetailGrid);
				$UI.msg('success', jsonData.msg);
				var InitId = jsonData.rowid;
				var UrlStr = 'dhcstmhui.dhcinistrf.csp?RowId=' + InitId;
				Common_AddTab('出库', UrlStr);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	var FrLoc = $HUI.combobox('#FrLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'Login', Element: 'FrLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var FrLoc = record['RowId'];
			var ToLoc = $('#ToLoc').combobox('getValue');
			$HUI.combotree('#ScgId').setFilterByLoc(FrLoc, ToLoc);
		}
	});
	$('#FrLoc').combobox('setValue', session['LOGON.CTLOCID']);
	
	var ToLoc = $HUI.combobox('#ToLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'All', Element: 'ToLoc' })),
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var ToLoc = record['RowId'];
			var FrLoc = $('#FrLoc').combobox('getValue');
			$HUI.combotree('#ScgId').setFilterByLoc(FrLoc, ToLoc);
		}
	});
	
	var AuxToLoc = $HUI.combobox('#AuxToLoc', {
		url: $URL
			+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='
			+ JSON.stringify(addSessionParams({ Type: 'All', Element: 'AuxToLoc' })),
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var DetailCm = [[
		{
			title: '物资Id',
			field: 'InciId',
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150,
			sortable: true
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 180,
			sortable: true
		}, {
			title: '批次Id',
			field: 'Inclb',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 150,
			align: 'left',
			sortable: true
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 180,
			align: 'left',
			sortable: true
		}, {
			title: '转移数量',
			field: 'Qty',
			saveCol: true,
			width: 90,
			align: 'right',
			sortable: true
		}, {
			title: '单位Id',
			field: 'UomId',
			saveCol: true,
			width: 80,
			align: 'left',
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80,
			align: 'left'
		}, {
			title: '售价',
			field: 'Sp',
			width: 60,
			align: 'right',
			sortable: true
		}, {
			title: '货位码',
			field: 'StkbinDesc',
			width: 100,
			align: 'left',
			sortable: true
		}, {
			title: '批次库存',
			field: 'StkQty',
			width: 90,
			align: 'right',
			sortable: true
		}, {
			title: '占用数量',
			field: 'DirtyQty',
			width: 90,
			align: 'right',
			sortable: true
		}, {
			title: '可用数量',
			field: 'AvaQty',
			width: 90,
			align: 'right',
			sortable: true
		}, {
			title: '请求方总库存',
			field: 'CurQty',
			width: 150,
			align: 'right',
			sortable: true
		}, {
			title: '请求方标准库存',
			field: 'RepQty',
			width: 150,
			align: 'right',
			sortable: true
		}, {
			title: '参考库存',
			field: 'LevelQty',
			width: 90,
			align: 'right',
			sortable: true
		}, {
			title: '库存上限',
			field: 'MaxQty',
			width: 90,
			align: 'right',
			sortable: true
		}, {
			title: '库存下限',
			field: 'MinQty',
			width: 90,
			align: 'right',
			sortable: true
		}
	]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfAuxByLim',
			QueryName: 'RecLocItmForTransfer',
			query2JsonStrict: 1,
			rows: 99999
		},
		columns: DetailCm,
		showBar: true,
		pagination: false,
		remoteSort: false,
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	// 设置缺省值
	function SetDefaValues() {
		$('#FrLoc').combobox('setValue', gLocId);
	}
	
	SetDefaValues();
};
$(init);