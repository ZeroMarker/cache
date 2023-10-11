// 日常监测、满意度调查统计
var init = function() {
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
			if (ParamsObj.StartDate > ParamsObj.EndDate) {
				$UI.msg('alert', '起始日期不能大于截止日期!');
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
		var FrameUrl = '';
		if ('FlagStatSatisfaction' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDSatisfaction.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagStatDailySurvey' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDDailySurvey.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return FrameUrl;
	}
	function GetConditions(ParamsObj) {
		var Conditions = '';
		if (ParamsObj.StartDate !== '') {
			Conditions = Conditions + ParamsObj.StartDate;
		}
		if (ParamsObj.EndDate !== '') {
			Conditions = Conditions + ' ~ ' + ParamsObj.EndDate;
		}
		return Conditions;
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		CloseStatTab('#tabs');
		GetReportStyle('#Report');
	};
	Default();
};
$(init);