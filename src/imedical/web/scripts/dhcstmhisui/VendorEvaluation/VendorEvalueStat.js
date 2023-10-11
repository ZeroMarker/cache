var init = function() {
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var EvalIndexParams = JSON.stringify(addSessionParams());
	var EvalIndexBox = $HUI.combobox('#EvalIndex', {
		url: $URL + '?ClassName=web.DHCSTMHUI.DHCVendorEvaluationIndex&QueryName=EvalIndex&ResultSetType=array&Params=' + EvalIndexParams,
		valueField: 'RowId',
		textField: 'Desc'
	});

	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '起始日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			Params = encodeUrlStr(Params);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var URL = CheckedURL(CheckedValue, Params);
			AddStatTab(CheckedTitle, URL, '#tabs');
		}
	});

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			$UI.clearBlock('#Conditions');
			CloseStatTab('#tabs');
			SetDefaValues();
		}
	});

	SetDefaValues();
	GetReportStyle('#Report');
};
$(init);

function SetDefaValues() {
	$('#StartDate').datebox('setValue', DateFormatter(new Date()));
	$('#EndDate').datebox('setValue', DateFormatter(new Date()));
}
function CheckedURL(CheckedValue, Params) {
	var p_URL = '';
	if ('FlagVendorIndexScore' == CheckedValue) {
		p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_VendorIndexScore.raq&Params=' + Params;
	} else {
		p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_VendorIndexScore.raq&Params=' + Params;
	}
	return p_URL;
}
