addInterLocFun = function(dataStore,grid,pagingTool) {

	if(interLocSetField.getValue()==""){
	   Ext.Msg.show({title:'提示',msg:'请选择接口套',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
	   return false;
	}
	var jxUnitDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut'])
	});

	jxUnitDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:InterLocUrl+'?action=getjxunit&str='+Ext.getCmp('jxUnitField').getRawValue(),method:'POST'})
	});

	var jxUnitField = new Ext.form.ComboBox({
		id: 'jxUnitField',
		fieldLabel:'核算单元',
		allowBlank: false,
		store: jxUnitDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'',
		name: 'jxUnitField',
		minChars: 1,
		pageSize: 10,
		anchor: '90%',
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
	var orderField = new Ext.form.TextField({
		id: 'orderField',
		fieldLabel: '顺序号',
		allowBlank: false,
		emptyText: '',
		anchor: '90%'
	});
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		allowBlank: false,
		emptyText: '',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		allowBlank: false,
		emptyText: '',
		anchor: '90%'
	}); 

	var patTypeStore = new Ext.data.SimpleStore({
	fields: ['key','keyValue'],
	data:[['I','住院'],['O','门诊'],['E','急诊']]
	});
	var patTypeField = new Ext.form.ComboBox({
		id: 'patTypeField',
		fieldLabel: '病人类型',
		selectOnFocus: true,
		allowBlank: false,
		store: patTypeStore,
		anchor: '90%',
		value:'', //默认值
		valueNotFoundText:'',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'',
		mode: 'local', //本地模式
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: true,
		emptyText:'',
		anchor: '90%'
	});

	remarkField.on('check', function(o, v){
		if(v==true)	inFlagField.setValue(false);
	});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			jxUnitField,
			orderField,
			codeField,
            nameField,
			//patTypeField,
			remarkField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加接口单元',
    width: 380,
    height:320,
    minWidth: 380,
    minHeight: 320,
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
			var jxUnit = jxUnitField.getValue();
			var order = orderField.getValue();
      		var code = codeField.getValue();
      		var name = nameField.getValue();
			var remark = remarkField.getValue();
		    //var patType = patTypeField.getValue();
			
      		code = code.trim();
      		name = name.trim();
			remark = remark.trim();   
            jxUnit = jxUnit.trim();
			order = order.trim();
			//patType = patType.trim();
        	var data = code+'^'+name+'^'+order+'^'+jxUnit+'^'+interLocSetField.getValue()+'^'+remark;
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
							url: InterLocUrl+'?action=add&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'提示',msg:'错误',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'提示',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='数据为空!';
									if(jsonData.info=='RepCode') message='代码不能重复!';
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