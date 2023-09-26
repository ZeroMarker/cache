// /����: ѡ��¼�뷽ʽ
// /����: ѡ��¼�뷽ʽ
// /��д�ߣ�zhangdongmei
// /��д����: 2012.09.04

function SelectModel(InputType, Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// ȷ����ť
	var returnBT = new Ext.Toolbar.Button({
			text: 'ȷ��',
			tooltip: '���ȷ��',
			iconCls: 'page_goto',
			handler: function () {
				returnData();
			}
		});

	// ȡ����ť
	var cancelBT = new Ext.Toolbar.Button({
			text: 'ȡ��',
			tooltip: '���ȡ��',
			iconCls: 'page_close',
			handler: function () {
				SelInputWin.close();
			}
		});

	var InStkTkWin = new Ext.ux.ComboBox({
			fieldLabel: 'ʵ�̴���',
			id: 'InStkTkWin',
			name: 'InStkTkWin',
			anchor: '90%',
			emptyText: 'ʵ�̴���...',
			store: INStkTkWindowStore,
			valueField: 'RowId',
			displayField: 'Description',
			params: {
				'LocId': 'PhaLoc'
			},
			disabled: InputType == '3'
		});

	var SelInputWin = new Ext.Window({
			title: 'ʵ��¼�뷽ʽѡ��',
			width: 500,
			height: 500,
			labelWidth: 100,
			items: [{
					xtype: 'radiogroup',
					id: 'InputModel',
					anchor: '95%',
					columns: 1,
					style: 'padding:5px 5px 5px 5px;',
					items: [{
							checked: (InputType == '1') || (InputType == ''),
							boxLabel: '¼�뷽ʽһ:������α��ʽ�������������ݰ��������ʵ������',
							id: 'InputModel1',
							name: 'InputModel',
							inputValue: '1',
							disabled: (InputType != '') && (InputType != '1')
						}, {
							checked: false,
							boxLabel: '¼�뷽ʽ��:���������¼�뷽ʽ',
							id: 'InputModel2',
							name: 'InputModel',
							inputValue: '2',
							disabled: (InputType != '') && (InputType != '1')
						}, {
							checked: InputType == '2',
							boxLabel: '¼�뷽ʽ��:��Ʒ�������ʽ�������������ݰ�Ʒ�����ʵ������',
							id: 'InputModel3',
							name: 'InputModel',
							inputValue: '3',
							disabled: (InputType != '') && (InputType != '2')
						}, {
							checked: InputType == '3',
							boxLabel: '¼�뷽ʽ��:��ֵɨ���̵�',
							id: 'InputModel4',
							name: 'InputModel',
							inputValue: '4',
							disabled: InputType != '3'
						}
					]
				}, {
					layout: 'form',
					frame: true,
					border: false,
					labelAlign: 'right',
					items: [InStkTkWin]
				}
			],
			buttons: [returnBT, cancelBT]
		});

	SelInputWin.show();

	function returnData() {
		var selectModel = Ext.getCmp('InputModel').getValue();
		if (selectModel == null) {
			Msg.info("error", "��ѡ��¼�뷽ʽ!");
		} else {
			SelectData();
			SelInputWin.close();
		}
	}

	function SelectData() {
		var selectRadio = Ext.getCmp('InputModel').getValue();
		if (selectRadio) {
			var selectModel = selectRadio.inputValue;
			var instwWin = Ext.getCmp("InStkTkWin").getValue();
			Fn(selectModel, instwWin);
		}
	}
}
