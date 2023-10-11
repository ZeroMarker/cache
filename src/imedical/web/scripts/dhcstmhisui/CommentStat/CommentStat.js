var init = function() {
	/* --按钮事件--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '开始日期不能为空!');
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
			var Url = CheckedUrl(CheckedValue, Params);
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	function CheckedUrl(Checked, Params) {
		if ('FlagDeatail' == Checked) {
			// 按点评明细汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ComDetail.raq&Params=' + Params;
		} else if ('FlagReason' == Checked) {
			// 按不合理原因汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ComDetailByReason.raq&Params=' + Params;
		} else if ('FlagDoctor' == Checked) {
			// 按开单医生汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ComDetailByDoctor.raq&Params=' + Params;
		} else if ('FlagOriLoc' == Checked) {
			// 按开单科室汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ComDetailByOriLoc.raq&Params=' + Params;
		} else if ('FlagQuality' == Checked) {
			// 按合格率汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ComDetailByQuality.raq&Params=' + Params;
		} else {
			// 按点评明细汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ComDetail.raq&Params=' + Params;
		}
		return p_URL;
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
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Scg = $('#ScgStk').combotree('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#ScgStk').combotree({
		onChange: function(newValue, oldValue) {
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + newValue;
			StkCatBox.reload(url);
		}
	});
	
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		CloseStatTab('#tabs');
	};
	Default();
};
$(init);