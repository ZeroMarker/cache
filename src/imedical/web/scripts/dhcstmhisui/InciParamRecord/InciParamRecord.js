// 名称: 物资属性审核维护
// 编写日期: 20200701
var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_InciParamRecord';
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
	var FAuditFlag = $HUI.combobox('#FAuditFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '是' }, { 'RowId': 'N', 'Description': '否' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('Conditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		InciParamRecordGrid.load({
			ClassName: 'web.DHCSTMHUI.InciParamRecord',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#AddBT', {
		onClick: function() {
			InciParamRecordGrid.commonAddRow();
		}
	});
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var Rows = InciParamRecordGrid.getChangesData();
			if (Rows === false) {	// 未完成编辑或明细为空
				return;
			}
			if (isEmpty(Rows)) {	// 明细不变
				$UI.msg('alert', '没有需要保存的明细!');
				return;
			}
			var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			$.cm({
				ClassName: 'web.DHCSTMHUI.InciParamRecord',
				MethodName: 'jsSave',
				Params: MainObj,
				ListData: JSON.stringify(Rows)
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					InciParamRecordGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	var InciParamRecordCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '字段描述',
			field: 'INCIPDesc',
			width: 300,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '字段名称',
			field: 'INCIPParamName',
			width: 350,
			fitColumns: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '审核标志',
			field: 'AuditFlag',
			width: 120,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];
	
	var InciParamRecordGrid = $UI.datagrid('#InciParamRecordGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.InciParamRecord',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: InciParamRecordCm,
		onClickRow: function(index, row) {
			InciParamRecordGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);