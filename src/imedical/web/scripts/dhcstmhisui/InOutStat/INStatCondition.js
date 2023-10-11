var init = function() {
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.Loc)) {
				$UI.msg('alert', '�����Ҳ���Ϊ��!');
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
			if ((StartDate == EndDate) && (ParamsObj.StartTime > ParamsObj.EndTime)) {
				$UI.msg('alert', '��ֹʱ�䲻��С�ڿ�ʼʱ��!');
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
			// ������ϸ
			ReportName = 'DHCSTM_HUI_importdetail.raq';
		} else if ('FlagImportGroupDetail' == Checked) {
			// ���ݵ�Ʒ����
			ReportName = 'DHCSTM_HUI_importgroupdetail.raq';
		} else if ('FlagItmStat' == Checked) {
			// ��Ʒ����
			ReportName = 'DHCSTM_HUI_importitmstat.raq';
		} else if ('FlagItmBatStat' == Checked) {
			// ��Ʒ���λ���
			ReportName = 'DHCSTM_HUI_importitmbatstat.raq';
		} else if ('FlagVendorStat' == Checked) {
			// ��Ӧ�̻���
			ReportName = 'DHCSTM_HUI_importvendorstat.raq';
		} else if ('FlagVendorItmStat' == Checked) {
			// ��Ӧ����ϸ����
			ReportName = 'DHCSTM_HUI_importvendoitmrstat.raq';
		} else if ('FlagVendorStkcatCross' == Checked) {
			// ��Ӧ��/������
			ReportName = 'DHCSTM_HUI_importvendorstkcatcross.raq';
		} else if ('FlagVendorInvList' == Checked) {
			// ��Ӧ�̷�Ʊ
			ReportName = 'DHCSTM_HUI_importVendorInvList.raq';
		} else if ('FlagStkGrpStat' == Checked) {
			// �������
			ReportName = 'DHCSTM_HUI_importstkgrpstat.raq';
		} else if ('FlagStockStat' == Checked) {
			// ���������
			ReportName = 'DHCSTM_HUI_importstockstat.raq';
		} else if ('FlagRecItmSumStat' == Checked) {
			// ���ݻ���
			ReportName = 'DHCSTM_HUI_importrecitmsumstat.raq';
		} else if ('FlagSourceOfFundStat' == Checked) {
			// �ʽ���Դ����
			ReportName = 'DHCSTM_HUI_sourceoffundstat.raq';
		} else if ('FlagVendor2InvList' == Checked) {
			// ��Ӧ�̷�Ʊ���ݻ���
			ReportName = 'DHCSTM_HUI_VendorRecInvNoDetailStat.raq';
		}
		var p_URL = PmRunQianUrl + '?reportName=' + ReportName + '&Params=' + Params + '&Conditions=' + Conditions;
		return p_URL;
	}
	function GetConditions(ParamsObj) {
		// ��ȡ��ѯ�����б�
		var Conditions = '';
		if (ParamsObj.Loc != '') {
			Conditions = '������: ' + $('#Loc').combobox('getText');
		}
		if (ParamsObj.StartDate != '') {
			Conditions = Conditions + ' ͳ��ʱ��: ' + ParamsObj.StartDate + ' ' + ParamsObj.StartTime;
		}
		if (ParamsObj.EndDate != '') {
			Conditions = Conditions + '~ ' + ParamsObj.EndDate + ' ' + ParamsObj.EndTime;
		}
		if (ParamsObj.Vendor != '') {
			Conditions = Conditions + ' ��Ӧ��: ' + $('#Vendor').combobox('getText');
		}
		if (ParamsObj.ScgStk != '') {
			Conditions = Conditions + ' ����: ' + $('#ScgStk').combobox('getText');
		}
		if (ParamsObj.StkCat != '') {
			Conditions = Conditions + ' ������: ' + $('#StkCat').combobox('getText');
		}
		if (ParamsObj.Manf != '') {
			Conditions = Conditions + ' ��������: ' + $('#Manf').combobox('getText');
		}
		if (ParamsObj.InciDesc != '') {
			Conditions = Conditions + ' ����: ' + ParamsObj.InciDesc;
		}
		if (ParamsObj.OperateType != '') {
			Conditions = Conditions + ' �������: ' + $('#OperateType').combobox('getText');
		}
		if (ParamsObj.InvNo != '') {
			Conditions = Conditions + ' ��Ʊ��: ' + ParamsObj.InvNo;
		}
		if (ParamsObj.HvFlag == 'Y') {
			Conditions = Conditions + ' ��ֵ: ��';
		} else if (ParamsObj.HvFlag == 'N') {
			Conditions = Conditions + ' ��ֵ: ��';
		} else if (ParamsObj.HvFlag == '') {
			Conditions = Conditions + ' ��ֵ: ȫ��';
		}
		if (ParamsObj.ChargeFlag == 'Y') {
			Conditions = Conditions + ' �շ�: ��';
		} else if (ParamsObj.ChargeFlag == 'N') {
			Conditions = Conditions + ' �շ�: ��';
		} else if (ParamsObj.ChargeFlag == '') {
			Conditions = Conditions + ' �շ�: ȫ��';
		}
		if (Conditions.RetFlag != '') {
			Conditions = Conditions + ' ͳ�Ʒ�ʽ: ' + $('#RetFlag').combobox('getText');
		}
		if (ParamsObj.SourceOfFund != '') {
			Conditions = Conditions + ' �ʽ���Դ: ' + $('#SourceOfFund').combobox('getText');
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
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': '1', 'Description': '���' }, { 'RowId': '2', 'Description': '�˻�' }],
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
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'Y', 'Description': '��ֵ' }, { 'RowId': 'N', 'Description': '�Ǹ�ֵ' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeFlagBox = $HUI.combobox('#ChargeFlag', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'Y', 'Description': '�շ�' }, { 'RowId': 'N', 'Description': '���շ�' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	$HUI.combobox('#AdjCheque', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'G', 'Description': '����' }, { 'RowId': 'A', 'Description': '���ۻ�Ʊ' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var OperateParams = JSON.stringify(addSessionParams({ Type: 'IM' }));
	$HUI.combobox('#OperateType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOperateType&ResultSetType=array&Params=' + OperateParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	// 68����
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
	/* ˫���ر�TABѡ�*/
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
	// ���Ҽ��˵��¼�
	function tableTabCloseEven() {
	// �رյ�ǰ
		$('#tabmm-tabclose').click(function() {
			var currtab_title = $('#tabmm').data('currtab');
			$('#tabs').tabs('close', currtab_title);
		});
		// ȫ���ر�
		$('#tabmm-tabcloseall').click(function() {
			$('.tabs-inner span').each(function(i, n) {
				var t = $(n).text();
				if (t != '����') {
					$('#tabs').tabs('close', t);
				}
			});
		});
		// �رճ���ǰ֮���TAB
		$('#tabmm-tabcloseother').click(function() {
			var currtab_title = $('#tabmm').data('currtab');
			$('.tabs-inner span').each(function(i, n) {
				var t = $(n).text();
				if (t != currtab_title)
					if (t != '����') {
						$('#tabs').tabs('close', t);
					}
			});
		});
		// �رյ�ǰ�Ҳ��TAB
		$('#tabmm-tabcloseright').click(function() {
			var nextall = $('.tabs-selected').nextAll();
			if (nextall.length == 0) {
				$UI.msg('alert', '�Ҳ�û����!');
				return false;
			}
			nextall.each(function(i, n) {
				var t = $('a:eq(0) span', $(n)).text();
				if (t != '����') {
					$('#tabs').tabs('close', t);
				}
			});
			return false;
		});
		// �رյ�ǰ����TAB
		$('#tabmm-tabcloseleft').click(function() {
			var prevall = $('.tabs-selected').prevAll();
			if (prevall.length == 0) {
				$UI.msg('alert', '���û����!');
				return false;
			}
			prevall.each(function(i, n) {
				var t = $('a:eq(0) span', $(n)).text();
				if (t != '����') {
					$('#tabs').tabs('close', t);
				}
			});
			return false;
		});
	}
	
	/* --���ó�ʼֵ--*/
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