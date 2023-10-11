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
		text: '刷新',
		handler: function() {
			Query();
		}
	};
	var SaveBT = {
		iconCls: 'icon-save',
		text: '保存',
		handler: function() {
			Save();
		}
	};
	var InitBT = {
		iconCls: 'icon-big-switch',
		text: '同步',
		handler: function() {
			Init();
		}
	};
	function Save() {
		var Rows = SCGrid.getChangesData();
		if (Rows === false) {	// 未完成编辑或明细为空
			return;
		}
		if (isEmpty(Rows)) {	// 明细不变
			$UI.msg('alert', '没有需要保存的明细!');
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
					$UI.msg('alert', Type + '配置启用，IP不能为空!');
					return;
				} else if ((Type == 'ECS') && ((isEmpty(LocalIP) || isEmpty(User) || isEmpty(PassWord)))) {
					$UI.msg('alert', Type + '配置启用，IP、授权ID、授权码不能为空!');
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
		data: [{ 'RowId': '', 'Description': '全部' }, { 'RowId': 'ECS', 'Description': 'ECS' }, { 'RowId': 'HRP', 'Description': 'HRP' }, { 'RowId': 'LIS', 'Description': 'LIS' }],
		valueField: 'RowId',
		textField: 'Description'
	});
	
	var UseFlag = {
		type: 'combobox',
		options: {
			data: [{ RowId: 'Y', Description: '是' }, { RowId: 'N', Description: '否' }],
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
			title: '接口类型',
			field: 'Type',
			width: 100,
			editor: {
				type: 'text',
				options: {
					
				}
			}
		}, {
			title: '服务器IP',
			field: 'LocalIP',
			width: 300,
			editor: {
				type: 'text',
				options: {
					
				}
			}
		}, {
			title: '授权ID',
			field: 'User',
			width: 150,
			editor: {
				type: 'text',
				options: {

				}
			}
		}, {
			title: '授权码',
			field: 'PassWord',
			width: 150,
			editor: {
				type: 'text',
				options: {
					
				}
			}
		}, {
			title: '是否启用',
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