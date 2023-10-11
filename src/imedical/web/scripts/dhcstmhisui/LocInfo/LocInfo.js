/*
����������Ϣά��
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
	// ���ݽӿ����ÿ�����ذ�ťչʾ
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
				$UI.msg('alert', '��ѡ�����!');
				return;
			} else {
				for (var i = 0, Len = Rows.length; i < Len; i++) {
					var RowData = Rows[i];
					var RowIndex = LocInfoGrid.getRowIndex(RowData);
					var LocId = RowData['LocId'];
					if (LocStr == '') { LocStr = LocId; } else { LocStr = LocStr + ',' + LocId; }
				}
				if (LocStr == '') {
					$UI.msg('alert', '��ѡ�����!');
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
				$UI.msg('alert', '��ѡ�����!');
				return;
			} else {
				for (var i = 0, Len = Rows.length; i < Len; i++) {
					var RowData = Rows[i];
					var RowIndex = LocInfoGrid.getRowIndex(RowData);
					var LocId = RowData['LocId'];
					if (LocStr == '') { LocStr = LocId; } else { LocStr = LocStr + ',' + LocId; }
				}
				if (LocStr == '') {
					$UI.msg('alert', '��ѡ�����!');
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
				$UI.msg('alert', '��ѡ��һ������!');
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
		if (Detail === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Detail)) {	// ��ϸ����
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
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
			$UI.msg('alert', '��ѡ��Ҫ���͵Ŀ���!');
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
			$UI.msg('alert', '��ѡ��Ҫ���͵Ŀ���!');
			return;
		}
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceForSCI',
			MethodName: 'getHopLoc',
			LocIdStr: locstr
		}, function(jsonData) {
			$UI.msg('success', '�ѷ���!');
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
			{ RowId: 'A', Description: '��е����' },
			{ RowId: 'R', Description: 'ҩ��' },
			{ RowId: 'I', Description: 'סԺҩ��' },
			{ RowId: 'O', Description: '����ҩ��' },
			{ RowId: 'G', Description: '����ҩ��' },
			{ RowId: 'E', Description: '����' }
		]
	});
	
	var Params = JSON.stringify(addSessionParams({ BDPHospital: GetHospId() }));
	// ������
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
	// ��Ŀ��
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
				{ RowId: 'A', Description: '��е����' },
				{ RowId: 'R', Description: 'ҩ��' },
				{ RowId: 'I', Description: 'סԺҩ��' },
				{ RowId: 'O', Description: '����ҩ��' },
				{ RowId: 'G', Description: '����ҩ��' },
				{ RowId: 'E', Description: '����' }
			]
		}
	};
	// ֧�����
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
			title: '����',
			field: 'LocCode',
			width: 150,
			align: 'left'
		}, {
			title: '����',
			field: 'LocDesc',
			width: 260,
			align: 'left'
		}, {
			title: '������',
			field: 'SlgId',
			width: 120,
			editor: SlgCombo,
			formatter: CommonFormatter(SlgCombo, 'SlgId', 'SlgDesc')		// combo��dataͬ��ʱ,ʹ��CommonFormatter(SlgCombo)Ҳ��
		}, {
			title: '��Ŀ��',
			field: 'LigId',
			width: 120,
			editor: LigCombo,
			formatter: CommonFormatter(LigCombo, 'LigId', 'LigDesc')
		}, {
			title: '�ⷿ���',
			field: 'Type',
			width: 150,
			editor: LocTypeCombo,
			formatter: CommonFormatter(LocTypeCombo)
		}, {
			title: '֧�����',
			field: 'MainLocId',
			width: 150,
			editor: MainLocCombo,
			formatter: CommonFormatter(MainLocCombo, 'MainLocId', 'MainLocDesc')
		}, {
			title: '����',
			field: 'Active',
			width: 60,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '�����������Ŀ',
			field: 'ReqAllItm',
			width: 120,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '����˳��',
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
			title: '��ӡģʽ',
			field: 'PrintMode',
			width: 100,
			align: 'left',
			editor: PrintModeCodeCombo,
			formatter: CommonFormatter(PrintModeCodeCombo, 'PrintMode', 'PrintMode')
		}, {
			title: '�Զ��±���־',
			field: 'AutoMonFlag',
			width: 120,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}, {
			title: '�����ٴ�����',
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