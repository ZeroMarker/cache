var FindWin = function(Fn) {
	$HUI.dialog('#FindWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();
	
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(RequestMainGrid);
		$UI.clear(RequestDetailGrid);
		
		var LocId = $('#ReqLoc').combobox('getValue');
		var LocDesc = $('#ReqLoc').combobox('getText');
		var ReqTypeId = $('#ReqType').combobox('getValue');
		var ReqTypeDesc = $('#ReqType').combobox('getText');
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			AllTransfer: 'Y',
			PartTransfer: 'Y',
			NoTransfer: 'Y',
			ReqLoc: { RowId: LocId, Description: LocDesc },
			HvFlag: gHVInRequest ? 'Y' : 'N',
			ReqType: { RowId: ReqTypeId, Description: ReqTypeDesc }
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	
	$UI.linkbutton('#FQueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '开始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.ReqLoc)) {
			$UI.msg('alert', '请求科室不能为空!');
			return;
		}
		$UI.clear(RequestDetailGrid);
		$UI.clear(RequestMainGrid);
		var Params = JSON.stringify(ParamsObj);
		RequestMainGrid.load({
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#FComBT', {
		onClick: function() {
			var Row = RequestMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要返回的请求单!');
				return;
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	$UI.linkbutton('#FClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var FReqTypeBox = $HUI.combobox('#FReqType', {
		data: [{ 'RowId': 'O', 'Description': '临时请求' }, { 'RowId': 'C', 'Description': '申领计划' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var FReqLocParams = JSON.stringify(addSessionParams({ Type: INREQUEST_LOCTYPE, Element: 'FReqLoc' }));
	var FReqLocBox = $HUI.combobox('#FReqLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FReqLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FSupLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'FSupLoc' }));
	var FSupLocBox = $HUI.combobox('#FSupLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FSupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var RequestMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '请求单号',
			field: 'ReqNo',
			width: 150
		}, {
			title: '病人姓名',
			field: 'PatientName',
			width: 120
		}, {
			title: '病案号',
			field: 'Medicare',
			width: 150
		}, {
			title: '请求部门',
			field: 'ToLocDesc',
			width: 150
		}, {
			title: '供给部门',
			field: 'FrLocDesc',
			width: 100
		}, {
			title: '请求人',
			field: 'UserName',
			width: 70
		}, {
			title: '日期',
			field: 'Date',
			width: 90
		}, {
			title: '时间',
			field: 'Time',
			width: 80
		}, {
			title: '完成状态',
			field: 'Complete',
			width: 60,
			align: 'center'
		}, {
			title: '出库状态',
			field: 'Status',
			width: 80,
			formatter: function(value) {
				var status = '';
				if (value == 0) {
					status = '未转移';
				} else if (value == 1) {
					status = '部分转移';
				} else if (value == 2) {
					status = '全部转移';
				}
				return status;
			}
		}, {
			title: '备注',
			field: 'Remark',
			width: 100
		}
	]];
	
	var RequestMainGrid = $UI.datagrid('#RequestMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INRequest',
			QueryName: 'INReqM',
			query2JsonStrict: 1
		},
		columns: RequestMainCm,
		showBar: true,
		onSelect: function(index, row) {
			var ParamsObj = { RefuseFlag: 1 };
			var Params = JSON.stringify(ParamsObj);
			RequestDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.INReqItm',
				QueryName: 'INReqD',
				query2JsonStrict: 1,
				Req: row.RowId,
				Params: Params
			});
		},
		onDblClickRow: function(index, row) {
			Fn(row.RowId);
			$HUI.dialog('#FindWin').close();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var RequestDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
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
			title: '备注',
			field: 'ReqRemarks',
			width: 100
		}, {
			title: '是否拒绝',
			field: 'RefuseFlag',
			width: 60,
			align: 'center'
		}
	]];
	
	var RequestDetailGrid = $UI.datagrid('#RequestDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.INReqItm',
			QueryName: 'INReqD',
			query2JsonStrict: 1
		},
		columns: RequestDetailCm,
		showBar: true
	});
	
	Clear();
	Query();
};