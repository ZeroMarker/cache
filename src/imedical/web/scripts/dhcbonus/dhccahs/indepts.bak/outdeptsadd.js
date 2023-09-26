addFun = function(dataStore,grid,pagingTool,parRef) {
	if(parRef=="")
	{
		Ext.Msg.show({title:'注意',msg:'请选择接口部门套后再添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
	}
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '序号',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '序号...',
		anchor: '90%'
	});
		var itemTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','shortcut','remark','order','active'])
	});
	var itemType = new Ext.form.ComboBox({
		id: 'itemType',
		fieldLabel: '数据类别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: itemTypeDs,
		valueField: 'rowid',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择数据类别...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	itemTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.datalevelsetsexe.csp?action=listitemtype&searchvalue='+Ext.getCmp('itemType').getRawValue()+'&searchfield=shortcut',method:'GET'});
	});

	itemType.on("select",function(cmb,rec,id ){
		//alert("asdf");
		items.setRawValue("");
		items.setValue("");
		itemsDs.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitemstoo&itemtype='+itemType.getValue(),method:'GET'});
		itemsDs.load({params:{start:0, limit:cmb.pageSize}});
	});

	var itemsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','itemDr','itemShortCut'])
	});
	
	itemsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitemstoo&itemtype='+itemType.getValue()+'&searchValue='+Ext.getCmp('items').getRawValue()+'&searchField=shortcut',method:'GET'});
	});
	
	var items = new Ext.form.ComboBox({
		id: 'items',
		fieldLabel: '数据',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: itemsDs,
		valueField: 'itemDr',
		displayField: 'itemShortCut',
		triggerAction: 'all',
		emptyText:'选择数据...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	var itemShortCut="";
	items.on("select",function(cmb,rec,id ){
		itemShortCut=rec.get("itemShortCut");
	});
	items.on("focus",function(cmb){
		items.setRawValue("");
		items.setValue("");
		itemsDs.proxy=new Ext.data.HttpProxy({url:'dhc.ca.initemsexe.csp?action=listdataitemstoo&itemtype='+itemType.getValue(),method:'GET'});
		itemsDs.load({params:{start:0, limit:cmb.pageSize}});
	});

	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: true,
		emptyText: '接口部门备注...',
		anchor: '90%'
	});

	var formStore = new Ext.data.SimpleStore({//定义组合框中显示的数据源
		fields: ['type','rowid'],
		data : [['住院','I'],['门诊','O'],['体检','E']]
	});
	var formComm = new Ext.form.ComboBox({
		id: 'formComm',
		fieldLabel: '病人类型',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: formStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'病人类型...',
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
		labelWidth: 75,
		items: [
			orderField,
			itemType,
			items,
			formComm,
			remarkField
		]
	});

	// define window and show it in desktop
	var window = new Ext.Window({
		title: '添加接口部门',
		width: 350,
		height: 300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			id:'saveButton',
			text: '保存',
			handler: function() {
		      		var code=itemShortCut.substring(0,itemShortCut.indexOf("-"));
					var name=itemShortCut.substring(itemShortCut.indexOf("-")+1);
		      		var remark = remarkField.getValue();
					//alert(parRef+"**"+inDeptSetsId);
		      		//code = code.trim();
		            //name = name.trim();
					remark=remark.trim();
		      		if(itemShortCut=="")
		      		{
		      			Ext.Msg.show({title:'错误',msg:'数据为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		      			return;
		      		};
		      		
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: outDeptsUrl+'?action=addOutDept&inDeptId='+parRef+'&code='+code+'&name='+name+'&remark='+remark+'&inDeptSetsId='+inDeptSetsId+'&order='+orderField.getValue()+'&patType='+formComm.getValue(),
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
							}
							else
								{
									var message = "";
									if(jsonData.info == 'RepCode')
									{
										message = '输入的代码已经存在!';
									}
									else if(jsonData.info == 'RepName')
										{
											message = '输入的名称已经存在!';
										}
										else message = "该科室已经在"+jsonData.info+"添加";
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
			