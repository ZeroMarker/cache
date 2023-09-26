addFun = function(dataStore,grid,pagingTool) {
	var unitDr=units.getValue();
	if(unitDr==""){
		Ext.Msg.show({title:'注意',msg:'请选择单元后再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		allowBlank: false,
		emptyText: '单位人员代码...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		allowBlank: false,
		emptyText: '单位人员名称...',
		anchor: '90%'
	});
	
	var nationalField = new Ext.form.TextField({
		id: 'nationalField',
		fieldLabel: '民族',
		allowBlank: true,
		emptyText: '民族...',
		anchor: '90%'
	});
	
	var birthPlaceField = new Ext.form.TextField({
		id: 'birthPlaceField',
		fieldLabel: '籍贯',
		allowBlank: true,
		emptyText: '籍贯...',
		anchor: '90%'
	});
	
	var titleField = new Ext.form.TextField({
		id: 'titleField',
		fieldLabel: '职称',
		allowBlank: true,
		emptyText: '职称...',
		anchor: '90%'
	});
	
	var dutyField = new Ext.form.TextField({
		id: 'titleField',
		fieldLabel: '职务',
		allowBlank: true,
		emptyText: '职务...',
		anchor: '90%'
	});
	
	var stateField = new Ext.form.TextField({
		id: 'stateField',
		fieldLabel: '状态',
		allowBlank: true,
		emptyText: '状态...',
		anchor: '90%'
	});
	
	var preparationField = new Ext.form.TextField({
		id: 'preparationField',
		fieldLabel: '编制',
		allowBlank: true,
		emptyText: '编制...',
		anchor: '90%'
	});
	
	var phoneField = new Ext.form.TextField({
		id: 'phoneField',
		fieldLabel: '电话',
		allowBlank: true,
		emptyText: '电话...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: true,
		emptyText: '备注...',
		anchor: '90%'
	});
	
	var unitNameField = new Ext.form.TextField({
		id: 'unitNameField',
		fieldLabel: '单位名称',
		allowBlank: true,
		emptyText: '单位名称...',
		anchor: '90%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '有效:',
		allowBlank: false,
		renderer : function(v, p, record){
        	p.css += ' x-grid3-check-col-td'; 
        	return '<div class="x-grid3-check-col'+(v=='Y'?'-on':'')+' x-grid3-cc-'+this.id+'">&#160;</div>';
    	}
	});
	
	var educationField = new Ext.form.TextField({
		id: 'educationField',
		fieldLabel: '学历',
		allowBlank: true,
		emptyText: '学历...',
		anchor: '90%'
	});
	
	var birthdayDate = new Ext.form.DateField({
		id: 'birthdayDate',
		fieldLabel: '生日',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		emptyText:'选择生日...',
		anchor: '90%'
	});
	
	var startDate = new Ext.form.DateField({
		id: 'startDate',
		fieldLabel: '入职时间',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		emptyText:'选择入职时间...',
		anchor: '90%'
	});
	var endDate = new Ext.form.DateField({
		id: 'endDate',
		fieldLabel: '离职时间',
		allowBlank: true,
		dateFormat: 'Y-m-d',
		emptyText:'选择离职时间...',
		anchor: '90%'
	});

	
	var maleField = new Ext.form.Radio({
		id: 'maleField',
		name:'gender',
		fieldLabel: '性别',
		boxLabel: '男',
		value : 'M', 
		allowBlank: true,
		checked: false
	});
	
	var titField = new Ext.form.TextField({
		id: 'titField',
		fieldLabel: '职称',
		allowBlank: true,
		emptyText: '职称...',
		anchor: '90%'
	});
	
	var femaleField = new Ext.form.Radio({
		id: 'femaleField',
		boxLabel: '女',
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
	var formStore = new Ext.data.SimpleStore({//定义组合框中显示的数据源
		fields: ['type','gender'],
		data : [['男','M'],['女','F']]
	});
	var formComm = new Ext.form.ComboBox({
		id: 'formComm',
		fieldLabel: '人员性别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: formStore,
		valueField: 'gender',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'人员性别...',
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
  	title: '添加单位人员',
    width: 400,
    height:550,
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
      			Ext.Msg.show({title:'错误',msg:'代码为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'名称为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: encodeURI(UnitPersonsUrl+'?action=add&code='+code+'&name='+name+'&remark='+remark+'&startDate='+sDate+'&endDate='+eDate+'&birthday='+birthday+'&national='+nationalField.getValue()+'&birthPlace='+birthPlaceField.getValue()+'&education='+educationField.getValue()+'&duty='+dutyField.getValue()+'&state='+stateField.getValue()+'&preparation='+preparationField.getValue()+'&phone='+phoneField.getValue()+'&remark='+remark+'&unitDr='+unitDr+'&title='+titles+'&gender='+gender),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,id:unitDr}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepCode') message='输入的代码已经存在!';
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

    window.show();
};