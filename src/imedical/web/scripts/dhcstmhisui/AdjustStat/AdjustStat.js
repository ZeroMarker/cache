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
				$UI.msg('alert', '截止日期不能小于开始日期!');
				return;
			}
			/* if(isEmpty(ParamsObj.Loc)){
				$UI.msg('alert','科室不能为空!');
				return;
			}*/
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
		if ('FlagAdjlist' == Checked) {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_AdjustStat.raq&Params=' + Params;
		}
		return p_URL;
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	/* --绑定控件--*/
	var LocParams = JSON.stringify(addSessionParams({ Type: 'LinkLoc' }));
	var LocBox = $HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#ScgStk').setFilterByLoc(LocId);
		}
	});
	var AdjustReasonParams = JSON.stringify(addSessionParams({ Type: 'M' }));
	var AdjustReasonBox = $HUI.combobox('#AdjustReason', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetForAdjustReason&ResultSetType=array&Params=' + AdjustReasonParams,
		valueField: 'Rowid',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Loc = $('#Loc').combo('getValue');
		var Obj = { StkGrpRowId: '', StkGrpType: 'M', Locdr: Loc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	/* --设置初始值--*/
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