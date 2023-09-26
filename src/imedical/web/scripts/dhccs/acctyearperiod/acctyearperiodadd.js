addFun = function(dataStore,grid) {
	Ext.QuickTips.init();

	//var acctYearDrField = new Ext.form.TextField({
	//	id:'acctYearDrField',
	//	fieldLabel: '������',
	//	allowBlank: false,
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

	var acctMonthField = new Ext.form.TextField({
		id:'acctMonthField',
		fieldLabel: '����ڼ�',
		allowBlank: false,
		anchor: '95%'
	});

	var beginDateField = new Ext.form.DateField({
		id:'beginDateField',
		fieldLabel: '��ʼ����',
		format: 'Y��m��d��',
		allowBlank: false,
		anchor: '95%'
	});
		
	var endDateField = new Ext.form.DateField({
		id:'endDateField',
		fieldLabel: '��������',
		format: 'Y��m��d��',
		allowBlank: false,
		anchor: '95%'
	});

	var cashFlagField = new Ext.form.Checkbox({
		id:'cashFlagField',
		fieldLabel: '�ֽ����н���',
		allowBlank: false,
		anchor: '95%'
	});
	
	var fixFlagField = new Ext.form.Checkbox({
		id:'fixFlagField',
		fieldLabel: '�̶��ʲ�����',
		allowBlank: false,
		anchor: '95%'
	});
	
	var matFlagField = new Ext.form.Checkbox({
		id:'matFlagField',
		fieldLabel: '���ʽ���',
		allowBlank: false,
		anchor: '95%'
	});
		
	var medFlagField = new Ext.form.Checkbox({
		id:'medFlagField',
		fieldLabel: 'ҩ�����',
		allowBlank: false,
		anchor: '95%'
	});
	
	var drugStoreFlagField = new Ext.form.Checkbox({
		id:'drugStoreFlagField',
		fieldLabel: 'ҩ������',
		allowBlank: false,
		anchor: '95%'
	});
	
	var wageFlagField = new Ext.form.Checkbox({
		id:'wageFlagField',
		fieldLabel: '���ʽ���',
		allowBlank: false,
		anchor: '95%'
	});
	
	var accFlagField = new Ext.form.Checkbox({
		id:'accFlagField',
		fieldLabel: '�������',
		allowBlank: false,
		anchor: '95%'
	});
		
	var budgFlagField = new Ext.form.Checkbox({
		id:'budgFlagField',
		fieldLabel: 'Ԥ�����',
		allowBlank: false,
		anchor: '95%'
	});	
	
	var perfFlagField = new Ext.form.Checkbox({
		id:'perfFlagField',
		fieldLabel: '��Ч����',
		allowBlank: false,
		anchor: '95%'
	});
		
	var costFlagField = new Ext.form.Checkbox({
		id:'costFlagField',
		fieldLabel: '�ɱ�����',
		allowBlank: false,
		anchor: '95%'
	});	
		
	var matCheckDateField = new Ext.form.DateField({
		id:'matCheckDateField',
		fieldLabel: '���ʽ�������',
		format: 'Y��m��d��',
		allowBlank: true,
		anchor: '95%'
	});
		
	var fixCheckDateField = new Ext.form.DateField({
		id:'fixCheckDateField',
		fieldLabel: '�̶��ʲ�����',
		format: 'Y��m��d��',
		allowBlank: true,
		anchor: '95%'
	});
	
	var isDepreciationField = new Ext.form.Checkbox({
		id:'isDepreciationField',
		fieldLabel: '�Ƿ����',
		allowBlank: false,
		anchor: '95%'
	});	
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
			//acctYearDrField, 
			acctYearCB,
			acctMonthField,
			beginDateField,
			endDateField,
			cashFlagField,
			fixFlagField,
			matFlagField,
			medFlagField,
			drugStoreFlagField,
			wageFlagField,
			accFlagField,
			budgFlagField,
			perfFlagField,
			costFlagField,
			matCheckDateField,
			fixCheckDateField,
			isDepreciationField
		]
	});

	var window = new Ext.Window({
		title: '����',
		width: 300,
		height:520,
		minWidth: 300,
		minHeight: 520,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			handler: function() {

				if (formPanel.form.isValid()) {
								
					//var acctYearDr= 	acctYearDrField.getValue();
					var acctMonth=      acctMonthField.getValue();
					var beginDate=      beginDateField.getValue().format('Y-m-d');
					var endDate=        endDateField.getValue().format('Y-m-d');
					var cashFlag=       (cashFlagField.getValue()==true)?'1':'0';
					var fixFlag=        (fixFlagField.getValue()==true)?'1':'0';
					var matFlag=        (matFlagField.getValue()==true)?'1':'0';
					var medFlag=        (medFlagField.getValue()==true)?'1':'0';
					var drugStoreFlag=  (drugStoreFlagField.getValue()==true)?'1':'0';
					var wageFlag=       (wageFlagField.getValue()==true)?'1':'0';
					var accFlag=        (accFlagField.getValue()==true)?'1':'0';
					var budgFlag=       (budgFlagField.getValue()==true)?'1':'0';
					var perfFlag=       (perfFlagField.getValue()==true)?'1':'0';
					var costFlag=       (costFlagField.getValue()==true)?'Y':'N';
					var matCheckDate='';
					if(matCheckDateField.getValue()!=''){
						matCheckDate=   matCheckDateField.getValue().format('Y-m-d');
					}
					var fixCheckDate='';
					if(fixCheckDateField.getValue()!=''){
						fixCheckDate=   fixCheckDateField.getValue().format('Y-m-d');
					}
					var isDepreciation= (isDepreciationField.getValue()==true)?'1':'0';
					
					//acctYearDr = acctYearDr.trim();
					acctMonth = acctMonth.trim();
			
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=addacctyearperiod&acctYearDr='+acctYearCB.getValue()+'&acctMonth='+acctMonth+'&beginDate='+beginDate+'&endDate='+endDate+'&cashFlag='+cashFlag+'&fixFlag='+fixFlag+'&matFlag='+matFlag+'&medFlag='+medFlag+'&drugStoreFlag='+drugStoreFlag+'&wageFlag='+wageFlag+'&accFlag='+accFlag+'&budgFlag='+budgFlag+'&perfFlag='+perfFlag+'&costFlag='+costFlag+'&matCheckDate='+matCheckDate+'&fixCheckDate='+fixCheckDate+'&isDepreciation='+isDepreciation,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'���ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
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