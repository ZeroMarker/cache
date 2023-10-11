// 名称: 月报年度统计(月报汇总)
// 编写日期: 20180813
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
			// 类组汇总(库存转移)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatByMonRep_Scg.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if ('StkCatStat' == Checked) {
			// 类组库存分类(库存转移)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatByMonRep_StkCat.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if ('InciRecRetStat' == Checked) {
			// 入库退货明细(按品种)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatByMonRep_Inci.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if ('OutLocStat' == Checked) {
			// 出库汇总(按科室)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatTKByMonRep_Loc.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if ('ScgCatStatCat' == Checked) {
			// 类组库存分类(分类)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatByMonCatRep.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		} else if ('OutLocStatCat' == Checked) {
			// 出库汇总(按科室分类)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_YearStatTKByMonCatRep_Loc.raq&PhaLoc=' + PhaLoc + '&Year=' + Year + '&StMonth=' + StMonth + '&EdMonth=' + EdMonth;
		}
		return p_URL;
	}
	
	function QueryYearStkMon() {
		var ParamsObj = GetParamsObj();
		var StMonth = ParamsObj.StMonth;
		var EdMonth = ParamsObj.EdMonth;
		if (isEmpty(ParamsObj.PhaLoc)) {
			$UI.msg('alert', '请选择科室!');
			return;
		}
		if (isEmpty(ParamsObj.Year)) {
			$UI.msg('alert', '请填写年份!');
			return;
		}
		if ((!isEmpty(StMonth)) && (!isEmpty(EdMonth)) && compareDate(StMonth, EdMonth)) {
			$UI.msg('alert', '截止月份不能小于开始月份!');
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