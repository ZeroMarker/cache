var init = function() {
	var Clear = function() {
		$UI.clearBlock('#FindConditions');
		$UI.clear(OeoriMainGrid);
		$UI.clear(OeoriDetailGrid);
		var DefaultData = {
			StartDate: DateFormatter(DateAdd(new Date(), 'd', -1)),
			EndDate: new Date(),
			excludeInci: 'Y'
		};
		$('#BarCode').val('');
		$UI.fillBlock('#FindConditions', DefaultData);
	};
	var FRecLocParams = JSON.stringify(addSessionParams({
		Type: 'All'
	}));
	var FRecLocBox = $HUI.combobox('#LocId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + FRecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#oeorcat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	$UI.linkbutton('#DelBT', {
		onClick: function() {
			var Params = OeoriDetailGrid.getSelectedData('RowId');
			if (Params.length == 0) {
				$UI.msg('alert', '��ѡ����Ҫɾ������ϸ!');
				return;
			}
			if (Params[0].RowId == '' || Params[0].RowId == undefined) {
				$UI.msg('alert', '����ϸ��δ����,����ɾ��!');
				return;
			}
			$UI.confirm('����Ҫɾ��������ϸ,�Ƿ����?', '', '', Delete);
		}
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			var Params = JSON.stringify(ParamsObj);
			var row = OeoriMainGrid.getSelected();
			if (isEmpty(row)) {
				$UI.msg('alert', '��ѡ��һ��ҽ��!');
				return;
			}
			var oeori = row.Oeori;
			var Detail = OeoriDetailGrid.getChangesData('Dhcit');
			if (Detail === false) {	// δ��ɱ༭����ϸΪ��
				return;
			}
			if (isEmpty(Detail)) {	// ��ϸ����
				$UI.msg('alert', 'û����Ҫ�������ϸ!');
				return;
			}
			$.cm({
				ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
				MethodName: 'Save',
				Params: Params,
				oeori: oeori,
				ListDetail: JSON.stringify(Detail)
			}, function(jsonData) {
				if (jsonData.success === 0) {
					$UI.msg('success', jsonData.msg);
					OeoriDetailGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});

	$UI.linkbutton('#AuditBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#FindConditions');
			var Params = JSON.stringify(ParamsObj);
			var row = OeoriMainGrid.getSelected();
			if (isEmpty(row)) {
				$UI.msg('alert', '��ѡ��һ��ҽ��!');
				return;
			}
			var oeori = row.Oeori;
			$.cm({
				ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
				MethodName: 'Audit',
				Params: Params,
				oeori: oeori
			}, function(jsonData) {
				if (jsonData.success == 0) {
					$UI.msg('success', jsonData.msg);
					OeoriDetailGrid.reload();
				} else {
					$UI.msg('error', jsonData.msg);
				}
			});
		}
	});
	$UI.linkbutton('#CancelAuditBT', {
		onClick: function() {
			var Params = OeoriDetailGrid.getSelectedData('RowId');
			if (Params.length == 0) {
				$UI.msg('alert', '��ѡ����Ҫȡ����˵���ϸ!');
				return;
			}
			var SelectedRow = OeoriDetailGrid.getSelected();
			if (SelectedRow.AckFlag != 'Y') {
				$UI.msg('alert', '��ǰ��δ���,����ȡ�����!');
				return;
			}
			$UI.confirm('����Ҫȡ�����������ϸ,ֻ����ȡ��һ��,�Ƿ����?', '', '', CancelAudit);
		}
	});
	$('#wardno').bind('keydown', function(event) {
		if (event.keyCode == 13) {
			var PapmiNo = $(this).val();
			if (isEmpty(PapmiNo)) {
				$UI.msg('alert', '������ǼǺ�!');
				return false;
			}
			try {
				var patinfostr = tkMakeServerCall('web.DHCSTMHUI.HVMatOrdItm', 'Pa', PapmiNo);
				var patinfoarr = patinfostr.split('^');
				var newPaAdmNo = patinfoarr[0];
				var patinfo = patinfoarr[1] + ',' + patinfoarr[2];
				$('#wardno').val(newPaAdmNo);
			} catch (e) {}
		}
	});
	$('#BarCode').bind('keypress', function(event) {
		if (event.keyCode == '13') {
			var BarCode = $(this).val();
			if (BarCode == '') {
				$UI.msg('alert', '����������!');
				return;
			}
			var row = OeoriMainGrid.getSelected();
			if (isEmpty(row)) {
				$UI.msg('alert', '��ѡ��һ��ҽ��!');
				return;
			}
			var FindIndex = OeoriDetailGrid.find('BarCode', BarCode);
			if (FindIndex >= 0) {
				$UI.msg('alert', '���벻���ظ�¼��!');
				$('#BarCode').val('');
				$('#BarCode').focus();
				return false;
			}
			var RecLoc = row.RecLoc;
			var BarCodeData = $.cm({
				ClassName: 'web.DHCSTMHUI.DHCItmTrack',
				MethodName: 'GetItmByBarcode',
				BarCode: BarCode
			}, false);
			if (!isEmpty(BarCodeData.success) && BarCodeData.success != 0) {
				$UI.msg('alert', BarCodeData.msg);
				$(this).val('');
				$(this).focus();
				return;
			}
			if (BarCodeData.Inclb == '') {
				$UI.msg('alert', 'û����Ӧ����¼,�����Ƶ�!');
				$('#BarCode').val('');
				return;
			} else if (BarCodeData.IsAudit != 'Y') {
				$UI.msg('alert', '��ֵ������δ��˵�' + BarCodeData.OperNo + ',���ʵ!');
				return;
			} else if (BarCodeData.Type == 'T') {
				$UI.msg('alert', '��ֵ�����Ѿ�����,�����Ƶ�!');
				return;
			} else if (BarCodeData.Status != 'Enable') {
				$UI.msg('alert', '��ֵ���봦�ڲ�����״̬,�����Ƶ�!');
				return;
			} else if (BarCodeData.ExitInLoc != RecLoc) {
				$UI.msg('alert', '��ֵ��������տ��Ҳ�һ�²����Ƶ�!');
				return;
			}

			var jsonData = tkMakeServerCall('web.DHCSTMHUI.DHCItmTrack', 'Select', BarCode);
			jsonData = $.parseJSON(jsonData);
			var record = {
				Dhcit: jsonData.itmtrackid,
				InciCode: jsonData.incicode,
				InciDesc: jsonData.incidesc,
				BarCode: BarCode,
				Manf: jsonData.manfdesc,
				Inclb: jsonData.inclb,
				BatExp: jsonData.expdate + '~' + jsonData.batno,
				Rp: jsonData.rp
			};
			OeoriDetailGrid.appendRow(record);
			$('#BarCode').val('');
		}
	});
	var OeoriMainCm = [[
		{
			title: 'Oeori',
			field: 'Oeori',
			width: 100,
			hidden: true
		}, {
			title: 'ҽ�������',
			field: 'ArcimCode',
			width: 200
		}, {
			title: 'ҽ��������',
			field: 'ArcimDesc',
			width: 200
		}, {
			title: '���ߵǼǺ�',
			field: 'PaAdmNo',
			width: 200
		}, {
			title: '��������',
			field: 'PaAdmName',
			width: 150
		}, {
			title: '���տ���id',
			field: 'RecLoc',
			hidden: true,
			width: 100
		}, {
			title: '���տ���',
			field: 'RecLocDesc',
			width: 200
		}, {
			title: 'ҽ������',
			field: 'OeoriDate',
			width: 100,
			hidden: true
		}, {
			title: 'ҽ��¼����',
			field: 'UserAddName',
			width: 150
		}, {
			title: 'ҽ������',
			field: 'OrderPackQty',
			width: 80
		}, {
			title: 'ҽ���۸�',
			field: 'OeoriPrices',
			width: 100
		}, {
			title: 'ҽ��״̬',
			field: 'OeoriStatus',
			width: 80
		}
	]];
	var OeoriMainGrid = $UI.datagrid('#OeoriMainGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			QueryName: 'QueryOeori',
			query2JsonStrict: 1
		},
		columns: OeoriMainCm,
		showBar: false,
		onSelect: function(index, row) {
			OeoriDetailGrid.load({
				ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
				QueryName: 'QueryDetail',
				query2JsonStrict: 1,
				oeori: row.Oeori
			});
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				OeoriMainGrid.selectRow(0);
			}
		}
	});
	var OeoriDetailCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 100,
			saveCol: true,
			hidden: true
		}, {
			title: 'Dhcit',
			field: 'Dhcit',
			width: 80,
			saveCol: true,
			hidden: true
		}, {
			title: '���ʴ���',
			field: 'InciCode',
			width: 150
		}, {
			title: '��������',
			field: 'InciDesc',
			width: 200
		}, {
			title: '��ֵ����',
			field: 'BarCode',
			saveCol: true,
			width: 200
		}, {
			title: '��������',
			field: 'Manf',
			width: 80
		}, {
			title: '����Id',
			field: 'Inclb',
			width: 120,
			hidden: true
		}, {
			title: '����~Ч��',
			field: 'BatExp',
			width: 150
		}, {
			title: '����',
			field: 'Rp',
			width: 90
		}, {
			title: '��¼����',
			field: 'OBBDate',
			width: 80
		}, {
			title: '��¼ʱ��',
			field: 'OBBTime',
			width: 80
		}, {
			title: '��¼��',
			field: 'OBBUser',
			width: 80
		}, {
			title: '��˱�־',
			field: 'AckFlag',
			width: 80,
			saveCol: true
		}, {
			title: '�������',
			field: 'OBBAckDate',
			width: 70
		}, {
			title: '���ʱ��',
			field: 'OBBAckTime',
			width: 90
		}, {
			title: '�����',
			field: 'OBBAckUser',
			width: 80
		}, {
			title: 'ȡ���������',
			field: 'CancelDate',
			width: 100,
			saveCol: true
		}, {
			title: 'ȡ�����ʱ��',
			field: 'CancelTime',
			width: 100
		}, {
			title: 'ȡ�������',
			field: 'CancelSSUSR',
			width: 100
		}
	]];

	var OeoriDetailGrid = $UI.datagrid('#OeoriDetailGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			QueryName: 'QueryDetail',
			query2JsonStrict: 1
		},
		columns: OeoriDetailCm,
		showBar: false
	});
	function Query() {
		var ParamsObj = $UI.loopBlock('#FindConditions');
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
		OeoriMainGrid.load({
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			QueryName: 'QueryOeori',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	function Delete() {
		var Params = OeoriDetailGrid.getSelectedData('RowId');
		$.cm({
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			MethodName: 'Delete',
			Params: JSON.stringify(Params)
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				OeoriDetailGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function CancelAudit() {
		var Params = OeoriDetailGrid.getSelectedData('RowId');
		$.cm({
			ClassName: 'web.DHCSTMHUI.OeoriBindBarcode',
			MethodName: 'CancelAudit',
			Params: JSON.stringify(Params),
			UserId: gUserId
		}, function(jsonData) {
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				OeoriDetailGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	Clear();
	Query();
};
$(init);