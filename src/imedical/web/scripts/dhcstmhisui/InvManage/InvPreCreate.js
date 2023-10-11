var InvVenId = '';
var CreateWin = function(Fn) {
	$HUI.dialog('#CreateWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();

	var CVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var CVendorBox = $HUI.combobox('#CVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + CVendorParams,
		valueField: 'RowId',
		textField: 'Description',
		onChange: function(newValue, oldValue) {
			InvVenId = newValue;
		}
	});
	var CLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#CLocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + CLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var CGRMainCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: '����',
			field: 'GRNo',
			width: 150
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 100
		}, {
			title: '����',
			field: 'Type',
			width: 70,
			saveCol: true,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '���';
				} else {
					return '�˻�';
				}
			}
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
			title: 'Vendor',
			field: 'Vendor',
			width: 100,
			saveCol: true,
			hidden: true
		}
	]];

	var CGRMainGrid = $UI.datagrid('#CGRMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRec',
			query2JsonStrict: 1
		},
		columns: CGRMainCm,
		showBar: true,
		singleSelect: false,
		checkOnSelect: true,
		onBeforeCheck: function(index, row) {
			var RowVendorId = row['Vendor'];
			if (!isEmpty(InvVenId) && !isEmpty(RowVendorId) && InvVenId != RowVendorId) {
				$UI.msg('alert', '��' + (index + 1) + '�й�Ӧ���뷢Ʊ��Ӧ�̲�һ��,���ʵ!');
				return false;
			}
		},
		onCheck: function(index, row) {
			var RowVendorId = row['Vendor'];
			var RowVendorDesc = row['VendorDesc'];
			if (isEmpty(InvVenId) && !isEmpty(RowVendorId)) {
				AddComboData($('#CVendor'), RowVendorId, RowVendorDesc);
				$('#CVendor').combobox('setValue', RowVendorId);
			}
			CSelect();
		},
		onUncheck: function(index, Row) {
			if (isEmpty($(this).datagrid('getChecked'))) {
				$('#CVendor').combobox('setValue', '');
			}
			CSelect();
		},
		onCheckAll: function(rows) {
			var RowVendorId = rows[0].Vendor;
			var RowVendorDesc = rows[0].VendorDesc;
			if (isEmpty(InvVenId) && !isEmpty(RowVendorId)) {
				AddComboData($('#CVendor'), RowVendorId, RowVendorDesc);
				$('#CVendor').combobox('setValue', RowVendorId);
			}
			var NullInfo = '', NullInfoArr = [];
			var vendor = $('#CVendor').combobox('getValue');
			for (var i = 0, Len = rows.length; i < Len; i++) {
				var RowData = rows[i];
				if (!isEmpty(RowData['Vendor']) && RowData['Vendor'] != vendor) {
					NullInfoArr.push(i + 1);
				}
				if (!isEmpty(NullInfoArr)) {
					NullInfo = NullInfoArr.join('��');
				}
			}
			if (!isEmpty(NullInfo)) {
				var MsgStr = '��' + NullInfo + '�й�Ӧ���뷢Ʊ��Ӧ�̲�ͬ';
				$UI.msg('error', MsgStr);
				return false;
			}
			CSelect();
		},
		onUncheckAll: function(rows) {
			if (isEmpty($(this).datagrid('getChecked'))) {
				$('#CVendor').combobox('setValue', '');
			}
			$UI.clear(CGRDetailGrid);
		}
	});

	var CGRDetailCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'RowId',
			field: 'RowId',
			width: 50,
			saveCol: true,
			hidden: true
		}, {
			title: 'IncId',
			field: 'IncId',
			width: 50,
			hidden: true
		}, {
			title: '����',
			field: 'Code',
			width: 120
		}, {
			title: '����',
			field: 'Description',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '����',
			field: 'Qty',
			width: 100,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '����',
			field: 'Rp',
			width: 100,
			align: 'right'
		}, {
			title: '���۽��',
			field: 'RpAmt',
			width: 100,
			saveCol: true,
			align: 'right'
		}, {
			title: '�ۼ�',
			field: 'Sp',
			width: 100,
			align: 'right'
		}, {
			title: '�ۼ۽��',
			field: 'SpAmt',
			width: 100,
			saveCol: true,
			align: 'right'
		}, {
			title: '��������',
			field: 'Manf',
			width: 100
		}, {
			title: '����',
			field: 'Type',
			align: 'center',
			saveCol: true,
			formatter: function(value, row, index) {
				if (value == 'G') {
					return '���';
				} else {
					return '�˻�';
				}
			}
		}
	]];

	var CGRDetailGrid = $UI.datagrid('#CGRDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRecItm',
			query2JsonStrict: 1
		},
		columns: CGRDetailCm,
		showBar: true,
		singleSelect: false,
		pagination: false,
		onCheck: function(index, row) {
			ComTotalAmt();
		},
		onUncheck: function(index, Row) {
			ComTotalAmt();
		},
		onCheckAll: function(rows) {
			ComTotalAmt();
		},
		onUncheckAll: function(rows) {
			ComTotalAmt();
		}
	});

	$UI.linkbutton('#CQueryBT', {
		onClick: function() {
			CQuery();
		}
	});
	function CQuery() {
		var ParamsObj = $UI.loopBlock('#CConditions');
		var StartDate = ParamsObj.StartDate;
		var EndDate = ParamsObj.EndDate;
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
		$UI.clear(CGRMainGrid);
		$UI.clear(CGRDetailGrid);
		CGRMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRec',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	$UI.linkbutton('#CSaveBT', {
		onClick: function() {
			var MainRows = CGRMainGrid.getSelections();
			if (MainRows.length <= 0) {
				$UI.msg('alert', '��ѡ��Ҫ��ϵ�����˻���!');
				return;
			}
			var DetailRows = CGRDetailGrid.getSelections();
			if (DetailRows.length <= 0) {
				$UI.confirm('δѡ����ϸ���Ƿ��յ��ݰ�?', '', '', CSave);
			} else {
				var TotalAmt = $('#CTotalRpAmt').val();
				if (TotalAmt == '' || TotalAmt == 0) {
					$UI.msg('alert', '��ϵ�����˻��������ܶ�Ϊ��!');
					return;
				}
				CSave(DetailRows);
			}
		}
	});
	function CSave(DetailRows) {
		var ParamsObj = $UI.loopBlock('#CConditions');
		var LocId = ParamsObj.LocId;
		var Vendor = ParamsObj.Vendor;
		if (isEmpty(Vendor)) {
			$UI.msg('alert', '��Ӧ�̲���Ϊ��!');
			return;
		}
		if (isEmpty(LocId)) {
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return;
		}
		var Params = JSON.stringify(addSessionParams(ParamsObj));
		if (isEmpty(DetailRows)) {
			DetailRows = CGRDetailGrid.getRows();
		}
		var TotalAmt = 0;
		for (var i = 0; i < DetailRows.length; i++) {
			var RpAmt = DetailRows[i].RpAmt;
			TotalAmt = accAdd(Number(TotalAmt), Number(RpAmt));
		}
		if (TotalAmt == '' || TotalAmt == 0) {
			$UI.msg('alert', '��ϵ�����˻��������ܶ�Ϊ��!');
			return;
		}
		var Detail = JSON.stringify(DetailRows);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			MethodName: 'jsSaveByItm',
			InvId: '',
			LocId: LocId,
			Detail: Detail,
			Params: Params
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var InvId = jsonData.rowid;
				$HUI.dialog('#CreateWin').close();
				InvVenId = '';
				Fn(InvId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#CClearBT', {
		onClick: function() {
			CClear();
		}
	});
	
	function CSelect() {
		var Rows = CGRMainGrid.getChecked();
		if (Rows.length <= 0) {
			$UI.clear(CGRDetailGrid);
			return;
		}
		var Params = CGRMainGrid.getSelectedData();
		CGRDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRecItm',
			query2JsonStrict: 1,
			Params: JSON.stringify(Params),
			rows: 9999
		});
	}
	
	function CClear() {
		$UI.clearBlock('#CConditions');
		$UI.clear(CGRMainGrid);
		$UI.clear(CGRDetailGrid);
		var LocId = $('#IngrLoc').combobox('getValue');
		var LocDesc = $('#IngrLoc').combobox('getText');
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			LocId: { RowId: LocId, Description: LocDesc }
		};
		$UI.fillBlock('#CConditions', DefaultData);
		InvVenId = '';
	}
	
	function ComTotalAmt() {
		var TotalAmt = '';
		var Rows = CGRDetailGrid.getChecked();
		for (var i = 0; i < Rows.length; i++) {
			var RpAmt = Rows[i].RpAmt;
			TotalAmt = accAdd(Number(TotalAmt), Number(RpAmt));
		}
		$('#CTotalRpAmt').val(TotalAmt);
	}
	
	CClear();
	CQuery();
};