var SelInitWin = function(Fn, DispLoc, ReqLoc, HvFlag) {
	$HUI.dialog('#SelInitWin', { width: gWinWidth, height: gWinHeight }).open();
	$HUI.radio("[name='DispMode']", {
		onChecked: function(e, value) {
			var DispMode = $("input[name='DispMode']:checked").val();
			if (DispMode == '0') {
				$('#InitUserList').combobox({
					disabled: true
				});
				$('#InitGrpList').combobox({
					disabled: false
				});
			} else {
				$('#InitUserList').combobox({
					disabled: false
				});
				$('#InitGrpList').combobox({
					disabled: true
				});
			}
		}
	});
	var LocParams = JSON.stringify(addSessionParams({
		Type: 'LeadLoc',
		LocId: DispLoc
	}));
	var LocBox = $HUI.combobox('#FrLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 专业组
	var GrpListParams = JSON.stringify(addSessionParams({
		User: gUserId,
		SubLoc: ReqLoc,
		ReqFlag: ''
	}));
	var GrpListBox = $HUI.combobox('#InitGrpList', {
		url: $URL + '?ClassName=web.DHCSTMHUI.DHCSubLocUserGroup&QueryName=GetLocGrp&ResultSetType=array&Params=' + GrpListParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 科室人员
	var UserListBox = $HUI.combobox('#InitUserList', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetDeptUser&ResultSetType=array&Params='
			+ JSON.stringify({
				LocDr: ReqLoc
			}),
		valueField: 'RowId',
		textField: 'Description'
	});
	var MainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '单号',
			field: 'InitNo',
			align: 'left',
			editor: 'text',
			width: 150,
			sortable: true
		}, {
			title: '供给科室',
			field: 'FrLocDesc',
			width: 150,
			sortable: true
		}, {
			title: '制单时间',
			field: 'InitDateTime',
			width: 150
		}, {
			title: '单据状态',
			field: 'StatusCode',
			width: 70
		}, {
			title: '制单人',
			field: 'UserName',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}, {
			title: '进销差',
			field: 'MarginAmt',
			align: 'right',
			width: 100
		}, {
			title: '备注',
			field: 'Remark',
			width: 150
		}
	]];
	var MainGrid = $UI.datagrid('#InitMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1
		},
		columns: MainCm,
		onSelect: function(index, row) {
			var Init = row['RowId'];
			var ParamsObj = {
				Init: Init,
				InitType: 'T'
			};
			$UI.clear(DetailGrid);
			DetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
				QueryName: 'DHCINIsTrfD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj)
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				MainGrid.selectRow(0);
			}
		}
	});

	var DetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '物资批次Id',
			field: 'Inclb',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 120
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 180
		}, {
			title: '规格',
			field: 'Spec',
			width: 80
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 160
		}, {
			title: '批次库存',
			field: 'InclbQty',
			align: 'right',
			width: 80
		}, {
			title: '转移数量',
			field: 'Qty',
			align: 'right',
			width: 80
		}, {
			title: '发放数量',
			field: 'DispQty',
			width: 80,
			saveCol: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					tipPosition: 'bottom',
					required: true,
					precision: GetFmtNum('FmtQTY')
				}
			},
			align: 'right'
		}, {
			title: '单位Id',
			field: 'UomId',
			saveCol: true,
			hidden: true,
			width: 50
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 50
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 80
		}, {
			title: '可用数量',
			field: 'InclbAvaQty',
			align: 'right',
			width: 100
		}
	]];
	var DetailGrid = $UI.datagrid('#InitDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINIsTrfItm',
			QueryName: 'DHCINIsTrfD',
			query2JsonStrict: 1
		},
		columns: DetailCm,
		singleSelect: false,
		onClickRow: function(index, row) {
			DetailGrid.commonClickRow(index, row);
		}
	});

	$UI.linkbutton('#InitQueryBT', {
		onClick: function() {
			InitQuery();
		}
	});
	function InitQuery() {
		var ParamsObj = $UI.loopBlock('#InitConditions');
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '起始日期不能为空!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '截止日期不能为空!');
			return;
		}
		ParamsObj.Status = '31';
		ParamsObj.ToLoc = DispLoc;
		ParamsObj.HVFlag = HvFlag;
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		MainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINIsTrf',
			QueryName: 'DHCINIsTrfM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#InitClearBT', {
		onClick: function() {
			Clear();
		}
	});

	$UI.linkbutton('#InitSelectBT', {
		onClick: function() {
			SaveDispByInit();
		}
	});
	function SaveDispByInit() {
		if (!DetailGrid.endEditing()) {
			return;
		}
		var SelectedRow = MainGrid.getSelected();
		if (isEmpty(SelectedRow)) {
			$UI.msg('alert', '请选择转移单!');
			return;
		}
		var Rows = DetailGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择转移单明细!');
			return;
		}
		for (var i = 0; i < Rows.length; i++) {
			if (isEmpty(Rows[i].DispQty) || Rows[i].DispQty == 0) {
				var InciDesc = Rows[i].InciDesc;
				$UI.msg('alert', '请输入' + InciDesc + '的发放数量!');
				return;
			}
		}
		var ParamsObj = $UI.loopBlock('#InitConditions');
		var DispMode = $("input[name='DispMode']:checked").val();
		if ((DispMode == '1') && (isEmpty(ParamsObj['UserList']))) {
			$UI.msg('alert', '请选择发放人员!');
			return;
		}
		if ((DispMode == '0') && (isEmpty(ParamsObj['GrpList']))) {
			$UI.msg('alert', '请选择发放专业组!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		var Main = JSON.stringify(SelectedRow);
		var Detail = JSON.stringify(DetailGrid.getSelectedData());
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINDisp',
			MethodName: 'SaveDispByInit',
			Main: Main,
			Detail: Detail,
			Params: Params,
			DispLoc: DispLoc,
			ReqLoc: ReqLoc
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				Fn(jsonData.rowid);
				$HUI.dialog('#SelInitWin').close();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	function Clear() {
		$UI.clearBlock('#InitConditions');
		$UI.clear(MainGrid);
		$UI.clear(DetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#InitConditions', DefaultData);
	}

	Clear();
	InitQuery();
};