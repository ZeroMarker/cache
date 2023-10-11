var userdr = session['LOGON.USERID'];
var projUrl = '../csp/herp.acct.acctbatchauditexe.csp';

function cancelAuditFun(vouchidDs) {

	//////////////// ���ı��� ////////////////////
	var textArea = new Ext.form.TextArea({
			id: 'textArea',
			width: 500,
			height:120,
			anchor: '100%',
			fieldLabel: '��������',
			//allowBlank :false,
			selectOnFocus: 'true',
			emptyText: '����д������������100�֣�����'
		});

	/////////////// ����˵�����ı��� /////////////////////////
	var viewFieldSet = new Ext.form.FieldSet({
			title: '��������',
			height: 160,
			labelSeparator: '��',
			items: textArea
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
						viewFieldSet
					]
				}
			]
		}
	]

	var formPanel = new Ext.form.FormPanel({
			labelWidth: 90,
			labelAlign:'right',
			frame: true,
			items: colItems
		});

	addButton = new Ext.Toolbar.Button({
			text: 'ȷ��'
		});

	//////////////////////////  ���Ӱ�ť��Ӧ����   //////////////////////////////
	addHandler = function () {

		var view = encodeURIComponent(Ext.getCmp('textArea').getRawValue());
		var statusid = -1; //statusid=1ͨ����0Ϊ��ͨ����-1Ϊ�����

		var vouchid = vouchidDs.join();
		Ext.Ajax.request({
			url: projUrl + '?action=veraudit' + '&userdr=' + userdr + '&vouchid=' + vouchid + 
			'&ChkResult=&view=' + view + '&statusid=' + statusid + 
			'&bookID=' + bookID,
			waitMsg: '�������...',
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
						msg: '��������! ',
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
						msg: '�����ʧ�ܣ�'+jsonData.info,
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
			title: '�����',
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
