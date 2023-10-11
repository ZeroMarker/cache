// 器械维护界面js
var init = function() {
	var GridList;
	var HospId = gHospId;
	var TableName = 'CSSD_Item';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		} else {
			Query();
		}
	}
	
	var Query = function() {
		var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		var Params = JSON.stringify($UI.loopBlock('PkgItmTB'));
		GridList.load({
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectAll',
			Params: Params,
			Others: Others
		});
	};

	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('PkgItmTB');
			$UI.clear(GridList);
		}
	});

	var Cm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '器械',
			field: 'ItmDesc',
			width: 200,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '别名',
			field: 'ItmAlias',
			width: 100,
			editor: { type: 'validatebox' }
		}, {
			title: '器械规格',
			field: 'ItmSpec',
			width: 200,
			editor: { type: 'validatebox', options: { required: false }}
		}, {
			title: '价格',
			align: 'right',
			field: 'ItmPrice',
			width: 100,
			editor: { type: 'numberbox', options: { required: false }},
			formatter: function(value, row, index) {
				if (value !== '') {
					return (parseFloat(value).toFixed(2) + '').replace(/\d{1,3}(?=(\d{3})+(\.\d*)?$)/g, '$&,');
				}
			}
		}, {
			title: '是否可用',
			align: 'center',
			field: 'UseFlag',
			width: 150,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '是否植入物',
			align: 'center',
			field: 'ImplantsFlag',
			width: 100,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '一次性标志',
			align: 'center',
			field: 'OneOffFlag',
			width: 100,
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '备注',
			field: 'Remarks',
			width: 250,
			editor: { type: 'validatebox' }
		}
	]];

	GridList = $UI.datagrid('#GridList', {
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
			MethodName: 'jsDeleteItm'
		},
		navigatingWithKey: true,
		columns: Cm,
		checkField: 'ItmDesc',
		fitColumns: true,
		onClickRow: function(index, row) {
			GridList.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#GridList').datagrid('selectRow', 0);
			}
		},
		showAddSaveDelItems: true,
		saveDataFn: function() {
			var Rows = GridList.getChangesData();
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.PackageItem',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				$UI.msg('success', jsonData.msg);
				if (jsonData.success === 0) {
					GridList.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		beforeAddFn: function() {
			var DefaultData = { UseFlag: 'Y' };
			return DefaultData;
		}
	});
	InitHosp();
};
$(init);