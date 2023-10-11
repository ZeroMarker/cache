// 人员工作量统计
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
			var FrameParams = JSON.stringify(ParamsObj);
			FrameParams = encodeUrlStr(FrameParams);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Conditions = encodeUrlStr(GetConditions(ParamsObj));
			var Url = CheckedUrl(CheckedValue, FrameParams, Conditions);
			AddStatTab(CheckedTitle, Url, '#PersonTabs');
		}
	});
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'SupLoc', BDPHospital: gHospId }));
	$HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#UserName', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description'
	});
	function CheckedUrl(Checked, FrameParams, Conditions) {
		var FrameUrl = '';
		if ('FlagPersonWorkLoadSum' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_StatPersonWorkLoadSum.raq&Params=' + FrameParams + '&Conditions=' + Conditions;
		} else if ('FlagPersonWorkLoadDetail' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_StatPersonWorkLoadDetail.raq&Params=' + FrameParams + '&Conditions=' + Conditions;
		}
		return FrameUrl;
	}
	function GetConditions(ParamsObj) {
		// 获取查询条件列表
		var Conditions = '';
		if (ParamsObj.StartDate !== '') {
			Conditions = Conditions + ' 统计日期: ' + ParamsObj.StartDate;
		}
		if (ParamsObj.EndDate !== '') {
			Conditions = Conditions + ' ~ ' + ParamsObj.EndDate;
		}
		if (ParamsObj.SupLoc !== '') {
			Conditions = Conditions + ' 供应科室: ' + $('#SupLoc').combobox('getText');
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
		CloseStatTab('#PersonTabs');
		GetReportStyle('#Report');
	};
	Default();
};
$(init);