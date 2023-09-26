editFun = function(dataStore,grid) {
	
	Ext.QuickTips.init();

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var rowid = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		rowid = rowObj[0].get("rowid");
	}

	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel: '模块编号',
		allowBlank: false,
		name:'code',
		anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel: '模块名称',
		allowBlank: false,
		name:'name',
		anchor: '95%'
	});

	var isAutoVouchField = new Ext.form.Checkbox({
		id:'isAutoVouchField',
		fieldLabel: '是否自动生成凭证',
		allowBlank: false,
		name:'isAutoVouch',
		anchor: '95%'
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			codeField,
            nameField,
            isAutoVouchField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			isAutoVouchField.setValue((rowObj[0].data['isAutoVouch'])=='1'?true:false);
		});
    
	var window = new Ext.Window({
		title: '修改',
		width: 300,
		height:200,
		minWidth: 300,
		minHeight: 200,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存', 
			handler: function() {
				
				var	code = codeField.getValue();
				var	name = nameField.getValue();
				var	isAutoVouch = (isAutoVouchField.getValue()==true)?'1':'0';
				
				code = code.trim();
				name = name.trim();
				
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=editacctsysmode&rowid='+rowid+'&code='+code+'&name='+name+'&isAutoVouch='+isAutoVouch,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load();
								window.close();
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
					scope: this
					});
				}
				else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
				}
			},
			{
					text: '取消',
			handler: function(){window.close();}
		}]
	});
    window.show();
};