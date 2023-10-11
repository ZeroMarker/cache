var init = function() {
	var Params = JSON.stringify(addSessionParams());
	$HUI.combobox('#WardLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetWardLoc&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description'
	});
	
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
	$UI.linkbutton('#AlQueryBT', {
		onClick: function() {
			FindRetWin();
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(RetGrid);
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
		RetGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCInMatRet',
			QueryName: 'QueryInMatNeedRet',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(RetGrid);
		Default();
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	
	$UI.linkbutton('#RetBT', {
		onClick: function() {
			var DetailRowsData = RetGrid.getSelections();
			if (DetailRowsData.length == 0) {
				$UI.msg('alert', '请选择待退回材料信息！');
				return false;
			}
			var Detail = JSON.stringify(DetailRowsData);
			
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCInMatRet',
				MethodName: 'jsInMatRet',
				Main: Params,
				Detail: Detail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
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
	var RetGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'DMainId',
			field: 'DMainId',
			width: 60,
			hidden: true
		}, {
			title: 'DDetailId',
			field: 'DDetailId',
			width: 60,
			hidden: true
		}, {
			title: 'DspId',
			field: 'DspId',
			width: 60,
			hidden: true
		}, {
			title: '病区',
			field: 'WardLocId',
			width: 80,
			hidden: true
		}, {
			title: '病区',
			field: 'WardLocDesc',
			width: 150
		}, {
			title: '登记号',
			field: 'PatNo',
			width: 80
		}, {
			title: '床号',
			field: 'BedNo',
			width: 60
		}, {
			title: '姓名',
			field: 'PatName',
			width: 100
		}, {
			title: '库存项id',
			field: 'InciId',
			width: 150,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '发放数量',
			field: 'DspQty',
			width: 80,
			align: 'right'
		}, {
			title: '已退回数量',
			field: 'AlRetQty',
			width: 100,
			align: 'right'
		}, {
			title: '可退回数量',
			field: 'RetQty',
			width: 100,
			align: 'right'/*,
			editor: {
				type: 'numberbox',
				options: {
					
				}
			}*/
		}, {
			title: '发放日期',
			field: 'DispDate',
			width: 100
		}, {
			title: '发放时间',
			field: 'DispTime',
			width: 150
		}, {
			title: '发放单号',
			field: 'DispNo',
			width: 150
		}
	]];

	var RetGrid = $UI.datagrid('#RetGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatRet',
			QueryName: 'QueryInMatNeedRet',
			query2JsonStrict: 1
		},
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		showBar: true,
		columns: RetGridCm,
		onClickRow: function(index, row) {
			RetGrid.commonClickRow(index, row);
		}
	});
	
	/* --设置初始值--*/
	var Default = function() {
		// /设置初始值 考虑使用配置
		var StartDate = DateAdd(new Date(), 'd', -5);
		var EndDate = DateAdd(new Date(), 'd', 3);
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
function PrintDispRet(RowId) {
	if (isEmpty(RowId)) {
		return;
	}
	var RaqName = 'DHCSTM_HUI_InItmDispRetCol.raq';
	var fileName = '{' + RaqName + '(Parref=' + RowId + ')}';
	// alert(DispId)
	// alert(fileName)
	// DHCCPM_RQDirectPrint(fileName);  //直接打印
	var transfileName = TranslateRQStr(fileName);
	DHCSTM_DHCCPM_RQPrint(transfileName);
	// var transfileName = TranslateRQStr(fileName);
	// DHCSTM_DHCCPM_RQPrint(transfileName);
	// Common_PrintLog('DP', DispId, "");
}