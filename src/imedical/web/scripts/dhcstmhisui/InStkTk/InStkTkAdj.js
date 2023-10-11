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
		$UI.clear(DetailGrid);
		var DefaultData = {
			FLoc: gLocObj,
			FStartDate: DateFormatter(new Date()),
			FEndDate: DateFormatter(new Date()),
			FExcludeNew: 'Y',
			FInstComp: 'Y',
			FStkTkComp: 'Y',
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
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		MasterGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	// 确认
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
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkAdj',
			MethodName: 'jsStkTkAdj',
			Inst: row.RowId,
			UserId: gUserId
		}, function(jsonData) {
			if (jsonData.success >= 0) {
				var AdjId = jsonData.rowid;
				if (AdjId == '') {
					$UI.msg('success', '盘点确认成功，库存未发生变化');
				} else {
					$UI.msg('success', jsonData.msg);
				}
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	// 打印
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			Print();
		}
	});
	function Print() {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		PrintINStk(row.RowId, 0);
	}
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			$UI.confirm('该物资或耗材删除后，本次不再盘点，需重新盘点！', 'warning', '', DeletInstkstkItm, '', '', '警告', false);
		}
	});
	function DeletInstkstkItm() {
		var row = $('#DetailGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			MethodName: 'DeleteItm',
			insti: row.RowId
		}, function(jsonData) {
			if (jsonData == 0) {
				$UI.msg('success', '删除成功！');
				loadDetailGrid();
			} else {
				$UI.msg('error', '删除失败！');
			}
		});
	}
	// 加载明细
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
		var ParamsObj = $UI.loopBlock('DetailConditions');
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1,
			Inst: row.RowId,
			Others: Params
		});
	}
	
	$HUI.radio("[name='StatFlag']", {
		onChecked: function(e, value) {
			loadDetailGrid();
		}
	});
	
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
			title: '科室',
			field: 'LocDesc',
			width: 100
		}, {
			title: '账盘完成',
			field: 'CompFlag',
			width: 100,
			formatter: function(value, row, index) {
				if (row.CompFlag == 'Y') {
					return '已完成';
				} else {
					return '未完成';
				}
			}
		}, {
			title: '实盘完成',
			field: 'StkTkCompFlag',
			width: 100,
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
			width: 100,
			formatter: function(value, row, index) {
				if (row.AdjCompFlag == 'Y') {
					return '已完成';
				} else {
					return '未完成';
				}
			}
		}, {
			title: '标志',
			field: 'ManaFlag',
			width: 70,
			hidden: true
		}, {
			title: '账盘单位',
			field: 'FreezeUomId',
			width: 100,
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
			width: 100
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
			width: 100
		}, {
			title: '最低进价',
			field: 'MinRp',
			width: 100,
			align: 'right'
		}, {
			title: '最高进价',
			field: 'MaxRp',
			width: 100,
			align: 'right'
		}, {
			title: '抽查数',
			field: 'RandomNum',
			width: 100,
			align: 'right'
		}, {
			title: '高值标志',
			field: 'HVFlag',
			width: 100
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTk',
			QueryName: 'DHCSTINStkTk',
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
	var DetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 50
		}, {
			title: 'Inclb',
			field: 'Inclb',
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
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '条码',
			field: 'Barcode',
			width: 100
		}, {
			title: '账盘数量',
			field: 'FreezeQty',
			width: 100,
			align: 'right'
		}, {
			title: '可用库存',
			field: 'AvaQty',
			width: 100,
			align: 'right'
		}, {
			title: '账盘日期',
			field: 'FreezeDate',
			width: 100
		}, {
			title: '账盘时间',
			field: 'FreezeTime',
			width: 100
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
			width: 80
		}, {
			title: '实盘人',
			field: 'CountUserId',
			hidden: true
		}, {
			title: '实盘人',
			field: 'CountUserName',
			width: 100
		}, {
			title: '损益数量',
			field: 'VarianceQty',
			width: 100,
			align: 'right'
		}, {
			title: '当前库存',
			field: 'StkQty',
			width: 100,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomId',
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 60
		}, {
			title: '批号',
			field: 'BatchNo',
			width: 100
		}, {
			title: '有效期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '调整标志',
			field: 'AdjFlag',
			width: 70,
			hidden: true
		}, {
			title: '货位码',
			field: 'StkBinDesc',
			width: 60
		}, {
			title: '进价',
			field: 'Rp',
			width: 60,
			align: 'right'
		}, {
			title: '账盘金额',
			field: 'FreezeRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '实盘金额',
			field: 'CountRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '损益金额',
			field: 'VarianceRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '类组',
			field: 'StkScgDesc',
			width: 100
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 100
		}, {
			title: '库存分类',
			field: 'StkCatDesc',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 70,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1
		},
		columns: DetailGridCm
	});
	Clear();
	Query();
};
$(init);