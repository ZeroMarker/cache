// 消毒包使用统计
var init = function() {
	var RecLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	$HUI.combobox('#RecLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	/* --按钮事件--*/
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
			if (isEmpty(ParamsObj.RecLoc)) {
				$UI.msg('alert', '接收科室不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Conditions = GetConditions(ParamsObj);
			Params = encodeUrlStr(Params);
			Conditions = encodeUrlStr(Conditions);
			var Url = CheckedUrl(CheckedValue, Params, Conditions);
			AddStatTab(CheckedTitle, Url, '#UseTabs');
		}
	});
	// 拼接url
	function CheckedUrl(Checked, Params, Conditions) {
		var FrameUrl = '';
		if ('FlagPackageUse' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_PackageUseStat.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return FrameUrl;
	}
	// 组织查询条件
	function GetConditions(ParamsObj) {
		var Conditions = '';
		if (ParamsObj.StartDate !== '') {
			Conditions = Conditions + ' 统计日期: ' + ParamsObj.StartDate;
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
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			RecLoc:gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		CloseStatTab('#UseTabs');
		GetReportStyle('#Report');
	};
	Default();
};
$(init);