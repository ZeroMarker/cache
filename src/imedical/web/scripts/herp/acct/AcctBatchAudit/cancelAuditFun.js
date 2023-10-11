var userdr = session['LOGON.USERID'];
var projUrl = '../csp/herp.acct.acctbatchauditexe.csp';

function cancelAuditFun(vouchidDs) {

	//////////////// 多文本域 ////////////////////
	var textArea = new Ext.form.TextArea({
			id: 'textArea',
			width: 500,
			height:120,
			anchor: '100%',
			fieldLabel: '反审核意见',
			//allowBlank :false,
			selectOnFocus: 'true',
			emptyText: '请填写审核意见（少于100字）……'
		});

	/////////////// 导入说明多文本域 /////////////////////////
	var viewFieldSet = new Ext.form.FieldSet({
			title: '反审核意见',
			height: 160,
			labelSeparator: '：',
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
			text: '确定'
		});

	//////////////////////////  增加按钮响应函数   //////////////////////////////
	addHandler = function () {

		var view = encodeURIComponent(Ext.getCmp('textArea').getRawValue());
		var statusid = -1; //statusid=1通过，0为不通过，-1为反审核

		var vouchid = vouchidDs.join();
		Ext.Ajax.request({
			url: projUrl + '?action=veraudit' + '&userdr=' + userdr + '&vouchid=' + vouchid + 
			'&ChkResult=&view=' + view + '&statusid=' + statusid + 
			'&bookID=' + bookID,
			waitMsg: '反审核中...',
			failure: function (result, request) {
				Ext.Msg.show({
					title: '错误',
					msg: '请检查网络连接! ',
					buttons: Ext.Msg.OK,
					icon: Ext.MessageBox.ERROR
				});
			},
			success: function (result, request) {
				var jsonData = Ext.util.JSON.decode(result.responseText);
				if ((jsonData.success == 'true')) {
					Ext.Msg.show({
						title: '注意',
						msg: '反审核完成! ',
						icon: Ext.MessageBox.INFO,
						buttons: Ext.Msg.OK
					});
					//itemGrid.store.load({params:{start:0, limit:25,userdr:userdr}});
					var tbarnum = itemGrid.getBottomToolbar();
					tbarnum.doLoad(tbarnum.cursor);
					addwin.close();
				} else {
					Ext.Msg.show({
						title: '错误',
						msg: '反审核失败！'+jsonData.info,
						buttons: Ext.Msg.OK,
						icon: Ext.MessageBox.ERROR
					});
				}
			},
			scope: this
		});

		
	}

	////// 添加监听事件 ////////////////
	addButton.addListener('click', addHandler, false);

	cancelButton = new Ext.Toolbar.Button({
			text: '取消'
		});

	cancelHandler = function () {
		addwin.close();
	}

	cancelButton.addListener('click', cancelHandler, false);

	var addwin = new Ext.Window({
			title: '反审核',
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
