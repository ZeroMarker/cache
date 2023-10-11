var NeedDispGrid = '';
var init = function() {
	var LocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	$HUI.combobox('#AdmLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#CardType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCardType&ResultSetType=array&Params=' + LocParams,
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
	
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(NeedDispGrid);
		$UI.clear(DispMainGrid);
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
		NeedDispGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			QueryName: 'QueryNeedDisp',
			query2JsonStrict: 1,
			Params: Params
		});
		DispMainGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			QueryName: 'QueryMatDisp',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	function DefaultClear() {
		$UI.clearBlock('#MainConditions');
		$UI.clear(DispDetailGrid);
		$UI.clear(DispMainGrid);
		Default();
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			DefaultClear();
		}
	});
	
	$UI.linkbutton('#PrintBT', {
		onClick: function() {
			var DispFlag = $HUI.checkbox('#DispFlag').getValue();
			var RowsData = DispMainGrid.getSelections();
			if (RowsData.length == 0) {
				$UI.msg('alert', '��ѡ������ž�����Ϣ��');
				return false;
			}
			for (var i = 0; i < RowsData.length; i++) {
				var Adm = RowsData[i].Adm;
				var PrtId = RowsData[i].PrtId;
				var DispId = RowsData[i].DispId;
				var AdmStr = Adm + '^' + PrtId + '^' + DispFlag;
				if (!isEmpty(DispId)) {
					AdmStr = '';
				}
				PrintDisp(gLocId, gUserId, DispId, AdmStr);
			}
		}
	});
	
	$UI.linkbutton('#DispBT', {
		onClick: function() {
			if (CheckBeforeDisp()) {
				Distribute();
			}
		}
	});
	
	function CheckBeforeDisp() {
		if (!DispDetailGrid.endEditing()) {
			return false;
		}
		var DispFlag = $HUI.checkbox('#DispFlag').getValue();
		if (DispFlag == true) {
			$UI.msg('alert', '�ѷ��ţ�');
			return false;
		}
		var RowsData = DispMainGrid.getSelections();
		if (RowsData.length == 0) {
			$UI.msg('alert', '��ѡ������ž�����Ϣ��');
			return false;
		}
		var DetailRowsData = DispDetailGrid.getSelections();
		if (DetailRowsData.length == 0) {
			$UI.msg('alert', '��ѡ������Ų�����Ϣ��');
			return false;
		}
		for (var i = 0; i < DetailRowsData.length; i++) {
			var DispFlag = DetailRowsData[i].DispFlag;
			var InciDesc = DetailRowsData[i].InciDesc;
			if (DispFlag == 1) {
				$UI.msg('alert', InciDesc + '�Ѿ�����!');
				return false;
			}
			var HvFlag = DetailRowsData[i].HvFlag;
			if (HvFlag == 'Y') {
				var Barcode = DetailRowsData[i].Barcode;
				var CheckBarcode = DetailRowsData[i].CheckBarcode;
				if (isEmpty(CheckBarcode)) {
					$UI.msg('alert', Barcode + '��ɨ���Ӧ��ֵ����!');
					return false;
				} else if (CheckBarcode != Barcode) {
					$UI.msg('alert', Barcode + '��ֵ���벻ƥ��!');
					return false;
				}
			}
		}
		return true;
	}
	
	function Distribute() {
		var DetailRowsData = DispDetailGrid.getSelections();
		var Main = JSON.stringify(sessionObj);
		var Detail = JSON.stringify(DetailRowsData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			MethodName: 'jsMatDisp',
			Main: Main,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				var rowidStr = jsonData.rowid.toString();
				var DispIdStr = rowidStr.split(',');
				for (var i = 0; i < DispIdStr.length; i++) {
					var DispId = DispIdStr[i];
					PrintDisp(gLocId, gUserId, DispId, '');
				}
				$('#PatNo').val('');
				$('#CardNo').val('');
				$('#PatNo').focus();
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	/* --Grid--*/
	// /�����б�
	var DispMainGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'Adm',
			field: 'Adm',
			width: 60,
			hidden: true
		}, {
			title: 'DispId',
			field: 'DispId',
			width: 60,
			hidden: true
		}, {
			title: '����״̬',
			field: 'DispFlag',
			width: 80,
			formatter: DispFlagFormatter
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
			title: '�վ�Id',
			field: 'PrtId',
			width: 100,
			hidden: true
		}, {
			title: '�վݺ�',
			field: 'PrtCode',
			width: 100
		}, {
			title: '�շ�����',
			field: 'PrtDate',
			width: 80
		}, {
			title: '�շ�ʱ��',
			field: 'PrtTime',
			width: 80
		}, {
			title: '�շѽ��',
			field: 'PrtAmt',
			width: 80,
			align: 'right',
			hidden: true
		}, {
			title: '�Ա�',
			field: 'PatSex',
			width: 50
		}, {
			title: '����',
			field: 'PatOld',
			width: 50
		}, {
			title: '�绰',
			field: 'PatTel',
			width: 100
		}, {
			title: '����',
			field: 'PatLoc',
			width: 100
		}, {
			title: '��������',
			field: 'DspDate',
			width: 100
		}
	]];

	var DispMainGrid = $UI.datagrid('#DispMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			QueryName: 'QueryMatDisp',
			query2JsonStrict: 1
		},
		showBar: true,
		selectOnCheck: true,
		checkOnSelect: true,
		singleSelect: false,
		columns: DispMainGridCm,
		onCheck: function(index, row) {
			$UI.clear(DispDetailGrid);
			var Rows = DispMainGrid.getSelectedData();
			if (!isEmpty(Rows)) {
				var tmpPatId = '';
				for (var i = 0; i < Rows.length; i++) {
					var PatId = Rows[i].PatId;
					if ((tmpPatId != '') && (tmpPatId != PatId)) {
						$UI.msg('alert', '��ѡ��ͬһ�����˽��з���!');
						return;
					}
					if (tmpPatId == '') { tmpPatId = PatId; }
				}
				var Params = JSON.stringify(Rows);
				var MainObj = $UI.loopBlock('MainConditions');
				var Others = JSON.stringify(jQuery.extend(true, MainObj, sessionObj));
				DispDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCMatDisp',
					QueryName: 'QueryMatDispDetail',
					query2JsonStrict: 1,
					Params: Params,
					Others: Others,
					rows: 99999
				});
			}
		},
		onUncheck: function(index, Row) {
			$UI.clear(DispDetailGrid);
			var Rows = DispMainGrid.getSelectedData();
			if (!isEmpty(Rows)) {
				var Params = JSON.stringify(Rows);
				var MainObj = $UI.loopBlock('MainConditions');
				var Others = JSON.stringify(jQuery.extend(true, MainObj, sessionObj));
				DispDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCMatDisp',
					QueryName: 'QueryMatDispDetail',
					query2JsonStrict: 1,
					Params: Params,
					Others: Others,
					rows: 99999
				});
			}
		},
		onCheckAll: function(rows) {
			$UI.clear(DispDetailGrid);
			var Rows = DispMainGrid.getSelectedData();
			if (!isEmpty(Rows)) {
				var tmpPatId = '';
				for (var i = 0; i < Rows.length; i++) {
					var PatId = Rows[i].PatId;
					if ((tmpPatId != '') && (tmpPatId != PatId)) {
						$UI.msg('alert', '��ѡ��ͬһ�����˽��з���!');
						return;
					}
					if (tmpPatId == '') { tmpPatId = PatId; }
				}
				var Params = JSON.stringify(Rows);
				var MainObj = $UI.loopBlock('MainConditions');
				var Others = JSON.stringify(jQuery.extend(true, MainObj, sessionObj));
				DispDetailGrid.load({
					ClassName: 'web.DHCSTMHUI.DHCMatDisp',
					QueryName: 'QueryMatDispDetail',
					query2JsonStrict: 1,
					Params: Params,
					Others: Others,
					rows: 99999
				});
			}
		},
		onUncheckAll: function(rows) {
			$UI.clear(DispDetailGrid);
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				DispMainGrid.selectRow(0);
			}
		}
	});
	
	// /�����б���ϸ
	var DispDetailGridCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'Adm',
			field: 'Adm',
			width: 60,
			hidden: true
		}, {
			title: 'DispItmId',
			field: 'DispItmId',
			width: 60,
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
			title: '����',
			field: 'Qty',
			width: 80,
			align: 'right'
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
			title: '���',
			field: 'SpAmt',
			width: 80,
			align: 'right'
		}, {
			title: 'ҽ��״̬',
			field: 'OeoriFlag',
			width: 80,
			hidden: true
		}, {
			title: 'ҽʦ',
			field: 'OrdUserName',
			width: 80,
			hidden: true
		}, {
			title: '��λ',
			field: 'StkBin',
			width: 100
		}, {
			title: '��������',
			field: 'Manf',
			width: 100
		}, {
			title: '���ÿ��',
			field: 'AvaQty',
			width: 80,
			align: 'right'
		}, {
			title: '����״̬',
			field: 'DispFlag',
			width: 80,
			hidden: true
		}, {
			title: '��ֵ��־',
			field: 'HvFlag',
			width: 80
		}, {
			title: '��ֵ����',
			field: 'Barcode',
			width: 200
		}, {
			title: 'ɨ������',
			field: 'CheckBarcode',
			width: 200,
			editor: {
				type: 'validatebox',
				options: {
					
				}
			}
		}, {
			title: 'ҽ��״̬',
			field: 'OeoriFlag',
			width: 80,
			hidden: true
		}, {
			title: '��λ',
			field: 'UomId',
			width: 80,
			hidden: true
		}
	]];

	var DispDetailGrid = $UI.datagrid('#DispDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			QueryName: 'QueryMatDispDetail',
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
		onBeforeCellEdit: function(index, field) {
			var row = $(this).datagrid('getRows')[index];
			var HvFlag = row.HvFlag;
			var Barcode = row.Barcode;
			if (field == 'CheckBarcode') {
				if ((HvFlag != 'Y') || (isEmpty(Barcode))) {
					return false;
				}
			}
		},
		onBeginEdit: function(index, row) {
			var ed = $('#DispDetailGrid').datagrid('getEditors', index);
			for (var i = 0; i < ed.length; i++) {
				var Editor = ed[i];
				if (Editor.field == 'CheckBarcode') {
					$(Editor.target).bind('keydown', function(event) {
						if (event.keyCode == 13) {
							var Barcode = row.Barcode;
							var CheckBarcode = $(this).val();
							if (isEmpty(CheckBarcode)) {
								$UI.msg('alert', '��ɨ���ֵ����!');
								return false;
							} else if (Barcode != CheckBarcode) {
								$UI.msg('alert', '���벻ƥ��!');
								$(this).val('');
								$(this).focus();
								return false;
							} else {
								$UI.msg('alert', '����ƥ��ɹ�!');
							}
						}
					});
				}
			}
		}, onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				// Ĭ��ȫѡ
				$('#DispDetailGrid').datagrid('selectAll');
			}
		}
	});

	// /�������б�
	var NeedDispGridCm = [[
		{
			title: '����id',
			field: 'PatId',
			width: 60,
			hidden: true
		}, {
			title: '�к�',
			field: 'tSendVoice',
			width: 60,
			align: 'center',
			allowExport: false,
			formatter: function(value, row, index) {
				return "<a href='#' onclick='SendMessToVoice(\"" + index + "\")'><img src='../scripts_lib/hisui-0.1.0/dist/css/icons/big/ring.png' title='�к�' border='0'></a>";
			}
		}, {
			title: '����',
			field: 'PatName',
			width: 80
		}, {
			title: '�ǼǺ�',
			field: 'PatNo',
			width: 105
		}
	]];
	NeedDispGrid = $UI.datagrid('#NeedDispGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCMatDisp',
			QueryName: 'QueryNeedDisp',
			query2JsonStrict: 1,
			Params: JSON.stringify(addSessionParams({ StartDate: DateFormatter(new Date()) })),
			rows: 99999
		},
		columns: NeedDispGridCm,
		pagination: false,
		onClickRow: function(index, row) {
			NeedDispGrid.commonClickRow(index, row);
		},
		onSelect: function(index, row) {
			
		},
		onLoadSuccess: function(data) {
			
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
		$('#PatNo').focus();
	};
	Default();
	Query();
};
$(init);

// �к���Ϣ����
function SendMessToVoice(index) {
	if (isEmpty(index)) {
		dhcphaMsgBox.alert('û��ѡ������,���ܽк�!');
		return;
	}
	var RowData = NeedDispGrid.getRows()[index];
	var PatNo = RowData.PatNo;
	var PatName = RowData.PatName;
	var ServerIp = ClientIPAddress;
	var DispUserId = gUserId;
	var Ret = tkMakeServerCall('web.DHCSTMHUI.Common.ServiceCommon', 'SendMessToVoice', PatNo, PatName, ServerIp, DispUserId);
}