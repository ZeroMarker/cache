// /名称: 调价损益查询
// /描述: 调价损益查询
// /编写者：zhangxiao
// /编写日期: 2018.06.15
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
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			Loc: gLocObj,
			OptType: '1'
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
		DetailGrid.load({
			ClassName: 'web.DHCSTMHUI.AspAmount',
			QueryName: 'QueryAspBatAmount',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	var DetailGridCm = [[
		{
			title: 'AspaIdLb',
			field: 'AspaIdLb',
			hidden: true,
			width: 60
		}, {
			title: 'Incib',
			field: 'Incib',
			hidden: true,
			width: 60
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '批次/效期',
			field: 'BatExp',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '调价单位',
			field: 'AspUom',
			width: 100
		}, {
			title: '库存量',
			field: 'StkLbQty',
			align: 'right',
			hidden: true,
			width: 100
		}, {
			title: '调前售价',
			field: 'PriorSp',
			width: 100,
			align: 'right'
		}, {
			title: '调后售价',
			field: 'ResultSp',
			width: 100,
			align: 'right'
		}, {
			title: '差价(售价)',
			field: 'DiffSp',
			hidden: true,
			width: 80
		}, {
			title: '调前进价',
			field: 'PriorRp',
			width: 100,
			align: 'right'
		}, {
			title: '调后进价',
			field: 'ResultRp',
			width: 100,
			align: 'right'
		}, {
			title: '差价(进价)',
			field: 'DiffRp',
			hidden: true,
			width: 100
		}, {
			title: '损益金额(售价)',
			field: 'SpLbAmt',
			width: 120,
			align: 'center'
		}, {
			title: '损益金额(进价)',
			field: 'RpLbAmt',
			width: 120,
			align: 'center'
		}, {
			title: '科室',
			field: 'LocDesc',
			width: 100,
			align: 'center'
		}, {
			title: '生效日期',
			field: 'ExecuteDate',
			width: 100,
			align: 'left'
		}, {
			title: '调价人',
			field: 'AspUser',
			width: 60,
			align: 'left'
		}, {
			title: '调价原因',
			field: 'AspReason',
			width: 60,
			align: 'left'
		}
	]];
	var DetailGrid = $UI.datagrid('#DetailGrid', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.AspAmount',
			QueryName: 'QueryAspBatAmount',
			query2JsonStrict: 1
		},
		sortName: 'RowId',
		sortOrder: 'Desc',
		showBar: true,
		columns: DetailGridCm,
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