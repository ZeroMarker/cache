var init = function() {
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
				$UI.msg('alert', '采购科室不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			Params = encodeUrlStr(Params);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Conditions = encodeUrlStr(GetConditions(ParamsObj));
			var Url = CheckedUrl(CheckedValue, Params, Conditions);
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	function CheckedUrl(Checked, Params, Conditions) {
		if ('FlagVendor' == Checked) {
			// 供应商
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_PayStat.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagVendorItm' == Checked) {
			// 供应商明细
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_PayStat2.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagPay' == Checked) {
			// 付款单
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_PayStat_payno.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj) {
		// 获取查询条件列表
		var Conditions = '';
		if (ParamsObj.Loc != '') {
			Conditions = '科室: ' + $('#Loc').combobox('getText');
		}
		if (ParamsObj.StartDate != '') {
			Conditions = Conditions + ' 统计时间: ' + ParamsObj.StartDate;
		}
		if (ParamsObj.EndDate != '') {
			Conditions = Conditions + '~ ' + ParamsObj.EndDate;
		}
		if (ParamsObj.Vendor != '') {
			Conditions = Conditions + ' 供应商: ' + $('#Vendor').combobox('getText');
		}
		if (ParamsObj.PayMode != '') {
			Conditions = Conditions + ' 支付方式: ' + $('#PayMode').combobox('getText');
		}
		return Conditions;
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	/* --绑定控件--*/
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
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var CompFlagBox = $HUI.combobox('#CompFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'N', 'Description': '未完成' }, { 'RowId': 'Y', 'Description': '完成' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var PayModeBox = $HUI.combobox('#PayMode', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPayMode&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
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