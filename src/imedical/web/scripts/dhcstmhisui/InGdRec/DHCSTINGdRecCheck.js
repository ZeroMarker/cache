/*��ⵥ��ѯ������*/
var init = function () {
	$UI.linkbutton('#QueryBT', {
		onClick: function () {
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			IngrClear();
		}
	});
	$UI.linkbutton('#AcceptBT', {
		onClick: function () {
			AcceptData();
		}
	});
	$UI.linkbutton('#EvaluateBT', {
		onClick: function () {
			var Row = InGdRecMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ�������۵���ⵥ!');
				return false;
			}
			VendorEvaluateWin(Row.IngrId);
		}
	});
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: "Login" }));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var FVendorBoxParams = JSON.stringify(addSessionParams({ APCType: "M", RcFlag: "Y" }));
	var FVendorBox = $HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var InGdRecMainCm = [[{
		title: "RowId",
		field: 'IngrId',
		width: 100,
		hidden: true
	}, {
		title: "��ⵥ��",
		field: 'IngrNo',
		width: 120
	}, {
		title: "��Ӧ��",
		field: 'Vendor',
		width: 200
	}, {
		title: '��������',
		field: 'ReqLocDesc',
		width: 150
	}, {
		title: '������',
		field: 'AcceptUser',
		width: 70
	}, {
		title: '��������',
		field: 'CreateDate',
		width: 90
	}, {
		title: '�ɹ�Ա',
		field: 'PurchUser',
		width: 70
	}, {
		title: "��ɱ�־",
		field: 'Complete',
		width: 70
	}, {
		title: "���۽��",
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "�ۼ۽��",
		field: 'SpAmt',
		width: 100,
		align: 'right'
	}
	]];

	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query'
		},
		columns: InGdRecMainCm,
		showBar: true,
		//plugins: [ProdCertif],
		onSelect: function (index, row) {
			$UI.setUrl(InGdRecDetailGrid)
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				Parref: row.IngrId,
				rows: 99999
			});
		}
	})
	var AcceptConCombox = {
		type: 'combobox',
		options: {
			data: [{ 'RowId': '�ϸ�', 'Description': '�ϸ�' }, { 'RowId': '���ϸ�', 'Description': '���ϸ�' }],
			//data:[['�ϸ�','�ϸ�'],['���ϸ�','���ϸ�']],
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function (record) {
				var rows = InRequestGrid.getRows();
				var row = rows[InRequestGrid.editIndex];
				row.UomDesc = record.Description;

			},
			onShowPanel: function () {
				$(this).combobox('reload');
			}
		}
	};
	var InGdRecDetailCm = [[{
		title: "RowId",
		field: 'RowId',
		width: 100,
		hidden: true
	}, {
		title: '���ʴ���',
		field: 'IncCode',
		width: 80
	}, {
		title: '��������',
		field: 'IncDesc',
		width: 230
	}, {
		title: "���",
		field: 'Spec',
		width: 180
	}, {
		title: "������",
		field: 'SpecDesc',
		width: 180
	}, {
		title: "����",
		field: 'Manf',
		width: 180
	}, {
		title: "����",
		field: 'BatchNo',
		width: 90
	}, {
		title: "��Ч��",
		field: 'ExpDate',
		width: 100
	}, {
		title: "��λ",
		field: 'IngrUom',
		width: 80
	}, {
		title: "����",
		field: 'RecQty',
		width: 80,
		align: 'right'
	}, {
		title: "���װ���",
		field: 'PackGood',
		width: 60,
		align: 'center',
		editor: {
			type: 'checkbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		}
	}, {
		title: "�кϸ�֤",
		field: 'ProdCertif',
		width: 60,
		align: 'center',
		editor: {
			type: 'checkbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		}
	}, {
		title: "��ⱨ��",
		field: 'CheckRepNo',
		width: 60,
		align: 'center',
		editor: {
			type: 'checkbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		}
	}, {
		title: "��Ʒ��ʶ",
		field: 'Token',
		width: 60,
		align: 'center',
		editor: {
			type: 'checkbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		}
	}, {
		title: "���ı�ʶ",
		field: 'LocalToken',
		width: 60,
		align: 'center',
		editor: {
			type: 'checkbox',
			options: {
				on: 'Y',
				off: 'N'
			}
		}
	}, {
		title: "�����¶�",
		field: 'AOGTemp',
		width: 80,
		editor: {
			type: 'numberbox',
		}
	}, {
		title: "���ս���",
		field: 'AcceptCon',
		width: 80,
		formatter: CommonFormatter(AcceptConCombox, 'AcceptCon', 'AcceptCon'),
		editor: AcceptConCombox
	}, {
		title: "���ڰ�",
		field: 'CheckPort',
		width: 80,
		editor: {
			type: 'text'
		}
	}, {
		title: "��������",
		field: 'CheckRepDate',
		width: 80,
		editor: {
			type: 'datebox'
		}
	}, {
		title: "���ձ�ע",
		field: 'CheckRemarks',
		width: 80,
		editor: {
			type: 'text'
		}
	}, {
		title: "ע��֤��",
		field: 'AdmNo',
		width: 80,
		editor: {
			type: 'text'
		}
	}, {
		title: "ע��֤��Ч��",
		field: 'AdmExpdate',
		width: 80,
		editor: {
			type: 'datebox',
			options: {
			}
		}
	}, {
		title: "ժҪ",
		field: 'Remark',
		width: 80,
		editor: {
			type: 'text'
		}
	}, {
		title: "����",
		field: 'Rp',
		width: 60,
		align: 'right'
	}, {
		title: "�ۼ�",
		field: 'Sp',
		width: 60,
		align: 'right'
	}, {
		title: "��Ʊ��",
		field: 'InvNo',
		width: 80
	}, {
		title: "��Ʊ����",
		field: 'InvDate',
		width: 100
	}, {
		title: "���۽��",
		field: 'RpAmt',
		width: 100,
		align: 'right'
	}, {
		title: "�ۼ۽��",
		field: 'SpAmt',
		width: 100,
		align: 'right'
	}, {
		title: '��ֵ����',
		field: 'HVBarCode',
		width: 80
	}, {
		title: '�Դ�����',
		field: 'OrigiBarCode',
		width: 80
	}
	]];

	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		url: '',
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			rows: 99999
		},
		pagination:false,
		columns: InGdRecDetailCm,
		showBar: true,
		onClickCell: function (index, filed, value) {
			InGdRecDetailGrid.commonClickCell(index, filed, value);
		}
	})
	function QueryIngrInfo() {
		var ParamsObj = $UI.loopBlock('#FindConditions')
		if (isEmpty(ParamsObj.StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.FRecLoc)) {
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(InGdRecDetailGrid);
		$UI.setUrl(InGdRecMainGrid)
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			Params: Params
		});

	}
	function AcceptData() {
		var Row = InGdRecMainGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '��ѡ��Ҫ���յ���ⵥ!');
			return false;
		}
		if (Row.AcceptUser != "") {
			$UI.msg('alert', '����ⵥ�����գ�������ѡ��')
			return false;
		}
		var IngrId = Row.IngrId;
		var Main = JSON.stringify(addSessionParams({ IngrId: IngrId }));
		var DetailObj = InGdRecDetailGrid.getRowsData();
		if (DetailObj.length == 0) {
			$UI.msg('alert', '���յ�����ϸ!');
			return false;
		}
		var Detail = JSON.stringify(DetailObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			MethodName: 'SaveAcceptInfo',
			MainInfo: Main,
			ListData: Detail
		}, function (jsonData) {
			$UI.msg('alert', jsonData.msg);
			if (jsonData.success == 0) {
				QueryIngrInfo();
			}
		});
	}
	function IngrClear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			FRecLoc: gLocObj,
			FStatusBox: "Y"
		}
		$UI.fillBlock('#FindConditions', Dafult);

	}
	IngrClear();
}
$(init);