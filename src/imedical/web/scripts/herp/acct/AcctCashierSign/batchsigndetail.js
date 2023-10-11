
var userdr = session['LOGON.USERID']; //��¼��ID
var projUrl = 'herp.acct.acctcashiersignexe.csp';

function batchsigndetail(arr) {

	//***�����������������***//
	var CheckResultField = new Ext.form.ComboBox({
			fieldLabel: '�������',
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
			fieldLabel: '�������',
			allowBlank: false,
			selectOnFocus: 'true',
			emptyText: '����д�������������100�֣�����'
		});

	/////////////// ����˵�����ı��� /////////////////////////
	var viewFieldSet = new Ext.form.FieldSet({
			title: '�������',
			height: 110,
			labelSeparator: '��',
			items: textArea
		});
	var checkFieldSet = new Ext.form.FieldSet({
			title: '�������',
			height: 70,
			labelSeparator: '��',
			items: CheckResultField
		});
	//***����ṹ***//
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
	];
	//***�������(���)***//
	var formPanel = new Ext.form.FormPanel({
			labelWidth: 80,
			frame: true,
			items: colItems
		});
	//***ȷ����ť***//
	var addButton = new Ext.Toolbar.Button({
			text: 'ȷ��'
		});

	cancelButton = new Ext.Toolbar.Button({
			text: 'ȡ��',
			handler: function () {
				addwin.close();
			}
		});

	//***����һ������***//
	var addwin = new Ext.Window({
			title: '����˵��+�������',
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

	//////////////////////////  ȷ����ť��Ӧ����   //////////////////////////////
	var addHandler = function () {
		var ChkResult = encodeURIComponent(CheckResultField.getRawValue());
		//alert(Ext.getCmp('textArea').getRawValue());
		var view = encodeURI(Ext.getCmp('textArea').getRawValue().trim());
		//	alert(view);
		// var win_closed=false;	//�Ƿ�رյ����������������
		if (ChkResult == "") {
			Ext.Msg.show({
				title: '����',
				msg: '�����������Ϊ�� ',
				buttons: Ext.Msg.OK,
				icon: Ext.MessageBox.ERROR
			});
			return;
		};

		rowid = arr.join();
		Ext.Ajax.request({
			url: projUrl + '?action=BatchSign&userdr=' + userdr + '&ChkResult=' + ChkResult + '&view=' + view + '&rowid=' + rowid + '&acctbookid=' + acctbookid,
			waitMsg: 'ǩ����...',
			failure: function (result, request) {
				// console.log(result);
				Ext.Msg.show({
					title: '����',
					msg: '������������! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				// console.log(jsonData);
				if ((jsonData.success == 'true')) {
					// win_closed=true;		//ǩ�ֳɹ����رյ�������
					
					Ext.Msg.show({
						title: 'ע��',
						msg: '����ǩ�����! ',
						icon: Ext.MessageBox.INFO,
						buttons: Ext.Msg.OK
					});
					
					//����ɹ���ͣ���ڵ�ǰҳ
					var tbarnum = itemGrid.getBottomToolbar();
					tbarnum.doLoad(tbarnum.cursor);
					addwin.close();
				} else {
					Ext.Msg.show({
						title: '����',
						msg: '����ǩ��ʧ��!' + jsonData.info,
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.ERROR
					});
				}
			},
			scope: this
		});
		
	}
	//***��Ӽ����¼�***//
	addButton.addListener('click', addHandler, false);

}
