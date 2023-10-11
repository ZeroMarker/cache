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
				$UI.msg('alert', '截止日期不能小于开始日期!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			Params = encodeUrlStr(Params);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Conditions = encodeUrlStr(GetConditions(ParamsObj));
			var Url = CheckedUrl(CheckedValue, Params, Conditions);
			if (isEmpty(Url)) {
				return;
			}
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	
	function CheckedUrl(Checked, Params, Conditions) {
		var p_URL;
		if (Checked == 'FlagUsed') {
			// 已使用条码汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_HvMatStat.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if (Checked == 'FlagUsedInci') {
			// 单品汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_HvMatInciStat.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj) {
		// 获取查询条件列表
		var Conditions = '';
		if (ParamsObj.Loc != '') {
			Conditions = '接收科室: ' + $('#Loc').combobox('getText');
		}
		if (ParamsObj.StartDate != '') {
			Conditions = Conditions + ' 统计时间: ' + ParamsObj.StartDate;
		}
		if (ParamsObj.EndDate != '') {
			Conditions = Conditions + ' ~ ' + ParamsObj.EndDate;
		}
		if (ParamsObj.Vendor != '') {
			Conditions = Conditions + ' 供应商: ' + $('#Vendor').combobox('getText');
		}
		if (ParamsObj.InciDesc != '') {
			Conditions = Conditions + ' 物资: ' + ParamsObj.InciDesc;
		}
		return Conditions;
	}
	
	var LocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
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
		var Obj = { StkGrpRowId: '', StkGrpType: 'M', Locdr: Loc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	$('#PamNo').bind('keypress', function(event) {
		if (event.keyCode == '13') {
			var PamNo = $('#PamNo').val();
			var NewValue = leftPad(PamNo, '0', 10);
			$('#PamNo').val(NewValue);
		}
	});
	
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		// /设置初始值 考虑使用配置
		var DefaultValue = {
			StartDate: new Date(),
			EndDate: new Date()
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		CloseStatTab('#tabs');
	};
	Default();
	GetReportStyle('#Report');
};
$(init);