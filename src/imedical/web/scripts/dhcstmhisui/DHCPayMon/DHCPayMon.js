/* 生成付款月报*/
var init = function() {
	var PayMonLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PayMonLocBox = $HUI.combobox('#HistoryPayMonLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PayMonLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var PayMonCm = [[
		{	field: 'check',
			checkbox: true
		}, {
			title: 'lastPayMonRowid',
			field: 'lastPayMonRowid',
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
			width: 230
		}, {
			title: '上期月份',
			field: 'lastMonth',
			width: 100
		}, {
			title: '上期起始日期',
			field: 'lastFrDate',
			width: 100
		}, {
			title: '上期截止日期',
			field: 'lastToDate',
			width: 100
		}, {
			title: '本期月份',
			field: 'CurMonth',
			width: 100,
			editor: {
				type: 'text',
				options: {
					required: true
				}
			}
		}, {
			title: '本期开始日期',
			field: 'CurStartDate',
			width: 100,
			editor: {
				type: 'datebox',
				options: {
					required: true
				}
			}
		}, {
			title: '本期截止日期',
			field: 'CurEndDate',
			width: 100,
			editor: {
				type: 'datebox',
				options: {
					required: true
				}
			}
		}
	]];
	function CheckBeforeCreate() {
		var RowData = PayMonGrid.getChecked();
		var flag = true;
		for (var i = 0; i < RowData.length; i++) {
			var LocDesc = RowData[i].LocDesc;
			var CurEndDate = RowData[i].CurEndDate;
			var Today = DateFormatter(new Date());
			var NowTime = new Date().format('H:i:s');
			if (FormatDate(CurEndDate) >= FormatDate(Today)) {
				$UI.msg('alert', LocDesc + '本期截止日期不能超过当前日期!');
				flag = false;
			}
		}
		return flag;
	}
	var PayMonGrid = $UI.datagrid('#PayMonGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'jsGrpLocForPayMon',
			query2JsonStrict: 1
		},
		singleSelect: false,
		checkOnSelect: false,
		columns: PayMonCm,
		fitColumns: true,
		toolbar: [{
			id: 'SaveBT',
			text: '生成付款月报',
			iconCls: 'icon-save',
			handler: function() {
				if (!PayMonGrid.endEditing()) {
					return;
				}
				if (CheckBeforeCreate()) {
					CreatePayMon();
				}
			}
		}],
		idField: 'LocId',
		sortName: 'RowId',
		sortOrder: 'Desc',
		onClickCell: function(index, field, value) {
			var Row = PayMonGrid.getRows()[index];
			if ((field == 'CurStartDate') && (Row.lastPayMonRowid != '')) {
				return false;
			}
			PayMonGrid.commonClickCell(index, field, value);
		},
		onEndEdit: function(index, row, changes) {
			var Editors = $(this).datagrid('getEditors', index);
			for (var i = 0; i < Editors.length; i++) {
				var Editor = Editors[i];
				var Today = DateFormatter(new Date());
				var NowTime = new Date().format('H:i:s');
				if (Editor.field == 'CurEndDate') {
					var CurEndDate = row.CurEndDate;
					if (FormatDate(CurEndDate) >= FormatDate(Today)) {
						$UI.msg('alert', '本期截止日期不能超过当前日期!');
						PayMonGrid.checked = false;
						return false;
					}
					var FormatCurEndDate = FormatDate(CurEndDate);
					var NewCurEndDate = FormatCurEndDate.getFullYear() + '-' + (FormatCurEndDate.getMonth() + 1);
					row.CurMonth = NewCurEndDate;
				} else
				if (Editor.field == 'CurEndTime') {
					var CurEndTime = row.CurEndTime;
					if (CurEndTime > NowTime) {
						$UI.msg('alert', '本期截止时间不能超过当前时间!');
						PayMonGrid.checked = false;
						return false;
					}
				}
			}
		}
	});
	function CreatePayMon() {
		var RowData = PayMonGrid.getChecked();
		if (isEmpty(RowData)) {
			$UI.msg('alert', '选择需要生成付款月报的科室!');
			return false;
		}
		for (var i = 0; i < RowData.length; i++) {
			var StartDate = RowData[i].CurStartDate;
			var EndDate = RowData[i].CurEndDate;
			var LocDesc = RowData[i].LocDesc;
			var Today = DateFormatter(new Date());
			var Month = RowData[i].CurMonth;
			if (isEmpty(Month) || isEmpty(StartDate) || isEmpty(EndDate)) {
				$UI.msg('alert', LocDesc + '本期月份、开始日期、截止日期不能为空!');
				return false;
			}
			
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', LocDesc + '截止日期不能小于开始日期!');
				return false;
			}
			if (compareDate(EndDate, Today)) {
				$UI.msg('alert', LocDesc + '本期截止日期不能超过当前日期!');
				return false;
			}
		}
		var RowData = JSON.stringify(RowData);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			MethodName: 'CreatePayReports',
			MainParams: RowData,
			UserId: gUserId
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryPayMon();
				QueryHistoryPayMon();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	var HistoryPayMonCm = [[
		{
			title: 'pmRowid',
			field: 'pmRowid',
			width: 100,
			hidden: true
		}, {
			title: '科室',
			field: 'locDesc',
			width: 230
		}, {
			title: '月份',
			field: 'MonthDate',
			width: 100
		}, {
			title: '上期结余金额',
			field: 'LastRpAmt',
			align: 'right',
			width: 100
		}, {
			title: '本期增加金额',
			field: 'ArrearRpAmt',
			align: 'right',
			width: 100
		}, {
			title: '本期付款金额',
			field: 'PayedRpAmt',
			align: 'right',
			width: 100
		}, {
			title: '本期结余金额',
			field: 'EndRpAmt',
			align: 'right',
			width: 100
		}, {
			title: '付款月报开始日期',
			field: 'frDate',
			width: 130
		}, {
			title: '付款月报截止日期',
			field: 'toDate',
			width: 130
		}
	]];
	var HistoryPayMonGrid = $UI.datagrid('#HistoryPayMonGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'DHCPayMon',
			query2JsonStrict: 1
		},
		columns: HistoryPayMonCm,
		sortName: 'RowId',
		sortOrder: 'Desc',
		fitColumns: true,
		onClickRow: function(index, row) {
			HistoryPayMonGrid.commonClickRow(index, row);
		}
	});
	$UI.linkbutton('#SearchBT', {
		onClick: function() {
			QueryHistoryPayMon();
		}
	});
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			ClearHistoryPayMon();
		}
	});
	$UI.linkbutton('#DeleteBT', {
		onClick: function() {
			var Row = HistoryPayMonGrid.getSelected();
			if (isEmpty(Row)) {
				$UI.msg('alert', '请选择要删除的历史付款月报!');
				return false;
			}
			var LocDesc = Row.locDesc;
			var curMon = Row.MonthDate;
			$UI.confirm('是否确定删除' + LocDesc + curMon + '月份的付款月报', 'warning', '', DeleteHistoryPayMon, '', '', '警告', false);
		}
	});
	function ClearHistoryPayMon() {
		$UI.clearBlock('#HistoryPayMonConditions');
		$UI.clear(HistoryPayMonGrid);
		// /设置初始值 考虑使用配置
		var DefaultData = {
			HistoryPayMonLoc: gLocObj
		};
		$UI.fillBlock('#HistoryPayMonConditions', DefaultData);
	}
	function QueryHistoryPayMon() {
		var ParamsObj = $UI.loopBlock('#HistoryPayMonConditions');
		if (isEmpty(ParamsObj.HistoryPayMonLoc)) {
			$UI.msg('alert', '科室不能为空!');
			return false;
		}
		var StartMonth = ParamsObj.StartDate;
		var EndMonth = ParamsObj.EndDate;
		var StartDate = '';
		var EndDate = '';
		if (!isEmpty(StartMonth)) {
			var StartDate = StartMonth + '-01';
		}
		if (!isEmpty(EndMonth)) {
			var EndDate = EndMonth + '-01';
		}
		if ((!isEmpty(StartDate)) && (!isEmpty(EndDate)) && compareDate(StartDate, EndDate)) {
			$UI.msg('alert', '截止月份不能小于开始月份!');
			return;
		}
		HistoryPayMonGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'DHCPayMon',
			query2JsonStrict: 1,
			loc: ParamsObj.HistoryPayMonLoc,
			StartDate: StartDate,
			EndDate: EndDate
		});
	}
	function DeleteHistoryPayMon() {
		var Row = HistoryPayMonGrid.getSelected();
		if (isEmpty(Row)) {
			$UI.msg('alert', '选择需要删除的记录!');
			return false;
		}
		var Rowid = Row.pmRowid;
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			MethodName: 'Delete',
			pm: Rowid
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryPayMon();
				QueryHistoryPayMon();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	function QueryPayMon() {
		PayMonGrid.load({
			ClassName: 'web.DHCSTMHUI.DHCPayMon',
			QueryName: 'jsGrpLocForPayMon',
			query2JsonStrict: 1,
			gGroupId: gGroupId,
			Params: JSON.stringify(addSessionParams())
		});
	}
	ClearHistoryPayMon();
	QueryPayMon();
};
$(init);