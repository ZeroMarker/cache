// 名称: 全院库存查询

var init = function() {
	var Clear = function() {
		$UI.clearBlock('#Conditions');
		var DefaultData = { StartDate: DateFormatter(new Date()),
			// PhaLoc:gLocObj,
			StockType: 4
		};
		$UI.fillBlock('#Conditions', DefaultData);
		CloseStatTab('#tabs');
	};
	var PhaLocParams = JSON.stringify(addSessionParams({ Type: 'All' }));
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
	var VendorParams = JSON.stringify(addSessionParams({ APCType: 'M' }));
	var VendorBox = $HUI.combobox('#Vendor', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetVendor&ResultSetType=array&Params=' + VendorParams,
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
	var ManfParams = JSON.stringify(addSessionParams({ StkType: 'M' }));
	var ManfBox = $HUI.combobox('#Manf', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPhManufacturer&ResultSetType=array&Params=' + ManfParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var ARCItemCatBox = $HUI.combobox('#ARCItemCatBox', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetOrdSubCat&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	var InsuTypeParams = JSON.stringify(addSessionParams());
	var InsuTypeBox = $HUI.combobox('#InsuType', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetInsuCat&ResultSetType=array&Params=' + InsuTypeParams,
		valueField: 'RowId',
		textField: 'Description'
	});
	var StockTypeBox = $HUI.combobox('#StockType', {
		data: [{ 'RowId': '0', 'Description': '全部' }, { 'RowId': '1', 'Description': '库存为零' }, { 'RowId': '2', 'Description': '库存为正' }, { 'RowId': '3', 'Description': '库存为负' }, { 'RowId': '4', 'Description': '库存非零', 'selected': true }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var INFOImportFlagBox = $HUI.combobox('#INFOImportFlag', {
		data: [{ 'RowId': '全部', 'Description': '全部' }, { 'RowId': '国产', 'Description': '国产' }, { 'RowId': '进口', 'Description': '进口' }, { 'RowId': '合资', 'Description': '合资' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var UseFlagBox = $HUI.combobox('#UseFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '可用' }, { 'RowId': 'N', 'Description': '不可用' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var HVFlagBox = $HUI.combobox('#HVFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '高值' }, { 'RowId': 'N', 'Description': '非高值' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var ChargeFlagBox = $HUI.combobox('#ChargeFlag', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'Y', 'Description': '收费' }, { 'RowId': 'N', 'Description': '不收费' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var SupervisionBox = $HUI.combobox('#Supervision', {
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'I', 'Description': 'I' }, { 'RowId': 'II', 'Description': 'II' }, { 'RowId': 'III', 'Description': 'III' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	var LocGroupBox = $HUI.combobox('#LocGroup', {
		url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=array',
		valueField: 'RowId',
		textField: 'Description'
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			if (isEmpty(ParamsObj.StartDate)) {
				$UI.msg('alert', '日期不能为空!');
				return;
			}
			if (isEmpty(ParamsObj.StockType)) {
				$UI.msg('alert', '类型不能为空!');
				return;
			}
			var Params = JSON.stringify(ParamsObj);
			Params = encodeUrlStr(Params);
			var StartDate = ParamsObj.StartDate;
			var CheckedRadioObj = $("input[name='ReportType']:checked");
			var CheckedValue = CheckedRadioObj.val();
			var CheckedTitle = CheckedRadioObj.attr('label');
			var Url = CheckedUrl(CheckedValue, Params, StartDate);
			AddStatTab(CheckedTitle, Url, '#tabs');
		}
	});
	
	function CheckedUrl(Checked, Params, StartDate) {
		if ('FlagInclb' == Checked) {
			// 批次明细
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocItmStkAll_Inclb.raq&Params=' + Params + '&stkDate=' + StartDate;
		} else if ('FlagInci' == Checked) {
			// 单品汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocItmStkAll_Inci.raq&Params=' + Params + '&stkDate=' + StartDate;
		} else if ('FlagIncil' == Checked) {
			// 单品科室汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocItmStkAll_Incil.raq&Params=' + Params + '&stkDate=' + StartDate;
		} else if ('FlagLocSum' == Checked) {
			// 科室汇总
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocItmStkAll_LocSum.raq&Params=' + Params + '&stkDate=' + StartDate;
		} else if ('FlagHighValue' == Checked) {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocItmStkAllHV_LocSum.raq&Params=' + Params + '&stkDate=' + StartDate;
		} else if ('FlagLocGroupDetail' == Checked) {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocItmStkAll_LocGroupDetail.raq&Params=' + Params + '&stkDate=' + StartDate;
		} else {
			p_URL = PmRunQianUrl + '?reportName=DHCSTM_HUI_LocItmStkAll_Inci.raq&Params=' + Params + '&stkDate=' + StartDate;
		}
		
		return p_URL;
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	Clear();
};
$(init);