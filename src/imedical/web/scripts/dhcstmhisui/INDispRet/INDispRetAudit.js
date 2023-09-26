var init = function () {
	var LocParams = JSON.stringify(addSessionParams({
				Type: 'Login'
			}));
	var LocBox = $HUI.combobox('#LocId', {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
			valueField: 'RowId',
			textField: 'Description'
		});

	var MainCm = [[{
				field: 'ck',
				checkbox: true
			}, {
				title: "RowId",
				field: 'RowId',
				width: 50,
				saveCol: true,
				hidden: true
			}, {
				title: "����",
				field: 'DsrNo',
				width: 150
			}, {
				title: "����",
				field: 'LocDesc',
				width: 200
			}, {
				title: "�Ƶ���",
				field: 'CreateUser',
				width: 100
			}, {
				title: "�Ƶ�����",
				field: 'CreateDate',
				width: 100
			}, {
				title: "�Ƶ�ʱ��",
				field: 'CreateTime',
				width: 100
			}, {
				title: "�����",
				field: 'AuditUser',
				width: 100
			}, {
				title: "�������",
				field: 'AuditDate',
				width: 100
			}, {
				title: "���ʱ��",
				field: 'AuditTime',
				width: 100
			}
		]];

	var MainGrid = $UI.datagrid('#MainGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				QueryName: 'DHCINDispRet'
			},
			singleSelect: false,
			columns: MainCm,
			onSelect: function (index, row) {
				$UI.clear(DetailGrid);
				DetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
					QueryName: 'DHCINDispRetItm',
					Parref: row.RowId,
					rows: 99999
				});
			},
			onLoadSuccess: function (data) {
				if (data.rows.length > 0) {
					MainGrid.selectRow(0);
				}
			}
		});

	var DetailCm = [[{
				title: "RowId",
				field: 'RowId',
				width: 50,
				hidden: true
			}, {
				title: "Inclb",
				field: 'Inclb',
				width: 50,
				hidden: true
			}, {
				title: "IncId",
				field: 'IncId',
				width: 50,
				hidden: true
			}, {
				title: "���ʴ���",
				field: 'InciCode',
				width: 150
			}, {
				title: "��������",
				field: 'InciDesc',
				width: 200
			}, {
				title: "���",
				field: 'Spec',
				width: 100
			}, {
				title: "����",
				field: 'BatchNo',
				width: 100
			}, {
				title: "��Ч��",
				field: 'ExpDate',
				width: 100
			}, {
				title: "�˻�����",
				field: 'Qty',
				width: 80,
				align: 'right'
			}, {
				title: "��λ",
				field: 'UomDesc',
				width: 80
			}, {
				title: "����",
				field: 'Rp',
				width: 80,
				align: 'right'
			}, {
				title: "���۽��",
				field: 'RpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "�ۼ�",
				field: 'Sp',
				width: 80,
				align: 'right'
			}, {
				title: "�ۼ۽��",
				field: 'SpAmt',
				width: 80,
				align: 'right'
			}, {
				title: "����",
				field: 'Manf',
				width: 200
			}, {
				title: "���ŵ���",
				field: 'IndsNo',
				width: 200
			}, {
				title: "���쵥��",
				field: 'DsrqNo',
				width: 200
			}
		]];

	var DetailGrid = $UI.datagrid('#DetailGrid', {
			queryParams: {
				ClassName: 'web.DHCSTMHUI.DHCINDispRetItm',
				QueryName: 'DHCINDispRetItm',
				rows: 99999
			},
			pagination:false,
			columns: DetailCm
		});

	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			var ParamsObj = $UI.loopBlock('#MainConditions');
			if (isEmpty(ParamsObj.LocId)) {
				$UI.msg('alert', '���Ҳ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			ParamsObj.CompFlag = "Y";
			var Params = JSON.stringify(ParamsObj);
			MainGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				QueryName: 'DHCINDispRet',
				Params: Params
			});
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			$UI.clearBlock('#MainConditions');
			$UI.clear(MainGrid);
			$UI.clear(DetailGrid);
			SetDefaValues();
		}
	});

	$UI.linkbutton('#AuditBT', {
		onClick: function () {
			var Rows = MainGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '��ѡ��Ҫ��˵ĵ���!');
				return;
			}
			var ParamsObj = $UI.loopBlock('#MainConditions');
			var Main = JSON.stringify(ParamsObj);
			var Detail = MainGrid.getSelectedData();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCINDispRet',
				MethodName: 'Audit',
				Main: Main,
				Detail: JSON.stringify(Detail)
			}, function (jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					MainGrid.commonReload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#PrintBT', {
		onClick: function () {
			var Rows = MainGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '��ѡ��Ҫ��ӡ�ĵ���!');
				return;
			}
			for(var i=0;i<Rows.length;i++){
				var record=Rows[i];
				PrintINDispRet(record.RowId);
			}
		}
	});
	
	SetDefaValues();
}
$(init);