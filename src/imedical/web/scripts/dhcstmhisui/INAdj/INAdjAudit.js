var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		$UI.clear(AdjMainGrid);
		$UI.clear(AdjDetailGrid);
		SetDefValue();
	};
	function Query() {
		var ParamsObj = $UI.loopBlock('#Conditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.AdjLoc)) {
			$UI.msg('alert', '调整科室不能为空!');
			return;
		}
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
		AdjMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			QueryName: 'DHCINAdjM',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}

	});
	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			var Row = AdjMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要审核的调整单!');
				return;
			}
			var AdjId = Row.RowId;
			var Params = JSON.stringify(addSessionParams({
				RowId: AdjId
			}));
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINAdj',
				MethodName: 'JsAudit',
				Params: Params,
				AdjId: AdjId
			}, function(jsonData) {
				// $UI.msg('alert',jsonData.msg);
				if (jsonData.success == 0) {
					$UI.msg('success', '审核成功!');
					$UI.clear(AdjDetailGrid);
					AdjMainGrid.commonReload();
					if (InAdjParamObj['AutoPrintAfterAuditDAdj'] == 'Y') {
						PrintInAdj(AdjId);
					}
				} else {
					$UI.msg('error', jsonData.msg);
				}
				hideMask();
			});
		}
	});
	$UI.linkbutton('#CancelAuditBT', {
		onClick: function() {
			var Row = AdjMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要取消审核的调整单!');
				return;
			}
			$UI.confirm('确定取消审核?', '', '', CancelConfirmYes);
		}
	});
	function CancelConfirmYes() {
		var Row = AdjMainGrid.getSelected();
		var AdjId = Row.RowId;
		var Params = JSON.stringify(addSessionParams({
			RowId: AdjId
		}));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			MethodName: 'JsCancelAudit',
			Params: Params,
			AdjId: AdjId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', '取消审核成功!');
				$UI.clear(AdjDetailGrid);
				AdjMainGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
			hideMask();
		});
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var Row = AdjMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '没有需要打印的单据!');
				return;
			}
			var AdjId = Row.RowId;
			PrintInAdj(AdjId);
		}
	});
	var AdjLocParams = JSON.stringify(addSessionParams({
		Type: 'Login'
	}));
	if (InAdjParamObj.AllowAdjAllLoc == 'Y') {
		AdjLocParams = JSON.stringify(addSessionParams({
			Type: 'All'
		}));
	}
	var AdjLocBox = $HUI.combobox('#AdjLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + AdjLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var AdjMainCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: '调整单号',
			field: 'No',
			width: 180
		}, {
			title: '科室名称',
			field: 'AdjLocDesc',
			width: 150
		}, {
			title: '制单人',
			field: 'AdjUserName',
			width: 100
		}, {
			title: '制单时间',
			field: 'AdjDateTime',
			width: 150
		}, {
			title: '完成状态',
			field: 'Completed',
			width: 80
		}, {
			title: '审核标志',
			field: 'chkFlag',
			width: 80
		}, {
			title: '审核人',
			field: 'chkUserName',
			width: 100
		}, {
			title: '审核时间',
			field: 'chkDateTime',
			width: 150
		}, {
			title: '备注',
			field: 'remarks',
			width: 140
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
		}
	]];
	var AdjMainGrid = $UI.datagrid('#AdjMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINAdj',
			QueryName: 'DHCINAdjM',
			query2JsonStrict: 1
		},
		columns: AdjMainCm,
		showBar: true,
		onSelect: function(index, row) {
			var Adjrowid = row['RowId'];
			var ParamsObj = {
				InAdj: Adjrowid
			};
			AdjDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
				QueryName: 'DHCINAdjD',
				query2JsonStrict: 1,
				Params: JSON.stringify(ParamsObj),
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				AdjMainGrid.selectRow(0);
			}
		}
	});
	var AdjDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 80,
			hidden: true
		}, {
			title: 'InciId',
			field: 'InciId',
			hidden: true,
			width: 60
		}, {
			title: 'Inclb',
			field: 'Inclb',
			hidden: true,
			width: 80
		}, {
			title: '物资代码',
			field: 'Code',
			width: 100
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 150
		}, {
			title: '规格',
			field: 'Spec',
			align: 'left',
			width: 100
		}, {
			title: '生产厂家',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '批次~效期',
			field: 'BatExp',
			width: 200
		}, {
			title: '调整数量',
			field: 'Qty',
			align: 'right',
			width: 100
		}, {
			title: '高值条码',
			field: 'HvBarCode',
			width: 150
		}, {
			title: '单位',
			field: 'uomDesc',
			align: 'left',
			width: 60
		}, {
			title: '进价',
			field: 'Rp',
			align: 'right',
			width: 80
		}, {
			title: '进价金额',
			field: 'RpAmt',
			align: 'right',
			width: 100
		}, {
			title: '售价',
			field: 'Sp',
			align: 'right',
			width: 80
		}, {
			title: '售价金额',
			field: 'SpAmt',
			align: 'right',
			width: 100
		}
	]];
	var AdjDetailGrid = $UI.datagrid('#AdjDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINAdjItm',
			QueryName: 'DHCINAdjD',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: AdjDetailCm,
		showBar: true,
		remoteSort: false
	});
	function SetDefValue() {
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			AdjLoc: gLocObj,
			Complate: 'Y',
			Audit: 'N'
		};
		$UI.fillBlock('#Conditions', DefaultValue);
	}
	SetDefValue();
	Query();
};
$(init);