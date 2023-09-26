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
		fieldLabel: 'Ƭ�α��',
		allowBlank: true,
		anchor: '95%'
	});

	var acctSysBusiPhaseDrField = new Ext.form.TextField({
		id:'acctSysBusiPhaseDrField',
		fieldLabel: '�׶α��',
		allowBlank: true,
		anchor: '95%'
	});

	//var acctSysBusiTypeDrField = new Ext.form.TextField({
	//	id:'acctSysBusiTypeDrField',
	//	fieldLabel: '�����',
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
			fieldLabel: '�����',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'ѡ�������...',
			allowBlank: true,
			name:'acctSysBusiTypeCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});			
	
	//var acctYearDrField = new Ext.form.TextField({
	//	id:'acctYearDrField',
	//	fieldLabel: '������',
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
			fieldLabel: '������',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'ѡ�������...',
			allowBlank: true,
			name:'acctYearCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});			
	
	//var acctSubjDrField = new Ext.form.TextField({
	//	id:'acctSubjDrField',
	//	fieldLabel: '��Ŀ����',
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
			fieldLabel: '��Ŀ����',
			typeAhead:true,
			//pageSize:10,
			minChars:1,
			width:150,
			listWidth:150,
			triggerAction:'all',
			emptyText:'ѡ���Ŀ����...',
			allowBlank: true,
			name:'acctSubjCB',
			selectOnFocus: true,
			//mode:'local',
			forceSelection: true
		});	
	
	var summaryField = new Ext.form.TextField({
		id:'summaryField',
		fieldLabel: 'ժҪ',
		allowBlank: false,
		anchor: '95%'
	});
	
	var captionField = new Ext.form.TextField({
		id:'captionField',
		fieldLabel: '��Ŀ����',
		allowBlank: false,
		anchor: '95%'
	});

	//var directionField = new Ext.form.Checkbox({
	//	id:'directionField',
	//	fieldLabel: '�������',
	//	//allowBlank: false,
	//	anchor: '95%'
	//});
	
	var directionCB = new Ext.form.ComboBox({
		//id:'directionCB',
		store: new Ext.data.SimpleStore({
				fields:['name','value'],
				data:[['�跽',0],['����',1]]
			}),
		valueField:'value',
		displayField:'name',
		fieldLabel: '�������',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ��������...',
		allowBlank: true,
		name:'directionCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});	
	
	var isAutoCreateField = new Ext.form.Checkbox({
		id:'isAutoCreateField',
		fieldLabel: '�Ƿ��Զ�',
		//allowBlank: false,
		anchor: '95%'
	});
	
	var relayTypeField = new Ext.form.TextField({
		id:'relayTypeField',
		fieldLabel: '�Զ����',
		allowBlank: true,
		anchor: '95%'
	});
	
	var isGroupField = new Ext.form.Checkbox({
		id:'isGroupField',
		fieldLabel: '�Ƿ����',
		//allowBlank: false,
		anchor: '95%'
	});
	
	//var moneyFieldField = new Ext.form.TextField({
	//	id:'moneyFieldField',
	//	fieldLabel: '����ֶ�',
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
		fieldLabel: '����ֶ�',
		typeAhead:true,
		//pageSize:10,
		minChars:1,
		width:150,
		listWidth:150,
		triggerAction:'all',
		emptyText:'ѡ�����ֶ�...',
		allowBlank: true,
		name:'moneyCB',
		selectOnFocus: true,
		mode:'local',
		forceSelection: true
	});	
	
	var whileSqlField = new Ext.form.TextField({
		id:'whileSqlField',
		fieldLabel: '��Ŀɸѡ����',
		allowBlank: true,
		anchor: '95%'
	});
	
	var isFundField = new Ext.form.Checkbox({
		id:'isFundField',
		fieldLabel: '�Ƿ����',
		//allowBlank: true,
		anchor: '95%'
	});
	
	var isPayField = new Ext.form.Checkbox({
		id:'isPayField',
		fieldLabel: '�Ƿ񸶿�',
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
		title: '���',
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
			text: '����', 
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
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load();
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
						scope: this
					});
				}else{
						Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}             
			}
		},
		{
			text: 'ȡ��',
			handler: function(){window.close();}
		}]
    });

    window.show();
};