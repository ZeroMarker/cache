function setTransferFrLoc(LocInfoGrid,Hospid) {
	var select = LocInfoGrid.getSelected()
		if (isEmpty(select)) {
			$UI.msg('alert', '请选择科室!')
			return;
		}
		var Clear = function () {
		$UI.clear(TransferFrLocGrid);
		$UI.clear(LocGrid);
	}
	$UI.linkbutton('#LocGridSearchBT', {
		onClick: function () {
			var SessionParmas=addSessionParams({Hospital:Hospid});
			var Paramsobj=$UI.loopBlock('LocGridTB');
			var Params=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
			LocGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
				QueryName: 'NotTransferFrLoc',
				Params: Params,
				Loc: select.LocId
			});
		}
	});
	$UI.linkbutton('#TransferFrLocGridSearchBT', {
		onClick: function () {
			TransferFrLocSave();
		}
	});
	$HUI.dialog('#TransferFrLoc').open()

	function TransferFrLocSave() {
		var Detail = TransferFrLocGrid.getChangesData();
		if (Detail === false){	//未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)){	//明细不变
			$UI.msg("alert", "没有需要保存的明细!");
			return;
		}
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
			MethodName: 'SaveDefat',
			Rows: JSON.stringify(Detail)
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				TransferFrLocGrid.commonReload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var TransferFrLocGridCm = [[{
				title: 'RowId',
				field: 'RowId',
				hidden: true
			}, {
				title: '代码',
				field: 'Code',
				width: 180
			}, {
				title: '描述',
				field: 'Description',
				width: 180
			}, {
				title: '默认值',
				field: 'DefaultFlag',
				width: 80,
				align: 'center',
				editor: {
					type: 'checkbox',
					options: {
						on: 'Y',
						off: 'N'
					}
				},
				formatter: BoolFormatter
			}
		]];

	var TransferFrLocGrid = $UI.datagrid('#TransferFrLocGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
				QueryName: 'TransferLoc',
				Loc: select.LocId
			},
			lazy: false,
			toolbar: '#TransferFrLocGridTB',
			columns: TransferFrLocGridCm,
			onDblClickRow: function (index, row) {
				var Rows = TransferFrLocGrid.getSelectedData();
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
					MethodName: 'Delete',
					Params: JSON.stringify(Rows)
				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						TransferFrLocGrid.reload();
						LocGrid.reload();
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			},
			onClickCell: function (index, filed, value) {
				TransferFrLocGrid.commonClickCell(index, filed)
			}
		})
		var LocGridCm = [[{
					title: 'RowId',
					field: 'RowId',
					hidden: true
				}, {
					title: '代码',
					field: 'Code',
					width: 200
				}, {
					title: '描述',
					field: 'Description',
					width: 200
				}
			]];
	var SessionParmas=addSessionParams({Hospital:Hospid});
	var Paramsobj=$UI.loopBlock('LocGridTB');
	var Params1=JSON.stringify(jQuery.extend(true,Paramsobj,SessionParmas));
	var LocGrid = $UI.datagrid('#LocGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
				QueryName: 'NotTransferFrLoc',
				Loc: select.LocId,
				Params:Params1
			},
			lazy: false,
			toolbar: '#LocGridTB',
			columns: LocGridCm,
			onDblClickRow: function (index, row) {
				var LocId = select.LocId;
				var Frloc = row.RowId;
				var Datefrom = "";
				var Dateto = "";
				var GroupId = gGroupId;
				$.cm({
					ClassName: 'web.DHCSTMHUI.DHCTransferLocConf',
					MethodName: 'Insert',
					LocId: LocId,
					Frloc: Frloc,
					Datefrom: Datefrom,
					Dateto: Dateto,
					GroupId: GroupId

				}, function (jsonData) {
					if (jsonData.success == 0) {
						$UI.msg('success', jsonData.msg);
						LocGrid.reload();
						TransferFrLocGrid.reload()
					} else {
						$UI.msg('error', jsonData.msg);
					}
				});
			}
		})
		Clear();
}