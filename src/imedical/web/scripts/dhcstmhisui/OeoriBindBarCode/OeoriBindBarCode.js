var init = function() {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(OeoriMainGrid);
		$UI.clear(OeoriDetailGrid);
		var DefaultData = {
			StartDate: DateFormatter(DateAdd(new Date(), 'd', -1)),
			EndDate: new Date(),
			excludeInci: 'Y'
		};
		$('#BarCode').val('');
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	var FRecLocParams = JSON.stringify(addSessionParams({
		Type: 'All'
	}));
	var FRecLocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#oeorcat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});

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
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var Params = OeoriDetailGrid.getSelectedData('RowId');
			if (Params.length == 0) {
				$UI.msg('alert', '请选择需要删除的明细!');
				return;
			}
			if (Params[0].RowId == '' || Params[0].RowId == undefined) {
				$UI.msg('alert', '该明细尚未保存,无需删除!');
				return;
			}
			$UI.confirm('您将要删除条码明细,是否继续?', '', '', Delete);
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			var Params = JSON.stringify(ParamsObj);
			var row = OeoriMainGrid.getSelected();
			if (isEmpty(row)) {
				$UI.msg('alert', '请选择一条医嘱!');
				return;
			}
			var oeori = row.Oeori;
			var Detail = OeoriDetailGrid.getChangesData('Dhcit');
			if (Detail === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Detail)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
				MethodName: 'Save',
				Params: Params,
				oeori: oeori,
				ListDetail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					OeoriDetailGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			var Params = JSON.stringify(ParamsObj);
			var row = OeoriMainGrid.getSelected();
			if (isEmpty(row)) {
				$UI.msg('alert', '请选择一条医嘱!');
				return;
			}
			var oeori = row.Oeori;
			$.cm({
				ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
				MethodName: 'Audit',
				Params: Params,
				oeori: oeori
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					OeoriDetailGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CancelAuditBT', {
		onClick: function() {
			var Params = OeoriDetailGrid.getSelectedData('RowId');
			if (Params.length == 0) {
				$UI.msg('alert', '请选择需要取消审核的明细!');
				return;
			}
			var SelectedRow = OeoriDetailGrid.getSelected();
			if (SelectedRow.AckFlag != 'Y') {
				$UI.msg('alert', '当前是未审核,不必取消审核!');
				return;
			}
			$UI.confirm('您将要取消审核条码明细,只允许取消一次,是否继续?', '', '', CancelAudit);
		}
	});
	$('#wardno').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var PapmiNo = $(this).val();
			if (isEmpty(PapmiNo)) {
				$UI.msg('alert', '请输入登记号!');
				return false;
			}
			try {
				var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PapmiNo);
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				var patinfo = patinfoarr[1] + ',' + patinfoarr[2];
				$('#wardno').val(newPaAdmNo);
			} catch (e) {}
		}
	});
	$('#BarCode').bind('keypress', function(event) {
		if (event.keyCode == '13') {
			var BarCode = $(this).val();
			if (BarCode == '') {
				$UI.msg('alert', '请输入条码!');
				return;
			}
			var row = OeoriMainGrid.getSelected();
			if (isEmpty(row)) {
				$UI.msg('alert', '请选择一条医嘱!');
				return;
			}
			var FindIndex = OeoriDetailGrid.find('BarCode', BarCode);
			if (FindIndex >= 0) {
				$UI.msg('alert', '条码不可重复录入!');
				$('#BarCode').val('');
				$('#BarCode').focus();
				return false;
			}
			var RecLoc = row.RecLoc;
			var BarCodeData = $.cm({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				MethodName: 'GetItmByBarcode',
				BarCode: BarCode
			}, false);
			if (!isEmpty(BarCodeData.success) && BarCodeData.success != 0) {
				$UI.msg('alert', BarCodeData.msg);
				$(this).val('');
				$(this).focus();
				return;
			}
			if (BarCodeData.Inclb == '') {
				$UI.msg('alert', '没有相应库存记录,不能制单!');
				$('#BarCode').val('');
				return;
			} else if (BarCodeData.IsAudit != 'Y') {
				$UI.msg('alert', '高值材料有未审核的' + BarCodeData.OperNo + ',请核实!');
				return;
			} else if (BarCodeData.Type == 'T') {
				$UI.msg('alert', '高值材料已经出库,不可制单!');
				return;
			} else if (BarCodeData.Status != 'Enable') {
				$UI.msg('alert', '高值条码处于不可用状态,不可制单!');
				return;
			} else if (BarCodeData.ExitInLoc != RecLoc) {
				$UI.msg('alert', '高值条码与接收科室不一致不可制单!');
				return;
			}

			var jsonData = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'Select', BarCode);
			jsonData = $.parseJSON(jsonData);
			var record = {
				Dhcit: jsonData.itmtrackid,
				InciCode: jsonData.incicode,
				InciDesc: jsonData.incidesc,
				BarCode: BarCode,
				Manf: jsonData.manfdesc,
				Inclb: jsonData.inclb,
				BatExp: jsonData.expdate + '~' + jsonData.batno,
				Rp: jsonData.rp
			};
			OeoriDetailGrid.appendRow(record);
			$('#BarCode').val('');
		}
	});
	var OeoriMainCm = [[
		{
			title: 'Oeori',
			field: 'Oeori',
			width: 100,
			hidden: true
		}, {
			title: '医嘱项代码',
			field: 'ArcimCode',
			width: 200
		}, {
			title: '医嘱项名称',
			field: 'ArcimDesc',
			width: 200
		}, {
			title: '患者登记号',
			field: 'PaAdmNo',
			width: 200
		}, {
			title: '患者姓名',
			field: 'PaAdmName',
			width: 150
		}, {
			title: '接收科室id',
			field: 'RecLoc',
			hidden: true,
			width: 100
		}, {
			title: '接收科室',
			field: 'RecLocDesc',
			width: 200
		}, {
			title: '医嘱日期',
			field: 'OeoriDate',
			width: 100,
			hidden: true
		}, {
			title: '医嘱录入人',
			field: 'UserAddName',
			width: 150
		}, {
			title: '医嘱数量',
			field: 'OrderPackQty',
			width: 80
		}, {
			title: '医嘱价格',
			field: 'OeoriPrices',
			width: 100
		}, {
			title: '医嘱状态',
			field: 'OeoriStatus',
			width: 80
		}
	]];
	var OeoriMainGrid = $UI.datagrid('#OeoriMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			QueryName: 'QueryOeori',
			query2JsonStrict: 1
		},
		columns: OeoriMainCm,
		showBar: false,
		onSelect: function(index, row) {
			OeoriDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				oeori: row.Oeori
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				OeoriMainGrid.selectRow(0);
			}
		}
	});
	var OeoriDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: 'Dhcit',
			field: 'Dhcit',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: '物资代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '物资名称',
			field: 'InciDesc',
			width: 200
		}, {
			title: '高值条码',
			field: 'BarCode',
			saveCol: true,
			width: 200
		}, {
			title: '生产厂家',
			field: 'Manf',
			width: 80
		}, {
			title: '批次Id',
			field: 'Inclb',
			width: 120,
			hidden: true
		}, {
			title: '批号~效期',
			field: 'BatExp',
			width: 150
		}, {
			title: '进价',
			field: 'Rp',
			width: 90
		}, {
			title: '记录日期',
			field: 'OBBDate',
			width: 80
		}, {
			title: '记录时间',
			field: 'OBBTime',
			width: 80
		}, {
			title: '记录人',
			field: 'OBBUser',
			width: 80
		}, {
			title: '审核标志',
			field: 'AckFlag',
			width: 80,
			saveCol: true
		}, {
			title: '审核日期',
			field: 'OBBAckDate',
			width: 70
		}, {
			title: '审核时间',
			field: 'OBBAckTime',
			width: 90
		}, {
			title: '审核人',
			field: 'OBBAckUser',
			width: 80
		}, {
			title: '取消审核日期',
			field: 'CancelDate',
			width: 100,
			saveCol: true
		}, {
			title: '取消审核时间',
			field: 'CancelTime',
			width: 100
		}, {
			title: '取消审核人',
			field: 'CancelSSUSR',
			width: 100
		}
	]];

	var OeoriDetailGrid = $UI.datagrid('#OeoriDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1
		},
		columns: OeoriDetailCm,
		showBar: false
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
		OeoriMainGrid.load({
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			QueryName: 'QueryOeori',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	function Delete() {
		var Params = OeoriDetailGrid.getSelectedData('RowId');
		$.cm({
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			MethodName: 'Delete',
			Params: JSON.stringify(Params)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				OeoriDetailGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function CancelAudit() {
		var Params = OeoriDetailGrid.getSelectedData('RowId');
		$.cm({
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			MethodName: 'CancelAudit',
			Params: JSON.stringify(Params),
			UserId: gUserId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				OeoriDetailGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	Clear();
	Query();
};
$(init);