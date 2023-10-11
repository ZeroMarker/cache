// 盘点汇总
var init = function() {
	// =======================条件初始化start==================
	
	// 科室
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	if (InStkTkParamObj.AllLoc == 'Y') {
		LocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	}
	$HUI.combobox('#FLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#FStkTkComp', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'N', 'Description': '未完成' }, { 'RowId': 'Y', 'Description': '已完成' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	// ===========================条件初始end===========================
	// ======================tbar操作事件start=========================
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
		ParamsObj.FInstComp = 'Y';
		ParamsObj.FAdjComp = 'N';
		ParamsObj.FInputFlag = 'Y';
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		$UI.clear(InstItmGrid);
		$UI.clear(InstDetailGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	// 取消完成
	$UI.linkbutton('#CancelCompleteBT', {
		onClick: function() {
			CancelComplete();
		}
	});
	function CancelComplete() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'jsStkCancelComplete',
			Inst: row.RowId
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 确定完成
	$UI.linkbutton('#CompleteBT', {
		onClick: function() {
			Complete();
		}
	});
	function Complete() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		if (row.StkTkCompFlag == 'Y') {
			$UI.msg('alert', '盘点单已经汇总完成!');
			return;
		}
		var clName = '';
		var mName = '';
		if (row.InputType == 1) {
			clName = 'web.DHCSTMHUI.INStkTkItmWd';
			mName = 'jsCompleteWd';
		} else if (row.InputType == 2) {
			clName = 'web.DHCSTMHUI.InStkTkInput';
			mName = 'jsCompleteInput';
		} else if (row.InputType == 3) {
			clName = 'web.DHCSTMHUI.INStkTkItmTrack';
			mName = 'jsCompleteItmTrack';
		}
		showMask();
		$.cm({
			ClassName: clName,
			MethodName: mName,
			Inst: row.RowId,
			UserId: gUserId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success >= 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 清屏
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			FLoc: gLocObj,
			FStartDate: DateFormatter(new Date()),
			FEndDate: DateFormatter(new Date()),
			FInstComp: 'Y',
			FStkTkComp: 'N',
			FAdjComp: 'N'
		};
		$UI.fillBlock('#Conditions', DefaultData);
	}
	// 加载物资汇总信息
	function loadDetailGrid() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			QueryName: 'CollectItmCountQty',
			query2JsonStrict: 1,
			Inst: row.RowId
		});
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
			width: 80
		}, {
			title: '科室',
			field: 'LocDesc',
			width: 150
		}, {
			title: '账盘完成',
			field: 'CompFlag',
			width: 80,
			hidden: true
		}, {
			title: '实盘完成',
			field: 'StkTkCompFlag',
			width: 80,
			formatter: function(value, row, index) {
				if (row.StkTkCompFlag == 'Y') {
					return '已完成';
				} else {
					return '未完成';
				}
			}
		}, {
			title: '调整完成',
			field: 'AdjCompFlag',
			width: 80,
			hidden: true
		}, {
			title: '标志',
			field: 'ManaFlag',
			width: 80,
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
			title: '账盘金额',
			field: 'SumFreezeRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '实盘金额',
			field: 'SumCount1RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '损益金额',
			field: 'SumVariance1RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '不可用标志',
			field: 'NotUseFlag',
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
			title: '录入类型',
			field: 'InputType',
			width: 100,
			formatter: InputTypeFormatter
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
			width: 80,
			align: 'right'
		}, {
			title: '高值标志',
			field: 'HVFlag',
			width: 80
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1
		},
		columns: MasterGridCm,
		onSelect: function(index, row) {
			loadDetailGrid();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#MasterGrid').datagrid('selectRow', 0);
			}
		}
	});
	// ===========================================物资汇总============================
	var DetailGridCm = [[
		{
			title: 'Inst',
			field: 'Inst',
			hidden: true,
			width: 50
		}, {
			title: 'InciId',
			field: 'InciId',
			hidden: true,
			width: 50
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '账盘数量',
			field: 'FreezeQty',
			width: 100,
			align: 'right'
		}, {
			title: '实盘数量',
			field: 'CountQty',
			width: 100,
			align: 'right'
		}, {
			title: '最新进价',
			field: 'LastRp',
			width: 100,
			align: 'right'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			QueryName: 'CollectItmCountQty',
			query2JsonStrict: 1
		},
		columns: DetailGridCm,
		sortName: 'InciCode',
		sortOrder: 'asc',
		fitColumns: true,
		onSelect: function(index, row) {
			loadInstItmGrid();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#DetailGrid').datagrid('selectRow', 0);
			}
		}
	});
	function loadInstItmGrid() {
		var Detailrow = $('#DetailGrid').datagrid('getSelected');
		if (isEmpty(Detailrow)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		if (isEmpty(Detailrow.InciId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		InstDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWdDetail',
			Inst: Detailrow.Inst,
			Inci: Detailrow.InciId,
			rows: 99999
		});
		InstItmGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWd',
			Inst: Detailrow.Inst,
			Inci: Detailrow.InciId,
			rows: 99999
		});
	}
	// =============================批次汇总=======================================
	var InstItmGridCm = [[
		{
			title: 'Insti',
			field: 'Insti',
			width: 100,
			hidden: true
		}, {
			title: 'Inclb',
			field: 'Inclb',
			width: 100,
			hidden: true
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '单位',
			field: 'FreezeUomDesc',
			width: 80
		}, {
			title: '账盘数量',
			field: 'FreezeQty',
			width: 100,
			align: 'right'
		}, {
			title: '实盘数量',
			field: 'CountQty',
			width: 100,
			align: 'right'
		}
	]];
	var InstItmGrid = $UI.datagrid('#InstItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWd'
		},
		pagination: false,
		columns: InstItmGridCm
	});
	// ====================批次明细=====================
	var InstDetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 100
		}, {
			title: 'Inclb',
			field: 'Inclb',
			hidden: true,
			width: 100
		}, {
			title: '批号',
			field: 'BatNo',
			width: 100
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '单位',
			field: 'CountUom',
			width: 80
		}, {
			title: '实盘数量',
			field: 'CountQty',
			width: 100,
			align: 'right'
		}, {
			title: '实盘日期',
			field: 'CountDate',
			width: 100
		}, {
			title: '实盘时间',
			field: 'CountTime',
			width: 100
		}, {
			title: '实盘人',
			field: 'CountUserName',
			width: 100
		}
	]];
	var InstDetailGrid = $UI.datagrid('#InstDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItmWd',
			MethodName: 'QueryItmTkWdDetail'
		},
		columns: InstDetailGridCm,
		pagination: false
	});
	Clear();
	Query();
};
$(init);