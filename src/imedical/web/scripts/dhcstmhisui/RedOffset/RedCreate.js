function Create(Fn) {
	$HUI.dialog('#CreateWin', {
		width: gWinWidth,
		height: gWinHeight
	}).open();

	// ������
	var CRecLocParams = JSON.stringify(addSessionParams({
		Type: 'Login',
		Element: 'CRecLoc'
	}));
	var CRecLocBox = $HUI.combobox('#CRecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + CRecLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				CVendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				CVendorBox.reload(url);
			}
		}
	});
	// ��Ӧ��
	var CVendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var CVendorBox = $HUI.combobox('#CVendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + CVendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Obj = { StkGrpType: 'M' };
		return Obj;
	};
	$('#CInciDesc').lookup(InciLookUpOp(HandlerParams, '#CInciDesc', '#CInci'));
	$UI.linkbutton('#CQueryBT', {
		onClick: function() {
			QueryRecMain();
		}
	});
	
	function QueryRecMain() {
		$UI.clear(RecMainGrid);
		$UI.clear(RecDetailGrid);
		var ParamsObj = $UI.loopBlock('#CreateConditions');
		if (isEmpty(ParamsObj.RecLoc)) {
			$UI.msg('alert', '�����Ҳ���Ϊ��!');
			return;
		}
		if (isEmpty(ParamsObj.Vendor)) {
			$UI.msg('alert', '��Ӧ�̲���Ϊ��!');
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
		var Params = JSON.stringify(ParamsObj);
		RecMainGrid.load({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'GetRecMain',
			query2JsonStrict: 1,
			Params: Params
		});
		$('#RecLocId').val(ParamsObj.RecLoc);
		$('#VendorId').val(ParamsObj.Vendor);
	}
	$UI.linkbutton('#CClearBT', {
		onClick: function() {
			CClear();
		}
	});
	var CClear = function() {
		$UI.clearBlock('#CreateConditions');
		$UI.clear(RecMainGrid);
		$UI.clear(RecDetailGrid);
		$UI.clear(InitDetailGrid);
		// /���ó�ʼֵ ����ʹ������
		var LocId = $('#RedLoc').combobox('getValue');
		var LocDesc = $('#RedLoc').combobox('getText');
		var Dafult = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			RecLoc: { RowId: LocId, Description: LocDesc }
		};
		$UI.fillBlock('#CreateConditions', Dafult);
	};
	function CheckDataBeforeSave() {
		if (!InitDetailGrid.endEditing()) {
			return false;
		}
		var RowsData = InitDetailGrid.getRows();
		if (RowsData.length <= 0) {
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return false;
		}
		for (var i = 0; i < RowsData.length; i++) {
			var row = i + 1;
			var NewRp = RowsData[i].NewRp;
			var Qty = RowsData[i].Qty;
			var InclbAvaQty = RowsData[i].InclbAvaQty;
			var Incidesc = RowsData[i].InciDesc;
			if (isEmpty(NewRp)) {
				$UI.msg('alert', '��' + row + '��' + Incidesc + '�½��۲���Ϊ��!');
				return false;
			}
			if (NewRp < 0) {
				$UI.msg('alert', '��' + row + '��' + Incidesc + '���۲���С����!');
				return false;
			}
			if (isEmpty(Qty)) {
				$UI.msg('alert', '��' + row + '��' + Incidesc + '�����������Ϊ��!');
				return false;
			}
			if ((Number(Qty) > Number(InclbAvaQty))) {
				$UI.msg('alert', '��' + row + '��' + Incidesc + '����������ܴ��ڿ������!');
				return false;
			}
		}
		return true;
	}
	function SaveRedInfo() {
		var InitDetailObj = InitDetailGrid.getRows();
		if (InitDetailObj === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		var ParamsObj = $UI.loopBlock('#CreateConditions');
		var RecMainData = JSON.stringify(addSessionParams(ParamsObj));
		var DetailData = JSON.stringify(InitDetailObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			MethodName: 'jsCreate',
			RecMainData: RecMainData,
			DetailData: DetailData
		}, function(jsonData) {
			hideMask();
			$UI.msg('success', jsonData.msg);
			if (jsonData.success == 0) {
				var RedRowid = jsonData.rowid;
				$HUI.dialog('#CreateWin').close();
				Fn(RedRowid);
			}
		});
	}
	$UI.linkbutton('#CSaveBT', {
		onClick: function() {
			if (CheckDataBeforeSave() == true) {
				SaveRedInfo();
			}
		}
	});
	var RecMainCm = [[
		{
			field: 'check',
			checkbox: true
		}, {
			title: 'IngrId',
			field: 'IngrId',
			width: 50,
			hidden: true
		}, {
			title: '��ⵥ��',
			field: 'IngrNo',
			width: 150
		}, {
			title: '��Ӧ��',
			field: 'VendorId',
			width: 150,
			hidden: true
		}, {
			title: '��Ӧ��',
			field: 'VendorDesc',
			width: 150
		}, {
			title: '������',
			field: 'RecLocId',
			width: 100,
			hidden: true
		}, {
			title: '������',
			field: 'RecLocDesc',
			width: 100
		}, {
			title: '�Ƶ�����',
			field: 'CreateDate',
			width: 100
		}, {
			title: '�������',
			field: 'AuditDate',
			width: 100
		}
	]];
	var RecMainGrid = $UI.datagrid('#RecMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'GetRecMain',
			query2JsonStrict: 1
		},
		singleSelect: false,
		checkOnSelect: true,
		columns: RecMainCm,
		pagination: false,
		onCheck: function(index, row) {
			SelectRecDetail();
		},
		onUncheck: function(index, Row) {
			SelectRecDetail();
		},
		onCheckAll: function(rows) {
			SelectRecDetail();
		},
		onUncheckAll: function(rows) {
			$UI.clear(RecDetailGrid);
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var RecDetailCm = [[
		{
			field: 'check',
			checkbox: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 50,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 150
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '��λ',
			field: 'IngrUomDesc',
			width: 100
		}, {
			title: '����',
			field: 'Rp',
			width: 100
		}, {
			title: '���',
			field: 'Spec',
			width: 100
		}, {
			title: '�ͺ�',
			field: 'Model',
			width: 100
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '����',
			field: 'BatNo',
			width: 100
		}, {
			title: 'Ч��',
			field: 'ExpDate',
			width: 100
		}, {
			title: '����',
			field: 'IngrQty',
			width: 100
		}
	]];
	var RecDetailGrid = $UI.datagrid('#RecDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'GetRecDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		singleSelect: false,
		columns: RecDetailCm,
		idField: 'Ingri',
		remoteSort: false,
		pagination: false,
		onClickRow: function(index, row) {
			RecDetailGrid.commonClickRow(index, row);
		},
		onCheck: function(index, row) {
			SelectInitDetail();
		},
		onUncheck: function(index, Row) {
			SelectInitDetail();
		},
		onCheckAll: function(rows) {
			SelectInitDetail();
		},
		onUncheckAll: function(rows) {
			$UI.clear(InitDetailGrid);
		},
		onLoadSuccess: function(data) {
			if ((data.rows.length > 0) && (CommParObj.IfSelFirstRow == 'Y')) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	var InitDetailCm = [[
		{
			title: 'Inclb',
			field: 'Inclb',
			width: 100,
			hidden: true
		}, {
			title: 'ToInclb',
			field: 'ToInclb',
			width: 100,
			hidden: true
		}, {
			title: '����',
			field: 'LocDesc',
			width: 150
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 150
		}, {
			title: '��λ',
			field: 'UomId',
			width: 50,
			hidden: true
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 100
		}, {
			title: '�������',
			field: 'InclbAvaQty',
			width: 100
		}, {
			title: '�������',
			field: 'Qty',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					min: 0
				}
			}
		}, {
			title: '�½���',
			field: 'NewRp',
			width: 100,
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '���ۼ�',
			field: 'NewSp',
			width: 100
		}, {
			title: 'ԭ����',
			field: 'OldRp',
			width: 100
		}, {
			title: 'ԭ�ۼ�',
			field: 'OldSp',
			width: 100
		}, {
			title: '�ⷿ��־',
			field: 'StoreFlag',
			width: 80,
			hidden: true
		}, {
			title: 'Ingri',
			field: 'Ingri',
			width: 80,
			hidden: true
		}, {
			title: 'Inci',
			field: 'Inci',
			width: 80,
			hidden: true
		}
	]];
	var InitDetailGrid = $UI.datagrid('#InitDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'GetInitDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		singleSelect: false,
		columns: InitDetailCm,
		remoteSort: false,
		pagination: false,
		onClickRow: function(index, row) {
			InitDetailGrid.commonClickRow(index, row);
		},
		onEndEdit: function(index, row, changes) {
			if (changes.hasOwnProperty('NewRp')) {
				if (NewRp < 0) {
					$UI.msg('alert', '���۲���С����!');
					InitDetailGrid.checked = false;
					return false;
				} else if (NewRp == 0) {
					$UI.msg('alert', '����Ϊ��,��ע���ʵ!');
				}
			}
			var Inci = row.Inci;
			var UomId = row.UomId;
			var NewRp = row.NewRp;
			var Sp = tkMakeServerCall('web.DHCSTMHUI.DHCINGdRec', 'GetSpForRec', Inci, UomId, NewRp, SessionParams);
			row.NewSp = Sp;
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				if (Editor.field == 'NewRp') {
					var NewRp = row.NewRp;
					var Inclb = row.Inclb;
					if (!isEmpty(NewRp)) {
						CopyPriceInfo(Inclb, NewRp, Sp);
					}
				}
			}
		}
	});
	function SelectRecDetail() {
		var Rows = RecMainGrid.getChecked();
		if (Rows.length <= 0) {
			$UI.clear(RecDetailGrid);
			return;
		}
		var Sels = RecMainGrid.getSelectedData();
		var MainIdStr = '';
		for (var i = 0, Len = Sels.length; i < Len; i++) {
			var Ingr = Sels[i]['IngrId'];
			if (MainIdStr == '') {
				MainIdStr = Ingr;
			} else {
				MainIdStr = MainIdStr + '^' + Ingr;
			}
		}
		if (isEmpty(MainIdStr)) {
			return;
		}
		RecDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'GetRecDetail',
			query2JsonStrict: 1,
			MainIdStr: MainIdStr,
			rows: 99999
		});
	}
	function SelectInitDetail() {
		var Rows = RecDetailGrid.getChecked();
		if (Rows.length <= 0) {
			$UI.clear(InitDetailGrid);
			return;
		}
		var Sels = RecDetailGrid.getSelectedData();
		var IngriStr = '';
		for (var i = 0, Len = Sels.length; i < Len; i++) {
			var Ingri = Sels[i]['Ingri'];
			if (IngriStr == '') {
				IngriStr = Ingri;
			} else {
				IngriStr = IngriStr + '^' + Ingri;
			}
		}
		if (isEmpty(IngriStr)) {
			return;
		}
		InitDetailGrid.load({
			ClassName: 'web.DHCSTMHUI.RedOffset',
			QueryName: 'GetInitDetail',
			query2JsonStrict: 1,
			IngriStr: IngriStr,
			rows: 99999
		});
	}
	function CopyPriceInfo(Inclb, Rp, Sp) {
		var Rows = InitDetailGrid.getRows();
		for (var i = 1; i < Rows.length; i++) {
			var RInclb = Rows[i].Inclb;
			if (RInclb == Inclb) {
				Rows[i].NewRp = Rp;
				Rows[i].NewSp = Sp;
				var RowIndex = $('#InitDetailGrid').datagrid('getRowIndex', Rows[i]);
				$('#InitDetailGrid').datagrid('refreshRow', RowIndex);
			}
		}
	}
	CClear();
}