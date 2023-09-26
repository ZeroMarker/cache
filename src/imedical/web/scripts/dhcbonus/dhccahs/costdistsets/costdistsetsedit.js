editFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择成本分摊套修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
	
	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '代码',
		allowBlank: false,
		emptyText: '代码...',
		name: 'code',
		anchor: '90%'
	});
	
	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '名称',
		allowBlank: false,
		emptyText: '名称...',
		name: 'name',
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: true,
		name: 'remark',
		emptyText: '备注...',
		anchor: '90%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeFlag',
		labelSeparator: '有效:',
		allowBlank: false,
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});
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
		valueNotFoundText: rowObj[0].get("deptSetName"),
		triggerAction: 'all',
		emptyText:'部门分层套...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	deptSetDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=listsub&id=roo&searchField=desc&active=Y&searchValue='+Ext.getCmp('deptSet').getRawValue(),method:'GET'});
	});
	var distFlagStore = new Ext.data.SimpleStore({//成本分摊套成本分摊套据源
		fields: ['type','rowid'],
		data : [['逐层','layer'],['直接','direct']]
	});
	var distFlag = new Ext.form.ComboBox({
		id: 'distFlag',
		fieldLabel: '分摊标志',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: distFlagStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'分摊标志...',
		mode: 'local',
		name:'Flag',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
    		orderField,
			codeField,
            nameField,
			deptSet,
			distFlag,
			remarkField,
            activeField
		]        
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			deptSet.setValue(rowObj[0].get("deptSetDr"));
			this.getForm().loadRecord(rowObj[0]);
		});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '成本分摊套门套',
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
		
			var order = orderField.getValue();
      		var code = codeField.getValue();
      		var name = nameField.getValue();
      		var active = (activeField.getValue()==true)?'Y':'N';
      		
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
							url: costDistSetsUrl+'?action=edit&id='+myRowid+'&order='+order+'&code='+code+'&name='+name+'&remark='+remarkField.getValue()+'&active='+active+'&deptSet='+deptSet.getValue()+'&distFlag='+distFlag.getValue(),
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
									if(jsonData.info=='EmptyCode') message='代码为空!';
									if(jsonData.info=='EmptyName') message='名称为空!';
									if(jsonData.info=='EmptyOrder') message='序号为空!';
									if(jsonData.info=='RepCode') message='代码已经存在!';
									if(jsonData.info=='RepName') message='名称已经存在!';
									if(jsonData.info=='RepOrder') message='序号已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
						Ext.Msg.show({title:'错误', msg:'选择成本分摊套后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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