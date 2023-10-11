// ����: �������μ۸�䶯ͳ��
var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		var DefaultData = {
			StartDate: DateFormatter(new Date()),
			EndDate: DateFormatter(new Date())
		};
		$UI.fillBlock('#Conditions', DefaultData);
		var Tabs = $('#tabs').tabs('tabs');
		var reportFrame = document.getElementById('IncDetailIFrame');
		reportFrame.src = '';
	};
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
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetStkCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});

	var HandlerParams = function() {
		var StkGrpId = $('#ScgStk').combotree('getValue');
		var Obj = { StkGrpRowId: StkGrpId, StkGrpType: 'M', Locdr: gLocId };
		return Obj;
	};
	$('#InciDesc').lookup(InciLookUpOp(HandlerParams, '#InciDesc', '#Inci'));
	var StockTypeBox = $HUI.combobox('#StockType', {
		data: [{ 'RowId': 0, 'Description': 'ȫ��' }, { 'RowId': 1, 'Description': '���Ϊ��' }, { 'RowId': 2, 'Description': '���Ϊ��' }, { 'RowId': 3, 'Description': '���Ϊ��' }, { 'RowId': 4, 'Description': '������' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
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
			var Params = JSON.stringify(addSessionParams(ParamsObj));
			Params = encodeUrlStr(Params);
			var Conditions = encodeUrlStr(GetConditions(ParamsObj));
			var p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_ItmBatRp.raq&Params=' + Params + '&Conditions=' + Conditions;
			var reportFrame = document.getElementById('IncDetailIFrame');
			reportFrame.src = CommonFillUrl(p_URL);
		}
	});
	function GetConditions(ParamsObj) {
		// ��ȡ��ѯ�����б�
		var Conditions = '';
		if (ParamsObj.StartDate != '') {
			Conditions = Conditions + ' ͳ��ʱ��: ' + ParamsObj.StartDate;
		}
		if (ParamsObj.EndDate != '') {
			Conditions = Conditions + '~ ' + ParamsObj.EndDate;
		}
		if (ParamsObj.ScgStk != '') {
			Conditions = Conditions + ' ����: ' + $('#ScgStk').combobox('getText');
		}
		if (ParamsObj.StkCat != '') {
			Conditions = Conditions + ' ������: ' + $('#StkCat').combobox('getText');
		}
		if (ParamsObj.MinRp != '') {
			Conditions = Conditions + ' ��ͽ���: ' + ParamsObj.MinRp;
		}
		if (ParamsObj.MaxRp != '') {
			Conditions = Conditions + ' ��߽���: ' + ParamsObj.MaxRp;
		}
		return Conditions;
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
