wAddFun = function() {

	var codeField = new Ext.form.TextField({
		name:'code',
		fieldLabel: '科室组编码',
		allowBlank: false,
		emptyText: '必填',
		anchor: '100%'
	});
	
	var nameField = new Ext.form.TextField({
		name:'name',
		fieldLabel: '科室组名称',
		allowBlank: false,
		emptyText: '必填',
		anchor: '100%'
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			codeField,
			nameField
		]
	});
	
	var addWin = new Ext.Window({
		title: '添加',
		width: 300,
		height: 130,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons:[{
			text: '保存',
			handler: function() {
				if (formPanel.form.isValid()) {
					tmpData=codeField.getValue().trim()+"^"+nameField.getValue().trim();
					Ext.Ajax.request({
						url: wUrl+'?action=wadd&data='+tmpData,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'操作成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								wDs.load({
									params:{start:0, limit:wPagingToolbar.pageSize},
									callback:function(r,o,s){
										wSM.selectFirstRow();
										cDs.load({params:{start:0, limit:0}});
									}
								});
							}else{
								var tmpmsg='';
								if(jsonData.info!='0'){
									tmpmsg='编码重复!';
								}
								Ext.Msg.show({title:'错误',msg:tmpmsg,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
					Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}
			}
		},
		{
			text: '取消',
			handler: function(){addWin.close();}
		}]
	});
	
	addWin.show();
};
