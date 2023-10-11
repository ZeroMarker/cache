// /统计清洗工作量
var init = function() {
	$HUI.combobox('#PackageClass', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var packageClassDr = record['RowId'];
			var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2', PkgClassId: packageClassDr }));
			$('#PackageName').combobox('clear');
			$('#PackageName').combobox('reload', $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams);
		}
	});
	
	var SpecParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#PackageSpec', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageSpec&ResultSetType=array&Params=' + SpecParams,
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
	var UserParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#CleanUserId', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetAllUser&ResultSetType=array&Params=' + UserParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var MachineParams = JSON.stringify(addSessionParams({ InManualFlag: 'Y' }));
	$HUI.combobox('#MachineNo', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetMachineNoComBo&type=washer&ResultSetType=array&Params=' + MachineParams,
		valueField: 'RowId',
		textField: 'Description'
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
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	// /拼接url
	function CheckedUrl(Checked, Params, Conditions) {
		// 清洗工作量统计
		var ReportUrl = '';
		if ('FlagStatCleanWorkLoadByPeople' === Checked) {
			ReportUrl = PmRunQianUrl + '?reportName=CSSD_HUI_StatCleanWorkLoadByUser.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagStatCleanMachine' === Checked) {
			ReportUrl = PmRunQianUrl + '?reportName=CSSD_HUI_StatCleanMachine.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagStatCleanWorkLoadDetail' === Checked) {
			ReportUrl = PmRunQianUrl + '?reportName=CSSD_HUI_StatCleanWorkLoadDetail.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return ReportUrl;
	}
	// 组织查询条件
	function GetConditions(ParamsObj) {
		var Conditions = '';
		if (ParamsObj.StartDate !== '') {
			Conditions = Conditions + ' 统计日期: ' + ParamsObj.StartDate;
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
		if (ParamsObj.PackageClass !== '') {
			Conditions = Conditions + ' 包分类: ' + $('#PackageClass').combobox('getText');
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
		CloseStatTab('#tabs');
		GetReportStyle('#Report');
	};
	Default();
};
$(init);