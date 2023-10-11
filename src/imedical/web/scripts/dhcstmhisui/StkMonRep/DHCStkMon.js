/* 生成月报*/
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
			title: '科室',
			field: 'LocDesc',
			width: 200
		}, {
			title: '上期月份',
			field: 'lastMonth',
			width: 80
		}, {
			title: '上期起始日期',
			field: 'lastFrDate',
			width: 100
		}, {
			title: '上期起始时间',
			field: 'lastFrTime',
			width: 100
		}, {
			title: '上期截止日期',
			field: 'lastToDate',
			width: 100
		}, {
			title: '上期截止时间',
			field: 'lastToTime',
			width: 100
		}, {
			title: '本期月份',
			field: 'CurMonth',
			width: 80,
			editor: {
				type: 'text',
				options: {
					// required: true
				}
			}
		}, {
			title: '本期开始日期',
			field: 'CurStartDate',
			width: 120
		}, {
			title: '本期开始时间',
			field: 'CurStartTime',
			width: 100
		}, {
			title: '本期截止日期',
			field: 'CurEndDate',
			width: 120,
			editor: {
				type: 'datebox',
				options: {
					// required: true
				}
			}
		}, {
			title: '本期截止时间',
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
						$UI.msg('alert', '本期截止日期不能超过当前日期!');
						StkMonGrid.checked = false;
						return false;
					}
					if (compareDate(StartDate, CurEndDate)) {
						$UI.msg('alert', '截止日期要晚于开始日期!');
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
	
	// 填充其他科室
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
			$UI.msg('alert', '选择需要生成月报的科室!');
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
				$UI.msg('alert', LocDesc + '截止时间要晚于开始时间!');
				return false;
			}
			if (compareDate(EndDate, EndDate)) {
				$UI.msg('alert', LocDesc + '本期截止日期不能超过当天!');
				return false;
			}
			if (isEmpty(CurMonthDate)) {
				$UI.msg('alert', LocDesc + '本期月份不能为空!');
				return false;
			}
			if ((!isEmpty(LastMonthDate)) && (!isEmpty(CurMonthDate)) && compareDate(LastMonthDate, CurMonthDate)) {
				$UI.msg('alert', LocDesc + '本期月份要晚于上期月份!');
				return false;
			}
			var Sty = FormatDate(StartDate).getFullYear();
			var Stm = FormatDate(StartDate).getMonth() + 1;
			var Edy = FormatDate(EndDate).getFullYear();
			var Edm = FormatDate(EndDate).getMonth() + 1;
			var Cuy = CurMonth.substring(0, 4);
			var Cum = CurMonth.substring(5, 7);
			if ((Cuy == Sty && Cum < Stm) || (Cuy == Edy && Cum > Edm) || (Cuy < Sty) || (Cuy > Edy)) {
				if (!confirm(LocDesc + '本期月份不在起止日期之内,是否继续生成月报?')) {
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
			title: '科室',
			field: 'locDesc',
			width: 230
		}, {
			title: '月份',
			field: 'mon',
			width: 100
		}, {
			title: '月报起始日期',
			field: 'frDate',
			width: 100
		}, {
			title: '月报截止日期',
			field: 'toDate',
			width: 100
		}, {
			title: '月报号',
			field: 'StkMonNo',
			width: 100
		}, {
			title: '凭证号',
			field: 'AcctVoucherCode',
			width: 100
		}, {
			title: '凭证日期',
			field: 'AcctVoucherDate',
			width: 100
		}, {
			title: '凭证处理状态',
			field: 'AcctVoucherStatus',
			width: 100
		}, {
			title: 'Pdf文件名称',
			field: 'PdfFile',
			width: 100
		}
	]];
	var DeleteBT = {
		text: '删除',
		iconCls: 'icon-cancel',
		handler: function() {
			var Row = HistoryStkMonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要删除的历史月报!');
				return false;
			}
			var LocDesc = Row.locDesc;
			var curMon = Row.mon;
			$UI.confirm('是否确定删除' + LocDesc + curMon + '月份的月报', 'warning', '', DeleteHistoryStkMon, '', '', '警告', false);
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
		// /设置初始值 考虑使用配置
		var DefaultData = {
			HistoryStkMonStatLoc: gLocObj
		};
		$UI.fillBlock('#HistoryStkMonConditions', DefaultData);
	}
	function QueryHistoryStkMon() {
		var ParamsObj = $UI.loopBlock('#HistoryStkMonConditions');
		if (isEmpty(ParamsObj.HistoryStkMonStatLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return false;
		}
		if (isEmpty(ParamsObj.HistoryStkMonStatLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return false;
		}
		var StartMonth = ParamsObj.StartDate;
		var EndMonth = ParamsObj.EndDate;
		var StartDate = StartMonth + '-01';
		var EndDate = EndMonth + '-01';
		if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止月份不能小于开始月份!');
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
			$UI.msg('alert', '选择需要删除的记录!');
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