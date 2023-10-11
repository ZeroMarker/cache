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
				$UI.msg('alert', '截止日期不能小于开始日期！');
				return;
			}
			if (isEmpty(ParamsObj.Loc)) {
				$UI.msg('alert', '供给科室不能为空!');
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
		if ('FlagInrequestStatDetail' == Checked) {
			// 物资明细
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_INRequestStat.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagInrequestStatLoc' == Checked) {
			// 科室物资明细
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_INRequestStatLoc.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj) {
		// 获取查询条件列表
		var Conditions = '';
		if (ParamsObj.Loc != '') {
			Conditions = '科室: ' + $('#Loc').combobox('getText');
		}
		if (ParamsObj.StartDate != '') {
			Conditions = Conditions + ' 统计时间: ' + ParamsObj.StartDate;
		}
		if (ParamsObj.EndDate != '') {
			Conditions = Conditions + '~ ' + ParamsObj.EndDate;
		}
		if (ParamsObj.ScgStk != '') {
			Conditions = Conditions + ' 类组: ' + $('#ScgStk').combobox('getText');
		}
		if (ParamsObj.InciDesc != '') {
			Conditions = Conditions + ' 物资: ' + ParamsObj.InciDesc;
		}
		return Conditions;
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
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#ScgStk').setFilterByLoc(LocId);
		}
	});
	var HandlerParams = function() {
		var Scg = $('#ScgStk').combotree('getValue');
		var Loc = $('#Loc').combo('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', Locdr: Loc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
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