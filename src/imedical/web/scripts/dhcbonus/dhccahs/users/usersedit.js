editFun = function(dataStore,grid,pagingTool) {
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
	
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '���',
		allowDecimals:false,
		allowBlank: false,
		name: 'order',
		emptyText: '���...',
		anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '��½��',
		allowBlank: false,
		emptyText: '��½��...',
		name: 'loginName',
		anchor: '90%'
	});
	var unitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: '�������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueNotFoundText: rowObj[0].get("unitTypeName"),
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ����...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitType').getRawValue(),method:'POST'});
	});

	var unitsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var units = new Ext.form.ComboBox({
		id: 'units',
		fieldLabel: 'ҽԺ��λ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueField: 'rowId',
		valueNotFoundText: rowObj[0].get("unitName"),
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��ҽԺ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	var oldPasswordField = new Ext.form.TextField({
		id: 'oldPasswordField',
		fieldLabel: '������',
		inputType:'password',
		allowBlank: false,
		emptyText: '������...',
		anchor: '90%'
	});
	
	var passwordField = new Ext.form.TextField({
		id: 'passwordField',
		fieldLabel: '������',
		inputType:'password',
		allowBlank: true,
		emptyText: '������...',
		anchor: '90%'
	});
	
	var confirmPasswordField = new Ext.form.TextField({
		id: 'confirmPasswordField',
		fieldLabel: 'ȷ��������',
		inputType:'password',
		allowBlank: true,
		emptyText: '������...',
		anchor: '90%'
	});
	
	unitsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'POST'});
	});
	
	var personDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut','remark','flag','active'])
	});
	var persons = new Ext.form.ComboBox({
		id: 'persons',
		fieldLabel: '��Ա',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: personDs,
		valueField: 'rowid',
		valueNotFoundText: rowObj[0].get("unitPersonName"),
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ����Ա...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	personDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.usersexe.csp?action=persons&searchField=shortcut&searchValue='+Ext.getCmp('persons').getRawValue()+'&id='+units.getValue(),method:'GET'});
	});
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '��ע',
		allowBlank: true,
		name: 'remark',
		emptyText: '��ע����...',
		anchor: '90%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '��Ч:',
		allowBlank: false,
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});
	
	confirmPasswordField.on('blur',function(combo, record, index){ 
		var tmpPsw=passwordField.getValue();
		var tmpConfPsw=confirmPasswordField.getValue();
		if(tmpPsw!=tmpConfPsw){
			Ext.Msg.show({title:'����',msg:'�������벻һ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	});
	oldPasswordField.on('blur',function(combo, record, index){ 
		var oldPassword = oldPasswordField.getValue();
		var tmpOldPsw=rowObj[0].get("password");
		if(oldPassword!=tmpOldPsw){
			Ext.Msg.show({title:'����',msg:'ԭʼ���벻��ȷ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	});
	
	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 70,
    items: [
			orderField,
			nameField,
			oldPasswordField,
			passwordField,
			confirmPasswordField,
			unitType,
			units,
			persons,
			remarkField,
            activeField
		]        
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		unitType.setValue(rowObj[0].get("unitTypeDr"));
		units.setValue(rowObj[0].get("unitDr"));
		persons.setValue(rowObj[0].get("unitPersonDr"));
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸��û�',
    width: 400,
    height:400,
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
		
			var order = orderField.getValue();
      		var password = passwordField.getValue();
      		var name = nameField.getValue();
			var person=persons.getValue();
			var remark=remarkField.getValue();
      		var active = (activeField.getValue()==true)?'Y':'N';
			var oldPassword = oldPasswordField.getValue();
			var tmpOldPsw=rowObj[0].get("password");
			var tmpConfPsw=confirmPasswordField.getValue();
	
			if(oldPassword!=tmpOldPsw){
				Ext.Msg.show({title:'����',msg:'ԭʼ���벻��ȷ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
  
			if(password!=""||tmpConfPsw!=""){
				if(password!=tmpConfPsw){
					Ext.Msg.show({title:'����',msg:'�������벻һ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
			}else{
				password=oldPassword;
			}
			
      		name = name.trim();
			
      		if(name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		  		
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: usersUrl+'?action=edit&id='+myRowid+'&order='+order+'&name='+name+'&remark='+remarkField.getValue()+'&password='+password+'&person='+person+'&active='+active,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyName') message='���������Ϊ��!';
									if(jsonData.info=='EmptyOrder') message='��������Ϊ��!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
									if(jsonData.info=='RepOrder') message='���������Ѿ�����!';
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
    //zjw 20160914 ���š�ҽԺ����Ա����
    unitType.on("select",function(cmb,rec,id ){
		units.setRawValue("");
		units.setValue("");
		units.clearValue();
		persons.setValue("");
		persons.setRawValue("");
		persons.clearValue();
		unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		personDs.load({params:{start:0, limit:0}});
	});
	units.on("select",function(cmb,rec,id ){
			type="";
			persons.setValue("");
			persons.setRawValue("");
			persons.clearValue();
			personDs.load({params:{start:0, limit:persons.pageSize,id:cmb.getValue()}});
	});
    
    window.show();
};