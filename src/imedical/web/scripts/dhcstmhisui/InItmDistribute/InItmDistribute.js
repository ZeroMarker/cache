var init = function() {
	var Params = JSON.stringify(addSessionParams());
	$HUI.combobox('#WardLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetWardLoc&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var HandlerParams = function() {
		var Obj = { StkGrpRowId: '', StkGrpType: 'M', Locdr: gLocId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	$('#PatNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var PatNo = $(this).val();
			if (isEmpty(PatNo)) {
				$UI.msg('alert', '请输入登记号!');
				return false;
			}
			try {
				var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PatNo);
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				$('#PatNo').val(newPaAdmNo);
			} catch (e) {}
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(DispMainGrid);
		$UI.clear(DispColGrid);
		$UI.clear(DispDetailGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
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
		var Pid = tkMakeServerCall('web.DHCSTMHUI.DHCInMatDisp', 'GetInMatDispPid', Params);
		
		ParamsObj.Pid = Pid;
		var MainParam = JSON.stringify(ParamsObj);
		
		DispMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDisp',
			query2JsonStrict: 1,
			Params: MainParam
		});
	}
	
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(DispDetailGrid);
		$UI.clear(DispColGrid);
		$UI.clear(DispMainGrid);
		Default();
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	
	$UI.linkbutton('#AlQueryBT', {
		onClick: function() {
			FindWin();
		}
	});
	
	$UI.linkbutton('#DispBT', {
		onClick: function() {
			var DispFlag = $HUI.checkbox('#DispFlag').getValue();
			if (DispFlag == true) {
				$UI.msg('alert', '已发放！');
				return;
			}
			var RowsData = DispMainGrid.getSelections();
			if (RowsData.length == 0) {
				$UI.msg('alert', '请选择要发放的病区！');
				return;
			}
			var WardLocIdStr = '', Pid = '';
			for (var i = 0; i < RowsData.length; i++) {
				var Pid = RowsData[i].Pid;
				var WardLocId = RowsData[i].WardLocId;
				if (WardLocIdStr == '') { WardLocIdStr = WardLocId; } else { WardLocIdStr = WardLocIdStr + ',' + WardLocId; }
			}
			if (isEmpty(Pid) || isEmpty(WardLocIdStr)) {
				$UI.msg('alert', '请选择有效的病区进行发放！');
				return;
			}
			var Params = JSON.stringify(addSessionParams({
				Pid: Pid,
				WardLocIdStr: WardLocIdStr
			}));

			var DetailRowsData = DispDetailGrid.getSelectedData();
			if (DetailRowsData.length == 0) {
				$UI.msg('alert', '请选择待发放材料信息！');
				return false;
			}
			var Detail = JSON.stringify(DetailRowsData);
			
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
				MethodName: 'jsInMatDisp',
				Main: Params,
				Detail: Detail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					var DispIdStr = jsonData.rowid.split(',');
					for (var i = 0; i < DispIdStr.length; i++) {
						var DispId = DispIdStr[i];
						PrintDisp(DispId);
					}
					$('#PatNo').val('');
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	/* --Grid--*/
	// /发放列表
	var DispMainGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'Pid',
			field: 'Pid',
			hidden: true,
			width: 60
		}, {
			title: '病区',
			field: 'WardLocId',
			width: 80,
			hidden: true
		}, {
			title: '病区',
			field: 'WardLocDesc',
			width: 150
		}
	]];

	var DispMainGrid = $UI.datagrid('#DispMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDisp',
			query2JsonStrict: 1
		},
		showBar: true,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		columns: DispMainGridCm,
		fitColumns: true,
		displayMsg: '',
		onClickRow: function(index, row) {
			DispMainGrid.commonClickRow(index, row);
		},
		onSelectChangeFn: function() {
			$UI.clear(DispColGrid);
			$UI.clear(DispDetailGrid);
			var RowsData = DispMainGrid.getSelections();
			var WardLocIdStr = '', Pid = '';
			for (var i = 0; i < RowsData.length; i++) {
				var Pid = RowsData[i].Pid;
				var WardLocId = RowsData[i].WardLocId;
				if (WardLocIdStr == '') { WardLocIdStr = WardLocId; } else { WardLocIdStr = WardLocIdStr + ',' + WardLocId; }
			}
			if (isEmpty(Pid) || isEmpty(WardLocIdStr)) {
				return;
			}

			var Params = JSON.stringify(addSessionParams({}));
			DispColGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
				QueryName: 'QueryInMatDispCol',
				query2JsonStrict: 1,
				Pid: Pid,
				WardLocIdStr: WardLocIdStr,
				Params: Params,
				rows: 99999
			});
			DispDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
				QueryName: 'QueryInMatDispDetail',
				query2JsonStrict: 1,
				Pid: Pid,
				WardLocIdStr: WardLocIdStr,
				Params: Params,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			/* if(data.rows.length > 0){
				DispMainGrid.selectRow(0);
			}*/
		}
	});
	// /明细汇总
	var DispColGridCm = [[
		{
			title: '库存项id',
			field: 'InciId',
			width: 100,
			hidden: true
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
			title: '数量/床号',
			field: 'QtyBedStr',
			width: 150,
			align: 'left'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 60
		}, {
			title: '单价',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '金额',
			field: 'ColSpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '货位',
			field: 'StkBin',
			width: 100
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '可用库存',
			field: 'AvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomId',
			width: 80,
			hidden: true
		}, {
			title: '数量',
			field: 'SumQtyTotal',
			width: 80,
			align: 'right'
		}
	]];

	var DispColGrid = $UI.datagrid('#DispColGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDispCol',
			query2JsonStrict: 1,
			rows: 99999
		},
		singleSelect: false,
		showBar: true,
		columns: DispColGridCm,
		pagination: false,
		onClickRow: function(index, row) {
			DispColGrid.commonClickRow(index, row);
		}
	});
	// /发放列表明细
	var DispDetailGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'DspId',
			field: 'DspId',
			saveCol: true,
			width: 60,
			hidden: true
		}, {
			title: '科室',
			field: 'AdmLocId',
			width: 60,
			hidden: true
		}, {
			title: '科室',
			field: 'AdmLocDesc',
			width: 150
		}, {
			title: '床号',
			field: 'BedNo',
			saveCol: true,
			width: 60
		}, {
			title: '姓名',
			field: 'PatName',
			width: 60
		}, {
			title: '登记号',
			field: 'PatNo',
			width: 100
		}, {
			title: '医嘱明细id',
			field: 'Oeori',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '库存项id',
			field: 'InciId',
			saveCol: true,
			width: 100,
			hidden: true
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
			title: '数量',
			field: 'Qty',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '单价',
			field: 'Sp',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '金额',
			field: 'SpAmt',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '医嘱状态',
			field: 'OeoriFlag',
			width: 80,
			hidden: true
		}, {
			title: '货位',
			field: 'StkBin',
			width: 100
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '可用库存',
			field: 'AvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '单位',
			field: 'UomId',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '使用日期',
			field: 'DoseDate',
			saveCol: true,
			width: 100
		}, {
			title: '分发时间',
			field: 'DoseTime',
			width: 80
		}, {
			title: '年龄',
			field: 'PatAge',
			width: 100
		}, {
			title: '性别',
			field: 'PatSex',
			width: 100
		}, {
			title: '诊断',
			field: 'DiagDesc',
			width: 100
		}, {
			title: '优先级',
			field: 'PriorityDesc',
			width: 100
		}, {
			title: 'WardLocId',
			field: 'WardLocId',
			saveCol: true,
			width: 60,
			hidden: true
		}, {
			title: 'AdmId',
			field: 'AdmId',
			saveCol: true,
			width: 60,
			hidden: true
		}
	]];

	var DispDetailGrid = $UI.datagrid('#DispDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDispDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		showBar: true,
		columns: DispDetailGridCm,
		pagination: false,
		onClickRow: function(index, row) {
			DispDetailGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				// 默认全选
				$('#DispDetailGrid').datagrid('selectAll');
			}
		}
	});
	
	/* --设置初始值--*/
	var Default = function() {
		var StartDate = DateAdd(new Date(), 'd', -5);
		var EndDate = DateAdd(new Date(), 'd', 3);
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: DateFormatter(StartDate),
			EndDate: DateFormatter(EndDate)
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	};
	Default();
	Query();
};
$(init);

function PrintDisp(DispId) {
	if (isEmpty(DispId)) {
		return;
	}
	var RaqName = 'DHCSTM_HUI_InItmDispCol.raq';
	var fileName = '{' + RaqName + '(Parref=' + DispId + ')}';
	DHCCPM_RQDirectPrint(fileName);
	Common_PrintLog('DP', DispId, '');
}