var init = function() {
	var HospId = gHospId;
	var TableName = 'CT_Loc';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		}
	}
	var lastyear = new Date().getFullYear() - 1;
	var nowyear = new Date().getFullYear();
	var nextyear = new Date().getFullYear() + 1;
	
	/* --按钮事件--*/
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		$UI.clear(LocLimitGrid);
		$UI.clear(StkScgLimitGrid);
		$UI.clear(StkCatLimitGrid);
		$UI.clear(InciLimitGrid);
		
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('#Conditions');
		if (isEmpty(Paramsobj.Year)) {
			$UI.msg('alert', '请选择年份!');
			return;
		}
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		LocLimitGrid.load({
			ClassName: 'web.DHCSTMHUI.LocLimitAmt',
			QueryName: 'QueryLocLimit',
			query2JsonStrict: 1,
			Params: Params,
			rows: 99999
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clearBlock('#InciTB');
		$UI.clear(LocLimitGrid);
		$UI.clear(StkScgLimitGrid);
		$UI.clear(StkCatLimitGrid);
		$UI.clear(InciLimitGrid);
		$('#Year').combobox('select', nowyear);
		Query();
	}
	
	$UI.linkbutton('#UpdatePeriodBT', {
		onClick: function() {
			var ParamsObj = $UI.loopBlock('#Conditions');
			if (isEmpty(ParamsObj.Year)) {
				$UI.msg('alert', '请选择年份!');
				return;
			}
			if (ParamsObj.Year < new Date().getFullYear()) {
				$UI.msg('alert', '不能生成本年之前的数据!');
				return;
			}
			if (isEmpty(ParamsObj.PeriodType)) {
				$UI.msg('alert', '请选择统计周期!');
				return;
			}
			var Msg = '即将批量设置科室科室定额信息，确认更新？';
			
			$UI.confirm(Msg, 'warning', '', UpdatePeriod, '', '', '警告', false, ParamsObj);
		}
	});

	function UpdatePeriod(ParamsObj) {
		var ParamsObj = jQuery.extend(true, ParamsObj, { BDPHospital: HospId });
		var Params = JSON.stringify(ParamsObj);
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.LocLimitAmt',
			MethodName: 'jsUpdatePeriod',
			Params: Params
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function LocSave() {
		if (!LocLimitGrid.endEditing()) {
			return;
		}
		var DetailObj = LocLimitGrid.getChangesData('LocId');
		if (DetailObj === false) { return; }
		if (isEmpty(DetailObj)) {
			$UI.msg('alert', '没有需要保存的信息!');
			return;
		}
		showMask();
		var Detail = JSON.stringify(DetailObj);
		$.cm({
			ClassName: 'web.DHCSTMHUI.LocLimitAmt',
			MethodName: 'jsSave',
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				Query();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	function CheckDetail(LocRow, Type) {
		if (isEmpty(LocRow)) {
			$UI.msg('alert', '请选择左侧要保存的科室!');
			return false;
		} else if (isEmpty(LocRow.RowId)) {
			$UI.msg('alert', '请先维护左侧科室信息!');
			return false;
		}
		if (Type == 3) {
			if (!InciLimitGrid.endEditing()) {
				return false;
			}
			var Rows = InciLimitGrid.getRows();
			for (var i = 0; i < Rows.length; i++) {
				var row = Rows[i];
				var OnceReqQty = row.OnceReqQty;
				var ReqQty = row.ReqQty;
				if ((!isEmpty(OnceReqQty)) && (!isEmpty(ReqQty))) {
					if (Number(OnceReqQty) > Number(ReqQty)) {
						$UI.msg('alert', '第' + (i + 1) + '行单次限领数量大于单品限领数量');
						return false;
					}
				}
			}
		}
		return true;
	}
	
	function LimitDetailSave(Type) {
		var Row = LocLimitGrid.getSelected();
		if (!CheckDetail(Row, Type)) {
			return;
		}
		Row.LimitType = Type;
		var Params = JSON.stringify(addSessionParams(Row));
		
		var DetailObj = {};
		if (Type == 1) {
			DetailObj = StkScgLimitGrid.getChangesData();
		} else if (Type == 2) {
			DetailObj = StkCatLimitGrid.getChangesData();
		} else if (Type == 3) {
			DetailObj = InciLimitGrid.getChangesData();
		}
		if (DetailObj === false) { return; }
		if (isEmpty(DetailObj)) {
			$UI.msg('alert', '没有需要保存的信息!');
			return;
		}
		var Detail = JSON.stringify(DetailObj);
		
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.LocLimitAmt',
			MethodName: 'jsSaveDetail',
			Main: Params,
			Detail: Detail
		}, function(jsonData) {
			hideMask();
			if (jsonData.success == 0) {
				$UI.msg('success', jsonData.msg);
				QueryDetail();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	
	$UI.linkbutton('#InciSave', {
		onClick: function() {
			LimitDetailSave(3);
		}
	});
	
	$UI.linkbutton('#InciQuery', {
		onClick: function() {
			QueryDetail();
		}
	});
	
	var PeriodType = $HUI.combobox('#PeriodType', {
		data: [{ 'RowId': '1', 'Description': '按年' }, { 'RowId': '2', 'Description': '按季' }, { 'RowId': '3', 'Description': '按月' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var Year = $HUI.combobox('#Year', {
		data: [{ 'RowId': lastyear, 'Description': lastyear }, { 'RowId': nowyear, 'Description': nowyear }, { 'RowId': nextyear, 'Description': nextyear }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	/* --Grid--*/
	var LocLimitCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: 'LocId',
			field: 'LocId',
			hidden: true,
			width: 60
		}, {
			title: '科室代码',
			field: 'LocCode',
			width: 100
		}, {
			title: '科室名称',
			field: 'LocDesc',
			width: 150
		}, /* {
			title: "开始日期",
			field: 'StartDate',
			width: 100
		}, {
			title: "截止日期",
			field: 'EndDate',
			width: 100
		}, */{
			title: '年份',
			field: 'Year',
			width: 80
		}, {
			title: '限领金额',
			field: 'ReqAmt',
			width: 80,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '已领金额',
			field: 'UsedAmt',
			width: 80,
			align: 'right'
		}, {
			title: '统计周期',
			field: 'PeriodTypeId',
			width: 80,
			hidden: true
		}, {
			title: '统计周期',
			field: 'PeriodTypeDesc',
			width: 80
		}
	]];

	var LocLimitGrid = $UI.datagrid('#LocLimitGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocLimitAmt',
			QueryName: 'QueryLocLimit',
			query2JsonStrict: 1
		},
		columns: LocLimitCm,
		pagination: false,
		showBar: true,
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				LocSave();
			}
		}],
		onClickRow: function(index, row) {
			LocLimitGrid.commonClickRow(index, row);
			QueryDetail();
		},
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	function QueryDetail() {
		$UI.clear(StkScgLimitGrid);
		$UI.clear(StkCatLimitGrid);
		$UI.clear(InciLimitGrid);
		var row = LocLimitGrid.getSelected();
		var RowId = row.RowId;
		if (isEmpty(RowId)) {
			return;
		}
		var activeTabTitle = $('#DetailTabs').tabs('getSelected').panel('options').title;
		if (activeTabTitle == '按类组') {
			StkScgLimitGrid.load({
				ClassName: 'web.DHCSTMHUI.LocLimitAmt',
				QueryName: 'QueryLocLimitDetail',
				query2JsonStrict: 1,
				Params: JSON.stringify({ Parref: RowId, LimitType: 1, BDPHospital: HospId }),
				rows: 99999
			});
		}
		if (activeTabTitle == '按库存分类') {
			StkCatLimitGrid.load({
				ClassName: 'web.DHCSTMHUI.LocLimitAmt',
				QueryName: 'QueryLocLimitDetail',
				query2JsonStrict: 1,
				Params: JSON.stringify({ Parref: RowId, LimitType: 2, BDPHospital: HospId }),
				rows: 99999
			});
		}
		if (activeTabTitle == '按品种') {
			var StkGrpId = $('#StkGrpBox').combotree('getValue');
			var InciDesc = $('#InciDesc').val();
			InciLimitGrid.load({
				ClassName: 'web.DHCSTMHUI.LocLimitAmt',
				QueryName: 'QueryLocLimitDetail',
				query2JsonStrict: 1,
				Params: JSON.stringify({ Parref: RowId, LimitType: 3, BDPHospital: HospId, StkGrpId: StkGrpId, InciDesc: InciDesc }),
				rows: 99999
			});
		}
	}
	
	var StkScgLimitCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '类组',
			field: 'ScgId',
			width: 150,
			hidden: true
		}, {
			title: '类组',
			field: 'Desc',
			width: 150
		}, {
			title: '限领金额',
			field: 'ReqAmt',
			width: 100,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '已领金额',
			field: 'UsedAmt',
			width: 100,
			align: 'right'
		}
	]];

	var StkScgLimitGrid = $UI.datagrid('#StkScgLimitGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocLimitAmt',
			QueryName: 'QueryLocLimitDetail',
			query2JsonStrict: 1
		},
		columns: StkScgLimitCm,
		pagination: false,
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				LimitDetailSave(1);
			}
		}],
		onClickRow: function(index, row) {
			StkScgLimitGrid.commonClickRow(index, row);
		}
	});
	
	var StkCatLimitCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			hidden: true,
			width: 60
		}, {
			title: '库存分类',
			field: 'CatId',
			width: 150,
			hidden: true
		}, {
			title: '库存分类',
			field: 'Desc',
			width: 150
		}, {
			title: '限领金额',
			field: 'ReqAmt',
			width: 100,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: GetFmtNum('FmtRP')
				}
			}
		}, {
			title: '已领金额',
			field: 'UsedAmt',
			width: 100,
			align: 'right'
		}
	]];

	var StkCatLimitGrid = $UI.datagrid('#StkCatLimitGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocLimitAmt',
			QueryName: 'QueryLocLimitDetail',
			query2JsonStrict: 1
		},
		columns: StkCatLimitCm,
		pagination: false,
		toolbar: [{
			text: '保存',
			iconCls: 'icon-save',
			handler: function() {
				LimitDetailSave(2);
			}
		}],
		onClickRow: function(index, row) {
			StkCatLimitGrid.commonClickRow(index, row);
		}
	});
	
	var InciLimitCm = [[{
		title: 'RowId',
		field: 'RowId',
		hidden: true,
		width: 60
	}, {
		title: '物资RowId',
		field: 'InciId',
		width: 100,
		hidden: true
	}, {
		title: '物资代码',
		field: 'Code',
		width: 100
	}, {
		title: '物资名称',
		field: 'Desc',
		width: 200
	}, {
		title: '单位',
		field: 'PUomDesc',
		width: 80
	}, {
		title: '限领金额',
		field: 'ReqAmt',
		width: 100,
		align: 'right',
		editor: {
			type: 'numberbox',
			options: {
				min: 0,
				precision: GetFmtNum('FmtRP')
			}
		}
	}, {
		title: '单次限领数量',
		field: 'OnceReqQty',
		width: 100,
		align: 'right',
		editor: {
			type: 'numberbox',
			options: {
				min: 0,
				precision: GetFmtNum('FmtQTY')
			}
		}
	}, {
		title: '限领数量',
		field: 'ReqQty',
		width: 100,
		align: 'right',
		editor: {
			type: 'numberbox',
			options: {
				min: 0,
				precision: GetFmtNum('FmtQTY')
			}
		}
	}, {
		title: '已领金额',
		field: 'UsedAmt',
		width: 100,
		align: 'right'
	}, {
		title: '已领数量',
		field: 'UsedQty',
		width: 100,
		align: 'right'
	}
	]];

	var InciLimitGrid = $UI.datagrid('#InciLimitGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.LocLimitAmt',
			QueryName: 'QueryLocLimitDetail',
			query2JsonStrict: 1
		},
		columns: InciLimitCm,
		pagination: false,
		toolbar: '#InciTB',
		onClickRow: function(index, row) {
			InciLimitGrid.commonClickRow(index, row);
		}
	});
	
	Clear();
	Query();
	InitHosp();
};
$(init);