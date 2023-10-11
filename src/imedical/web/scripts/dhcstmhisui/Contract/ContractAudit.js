var ContractGrid, ItmGrid;
var HospId = gHospId;
var TableName = 'APC_Vendor';
var init = function() {
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			Select();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				setStkGrpHospid(HospId);
				$HUI.combotree('#Scg').load(HospId);
				Select();
			};
		}
		setStkGrpHospid(HospId);
	}

	ContractCm = [[
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
			title: '操作',
			field: 'Icon',
			width: 80,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				var str = '<div class="icon-img col-icon" title="查看图片" href="#" onclick="ViewPic(' + index + ')"></div>';
				return str;
			}
		}, {
			title: '合同号',
			field: 'ContractNo',
			width: 200
		}, {
			title: '备注',
			field: 'Remark',
			width: 180
		}, {
			title: '供应商id',
			field: 'Vendor',
			width: 60,
			hidden: true
		}, {
			title: '科室',
			field: 'ConLocDesc',
			width: 150
		}, {
			title: '供应商',
			field: 'VendorDesc',
			width: 200
		}, {
			title: '生效日期',
			field: 'StartDate',
			width: 100
		}, {
			title: '截止日期',
			field: 'EndDate',
			width: 100,
			styler: flagColor
		}, {
			title: '临采标志',
			field: 'LcFlag',
			align: 'center',
			width: 80
		}, {
			title: '停用标志',
			field: 'StopFlag',
			align: 'center',
			width: 80
		}, {
			title: '审核标志',
			field: 'AuditFlag',
			align: 'center',
			width: 80
		}, {
			title: '审核日期',
			field: 'AuditDate',
			width: 100
		}, {
			title: '审核人',
			field: 'AuditUser',
			width: 80
		}
	]];

	ContractGrid = $UI.datagrid('#ContractGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			QueryName: 'QueryCont',
			query2JsonStrict: 1
		},
		columns: ContractCm,
		singleSelect: false,
		onSelect: function(index, row) {
			ItmGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
				QueryName: 'QueryItmCont',
				query2JsonStrict: 1,
				ContId: row.RowId,
				rows: 9999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				ContractGrid.selectRow(0);
			}
		}
	});
	
	function flagColor(val, row, index) {
		var Status = row['Status'];
		if (Status === '-1') {
			return 'color:white;background:' + GetColorHexCode('red');
		} else if (Status === '1') {
			return 'color:white;background:' + GetColorHexCode('orange');
		} else if (Status === '3') {
			return 'color:white;background:' + GetColorHexCode('yellow');
		}
	}
	var HandlerParams = function() {
		var Scg = $('#Scg').combotree('getValue');
		var Obj = {
			StkGrpRowId: Scg,
			StkGrpType: 'M',
			BDPHospital: HospId
		};
		return Obj;
	};

	var SelectRow = function(row) {
		ItmGrid.updateRow({
			index: ItmGrid.editIndex,
			row: {
				InciId: row.InciDr,
				InciCode: row.InciCode,
				InciDesc: row.InciDesc,
				Spec: row.Spec
			}
		});
		setTimeout(function() {
			ItmGrid.refreshRow();
			ItmGrid.startEditingNext('InciDesc');
		}, 0);
	};

	var ItmCm = [[
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
			title: '物资Id',
			field: 'InciId',
			width: 50,
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
			title: '规格',
			field: 'Spec',
			width: 150
		}
	]];

	ItmGrid = $UI.datagrid('#ItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			QueryName: 'QueryItmCont',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			MethodName: 'DelItmCont'
		},
		columns: ItmCm,
		fitColumns: true,
		pagination: false,
		singleSelect: false,
		showBar: false
	});
	
	var ConLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#ConLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ConLocParams
	});
	var VendorBox = $HUI.combobox('#Vendor', {
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			var LocId = $('#ConLoc').combo('getValue');
			var Params = JSON.stringify(addSessionParams({ APCType: 'M', BDPHospital: HospId, LocId: LocId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
			VendorBox.reload(url);
		}
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Select();
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(ContractGrid);
		$UI.clear(ItmGrid);
		var DefaultData = {
			ConLoc: gLocObj,
			StartDate: DateFormatter(DateAdd(new Date(), 'd', parseInt(-7))),
			EndDate: DateFormatter(new Date()),
			CompFlag: 'Y'
		};
		$UI.fillBlock('#MainConditions', DefaultData);
	}

	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			var RowsData = ContractGrid.getSelections();
			if ((isEmpty(RowsData)) || (RowsData.length == 0)) {
				$UI.msg('alert', '请选择需要审核的合同!');
				return false;
			}
			for (var i = 0, Len = RowsData.length; i < Len; i++) {
				var Record = RowsData[i];
				if (Record['AuditFlag'] == 'Y') {
					var RowIndex = ContractGrid.getRowIndex(Record);
					$UI.msg('alert', '第' + (RowIndex + 1) + '行数据已审核, 请核实!');
					return;
				}
			}
			$UI.confirm('您将要审核所选合同,是否继续?', '', '', AuditContract);
		}
	});
	function AuditContract() {
		var RowsData = ContractGrid.getSelections();
		var ListData = JSON.stringify(RowsData);
		var Params = JSON.stringify(sessionObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			MethodName: 'jsAudit',
			ListData: ListData,
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(ItmGrid);
				ContractGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#AuditNoBT', {
		onClick: function() {
			var RowsData = ContractGrid.getSelections();
			if ((isEmpty(RowsData)) || (RowsData.length == 0)) {
				$UI.msg('alert', '请选择需要拒绝的合同!');
				return false;
			}
			for (var i = 0, Len = RowsData.length; i < Len; i++) {
				var Record = RowsData[i];
				if (Record['AuditFlag'] == 'Y') {
					var RowIndex = ContractGrid.getRowIndex(Record);
					$UI.msg('alert', '第' + (RowIndex + 1) + '行数据已审核, 请核实!');
					return;
				}
			}
			$UI.confirm('您将要拒绝所选合同,是否继续?', '', '', AuditNoContract);
		}
	});
	function AuditNoContract() {
		var RowsData = ContractGrid.getSelections();
		var ListData = JSON.stringify(RowsData);
		var Params = JSON.stringify(sessionObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			MethodName: 'jsAuditNo',
			ListData: ListData,
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(ItmGrid);
				ContractGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CancelAuditBT', {
		onClick: function() {
			var RowsData = ContractGrid.getSelections();
			if ((isEmpty(RowsData)) || (RowsData.length == 0)) {
				$UI.msg('alert', '请选择需要取消审核的合同!');
				return false;
			}
			for (var i = 0, Len = RowsData.length; i < Len; i++) {
				var Record = RowsData[i];
				if (Record['AuditFlag'] != 'Y') {
					var RowIndex = ContractGrid.getRowIndex(Record);
					$UI.msg('alert', '第' + (RowIndex + 1) + '行数据未审核, 请核实!');
					return;
				}
			}
			$UI.confirm('您将要取消审核所选合同,是否继续?', '', '', CancelAudit);
		}
	});
	function CancelAudit() {
		var RowsData = ContractGrid.getSelections();
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			MethodName: 'jsCancelAudit',
			ListData: JSON.stringify(RowsData)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				$UI.clear(ItmGrid);
				ContractGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	Clear();
	InitHosp();
};

$(init);

function Select() {
	var SessionParmas = addSessionParams({ BDPHospital: HospId });
	var Paramsobj = $UI.loopBlock('#MainConditions');
	var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
	if (isEmpty(Paramsobj['ConLoc'])) {
		$UI.msg('alert', '科室不可为空!');
		return;
	}
	
	$UI.clear(ContractGrid);
	$UI.clear(ItmGrid);
	ContractGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
		QueryName: 'QueryCont',
		query2JsonStrict: 1,
		Params: Params
	});
}

function ViewPic(index) {
	var RowData = ContractGrid.getRows()[index];
	var OrgType = 'Contract';
	var OrgId = RowData.RowId;
	var Vendor = RowData.Vendor;
	ViewFileWin(OrgType, OrgId, '', 'Vendor', Vendor, '', HospId);
}