var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_CertType';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		}
		Query();
	}
	function Query() {
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		VendorCertTypeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCCertType',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Type: 'Vendor',
			Params: Params
		});
		ManfCertTypeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCCertType',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Type: 'Manf',
			Params: Params
		});
		InciCertTypeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCCertType',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Type: 'Inci',
			Params: Params
		});
	}
	
	function Save(Type) {
		var Rows = '';
		if (Type == 'Vendor') {
			Rows = VendorCertTypeGrid.getChangesData();
		} else if (Type == 'Manf') {
			Rows = ManfCertTypeGrid.getChangesData();
		} else if (Type == 'Inci') {
			Rows = InciCertTypeGrid.getChangesData();
		}
		if (Rows === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId, Type: Type }));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCCertType',
			MethodName: 'jsSave',
			Main: MainObj,
			Detail: JSON.stringify(Rows)
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function Reset() {
		showMask();
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId, Type: 'CertType', InitFlag: 'N' }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DataInit',
			MethodName: 'jsInit',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	CertTypeCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '代码',
			field: 'Code',
			width: 150,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			title: '全称',
			field: 'FullName',
			width: 200,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			title: '简称',
			field: 'ShortName',
			width: 200,
			editor: {
				type: 'validatebox',
				options: {
					required: true
				}
			}
		}, {
			title: '序号',
			field: 'Num',
			width: 100,
			align: 'center',
			editor: {
				type: 'numberbox',
				options: {
					required: true,
					tipPosition: 'bottom',
					min: 1,
					precision: 0
				}
			}
		}, {
			title: '是否展示',
			field: 'ShowFlag',
			width: 100,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '报警天数',
			field: 'WarnDays',
			width: 100,
			align: 'center',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: 0
				}
			}
		}, {
			title: '控制入库天数',
			field: 'ControlInDays',
			width: 100,
			align: 'center',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: 0
				}
			}
		}, {
			title: '控制出库天数',
			field: 'ControlOutDays',
			width: 100,
			align: 'center',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: 0
				}
			}
		}, {
			title: '控制临床天数',
			field: 'ControlUseDays',
			width: 100,
			align: 'center',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: 0
				}
			}
		}
	]];
	// 供应商
	var VendorCertTypeGrid = $UI.datagrid('#VendorCertTypeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCCertType',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				Save('Vendor');
			}
		}, {
			text: '同步',
			iconCls: 'icon-reload',
			handler: function() {
				Reset();
			}
		}],
		columns: CertTypeCm,
		showAddItems: true,
		beforeAddFn: function() {
			var DefaultData = { ShowFlag: 'Y' };
			return DefaultData;
		},
		onClickCell: function(index, field, value) {
			VendorCertTypeGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field) {
			var RowData = $(this).datagrid('getRows')[index];
			if (field == 'Code' && !isEmpty(RowData['RowId'])) {
				return false;
			}
		}
	});
	// 生产厂家
	var ManfCertTypeGrid = $UI.datagrid('#ManfCertTypeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCCertType',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				Save('Manf');
			}
		}],
		columns: CertTypeCm,
		showAddItems: true,
		beforeAddFn: function() {
			var DefaultData = { ShowFlag: 'Y' };
			return DefaultData;
		},
		onClickCell: function(index, field, value) {
			ManfCertTypeGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field) {
			var RowData = $(this).datagrid('getRows')[index];
			if (field == 'Code' && !isEmpty(RowData['RowId'])) {
				return false;
			}
		}
	});
	// 库存项
	var InciCertTypeGrid = $UI.datagrid('#InciCertTypeGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCCertType',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				Save('Inci');
			}
		}],
		columns: CertTypeCm,
		showAddItems: true,
		beforeAddFn: function() {
			var DefaultData = { ShowFlag: 'Y' };
			return DefaultData;
		},
		onClickCell: function(index, field, value) {
			InciCertTypeGrid.commonClickCell(index, field);
		},
		onBeforeCellEdit: function(index, field) {
			var RowData = $(this).datagrid('getRows')[index];
			if (field == 'Code' && !isEmpty(RowData['RowId'])) {
				return false;
			}
		}
	});
	
	InitHosp();
};
$(init);