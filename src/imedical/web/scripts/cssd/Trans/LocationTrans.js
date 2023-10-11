var init = function() {
	$HUI.combobox('#CurLocation', {
		valueField: 'RowId',
		textField: 'Description',
		data: CurLocationData
	});

	var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1' }));
	$HUI.combobox('#OprPkg', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var Params = JSON.stringify(ParamsObj);
			Params = encodeUrlStr(Params);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Conditions = GetConditions(ParamsObj);
			Conditions = encodeUrlStr(Conditions);
			var Url = CheckedUrl(CheckedValue, Params, Conditions);
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	// 拼接url
	function CheckedUrl(Checked, Params, Conditions) {
		var FrameUrl = '';
		if ('FlagPkgCurLocation' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDLocationTrans.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return FrameUrl;
	}
	// 组织查询条件
	function GetConditions(ParamsObj) {
		// 获取查询条件列表
		var Conditions = '';
		if (!isEmpty(ParamsObj.StartDate)) {
			Conditions = Conditions + ' 统计时间: ' + ParamsObj.StartDate;
		}
		if (!isEmpty(ParamsObj.EndDate)) {
			Conditions = Conditions + ' ~ ' + ParamsObj.EndDate;
		}
		return Conditions;
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		var DefaultValue = {
			StartDate: new Date(),
			EndDate: new Date()
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		CloseStatTab('#tabs');
		GetReportStyle('#Report');
	};
	Default();
};
$(init);