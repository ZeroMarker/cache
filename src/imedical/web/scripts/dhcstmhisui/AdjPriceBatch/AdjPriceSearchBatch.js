// /名称: 调价单(批次)查询
// /描述: 调价单(批次)查询
// /编写者：zhangxiao
// /编写日期: 2018.07.12
var init = function() {
	var InciHandlerParams = function() {
		var Scg = $('#ScgId').combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: 'M',
			BDPHospital: gHospId
		};
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(InciHandlerParams, '#InciDesc', '#Inci'));
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(MasterGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			AdjSPCat: '0'
		};
		$UI.fillBlock('#Conditions', DefaultData);
		$('#ScgId').combotree('options')['setDefaultFun']();
	};
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
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
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryAspBatNo',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	var MasterGridCm = [[
		{
			title: '调价单ID',
			field: 'AspBatIdStr',
			width: 200,
			hidden: true
		}, {
			title: '调价单号',
			field: 'AspNo',
			width: 150
		}, {
			title: '最后更新日期',
			field: 'AspDate',
			width: 100,
			align: 'right'
		}, {
			title: '操作人',
			field: 'AspUser',
			width: 70,
			align: 'right'
		}
	]];
	var MasterGrid = $UI.datagrid('#MasterGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryAspBatNo',
			query2JsonStrict: 1
		},
		columns: MasterGridCm,
		fitColumns: true,
		showBar: true,
		onSelect: function(index, row) {
			var ParamsObj = $UI.loopBlock('Conditions');
			var Params = JSON.stringify(ParamsObj);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				AspNo: row.AspNo,
				AspBatIdStr: row.AspBatIdStr,
				Params: Params
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var DetailGridCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: 'Incib',
			field: 'Incib',
			hidden: true,
			width: 60
		}, {
			title: '状态',
			field: 'Status',
			width: 80
		}, {
			title: '库存分类',
			field: 'StkCatDesc',
			width: 80
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
			title: '调价单位',
			field: 'AspUomDesc',
			width: 100
		}, {
			title: '调前售价',
			field: 'PriorSpUom',
			width: 100,
			align: 'right'
		}, {
			title: '调后售价',
			field: 'ResultSpUom',
			width: 100,
			align: 'right'
		}, {
			title: '差价(售价)',
			field: 'DiffSpUom',
			width: 80
		}, {
			title: '调前进价',
			field: 'PriorRpUom',
			width: 100,
			align: 'right'
		}, {
			title: '调后进价',
			field: 'ResultRpUom',
			width: 100,
			align: 'right'
		}, {
			title: '差价(进价)',
			field: 'DiffRpUom',
			width: 100
		}, {
			title: '调价原因',
			field: 'AdjReason',
			width: 80,
			align: 'center'
		}, {
			title: '物价文件号',
			field: 'WarrentNo',
			width: 100,
			align: 'center'
		}, {
			title: '计划生效日期',
			field: 'PreExecuteDate',
			width: 100,
			align: 'center'
		}, {
			title: '实际生效日期',
			field: 'ExecuteDate',
			width: 100,
			align: 'left'
		}, {
			title: '制单人',
			field: 'AdjUserName',
			width: 60,
			align: 'left'
		}, {
			title: '审核人',
			field: 'AuditUserName',
			width: 60,
			align: 'left'
		}, {
			title: '生效人',
			field: 'ExeUserName',
			width: 60,
			align: 'left'
		}, {
			title: '批次/有效期',
			field: 'BatExp',
			width: 100,
			align: 'left'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INAdjPriceBatch',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1
		},
		columns: DetailGridCm,
		showBar: true
	});
	Clear();
	Query();
};
$(init);