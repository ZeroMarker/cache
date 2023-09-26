addFun = function(dataStore,grid,pagingTool,parRef) {
	Ext.QuickTips.init();

	var creSubDescField = new Ext.form.TextField({
		id:'creSubDesc',
		fieldLabel: 'creSubDesc',
		allowBlank: true,
		anchor: '95%'
	});

	//var creSubDataSourceField = new Ext.form.TextField({
	//	id:'creSubDataSource',
	//	fieldLabel: 'creSubDataSource',
	//	allowBlank: true,
	//	anchor: '95%'
	//});

	var creSubDataSourceCB = new Ext.form.ComboBox({
		store: new Ext.data.SimpleStore({
				fields:['name'],
				data:[['FP'],['YJ'],['ALL']]
			}),
		valueField:'name',
		displayField:'name',
		fieldLabel: 'creSubDataSource',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'creSubDataSource...',
		allowBlank: true,
		name:'creSubDataSourceCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});		
	
	//var creSubPatTypeField = new Ext.form.TextField({
	//	id:'creSubPatType',
	//	fieldLabel: 'creSubPatType',
	//	allowBlank: true,
	//	anchor: '95%'
	//});		
	
	var creSubPatTypeCB = new Ext.form.ComboBox({
		store: new Ext.data.SimpleStore({
				fields:['value','name'],
				data:[['I','In Patient'],['O','Out Patient'],['A','ALL']]
			}),
		valueField:'value',
		displayField:'name',
		fieldLabel: 'creSubPatType',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'creSubPatType...',
		allowBlank: true,
		name:'creSubPatTypeCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});	
	
	var creSubAccItemField = new Ext.form.TextField({
		id:'creSubAccItem',
		fieldLabel: 'creSubAccItem',
		allowBlank: true,
		anchor: '95%'
	});
	
	var creSubadmreasonField = new Ext.form.TextField({
		id:'creSubadmreason',
		fieldLabel: 'creSubadmreason',
		//format: 'Y年m月d日',
		allowBlank: true,
		anchor: '95%'
	});

	var creSubpaymodeField = new Ext.form.TextField({
		id:'creSubpaymode',
		fieldLabel: 'creSubpaymode',
		allowBlank: true,
		anchor: '95%'
	});

	var creSubcatField = new Ext.form.TextField({
		id:'creSubcat',
		fieldLabel: 'creSubcat',
		allowBlank: true,
		anchor: '95%'
	});
		
	var creSubLocField = new Ext.form.TextField({
		id:'creSubLoc',
		fieldLabel: 'creSubLoc',
		allowBlank: true,
		anchor: '95%'
	});
	
	var creSubFlag1Field = new Ext.form.TextField({
		id:'creSubFlag1',
		fieldLabel: 'creSubFlag1',
		allowBlank: true,
		anchor: '95%'
	});

	var creSubFlag2Field = new Ext.form.TextField({
		id:'creSubFlag2',
		fieldLabel: 'creSubFlag2',
		allowBlank: true,
		anchor: '95%'
	});

	var creSubFlag3Field = new Ext.form.TextField({
		id:'creSubFlag3',
		fieldLabel: 'creSubFlag3',
		allowBlank: true,
		anchor: '95%'
	});
	
	
	var creSubFlag4Field = new Ext.form.TextField({
		id:'creSubFlag4',
		fieldLabel: 'creSubFlag4',
		allowBlank: true,
		anchor: '95%'
	});

	var creSubFlag5Field = new Ext.form.TextField({
		id:'creSubFlag5',
		fieldLabel: 'creSubFlag5',
		allowBlank: true,
		anchor: '95%'
	});
		
	var creSubPrePrtFlagField = new Ext.form.Checkbox({
		id:'creSubPrePrtFlag',
		fieldLabel: 'creSubPrePrtFlag',
		allowBlank: true,
		anchor: '95%'
	});
	
	var creSubIncluAbortField = new Ext.form.Checkbox({
		id:'creSubIncluAbort',
		fieldLabel: 'creSubIncluAbort',
		allowBlank: true,
		anchor: '95%'
	});
	
	var creSubDFContainsField = new Ext.form.TextField({
		id:'creSubDFContains',
		fieldLabel: 'creSubDFContains',
		allowBlank: true,
		anchor: '95%'
	});
	
	var creSubJFContainsField = new Ext.form.TextField({
		id:'creSubJFContains',
		fieldLabel: 'creSubJFContains',
		allowBlank: true,
		anchor: '95%'
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [		
			creSubDescField,
			//creSubDataSourceField,
			creSubDataSourceCB,
			//creSubPatTypeField,
			creSubPatTypeCB,
			creSubAccItemField,
			creSubadmreasonField,
			creSubpaymodeField,
			creSubcatField,
			creSubLocField,
			creSubFlag1Field,
			creSubFlag2Field,
			creSubFlag3Field,
			creSubFlag4Field,
			creSubFlag5Field,
			creSubPrePrtFlagField,
			creSubIncluAbortField,
			creSubDFContainsField,
			creSubJFContainsField
		]
	});

	var window = new Ext.Window({
		title: '添加',
		width: 700,
		height:530,
		minWidth: 700,
		minHeight: 530,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存', 
			handler: function() {
			
				var creSubDesc		 =	creSubDescField.getValue();
				var creSubAccItem	 =	creSubAccItemField.getValue();
				var creSubadmreason	 =	creSubadmreasonField.getValue();
				var creSubpaymode	 =	creSubpaymodeField.getValue();
				var creSubcat		 =	creSubcatField.getValue();
				var creSubLoc		 =	creSubLocField.getValue();
				var creSubFlag1		 =	creSubFlag1Field.getValue();
				var creSubFlag2		 =	creSubFlag2Field.getValue();
				var creSubFlag3		 =	creSubFlag3Field.getValue();
				var creSubFlag4		 =	creSubFlag4Field.getValue();
				var creSubFlag5		 =	creSubFlag5Field.getValue();
				var creSubPrePrtFlag =	(creSubPrePrtFlagField.getValue()==true)?'Y':'N';
				var creSubIncluAbort =	(creSubIncluAbortField.getValue()==true)?'Y':'N';
				var creSubDFContains =	creSubDFContainsField.getValue();
				var creSubJFContains =	creSubJFContainsField.getValue();
				
				creSubDesc		 = creSubDesc.trim();			
				creSubAccItem	 = creSubAccItem.trim();		
				creSubadmreason	 = creSubadmreason.trim();		
				creSubpaymode	 = creSubpaymode.trim();		
				creSubcat		 = creSubcat.trim();			
				creSubLoc		 = creSubLoc.trim();			
				creSubFlag1		 = creSubFlag1.trim();			
				creSubFlag2		 = creSubFlag2.trim();			
				creSubFlag3		 = creSubFlag3.trim();			
				creSubFlag4		 = creSubFlag4.trim();			
				creSubFlag5		 = creSubFlag5.trim();			
				creSubDFContains = creSubDFContains.trim();	
				creSubJFContains = creSubJFContains.trim();	
				
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=adddhcacccresub&creSubParRef='+parRef+'&creSubDesc='+creSubDesc+'&creSubDataSource='+creSubDataSourceCB.getValue()+'&creSubPatType='+creSubPatTypeCB.getValue()+'&creSubAccItem='+creSubAccItem+'&creSubadmreason='+creSubadmreason+'&creSubpaymode='+creSubpaymode+'&creSubcat='+creSubcat+'&creSubLoc='+creSubLoc+'&creSubFlag1='+creSubFlag1+'&creSubFlag2='+creSubFlag2+'&creSubFlag3='+creSubFlag3+'&creSubFlag4='+creSubFlag4+'&creSubFlag5='+creSubFlag5+'&creSubPrePrtFlag='+creSubPrePrtFlag+'&creSubIncluAbort='+creSubIncluAbort+'&creSubDFContains='+creSubDFContains+'&creSubJFContains='+creSubJFContains,
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