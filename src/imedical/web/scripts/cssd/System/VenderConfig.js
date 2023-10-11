// 外来器械厂商维护界面js
var init = function() {
	var HospId = gHospId;
	var TableName = 'CSSD_Ven';
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
	
	var Query = function() {
		var Params = JSON.stringify($UI.loopBlock('VenderTB'));
		var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		VenderGrid.load({
			ClassName: 'web.CSSDHUI.System.VenderConfig',
			QueryName: 'QueryVenderInfo',
			Params: Params,
			Others: Others
		});
	};
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('VenderTB');
			$UI.clear(VenderGrid);
		}
	});
	
	var MachineVenCombox = {
		type: 'combobox',
		options: {
			data: MachineVenData,
			valueField: 'RowId',
			textField: 'Description',
			editable: true
		}
	};
	
	var VenderCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			hidden: true
		}, {
			title: '厂商代码',
			field: 'VenCode',
			width: 80,
			sortable: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '厂商名称',
			field: 'VenDesc',
			width: 200,
			sortable: true,
			editor: { type: 'validatebox', options: { required: true }}
		}, {
			title: '别名',
			field: 'VenAlias',
			width: 200,
			sortable: true,
			editor: { type: 'text' }
		}, {
			title: '厂商类型',
			field: 'VenType',
			width: 100,
			sortable: true,
			formatter: CommonFormatter(MachineVenCombox, 'VenType', 'VenTypeDesc'),
			editor: MachineVenCombox
		}, {
			title: '配送人',
			field: 'SaleManName',
			width: 100,
			sortable: true,
			editor: { type: 'validatebox' }
		}, {
			title: '电话',
			field: 'Telephone',
			width: 120,
			sortable: true,
			editor: { type: 'text' }
		}, {
			title: '地址',
			field: 'Address',
			width: 300,
			sortable: true,
			editor: { type: 'validatebox' }
		}, {
			title: '是否启用',
			field: 'IsStop',
			align: 'center',
			width: 80,
			editor: { type: 'checkbox', check: 'checked', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];
	
	var VenderGrid = $UI.datagrid('#VenderGrid', {
		queryParams: {
			ClassName: 'web.CSSDHUI.System.VenderConfig',
			QueryName: 'QueryVenderInfo'
		},
		deleteRowParams: {
			ClassName: 'web.CSSDHUI.System.VenderConfig',
			MethodName: 'jsDelete'
		},
		columns: VenderCm,
		showAddSaveDelItems: true,
		saveDataFn: function() {
			var Others = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var Rows = VenderGrid.getChangesData();
			if (isEmpty(Rows)) {
				return;
			}
			if (Rows === false) {
				$UI.msg('alert', '存在未填写的必填项，不能保存!');
				return;
			}
			for (var i = 0; i < Rows.length; i++) {
				var Telephone = Rows[i]['Telephone'];
				if (!isEmpty(Telephone)) {
					var mobile = /^[1][3,4,5,7,8][0-9]{9}$/, phone = /^0\d{2,3}-?\d{7,8}$/;
					if (!mobile.test(Telephone) && !phone.test(Telephone)) {
						$UI.msg('alert', '电话格式不正确!');
						return;
					}
				}
			}
			showMask();
			$.cm({
				ClassName: 'web.CSSDHUI.System.VenderConfig',
				MethodName: 'jsSave',
				Params: JSON.stringify(Rows),
				Others: Others
			}, function(jsonData) {
				hideMask();
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					VenderGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		},
		checkField: 'VenCode',
		onClickRow: function(index, row) {
			VenderGrid.commonClickRow(index, row);
		},
		beforeAddFn: function() {
			var DefaultData = { IsStop: 'Y' };
			return DefaultData;
		}
	});
	InitHosp();
};
$(init);