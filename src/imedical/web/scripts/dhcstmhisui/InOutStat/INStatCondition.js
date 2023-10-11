var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.Loc)) {
				$UI.msg('alert', '入库科室不能为空!');
				return;
			}
			if (isEmpty(StartDate)) {
				$UI.msg('alert', '开始日期不能为空!');
				return;
			}
			if (isEmpty(EndDate)) {
				$UI.msg('alert', '截止日期不能为空!');
				return;
			}
			if (compareDate(StartDate, EndDate)) {
				$UI.msg('alert', '截止日期不能小于开始日期!');
				return;
			}
			if ((StartDate == EndDate) && (ParamsObj.StartTime > ParamsObj.EndTime)) {
				$UI.msg('alert', '截止时间不能小于开始时间!');
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
		var ReportName = '';
		if ('FlagImportDetail' == Checked) {
			// 单据明细
			ReportName = 'DHCSTM_HUI_importdetail.raq';
		} else if ('FlagImportGroupDetail' == Checked) {
			// 单据单品汇总
			ReportName = 'DHCSTM_HUI_importgroupdetail.raq';
		} else if ('FlagItmStat' == Checked) {
			// 单品汇总
			ReportName = 'DHCSTM_HUI_importitmstat.raq';
		} else if ('FlagItmBatStat' == Checked) {
			// 单品批次汇总
			ReportName = 'DHCSTM_HUI_importitmbatstat.raq';
		} else if ('FlagVendorStat' == Checked) {
			// 供应商汇总
			ReportName = 'DHCSTM_HUI_importvendorstat.raq';
		} else if ('FlagVendorItmStat' == Checked) {
			// 供应商明细汇总
			ReportName = 'DHCSTM_HUI_importvendoitmrstat.raq';
		} else if ('FlagVendorStkcatCross' == Checked) {
			// 供应商/库存分类
			ReportName = 'DHCSTM_HUI_importvendorstkcatcross.raq';
		} else if ('FlagVendorInvList' == Checked) {
			// 供应商发票
			ReportName = 'DHCSTM_HUI_importVendorInvList.raq';
		} else if ('FlagStkGrpStat' == Checked) {
			// 类组汇总
			ReportName = 'DHCSTM_HUI_importstkgrpstat.raq';
		} else if ('FlagStockStat' == Checked) {
			// 库存分类汇总
			ReportName = 'DHCSTM_HUI_importstockstat.raq';
		} else if ('FlagRecItmSumStat' == Checked) {
			// 单据汇总
			ReportName = 'DHCSTM_HUI_importrecitmsumstat.raq';
		} else if ('FlagSourceOfFundStat' == Checked) {
			// 资金来源汇总
			ReportName = 'DHCSTM_HUI_sourceoffundstat.raq';
		} else if ('FlagVendor2InvList' == Checked) {
			// 供应商发票单据汇总
			ReportName = 'DHCSTM_HUI_VendorRecInvNoDetailStat.raq';
		}
		var p_URL = PmRunQianUrl + '?reportName=' + ReportName + '&Params=' + Params + '&Conditions=' + Conditions;
		return p_URL;
	}
	function GetConditions(ParamsObj) {
		// 获取查询条件列表
		var Conditions = '';
		if (ParamsObj.Loc != '') {
			Conditions = '入库科室: ' + $('#Loc').combobox('getText');
		}
		if (ParamsObj.StartDate != '') {
			Conditions = Conditions + ' 统计时间: ' + ParamsObj.StartDate + ' ' + ParamsObj.StartTime;
		}
		if (ParamsObj.EndDate != '') {
			Conditions = Conditions + '~ ' + ParamsObj.EndDate + ' ' + ParamsObj.EndTime;
		}
		if (ParamsObj.Vendor != '') {
			Conditions = Conditions + ' 供应商: ' + $('#Vendor').combobox('getText');
		}
		if (ParamsObj.ScgStk != '') {
			Conditions = Conditions + ' 类组: ' + $('#ScgStk').combobox('getText');
		}
		if (ParamsObj.StkCat != '') {
			Conditions = Conditions + ' 库存分类: ' + $('#StkCat').combobox('getText');
		}
		if (ParamsObj.Manf != '') {
			Conditions = Conditions + ' 生产厂家: ' + $('#Manf').combobox('getText');
		}
		if (ParamsObj.InciDesc != '') {
			Conditions = Conditions + ' 物资: ' + ParamsObj.InciDesc;
		}
		if (ParamsObj.OperateType != '') {
			Conditions = Conditions + ' 入库类型: ' + $('#OperateType').combobox('getText');
		}
		if (ParamsObj.InvNo != '') {
			Conditions = Conditions + ' 发票号: ' + ParamsObj.InvNo;
		}
		if (ParamsObj.HvFlag == 'Y') {
			Conditions = Conditions + ' 高值: 是';
		} else if (ParamsObj.HvFlag == 'N') {
			Conditions = Conditions + ' 高值: 否';
		} else if (ParamsObj.HvFlag == '') {
			Conditions = Conditions + ' 高值: 全部';
		}
		if (ParamsObj.ChargeFlag == 'Y') {
			Conditions = Conditions + ' 收费: 是';
		} else if (ParamsObj.ChargeFlag == 'N') {
			Conditions = Conditions + ' 收费: 否';
		} else if (ParamsObj.ChargeFlag == '') {
			Conditions = Conditions + ' 收费: 全部';
		}
		if (Conditions.RetFlag != '') {
			Conditions = Conditions + ' 统计方式: ' + $('#RetFlag').combobox('getText');
		}
		if (ParamsObj.SourceOfFund != '') {
			Conditions = Conditions + ' 资金来源: ' + $('#SourceOfFund').combobox('getText');
		}
		return Conditions;
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	
	var LocParams = JSON.stringify(addSessionParams({ Type: 'Login', Element: 'Loc' }));
	$HUI.combobox('#Loc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + LocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#RetFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': '1', 'Description': '入库' }, { 'RowId': '2', 'Description': '退货' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	$HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#SourceOfFund', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Scg = $('#ScgStk').combotree('getValue');
		var Loc = $('#Loc').combo('getValue');
		var Obj = { StkGrpRowId: Scg, StkGrpType: 'M', Locdr: Loc };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#ScgStk').combotree({
		separator: '^',
		onChange: function(newValue, oldValue) {
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + newValue;
			StkCatBox.reload(url);
		}
	});
	var ManfParams = JSON.stringify(addSessionParams({ StkType: 'M' }));
	$HUI.combobox('#Manf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#HvFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '高值' }, { 'RowId': 'N', 'Description': '非高值' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeFlagBox = $HUI.combobox('#ChargeFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '收费' }, { 'RowId': 'N', 'Description': '不收费' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#AdjCheque', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'G', 'Description': '赠送' }, { 'RowId': 'A', 'Description': '调价换票' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var OperateParams = JSON.stringify(addSessionParams({ Type: 'IM' }));
	$HUI.combobox('#OperateType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params=' + OperateParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 68分类
	var Official = $HUI.combotree('#Official', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&MethodName=GetMCOChildNode&NodeId=AllMCO&Params=' + gHospId,
		valueField: 'id',
		textField: 'text',
		editable: true
	});
	$('#Official').parent().find('.combo-text').blur(function() {
		$('#Official').combotree('clear');
	});
	var ClinicalCatlParams = JSON.stringify(addSessionParams());
	/*
	$HUI.lookup('#ClinicalCat', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.Common.Dicts',
			QueryName: 'GetClinicCat',
			Params: ClinicalCatlParams,
			rows: 9999
		}
	});
	*/
	var ClinicalCat = $HUI.combobox('#ClinicalCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetClinicCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			ClinicalCat.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetClinicCat&ResultSetType=array&Params=' + Params;
			ClinicalCat.reload(url);
		}
	});
	function tableTabClose() {
	/* 双击关闭TAB选项卡*/
		$('#tabs').dblclick(function() {
			var subtitle = $('#tabs').tabs('getSelected').panel('options').title;
			$('#tabs').tabs('close', subtitle);
		});
		$('#tabs').on('contextmenu', function(e) {
			e.preventDefault();
			$('#tabmm').menu('show', {
				left: e.pageX,
				top: e.pageY
			});
			var subtitle = $('#tabs').tabs('getSelected').panel('options').title;
			$('#tabmm').data('currtab', subtitle);
			return false;
		});
	}
	// 绑定右键菜单事件
	function tableTabCloseEven() {
	// 关闭当前
		$('#tabmm-tabclose').click(function() {
			var currtab_title = $('#tabmm').data('currtab');
			$('#tabs').tabs('close', currtab_title);
		});
		// 全部关闭
		$('#tabmm-tabcloseall').click(function() {
			$('.tabs-inner span').each(function(i, n) {
				var t = $(n).text();
				if (t != '报表') {
					$('#tabs').tabs('close', t);
				}
			});
		});
		// 关闭除当前之外的TAB
		$('#tabmm-tabcloseother').click(function() {
			var currtab_title = $('#tabmm').data('currtab');
			$('.tabs-inner span').each(function(i, n) {
				var t = $(n).text();
				if (t != currtab_title)
					if (t != '报表') {
						$('#tabs').tabs('close', t);
					}
			});
		});
		// 关闭当前右侧的TAB
		$('#tabmm-tabcloseright').click(function() {
			var nextall = $('.tabs-selected').nextAll();
			if (nextall.length == 0) {
				$UI.msg('alert', '右侧没有了!');
				return false;
			}
			nextall.each(function(i, n) {
				var t = $('a:eq(0) span', $(n)).text();
				if (t != '报表') {
					$('#tabs').tabs('close', t);
				}
			});
			return false;
		});
		// 关闭当前左侧的TAB
		$('#tabmm-tabcloseleft').click(function() {
			var prevall = $('.tabs-selected').prevAll();
			if (prevall.length == 0) {
				$UI.msg('alert', '左侧没有了!');
				return false;
			}
			prevall.each(function(i, n) {
				var t = $('a:eq(0) span', $(n)).text();
				if (t != '报表') {
					$('#tabs').tabs('close', t);
				}
			});
			return false;
		});
	}
	
	/* --设置初始值--*/
	var Default = function() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#ReportConditions');
		var DefaultValue = {
			StartDate: DefaultStDate(),
			EndDate: DefaultEdDate(),
			// Loc:gLocObj,
			RetFlag: ''
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		$('#Loc').combobox('setValue', gLocId);
		CloseStatTab('#tabs');
	};
	Default();
	tableTabClose();
	tableTabCloseEven();
	GetReportStyle('#Report');
};
$(init);