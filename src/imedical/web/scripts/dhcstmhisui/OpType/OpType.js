var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_OperateType';
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
		OptypeGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCOpType',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	var OpTypeData = [{ 'RowId': 'OM', 'Description': '出库' }, { 'RowId': 'IM', 'Description': '入库' }];
	var OpTypeCombox = {
		type: 'combobox',
		options: {
			data: OpTypeData,
			required: true,
			tipPosition: 'bottom',
			valueField: 'RowId',
			textField: 'Description'
		}
	};
	$('#AddBT').on('click', function() {
		OptypeGrid.commonAddRow();
	});
	
	function CheckDataBeforeSave() {
		if (!OptypeGrid.endEditing()) {
			return false;
		}
		var RowsData = OptypeGrid.getRows();
		var OMDefCount = 0, IMDefCount = 0;
		for (var i = 0; i < RowsData.length; i++) {
			var Type = RowsData[i].Type;
			var DefaultFlag = RowsData[i].DefaultFlag;
			if ((Type == 'OM') && (DefaultFlag == 'Y')) {
				OMDefCount = OMDefCount + 1;
			} else if ((Type == 'IM') && (DefaultFlag == 'Y')) {
				IMDefCount = IMDefCount + 1;
			}
		}
		if (OMDefCount > 1) {
			$UI.msg('alert', '出库类型设置了多个默认值!');
			return false;
		}
		if (IMDefCount > 1) {
			$UI.msg('alert', '入库类型设置了多个默认值!');
			return false;
		}
		return true;
	}
	
	$('#SaveBT').on('click', function() {
		if (!CheckDataBeforeSave()) {
			return;
		}
		var Rows = OptypeGrid.getChangesData();
		if (Rows === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCOpType',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		}, function(jsonData) {
			$UI.msg('success', jsonData.msg);
			if (jsonData.success == 0) {
				OptypeGrid.reload();
			}
		});
	});
	$('#DeleteBT').on('click', function() {
		var Rows = OptypeGrid.getSelectedData();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCOpType',
			MethodName: 'Delete',
			Params: JSON.stringify(Rows)
		}, function(jsonData) {
			$UI.msg('alert', jsonData.msg);
			if (jsonData.success == 0) {
				OptypeGrid.reload();
			}
		});
	});
	var OptypeCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '代码',
			field: 'Code',
			width: 100,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '描述',
			field: 'Description',
			width: 150,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '类型',
			field: 'Type',
			width: 150,
			fitColumns: true,
			formatter: CommonFormatter(OpTypeCombox, 'Type', 'TypeDesc'),
			editor: OpTypeCombox
		}, {
			title: '默认',
			field: 'DefaultFlag',
			width: 150,
			fitColumns: true,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];
	var OptypeGrid = $UI.datagrid('#OptypeList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCOpType',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		columns: OptypeCm,
		toolbar: '#OptypeTB',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickRow: function(index, row) {
			OptypeGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);