addFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();

	var creCodeField = new Ext.form.TextField({
		id:'creCode',
		fieldLabel: 'creCode',
		allowBlank: true,
		anchor: '95%'
	});

	var creDescField = new Ext.form.TextField({
		id:'creDesc',
		fieldLabel: 'creDesc',
		allowBlank: true,
		anchor: '95%'
	});
		
	//var creDataSourceField = new Ext.form.TextField({
	//	id:'creDataSource',
	//	fieldLabel: 'creDataSource',
	//	allowBlank: true,
	//	anchor: '95%'
	//});	
	
	var creDataSourceCB = new Ext.form.ComboBox({
		store: new Ext.data.SimpleStore({
				fields:['name'],
				data:[['FP'],['YJ'],['ALL']]
			}),
		valueField:'name',
		displayField:'name',
		fieldLabel: 'creDataSource',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'creDataSource...',
		allowBlank: true,
		name:'creDataSourceCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});		
	
	//var crePatTypeField = new Ext.form.TextField({
	//	id:'crePatType',
	//	fieldLabel: 'crePatType',
	//	allowBlank: true,
	//	anchor: '95%'
	//});
	
	var crePatTypeCB = new Ext.form.ComboBox({
		store: new Ext.data.SimpleStore({
				fields:['value','name'],
				data:[['I','In Patient'],['O','Out Patient'],['A','ALL']]
			}),
		valueField:'value',
		displayField:'name',
		fieldLabel: 'crePatType',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'crePatType...',
		allowBlank: true,
		name:'crePatTypeCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});	
	
	var creDateField = new Ext.form.DateField({
		id:'creDate',
		fieldLabel: 'creDate',
		format: 'Y年m月d日',
		allowBlank: true,
		anchor: '95%'
	});
		
	var creTimeField = new Ext.form.TimeField({
		id:'creTime',
		format:'H:i',
		increment: 30,
		fieldLabel: 'creTime',
		allowBlank: true,
		anchor: '95%'
	});
	
	var creActiveFlagField = new Ext.form.Checkbox({
		id:'creActiveFlag',
		fieldLabel: 'creActiveFlag',
		allowBlank: true,
		anchor: '95%'
	});

	var creStartDateField = new Ext.form.DateField({
		id:'creStartDate',
		fieldLabel: 'creStartDate',
		allowBlank: true,
		anchor: '95%'
	});
		
	var creEndDateField = new Ext.form.DateField({
		id:'creEndDate',
		fieldLabel: 'creEndDate',
		allowBlank: true,
		anchor: '95%'
	});
	
	var crePrePrtFlagField = new Ext.form.Checkbox({
		id:'crePrePrtFlag',
		fieldLabel: 'crePrePrtFlag',
		allowBlank: true,
		anchor: '95%'
	});

	var creIncluAbortField = new Ext.form.Checkbox({
		id:'creIncluAbort',
		fieldLabel: 'creIncluAbort',
		allowBlank: true,
		anchor: '95%'
	});

	var creModeCodeField = new Ext.form.TextField({
		id:'creModeCode',
		fieldLabel: 'creModeCode',
		allowBlank: true,
		anchor: '95%'
	});
	
	
	var creBusiTypeField = new Ext.form.TextField({
		id:'creBusiType',
		fieldLabel: 'creBusiType',
		allowBlank: true,
		anchor: '95%'
	});

	var creNote1Field = new Ext.form.TextField({
		id:'creNote1',
		fieldLabel: 'creNote1',
		allowBlank: true,
		anchor: '95%'
	});
		
	var creNote2Field = new Ext.form.TextField({
		id:'creNote2',
		fieldLabel: 'creNote2',
		allowBlank: true,
		anchor: '95%'
	});
	
	var creNote3Field = new Ext.form.TextField({
		id:'creNote3',
		fieldLabel: 'creNote3',
		allowBlank: true,
		anchor: '95%'
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [		
			creCodeField,	
			creDescField,
			creDataSourceCB,
			crePatTypeCB,
			creDateField,
			creTimeField,
			creActiveFlagField,
			creStartDateField,
			creEndDateField,
			crePrePrtFlagField,
			creIncluAbortField,	
			creModeCodeField,
			creBusiTypeField,
			creNote1Field,
			creNote2Field,
			creNote3Field
		]
	});

	var window = new Ext.Window({
		title: '添加',
		width: 300,
		height:500,
		minWidth: 300,
		minHeight: 500,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存', 
			handler: function() {
			
				var creCode = creCodeField.getValue();	
				var creDesc = creDescField.getValue();
				var creDate = ((creDateField.getValue()=='')?'':creDateField.getValue().format('Y-m-d'));
				var creTime = creTimeField.getValue();
				var creActiveFlag = (creActiveFlagField.getValue()==true)?'Y':'N';
				var creStartDate = ((creStartDateField.getValue()=='')?'':creStartDateField.getValue().format('Y-m-d'));
				var creEndDate = ((creEndDateField.getValue()=='')?'':creEndDateField.getValue().format('Y-m-d'));
				var crePrePrtFlag = (crePrePrtFlagField.getValue()==true)?'Y':'N';
				var creIncluAbort = (creIncluAbortField.getValue()==true)?'Y':'N';
				var creModeCode = creModeCodeField.getValue();
				var creBusiType = creBusiTypeField.getValue();
				var creNote1 = creNote1Field.getValue();
				var creNote2 = creNote2Field.getValue();
				var creNote3 = creNote3Field.getValue();
				
				creCode = creCode.trim();	
				creDesc = creDesc.trim();
				creTime = creTime.trim();
				creModeCode = creModeCode.trim();
				creBusiType = creBusiType.trim();
				creNote1 = creNote1.trim();
				creNote2 = creNote2.trim();
				creNote3 = creNote3.trim();
				
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=adddhcacccre&creCode='+creCode+'&creDesc='+creDesc+'&creDataSource='+creDataSourceCB.getValue()+'&crePatType='+crePatTypeCB.getValue()+'&creDate='+creDate+'&creTime='+creTime+'&creActiveFlag='+creActiveFlag+'&creStartDate='+creStartDate+'&creEndDate='+creEndDate+'&crePrePrtFlag='+crePrePrtFlag+'&creIncluAbort='+creIncluAbort+'&creModeCode='+creModeCode+'&creBusiType='+creBusiType+'&creNote1='+creNote1+'&creNote2='+creNote2+'&creNote3='+creNote3,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
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