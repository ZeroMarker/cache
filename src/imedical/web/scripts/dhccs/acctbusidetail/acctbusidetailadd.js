addFun = function(dataStore,grid) {
	Ext.QuickTips.init();

	//'rowid',
	//'acctSysBusiSectionDr',
	//'acctSysBusiPhaseDr',
	//'acctSysBusiTypeDr',
	//'acctYearDr',
	//'acctSubjDr',
	//'summary',
	//'caption',
	//'direction',
	//'isAutoCreate',
	//'relayType',
	//'isGroup',
	//'moneyField',
	//'whileSql',
	//'isFund',
	//'isPay'

	var acctSysBusiSectionDrField = new Ext.form.TextField({
		id:'acctSysBusiSectionDrField',
		fieldLabel: '片段编号',
		allowBlank: true,
		anchor: '95%'
	});

	var acctSysBusiPhaseDrField = new Ext.form.TextField({
		id:'acctSysBusiPhaseDrField',
		fieldLabel: '阶段编号',
		allowBlank: true,
		anchor: '95%'
	});

	//var acctSysBusiTypeDrField = new Ext.form.TextField({
	//	id:'acctSysBusiTypeDrField',
	//	fieldLabel: '类别编号',
	//	allowBlank: false,
	//	anchor: '95%'
	//});
	
	var acctSysBusiTypeST = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['typeName','rowid'])
	});
	
	acctSysBusiTypeST.on(
			'beforeload',
			function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsysbusitype', method:'GET'});
			}
		);	
		
	var acctSysBusiTypeCB = new Ext.form.ComboBox({
			//id:'acctSysBusiTypeCB',
			store: acctSysBusiTypeST,
			valueField:'rowid',
			displayField:'typeName',
			fieldLabel: '类别编号',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'选择类别编号...',
			allowBlank: true,
			name:'acctSysBusiTypeCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});			
	
	//var acctYearDrField = new Ext.form.TextField({
	//	id:'acctYearDrField',
	//	fieldLabel: '会计年度',
	//	allowBlank: true,
	//	anchor: '95%'
	//});
	
	var acctYearST = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['acctYear','rowid'])
	});
	
	acctYearST.on(
			'beforeload',
			function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctyear', method:'GET'});
			}
		);	
		
	var acctYearCB = new Ext.form.ComboBox({
			//id:'acctYearCB',
			store: acctYearST,
			valueField:'rowid',
			displayField:'acctYear',
			fieldLabel: '会计年度',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'选择会计年度...',
			allowBlank: true,
			name:'acctYearCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});			
	
	//var acctSubjDrField = new Ext.form.TextField({
	//	id:'acctSubjDrField',
	//	fieldLabel: '科目编码',
	//	allowBlank: false,
	//	anchor: '95%'
	//});

	var acctSubjST = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'}, ['aCCTSubjName','rowid'])
	});
	
	acctSubjST.on(
			'beforeload',
			function(ds, o) {
				ds.proxy = new Ext.data.HttpProxy({url:'dhc.cs.baseexe.csp?action=listacctsubj', method:'GET'});
			}
		);	
		
	var acctSubjCB = new Ext.form.ComboBox({
			//id:'acctSubjCB',
			store: acctSubjST,
			valueField:'rowid',
			displayField:'aCCTSubjName',
			fieldLabel: '科目编码',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'选择科目编码...',
			allowBlank: true,
			name:'acctSubjCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});	
	
	var summaryField = new Ext.form.TextField({
		id:'summaryField',
		fieldLabel: '摘要',
		allowBlank: false,
		anchor: '95%'
	});
	
	var captionField = new Ext.form.TextField({
		id:'captionField',
		fieldLabel: '科目标题',
		allowBlank: false,
		anchor: '95%'
	});

	//var directionField = new Ext.form.Checkbox({
	//	id:'directionField',
	//	fieldLabel: '借贷方向',
	//	//allowBlank: false,
	//	anchor: '95%'
	//});
	
	var directionCB = new Ext.form.ComboBox({
		//id:'directionCB',
		store: new Ext.data.SimpleStore({
				fields:['name','value'],
				data:[['借方',0],['贷方',1]]
			}),
		valueField:'value',
		displayField:'name',
		fieldLabel: '借贷方向',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'选择借贷方向...',
		allowBlank: true,
		name:'directionCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});	
	
	var isAutoCreateField = new Ext.form.Checkbox({
		id:'isAutoCreateField',
		fieldLabel: '是否自动',
		//allowBlank: false,
		anchor: '95%'
	});
	
	var relayTypeField = new Ext.form.TextField({
		id:'relayTypeField',
		fieldLabel: '自动序号',
		allowBlank: true,
		anchor: '95%'
	});
	
	var isGroupField = new Ext.form.Checkbox({
		id:'isGroupField',
		fieldLabel: '是否分组',
		//allowBlank: false,
		anchor: '95%'
	});
	
	//var moneyFieldField = new Ext.form.TextField({
	//	id:'moneyFieldField',
	//	fieldLabel: '金额字段',
	//	allowBlank: false,
	//	anchor: '95%'
	//});	
	
	var moneyCB = new Ext.form.ComboBox({
		//id:'moneyCB',
		store: new Ext.data.SimpleStore({
				fields:['name'],
				data:[['P'],['S'],['M']]
			}),
		valueField:'name',
		displayField:'name',
		fieldLabel: '金额字段',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'选择金额字段...',
		allowBlank: true,
		name:'moneyCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});	
	
	var whileSqlField = new Ext.form.TextField({
		id:'whileSqlField',
		fieldLabel: '科目筛选条件',
		allowBlank: true,
		anchor: '95%'
	});
	
	var isFundField = new Ext.form.Checkbox({
		id:'isFundField',
		fieldLabel: '是否基金',
		//allowBlank: true,
		anchor: '95%'
	});
	
	var isPayField = new Ext.form.Checkbox({
		id:'isPayField',
		fieldLabel: '是否付款',
		//allowBlank: true,
		anchor: '95%'
	});

	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		autoScroll:true,
		labelWidth: 80,
		items: [
    		acctSysBusiSectionDrField,
            acctSysBusiPhaseDrField,
            //acctSysBusiTypeDrField,
			acctSysBusiTypeCB,
			//acctYearDrField,
			acctYearCB,
			acctSubjCB,
			summaryField,	
    		captionField,
            directionCB,
            isAutoCreateField,
			relayTypeField,
			isGroupField,
			moneyCB,
    		whileSqlField,
            isFundField,
            isPayField
		]
	});

	var window = new Ext.Window({
		title: '添加',
		width: 300,
		height:470,
		minWidth: 300,
		minHeight: 470,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存', 
			handler: function() {
				
				var acctSysBusiSectionDr =  acctSysBusiSectionDrField.getValue();
				var acctSysBusiPhaseDr	 =  acctSysBusiPhaseDrField.getValue();
				//var acctSysBusiTypeDr	 =  acctSysBusiTypeDrField.getValue();
				//var acctYearDr			 =  acctYearDrField.getValue();
				//var acctSubjDr			 =  acctSubjDrField.getValue();
				var summary				 =  summaryField.getValue();	
				var caption				 =  captionField.getValue();
				//var direction			 = (directionField.getValue()==true)?'1':'0';
				var isAutoCreate		 = (isAutoCreateField.getValue()==true)?'1':'0';
				var relayType			 =  relayTypeField.getValue();
				var isGroup				 = (isGroupField.getValue()==true)?'1':'0';
				//var moneyField			 =  moneyFieldField.getValue();
				var whileSql			 =  whileSqlField.getValue();
				var isFund				 = (isFundField.getValue()==true)?'1':'0';
				var isPay				 = (isPayField.getValue()==true)?'1':'0';
				
				acctSysBusiSectionDr = acctSysBusiSectionDr.trim();
				acctSysBusiPhaseDr	 = acctSysBusiPhaseDr.trim();	
				//acctSysBusiTypeDr	 = acctSysBusiTypeDr.trim();	
				//acctYearDr			 = acctYearDr.trim();			
				//acctSubjDr			 = acctSubjDr.trim();			
				summary				 = summary.trim();				
				caption				 = caption.trim();				
				relayType            = relayType.trim();           
				//moneyField	         = moneyField.trim();	        
				whileSql             = whileSql.trim();            
								
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=addacctbusidetail&acctSysBusiSectionDr='+acctSysBusiSectionDr+'&acctSysBusiPhaseDr='+acctSysBusiPhaseDr+'&acctSysBusiTypeDr='+acctSysBusiTypeCB.getValue()+'&acctYearDr='+acctYearCB.getValue()+'&acctSubjDr='+acctSubjCB.getValue()+'&summary='+summary+'&caption='+caption+'&direction='+directionCB.getValue()+'&isAutoCreate='+isAutoCreate+'&relayType='+relayType+'&isGroup='+isGroup+'&moneyField='+moneyCB.getValue()+'&whileSql='+whileSql+'&isFund='+isFund+'&isPay='+isPay,
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