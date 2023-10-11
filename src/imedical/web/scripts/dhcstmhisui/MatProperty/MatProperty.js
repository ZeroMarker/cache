var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_ItmNotUseReason';
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
		Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		if (TableName == 'DHC_ItmNotUseReason') {
			NotUseReasonGrid.load({
				ClassName: 'web.DHCSTMHUI.ItmNotUseReason',
				QueryName: 'SelectAll',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (TableName == 'DHC_ItmQualityLevel') {
			QuailtyLevelGrid.load({
				ClassName: 'web.DHCSTMHUI.ITMQL',
				QueryName: 'SelectAll',
				query2JsonStrict: 1,
				Params: Params
			});
		} else if (TableName == 'INC_SterileCategory') {
			CategoryGrid.load({
				ClassName: 'web.DHCSTMHUI.ItmCate',
				QueryName: 'SelectAll',
				query2JsonStrict: 1,
				Params: Params
			});
		}
	}
	
	$HUI.tabs('#DetailTabs', {
		onSelect: function(title, index) {
			if (title == '不可用原因') {
				TableName = 'DHC_ItmNotUseReason';
			} else if (title == '执行标准') {
				TableName = 'DHC_ItmQualityLevel';
			} else if (title == '灭菌分类') {
				TableName = 'INC_SterileCategory';
			}
			InitHosp();
		}
	});
	
	// 不可用原因--------------------------
	function SaveNotUseReason() {
		var Rows = NotUseReasonGrid.getChangesData();
		if (Rows === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.ItmNotUseReason',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', '保存成功！');
				NotUseReasonGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var NotUseReasonGrid = $UI.datagrid('#NotUseReasonGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ItmNotUseReason',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.ItmNotUseReason',
			MethodName: 'Delete'
		},
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveNotUseReason();
			} }],
		columns: [[{
			title: 'RowId',
			field: 'RowId',
			hidden: true
		}, {
			title: '描述',
			field: 'Description',
			width: 350,
			editor: { type: 'validatebox', options: { required: true }}
		}
		]],
		showAddDelItems: true,
		onClickRow: function(index, row) {
			NotUseReasonGrid.commonClickRow(index, row);
		}
	});
	// 质量层次--------------------------
	function SaveQuailtyLevel() {
		var Rows = QuailtyLevelGrid.getChangesData();
		if (Rows === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.ITMQL',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', '保存成功！');
				QuailtyLevelGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var QuailtyLevelGrid = $UI.datagrid('#QuailtyLevelGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ITMQL',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.ITMQL',
			MethodName: 'Delete'
		},
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				SaveQuailtyLevel();
			} }],
		columns: [[
			{
				title: 'RowId',
				field: 'RowId',
				hidden: true
			}, {
				title: '代码',
				field: 'Code',
				width: 310,
				editor: { type: 'validatebox', options: { required: true }}
			}, {
				title: '描述',
				field: 'Description',
				width: 350,
				editor: { type: 'validatebox', options: { required: true }}
			}
		]],
		showAddDelItems: true,
		onClickRow: function(index, row) {
			QuailtyLevelGrid.commonClickRow(index, row);
		}
	});
	// 灭菌分类--------------------------
	function SaveCategory() {
		var Rows = CategoryGrid.getChangesData();
		if (Rows === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.ItmCate',
			MethodName: 'Save',
			Main: MainObj,
			Params: JSON.stringify(Rows)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', '保存成功！');
				CategoryGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var CategoryGrid = $UI.datagrid('#CategoryGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ItmCate',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		deleteRowParams: {
			ClassName: 'web.DHCSTMHUI.ItmCate',
			MethodName: 'Delete'
		},
		toolbar: [
			{
				text: '保存',
				iconCls: 'icon-save',
				handler: function() {
					SaveCategory();
				}
			}
		],
		columns: [[
			{
				title: 'RowId',
				field: 'RowId',
				hidden: true
			}, {
				title: '描述',
				field: 'Description',
				width: 350,
				editor: { type: 'validatebox', options: { required: true }}
			}
		]],
		showAddDelItems: true,
		onClickRow: function(index, row) {
			CategoryGrid.commonClickRow(index, row);
		}
	});
	InitHosp();
};
$(init);