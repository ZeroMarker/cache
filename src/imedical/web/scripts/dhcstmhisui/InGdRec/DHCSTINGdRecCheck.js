/* ��ⵥ��ѯ������*/
var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryIngrInfo();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			IngrClear();
		}
	});
	$UI.linkbutton('#AcceptBT', {
		onClick: function() {
			AcceptData();
		}
	});
	$UI.linkbutton('#EvaluateBT', {
		onClick: function() {
			var Row = InGdRecMainGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫ�������۵���ⵥ!');
				return false;
			}
			VendorEvaluateWin(Row.IngrId);
		}
	});
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var RowData = InGdRecMainGrid.getSelections();
			var IngrIdStr = '';
			for (var i = 0; i < RowData.length; i++) {
				var IngrId = RowData[i].IngrId;
				if (IngrIdStr == '') {
					IngrIdStr = IngrId;
				} else {
					IngrIdStr = IngrIdStr + ',' + IngrId;
				}
			}
			if (IngrIdStr == '') {
				$UI.msg('alert', '��ѡ����Ҫ��ӡ����Ϣ!');
				return false;
			}
			var ParamsObj = $UI.loopBlock('#FindConditions');
			PrintRecCheck(IngrIdStr);
		}
	});
	var FRecLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var FRecLocBox = $HUI.combobox('#FRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				FVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				FVendorBox.reload(url);
			}
		}
	});
	var FVendorBoxParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVendorBox = $HUI.combobox('#FVendorBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVendorBoxParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var InGdRecMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'IngrId',
			width: 100,
			hidden: true
		}, {
			title: '��ⵥ��',
			field: 'IngrNo',
			width: 120
		}, {
			title: '��Ӧ��',
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
			title: '��ɱ�־',
			field: 'Complete',
			width: 70
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�����',
			field: 'AuditUser',
			width: 90
		}, {
			title: '�������',
			field: 'AuditDate',
			width: 90
		}
	]];

	var InGdRecMainGrid = $UI.datagrid('#InGdRecMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: InGdRecMainCm,
		showBar: true,
		singleSelect: false,
		onSelectChangeFn: function() {
			var Rows = InGdRecMainGrid.getSelections();
			var count = Rows.length;
			var IngrIdStr = '';
			for (i = 0; i < count; i++) {
				var RowData = Rows[i];
				var IngrId = RowData.IngrId;
				if (IngrIdStr == '') {
					IngrIdStr = IngrId;
				} else {
					IngrIdStr = IngrIdStr + ',' + IngrId;
				}
			}
			InGdRecDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				Parref: IngrIdStr,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var AcceptConCombox = {
		type: 'combobox',
		options: {
			data: [{ 'RowId': '�ϸ�', 'Description': '�ϸ�' }, { 'RowId': '���ϸ�', 'Description': '���ϸ�' }],
			valueField: 'RowId',
			textField: 'Description',
			onSelect: function(record) {
				var rows = InGdRecDetailGrid.getRows();
				var row = rows[InGdRecDetailGrid.editIndex];
				row.UomDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var InGdRecDetailCm = [[
		{
			title: 'RowId',
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
			title: '���',
			field: 'Spec',
			width: 180
		}, {
			title: '������',
			field: 'SpecDesc',
			width: 180,
			hidden: CodeMainParamObj.UseSpecList == 'Y' ? false : true
		}, {
			title: '��������',
			field: 'Manf',
			width: 180
		}, {
			title: '����',
			field: 'BatchNo',
			width: 90
		}, {
			title: '��Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '��λ',
			field: 'IngrUom',
			width: 80
		}, {
			title: '����',
			field: 'RecQty',
			width: 80,
			align: 'right'
		}, {
			title: '���װ���',
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
			title: '�кϸ�֤',
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
			title: '��ⱨ��',
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
			title: '��Ʒ��ʶ',
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
			title: '���ı�ʶ',
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
			title: '�����¶�',
			field: 'AOGTemp',
			width: 80,
			editor: {
				type: 'numberbox',
				options: {
					precision: 2
				}
			}
		}, {
			title: '���ս���',
			field: 'AcceptCon',
			width: 80,
			formatter: CommonFormatter(AcceptConCombox, 'AcceptCon', 'AcceptCon'),
			editor: AcceptConCombox
		}, {
			title: '���ڰ�',
			field: 'CheckPort',
			width: 80,
			editor: {
				type: 'text'
			}
		}, {
			title: '��������',
			field: 'CheckRepDate',
			width: 80,
			editor: {
				type: 'datebox'
			}
		}, {
			title: '���ձ�ע',
			field: 'CheckRemarks',
			width: 80,
			editor: {
				type: 'text'
			}
		}, {
			title: 'ע��֤��',
			field: 'AdmNo',
			width: 80,
			editor: {
				type: 'text'
			}
		}, {
			title: 'ע��֤��Ч��',
			field: 'AdmExpdate',
			width: 80,
			editor: {
				type: 'datebox',
				options: {
				}
			}
		}, {
			title: 'ժҪ',
			field: 'Remark',
			width: 80,
			editor: {
				type: 'text'
			}
		}, {
			title: '����',
			field: 'Rp',
			width: 60,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 60,
			align: 'right'
		}, {
			title: '��Ʊ��',
			field: 'InvNo',
			width: 80
		}, {
			title: '��Ʊ����',
			field: 'InvDate',
			width: 100
		}, {
			title: '����ҽ������',
			field: 'MatInsuCode',
			width: 160
		}, {
			title: '����ҽ������',
			field: 'MatInsuDesc',
			width: 160
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
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
		}, {
			title: '��ⵥ��',
			field: 'IngrNo',
			width: 120
		}
	]];

	var InGdRecDetailGrid = $UI.datagrid('#InGdRecDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCINGdRecItm',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		pagination: false,
		columns: InGdRecDetailCm,
		showBar: true,
		onClickRow: function(index, row) {
			InGdRecDetailGrid.commonClickRow(index, row);
		}
	});
	function QueryIngrInfo() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
		if (isEmpty(ParamsObj.FRecLoc)) {
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return false;
		}
		if (isEmpty(StartDate)) {
			$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
			return;
		}
		if (isEmpty(EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
			return;
		}
		if (compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
			return;
		}
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(InGdRecDetailGrid);
		InGdRecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCINGdRec',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	function AcceptData() {
		var RowsData = InGdRecMainGrid.getSelections();
		if (isEmpty(RowsData)) {
			$UI.msg('alert', '��ѡ��Ҫ���յ���ⵥ!');
			return false;
		}
		var IngrIdStr = '';
		for (var i = 0; i < RowsData.length; i++) {
			var AcceptUser = RowsData[i].AcceptUser;
			var IngrNo = RowsData[i].IngrNo;
			var IngrId = RowsData[i].IngrId;
			if (!isEmpty(AcceptUser)) {
				$UI.msg('alert', IngrNo + '��ⵥ������!');
				return false;
			}
			if (IngrIdStr == '') {
				IngrIdStr = IngrId;
			} else {
				IngrIdStr = IngrIdStr + '^' + IngrId;
			}
		}
		if (IngrIdStr == '') {
			$UI.msg('alert', 'û����Ҫ���յĵ���!');
			return false;
		}
		var Main = JSON.stringify(addSessionParams({ IngrIdStr: IngrIdStr }));
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
		}, function(jsonData) {
			if (jsonData.success == 0) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					InGdRecMainGrid.reload();
				} else {
					$UI.msg('alert', jsonData.msg);
				}
			}
		});
	}
	function IngrClear() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(InGdRecMainGrid);
		$UI.clear(InGdRecDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			FRecLoc: gLocObj,
			FStatusBox: 'Y'
		};
		$UI.fillBlock('#FindConditions', DefaultData);
	}
	IngrClear();
	QueryIngrInfo();
};
$(init);