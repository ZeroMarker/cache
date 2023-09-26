editFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的行!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}
	
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '序号',
		allowDecimals:false,
		allowBlank: false,
		name: 'order',
		emptyText: '序号...',
		anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '登陆名',
		allowBlank: false,
		emptyText: '登陆名...',
		name: 'loginName',
		anchor: '90%'
	});
	var unitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: '集团类别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueNotFoundText: rowObj[0].get("unitTypeName"),
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择集团...',
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
		fieldLabel: '医院单位',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueField: 'rowId',
		valueNotFoundText: rowObj[0].get("unitName"),
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择医院...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	var oldPasswordField = new Ext.form.TextField({
		id: 'oldPasswordField',
		fieldLabel: '旧密码',
		inputType:'password',
		allowBlank: false,
		emptyText: '类别代码...',
		anchor: '90%'
	});
	
	var passwordField = new Ext.form.TextField({
		id: 'passwordField',
		fieldLabel: '新密码',
		inputType:'password',
		allowBlank: true,
		emptyText: '类别代码...',
		anchor: '90%'
	});
	
	var confirmPasswordField = new Ext.form.TextField({
		id: 'confirmPasswordField',
		fieldLabel: '确认新密码',
		inputType:'password',
		allowBlank: true,
		emptyText: '类别代码...',
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
		fieldLabel: '人员',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: personDs,
		valueField: 'rowid',
		valueNotFoundText: rowObj[0].get("unitPersonName"),
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择人员...',
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
		fieldLabel: '备注',
		allowBlank: true,
		name: 'remark',
		emptyText: '备注名称...',
		anchor: '90%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '有效:',
		allowBlank: false,
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});
	
	confirmPasswordField.on('blur',function(combo, record, index){ 
		var tmpPsw=passwordField.getValue();
		var tmpConfPsw=confirmPasswordField.getValue();
		if(tmpPsw!=tmpConfPsw){
			Ext.Msg.show({title:'错误',msg:'两次密码不一致!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		}
	});
	oldPasswordField.on('blur',function(combo, record, index){ 
		var oldPassword = oldPasswordField.getValue();
		var tmpOldPsw=rowObj[0].get("password");
		if(oldPassword!=tmpOldPsw){
			Ext.Msg.show({title:'错误',msg:'原始密码不正确!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
  	title: '修改用户',
    width: 400,
    height:400,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存', 
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
				Ext.Msg.show({title:'错误',msg:'原始密码不正确!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			}
  
			if(password!=""||tmpConfPsw!=""){
				if(password!=tmpConfPsw){
					Ext.Msg.show({title:'错误',msg:'两次密码不一致!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					return;
				}
			}else{
				password=oldPassword;
			}
			
      		name = name.trim();
			
      		if(name=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		  		
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: usersUrl+'?action=edit&id='+myRowid+'&order='+order+'&name='+name+'&remark='+remarkField.getValue()+'&password='+password+'&person='+person+'&active='+active,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {				
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyName') message='输入的名称为空!';
									if(jsonData.info=='EmptyOrder') message='输入的序号为空!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
									if(jsonData.info=='RepOrder') message='输入的序号已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'请修正页面提示的错误后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					}             
	    	}
    	},
    	{
				text: '取消',
        handler: function(){window.close();}
      }]
    });
    //zjw 20160914 集团、医院、人员联动
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