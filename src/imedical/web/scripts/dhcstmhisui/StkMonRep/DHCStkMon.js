/* �����±�*/
var init = function() {
	var StkMonLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var StkMonLocBox = $HUI.combobox('#HistoryStkMonStatLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + StkMonLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			if (!StkMonGrid.endEditing()) {
				return;
			}
			CreateStkMon();
		}
	});
	$UI.linkbutton('#RefreshBT', {
		onClick: function() {
			$UI.clear(StkMonGrid);
			QueryStkMon();
		}
	});
	var StkMonCm = [[
		{
			field: 'check',
			checkbox: true
		}, {
			title: 'lastStkMonRowid',
			field: 'lastStkMonRowid',
			width: 100,
			hidden: true
		}, {
			title: 'LocId',
			field: 'LocId',
			width: 80,
			hidden: true
		}, {
			title: '����',
			field: 'LocDesc',
			width: 200
		}, {
			title: '�����·�',
			field: 'lastMonth',
			width: 80
		}, {
			title: '������ʼ����',
			field: 'lastFrDate',
			width: 100
		}, {
			title: '������ʼʱ��',
			field: 'lastFrTime',
			width: 100
		}, {
			title: '���ڽ�ֹ����',
			field: 'lastToDate',
			width: 100
		}, {
			title: '���ڽ�ֹʱ��',
			field: 'lastToTime',
			width: 100
		}, {
			title: '�����·�',
			field: 'CurMonth',
			width: 80,
			editor: {
				type: 'text',
				options: {
					// required: true
				}
			}
		}, {
			title: '���ڿ�ʼ����',
			field: 'CurStartDate',
			width: 120
		}, {
			title: '���ڿ�ʼʱ��',
			field: 'CurStartTime',
			width: 100
		}, {
			title: '���ڽ�ֹ����',
			field: 'CurEndDate',
			width: 120,
			editor: {
				type: 'datebox',
				options: {
					// required: true
				}
			}
		}, {
			title: '���ڽ�ֹʱ��',
			field: 'CurEndTime',
			width: 100
		}
	]];
	var StkMonGrid = $UI.datagrid('#StkMonGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'jsGrpLocForStkMon',
			query2JsonStrict: 1
		},
		singleSelect: false,
		checkOnSelect: false,
		columns: StkMonCm,
		fitColumns: true,
		idField: 'LocId',
		onClickCell: function(index, filed, value) {
			StkMonGrid.commonClickCell(index, filed);
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				var Today = DateFormatter(new Date());
				var NowTime = new Date().format('H:i:s');
				if (Editor.field == 'CurEndDate') {
					var CurEndDate = row.CurEndDate;
					var lastMonth = row.lastMonth;
					var StartDate = row.CurStartDate;
					var EndDate = CurEndDate;
					if (compareDate(CurEndDate, Today)) {
						$UI.msg('alert', '���ڽ�ֹ���ڲ��ܳ�����ǰ����!');
						StkMonGrid.checked = false;
						return false;
					}
					if (compareDate(StartDate, CurEndDate)) {
						$UI.msg('alert', '��ֹ����Ҫ���ڿ�ʼ����!');
						StkMonGrid.checked = false;
						return false;
					}
					CurEndDate = FormatDate(CurEndDate);
					// var NewCurEndDate = CurEndDate.getFullYear() + '-' + leftPad((CurEndDate.getMonth() + 1).toString(), '0', 2);
					var NewCurMonth = tkMakeServerCall('web.DHCSTMHUI.DHCStkMon', 'GetCurMonth', StartDate, EndDate, lastMonth);
					row.CurMonth = NewCurMonth;
					FillOtherLocInfo(row);
				}
			}
		}
	});
	
	// �����������
	function FillOtherLocInfo(row) {
		var CurLocId = row['LocId'];
		var CurStartDate = row['CurStartDate'];
		var CurEndDate = row['CurEndDate'];
		var NewCurMonth = row['CurMonth'];
		var Sels = StkMonGrid.getChecked();
		for (var i = 0, Len = Sels.length; i < Len; i++) {
			var Record = Sels[i];
			if (Record['LocId'] == CurLocId) {
				continue;
			}
			var RowIndex = StkMonGrid.getRowIndex(Record);
			StkMonGrid.updateRow({
				index: RowIndex,
				row: {
					'CurMonth': NewCurMonth,
					'CurEndDate': CurEndDate
				}
			});
		}
	}
	
	function CreateStkMon() {
		var RowData = StkMonGrid.getChecked();
		if (isEmpty(RowData)) {
			$UI.msg('alert', 'ѡ����Ҫ�����±��Ŀ���!');
			return false;
		}
		for (var i = 0; i < RowData.length; i++) {
			var StartDate = RowData[i].CurStartDate;
			var StartTime = RowData[i].CurStartTime;
			var EndDate = RowData[i].CurEndDate;
			var EndTime = RowData[i].CurEndTime;
			var LocDesc = RowData[i].LocDesc;
			var LastMonth = RowData[i].lastMonth;
			var CurMonth = RowData[i].CurMonth;
			var LastMonthDate = LastMonth + '-01';
			var CurMonthDate = CurMonth + '-01';
			var Today = DateFormatter(new Date());
			
			if (compareDate(StartDate, EndDate) || (StartDate == EndDate && StartTime >= EndTime)) {
				$UI.msg('alert', LocDesc + '��ֹʱ��Ҫ���ڿ�ʼʱ��!');
				return false;
			}
			if (compareDate(EndDate, EndDate)) {
				$UI.msg('alert', LocDesc + '���ڽ�ֹ���ڲ��ܳ�������!');
				return false;
			}
			if (isEmpty(CurMonthDate)) {
				$UI.msg('alert', LocDesc + '�����·ݲ���Ϊ��!');
				return false;
			}
			if ((!isEmpty(LastMonthDate)) && (!isEmpty(CurMonthDate)) && compareDate(LastMonthDate, CurMonthDate)) {
				$UI.msg('alert', LocDesc + '�����·�Ҫ���������·�!');
				return false;
			}
			var Sty = FormatDate(StartDate).getFullYear();
			var Stm = FormatDate(StartDate).getMonth() + 1;
			var Edy = FormatDate(EndDate).getFullYear();
			var Edm = FormatDate(EndDate).getMonth() + 1;
			var Cuy = CurMonth.substring(0, 4);
			var Cum = CurMonth.substring(5, 7);
			if ((Cuy == Sty && Cum < Stm) || (Cuy == Edy && Cum > Edm) || (Cuy < Sty) || (Cuy > Edy)) {
				if (!confirm(LocDesc + '�����·ݲ�����ֹ����֮��,�Ƿ���������±�?')) {
					return false;
				}
			}
		}
		RowData = JSON.stringify(RowData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			MethodName: 'CreateReports',
			MainParams: RowData,
			UserId: gUserId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryStkMon();
				QueryHistoryStkMon();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var HistoryStkMonCm = [[
		{
			title: 'smRowid',
			field: 'smRowid',
			width: 100,
			hidden: true
		}, {
			title: '����',
			field: 'locDesc',
			width: 230
		}, {
			title: '�·�',
			field: 'mon',
			width: 100
		}, {
			title: '�±���ʼ����',
			field: 'frDate',
			width: 100
		}, {
			title: '�±���ֹ����',
			field: 'toDate',
			width: 100
		}, {
			title: '�±���',
			field: 'StkMonNo',
			width: 100
		}, {
			title: 'ƾ֤��',
			field: 'AcctVoucherCode',
			width: 100
		}, {
			title: 'ƾ֤����',
			field: 'AcctVoucherDate',
			width: 100
		}, {
			title: 'ƾ֤����״̬',
			field: 'AcctVoucherStatus',
			width: 100
		}, {
			title: 'Pdf�ļ�����',
			field: 'PdfFile',
			width: 100
		}
	]];
	var DeleteBT = {
		text: 'ɾ��',
		iconCls: 'icon-cancel',
		handler: function() {
			var Row = HistoryStkMonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '��ѡ��Ҫɾ������ʷ�±�!');
				return false;
			}
			var LocDesc = Row.locDesc;
			var curMon = Row.mon;
			$UI.confirm('�Ƿ�ȷ��ɾ��' + LocDesc + curMon + '�·ݵ��±�', 'warning', '', DeleteHistoryStkMon, '', '', '����', false);
		}
	};
	var HistoryStkMonGrid = $UI.datagrid('#HistoryStkMonGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'DHCStkMon',
			query2JsonStrict: 1
		},
		columns: HistoryStkMonCm,
		sortName: 'RowId',
		sortOrder: 'Desc',
		toolbar: [DeleteBT],
		fitColumns: true,
		onClickRow: function(index, row) {
			HistoryStkMonGrid.commonClickRow(index, row);
		}
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			QueryHistoryStkMon();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearHistoryStkMon();
		}
	});

	function ClearHistoryStkMon() {
		$UI.clearBlock('#HistoryStkMonConditions');
		$UI.clear(HistoryStkMonGrid);
		// /���ó�ʼֵ ����ʹ������
		var DefaultData = {
			HistoryStkMonStatLoc: gLocObj
		};
		$UI.fillBlock('#HistoryStkMonConditions', DefaultData);
	}
	function QueryHistoryStkMon() {
		var ParamsObj = $UI.loopBlock('#HistoryStkMonConditions');
		if (isEmpty(ParamsObj.HistoryStkMonStatLoc)) {
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return false;
		}
		if (isEmpty(ParamsObj.HistoryStkMonStatLoc)) {
			$UI.msg('alert', '���Ҳ���Ϊ��!');
			return false;
		}
		var StartMonth = ParamsObj.StartDate;
		var EndMonth = ParamsObj.EndDate;
		var StartDate = StartMonth + '-01';
		var EndDate = EndMonth + '-01';
		if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '��ֹ�·ݲ���С�ڿ�ʼ�·�!');
			return;
		}
		HistoryStkMonGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'DHCStkMon',
			query2JsonStrict: 1,
			Params: JSON.stringify(ParamsObj)
		});
	}
	function DeleteHistoryStkMon() {
		var Row = HistoryStkMonGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', 'ѡ����Ҫɾ���ļ�¼!');
			return false;
		}
		var Rowid = Row.smRowid;
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			MethodName: 'Delete',
			sm: Rowid
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryHistoryStkMon();
				QueryStkMon();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function QueryStkMon() {
		var LocDesc = $('#LocDesc').val();
		var Params = JSON.stringify(addSessionParams({ LocDesc: LocDesc }));
		StkMonGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'jsGrpLocForStkMon',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	ClearHistoryStkMon();
	QueryStkMon();
};
$(init);