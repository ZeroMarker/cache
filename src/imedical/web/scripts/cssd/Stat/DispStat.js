// 发放工作量统计
var init = function() {
	var SupLocParams = JSON.stringify(addSessionParams({ Type: 'SupLoc', BDPHospital: gHospId }));
	$HUI.combobox('#SupLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + SupLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	var RecLocParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	$HUI.combobox('#RecLoc', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	$HUI.combobox('#SterTypeId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetSterType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});

	$HUI.datebox('#StartDate', {
		onSelect: function(record) {
			IsClearDataType();
		}
	});
	$HUI.datebox('#EndDate', {
		onSelect: function(record) {
			IsClearDataType();
		}
	});
	function IsClearDataType() {
		var StartDate = $('#StartDate').datebox('getValue');
		var EndDate = $('#EndDate').datebox('getValue');
		var DateType = $('#DateType').combobox('getValue');
		var Today = DateFormatter(new Date());
		if (DateType === '1' && StartDate !== EndDate) {
			$('#DateType').combobox('clear');
		} else if (DateType === '2' && (StartDate !== getWeekStartDate() || EndDate !== Today)) {
			$('#DateType').combobox('clear');
		} else if (DateType === '3' && (StartDate !== getMonthStartDate() || EndDate !== Today)) {
			$('#DateType').combobox('clear');
		} else if (DateType === '4' && (StartDate !== getQuarterStartDate() || EndDate !== Today)) {
			$('#DateType').combobox('clear');
		} else if (DateType === '5' && (StartDate !== getYearStartDate() || EndDate !== Today)) {
			$('#DateType').combobox('clear');
		}
	}

	$HUI.combobox('#DateType', {
		valueField: 'RowId',
		textField: 'Description',
		data: DateTypeData,
		onSelect: function(record) {
			var SelectTypeVal = record.RowId;
			var startDate = '';
			var endDate = DateFormatter(new Date());
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
			$('#StartDate').datebox('setValue', startDate);
			$('#EndDate').datebox('setValue', endDate);
		}
	});

	$HUI.combobox('#PkgClassId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var PkgClassId = record['RowId'];
			$('#PkgDesc').combobox('clear');
			var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2,7', PkgClassId: PkgClassId }));
			$('#PkgDesc').combobox('reload', $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams);
		}
	});
	
	var SpecParams = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: gHospId }));
	$HUI.combobox('#PkgSpec', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageSpec&ResultSetType=array&Params=' + SpecParams,
		valueField: 'RowId',
		textField: 'Description'
	});

	// 根据选择报表类型过滤查询条件
	$HUI.radio("[name='ReportType']", {
		onChecked: function(e, value) {
			if (($(e.target).attr('value') === 'ConsumeDispSum') || ($(e.target).attr('value') === 'DispSum')) {
				$('#sttime').css('display', 'none');
				$('#endtime').css('display', 'none');
				$('#suploc').css('display', 'none');
				$('#disploc').css('display', 'none');
				$('#pkgclass').css('display', 'none');
				$('#stertype').css('display', 'none');
			} else {
				$('#pkgclass').css('display', '');
				$('#sttime').css('display', '');
				$('#endtime').css('display', '');
				$('#suploc').css('display', '');
				$('#disploc').css('display', '');
				$('#stertype').css('display', '');
			}
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
			var Params = JSON.stringify(ParamsObj);
			Params = encodeUrlStr(Params);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Conditions = encodeUrlStr(GetConditions(ParamsObj));
			var Url = CheckedUrl(CheckedValue, Params, Conditions);
			AddStatTab(CheckedTitle, Url, '#DispTabs');
		}
	});
	// /拼接url
	function CheckedUrl(Checked, Params, Conditions) {
		var FrameUrl = '';
		if ('FlagPackage' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDDispByPackage.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagLoc' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDDispByLoc.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagItmDetail' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDDispItmDetail.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagLocDispDetail' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDLocDispDetail.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagConsumeDispSum' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDConsumeDispSum.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagDispSum' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDDispSum.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return FrameUrl;
	}
	// 组织查询条件
	function GetConditions(ParamsObj) {
		// 获取查询条件列表
		var Conditions = '';
		if (ParamsObj.StartDate !== '') {
			Conditions = Conditions + ' 统计时间: ' + ParamsObj.StartDate;
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
		if (ParamsObj.PkgClassId !== '') {
			Conditions = Conditions + ' 包分类: ' + $('#PkgClassId').combobox('getText');
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
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		CloseStatTab('#DispTabs');
		GetReportStyle('#Report');
	};
	Default();
};
$(init);