// 统计打包工作量
var init = function() {
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'SupLoc', BDPHospital: gHospId }));
	var Params = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#PackLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#PkgClass', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$('#PackName').combobox('clear');
		}
	});
	$HUI.combobox('#PackName', {
		onShowPanel: function() {
			var PkgClassId = $('#PkgClass').combobox('getValue');
			var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2,7', PkgClassId: PkgClassId }));
			$(this).combobox('reload', $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams);
		}
	});
	$HUI.combobox('#PkgSpec', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageSpec&ResultSetType=array&Params=' + Params,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#DateType', {
		valueField: 'RowId',
		textField: 'Description',
		data: DateTypeData,
		onSelect: function(record) {
			var SelectTypeVal = record.RowId;
			var startDate = '', endDate = '';
			if (SelectTypeVal === '1') {
				startDate = DateFormatter(new Date());
			} else if (SelectTypeVal === '2') {
				startDate = getWeekStartDate();
			} else if (SelectTypeVal === '3') {
				startDate = getMonthStartDate();
			} else if (SelectTypeVal === '4') {
				startDate = getQuarterStartDate();
			} else if (SelectTypeVal === '5') {
				startDate = getYearStartDate();
			}
			endDate = DateFormatter(new Date());
			$('#StartTime').timespinner('setValue', '');
			$('#EndTime').timespinner('setValue', '');
			$('#StartDate').datebox('setValue', startDate);
			$('#EndDate').datebox('setValue', endDate);
		}
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
			var FrameParams = JSON.stringify(ParamsObj);
			FrameParams = encodeUrlStr(FrameParams);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Conditions = encodeUrlStr(GetConditions(ParamsObj));
			var Url = CheckedUrl(CheckedValue, FrameParams, Conditions);
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	// 拼接url
	function CheckedUrl(Checked, FrameParams, Conditions) {
		var FrameUrl = '';
		if ('FlagPackSt' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_PackSt.raq&Params=' + FrameParams + '&Conditions=' + Conditions;
		}
		return FrameUrl;
	}
	// 组织查询条件
	function GetConditions(ParamsObj) {
		// 获取查询条件列表
		var Conditions = '';
		if (ParamsObj.StartDate !== '') {
			Conditions = Conditions + '统计时间:' + ParamsObj.StartDate;
			if (ParamsObj.StartTime !== '') {
				Conditions = Conditions + ' ' + ParamsObj.StartTime;
			}
		}
		if (ParamsObj.EndDate !== '') {
			Conditions = Conditions + ' ~ ' + ParamsObj.EndDate;
			if (ParamsObj.EndTime !== '') {
				Conditions = Conditions + ' ' + ParamsObj.EndTime;
			}
		}
		if (ParamsObj.PkgClass !== '') {
			Conditions = Conditions + ' 包分类:' + $('#PkgClass').combobox('getText');
		}
		if (ParamsObj.PkgSpec !== '') {
			Conditions = Conditions + ' 规格:' + $('#PkgSpec').combobox('getText');
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
			DateType: 1
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		CloseStatTab('#tabs');
		GetReportStyle('#Report');
	};
	Default();
};
$(init);