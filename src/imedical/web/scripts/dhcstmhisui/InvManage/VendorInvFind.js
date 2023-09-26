var FindWin = function (IngrLoc, Fn) {
	$HUI.dialog('#FindWin').open();

	var FVendorParams = JSON.stringify(addSessionParams({
				APCType: "M",
				RcFlag: "Y"
			}));
	var FVendorBox = $HUI.combobox('#FVendor', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var InvMainCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "��ϵ���",
				field: 'AssemNo',
				width: 200
			}, {
				title: "��Ӧ��",
				field: 'VendorDesc',
				width: 200
			}, {
				title: "�Ƶ���",
				field: 'CreateUser',
				width: 80
			}, {
				title: "�Ƶ�����",
				field: 'CreateDate',
				width: 100,
				align: 'right'
			}, {
				title: "�Ƶ�ʱ��",
				field: 'CreateTime',
				width: 80,
				align: 'right'
			}, {
				title: "��Ͻ���",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "���״̬",
				field: 'InvComp',
				width: 80
			}
		]];

	var InvMainGrid = $UI.datagrid('#InvMainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInv'
			},
			columns: InvMainCm,
			onSelect: function (index, row) {
				InvDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCVendorInv',
					QueryName: 'DHCVendorInvItm',
					Inv: row.RowId
				});
			},
			onDblClickRow: function (index, row) {
				Fn(row.RowId);
				$HUI.dialog('#FindWin').close();
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					InvMainGrid.selectRow(0);
				}
			}
		});

	var InvDetailCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "Pointer",
				field: 'Pointer',
				width: 50,
				hidden: true
			}, {
				title: "IncId",
				field: 'IncId',
				width: 50,
				hidden: true
			}, {
				title: "����",
				field: 'Code',
				width: 120
			}, {
				title: "����",
				field: 'Description',
				width: 150
			}, {
				title: "���",
				field: 'Spec',
				width: 100
			}, {
				title: "����",
				field: 'Qty',
				width: 100,
				align: 'right'
			}, {
				title: "��λ",
				field: 'UomDesc',
				width: 80
			}, {
				title: "����",
				field: 'Rp',
				width: 100,
				align: 'right'
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "�ۼ�",
				field: 'Sp',
				width: 100,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 100,
				align: 'right'
			}, {
				title: "����",
				field: 'Manf',
				width: 100
			}, {
				title: "����",
				field: 'Type',
				align: 'center',
				formatter: function(value,row,index){
					if (value=="G"){
						return "���";
					} else {
						return "�˻�";
					}
				}
			}
		]];

	var InvDetailGrid = $UI.datagrid('#InvDetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInvItm'
			},
			columns: InvDetailCm
		})

	$UI.linkbutton('#FQueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			$UI.clear(InvMainGrid);
			$UI.clear(InvDetailGrid);
			InvMainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCVendorInv',
				QueryName: 'DHCVendorInv',
				LocId: IngrLoc,
				Params: Params
			});
		}
	});
	
	$UI.linkbutton('#FSelectBT', {
		onClick: function () {
			var Row = InvMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ���صķ�Ʊ��ϵ�!');
			}
			Fn(Row.RowId);
			$HUI.dialog('#FindWin').close();
		}
	});
	
	$UI.linkbutton('#FClearBT', {
		onClick: function () {
			Clear();
		}
	});

	function Clear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InvMainGrid);
		$UI.clear(InvDetailGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
		}
		$UI.fillBlock('#FindConditions', Dafult);
	}
	Clear();
}