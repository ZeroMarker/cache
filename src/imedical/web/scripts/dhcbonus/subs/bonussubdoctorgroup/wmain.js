var wValue = new Array({
			header : '',
			dataIndex : 'BonusSubDoctorGroupID'
		}, // 0
		{
			header : 'ҽ�������',
			dataIndex : 'DoctorGroupCode'
		}, // 1
		{
			header : 'ҽ��������',
			dataIndex : 'DoctorGroupName'
		}, // 2
		{
			header : '',
			dataIndex : 'IsValid'
		} // 3
);

var wUrl = 'dhc.bonus.bonussubdoctorgroupexe.csp';
var wProxy = new Ext.data.HttpProxy({
			url : wUrl + '?action=wlist&start=0&limit=25'
		});

var wDs = new Ext.data.Store({
			proxy : wProxy,
			reader : new Ext.data.JsonReader({
						root : 'rows',
						totalProperty : 'results'
					}, [wValue[0].dataIndex, wValue[1].dataIndex,
							wValue[2].dataIndex, wValue[3].dataIndex]),
			remoteSort : true
		});

wDs.setDefaultSort('BonusSubDoctorGroupID', 'Desc');

var wCm = new Ext.grid.ColumnModel([new Ext.grid.RowNumberer(), {
			header : wValue[1].header,
			dataIndex : wValue[1].dataIndex,
			width : 150,
			sortable : true
		}, {
			header : wValue[2].header,
			dataIndex : wValue[2].dataIndex,
			width : 200,
			align : 'left',
			sortable : true
		}]);

var wPagingToolbar = new Ext.PagingToolbar({
			pageSize : 25,
			store : wDs,
			displayInfo : true,
			displayMsg : '��ǰ��ʾ{0} - {1}������{2}',
			emptyMsg : "û������"
		});

var wAddButton = new Ext.Toolbar.Button({
			text : '���',
			tooltip : '���',
			iconCls : 'add',
			handler : function() {
				wAddFun();
			}
		});

var wEditButton = new Ext.Toolbar.Button({
			text : '�޸�',
			tooltip : '�����ɺ󲻿��޸�',
			iconCls : 'option',
			handler : function() {
				wEditFun();
			}
		});

var wDelButton = new Ext.Toolbar.Button({
	text : 'ɾ��',
	tooltip : 'ɾ��',
	iconCls : 'remove',
	handler : function() {
		var rowObj = wMain.getSelectionModel().getSelections();
		var len = rowObj.length;
		var tmpRowid = "";
		if (len < 1) {
			Ext.Msg.show({
						title : 'ע��',
						msg : '��ѡ����Ҫɾ��������!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.WARNING
					});
			return;
		} else {
			tmpRowid = rowObj[0].get("BonusSubDoctorGroupID");
			var cLen = cDs.getCount();
			if (cLen == 0) {
				Ext.MessageBox.confirm('��ʾ', 'ȷ��Ҫɾ��ѡ������?', function(btn) {
					if (btn == 'yes') {
						Ext.Ajax.request({
							url : wUrl + '?action=wdel&rowid=' + tmpRowid,
							waitMsg : 'ɾ����...',
							failure : function(result, request) {
								Ext.Msg.show({
											title : '����',
											msg : '������������!',
											buttons : Ext.Msg.OK,
											icon : Ext.MessageBox.ERROR
										});
							},
							success : function(result, request) {
								var jsonData = Ext.util.JSON
										.decode(result.responseText);
								if (jsonData.success == 'true') {
									Ext.Msg.show({
												title : 'ע��',
												msg : '�����ɹ�!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.INFO
											});
									wDs.load({
												params : {
													start : 0,
													limit : wPagingToolbar.pageSize
												}
											});
								} else {
									Ext.Msg.show({
												title : '����',
												msg : '��ɾ���ӵ�Ԫ!',
												buttons : Ext.Msg.OK,
												icon : Ext.MessageBox.ERROR
											});
								}
							},
							scope : this
						});
					}
				})
			} else {
				Ext.Msg.show({
							title : '����',
							msg : '���ӵ�Ԫ,����ɾ��!',
							buttons : Ext.Msg.OK,
							icon : Ext.MessageBox.ERROR
						});
			}
		}
	}
});

wSM = new Ext.grid.RowSelectionModel({
			singleSelect : true
		});

var wMain = new Ext.grid.GridPanel({
			title : 'ҽ����ά��',
			region : 'west',
			width : 450,
			store : wDs,
			cm : wCm,
			trackMouseOver : true,
			stripeRows : true,
			sm : wSM,
			loadMask : true,
			viewConfig : {
				forceFit : true
			},
			tbar : [wAddButton, '-', wEditButton, '-', wDelButton],
			bbar : wPagingToolbar
		});

wDs.load({
			params : {
				start : 0,
				limit : wPagingToolbar.pageSize
			},
			callback : function(record, options, success) {
				wMain.fireEvent('rowclick', this, 0);
			}
		});

var cSelected = '';

wMain.on('rowclick', function(grid, rowIndex, e) {

			var num = wDs.getTotalCount();
			if (num > 0) {
				var selectedRow = wDs.data.items[rowIndex];
				// alert(wDs.getTotalCount());

				var tmpWRowid = selectedRow.data['BonusSubDoctorGroupID'];
				cSelected = tmpWRowid;
				cDs.proxy = new Ext.data.HttpProxy({
							url : wUrl + '?action=clist&parRef=' + tmpWRowid
						});
				cDs.load({
							params : {
								start : 0,
								limit : 25
							}
						});
			}
		});
