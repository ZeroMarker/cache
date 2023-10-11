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
	
	/* --��ť�¼�--*/
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
			$UI.msg('alert', '��ѡ�����!');
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
				$UI.msg('alert', '��ѡ�����!');
				return;
			}
			if (ParamsObj.Year < new Date().getFullYear()) {
				$UI.msg('alert', '�������ɱ���֮ǰ������!');
				return;
			}
			if (isEmpty(ParamsObj.PeriodType)) {
				$UI.msg('alert', '��ѡ��ͳ������!');
				return;
			}
			var Msg = '�����������ÿ��ҿ��Ҷ�����Ϣ��ȷ�ϸ��£�';
			
			$UI.confirm(Msg, 'warning', '', UpdatePeriod, '', '', '����', false, ParamsObj);
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
			$UI.msg('alert', 'û����Ҫ�������Ϣ!');
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
			$UI.msg('alert', '��ѡ�����Ҫ����Ŀ���!');
			return false;
		} else if (isEmpty(LocRow.RowId)) {
			$UI.msg('alert', '����ά����������Ϣ!');
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
						$UI.msg('alert', '��' + (i + 1) + '�е��������������ڵ�Ʒ��������');
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
			$UI.msg('alert', 'û����Ҫ�������Ϣ!');
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
		data: [{ 'RowId': '1', 'Description': '����' }, { 'RowId': '2', 'Description': '����' }, { 'RowId': '3', 'Description': '����' }],
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
			title: '���Ҵ���',
			field: 'LocCode',
			width: 100
		}, {
			title: '��������',
			field: 'LocDesc',
			width: 150
		}, /* {
			title: "��ʼ����",
			field: 'StartDate',
			width: 100
		}, {
			title: "��ֹ����",
			field: 'EndDate',
			width: 100
		}, */{
			title: '���',
			field: 'Year',
			width: 80
		}, {
			title: '������',
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
			title: '������',
			field: 'UsedAmt',
			width: 80,
			align: 'right'
		}, {
			title: 'ͳ������',
			field: 'PeriodTypeId',
			width: 80,
			hidden: true
		}, {
			title: 'ͳ������',
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
			text: '����',
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
		if (activeTabTitle == '������') {
			StkScgLimitGrid.load({
				ClassName: 'web.DHCSTMHUI.LocLimitAmt',
				QueryName: 'QueryLocLimitDetail',
				query2JsonStrict: 1,
				Params: JSON.stringify({ Parref: RowId, LimitType: 1, BDPHospital: HospId }),
				rows: 99999
			});
		}
		if (activeTabTitle == '��������') {
			StkCatLimitGrid.load({
				ClassName: 'web.DHCSTMHUI.LocLimitAmt',
				QueryName: 'QueryLocLimitDetail',
				query2JsonStrict: 1,
				Params: JSON.stringify({ Parref: RowId, LimitType: 2, BDPHospital: HospId }),
				rows: 99999
			});
		}
		if (activeTabTitle == '��Ʒ��') {
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
			title: '����',
			field: 'ScgId',
			width: 150,
			hidden: true
		}, {
			title: '����',
			field: 'Desc',
			width: 150
		}, {
			title: '������',
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
			title: '������',
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
			text: '����',
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
			title: '������',
			field: 'CatId',
			width: 150,
			hidden: true
		}, {
			title: '������',
			field: 'Desc',
			width: 150
		}, {
			title: '������',
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
			title: '������',
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
			text: '����',
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
		title: '����RowId',
		field: 'InciId',
		width: 100,
		hidden: true
	}, {
		title: '���ʴ���',
		field: 'Code',
		width: 100
	}, {
		title: '��������',
		field: 'Desc',
		width: 200
	}, {
		title: '��λ',
		field: 'PUomDesc',
		width: 80
	}, {
		title: '������',
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
		title: '������������',
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
		title: '��������',
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
		title: '������',
		field: 'UsedAmt',
		width: 100,
		align: 'right'
	}, {
		title: '��������',
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