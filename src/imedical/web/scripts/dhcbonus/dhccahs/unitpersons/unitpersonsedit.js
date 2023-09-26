editFun = function(dataStore,grid,pagingTool) {
	var unitDr=units.getValue();
	if(unitDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��Ԫ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		name:'code',
		emptyText: '��λ��Ա����...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		name:'name',
		emptyText: '��λ��Ա����...',
		anchor: '90%'
	});
	
	var nationalField = new Ext.form.TextField({
		id: 'nationalField',
		fieldLabel: '����',
		name:'national',
		allowBlank: true,
		emptyText: '����...',
		anchor: '90%'
	});
	
	var birthPlaceField = new Ext.form.TextField({
		id: 'birthPlaceField',
		fieldLabel: '����',
		allowBlank: true,
		name:'birthPlace',
		emptyText: '����...',
		anchor: '90%'
	});
	
	var titleField = new Ext.form.TextField({
		id: 'titleField',
		fieldLabel: 'ְ��',
		name:'title',
		allowBlank: true,
		emptyText: 'ְ��...',
		anchor: '90%'
	});
	
	var dutyField = new Ext.form.TextField({
		id: 'dutyField',
		fieldLabel: 'ְ��',
		allowBlank: true,
		name:'duty',
		emptyText: 'ְ��...',
		anchor: '90%'
	});
	
	var stateField = new Ext.form.TextField({
		id: 'stateField',
		fieldLabel: '״̬',
		allowBlank: true,
		name:'state',
		emptyText: '״̬...',
		anchor: '90%'
	});
	
	var preparationField = new Ext.form.TextField({
		id: 'preparationField',
		fieldLabel: '����',
		allowBlank: true,
		name:'preparation',
		emptyText: '����...',
		anchor: '90%'
	});
	
	var phoneField = new Ext.form.TextField({
		id: 'phoneField',
		fieldLabel: '�绰',
		allowBlank: true,
		name:'phone',
		emptyText: '�绰...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		name:'remark',
		emptyText: '��ע...',
		anchor: '90%'
	});
	
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '��Ч:',
		allowBlank: false,
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});
	
	var educationField = new Ext.form.TextField({
		id: 'educationField',
		fieldLabel: 'ѧ��',
		allowBlank: true,
		name:'education',
		emptyText: 'ѧ��...',
		anchor: '90%'
	});
	
	var birthdayDate = new Ext.form.DateField({
		id: 'birthdayDate',
		fieldLabel: '����',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		emptyText:'ѡ������...',
		anchor: '90%'
	});
	
	var startDate = new Ext.form.DateField({
		id: 'startDate',
		fieldLabel: '��ְʱ��',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		emptyText:'ѡ����ְʱ��...',
		anchor: '90%'
	});
	var endDate = new Ext.form.DateField({
		id: 'endDate',
		fieldLabel: '��ְʱ��',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		emptyText:'ѡ����ְʱ��...',
		anchor: '90%'
	});

	
	var maleField = new Ext.form.Radio({
		id: 'maleField',
		fieldLabel: '�Ա�',
		boxLabel: '��',
		name:'gender',
		checked: (rowObj[0].data['gender'])=='��'?true:false,
		allowBlank: true
	});
	
	var titField = new Ext.form.TextField({
		id: 'titField',
		fieldLabel: 'ְ��',
		allowBlank: true,
		name:'title',
		emptyText: 'ְ��...',
		anchor: '90%'
	});
	
	var femaleField = new Ext.form.Radio({
		id: 'femaleField',
		boxLabel: 'Ů',
		checked: (rowObj[0].data['gender'])=='Ů'?true:false,
		hideLabel: true,
		name:'gender',
		allowBlank: true
	});
	
	
	
	remarkField.on('check', function(o, v){
		if(v==true)	inFlagField.setValue(false);
	});
	
	//------zjw 20160811
	var formStore = new Ext.data.SimpleStore({//������Ͽ�����ʾ������Դ
		fields: ['type','gender'],
		data : [['��','M'],['Ů','F']]
	});
	var formComm = new Ext.form.ComboBox({
		id: 'formComm',
		fieldLabel: '��Ա�Ա�',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: formStore,
		valueField: 'gender',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'��Ա�Ա�...',
		mode: 'local',
		name:'Flag',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	//------
	/*------zjw 20160811
	var flagPanel = new Ext.Panel({
		layout: 'column',
		border: false,
		baseCls: 'x-plain',
		defaults: {
		border: false,
		layout: 'form',
		baseCls: 'x-plain',
		//labelSeparator: ':',
		columnWidth: .3
			},
			items: [
				{
					items: maleField
				},
				{
					items: femaleField
				}
			]
	});
	
	*/
	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
			codeField,
            nameField,
			//flagPanel,
			formComm,
            birthdayDate,
			nationalField,
			birthPlaceField,
			educationField,
			titField,
			dutyField,
			stateField,
			preparationField,
			phoneField,
			remarkField,
			startDate,
			endDate,
			//unitNameField
			activeField
		]        
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			startDate.setValue(rowObj[0].data['start']);
			endDate.setValue(rowObj[0].data['stop']);
			birthdayDate.setValue(rowObj[0].data['birthday']);
			formComm.setValue(rowObj[0].data['gender']);
		});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸ĵ�λ��Ա',
    width: 400,
    height:550,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '����', 
		handler: function() {
      	// check form value	
      		var code = codeField.getValue();
      		var name = nameField.getValue();
			var remark = remarkField.getValue();
			var sDate="";
			var eDate="";
			var birthday="";
			var titles=titField.getValue();
			if(startDate.getValue()!=""){sDate=startDate.getValue().format('Y-m-d');}
			if(endDate.getValue()!=""){eDate=endDate.getValue().format('Y-m-d');}
			if(birthdayDate.getValue()!=""){birthday=birthdayDate.getValue().format('Y-m-d');}

			/*------zjw 20160811
			var male=maleField.getValue();
			var female=femaleField.getValue();
			var gender=""
			if(female==true) gender="F";
			if(male==true) gender="M";
			*/
			var gender=formComm.getValue();	//------zjw 20160811
		
			var temDate=""
			if(startDate>endDate){
				temDate=startDate;
				startDate=endDate;
				endDate=temDate;
			}
	
      		code = code.trim();
      		name = name.trim();
			remark = remark.trim();
      	
      		if(code=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			
			var active = (activeField.getValue()==true)?'Y':'N';
			
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: encodeURI(UnitPersonsUrl+'?action=edit&code='+code+'&name='+name+'&remark='+remark+'&startDate='+sDate+'&endDate='+eDate+'&birthday='+birthday+'&national='+nationalField.getValue()+'&birthPlace='+birthPlaceField.getValue()+'&education='+educationField.getValue()+'&duty='+dutyField.getValue()+'&state='+stateField.getValue()+'&preparation='+preparationField.getValue()+'&phone='+phoneField.getValue()+'&remark='+remark+'&unitDr='+unitDr+'&title='+titles+'&gender='+gender+'&id='+myRowid+'&active='+active),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,id:unitDr}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyCode') message='����Ĵ���Ϊ��!';
									if(jsonData.info=='EmptyName') message='���������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
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