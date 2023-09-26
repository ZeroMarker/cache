/*�����±�*/
var init = function () {

	var StkMonLocParams = JSON.stringify(addSessionParams({ Type: "Login" }));
	var StkMonLocBox = $HUI.combobox('#HistoryStkMonLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + StkMonLocParams,
		valueField: 'RowId',
		textField: 'Description'
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
			width: 230
		}, {
			title: "�����·�",
			field: 'lastMonth',
			width: 100
		}, {
			title: "������ʼ����",
			field: 'lastFrDate',
			width: 100
		}, {
			title: "������ʼʱ��",
			field: 'lastFrTime',
			width: 100
		}, {
			title: "���ڽ�ֹ����",
			field: 'lastToDate',
			width: 100
		}, {
			title: "���ڽ�ֹʱ��",
			field: 'lastToTime',
			width: 100
		}, {
			title: "�����·�",
			field: 'CurMonth',
			width: 100,
			editor: {
				type: 'text',
				options: {
					required: true
				}
			}
		}, {
			title: "���ڿ�ʼ����",
			field: 'CurStartDate',
			width: 100,
			editor: {
				type: 'datebox',
				options: {
					required: true
				}
			}
		}, {
			title: "���ڿ�ʼʱ��",
			field: 'CurStartTime',
			width: 150,
			editor: {
				type: 'timespinner',
				options: {
					required: true
				}
			}
		}, {
			title: "���ڽ�ֹ����",
			field: 'CurEndDate',
			width: 100,
			editor: {
				type: 'datebox',
				options: {
					required: true
				}
			}
		}, {
			title: "���ڽ�ֹʱ��",
			field: 'CurEndTime',
			width: 150,
			editor: {
				type: 'timespinner',
				options: {
					//value:'23:59:59',
					required: true
				}
			}
		}
	]];
	var StkMonGrid = $UI.datagrid('#StkMonGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'jsGrpLocForStkMon'
		},
		singleSelect: false,
		checkOnSelect: false,
		columns: StkMonCm,
		toolbar: [{
				id: 'SaveBT',
				text: '�����±�',
				iconCls: 'icon-save',
				handler: function () {
					StkMonGrid.endEditing();
					CreateStkMon();
				}
			},{
				id: 'RefreshBT',
				text: 'ˢ��',
				iconCls: 'icon-reload',
				handler: function () {
					$UI.clear(StkMonGrid);
					QueryStkMon();
				}
		}],
		idField: 'LocId',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickCell: function (index, field, value) {
			var Row = StkMonGrid.getRows()[index];
			if (((field == 'CurStartDate') || (field == 'CurStartTime')) && (Row.lastStkMonRowid != "")) {
				return false;
			}
			StkMonGrid.commonClickCell(index, field, value)
		},
		onEndEdit: function (index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				var Today = DateFormatter(new Date());
				var NowTime = new Date().format('H:i:s');
				if (Editor.field == 'CurEndDate') {
					var CurEndDate = row.CurEndDate;
					if (FormatDate(CurEndDate) > FormatDate(Today)) {
						$UI.msg('alert', '���ڽ�ֹ���ڲ��ܳ�����ǰ����!');
						StkMonGrid.checked = false;
						return false;
					}
					var FormatCurEndDate = FormatDate(CurEndDate);
					var NewCurEndDate = FormatCurEndDate.getFullYear() + '-' + (FormatCurEndDate.getMonth() + 1);
					row.CurMonth = NewCurEndDate;
				} else
					if (Editor.field == 'CurEndTime') {
						var CurEndTime = row.CurEndTime
						alert("CurEndTime" + CurEndTime)
						if (CurEndTime > NowTime) {
							$UI.msg('alert', '���ڽ�ֹʱ�䲻�ܳ�����ǰʱ��!');
							StkMonGrid.checked = false;
							return false;
						}
					}

			}
		}
	})
	function CreateStkMon() {
		var RowData = StkMonGrid.getChecked();
		if (isEmpty(RowData)) {
			$UI.msg('alert', 'ѡ����Ҫ�����±��Ŀ���!');
			return false;
		}
		for(var i = 0; i < RowData.length; i++){
			var StartDate = RowData[i].CurStartDate;
			var StartTime = RowData[i].CurStartTime;
			var EndDate = RowData[i].CurEndDate;
			var EndTime = RowData[i].CurEndTime;
			var LocDesc = RowData[i].LocDesc;
			var Today = DateFormatter(new Date());
			if((StartDate>EndDate)||(StartDate==EndDate && StartTime>=EndTime)){
				$UI.msg('alert', LocDesc+'��ֹʱ��Ҫ���ڿ�ʼʱ��!');
				return false;
			}
			if(EndDate >= Today){
				$UI.msg('alert', LocDesc+'���ڽ�ֹ���ڲ��ܳ�������!');
				return false;
			}
		}
		var RowData = JSON.stringify(RowData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			MethodName: 'CreateReports',
			MainParams: RowData,
			UserId: gUserId
		}, function (jsonData) {
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
			title: "�·�",
			field: 'mon',
			width: 100
		}, {
			title: "�±���ʼ����",
			field: 'frDate',
			width: 100
		}, {
			title: "�±���ֹ����",
			field: 'toDate',
			width: 100
		}, {
			title: "�±���",
			field: 'StkMonNo',
			width: 100
		}, {
			title: "ƾ֤��",
			field: 'AcctVoucherCode',
			width: 100
		}, {
			title: "ƾ֤����",
			field: 'AcctVoucherDate',
			width: 100
		}, {
			title: "ƾ֤����״̬",
			field: 'AcctVoucherStatus',
			width: 100
		}, {
			title: "Pdf�ļ�����",
			field: 'PdfFile',
			width: 100
		}
	]];
	var HistoryStkMonGrid = $UI.datagrid('#HistoryStkMonGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'DHCStkMon'
		},
		columns: HistoryStkMonCm,
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickCell: function (index, field, value) {
			HistoryStkMonGrid.commonClickCell(index, field, value)
		}
	})
	$UI.linkbutton('#SearchBT', {
		onClick: function () {
			QueryHistoryStkMon();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function () {
			ClearHistoryStkMon();
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function () {
			var Row = HistoryStkMonGrid.getSelected();
			if(isEmpty(Row)){
				$UI.msg('alert', "��ѡ��Ҫɾ������ʷ�±�!");
				return false;
			}
			var LocDesc = Row.locDesc;
			var curMon = Row.mon;
			$UI.confirm("�Ƿ�ȷ��ɾ��" + LocDesc + curMon + "�·ݵ��±�", "warning", "", DeleteHistoryStkMon, "", "", "����", false);
		}
	});
	function ClearHistoryStkMon() {
		$UI.clearBlock('#HistoryStkMonConditions');
		$UI.clear(HistoryStkMonGrid);
		///���ó�ʼֵ ����ʹ������
		var Dafult = {
			HistoryStkMonLoc: gLocObj
		}
		$UI.fillBlock('#HistoryStkMonConditions', Dafult);
	}
	function QueryHistoryStkMon() {
		var ParamsObj = $UI.loopBlock('#HistoryStkMonConditions');
		if (isEmpty(ParamsObj.HistoryStkMonLoc)) {
			$UI.msg('alert', "���Ҳ���Ϊ��!");
			return false;
		}
		var StYear = ParamsObj.StYear;
		var StMonth = ParamsObj.StMonth;
		var EdYear = ParamsObj.EdYear;
		var EdMonth = ParamsObj.EdMonth;
		var StartDate = "";
		var EndDate = "";
		if ((!isEmpty(StYear)) && (!isEmpty(StMonth)) && (!isEmpty(EdYear)) && (!isEmpty(EdMonth))) {
			var StartDate = StYear + '-' + StMonth + '-' + '01';
			var EndDate = EdYear + '-' + EdMonth + '-' + '01';
		}

		$UI.setUrl(HistoryStkMonGrid);
		HistoryStkMonGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'DHCStkMon',
			loc: ParamsObj.HistoryStkMonLoc,
			StartDate: StartDate,
			EndDate: EndDate
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
		}, function (jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryHistoryStkMon();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});

	}
	function QueryStkMon() {
		$UI.setUrl(StkMonGrid);
		StkMonGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCStkMon',
			QueryName: 'jsGrpLocForStkMon',
			gGroupId: gGroupId,
			Params:JSON.stringify(addSessionParams())
		});

	}
	ClearHistoryStkMon();
	QueryStkMon();

}
$(init);