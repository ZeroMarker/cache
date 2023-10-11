var init = function() {
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
			// if(isEmpty(ParamsObj.PhaLoc)){
			//	$UI.msg("alert","科室不能为空!");
			//	return;
			// }
			// var Params=encodeURI(JSON.stringify(ParamsObj));
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '截止日期不能小于开始日期!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			Params = encodeUrlStr(Params);
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Url = CheckedUrl(CheckedValue, Params);
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	var HandlerParams = function() {
		var Obj = { StkGrpType: 'M' };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	function CheckedUrl(Checked, Params) {
		// 统计列表-按物资
		if ('FlagItmlist' == Checked) {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_DispStatAll_INCI_Common.raq&Params=' + Params;
		} else if ('FlagDocLoclist' == Checked) {
			// 统计列表-按医生科室
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_DispStatAll_DOCLOC_Common.raq&Params=' + Params;
		} else if ('FlagStkCatlist' == Checked) {
			// 统计列表-按库存分类
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_DispStatAll_STKCAT_Common.raq&Params=' + Params;
		} else if ('FlagAdmLoclist' == Checked) {
			// 统计列表-按患者科室
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_DispStatAll_AdmLoc.raq&Params=' + Params;
		} else if ('FlagRecLoclist' == Checked) {
			// 统计列表-按接收科室
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_DispStatAll_RecLoc.raq&Params=' + Params;
		} else if ('FlaglistDetail' == Checked) {
			// 统计列表详情
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_DispStatAll_INCI_Common_Detail.raq&Params=' + Params;
		} else if (Checked == 'FlagVendorSum') {
			// 供应商汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_DispStatAll_VendorSum.raq&Params=' + Params;
		}
		return p_URL;
	}
	
	/* --绑定控件--*/
	var CTHospBox = $HUI.combobox('#CTHosp', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetHosp&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		var DefaultValue = {
			StartDate: new Date(),
			EndDate: new Date()
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		CloseStatTab('#tabs');
	};
	Default();
	GetReportStyle('#Report');
};
$(init);