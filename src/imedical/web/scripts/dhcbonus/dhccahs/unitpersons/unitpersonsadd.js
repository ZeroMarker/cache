addFun = function(dataStore,grid,pagingTool) {
	var unitDr=units.getValue();
	if(unitDr==""){
		Ext.Msg.show({title:'ע��',msg:'��ѡ��Ԫ������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '��λ��Ա����...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '��λ��Ա����...',
		anchor: '90%'
	});
	
	var nationalField = new Ext.form.TextField({
		id: 'nationalField',
		fieldLabel: '����',
		allowBlank: true,
		emptyText: '����...',
		anchor: '90%'
	});
	
	var birthPlaceField = new Ext.form.TextField({
		id: 'birthPlaceField',
		fieldLabel: '����',
		allowBlank: true,
		emptyText: '����...',
		anchor: '90%'
	});
	
	var titleField = new Ext.form.TextField({
		id: 'titleField',
		fieldLabel: 'ְ��',
		allowBlank: true,
		emptyText: 'ְ��...',
		anchor: '90%'
	});
	
	var dutyField = new Ext.form.TextField({
		id: 'titleField',
		fieldLabel: 'ְ��',
		allowBlank: true,
		emptyText: 'ְ��...',
		anchor: '90%'
	});
	
	var stateField = new Ext.form.TextField({
		id: 'stateField',
		fieldLabel: '״̬',
		allowBlank: true,
		emptyText: '״̬...',
		anchor: '90%'
	});
	
	var preparationField = new Ext.form.TextField({
		id: 'preparationField',
		fieldLabel: '����',
		allowBlank: true,
		emptyText: '����...',
		anchor: '90%'
	});
	
	var phoneField = new Ext.form.TextField({
		id: 'phoneField',
		fieldLabel: '�绰',
		allowBlank: true,
		emptyText: '�绰...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		emptyText: '��ע...',
		anchor: '90%'
	});
	
	var unitNameField = new Ext.form.TextField({
		id: 'unitNameField',
		fieldLabel: '��λ����',
		allowBlank: true,
		emptyText: '��λ����...',
		anchor: '90%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '��Ч:',
		allowBlank: false,
		renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    	}
	});
	
	var educationField = new Ext.form.TextField({
		id: 'educationField',
		fieldLabel: 'ѧ��',
		allowBlank: true,
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
		name:'gender',
		fieldLabel: '�Ա�',
		boxLabel: '��',
		value : 'M', 
		allowBlank: true,
		checked: false
	});
	
	var titField = new Ext.form.TextField({
		id: 'titField',
		fieldLabel: 'ְ��',
		allowBlank: true,
		emptyText: 'ְ��...',
		anchor: '90%'
	});
	
	var femaleField = new Ext.form.Radio({
		id: 'femaleField',
		boxLabel: 'Ů',
		//hideLabel: true,
		name:'gender',
		value : 'F', 
		allowBlank: true,
		checked: false
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
		border:false,
		baseCls: 'x-plain',
		defaults: {
		border:false,
		layout: 'form',
		baseCls: 'x-plain',
		//labelSeparator: ':',
		columnWidth: .45
	
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
			endDate
			//unitNameField
			//activeField
			
		]        
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��ӵ�λ��Ա',
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
			
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: encodeURI(UnitPersonsUrl+'?action=add&code='+code+'&name='+name+'&remark='+remark+'&startDate='+sDate+'&endDate='+eDate+'&birthday='+birthday+'&national='+nationalField.getValue()+'&birthPlace='+birthPlaceField.getValue()+'&education='+educationField.getValue()+'&duty='+dutyField.getValue()+'&state='+stateField.getValue()+'&preparation='+preparationField.getValue()+'&phone='+phoneField.getValue()+'&remark='+remark+'&unitDr='+unitDr+'&title='+titles+'&gender='+gender),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,id:unitDr}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
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