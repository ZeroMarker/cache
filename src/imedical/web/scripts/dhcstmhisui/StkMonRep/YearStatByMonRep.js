// ����: �±����ͳ��(�±�����)
// ��д����: 20180813
var init = function() {
	function GetParamsObj() {
		var ParamsObj = $UI.loopBlock('#YearConditions');
		return ParamsObj;
	}
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	var Clear = function() {
		$UI.clearBlock('#YearConditions');
		var Year = new Date().getFullYear();
		var DefaultData = {
			PhaLoc: gLocObj,
			Year: Year
		};
		$UI.fillBlock('#YearConditions', DefaultData);
		CloseStatTab('#tabs');
	};
	var LocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var LocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			QueryYearStkMon();
		}
	});
	function CheckedUrl(Checked) {
		var ParamsObj = GetParamsObj();
		var PhaLoc = ParamsObj.PhaLoc;
		var Year = ParamsObj.Year;
		var StMonth = ParamsObj.StMonth;
		var EdMonth = ParamsObj.EdMonth;
		
		if ('ScgStat' == Checked) {
			// �������(���ת��)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatByMonRep_Scg.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if ('StkCatStat' == Checked) {
			// ���������(���ת��)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatByMonRep_StkCat.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if ('InciRecRetStat' == Checked) {
			// ����˻���ϸ(��Ʒ��)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatByMonRep_Inci.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if ('OutLocStat' == Checked) {
			// �������(������)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatTKByMonRep_Loc.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if ('ScgCatStatCat' == Checked) {
			// ���������(����)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatByMonCatRep.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if ('OutLocStatCat' == Checked) {
			// �������(�����ҷ���)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatTKByMonCatRep_Loc.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		}
		return p_URL;
	}
	
	function QueryYearStkMon() {
		var ParamsObj = GetParamsObj();
		var StMonth = ParamsObj.StMonth;
		var EdMonth = ParamsObj.EdMonth;
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '��ѡ�����!');
			return;
		}
		if (isEmpty(ParamsObj.Year)) {
			$UI.msg('alert', '����д���!');
			return;
		}
		if ((!isEmpty(StMonth)) && (!isEmpty(EdMonth)) && compareDate(StMonth, EdMonth)) {
			$UI.msg('alert', '��ֹ�·ݲ���С�ڿ�ʼ�·�!');
			return;
		}
		var CheckedRadioObj = $("input[name='ReportType']:checked");
		var CheckedValue = CheckedRadioObj.val();
		var CheckedTitle = CheckedRadioObj.attr('label');
		var Url = CheckedUrl(CheckedValue);
		AddStatTab(CheckedTitle, Url, '#tabs');
	}
	Clear();
	GetReportStyle('#Report');
};
$(init);