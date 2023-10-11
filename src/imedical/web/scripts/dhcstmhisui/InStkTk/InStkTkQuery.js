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
	
	var FCompBox = $HUI.combobox('#FCompBox', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': '1', 'Description': '未账盘完成' }, { 'RowId': '2', 'Description': '账盘完成' }, { 'RowId': '3', 'Description': '实盘完成' }, { 'RowId': '4', 'Description': '调整完成' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var HandlerParams = function() {
		var Obj = { StkGrpType: 'M', BDPHospital: gHospId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#InciId'));
	$('#FInciDesc').lookup(InciLookUpOp(HandlerParams, '#FInciDesc', '#FInciId'));
	// ===========================条件初始end===========================
	// ======================tbar操作事件start=========================
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		var StartDate = ParamsObj.FStartDate;
		var EndDate = ParamsObj.FEndDate;
		var CompFlag = ParamsObj.FCompBox;
		if (CompFlag == '') {
			ParamsObj.FInstComp = '';
			ParamsObj.FStkTkComp = '';
			ParamsObj.FAdjComp = '';
		} else if (CompFlag == '1') {
			ParamsObj.FInstComp = 'N';
			ParamsObj.FStkTkComp = 'N';
			ParamsObj.FAdjComp = 'N';
		} else if (CompFlag == '2') {
			ParamsObj.FInstComp = 'Y';
			ParamsObj.FStkTkComp = 'N';
			ParamsObj.FAdjComp = 'N';
		} else if (CompFlag == '3') {
			ParamsObj.FInstComp = 'Y';
			ParamsObj.FStkTkComp = 'Y';
			ParamsObj.FAdjComp = 'N';
		} else if (CompFlag == '4') {
			ParamsObj.FInstComp = 'Y';
			ParamsObj.FStkTkComp = 'Y';
			ParamsObj.FAdjComp = 'Y';
		}
		
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
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			FLoc: gLocObj,
			FStartDate: DateFormatter(new Date()),
			FEndDate: DateFormatter(new Date()),
			FCompBox: ''
		};
		$UI.fillBlock('#Conditions', DefaultData);
		$('#detailtype').tabs('disableTab', 1);
	}
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			Print(1);
		}
	});
	function Print(type) {
		var row = $('#MasterGrid').datagrid('getSelected');
		if (isEmpty(row)) {
			$UI.msg('alert', '请选择数据!');
			return;
		}
		if (isEmpty(row.RowId)) {
			$UI.msg('alert', '参数错误!');
			return;
		}
		PrintINStk(row.RowId, type);
	}
	
	$UI.linkbutton('#PrintInciBT', {
		onClick: function() {
			Print(2);
		}
	});
	
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
		var SSObj = $UI.loopBlock('Conditions');
		var ParamsObj = $UI.loopBlock('DetailConditions');
		ParamsObj.FFreezeNonzero = SSObj.FFreezeNonzero;
		ParamsObj.FCountNonzero = SSObj.FCountNonzero;
		var Params = JSON.stringify(ParamsObj);
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1,
			Inst: row.RowId,
			Others: Params,
			totalFooter: '"InciCode":"合计"',
			totalFields: 'FreezeRpAmt,CountRpAmt'
		});
	}
	// 检索明细
	$UI.linkbutton('#QueryDetailBT', {
		onClick: function() {
			loadDetailGrid();
		}
	});
	
	// 叶签切换 监听
	$HUI.tabs('#detailtype', {
		onSelect: function(title) {
			if (title == '按品种汇总') {
				loadDetailGridRQ();
			} else {
				loadDetailGrid();
			}
		}
	});
	function loadDetailGridRQ() {
		var row = $('#MasterGrid').datagrid('getSelected');
		var RowId = row.RowId;
		var NoFreezeZero = InStkTkParamObj.NoFreezeZeroWhilePrint;		// 打印时过滤冻结数为0的项目
		var SSObj = $UI.loopBlock('Conditions');
		var FFreezeNonzero = SSObj.FFreezeNonzero;
		var FCountNonzero = SSObj.FCountNonzero;
		var Others = JSON.stringify({ NoFreezeZero: NoFreezeZero, FFreezeNonzero: FFreezeNonzero, FCountNonzero: FCountNonzero });
		var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_INStkTk_GroupInci.raq'
			+ '&Inst=' + RowId + '&Others=' + Others;
		$('#frameInstktkInciPanel').attr('src', CommonFillUrl(p_URL));
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
			width: 200
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
			width: 150
		}, {
			title: '盘点完成',
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
			width: 100,
			hidden: true
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
			width: 70,
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
			QueryName: 'jsDHCSTINStkTk',
			query2JsonStrict: 1
		},
		columns: MasterGridCm,
		onSelect: function(index, row) {
			var DTTabed = $('#detailtype').tabs('getSelected');
			DTTabed = $('#detailtype').tabs('getTabIndex', DTTabed);
			if (DTTabed == 0) {
				loadDetailGrid();
			} else if (DTTabed == 1) {
				loadDetailGridRQ();
			}
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#detailtype').tabs('enableTab', 1);
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
			width: 100,
			hidden: true
		}, {
			title: '单位',
			field: 'UomId',
			hidden: true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 60
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
			title: '损益数量',
			field: 'VarianceQty',
			width: 100,
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
			title: '账盘日期',
			field: 'FreezeDate',
			width: 100
		}, {
			title: '账盘时间',
			field: 'FreezeTime',
			width: 100
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
			title: '状态',
			field: 'Status',
			width: 60,
			hidden: true
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
			width: 60,
			hidden: true
		}, {
			title: '货位码',
			field: 'StkBinDesc',
			width: 100
		}, {
			title: '进价',
			field: 'Rp',
			width: 60,
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
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INStkTkItm',
			QueryName: 'jsDHCSTInStkTkItm',
			query2JsonStrict: 1,
			totalFooter: '"InciCode":"合计"',
			totalFields: 'FreezeRpAmt,CountRpAmt'
		},
		columns: DetailGridCm,
		showBar: true,
		showFooter: true
	});
	Clear();
	Query();
	GetReportStyle('#Report');
};
$(init);