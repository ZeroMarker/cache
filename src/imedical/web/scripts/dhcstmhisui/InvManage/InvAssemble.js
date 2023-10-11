var InvDetailWin = function(InvId, IngrLoc, VendorId, Fn) {
	$HUI.dialog('#InvDetailWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();

	var FVVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var FVVendorBox = $HUI.combobox('#FVVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + FVVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var GRMainCm = [[
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
		}
	]];

	var GRMainGrid = $UI.datagrid('#GRMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRec',
			query2JsonStrict: 1
		},
		columns: GRMainCm,
		showBar: true,
		singleSelect: false,
		onSelectChangeFn: function() {
			Select();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				GRMainGrid.selectRow(0);
				// Select();
			}
		}
	});

	var GRDetailCm = [[
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

	var GRDetailGrid = $UI.datagrid('#GRDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRecItm',
			query2JsonStrict: 1
		},
		columns: GRDetailCm,
		showBar: true,
		singleSelect: false,
		pagination: false,
		onCheck: function(index, row) {
			TotalAmt();
		},
		onUncheck: function(index, Row) {
			TotalAmt();
		},
		onCheckAll: function(rows) {
			TotalAmt();
		},
		onUncheckAll: function(rows) {
			TotalAmt();
		}
	});

	$UI.linkbutton('#FVQueryBT', {
		onClick: function() {
			FQuery();
		}
	});
	function FQuery() {
		var ParamsObj = $UI.loopBlock('#FVConditions');
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
		ParamsObj.LocId = IngrLoc;
		ParamsObj.Vendor = VendorId;
		var Params = JSON.stringify(ParamsObj);
		$UI.clear(GRMainGrid);
		$UI.clear(GRDetailGrid);
		GRMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRec',
			query2JsonStrict: 1,
			Params: Params
		});
	}

	$UI.linkbutton('#FVSaveBT', {
		onClick: function() {
			var MainRows = GRMainGrid.getSelections();
			if (MainRows.length <= 0) {
				$UI.msg('alert', '��ѡ��Ҫ��ϵ�����˻���!');
				return;
			}
			var DetailRows = GRDetailGrid.getSelections();
			if (DetailRows.length <= 0) {
				$UI.confirm('δѡ����ϸ���Ƿ��յ��ݰ�?', '', '', Save);
			} else {
				var TotalAmt = $('#TotalRpAmt').val();
				if (TotalAmt == '' || TotalAmt == 0) {
					$UI.msg('alert', '��ϵ�����˻��������ܶ�Ϊ��!');
					return;
				}
				Save(DetailRows);
			}
		}
	});
	function Save(DetailRows) {
		if (isEmpty(DetailRows)) {
			DetailRows = GRDetailGrid.getRows();
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
		var jsonData = $.cm({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			MethodName: 'SelectInvInfo',
			RowId: InvId
		}, false);
		var InvAmt = jsonData.InvAmt;
		var AlreadyAmt = jsonData.RpAmt;
		var LeftAmt = accSub(Number(InvAmt), Number(AlreadyAmt));
		if ((Number(InvAmt) > 0) && ((LeftAmt <= 0) || (TotalAmt > LeftAmt))) {
			// δά����Ʊ����,�ݲ�������
			$UI.msg('alert', '��ǰ���ѳ�����Ʊ�������ٽ��а�!');
			return;
		}
		
		var Detail = JSON.stringify(DetailRows);
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			MethodName: 'jsSaveByItm',
			InvId: InvId,
			LocId: IngrLoc,
			Detail: Detail
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				$HUI.dialog('#InvDetailWin').close();
				Fn(InvId);
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}

	$UI.linkbutton('#FVClearBT', {
		onClick: function() {
			Clear();
		}
	});
	
	function Select() {
		var Rows = GRMainGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.clear(GRDetailGrid);
			return;
		}
		GRDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCVendorInv',
			QueryName: 'GetIngdRecItm',
			query2JsonStrict: 1,
			Params: JSON.stringify(Rows),
			rows: 9999
		});
	}
	
	function Clear() {
		$UI.clearBlock('#FVConditions');
		$UI.clear(GRMainGrid);
		$UI.clear(GRDetailGrid);
		var DefaultData = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate()
		};
		$UI.fillBlock('#FVConditions', DefaultData);
	}
	
	function TotalAmt() {
		var TotalAmt = '';
		var Rows = GRDetailGrid.getChecked();
		for (var i = 0; i < Rows.length; i++) {
			var RpAmt = Rows[i].RpAmt;
			TotalAmt = accAdd(Number(TotalAmt), Number(RpAmt));
		}
		$('#TotalRpAmt').val(TotalAmt);
	}
	
	Clear();
	FQuery();
};