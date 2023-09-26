// /名称: 选择录入方式
// /描述: 选择录入方式
// /编写者：zhangdongmei
// /编写日期: 2012.09.04

function SelectModel(InputType, Fn) {
	Ext.QuickTips.init();
	Ext.BLANK_IMAGE_URL = Ext.BLANK_IMAGE_URL;

	// 确定按钮
	var returnBT = new Ext.Toolbar.Button({
			text: '确定',
			tooltip: '点击确定',
			iconCls: 'page_goto',
			handler: function () {
				returnData();
			}
		});

	// 取消按钮
	var cancelBT = new Ext.Toolbar.Button({
			text: '取消',
			tooltip: '点击取消',
			iconCls: 'page_close',
			handler: function () {
				SelInputWin.close();
			}
		});

	var InStkTkWin = new Ext.ux.ComboBox({
			fieldLabel: '实盘窗口',
			id: 'InStkTkWin',
			name: 'InStkTkWin',
			anchor: '90%',
			emptyText: '实盘窗口...',
			store: INStkTkWindowStore,
			valueField: 'RowId',
			displayField: 'Description',
			params: {
				'LocId': 'PhaLoc'
			},
			disabled: InputType == '3'
		});

	var SelInputWin = new Ext.Window({
			title: '实盘录入方式选择',
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
							boxLabel: '录入方式一:填充批次表格式（根据帐盘数据按批次填充实盘数）',
							id: 'InputModel1',
							name: 'InputModel',
							inputValue: '1',
							disabled: (InputType != '') && (InputType != '1')
						}, {
							checked: false,
							boxLabel: '录入方式二:按库存批次录入方式',
							id: 'InputModel2',
							name: 'InputModel',
							inputValue: '2',
							disabled: (InputType != '') && (InputType != '1')
						}, {
							checked: InputType == '2',
							boxLabel: '录入方式三:按品种填充表格式（根据帐盘数据按品种填充实盘数）',
							id: 'InputModel3',
							name: 'InputModel',
							inputValue: '3',
							disabled: (InputType != '') && (InputType != '2')
						}, {
							checked: InputType == '3',
							boxLabel: '录入方式四:高值扫码盘点',
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
			Msg.info("error", "请选择录入方式!");
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
