// 统计接收工作量
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
	var PkgSpecParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId }));
	$HUI.combobox('#PkgSpec', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageSpec&ResultSetType=array&Params=' + PkgSpecParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#DateType', {
		valueField: 'RowId',
		textField: 'Description',
		data: DateTypeData,
		onSelect: function(record) {
			var SelectTypeVal = record.RowId;
			var startDate = '';
			var endDate = DateFormatter(new Date()); // 截止日期为今天
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
	$HUI.combobox('#PkgClass', {
		url: $URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPackageClass&ResultSetType=array&Params=' + PkgSpecParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			$('#PkgName').combobox('clear');
		}
	});
	$HUI.combobox('#PkgName', {
		onShowPanel: function() {
			var PackageClassDr = $('#PkgClass').combobox('getValue');
			var PkgParams = JSON.stringify(addSessionParams({ BDPHospital: gHospId, TypeDetail: '1,2,7', PkgClassId: PackageClassDr }));
			$(this).combobox('reload',
				$URL + '?ClassName=web.CSSDHUI.Common.Dicts&QueryName=GetPkg&ResultSetType=array&Params=' + PkgParams);
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
			AddStatTab(CheckedTitle, Url, '#ResTabs');
		}
	});
	// 拼接url
	function CheckedUrl(Checked, Params, Conditions) {
		var FrameUrl = '';
		if ('FlagPackage' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDRevByPackage.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagLoc' === Checked) {
			FrameUrl = PmRunQianUrl + '?reportName=CSSD_HUI_CSSDRevByLoc.raq&Params=' + Params + '&Conditions=' + Conditions;
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
		if (ParamsObj.SupLoc !== '') {
			Conditions = Conditions + ' 供应室:' + $('#SupLoc').combobox('getText');
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
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		var DefaultValue = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date()),
			SupLoc: gLocObj,
			DocType: 0
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		CloseStatTab('#ResTabs');
		GetReportStyle('#Report');
	};
	Default();
};
$(init);