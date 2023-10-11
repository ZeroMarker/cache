var init = function() {
	var Params = JSON.stringify(addSessionParams());
	$HUI.combobox('#WardLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetWardLoc&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var HandlerParams = function() {
		var Obj = { StkGrpRowId: '', StkGrpType: 'M', Locdr: gLocId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
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
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(DispMainGrid);
		$UI.clear(DispColGrid);
		$UI.clear(DispDetailGrid);
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
		var Pid = tkMakeServerCall('web.DHCSTMHUI.DHCInMatDisp', 'GetInMatDispPid', Params);
		
		ParamsObj.Pid = Pid;
		var MainParam = JSON.stringify(ParamsObj);
		
		DispMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDisp',
			query2JsonStrict: 1,
			Params: MainParam
		});
	}
	
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(DispDetailGrid);
		$UI.clear(DispColGrid);
		$UI.clear(DispMainGrid);
		Default();
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	
	$UI.linkbutton('#AlQueryBT', {
		onClick: function() {
			FindWin();
		}
	});
	
	$UI.linkbutton('#DispBT', {
		onClick: function() {
			var DispFlag = $HUI.checkbox('#DispFlag').getValue();
			if (DispFlag == true) {
				$UI.msg('alert', '�ѷ��ţ�');
				return;
			}
			var RowsData = DispMainGrid.getSelections();
			if (RowsData.length == 0) {
				$UI.msg('alert', '��ѡ��Ҫ���ŵĲ�����');
				return;
			}
			var WardLocIdStr = '', Pid = '';
			for (var i = 0; i < RowsData.length; i++) {
				var Pid = RowsData[i].Pid;
				var WardLocId = RowsData[i].WardLocId;
				if (WardLocIdStr == '') { WardLocIdStr = WardLocId; } else { WardLocIdStr = WardLocIdStr + ',' + WardLocId; }
			}
			if (isEmpty(Pid) || isEmpty(WardLocIdStr)) {
				$UI.msg('alert', '��ѡ����Ч�Ĳ������з��ţ�');
				return;
			}
			var Params = JSON.stringify(addSessionParams({
				Pid: Pid,
				WardLocIdStr: WardLocIdStr
			}));

			var DetailRowsData = DispDetailGrid.getSelectedData();
			if (DetailRowsData.length == 0) {
				$UI.msg('alert', '��ѡ������Ų�����Ϣ��');
				return false;
			}
			var Detail = JSON.stringify(DetailRowsData);
			
			showMask();
			$.cm({
				ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
				MethodName: 'jsInMatDisp',
				Main: Params,
				Detail: Detail
			}, function(jsonData) {
				hideMask();
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					var DispIdStr = jsonData.rowid.split(',');
					for (var i = 0; i < DispIdStr.length; i++) {
						var DispId = DispIdStr[i];
						PrintDisp(DispId);
					}
					$('#PatNo').val('');
					Query();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	
	/* --Grid--*/
	// /�����б�
	var DispMainGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'Pid',
			field: 'Pid',
			hidden: true,
			width: 60
		}, {
			title: '����',
			field: 'WardLocId',
			width: 80,
			hidden: true
		}, {
			title: '����',
			field: 'WardLocDesc',
			width: 150
		}
	]];

	var DispMainGrid = $UI.datagrid('#DispMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDisp',
			query2JsonStrict: 1
		},
		showBar: true,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		columns: DispMainGridCm,
		fitColumns: true,
		displayMsg: '',
		onClickRow: function(index, row) {
			DispMainGrid.commonClickRow(index, row);
		},
		onSelectChangeFn: function() {
			$UI.clear(DispColGrid);
			$UI.clear(DispDetailGrid);
			var RowsData = DispMainGrid.getSelections();
			var WardLocIdStr = '', Pid = '';
			for (var i = 0; i < RowsData.length; i++) {
				var Pid = RowsData[i].Pid;
				var WardLocId = RowsData[i].WardLocId;
				if (WardLocIdStr == '') { WardLocIdStr = WardLocId; } else { WardLocIdStr = WardLocIdStr + ',' + WardLocId; }
			}
			if (isEmpty(Pid) || isEmpty(WardLocIdStr)) {
				return;
			}

			var Params = JSON.stringify(addSessionParams({}));
			DispColGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
				QueryName: 'QueryInMatDispCol',
				query2JsonStrict: 1,
				Pid: Pid,
				WardLocIdStr: WardLocIdStr,
				Params: Params,
				rows: 99999
			});
			DispDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
				QueryName: 'QueryInMatDispDetail',
				query2JsonStrict: 1,
				Pid: Pid,
				WardLocIdStr: WardLocIdStr,
				Params: Params,
				rows: 99999
			});
		},
		onLoadSuccess: function(data) {
			/* if(data.rows.length > 0){
				DispMainGrid.selectRow(0);
			}*/
		}
	});
	// /��ϸ����
	var DispColGridCm = [[
		{
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
			title: '����/����',
			field: 'QtyBedStr',
			width: 150,
			align: 'left'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 60
		}, {
			title: '����',
			field: 'Sp',
			width: 80,
			align: 'right'
		}, {
			title: '���',
			field: 'ColSpAmt',
			width: 80,
			align: 'right'
		}, {
			title: '��λ',
			field: 'StkBin',
			width: 100
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '���ÿ��',
			field: 'AvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomId',
			width: 80,
			hidden: true
		}, {
			title: '����',
			field: 'SumQtyTotal',
			width: 80,
			align: 'right'
		}
	]];

	var DispColGrid = $UI.datagrid('#DispColGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDispCol',
			query2JsonStrict: 1,
			rows: 99999
		},
		singleSelect: false,
		showBar: true,
		columns: DispColGridCm,
		pagination: false,
		onClickRow: function(index, row) {
			DispColGrid.commonClickRow(index, row);
		}
	});
	// /�����б���ϸ
	var DispDetailGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'DspId',
			field: 'DspId',
			saveCol: true,
			width: 60,
			hidden: true
		}, {
			title: '����',
			field: 'AdmLocId',
			width: 60,
			hidden: true
		}, {
			title: '����',
			field: 'AdmLocDesc',
			width: 150
		}, {
			title: '����',
			field: 'BedNo',
			saveCol: true,
			width: 60
		}, {
			title: '����',
			field: 'PatName',
			width: 60
		}, {
			title: '�ǼǺ�',
			field: 'PatNo',
			width: 100
		}, {
			title: 'ҽ����ϸid',
			field: 'Oeori',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: '�����id',
			field: 'InciId',
			saveCol: true,
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
			title: '����',
			field: 'Qty',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomDesc',
			width: 80
		}, {
			title: '����',
			field: 'Sp',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: '���',
			field: 'SpAmt',
			saveCol: true,
			width: 80,
			align: 'right'
		}, {
			title: 'ҽ��״̬',
			field: 'OeoriFlag',
			width: 80,
			hidden: true
		}, {
			title: '��λ',
			field: 'StkBin',
			width: 100
		}, {
			title: '��������',
			field: 'ManfDesc',
			width: 100
		}, {
			title: '���ÿ��',
			field: 'AvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '��λ',
			field: 'UomId',
			saveCol: true,
			width: 80,
			hidden: true
		}, {
			title: 'ʹ������',
			field: 'DoseDate',
			saveCol: true,
			width: 100
		}, {
			title: '�ַ�ʱ��',
			field: 'DoseTime',
			width: 80
		}, {
			title: '����',
			field: 'PatAge',
			width: 100
		}, {
			title: '�Ա�',
			field: 'PatSex',
			width: 100
		}, {
			title: '���',
			field: 'DiagDesc',
			width: 100
		}, {
			title: '���ȼ�',
			field: 'PriorityDesc',
			width: 100
		}, {
			title: 'WardLocId',
			field: 'WardLocId',
			saveCol: true,
			width: 60,
			hidden: true
		}, {
			title: 'AdmId',
			field: 'AdmId',
			saveCol: true,
			width: 60,
			hidden: true
		}
	]];

	var DispDetailGrid = $UI.datagrid('#DispDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCInMatDisp',
			QueryName: 'QueryInMatDispDetail',
			query2JsonStrict: 1,
			rows: 99999
		},
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		showBar: true,
		columns: DispDetailGridCm,
		pagination: false,
		onClickRow: function(index, row) {
			DispDetailGrid.commonClickRow(index, row);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				// Ĭ��ȫѡ
				$('#DispDetailGrid').datagrid('selectAll');
			}
		}
	});
	
	/* --���ó�ʼֵ--*/
	var Default = function() {
		var StartDate = DateAdd(new Date(), 'd', -5);
		var EndDate = DateAdd(new Date(), 'd', 3);
		// /���ó�ʼֵ ����ʹ������
		var DefaultValue = {
			StartDate: DateFormatter(StartDate),
			EndDate: DateFormatter(EndDate)
		};
		$UI.fillBlock('#MainConditions', DefaultValue);
	};
	Default();
	Query();
};
$(init);

function PrintDisp(DispId) {
	if (isEmpty(DispId)) {
		return;
	}
	var RaqName = 'DHCSTM_HUI_InItmDispCol.raq';
	var fileName = '{' + RaqName + '(Parref=' + DispId + ')}';
	DHCCPM_RQDirectPrint(fileName);
	Common_PrintLog('DP', DispId, '');
}