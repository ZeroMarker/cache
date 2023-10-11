/*
科室扩充信息维护
*/
var init = function() {
	var HospId = gHospId;
	function InitHosp() {
		var hospComp = InitHospCombo('CT_Loc', gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				setStkGrpHospid(HospId);
				SetServiceInfo(HospId);
				$UI.clearBlock('Conditions');
				Query();
			};
		}
		setStkGrpHospid(HospId);
		SetServiceInfo();
		Query();
	}
	// 根据接口启用控制相关按钮展示
	function SetServiceInfo(HospId) {
		if (!isEmpty(HospId)) {
			SerUseObj = GetSerUseObj(HospId);
		}
		if (SerUseObj.SCI == 'Y') {
			$('.SCIShow').show();
		} else {
			$('.SCIShow').hide();
		}
	}
	function GetHospId() {
		var HospId = '';
		if ($('#_HospList').length != 0) {
			HospId = $HUI.combogrid('#_HospList').getValue();
		} else {
			HospId = gHospId;
		}
		return HospId;
	}
	$UI.linkbutton('#SetTransferFrLocBT', {
		onClick: function() {
			var LocStr = '';
			var Rows = LocInfoGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择科室!');
				return;
			} else {
				for (var i = 0, Len = Rows.length; i < Len; i++) {
					var RowData = Rows[i];
					var RowIndex = LocInfoGrid.getRowIndex(RowData);
					var LocId = RowData['LocId'];
					if (LocStr == '') { LocStr = LocId; } else { LocStr = LocStr + ',' + LocId; }
				}
				if (LocStr == '') {
					$UI.msg('alert', '请选择科室!');
					return;
				}
			}
			setTransferFrLoc(LocStr, GetHospId(), 'F');
		}
	});
	$UI.linkbutton('#SetTransferToLocBT', {
		onClick: function() {
			var LocStr = '';
			var Rows = LocInfoGrid.getSelections();
			if (Rows.length <= 0) {
				$UI.msg('alert', '请选择科室!');
				return;
			} else {
				for (var i = 0, Len = Rows.length; i < Len; i++) {
					var RowData = Rows[i];
					var RowIndex = LocInfoGrid.getRowIndex(RowData);
					var LocId = RowData['LocId'];
					if (LocStr == '') { LocStr = LocId; } else { LocStr = LocStr + ',' + LocId; }
				}
				if (LocStr == '') {
					$UI.msg('alert', '请选择科室!');
					return;
				}
			}
			setTransferFrLoc(LocStr, GetHospId(), 'T');
		}
	});
	$UI.linkbutton('#SetLocClaGrpBT', {
		onClick: function() {
			var LocStr = '';
			var Rows = LocInfoGrid.getSelections();
			if (Rows.length != 1) {
				$UI.msg('alert', '请选择一个科室!');
				return;
			} else {
				var Loc = Rows[0]['LocId'];
				setLocClaGrp(Loc, GetHospId());
			}
		}
	});
	$UI.linkbutton('#QueryBT', {
		onClick: function() {
			Query();
		}
	});
	function Query() {
		var SessionParmas = addSessionParams({ Hospital: HospId });
		var Paramsobj = $UI.loopBlock('Conditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		LocInfoGrid.load({
			ClassName: 'web.DHCSTMHUI.CTLOC',
			QueryName: 'Query',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	$UI.linkbutton('#ClearBT', {
		onClick: function() {
			Clear();
		}
	});
	function Clear() {
		$UI.clearBlock('#Conditions');
		$UI.clear(LocInfoGrid);
		InitHosp();
	}
	
	$UI.linkbutton('#SaveBT', {
		onClick: function() {
			Save();
		}
	});
	function Save() {
		var Detail = LocInfoGrid.getChangesData();
		if (Detail === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Detail)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.CTLOC',
			MethodName: 'Save',
			Params: JSON.stringify(Detail)
		}, function(jsonData) {
			if (jsonData.success === 0) {
				$UI.msg('success', jsonData.msg);
				LocInfoGrid.reload();
			} else {
				$UI.msg('error', jsonData.msg);
			}
		});
	}
	$('#SendLocSCIBT').on('click', SendLocSCI);
	function SendLocSCI() {
		var Rows = LocInfoGrid.getSelections();
		if (Rows.length <= 0) {
			$UI.msg('alert', '请选择要推送的科室!');
			return;
		}
		var locstr = '';
		for (var i = 0, Len = Rows.length; i < Len; i++) {
			var RowData = Rows[i];
			var RowIndex = LocInfoGrid.getRowIndex(RowData);
			var locid = RowData['LocId'];
			if (locstr == '') { locstr = locid; } else { locstr = locstr + '^' + locid; }
		}
		if (locstr == '') {
			$UI.msg('alert', '请选择要推送的科室!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCI',
			MethodName: 'getHopLoc',
			LocIdStr: locstr
		}, function(jsonData) {
			$UI.msg('success', '已发送!');
		});
	}
	var Slg = $HUI.combobox('#Slg', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=array&Params='+Params,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			Slg.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=array&Params=' + Params;
			Slg.reload(url);
		}
	});
	var Lig = $HUI.combobox('#Lig', {
		// url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocItemGrp&ResultSetType=array&Params='+Params,
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			Lig.clear();
			var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocItemGrp&ResultSetType=array&Params=' + Params;
			Lig.reload(url);
		}
	});
	var MainLoc = $HUI.combobox('#MainLoc', {
		// url: $URL+ '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params='+ JSON.stringify(addSessionParams({Type:'All'})),
		valueField: 'RowId',
		textField: 'Description',
		onShowPanel: function() {
			MainLoc.clear();
			var Params = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: HospId }));
			var url = $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=Array&Params=' + Params;
			MainLoc.reload(url);
		}
	});
	$('#Type').simplecombobox({
		data: [
			{ RowId: 'A', Description: '器械材料' },
			{ RowId: 'R', Description: '药库' },
			{ RowId: 'I', Description: '住院药房' },
			{ RowId: 'O', Description: '门诊药房' },
			{ RowId: 'G', Description: '总务药房' },
			{ RowId: 'E', Description: '其他' }
		]
	});
	
	var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
	// 科室组
	/* var SlgCombo = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			data : function(){
				var ComboData = $.cm({
					ClassName: 'web.DHCSTMHUI.Common.Dicts',
					QueryName: 'GetLocGroup',
					ResultSetType: 'array',
					Params: Params
				}, false);
				return ComboData;
			}()
		}
	};*/
	var SlgCombo = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocGroup&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			},
			onSelect: function(record) {
				var rows = LocInfoGrid.getRows();
				var row = rows[LocInfoGrid.editIndex];
				row.SlgDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	// 项目组
	/* var LigCombo = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			data : function(){
				var ComboData = $.cm({
					ClassName: 'web.DHCSTMHUI.Common.Dicts',
					QueryName: 'GetLocItemGrp',
					ResultSetType: 'array',
					Params: Params
				}, false);
				return ComboData;
			}()
		}
	};*/
	var LigCombo = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetLocItemGrp&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
			},
			onSelect: function(record) {
				var rows = LocInfoGrid.getRows();
				var row = rows[LocInfoGrid.editIndex];
				row.LigDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var LocTypeCombo = {
		type: 'combobox',
		options: {
			mode: 'local',
			valueField: 'RowId',
			textField: 'Description',
			data: [
				{ RowId: 'A', Description: '器械材料' },
				{ RowId: 'R', Description: '药库' },
				{ RowId: 'I', Description: '住院药房' },
				{ RowId: 'O', Description: '门诊药房' },
				{ RowId: 'G', Description: '总务药房' },
				{ RowId: 'E', Description: '其他' }
			]
		}
	};
	// 支配科室
	/* var MainLocCombo = {
		type: 'combobox',
		options: {
			valueField: 'RowId',
			textField: 'Description',
			data : function(){
				var ComboData = $.cm({
					ClassName: 'web.DHCSTMHUI.Common.Dicts',
					QueryName: 'GetCTLoc',
					Params: JSON.stringify(addSessionParams({Type:'All'})),
					ResultSetType: 'array'
				}, false);
				return ComboData;
			}()
		}
	};*/
	var MainLocCombo = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetCTLoc&ResultSetType=array',
			valueField: 'RowId',
			textField: 'Description',
			onBeforeLoad: function(param) {
				param.Params = JSON.stringify(addSessionParams({ Type: 'All', BDPHospital: GetHospId() }));
			},
			onSelect: function(record) {
				var rows = LocInfoGrid.getRows();
				var row = rows[LocInfoGrid.editIndex];
				row.MainLocDesc = record.Description;
			},
			onShowPanel: function() {
				$(this).combobox('reload');
			}
		}
	};
	var PrintModeCodeCombo = {
		type: 'combobox',
		options: {
			url: $URL + '?ClassName=web.DHCSTMHUI.Common.Dicts&QueryName=GetPrintRules&ResultSetType=array',
			mode: 'remote',
			valueField: 'Code',
			textField: 'Code'
		}
	};
	
	var LocInfoCm = [[
		{
			field: 'ck',
			checkbox: true
		}, {
			title: 'LocId',
			field: 'LocId',
			width: 80,
			hidden: true
		}, {
			title: '代码',
			field: 'LocCode',
			width: 150,
			align: 'left'
		}, {
			title: '名称',
			field: 'LocDesc',
			width: 260,
			align: 'left'
		}, {
			title: '科室组',
			field: 'SlgId',
			width: 120,
			editor: SlgCombo,
			formatter: CommonFormatter(SlgCombo, 'SlgId', 'SlgDesc')		// combo有data同步时,使用CommonFormatter(SlgCombo)也可
		}, {
			title: '项目组',
			field: 'LigId',
			width: 120,
			editor: LigCombo,
			formatter: CommonFormatter(LigCombo, 'LigId', 'LigDesc')
		}, {
			title: '库房类别',
			field: 'Type',
			width: 150,
			editor: LocTypeCombo,
			formatter: CommonFormatter(LocTypeCombo)
		}, {
			title: '支配科室',
			field: 'MainLocId',
			width: 150,
			editor: MainLocCombo,
			formatter: CommonFormatter(MainLocCombo, 'MainLocId', 'MainLocDesc')
		}, {
			title: '激活',
			field: 'Active',
			width: 60,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '申请科室外项目',
			field: 'ReqAllItm',
			width: 120,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '科室顺序',
			field: 'ReportSeq',
			width: 80,
			align: 'right',
			editor: {
				type: 'numberbox',
				options: {
					min: 0,
					precision: 0
				}
			}
		}, {
			title: '打印模式',
			field: 'PrintMode',
			width: 100,
			align: 'left',
			editor: PrintModeCodeCombo,
			formatter: CommonFormatter(PrintModeCodeCombo, 'PrintMode', 'PrintMode')
		}, {
			title: '自动月报标志',
			field: 'AutoMonFlag',
			width: 120,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '启用临床消耗',
			field: 'StockControlFlag',
			width: 120,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];

	var LocInfoGrid = $UI.datagrid('#LocInfoGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.CTLOC',
			QueryName: 'Query',
			query2JsonStrict: 1
		},
		columns: LocInfoCm,
		// fitColumns: true,
		remoteSort: true,
		singleSelect: false,
		showBar: true,
		onClickRow: function(index, row) {
			LocInfoGrid.commonClickRow(index, row);
		}
	});
	Clear();
};
$(init);