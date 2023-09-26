/*
ģ��:��������
��ģ��:��������-�����������-���ϸ�ҩʦ����ά��
 */
var unitsUrl = 'dhcpha.comment.addadvice.save.csp';
Ext.onReady(function () {
	Ext.QuickTips.init(); // ������Ϣ��ʾ
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;
	var AdviceAddButton = new Ext.Button({
		width : 65,
		id : "AdviceAddBtn",
		text : '����',
		iconCls:"page_add",
		listeners : {
			"click" : function () {
				AdviceAddClick();
			}
		}
	})

	var AdviceUpdButton = new Ext.Button({
		width : 65,
		id : "AdviceUpdBtn",
		text : '�޸�',
		iconCls:"page_modify",
		listeners : {
			"click" : function () {

				AdviceUpdClick();

			}
		}

	})

	var AdviceDelButton = new Ext.Button({
		width : 65,
		id : "AdviceDelBtn",
		text : 'ɾ��',
		iconCls:"page_delete",
		listeners : {
			"click" : function () {

				AdviceDelClick();

			}
		}

	})

	var AdviceDescField = new Ext.form.TextField({

		width : 400,
		id : "AdviceDescTxt",

		fieldLabel : ""
	})

	var Advicegridcm = new Ext.grid.ColumnModel({

		columns : [
			{
				header : '����',
				dataIndex : 'advdesc',
				width : 430
			}, {
				header : 'rowid',
				dataIndex : 'advrowid',
				width : 40,
				hidden:true
			}

		]

	});

	var Advicegridds = new Ext.data.Store({
			autoLoad : true,
			proxy : new Ext.data.HttpProxy({
				url : unitsUrl
				 + '?action=QueryAdviceDs',
				method : 'POST'
			}),
			reader : new Ext.data.JsonReader({
				root : 'rows',
				totalProperty : 'results'
			}, [
					'advdesc',
					'advrowid'

				]),

			remoteSort : true
		});

	var Advicegrid = new Ext.grid.GridPanel({

			id : 'Advicetbl',
			title : '���ϸ�ҩʦ����ά��',
			region : 'center',
			width : 650,
			autoScroll : true,
			enableHdMenu : false,
			ds : Advicegridds,
			cm : Advicegridcm,
			enableColumnMove : false,
			stripeRows : true,
			tbar : ['����', AdviceDescField, AdviceAddButton, '-', AdviceUpdButton],
			trackMouseOver : 'true'
		});

	Advicegrid.on('rowclick', function (grid, rowIndex, e) {
		var selectedRow = Advicegridds.data.items[rowIndex];
		var advdesc = selectedRow.data["advdesc"];
		Ext.getCmp("AdviceDescTxt").setValue(advdesc);
	});

	///view

	var por = new Ext.Viewport({
			layout : 'border', // ʹ��border����
			items : [Advicegrid]
		});
	///-----------------------Events----------------------


	///����

	function AdviceAddClick() {

		var advdesc = Ext.getCmp("AdviceDescTxt").getValue();

		if (advdesc == "") {
			Ext.Msg.show({
				title : '��ʾ',
				msg : '����¼������!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.INFO
			});
			return;
		}

		///���ݿ⽻��

		Ext.Ajax.request({

			url : unitsUrl + '?action=AdviceAdd&AdviceDesc=' + advdesc,

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
					Ext.Msg.show({
						title : '��ʾ',
						msg : '����ɹ�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
					QueryAdviceDs();
				} else {
					if (jsonData.retvalue == "-99") {
						Ext.Msg.alert("��ʾ", "��Ҫ�����ҩʦ������ϵͳ���Ѵ��ڵ������ظ������ܱ��棬���޸�!");
					} else {
						Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: " + jsonData.retinfo);
					}

				}
			},

			scope : this
		});

	}

	///��������

	function QueryAdviceDs() {
		Advicegridds.removeAll();

		Advicegridds.proxy = new Ext.data.HttpProxy({
				url : unitsUrl + '?action=QueryAdviceDs'
			});

		Advicegridds.load({

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

	///�޸��¼�

	function AdviceUpdClick() {

		var row = Ext.getCmp("Advicetbl").getSelectionModel().getSelections();

		if (row.length == 0) {

			Ext.Msg.show({
				title : '��ʾ',
				msg : 'δѡ�м�¼!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.INFO
			});
			return;
		}

		var advrowid = row[0].data.advrowid; //ԭ��ID
		var advdesc = Ext.getCmp("AdviceDescTxt").getValue(); //����


		if (advdesc == "") {
			Ext.Msg.show({
				title : '��ʾ',
				msg : '����¼������!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.INFO
			});
			return;
		}

		///���ݿ⽻��

		Ext.Ajax.request({

			url : unitsUrl + '?action=AdviceUpd&AdviceDesc=' + advdesc + '&AdviceID=' + advrowid,

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
					Ext.Msg.show({
						title : '��ʾ',
						msg : '����ɹ�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
					QueryAdviceDs();
				}else if (jsonData.retvalue == -99){
					Ext.Msg.alert("��ʾ", "�޸ĺ������Ѵ���!");
				}else{
					Ext.Msg.alert("��ʾ", "����ʧ��!����ֵ: " + jsonData.retinfo);
				}
			},

			scope : this
		});

	}

	///�޸�ԭ����¼�

	function AdviceDelClick() {

		var row = Ext.getCmp("Advicetbl").getSelectionModel().getSelections();

		if (row.length == 0) {

			Ext.Msg.show({
				title : '��ʾ',
				msg : 'δѡ�м�¼!',
				buttons : Ext.Msg.OK,
				icon : Ext.MessageBox.INFO
			});
			return;
		}

		Ext.MessageBox.confirm('ע��', 'ȷ��Ҫɾ���� ? ', DelClickResult);

	}

	///ɾ��ȷ�϶���
	function DelClickResult(btn) {
		if (btn == "no") {
			return;
		}

		var row = Ext.getCmp("Advicetbl").getSelectionModel().getSelections();
		var advrowid = row[0].data.advrowid; //ԭ��ID

		///���ݿ⽻��ɾ��

		Ext.Ajax.request({

			url : unitsUrl + '?action=AdviceDel&AdviceID=' + advrowid,

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
					Ext.Msg.show({
						title : '��ʾ',
						msg : 'ɾ���ɹ�!',
						buttons : Ext.Msg.OK,
						icon : Ext.MessageBox.INFO
					});
					QueryAdviceDs();
				} else {
					Ext.Msg.alert("��ʾ", "ɾ��ʧ��!����ֵ: " + jsonData.retinfo);

				}
			},

			scope : this
		});

	}

});