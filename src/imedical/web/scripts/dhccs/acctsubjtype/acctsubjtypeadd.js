addFun = function(dataStore,grid) {
	Ext.QuickTips.init();

	var compCodeField = new Ext.form.TextField({
		id:'compCodeField',
		fieldLabel: '单位编码',
		allowBlank: false,
		anchor: '95%'
	});

	var copyCodeField = new Ext.form.TextField({
		id:'copyCodeField',
		fieldLabel: '账套编码',
		allowBlank: false,
		anchor: '95%'
	});
	
	var noteField = new Ext.form.TextField({
		id:'noteField',
		fieldLabel: '说明',
		allowBlank: false,
		anchor: '95%'
	});

	var subjTypeCodeField = new Ext.form.TextField({
		id:'subjTypeCodeField',
		fieldLabel: '科目类别编码',
		allowBlank: false,
		anchor: '95%'
	});

	var subjTypeNameField = new Ext.form.TextField({
		id:'subjTypeNameField',
		fieldLabel: '科目类别名称',
		allowBlank: false,
		anchor: '95%'
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
    		compCodeField,
            copyCodeField,
            noteField,
            subjTypeCodeField,
            subjTypeNameField
		]
	});

	var window = new Ext.Window({
		title: '添加',
		width: 300,
		height:210,
		minWidth: 300,
		minHeight: 210,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存', 
			handler: function() {
			
				var	compCode = compCodeField.getValue();
				var	copyCode = copyCodeField.getValue();
				var	note = noteField.getValue();
				var	subjTypeCode = subjTypeCodeField.getValue();
				var	subjTypeName = subjTypeNameField.getValue();

				
				compCode = compCode.trim();
				copyCode = copyCode.trim();
				note = note.trim();
				subjTypeCode =	subjTypeCode.trim();
				subjTypeName = subjTypeName.trim();
				
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=addacctsubjtype&compCode='+compCode+'&copyCode='+copyCode+'&note='+note+'&subjTypeCode='+subjTypeCode+'&subjTypeName='+subjTypeName,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load();
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
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