var init = function() {
	/* --按钮事件--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.PoLoc)) {
				$UI.msg('alert', '订单科室不能为空!');
				return;
			}
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
			var Params = JSON.stringify(ParamsObj);
			Params = encodeURIComponent(Params);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Conditions = GetConditions(ParamsObj);
			var Url = CheckedUrl(CheckedValue, Params, Conditions);
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	function CheckedUrl(Checked, Params, Conditions) {
		var p_URL = '';
		if ('FlagInpo' == Checked) {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_InPoStat.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_InPoStat.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj) {
		// 获取查询条件列表
		var Conditions = '';
		if (ParamsObj.PoLoc != '') {
			Conditions = '订单科室: ' + $('#PoLoc').combobox('getText');
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
		if (ParamsObj.InciDesc != '') {
			Conditions = Conditions + ' 物资: ' + ParamsObj.InciDesc;
		}
		return Conditions;
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	
	/* --绑定控件--*/
	var PoLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PoLocBox = $HUI.combobox('#PoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PoLocParams,
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
		var PoLoc = $('#PoLoc').combo('getValue');
		var Obj = { StkGrpRowId: '', StkGrpType: 'M', Locdr: PoLoc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		var DefaultValue = {
			StartDate: new Date(),
			EndDate: new Date(),
			PoLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		$UI.clearBlock('#ReportConditions');
		CloseStatTab('#tabs');
	};
	Default();
	GetReportStyle('#Report');
};
$(init);