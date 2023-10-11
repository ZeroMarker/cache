// 消毒包消耗处理
var init = function() {
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login', BDPHospital: gHospId }));
	$HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('Conditions');
		if (isEmpty(ParamsObj['SupLoc'])) {
			$UI.msg('alert', '科室不可为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		GridList.load({
			ClassName: 'web.CSSDHUI.PackageRegister.RegUse',
			QueryName: 'GetLocPackages',
			Params: Params
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	
	function RegUseBT() {
		var Detail = GridList.getChecked();
		if (isEmpty(Detail)) {
			$UI.msg('alert', '请选择需要处理的标签!');
			return;
		}
		$UI.confirm('您将批量处理选中的标签, 是否继续?', '', '', RegUse);
	}
	function RegUse() {
		var Detail = GridList.getChecked();
		var DetailParams = JSON.stringify(Detail);
		showMask();
		$.cm({
			ClassName: 'web.CSSDHUI.PackageRegister.RegUse',
			MethodName: 'jsRegUse',
			Params: DetailParams
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$('#GridList').datagrid('reload');
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var AttributeCombox = {
		type: 'combobox',
		options: {
			data: PackTypeDetailData,
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	var Cm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'TransId',
			field: 'TransId',
			width: 100,
			hidden: true
		}, {
			title: '标签',
			field: 'Label',
			width: 200
		}, {
			title: '消毒包',
			field: 'PkgDesc',
			width: 200
		}, {
			title: '包属性',
			field: 'AttributeId',
			width: 100,
			formatter: CommonFormatter(AttributeCombox, 'AttributeId', 'AttributeDesc'),
			editor: AttributeCombox
		}, {
			title: '失效日期',
			field: 'ExpDate',
			width: 100
		}, {
			title: '离失效期的天数',
			field: 'MinusDate',
			width: 120,
			align: 'right'
		}, {
			title: '当前位置',
			field: 'CurLoction',
			width: 150
		}, {
			title: '当前状态',
			field: 'Status',
			width: 120,
			formatter: PkgStatusRenderer
		}
	]];
	
	var GridList = $UI.datagrid('#GridList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageRegister.RegUse',
			QueryName: 'GetLocPackages'
		},
		columns: Cm,
		singleSelect: false,
		fitColumns: true,
		navigatingWithKey: true,
		toolbar: [
			{
				id: 'RegUseBT',
				text: '消耗处理',
				iconCls: 'icon-ok',
				handler: function() {
					RegUseBT();
				}
			}
		],
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#GridList').datagrid('selectRow', 0);
			}
		}
	});
	
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(GridList);
		var DefaultData = {
			SupLoc: gLocObj,
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#Conditions', DefaultData);
	};
	Default();
	Query();
};
$(init);