var ContractGrid, ItmGrid, VendorItmGrid;
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
				var str = '';
				str = str + '<div class="icon-write-order col-icon" href="#" title="编辑" onclick="Update(' + row.RowId + ')"></div>'
				+ '<div class="icon-img col-icon" title="查看图片" href="#" onclick="ViewPic(' + index + ')"></div>';
				return str;
			}
		}, {
			title: '合同号',
			field: 'ContractNo',
			width: 180
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
			width: 180
		}, {
			title: '生效日期',
			field: 'StartDate',
			width: 120
		}, {
			title: '截止日期',
			field: 'EndDate',
			width: 120,
			styler: flagColor
		}, {
			title: '临采',
			field: 'LcFlag',
			align: 'center',
			width: 80
		}, {
			title: '停用',
			field: 'StopFlag',
			align: 'center',
			width: 80
		}, {
			title: '提交',
			field: 'CompFlag',
			align: 'center',
			width: 80
		}, {
			title: '审核',
			field: 'AuditFlag',
			align: 'center',
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
		idField: 'RowId',
		fitColumns: true,
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

	 	function SaveItms() {
			var Row = ContractGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择合同信息!');
				return;
			}
			if (Row['AuditFlag'] == 'Y') {
				$UI.msg('alert', '此合同已审核,请核实!');
				return false;
			}
			var Detail = ItmGrid.getChangesData('InciId');
			if (Detail === false) {
				return;
			}
			if (isEmpty(Detail)) {
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
				MethodName: 'SaveItmCont',
				ContId: Row.RowId,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					ItmGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
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
		var VendorId = row['PbVendorId'];
		var InciId = row.InciDr, InciCode = row.InciCode, InciDesc = row.InciDesc;
		var FindIndex = ItmGrid.find('InciId', InciId);
		if (FindIndex >= 0 && FindIndex != ItmGrid.ditIndex) {
			$UI.msg('alert', InciCode + ' ' + InciDesc + '位于第' + (FindIndex + 1) + '行!');
			ItmGrid.stopJump();
			return false;
		}
		var ConRow = ContractGrid.getSelected();
		if (VendorId != ConRow['Vendor']) {
			$UI.confirm(InciCode + ' ' + InciDesc + '供应商与此合同不一致, 是否继续?', '', '', SelectRowSet, '', '', '', '', row);
		} else {
			SelectRowSet(row);
		}
	};
	
	var SelectRowSet = function(row) {
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
			var ConRow = ContractGrid.getSelected();
			if (ConRow['AuditFlag'] != 'Y') {
				ItmGrid.startEditingNext('InciDesc');
			}
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
			width: 200,
			editor: InciEditor(HandlerParams, SelectRow)
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
		showAddSaveDelItems: true,
		beforeAddFn: function() {
			var Row = ContractGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择合同信息!');
				return false;
			} else if (Row['AuditFlag'] == 'Y') {
				$UI.msg('alert', '此合同已审核,请核实!');
				return false;
			}
			return true;
		},
		saveDataFn: function() {
			SaveItms();
		},
		beforeDelFn: function() {
			var Row = ContractGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择合同信息!');
				return false;
			} else if (Row['AuditFlag'] == 'Y') {
				$UI.msg('alert', '此合同已审核,请核实!');
				return false;
			}
			return true;
		},
		onBeforeEdit: function(index, row) {
			if (!isEmpty(row['RowId'])) {
				return false;
			}
			return true;
		},
		onClickRow: function(index, row) {
			ItmGrid.commonClickRow(index, row);
		}
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
	
	$UI.linkbutton('#IncItmFilterBtn', {
		onClick: function() {
			var BatParamsObj = $UI.loopBlock('#VendorBox');
			var Vendor = $('#ItmVendor').combo('getValue');
			if (Vendor == '' || Vendor == null) {
				$UI.msg('alert', '请选择供应商!');
				return;
			}
			var Row = ContractGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择合同信息!');
				return;
			}
			VendorItmGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
				QueryName: 'QueryItmByVendor',
				query2JsonStrict: 1,
				Vendor: Vendor,
				ContId: Row.RowId,
				rows: 9999
			});
		}
	});
	
	$UI.linkbutton('#IncItms', {
		onClick: function() {
			var Row = ContractGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择合同信息!');
				return;
			}
			var Rows = VendorItmGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择要保存的供应商物资信息!');
				return;
			}
			if (Row['AuditFlag'] == 'Y') {
				$UI.msg('alert', '此合同已审核,请核实!');
				return false;
			}
			var Detail = VendorItmGrid.getSelectedData();
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
				MethodName: 'SaveItmCont',
				ContId: Row.RowId,
				Detail: JSON.stringify(Detail)
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					ItmGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	var VendorItmCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: '物资Id',
			field: 'InciId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '代码',
			field: 'InciCode',
			width: 150
		}, {
			title: '名称',
			field: 'InciDesc',
			width: 200
		}, {
			title: '规格',
			field: 'Spec',
			width: 150
		}
	]];

	VendorItmGrid = $UI.datagrid('#VendorItmGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			QueryName: 'QueryItmByVendor',
			query2JsonStrict: 1
		},
		//toolbar: '#VendorBox',
		columns: VendorItmCm,
		fitColumns: true,
		pagination: false,
		singleSelect: false
	});
	
	var ConLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#ConLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + ConLocParams
	});
	
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M', BDPHospital: HospId }));
	$HUI.combobox('#ItmVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Select();
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$('#ItmVendor').combobox('clear');
			$('#Scg').combobox('clear');
			$UI.clearBlock('#MainConditions');
			$UI.clear(ContractGrid);
			$UI.clear(ItmGrid);
			$UI.clear(VendorItmGrid);
		}
	});

	$UI.linkbutton('#AddBT', {
		onClick: function() {
			AddWin('', Select, HospId);
		}
	});
	
	$UI.linkbutton('#CompBT', {
		onClick: function() {
			SetComp();
		}
	});
	
	function SetComp() {
		var RowsData = ContractGrid.getSelections();
		for (var i = 0; i < RowsData.length; i++) {
			var CompFlag = RowsData[i].CompFlag;
			var ContractNo = RowsData[i].ContractNo;
			if (CompFlag == 'Y') {
				$UI.msg('alert', ContractNo + '合同已提交!');
				return false;
			}
		}
		var ListData = JSON.stringify(RowsData);
		var Params = JSON.stringify(sessionObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			MethodName: 'jsSetComp',
			ListData: ListData,
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				ContractGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$UI.linkbutton('#CancelCompBT', {
		onClick: function() {
			CancelComp();
		}
	});
	
	function CancelComp() {
		var RowsData = ContractGrid.getSelections();
		var ListData = JSON.stringify(RowsData);
		var Params = JSON.stringify(sessionObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
			MethodName: 'jsCancelComp',
			ListData: ListData,
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				ContractGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#UpPicBT', {
		onClick: function() {
			var Row = ContractGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择合同信息!');
				return;
			}
			var RowId = Row.RowId;
			var Vendor = Row.Vendor;
			UpLoadFileWin('Contract', RowId, '', 'Vendor', Vendor, '');
		}
	});
	$.parser.parse('#VendorBox');
	$.parser.parse('#ScgBox');
	
	$UI.fillBlock('#MainConditions', { ConLoc: gLocObj });
	InitHosp();
	Select();
};
$(init);

function Select(RowId) {
	var SessionParmas = addSessionParams({ BDPHospital: HospId });
	var Paramsobj = $UI.loopBlock('#MainConditions');
	if (!isEmpty(RowId)) {
		Paramsobj['RowId'] = RowId;
	}
	if (isEmpty(Paramsobj['ConLoc'])) {
		$UI.msg('alert', '科室不可为空!');
		return;
	}
	var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
	$UI.clear(ContractGrid);
	$UI.clear(ItmGrid);
	$UI.clear(VendorItmGrid);
	ContractGrid.load({
		ClassName: 'web.DHCSTMHUI.DHCConTrackManager',
		QueryName: 'QueryCont',
		query2JsonStrict: 1,
		Params: Params
	});
}

function Update(ContId) {
	var RowData = ContractGrid.getRows()[ContractGrid.getRowIndex(ContId)];
	var AuditFlag = RowData['AuditFlag'];
	if (AuditFlag == 'Y') {
		$UI.msg('alert', '此合同已审核,请核实!');
		return;
	} else {
		AddWin(ContId, Select, HospId);
	}
}
function ConfirmAddWin(ParamsObj) {
	var ContId = ParamsObj['ContId'];
	AddWin(ContId, Select, HospId);
}

function ViewPic(index) {
	var RowData = ContractGrid.getRows()[index];
	var OrgType = 'Contract';
	var OrgId = RowData.RowId;
	var Vendor = RowData.Vendor;
	ViewFileWin(OrgType, OrgId, '', 'Vendor', Vendor, '', HospId);
}