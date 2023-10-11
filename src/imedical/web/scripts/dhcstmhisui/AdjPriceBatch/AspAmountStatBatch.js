// 名称: 调价损益统计(批次)
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			Loc: gLocObj,
			OptType: '1'
		};
		$UI.fillBlock('#Conditions', DefaultData);
		CloseStatTab('#tabs');
	};
	var LocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	
	var OptTypeBox = $HUI.combobox('#OptType', {
		data: [{ 'RowId': '1', 'Description': '全部' }, { 'RowId': '2', 'Description': '差额为正' }, { 'RowId': '3', 'Description': '差额为负' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Loc = $('#Loc').combo('getValue');
		var Obj = { StkGrpType: 'M', Locdr: Loc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(StartDate)) {
				$UI.msg('alert', '开始日期不能为空!');
				return;
			}
			if (isEmpty(EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '截止日期不能小于开始日期!');
				return;
			}
			if (isEmpty(ParamsObj.Loc)) {
				$UI.msg('alert', '科室不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			Params = encodeUrlStr(Params);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Url = CheckedUrl(CheckedValue, Params);
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	
	function CheckedUrl(Checked, Params) {
		if ('FlagDetailStat' == Checked) {
			// 调价损益单品汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_aspamountstat-incbatch.raq&Params=' + Params;
		} else if ('FlagItmLocStat' == Checked) {
			// 调价损益单品科室汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_aspamountstat-inclocbatch.raq&Params=' + Params;
		} else if ('FlagVendorStat' == Checked) {
			// 调价损益供应商汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_aspamountstat-vendorbatch.raq&Params=' + Params;
		} else {
			// 调价损益单品汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_aspamountstat-incbatch.raq&Params=' + Params;
		}
		
		return p_URL;
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	Clear();
};
$(init);