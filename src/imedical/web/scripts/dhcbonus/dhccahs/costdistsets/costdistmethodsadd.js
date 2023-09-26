addMethodsFun = function(dataStore,grid,pagingTool,parRef,deptSetDr,layerDr) {
	
	if(layerDr=="")
	{
		Ext.Msg.show({title:'错误',msg:'请选择分层',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	};

	var priorityField = new Ext.form.NumberField({
		id: 'priorityField',
		fieldLabel: '优先级',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '优先级...',
		anchor: '90%'
	});
	
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		allowBlank: false,
		emptyText: '代码...',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		allowBlank: false,
		emptyText: '名称...',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: true,
		emptyText: '备注...',
		anchor: '90%'
	});
	/**
	var deptSetDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['id','code','name','desc','remark','leaf','end','active','parent','uiProvider','order','recCost','hospDr','hospName','locDr'])
	});
	var deptSet = new Ext.form.ComboBox({
		id: 'deptSet',
		fieldLabel: '部门分层套',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: deptSetDs,
		valueField: 'id',
		displayField: 'desc',
		triggerAction: 'all',
		emptyText:'部门分层套...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	deptSetDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=listsub&id='+deptSetDr+'&searchField=desc&active=Y&searchValue='+Ext.getCmp('deptSet').getRawValue(),method:'GET'});
	});
	*/
	var itemsDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                                        
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','typeDr','typeName','typeShortCut','order','itemDr','itemCode','itemName','itemShortCut'])
	});

	itemsDs.on('beforeload',function(ds, o){           
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.dataitemcorresexe.csp?action=list&searchField=itemShortCut&searchValue='+Ext.getCmp('items').getRawValue()+'&dataTypeDr='+costId, method:'GET'});
	});

	var items = new Ext.form.ComboBox({
		id:'items',
		fieldLabel:'输出成本项',
		store: itemsDs,
		valueField:'itemDr',
		displayField:'itemShortCut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择输出成本项...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true 
	});
	
	var paramDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                             
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','active'])
	});

	paramDs.on('beforeload',function(ds, o){           
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.accperiodexe.csp?action=list&searchField=shortcut&searchValue='+Ext.getCmp('params').getRawValue()+'&active=Y', method:'GET'});
	});

	var params = new Ext.form.ComboBox({
		id:'params',
		fieldLabel:'参数区间',
		store: paramDs,
		valueField:'rowId',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择参数区间...',
		allowBlank: false,
		selectOnFocus: true,
		forceSelection: true 
	});
	
	var ioFlagField = new Ext.form.Checkbox({
		id: 'ioFlagField',
		labelSeparator: '收支配比:',
		allowBlank: false
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			priorityField,
			//deptSet,
			codeField,
            nameField,
			items,
			params,
			ioFlagField
			
		]        
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '分摊方法添加',
    width: 400,
    height:300,
    minWidth: 400,
    minHeight: 300,
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
			
			var priority = priorityField.getValue();
      		var code = codeField.getValue();
      		var name = nameField.getValue();
			//var layerDr= deptSet.getValue();
			var itemDr= items.getValue();
			var param= params.getValue();
			var ioFlag = (ioFlagField.getValue()==true)?'Y':'N';
      		code = code.trim();
      		name = name.trim();
      		
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
							url: costDistSetsUrl+'?action=addMethod&priority='+priority+'&code='+code+'&name='+name+'&layerDr='+layerDr+'&deptSet='+deptSetDr+'&itemDr='+itemDr+'&param='+param+'&id='+parRef+'&ioFlag='+ioFlag,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									costDistSetsDs.setDefaultSort('rowid', 'desc');
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,id:parRef,layerDr:layerDr}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyCode') message='代码为空!';
									if(jsonData.info=='EmptyName') message='名称为空!';
									if(jsonData.info=='EmptyOrder') message='序号为空!';
									if(jsonData.info=='RepCode') message='代码已经存在!';
									if(jsonData.info=='RepName') message='名称已经存在!';
									if(jsonData.info=='RepPriority') message='优先级已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
				Ext.Msg.show({title:'错误', msg:'请选择数据后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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