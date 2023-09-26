/*
ģ��:��������
��ģ��:��������-�����������-�������Ʒ���ά��
 */
var unitsUrl = 'dhcpha.comment.addcontrol.save.csp';

Ext.onReady(function () {

	Ext.QuickTips.init(); // ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	var ctrlgridcm = new Ext.grid.ColumnModel({

			columns : [
				{
					header : '����',
					dataIndex : 'ctrldesc',
					width : 300
				}, {
					header : 'rowid',
					dataIndex : 'ctrlrowid',
					width : 40,
					hidden:true
				}

			]

		});

	var ctrlgridds = new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({
				url : unitsUrl
				 + '?action=QueryCtrlDs',
				method : 'POST'
			}),
			reader : new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : 'results'
			}, [
					'ctrldesc',
					'ctrlrowid'

				]),

			remoteSort : true
		});

	var ctrlgrid = new Ext.grid.GridPanel({
			title : '��ά����¼<˫��ɾ��>',
			id : 'ctrltbl',
			region : 'center',
			width : 250,
			autoScroll : true,
			enableHdMenu : false,
			ds : ctrlgridds,
			cm : ctrlgridcm,
			enableColumnMove : false,
			stripeRows : true,
			trackMouseOver : 'true'

		});

	////////���Ʒ���Grid


	var poisongridcm = new Ext.grid.ColumnModel({

			columns : [
				{
					header : '����',
					dataIndex : 'poisondesc',
					width : 300
				}, {
					header : 'rowid',
					dataIndex : 'poisonrowid',
					width : 40,
					hidden:true
				}

			]

		});

	var poisongridds = new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({
				url : unitsUrl
				 + '?action=GetPHPoison',
				method : 'POST'
			}),
			reader : new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : 'results'
			}, [
					'poisondesc',
					'poisonrowid'

				]),

			remoteSort : true
		});

	var poisongrid = new Ext.grid.GridPanel({

			id : 'poisontbl',
			title : '����ҩ�Ｖ��ά��<˫������>',
			region : 'west',
			width : 350,
			autoScroll : true,
			enableHdMenu : false,
			ds : poisongridds,
			cm : poisongridcm,
			enableColumnMove : false,
			stripeRows : true,
			trackMouseOver : 'true'

		});

	///view

	var por = new Ext.Viewport({

			layout : 'border', // ʹ��border����

			items : [poisongrid, ctrlgrid]

		});

	///-----------------------Events----------------------


	///˫��grid���
	poisongrid.on('rowdblclick', function (grid, rowIndex, e) {

		var selectedRow = poisongridds.data.items[rowIndex];
		var poisondesc = selectedRow.data["poisondesc"];
		var poisonrowid = selectedRow.data["poisonrowid"];
		InsertToCtrlGrid(poisonrowid);

	});

	///���ݿ⽻��
	function InsertToCtrlGrid(poisonrowid) {

		Ext.Ajax.request({

			url : unitsUrl + '?action=CtrlAdd&PoisonID=' + poisonrowid,

			waitMsg : 'ɾ����...',
			failure : function (result, request) {
				Ext.Msg.show({
					title : '����',
					msg : '������������!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			},
			success : function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.retvalue == 0) {
					QueryCtrlDs();
				}else if (jsonData.retvalue == -3){
					Ext.Msg.alert("��ʾ", "�ù��Ʒ���/�ÿ���ҩ�Ｖ��Ϊ��!");
				}else if (jsonData.retvalue == -4){
					Ext.Msg.alert("��ʾ", "�ù��Ʒ���/�ÿ���ҩ�Ｖ���Ѳ�����!");
				}else if (jsonData.retvalue == -2){
					Ext.Msg.alert("��ʾ", "�ù��Ʒ�����ά��/�ÿ���ҩ�Ｖ����ά��!");
				}else {
					Ext.Msg.alert("����", "����ʧ��!����ֵ: " + jsonData.retinfo);
				}
			},

			scope : this
		});

	}

	///��������

	function QueryCtrlDs() {
		ctrlgridds.removeAll();

		ctrlgridds.proxy = new Ext.data.HttpProxy({
				url : unitsUrl + '?action=QueryCtrlDs'
			});

		ctrlgridds.load({

			callback : function (r, options, success) {

				if (success == false) {
					Ext.Msg.show({
						title : 'ע��',
						msg : '��ѯʧ�� !',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
				}
			}

		});

	}

	ctrlgrid.on('rowdblclick', function (grid, rowIndex, e) {

		var selectedRow = poisongridds.data.items[rowIndex];
		var ctrldesc = selectedRow.data["ctrldesc"];
		var ctrlrowid = selectedRow.data["ctrlrowid"];
		DelCtrlClick(ctrlrowid);

	});

	///�޸�ԭ����¼�

	function DelCtrlClick(ctrlrowid) {

		Ext.MessageBox.confirm('ע��', 'ȷ��Ҫɾ���� ? ', DelClickResult);

	}

	///ɾ��ȷ�϶���
	function DelClickResult(btn) {
		if (btn == "no") {
			return;
		}

		var row = Ext.getCmp("ctrltbl").getSelectionModel().getSelections();
		var ctrlrowid = row[0].data.ctrlrowid; //ID


		///���ݿ⽻��ɾ��

		Ext.Ajax.request({

			url : unitsUrl + '?action=CtrlDel&CtrlID=' + ctrlrowid,

			waitMsg : 'ɾ����...',
			failure : function (result, request) {
				Ext.Msg.show({
					title : '����',
					msg : '������������!',
					buttons : Ext.Msg.OK,
					icon : Ext.MessageBox.ERROR
				});
			},
			success : function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if (jsonData.retvalue == 0) {
					//Ext.Msg.show({title:'��ʾ',msg:'ɾ���ɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					QueryCtrlDs();
				} else {
					Ext.Msg.alert("��ʾ", "ɾ��ʧ��!����ֵ: " + jsonData.retinfo);

				}
			},

			scope : this
		});

	}

});
