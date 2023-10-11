var init = function() {
	// =======================条件初始化start==================
	// 科室
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	if (InStkTkParamObj.AllLoc == 'Y') {
		LocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	}
	var LocBox = $HUI.combobox('#FLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	// ===========================条件初始end===========================
	// ======================tbar操作事件start=========================
	// 清屏
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		var DefaultData = {
			FLoc: gLocObj,
			FStartDate: DateFormatter(new Date()),
			FEndDate: DateFormatter(new Date()),
			FInstComp: 'Y',
			FStkTkComp: 'N',
			FAdjComp: 'N'
		};
		$UI.fillBlock('#Conditions', DefaultData);
	};
	// 查询
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		var StartDate = ParamsObj.FStartDate;
		var EndDate = ParamsObj.FEndDate;
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止日期不能小于开始日期!');
			return;
		}
		$UI.clear(MasterGrid);
		var Params = JSON.stringify(ParamsObj);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	// 选取
	$UI.linkbutton('#CompleteBT', {
		onClick: function() {
			SelectHandler();
		}
	});
	function SelectHandler() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '请选择一条数据!');
			return;
		}
		SelectModel(row, Select);
	}
	
	function Select(SelectModel, InstWin) {
		var row = $('#MasterGrid').datagrid('getSelected');
		var InstId = row.RowId;
		var PhaLoc = row.LocId;
		if (isEmpty(PhaLoc)) {
			$UI.msg('alert', '请选择科室!');
			return;
		}
		// 跳转到相应的录入界面
		if (SelectModel == 1) {
			var UrlStr = 'dhcstmhui.instktkitmwd.csp?RowId=' + InstId + '&LocId=' + PhaLoc + '&InstwWin=' + InstWin;
			Common_AddTab('实盘-批次填充', UrlStr);
		} else if (SelectModel == 2) {
			var UrlStr = 'dhcstmhui.instktkinput.csp?RowId=' + InstId + '&LocId=' + PhaLoc + '&InstwWin=' + InstWin;
			Common_AddTab('实盘-品种填充', UrlStr);
		} else if (SelectModel == 3) {
			var UrlStr = 'dhcstmhui.instktkitmtrack.csp?RowId=' + InstId + '&LocId=' + PhaLoc + '&InstwWin=' + InstWin;
			Common_AddTab('实盘-高值扫码', UrlStr);
		}
	}
	
	// ======================tbar操作事件end============================
	
	var MasterGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 50
		}, {
			title: '盘点单号',
			field: 'InstNo',
			width: 150
		}, {
			title: '账盘日期',
			field: 'FreezeDate',
			width: 100
		}, {
			title: '账盘时间',
			field: 'FreezeTime',
			width: 100
		}, {
			title: '盘点科室',
			field: 'LocId',
			hidden: true
		}, {
			title: '盘点科室',
			field: 'LocDesc',
			width: 150
		}, {
			title: '账盘完成',
			field: 'CompFlag',
			width: 100,
			hidden: true
		}, {
			title: '实盘完成',
			field: 'StkTkCompFlag',
			width: 100,
			hidden: true
		}, {
			title: '调整完成',
			field: 'AdjCompFlag',
			width: 80,
			hidden: true
		}, {
			title: '重点关注标志',
			field: 'ManaFlag',
			width: 100,
			hidden: true
		}, {
			title: '账盘单位',
			field: 'FreezeUomId',
			width: 80,
			formatter: function(value, row, index) {
				if (row.FreezeUomId == 1) {
					return '入库单位';
				} else {
					return '基本单位';
				}
			}
		}, {
			title: '录入类型',
			field: 'InputType',
			width: 100,
			formatter: InputTypeFormatter
		}, {
			title: '包括不可用',
			field: 'IncludeNotUse',
			width: 100,
			hidden: true
		}, {
			title: '仅不可用',
			field: 'OnlyNotUse',
			width: 80,
			hidden: true
		}, {
			title: '不可用标志',
			field: 'NotUseFlag',
			width: 90,
			align: 'left'
		}, {
			title: '高值标志',
			field: 'HVFlag',
			width: 80
		}, {
			title: '类组',
			field: 'StkScgDesc',
			width: 100
		}, {
			title: '库存分类',
			field: 'StkCatDesc',
			width: 100
		}, {
			title: '开始货位码',
			field: 'FrSbDesc',
			width: 100
		}, {
			title: '结束货位码',
			field: 'ToSbDesc',
			width: 100
		}, {
			title: '打印标志',
			field: 'PrintFlag',
			width: 80,
			hidden: true
		}, {
			title: '最低进价',
			field: 'MinRp',
			width: 80,
			align: 'right'
		}, {
			title: '最高进价',
			field: 'MaxRp',
			width: 80,
			align: 'right'
		}, {
			title: '抽查数',
			field: 'RandomNum',
			width: 70,
			align: 'right'
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1
		},
		columns: MasterGridCm,
		onDblClickRow: function(index, row) {
			SelectHandler();
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	Clear();
	Query();
};
$(init);