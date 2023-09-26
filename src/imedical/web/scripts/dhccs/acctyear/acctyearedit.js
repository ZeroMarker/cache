editFun = function(dataStore,grid) {
	
	Ext.QuickTips.init();

	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;
	var rowid = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{
		rowid = rowObj[0].get("rowid");
	}

	var compCodeField = new Ext.form.TextField({
		id:'compCodeField',
		fieldLabel: '��λ����',
		allowBlank: false,
		name:'compCode',
		anchor: '95%'
	});

	var copyCodeField = new Ext.form.TextField({
		id:'copyCodeField',
		fieldLabel: '���ױ���',
		allowBlank: false,
		name:'copyCode',
		anchor: '95%'
	});
	
	var acctYearField = new Ext.form.TextField({
		id:'acctYearField',
		fieldLabel: '������',
		allowBlank: false,
		name:'acctYear',
		anchor: '95%'
	});
	
	var beginDateField = new Ext.form.DateField({
		id:'beginDateField',
		fieldLabel: '��ʼ����',
		allowBlank: false,
		format: 'Y��m��d��',
		name:'beginDate',
		anchor: '95%'
	});
		
	var endDateField = new Ext.form.DateField({
		id:'endDateField',
		fieldLabel: '��������',
		allowBlank: false,
		format: 'Y��m��d��',
		name:'endDate',
		anchor: '95%'
	});

	var periodNumField = new Ext.form.TextField({
		id:'periodNumField',
		fieldLabel: '�ڼ���Ŀ',
		allowBlank: false,
		name:'periodNum',
		anchor: '95%'
	});
	
	var accFlagField = new Ext.form.Checkbox({
		id:'accFlagField',
		fieldLabel: '�������',
		allowBlank: false,
		name:'accFlag',
		anchor: '95%'
	});
	
	var budgFlagField = new Ext.form.Checkbox({
		id:'budgFlagField',
		fieldLabel: 'Ԥ�����',
		allowBlank: false,
		name:'budgFlag',
		anchor: '95%'
	});
	
	var perfFlagField = new Ext.form.Checkbox({
		id:'perfFlagField',
		fieldLabel: '��Ч����',
		allowBlank: false,
		name:'perfFlag',
		anchor: '95%'
	});
		
	var costFlagField = new Ext.form.Checkbox({
		id:'costFlagField',
		fieldLabel: '�ɱ�����',
		allowBlank: false,
		name:'costFlag',
		anchor: '95%'
	});

	var cashDateField = new Ext.form.DateField({
		id:'cashDateField',
		fieldLabel: '�ֽ����н�������',
		allowBlank: true,
		format: 'Y��m��d��',
		name:'cashDate',
		anchor: '95%'
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		items: [
			compCodeField,
            copyCodeField,
            acctYearField,
            beginDateField,
            endDateField,
            periodNumField,
			accFlagField,
			budgFlagField,
			perfFlagField,
			costFlagField,
			cashDateField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			accFlagField.setValue((rowObj[0].data['accFlag'])=='1'?true:false);
			budgFlagField.setValue((rowObj[0].data['budgFlag'])=='1'?true:false);
			perfFlagField.setValue((rowObj[0].data['perfFlag'])=='1'?true:false);
			costFlagField.setValue((rowObj[0].data['costFlag'])=='Y'?true:false);
		});
    
	var window = new Ext.Window({
		title: '�޸�',
		width: 300,
		height:400,
		minWidth: 300,
		minHeight: 400,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			handler: function() {
				
				var	compCode = compCodeField.getValue();
				var	copyCode = copyCodeField.getValue();
				var	acctYear = acctYearField.getValue();
				var	beginDate = beginDateField.getValue().format('Y-m-d');
				var	endDate = endDateField.getValue().format('Y-m-d');
				var	periodNum = periodNumField.getValue();
				var	accFlag = (accFlagField.getValue()==true)?'1':'0';
				var	budgFlag = (budgFlagField.getValue()==true)?'1':'0';
				var	perfFlag = (perfFlagField.getValue()==true)?'1':'0';
				var	costFlag = (costFlagField.getValue()==true)?'Y':'N';
				var	cashDate = '';
				if(cashDateField.getValue()!= ""){
					cashDate = cashDateField.getValue().format('Y-m-d');
				}
				
				compCode = compCode.trim();
				copyCode = copyCode.trim();
				acctYear = acctYear.trim();
				periodNum =	periodNum.trim();
				accFlag = accFlag.trim();
				budgFlag = budgFlag.trim();
				perfFlag = perfFlag.trim();
				
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: 'dhc.cs.baseexe.csp?action=editacctyear&rowid='+rowid+'&compCode='+compCode+'&copyCode='+copyCode+'&acctYear='+acctYear+'&beginDate='+beginDate+'&endDate='+endDate+'&periodNum='+periodNum+'&accFlag='+accFlag+'&budgFlag='+budgFlag+'&perfFlag='+perfFlag+'&costFlag='+costFlag+'&cashDate='+cashDate,
						waitMsg:'������...',
						failure: function(result, request) {
							Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true') {
							Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load();
								window.close();
							}
							else
							{
								var message="SQLErr: "+jsonData.info;
								Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
						},
					scope: this
					});
				}
				else{
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