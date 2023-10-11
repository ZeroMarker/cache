var init = function() {
	$HUI.combobox('#CardType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCardType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onLoadSuccess: function() { // ���ݼ�������¼�
			var data = $('#CardType').combobox('getData');
			var Default = '';
			if (data.length > 0) {
				for (i = 0; i <= data.length; i++) {
					Default = data[i].Default;
					if (Default == 'Y') {
						$('#CardType').combobox('select', data[i].RowId);
						return;
					}
				}
			}
		},
		onSelect: function(record) {
			
		}
	});
	
	$('#PatNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var PatNo = $(this).val();
			if (isEmpty(PatNo)) {
				$UI.msg('alert', '������ǼǺ�!');
				return false;
			}
			try {
				var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PatNo);
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				$('#PatNo').val(newPaAdmNo);
			} catch (e) {}
		}
	});
	
	$('#CardNo').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var CardType = $('#CardType').combobox('getValue');
			BtnReadCardHandler(CardType, 'CardNo', 'PatNo');
		}
	});
	
	$UI.linkbutton('#ReadCardBT', {
		onClick: function() {
			var CardType = $('#CardType').combobox('getValue');
			BtnReadCardHandler(CardType, 'CardNo', 'PatNo');
		}
	});
	
	$UI.linkbutton('#AlQueryBT', {
		onClick: function() {
			FindRetWin();
		}
	});
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(ReturnMainGrid);
		$UI.clear(ReturnDetailGrid);
		var ParamsObj = $UI.loopBlock('#MainConditions');
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
		ReturnMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCMatReturn',
			QueryName: 'QueryMatReturn',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(ReturnDetailGrid);
		$UI.clear(ReturnMainGrid);
		Default();
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	
	$UI.linkbutton('#ReturnBT', {
		onClick: function() {
			if (CheckBeforeReturn()) {
				Return();
			}
		}
	});
	
	function CheckBeforeReturn() {
		if (!ReturnDetailGrid.endEditing()) {
			return false;
		}
		var DetailRowsData = ReturnDetailGrid.getRows();
		if (DetailRowsData.length == 0) {
			$UI.msg('alert', '��ѡ��Ҫ�˻ص���ϸ��');
			return false;
		}
		var count = 0;
		for (var i = 0; i < DetailRowsData.length; i++) {
			var Qty = Number(DetailRowsData[i].Qty);
			var LeftQty = Number(DetailRowsData[i].LeftQty);
			var ReqQty = Number(DetailRowsData[i].ReqQty);
			var ReqFalg = DetailRowsData[i].ReqFalg;
			if (!isEmpty(Qty) && (Qty != 0)) {
				if (Qty < 0) {
					$UI.msg('alert', '�˻���������С��0');
					return false;
				}
				if (Qty > LeftQty) {
					$UI.msg('alert', '�˻��������ܳ������˻�����');
					return false;
				}
				if ((ReqFalg == 'Y') && (Qty > ReqQty)) {
					$UI.msg('alert', '�˻��������ܳ��������˻�����');
					return false;
				}
				count = count + 1;
			}
		}
		if (count == 0) {
			$UI.msg('alert', 'û����Ҫ�˻ص���ϸ');
			return false;
		}
		return true;
	}
	
	function Return() {
		var DetailRowsData = ReturnDetailGrid.getRows();
		var Main = JSON.stringify(sessionObj);
		var Detail = JSON.stringify(DetailRowsData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCMatReturn',
			MethodName: 'jsMatReturn',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	/* --Grid--*/
	// /�˻��б�
	var ReturnMainGridCm = [[
		{
			title: 'DispId',
			field: 'DispId',
			width: 60,
			hidden: true
		}, {
			title: '����id',
			field: 'PatId',
			width: 80,
			hidden: true
		}, {
			title: '����',
			field: 'PatName',
			width: 80
		}, {
			title: '�ǼǺ�',
			field: 'PatNo',
			width: 100
		}, {
			title: '������',
			field: 'ReqUserName',
			width: 100
		}, {
			title: '��������',
			field: 'ReqDate',
			width: 100
		}, {
			title: '����ʱ��',
			field: 'ReqTime',
			width: 100
		}
	]];

	var ReturnMainGrid = $UI.datagrid('#ReturnMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatReturn',
			QueryName: 'QueryMatReturn',
			query2JsonStrict: 1
		},
		showBar: true,
		singleSelect: true,
		columns: ReturnMainGridCm,
		onClickRow: function(index, row) {
			ReturnMainGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			var Params = JSON.stringify(addSessionParams({ DispId: row.DispId }));
			ReturnDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCMatReturn',
				QueryName: 'QueryMatReturnDetail',
				query2JsonStrict: 1,
				Params: Params,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				ReturnMainGrid.selectRow(0);
			}
		}
	});
	
	// /�����б���ϸ
	var ReturnDetailGridCm = [[
		{
			title: 'DispDetailId',
			field: 'DispDetailId',
			width: 60,
			hidden: true
		}, {
			title: '����id',
			field: 'Adm',
			width: 80,
			hidden: true
		}, {
			title: 'ҽ����ϸid',
			field: 'Oeori',
			width: 80,
			hidden: true
		}, {
			title: '�����id',
			field: 'InciId',
			width: 100,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 100
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '����',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '�˻�����',
			field: 'Qty',
			width: 100,
			align: 'right',
			necessary: true,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtQTY')
				}
			}
		}, {
			title: '���˻�����',
			field: 'LeftQty',
			width: 100,
			align: 'right'
		}, {
			title: '�����˻�����',
			field: 'ReqQty',
			width: 100,
			align: 'right'
		}, {
			title: '���˻ؽ��',
			field: 'LeftSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '�����˻ؽ��',
			field: 'ReqSpAmt',
			width: 100,
			align: 'right'
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: '��λ',
			field: 'UomId',
			width: 100,
			hidden: true
		}, {
			title: '��ֵ����',
			field: 'Barcode',
			width: 100
		}, {
			title: '�˷������־',
			field: 'ReqFalg',
			width: 100
		}
	]];

	var ReturnDetailGrid = $UI.datagrid('#ReturnDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatReturn',
			QueryName: 'QueryMatReturnDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		showBar: true,
		columns: ReturnDetailGridCm,
		pagination: false,
		onClickRow: function(index, row) {
			ReturnDetailGrid.commonClickRow(index, row);
		},
		onEndEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('Qty')) {
				var Qty = row.Qty;
				if (!isEmpty(Qty)) {
					if (Qty < 0) {
						$UI.msg('alert', '�˻���������С��0!');
						return false;
					}
				}
			}
		}
	});
	
	/* --���ó�ʼֵ--*/
	var Default = function() {
		// /���ó�ʼֵ ����ʹ������
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	};
	Default();
	Query();
};
$(init);
	