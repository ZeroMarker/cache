var init = function() {
	var HospId = gHospId;
	var TableName = 'DHC_ServiceConfig';
	function InitHosp() {
		var hospComp = InitHospCombo(TableName, gSessionStr);
		if (typeof hospComp === 'object') {
			HospId = $HUI.combogrid('#_HospList').getValue();
			Query();
			$('#_HospList').combogrid('options').onSelect = function(index, record) {
				HospId = record.HOSPRowId;
				Query();
			};
		} else {
			Query();
		}
	}
	function Query() {
		var SessionParmas = addSessionParams({ BDPHospital: HospId });
		var Paramsobj = $UI.loopBlock('#MainConditions');
		var Params = JSON.stringify(jQuery.extend(true, Paramsobj, SessionParmas));
		SCGrid.load({
			ClassName: 'web.DHCSTMHUI.ServiceConfig',
			QueryName: 'SelectAll',
			query2JsonStrict: 1,
			Params: Params
		});
	}
	
	function Init() {
		var Params = JSON.stringify(addSessionParams({ BDPHospital: HospId, Type: 'ServiceConfig', InitFlag: 'N' }));
		$.cm({
			ClassName: 'web.DHCSTMHUI.DataInit',
			MethodName: 'jsInit',
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
	var QueryBT = {
		iconCls: 'icon-reload',
		text: 'ˢ��',
		handler: function() {
			Query();
		}
	};
	var SaveBT = {
		iconCls: 'icon-save',
		text: '����',
		handler: function() {
			Save();
		}
	};
	var InitBT = {
		iconCls: 'icon-big-switch',
		text: 'ͬ��',
		handler: function() {
			Init();
		}
	};
	function Save() {
		var Rows = SCGrid.getChangesData();
		if (Rows === false) {	// δ��ɱ༭����ϸΪ��
			return;
		}
		if (isEmpty(Rows)) {	// ��ϸ����
			$UI.msg('alert', 'û����Ҫ�������ϸ!');
			return;
		}
		for (var i = 0; i < Rows.length; i++) {
			var UseFlag = Rows[i].UseFlag;
			if (UseFlag == 'Y') {
				var Type = Rows[i].Type;
				var LocalIP = Rows[i].LocalIP;
				var User = Rows[i].User;
				var PassWord = Rows[i].PassWord;
				if ((Type != 'ECS') && (isEmpty(LocalIP))) {
					$UI.msg('alert', Type + '�������ã�IP����Ϊ��!');
					return;
				} else if ((Type == 'ECS') && ((isEmpty(LocalIP) || isEmpty(User) || isEmpty(PassWord)))) {
					$UI.msg('alert', Type + '�������ã�IP����ȨID����Ȩ�벻��Ϊ��!');
					return;
				}
			}
		}
		
		var MainObj = JSON.stringify(addSessionParams({ BDPHospital: HospId }));
		showMask();
		$.cm({
			ClassName: 'web.DHCSTMHUI.ServiceConfig',
			MethodName: 'jsSave',
			Main: MainObj,
			Detail: JSON.stringify(Rows)
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
	
	var Type = $HUI.combobox('#Type', {
		data: [{ 'RowId': '', 'Description': 'ȫ��' }, { 'RowId': 'ECS', 'Description': 'ECS' }, { 'RowId': 'HRP', 'Description': 'HRP' }, { 'RowId': 'LIS', 'Description': 'LIS' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var UseFlag = {
		type: 'combobox',
		options: {
			data: [{ RowId: 'Y', Description: '��' }, { RowId: 'N', Description: '��' }],
			valueField: 'RowId',
			textField: 'Description',
			mode: 'local'
		}
	};
	
	SCCm = [[
		{
			title: 'RowId',
			field: 'RowId',
			width: 50,
			hidden: true
		}, {
			title: '�ӿ�����',
			field: 'Type',
			width: 100,
			editor: {
				type: 'text',
				options: {
					
				}
			}
		}, {
			title: '������IP',
			field: 'LocalIP',
			width: 300,
			editor: {
				type: 'text',
				options: {
					
				}
			}
		}, {
			title: '��ȨID',
			field: 'User',
			width: 150,
			editor: {
				type: 'text',
				options: {

				}
			}
		}, {
			title: '��Ȩ��',
			field: 'PassWord',
			width: 150,
			editor: {
				type: 'text',
				options: {
					
				}
			}
		}, {
			title: '�Ƿ�����',
			field: 'UseFlag',
			width: 150,
			align: 'center',
			editor: { type: 'checkbox', options: { on: 'Y', off: 'N' }},
			formatter: BoolFormatter
		}
	]];
	
	var SCGrid = $UI.datagrid('#SCGrid', {
		queryParams: {
			ClassName: 'web.DHCSTMHUI.ServiceConfig',
			QueryName: 'SelectAll',
			query2JsonStrict: 1
		},
		showBar: true,
		columns: SCCm,
		checkField: 'Type',
		showAddItems: true,
		fitColumns: true,
		toolbar: [SaveBT, QueryBT, InitBT],
		onClickRow: function(index, row) {
			SCGrid.commonClickRow(index, row);
		},
		navigatingWithKey: true,
		onLoadSuccess: function(data) {
			if (data.rows.length > 0) {
				$(this).datagrid('selectRow', 0);
			}
		}
	});
	
	InitHosp();
};
$(init);