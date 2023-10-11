
var userdr = session['LOGON.USERID']; //登录人ID
var projUrl = 'herp.acct.acctcashiersignexe.csp';

function cancelsigndetail(arr) {

	//////////////// 审批结果 ////////////////////
	var ResultField = new Ext.form.TextField({
			id: 'ResultField',
			width: 500,
			anchor: '100%',
			fieldLabel: '审批结果',
			disabled: true,
			selectOnFocus: 'true',
			value: '不通过'
		});
	var viewResultSet = new Ext.form.FieldSet({
			title: '审批结果',
			height: 70,
			labelSeparator: '：',
			items: ResultField
		});
	//////////////// 多文本域 ////////////////////
	var textArea = new Ext.form.TextArea({
			id: 'textArea',
			width: 500,
			anchor: '100%',
			fieldLabel: '审批意见',
			allowBlank: false,
			selectOnFocus: 'true',
			emptyText: '请填写审批意见（少于100字）……'
		});

	/////////////// 导入说明多文本域 /////////////////////////
	var viewFieldSet = new Ext.form.FieldSet({
			title: '审批意见',
			height: 110,
			labelSeparator: '：',
			items: textArea
		});

	//***定义结构***//
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
						//checkFieldSet,
						viewResultSet,
						viewFieldSet
					]
				}
			]
		}
	];
	//***加载面板(框架)***//
	var formPanel = new Ext.form.FormPanel({
			labelWidth: 80,
			frame: true,
			items: colItems
		});
	//***确定按钮***//
	var addButton = new Ext.Toolbar.Button({
			text: '确定'
		});

	var cancelButton = new Ext.Toolbar.Button({
			text: '取消',
			handler: function () {
				addwin.close();
			}
		});

	var addwin = new Ext.Window({
			title: '申请说明+审批意见',
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

	//***确定按钮响应函数****///
	var addHandler = function () {
		var ChkResult = encodeURIComponent(ResultField.getValue());
		var view = encodeURI(Ext.getCmp('textArea').getRawValue().trim());
		// var win_closed=false;	//是否关闭弹出的审批意见窗口
		var rowid = arr.join();
		Ext.Ajax.request({
			url: projUrl + '?action=CancelSign&userdr=' + userdr + '&ChkResult=' + ChkResult +
			'&view=' + view + '&rowid=' + rowid + '&acctbookid=' + acctbookid,
			waitMsg: '取消中...',
			failure: function (result, request) {
				Ext.Msg.show({
					title: '错误',
					msg: '请检查网络连接!',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
				
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				// console.log(jsonData)
				if ((jsonData.success == 'true')) {
					// win_closed=true;	//是否关闭弹出的审批意见窗口
					Ext.Msg.show({
						title: '注意',
						msg: '取消签字完成! ',
						icon: Ext.MessageBox.INFO,
						buttons: Ext.Msg.OK
					});
					var tbarnum = itemGrid.getBottomToolbar();
					tbarnum.doLoad(tbarnum.cursor);
					
					addwin.close();
				} else {
					Ext.Msg.show({
						title: '错误',
						msg: '取消签字失败! ' + jsonData.info,
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.ERROR
					});
				}
			},
			scope: this
		});
		
	}

	//***添加监听事件***//
	addButton.addListener('click', addHandler, false);

}
