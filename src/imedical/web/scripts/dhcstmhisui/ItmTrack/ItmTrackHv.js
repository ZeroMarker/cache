/* 确认*/
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(BarMainGrid);
		$UI.clear(BarDetailGrid);
		// /设置初始值 考虑使用配置
		var DefaultData = {
			StartDate: TrackDefaultStDate(),
			EndDate: TrackDefaultEdDate()
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#ConfirmBT', {
		onClick: function() {
			var Selected = BarMainGrid.getSelectedData();
			if (Selected.length == 0) {
				$UI.msg('alert', '请选择!!');
				return;
			}
			var BarCode = Selected[0].BarCode;
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				MethodName: 'SaveHv',
				label: BarCode
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	var BarMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			width: 120,
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
			title: '条码',
			field: 'BarCode',
			width: 200
		}, {
			title: '自带条码',
			field: 'OriginalCode',
			width: 200
		}, {
			title: '状态',
			field: 'Status',
			formatter: StatusFormatter,
			width: 70
		}, {
			title: '批号id',
			field: 'BatNo',
			width: 90,
			hidden: true
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 100
		}, {
			title: '规格',
			field: 'Spec',
			width: 120
		}, {
			title: '具体规格',
			field: 'SpecDesc',
			width: 120,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '单位',
			field: 'UomDesc',
			width: 80
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 180
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '确认',
			field: 'RetOriFlag',
			width: 100
		}, {
			title: '条码生成(注册)日期',
			field: 'DhcitDate',
			width: 150
		}, {
			title: '条码生成(注册)时间',
			field: 'DhcitTime',
			width: 150
		}, {
			title: '操作人',
			field: 'DhcitUser',
			width: 100
		}
	]];
	var BarMainGrid = $UI.datagrid('#BarMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: BarMainCm,
		showBar: true,
		onSelect: function(index, row) {
			BarDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				QueryName: 'QueryItmTrackItem',
				query2JsonStrict: 1,
				Parref: row.RowId
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	var BarDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '类型',
			field: 'Type',
			formatter: TypeRenderer,
			width: 80
		}, {
			title: 'Pointer',
			field: 'Pointer',
			width: 80,
			hidden: true
		}, {
			title: '台账标记',
			field: 'IntrFlag',
			width: 80
		}, {
			title: '处理号',
			field: 'OperNo',
			width: 150
		}, {
			title: '业务发生日期',
			field: 'Date',
			width: 180
		}, {
			title: '业务发生时间',
			field: 'Time',
			width: 180
		}, {
			title: '业务操作人',
			field: 'User',
			width: 100
		}, {
			title: '位置信息',
			field: 'OperOrg',
			width: 150
		}
	]];
	
	var BarDetailGrid = $UI.datagrid('#BarDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'QueryItmTrackItem',
			query2JsonStrict: 1
		},
		columns: BarDetailCm,
		showBar: true
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
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
		$UI.clear(BarDetailGrid);
		BarMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCItmTrack',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	Clear();
	Query();
};
$(init);