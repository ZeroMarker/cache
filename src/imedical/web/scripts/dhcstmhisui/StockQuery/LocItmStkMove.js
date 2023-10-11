/* 台账查询*/
var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryMasterInfo();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			MasterClear();
		}
	});
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#StkGrpId').setFilterByLoc(LocId);
		}
	});
	$('#StkGrpId').stkscgcombotree({
		onSelect: function(node) {
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.clear();
				StkCatBox.loadData(data);
			});
		}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var StkGrpId = $('#StkGrpId').combotree('getValue');
		var PhaLoc = $('#PhaLoc').combo('getValue');
		var Obj = { StkGrpRowId: StkGrpId, StkGrpType: 'M', Locdr: PhaLoc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var StockTypeBox = $HUI.combobox('#StockType', {
		data: [{ 'RowId': 0, 'Description': '全部' }, { 'RowId': 1, 'Description': '库存为零' }, { 'RowId': 2, 'Description': '库存为正' }, { 'RowId': 3, 'Description': '库存为负' }, { 'RowId': 4, 'Description': '库存非零' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var QueryFlagBox = $HUI.combobox('#QueryFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': '1', 'Description': '零消耗' }, { 'RowId': '2', 'Description': '非零消耗' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var TransTypeBox = $HUI.combobox('#TransType', {
		data: [
			{ 'RowId': '', 'Description': '全部' },
			{ 'RowId': 'G', 'Description': '入库' },
			{ 'RowId': 'R', 'Description': '退货' },
			{ 'RowId': 'T', 'Description': '转移出库' },
			{ 'RowId': 'K', 'Description': '转移入库' },
			{ 'RowId': 'A', 'Description': '库存调整' },
			{ 'RowId': 'D', 'Description': '库存报损' },
			{ 'RowId': 'MP', 'Description': '住院医嘱' },
			{ 'RowId': 'MY', 'Description': '住院医嘱取消' },
			{ 'RowId': 'MF', 'Description': '门诊医嘱' },
			{ 'RowId': 'MH', 'Description': '门诊医嘱取消' },
			{ 'RowId': 'MDP', 'Description': '住院医嘱发放' },
			{ 'RowId': 'MDY', 'Description': '住院医嘱退回' },
			{ 'RowId': 'C', 'Description': '科室内发放' },
			{ 'RowId': 'L', 'Description': '科室内退回' }
		],
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#FilterBtn', {
		onClick: function() {
			QueryDetailInfo();
		}
	});
	function QueryDetailInfo() {
		var row = MasterInfoGrid.getSelected();
		if (isEmpty(row)) {
			return;
		}
		var ParamsObj = $UI.loopBlock('#Conditions');
		var DeatilParamsObj = $UI.loopBlock('#FilterTB');
		var ParamStr = JSON.stringify($.extend(ParamsObj, { TransType: DeatilParamsObj.TransType }));
		MasterDetailInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveDetail',
			ParamStr: JSON.stringify(ParamsObj),
			INCIL: row.INCIL
		});
	}
	var MasterInfoCm = [[
		{
			title: 'INCIL',
			field: 'INCIL',
			width: 60,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '库存分类',
			field: 'StkCat',
			width: 100
		}, {
			title: '入库单位',
			field: 'PurUom',
			width: 70
		}, {
			title: '基本单位',
			field: 'BUom',
			width: 90
		}, {
			title: '期初库存',
			field: 'BegQtyUom',
			width: 70,
			align: 'right'
		}, {
			title: '期初金额(进价)',
			field: 'BegRpAmt',
			width: 70,
			align: 'right'
		}, {
			title: '期初金额(售价)',
			field: 'BegSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '期末库存',
			field: 'EndQtyUom',
			width: 100,
			align: 'right'
		}, {
			title: '期末金额(进价)',
			field: 'EndRpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '期末金额(售价)',
			field: 'EndSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '国家医保编码',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '国家医保名称',
			field: 'MatInsuDesc',
			width: 160
		}
	]];

	var ParamsObj = $UI.loopBlock('#Conditions');
	var MasterInfoGrid = $UI.datagrid('#MasterInfoGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveSum',
			Params: JSON.stringify(ParamsObj)
		},
		columns: MasterInfoCm,
		showBar: true,
		onSelect: function(index, row) {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var DeatilParamsObj = $UI.loopBlock('#FilterTB');
			var ParamStr = JSON.stringify($.extend(ParamsObj, { TransType: DeatilParamsObj.TransType }));
			MasterDetailInfoGrid.load({
				ClassName: 'web.DHCSTMHUI.LocItmTransMove',
				MethodName: 'LocItmStkMoveDetail',
				ParamStr: JSON.stringify(ParamsObj),
				INCIL: row.INCIL
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var DetailInfoCm = [[
		{
			title: 'TrId',
			field: 'TrId',
			width: 100,
			hidden: true
		}, {
			title: '日期',
			field: 'TrDate',
			width: 150
		}, {
			title: '批号效期',
			field: 'BatExp',
			width: 150
		}, {
			title: '单位',
			field: 'PurUom',
			width: 80
		}, {
			title: '高值条码',
			field: 'HVBarCode',
			width: 140
		}, {
			title: '进价',
			field: 'Rp',
			width: 80,
			align: 'right'
		}, {
			title: '售价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '结余数量',
			field: 'EndQtyUom',
			width: 100
		}, {
			title: '批次结余',
			field: 'EndQtyUomInclb',
			width: 100
		}, {
			title: '数量',
			field: 'TrQtyUom',
			width: 100
		}, {
			title: '进价金额',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '处理号',
			field: 'TrNo',
			width: 120
		}, {
			title: '业务信息',
			field: 'TrAdm',
			width: 100
		}, {
			title: '业务类型',
			field: 'TrMsg',
			width: 100
		}, {
			title: '业务人',
			field: 'OperateUser',
			width: 100
		}, {
			title: '结余金额(进价)',
			field: 'EndRpAmt',
			width: 120,
			align: 'right'
		}, {
			title: '结余金额(售价)',
			field: 'EndSpAmt',
			width: 120,
			align: 'right'
		}, {
			title: '供应商',
			field: 'Vendor',
			width: 160
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 160
		}
	]];
	var MasterDetailInfoGrid = $UI.datagrid('#MasterDetailInfoGrid', {
		lazy: true,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveDetail'
		},
		idFiled: 'TrId',
		columns: DetailInfoCm,
		showBar: true,
		toolbar: '#FilterTB',
		onClickRow: function(index, row) {
			MasterDetailInfoGrid.commonClickRow(index, row);
		}
	});
	function QueryMasterInfo() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return;
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
		$UI.clear(MasterDetailInfoGrid);
		MasterInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.LocItmTransMove',
			MethodName: 'LocItmStkMoveSum',
			Params: Params
		});
	}
	function MasterClear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterInfoGrid);
		$UI.clear(MasterDetailInfoGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			PhaLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultData);
	}
	MasterClear();
};
$(init);