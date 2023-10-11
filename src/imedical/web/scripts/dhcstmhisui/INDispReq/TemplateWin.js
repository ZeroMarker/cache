var TemplateWin = function(SelectFn, CreateFn) {
	$HUI.dialog('#TemplateWin', {
		height: gWinHeight,
		width: gWinWidth
	}).open();
	var FTLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	var FTLocBox = $HUI.combobox('#FTLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FTLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(e) {
			DispTempLoc(e);
		}
	});
	// 专业组
	function DispTempLoc(FTLocId) {
		var FTUserGrpParams = JSON.stringify(addSessionParams({
			User: gUserId,
			SubLoc: FTLocId,
			ReqFlag: ''
		}));
		var FTUserGrpBox = $HUI.combobox('#FTUserGrp', {
			url: $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetUserGrp&ResultSetType=array&Params=' + FTUserGrpParams,
			valueField: 'RowId',
			textField: 'Description'
		});
	}
	$UI.linkbutton('#FTQueryBT', {
		onClick: function() {
			TemplateQuery();
		}
	});
	
	function TemplateQuery() {
		$UI.clear(TemplateMainGrid);
		$UI.clear(TemplateItmGrid);
		var ParamsObj = $UI.loopBlock('#TemplateConditions');
		if (isEmpty(ParamsObj['LocId'])) {
			$UI.msg('alert', '科室不能为空!');
			return;
		}
		ParamsObj['TemplateFlag'] = 'Y';
		var Params = JSON.stringify(ParamsObj);
		TemplateMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DispReqTemplate',
			QueryName: 'QueryTemplate',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#FTClearBT', {
		onClick: function() {
			TemplateDafult();
		}
	});
	$UI.linkbutton('#FTSelectBT', {
		onClick: function() {
			var Row = TemplateMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的模板!');
				return;
			}
			SelectFn(Row.RowId);
			$HUI.dialog('#TemplateWin').close();
		}
	});
	$UI.linkbutton('#FTCreateBT', {
		onClick: function() {
			var Row = TemplateMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的模板!');
				return;
			}
			var DetailRows = TemplateItmGrid.getSelections();
			if (isEmpty(DetailRows)) {
				$UI.msg('alert', '请选择需要制单的模板明细数据!');
				return;
			}
			var ReqItmArr = [];
			$.each(DetailRows, function(index, row) {
				var DspReqi = row['RowId'];
				ReqItmArr.push(DspReqi);
			});
			var DspReqiIdStr = ReqItmArr.join('^');
			CreateFn(Row['RowId'], DspReqiIdStr);
			$HUI.dialog('#TemplateWin').close();
		}
	});
    
	var TemplateMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '单号',
			field: 'DsrqNo',
			width: 160
		}, {
			title: '请领人',
			field: 'ReqUser',
			width: 100
		}, {
			title: '专业组',
			field: 'GrpDesc',
			width: 100
		}, {
			title: '请领模式',
			field: 'ReqMode',
			width: 80,
			hidden: true
		}, {
			title: '请领模式',
			field: 'ReqModeDesc',
			width: 100
		}, {
			title: '备注',
			field: 'Remark',
			width: 100
		}
	]];
	
	var TemplateMainGrid = $UI.datagrid('#TemplateMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DispReqTemplate',
			QueryName: 'QueryTemplate',
			query2JsonStrict: 1
		},
		columns: TemplateMainCm,
		onSelect: function(index, row) {
			TemplateItmGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
				QueryName: 'DHCINDispReqItm',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				TemplateMainGrid.selectRow(0);
			}
		}
	});
	var TemplateItmCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 60,
			hidden: true
		}, {
			title: '物资RowId',
			field: 'InciId',
			width: 100
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 100
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
			field: 'Manf',
			width: 150
		}, {
			title: '数量',
			field: 'Qty',
			width: 80,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '备注',
			field: 'Remark',
			width: 150
		}
	]];
	
	var TemplateItmGrid = $UI.datagrid('#TemplateItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINDispReqItm',
			QueryName: 'DHCINDispReqItm',
			query2JsonStrict: 1
		},
		columns: TemplateItmCm,
		singleSelect: false,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				TemplateItmGrid.selectAll();
			}
		}
	});
	
	function TemplateDafult() {
		$UI.clearBlock('#TemplateConditions');
		$UI.clear(TemplateMainGrid);
		$UI.clear(TemplateItmGrid);
		var LocObj = { RowId: $('#LocId').combobox('getValue'), Descirption: $('#LocId').combobox('getText') };
		// 默认主界面的科室
		var FDafultValue = {
			LocId: LocObj
		};
		$UI.fillBlock('#TemplateConditions', FDafultValue);
	}
	TemplateDafult();
	TemplateQuery();
};