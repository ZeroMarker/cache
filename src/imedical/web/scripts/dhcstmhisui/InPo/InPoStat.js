var init = function() {
	/* --��ť�¼�--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.PoLoc)) {
				$UI.msg('alert', '�������Ҳ���Ϊ��!');
				return;
			}
			if (isEmpty(StartDate)) {
				$UI.msg('alert', '��ʼ���ڲ���Ϊ��!');
				return;
			}
			if (isEmpty(EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���Ϊ��!');
				return;
			}
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '��ֹ���ڲ���С�ڿ�ʼ����!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			Params = encodeURIComponent(Params);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Conditions = GetConditions(ParamsObj);
			var Url = CheckedUrl(CheckedValue, Params, Conditions);
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	function CheckedUrl(Checked, Params, Conditions) {
		var p_URL = '';
		if ('FlagInpo' == Checked) {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_InPoStat.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_InPoStat.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj) {
		// ��ȡ��ѯ�����б�
		var Conditions = '';
		if (ParamsObj.PoLoc != '') {
			Conditions = '��������: ' + $('#PoLoc').combobox('getText');
		}
		if (ParamsObj.StartDate != '') {
			Conditions = Conditions + ' ͳ��ʱ��: ' + ParamsObj.StartDate;
		}
		if (ParamsObj.EndDate != '') {
			Conditions = Conditions + '~ ' + ParamsObj.EndDate;
		}
		if (ParamsObj.Vendor != '') {
			Conditions = Conditions + ' ��Ӧ��: ' + $('#Vendor').combobox('getText');
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
	var PoLocParams = JSON.stringify(addSessionParams({ Type: 'Login' }));
	var PoLocBox = $HUI.combobox('#PoLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PoLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var PoLoc = $('#PoLoc').combo('getValue');
		var Obj = { StkGrpRowId: '', StkGrpType: 'M', Locdr: PoLoc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	
	/* --���ó�ʼֵ--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		var DefaultValue = {
			StartDate: new Date(),
			EndDate: new Date(),
			PoLoc: gLocObj
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		$UI.clearBlock('#ReportConditions');
		CloseStatTab('#tabs');
	};
	Default();
	GetReportStyle('#Report');
};
$(init);