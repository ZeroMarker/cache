var init = function() {
	/* --按钮事件--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.PhaLoc)) {
				$UI.msg('alert', '出库科室不能为空!');
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
		if ('FlagLocStkcat' == Checked) {
			// 科室/库存分类
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-LocStkcat.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagLocStkcatCross' == Checked) {
			// 科室/库存分类交叉报表(进价)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-LocStkcatCross.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagLocScgCross' == Checked) {
			// 科室/类组交叉报表(进价)
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-LocScgCross.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagLoc' == Checked) {
			// 科室金额
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-Loc.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagLocGrp' == Checked) {
			// 科室金额/科室组
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-LocGrp.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagSum' == Checked) {
			// 单品汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-Sum.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagLocSum' == Checked) {
			// 科室单品汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-LocSum.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagDetail' == Checked) {
			// 出库明细
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-Detail.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagTrf' == Checked) {
			// 出库单汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-Trf.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagType' == Checked) {
			// 库存分类
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-Type.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagScg' == Checked) {
			// 类组汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-Scg.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagVendor' == Checked) {
			// 供应商库存分类
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-Vendor.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagVendorItm' == Checked) {
			// 供应商明细汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat-VendorItm.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagChargeSum' == Checked) {
			// 收费/不收费汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat_ChargeSum.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagBookCatSum' == Checked) {
			// 账簿分类汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat_BookCatSum.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagDetailTop' == Checked) {
			// 单品金额前十
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat_DetailTop.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagLocAmtTop' == Checked) {
			// 科室金额前二十
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat_LocAmtTop.raq&Params=' + Params + '&Conditions=' + Conditions;
		} else if ('FlagQtyTop' == Checked) {
			// 单品数量前二十
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TransferOutStat_DetailQtyTop.raq&Params=' + Params + '&Conditions=' + Conditions;
		}
		return p_URL;
	}
	function GetConditions(ParamsObj) {
		// 获取查询条件列表
		var Conditions = '';
		if (ParamsObj.Loc != '') {
			Conditions = Conditions + '出库科室: ' + $('#PhaLoc').combobox('getText');
		}
		if (ParamsObj.StartDate != '') {
			Conditions = Conditions + ' 统计时间: ' + ParamsObj.StartDate + ' ' + ParamsObj.StartTime;
		}
		if (ParamsObj.EndDate != '') {
			Conditions = Conditions + '~ ' + ParamsObj.EndDate + ' ' + ParamsObj.EndTime;
		}
		if (ParamsObj.TransferFlag != '') {
			Conditions = Conditions + ' 统计方式: ' + $('#TransferFlag').combobox('getText');
		}
		if (ParamsObj.TransRange != '') {
			Conditions = Conditions + ' 科室范围: ' + $('#TransRange').combobox('getText');
		}
		if (ParamsObj.RecLoc != '') {
			Conditions = Conditions + ' 接收科室: ' + $('#RecLoc').combobox('getText');
		}
		if (ParamsObj.LocGroup != '') {
			Conditions = Conditions + ' 科室组: ' + $('#LocGroup').combobox('getText');
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
		if (ParamsObj.SourceOfFund != '') {
			Conditions = Conditions + ' 资金来源: ' + $('#SourceOfFund').combobox('getText');
		}
		if (ParamsObj.Vendor != '') {
			Conditions = Conditions + ' 供应商: ' + $('#Vendor').combobox('getText');
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
		if (ParamsObj.GiftFlag == 'Y') {
			Conditions = Conditions + ' 捐赠: 是';
		} else if (ParamsObj.GiftFlag == 'N') {
			Conditions = Conditions + ' 捐赠: 否';
		} else if (ParamsObj.GiftFlag == '') {
			Conditions = Conditions + ' 捐赠: 全部';
		}
		return Conditions;
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Default();
		}
	});
	
	/* --绑定控件--*/
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'Login', Element: 'PhaLoc' }));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var RecLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'RecLoc' }));
	var RecLocBox = $HUI.combobox('#RecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var TransferFlagBox = $HUI.combobox('#TransferFlag', {
		data: [{ 'RowId': '0', 'Description': '转出转入' }, { 'RowId': '1', 'Description': '转出' }, { 'RowId': '2', 'Description': '转入' }],	//, {'RowId':'3','Description':'高值转入补录'}
		valueField: 'RowId',
		textField: 'Description'
	});
	var TransRangeBox = $HUI.combobox('#TransRange', {
		data: [{ 'RowId': '0', 'Description': '全部科室' }, { 'RowId': '1', 'Description': '科室组内部' }, { 'RowId': '2', 'Description': '科室组外部' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var LocGroupBox = $HUI.combobox('#LocGroup', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SourceOfFundBox = $HUI.combobox('#SourceOfFund', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var CreateUserIdParams = JSON.stringify(addSessionParams({
		UseAllUserAsPur: 'Y'
	}));
	var CreateUserIdBox = $HUI.combobox('#CreateUserId', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocPPLUser&ResultSetType=array&Params=' + CreateUserIdParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HandlerParams = function() {
		var Scg = $('#ScgStk').combotree('getValue');
		var Loc = $('#PhaLoc').combo('getValue');
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
	var ManfBox = $HUI.combobox('#Manf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HvFlagBox = $HUI.combobox('#HvFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '高值' }, { 'RowId': 'N', 'Description': '非高值' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeFlagBox = $HUI.combobox('#ChargeFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '收费' }, { 'RowId': 'N', 'Description': '不收费' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var PHCDOfficialTypeBox = $HUI.combobox('#PHCDOfficialType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInsuCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var INFOMTBox = $HUI.combobox('#INFOMT', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetMarkType&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var OperateOutTypeParams = JSON.stringify(addSessionParams({ Type: 'OM' }));
	var OperateOutTypeBox = $HUI.combobox('#OperateOutType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params=' + OperateOutTypeParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var INFOPBLevelBox = $HUI.combobox('#INFOPBLevel', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPBLevel&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var INFOImportFlagBox = $HUI.combobox('#INFOImportFlag', {
		data: [{ 'RowId': '国产', 'Description': '国产' }, { 'RowId': '进口', 'Description': '进口' }, { 'RowId': '合资', 'Description': '合资' }],
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
			// PhaLoc:gLocObj,
			TransferFlag: '0',
			TransRange: '0'
		};
		$UI.fillBlock('#Conditions', DefaultValue);
		$('#PhaLoc').combobox('setValue', gLocId);
		CloseStatTab('#tabs');
	};
	Default();
	tableTabClose();
	tableTabCloseEven();
	GetReportStyle('#Report');
};
$(init);