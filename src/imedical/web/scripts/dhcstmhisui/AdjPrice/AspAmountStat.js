var init = function() {
	/* --按钮事件--*/
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
				$UI.msg('alert', '截止日期不能小于开始日期！');
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
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	
	function CheckedUrl(Checked, Params) {
		if ('FlagDetailStat' == Checked) {
			// 单品汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_aspamountstat-inc.raq&Params=' + Params;
		} else if ('FlagItmLocStat' == Checked) {
			// 单品科室汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_aspamountstat-incloc.raq&Params=' + Params;
		} else if ('FlagVendorStat' == Checked) {
			// 供应商汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_aspamountstat-vendor.raq&Params=' + Params;
		}
		return p_URL;
	}
	
	/* --绑定控件--*/
	var AspLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var AspLocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + AspLocParams,
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
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Loc = $('#Loc').combo('getValue');
		var Obj = { StkGrpRowId: '', StkGrpType: 'M', Locdr: Loc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: new Date(),
			EndDate: new Date(),
			Loc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		CloseStatTab('#tabs');
	};
	Default();
	GetReportStyle('#Report');
};
$(init);