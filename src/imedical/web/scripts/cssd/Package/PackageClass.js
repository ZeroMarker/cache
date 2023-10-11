var init = function() {
	var PkgClassGrid;
	var HospId = gHospId;
	var TableName = 'CSSD_PackageClass';
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
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		PkgClassGrid.load({
			ClassName: 'web.CSSDHUI.PackageInfo.PackageClass',
			QueryName: 'SelectAll',
			Params: Params,
			rows: 9999
		});
	};
	
	var PkgClassCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '代码',
			field: 'PkgClassCode',
			width: 100,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '描述',
			field: 'PkgClassDesc',
			width: 150,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '是否启用',
			align: 'center',
			field: 'NotUseFlag',
			width: 100,
			editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];
	PkgClassGrid = $UI.datagrid('#GridList', {
		url: $URL,
		queryParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageClass',
			QueryName: 'SelectAll'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.PackageInfo.PackageClass',
			MethodName: 'jsDelete'
		},
		navigatingWithKey: true,
		columns: PkgClassCm,
		pagination: false,
		remoteSort: false,
		checkField: 'PkgClassCode',
		showAddSaveDelItems: true,
		onClickRow: function(index, row) {
			PkgClassGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$('#GridList').datagrid('selectRow', 0);
			}
		},
		beforeAddFn: function() {
			var DefaultData = { NotUseFlag: 'Y' };
			return DefaultData;
		},
		saveDataFn: function() {
			var Rows = PkgClassGrid.getChangesData();
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			$.cm({
				ClassName: 'web.CSSDHUI.PackageInfo.PackageClass',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					PkgClassGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	InitHosp();
};
$(init);