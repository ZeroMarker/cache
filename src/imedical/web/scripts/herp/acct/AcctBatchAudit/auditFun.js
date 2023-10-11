var userdr = session['LOGON.USERID'];
var projUrl = 'herp.acct.acctbatchauditexe.csp'

function auditFun(arr) {

	var CheckResultField = new Ext.form.ComboBox({
			fieldLabel: '��˽��',
			width: 500,
			anchor: '100%',
			store: new Ext.data.ArrayStore({
				fields: ['rowid', 'name'],
				data: [['1', 'ͨ��'], ['0', '��ͨ��']]
			}),
			displayField: 'name',
			valueField: 'rowid',
			typeAhead: true,
			mode: 'local',
			value: 1,
			forceSelection: true,
			triggerAction: 'all',
			emptyText: 'ѡ��...',
			selectOnFocus: 'true'
			//disabled:true
		});

	//////////////// ���ı��� ////////////////////
	var textArea = new Ext.form.TextArea({
			id: 'textArea',
			width: 500,
			anchor: '100%',
			fieldLabel: '������',
			//allowBlank :false,
			selectOnFocus: 'true',
			emptyText: '����д������������100�֣�����'
		});

	/////////////// ����˵�����ı��� /////////////////////////
	var viewFieldSet = new Ext.form.FieldSet({
			title: '������',
			height: 110,
			labelSeparator: '��',
			items: textArea
		});
	var checkFieldSet = new Ext.form.FieldSet({
			title: '��˽��',
			height: 70,
			labelSeparator: '��',
			items: CheckResultField
		});

	var colItems = [{
			layout: 'column',
			border: false,
			defaults: {
				columnWidth: '1.0',
				bodyStyle: 'padding:5px 5px 0',
				border: false
			},
			items: [{
					xtype: 'fieldset',
					autoHeight: true,
					items: [
						checkFieldSet,
						viewFieldSet
					]
				}
			]
		}
	]

	var formPanel = new Ext.form.FormPanel({
			labelWidth: 80,
			frame: true,
			items: colItems
		});

	addButton = new Ext.Toolbar.Button({
			text: 'ȷ��'
		});

	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
	addHandler = function () {

		var ChkResult = encodeURIComponent(CheckResultField.getRawValue());
		var view = encodeURIComponent(Ext.getCmp('textArea').getRawValue().trim());
		var statusid = CheckResultField.getValue();

		if (ChkResult == "") {
			Ext.Msg.show({
				title: '����',
				msg: '��˽������Ϊ�� ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
			return;
		}
		
		var vouchid=arr.join();	//������ת��Ϊ��","�ָ���ַ���
		Ext.Ajax.request({
			url: projUrl + '?action=veraudit&userdr=' + userdr + '&vouchid=' + vouchid + '&ChkResult=' + ChkResult + '&view=' + view + '&statusid=' + statusid + '&bookID=' + bookID,
			waitMsg: '�����...',
			failure: function (result, request) {
				Ext.Msg.show({
					title: '����',
					msg: '������������! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if ((jsonData.success == 'true')) {
					Ext.Msg.show({
						title: 'ע��',
						msg: '������! ',
						icon: Ext.MessageBox.INFO,
						buttons: Ext.Msg.OK
					});
					//itemGrid.store.load({params:{start:0, limit:25,userdr:userdr}});
					var tbarnum = itemGrid.getBottomToolbar();
					tbarnum.doLoad(tbarnum.cursor);
					addwin.close();
				} else {
					Ext.Msg.show({
						title: '����',
						msg: "���ʧ�ܣ�"+jsonData.info,
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.ERROR
					});
				}
			},
			scope: this
		});
		
	}

	////// ��Ӽ����¼� ////////////////
	addButton.addListener('click', addHandler, false);
	cancelButton = new Ext.Toolbar.Button({
			text: 'ȡ��'
		});
	cancelHandler = function () {
		addwin.close();
	}
	cancelButton.addListener('click', cancelHandler, false);
	var addwin = new Ext.Window({
			title: '��˽��+������',
			width: 500,
			height: 300,
			layout: 'fit',
			plain: true,
			modal: true,
			bodyStyle: 'padding:5px;',
			buttonAlign: 'center',
			items: formPanel,
			buttons: [
				addButton,
				cancelButton
			]
		});
	addwin.show();
}
