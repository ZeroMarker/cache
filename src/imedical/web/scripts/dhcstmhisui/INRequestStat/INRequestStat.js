var init = function() {
	/* --��ť�¼�--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(StartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ���ڣ�');
				return;
			}
			if (isEmpty(ParamsObj.Loc)) {
				$UI.msg('alert', '�������Ҳ���Ϊ��!');
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
			// ������ϸ
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_INRequestStat.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagInrequestStatLoc' == Checked) {
			// ����������ϸ
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_INRequestStatLoc.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj) {
		// ��ȡ��ѯ�����б�
		var Conditions = '';
		if (ParamsObj.Loc != '') {
			Conditions = '����: ' + $('#Loc').combobox('getText');
		}
		if (ParamsObj.StartDate != '') {
			Conditions = Conditions + ' ͳ��ʱ��: ' + ParamsObj.StartDate;
		}
		if (ParamsObj.EndDate != '') {
			Conditions = Conditions + '~ ' + ParamsObj.EndDate;
		}
		if (ParamsObj.ScgStk != '') {
			Conditions = Conditions + ' ����: ' + $('#ScgStk').combobox('getText');
		}
		if (ParamsObj.InciDesc != '') {
			Conditions = Conditions + ' ����: ' + ParamsObj.InciDesc;
		}
		return Conditions;
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	/* --�󶨿ؼ�--*/
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
	
	/* --���ó�ʼֵ--*/
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