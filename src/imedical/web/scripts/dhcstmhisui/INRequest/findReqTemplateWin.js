findReqTemplateWin = function(FnMod, FnCre) {
	$HUI.dialog('#TemWin', {
		height: gWinHeight,
		width: gWinWidth
	}).open();
	
	var Clear = function() {
		$UI.clearBlock('#TConditions');
		$UI.clear(TRequestMainGrid);
		$UI.clear(TRequestDetailGrid);
		var HvFlag = gHVInRequest == '' ? '' : (gHVInRequest ? 'Y' : 'N');
		var LocId = $('#ReqLoc').combobox('getValue');
		var LocDesc = $('#ReqLoc').combobox('getText');
		var ReqTypeId = $('#ReqType').combobox('getValue');
		var ReqTypeDesc = $('#ReqType').combobox('getText');
		var DefaultData = {
			ReqLoc: { RowId: LocId, Description: LocDesc },
			ReqType: { RowId: ReqTypeId, Description: ReqTypeDesc },
			HvFlag: HvFlag
		};
		$UI.fillBlock('#TConditions', DefaultData);
	};
	
	$UI.linkbutton('#TQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#TConditions');
		if (isEmpty(ParamsObj.ReqLoc)) {
			$UI.msg('alert', '请求科室不能为空!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(TRequestMainGrid);
		$UI.clear(TRequestDetailGrid);
		TRequestMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INRequestTemplate',
			QueryName: 'ReqTem',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#TModBT', {
		onClick: function() {
			var Row = TRequestMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的请求单!');
				return;
			}
			FnMod(Row.RowId);
			$HUI.dialog('#TemWin').close();
		}
	});
	$UI.linkbutton('#TCreBT', {
		onClick: function() {
			var Row = TRequestMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的请求单!');
				return;
			}
			var DetailRows = TRequestDetailGrid.getSelections();
			if (isEmpty(DetailRows)) {
				$UI.msg('alert', '请选择需要制单的模板明细数据!');
				return;
			}
			var InrqiArr = [];
			$.each(DetailRows, function(index, row) {
				var Inrqi = row['RowId'];
				var Incidesc = row['Description'];
				var NoLocReqFlag = row['NoLocReqFlag'];
				if (NoLocReqFlag == 'Y') {
					$UI.msg('alert', Incidesc + '禁止请领!');
				} else {
					InrqiArr.push(Inrqi);
				}
			});
			var ReqDetailIdStr = InrqiArr.join('^');
			if (isEmpty(InrqiArr)) {
				return false;
			}
			FnCre(Row.RowId, ReqDetailIdStr);
			$HUI.dialog('#TemWin').close();
		}
	});
	$UI.linkbutton('#TClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var TReqTypeBox = $HUI.combobox('#TReqType', {
		data: [{ 'RowId': 'O', 'Description': '临时请求' }, { 'RowId': 'C', 'Description': '申领计划' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var TReqLocParams = JSON.stringify(addSessionParams({ Type: INREQUEST_LOCTYPE, Element: 'TReqLoc' }));
	var TReqLocBox = $HUI.combobox('#TReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + TReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var TSupLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'TSupLoc' }));
	var TSupLocBox = $HUI.combobox('#TSupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + TSupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var TRequestMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '模板名称(备注)',
			field: 'Remark',
			width: 100
		}, {
			title: '供应科室',
			field: 'SupLocDesc',
			width: 100
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width: 180
		}, {
			title: '请求人',
			field: 'UserName',
			width: 70
		}, {
			title: '完成状态',
			field: 'Complete',
			width: 60,
			align: 'center',
			formatter: BoolFormatter
		}
	]];

	var TRequestMainGrid = $UI.datagrid('#TRequestMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequestTemplate',
			QueryName: 'ReqTem',
			query2JsonStrict: 1
		},
		columns: TRequestMainCm,
		onSelect: function(index, row) {
			var ParamsObj = { RefuseFlag: 1 };
			var Params = JSON.stringify(ParamsObj);
			TRequestDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INReqItm',
				QueryName: 'INReqD',
				query2JsonStrict: 1,
				Req: row.RowId,
				Params: Params
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});

	var TRequestDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 80
		}, {
			title: '是否使用',
			field: 'NotUseFlag',
			width: 60,
			align: 'center'
		}, {
			title: '是否禁止请领',
			field: 'NoLocReqFlag',
			width: 90,
			align: 'center'
		}, {
			title: '物资代码',
			field: 'Code',
			width: 120
		}, {
			title: '物资名称',
			field: 'Description',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			width: 100
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 100,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 100
		}, {
			title: '请求数量',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '售价金额',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '请求备注',
			field: 'ReqRemarks',
			width: 100
		}, {
			title: '是否拒绝',
			field: 'RefuseFlag',
			width: 60,
			align: 'center'
		}
	]];

	var TRequestDetailGrid = $UI.datagrid('#TRequestDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			query2JsonStrict: 1
		},
		columns: TRequestDetailCm,
		singleSelect: false,
		onLoadSuccess: function(data) {
			$.each(data.rows, function(index, row) {
				var NotUseFlag = row['NotUseFlag'];
				var NoLocReqFlag = row['NoLocReqFlag'];
				if ((NotUseFlag == '停用') || (NoLocReqFlag == 'Y')) {
					var Color = '#FD930C';
					SetGridBgColor(TRequestDetailGrid, index, 'RowId', Color);
				}
			});
		}
	});

	Clear();
	Query();
};