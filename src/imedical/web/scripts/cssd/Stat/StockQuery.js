// 供应室库存查询
var init = function() {
	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2,7' }));
	$HUI.combobox('#PackageName', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		onSelect: function(record) {
			$HUI.combobox('#CodeDict').clear();
			var url = $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCodeDict&ResultSetType=array&PkgDr=' + record['RowId'];
			$HUI.combobox('#CodeDict').reload(url);
		}
	});
	$HUI.combobox('#CodeDict', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCodeDict&ResultSetType=array'
	});
	
	var SpecParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#PkgSpec', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageSpec&ResultSetType=array&Params=' + SpecParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var LocParams = JSON.stringify(addSessionParams({ Type: 'SupLoc', BDPHospital: gHospId }));
	$HUI.combobox('#PackLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	// 接收科室
	var RecLocParams = JSON.stringify(addSessionParams({ Type: 'RecLoc', BDPHospital: gHospId }));
	$HUI.combobox('#RecLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		if (isEmpty(ParamsObj.PackLoc)) {
			$UI.msg('alert', '供应科室不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '灭菌开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '灭菌截止日期不能为空!');
			return;
		}
		if (compareDate(ParamsObj.StartDate, ParamsObj.EndDate)) {
			$UI.msg('alert', '开始日期不能大于截止日期');
			return;
		}
		GridList.load({
			ClassName: 'web.CSSDHUI.Stat.StockQueryStat',
			QueryName: 'SelectAll',
			Params: JSON.stringify(ParamsObj)
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	
	var Cm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			width: 150
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200
		}, {
			title: '规格',
			field: 'SpecDesc',
			width: 80
		}, {
			title: '包属性',
			field: 'AttributeDesc',
			width: 100
		}, {
			title: '标牌',
			field: 'CodeDict',
			width: 120
		}, {
			title: '当前状态',
			field: 'StatusDesc',
			width: 100
		}, {
			title: '当前状态',
			field: 'Status',
			width: 80,
			hidden: true
		}, {
			title: '配包科室',
			field: 'PackLocDesc',
			width: 100
		}, {
			title: '配包日期',
			field: 'PackDate',
			width: 100
		}, {
			title: '灭菌日期',
			field: 'SterDate',
			width: 100
		}, {
			title: '失效日期',
			field: 'Expdate',
			width: 100
		}
	]];
	var GridList = $UI.datagrid('#GridList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.Stat.StockQueryStat',
			QueryName: 'SelectAll'
		},
		columns: Cm,
		fitColumns: true,
		showBar: true
	});
	
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(GridList);
		var DefaultValue = {
			PackLoc: gLocObj,
			StartDate: DateFormatter(DateAdd(new Date(), 'm', -6)),		// 消毒包最长180天有效期
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		Query();
	};
	Default();
};
$(init);