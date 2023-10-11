// TKPY̨��ͳ�ƻ���
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		var DefaultData = {
			StartDate: new Date(),
			EndDate: new Date(),
			PhaLoc: gLocObj,
			Ways: 0
		};
		$UI.fillBlock('#Conditions', DefaultData);
		CloseStatTab('#tabs');
	};
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'PhaLoc' }));
	var PhaLocBox = $HUI.combobox('#PhaLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + PhaLocParams,
		valueField: 'RowId',
		textField: 'Description',
		onSelect: function(record) {
			var LocId = record['RowId'];
			$HUI.combotree('#ScgStk').setFilterByLoc(LocId);
			if (CommParObj.ApcScg == 'L') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M', LocId: LocId }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params;
				VendorBox.reload(url);
			}
		}
	});
	var RecLocParams = JSON.stringify(addSessionParams({ Type: 'All', Element: 'RecLoc' }));
	var RecLocBox = $HUI.combobox('#RecLoc', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array&Params=' + RecLocParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var WaysBox = $HUI.combobox('#Ways', {
		data: [{ 'RowId': '0', 'Description': 'ȫ��' }, { 'RowId': '1', 'Description': 'ת��ת��̨��' }, { 'RowId': '2', 'Description': 'ҽ��̨��' }, { 'RowId': '3', 'Description': 'ȫ��(���ڳ�������)' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var SourceOfFundParams = JSON.stringify(addSessionParams());
	var SourceOfFundBox = $HUI.combobox('#SourceOfFund', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetSourceOfFund&ResultSetType=array&Params=' + SourceOfFundParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	$('#ScgStk').stkscgcombotree({
		onSelect: function(node) {
			$.cm({
				ClassName: 'web.DHCSTMHUI.Common.Dicts',
				QueryName: 'GetStkCat',
				ResultSetType: 'array',
				StkGrpId: node.id
			}, function(data) {
				StkCatBox.clear();
				StkCatBox.loadData(data);
			});
			if (CommParObj.ApcScg == 'S') {
				VendorBox.clear();
				var Params = JSON.stringify(addSessionParams({ APCType: 'M' }));
				var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + Params + '&ScgId=' + node.id ;
				VendorBox.reload(url);
			}
		}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
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
	$('#ScgStk').combotree({
		onChange: function(newValue, oldValue) {
			StkCatBox.clear();
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array&StkGrpId=' + newValue;
			StkCatBox.reload(url);
		}
	});
	var StkCatBox = $HUI.combobox('#StkCat', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var ManfParams = JSON.stringify(addSessionParams({ StkType: 'M' }));
	var ManfBox = $HUI.combobox('#Manf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var HvFlagBox = $HUI.combobox('#HvFlag', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'Y', 'Description': '��ֵ' }, { 'RowId': 'N', 'Description': '�Ǹ�ֵ' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeFlagBox = $HUI.combobox('#ChargeFlag', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'Y', 'Description': '�շ�' }, { 'RowId': 'N', 'Description': '���շ�' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var INFOImportFlagBox = $HUI.combobox('#INFOImportFlag', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': '����', 'Description': '����' }, { 'RowId': '����', 'Description': '����' }, { 'RowId': '����', 'Description': '����' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var PublicBiddingBox = $HUI.combobox('#PublicBidding', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'N', 'Description': '���б�' }, { 'RowId': 'Y', 'Description': '�б�' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var PBLevelParams = JSON.stringify(addSessionParams());
	var INFOPBLevelBox = $HUI.combobox('#INFOPBLevel', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPBLevel&ResultSetType=array&Params=' + PBLevelParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var InsuTypeBox = $HUI.combobox('#InsuType', {
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
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			var StartDate = ParamsObj.StartDate;
			var EndDate = ParamsObj.EndDate;
			if (isEmpty(ParamsObj.PhaLoc)) {
				$UI.msg('alert', '������Ҳ���Ϊ��!');
				return;
			}
			if (isEmpty(ParamsObj.RecLoc)) {
				$UI.msg('alert', 'ҽ�����Ҳ���Ϊ��!');
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
			var Url = CheckedUrl(CheckedValue, Params);
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	function CheckedUrl(Checked, Params) {
		// ��Ʒ����
		if ('FlagSum' == Checked) {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TKPYStat_Sum.raq&Params=' + Params;
		}
		// �����൥Ʒ����
		else if ('FlagStkCatInci' == Checked) {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TKPYStat_StkCatInci.raq&Params=' + Params;
		}
		// ��Ʒ��ϸ
		else if ('FlagDetail' == Checked) {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TKPYStat_InciDetail.raq&Params=' + Params;
		}
		// ���������
		else if ('FlagType' == Checked) {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TKPYStat_StkCat.raq&Params=' + Params;
		} else {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_TKPYStat_Sum.raq&Params=' + Params;
		}

		return p_URL;
	}

	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	Clear();
	GetReportStyle('#Report');
};
$(init);