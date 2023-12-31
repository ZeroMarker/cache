addInDeptsFun = function(dataStore,grid,pagingTool) {
	if(inDeptSetsId=="")
	{
		Ext.Msg.show({title:'注意',msg:'请选择接口部门套后再添加!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
		return;
	}
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '顺序',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '顺序...',
		anchor: '90%'
	});
	
	var unitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: '集团单元',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择集团单元...',
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
		fieldLabel: '医院单元',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择医院单元...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchField=shortcut&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'POST'});
	});
	
	var assLocDs = new Ext.data.Store({
		proxy: "",                                                            
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','address','remark','startTime','stop','unitDr','propertyDr','active'])
	});
	var assLoc = new Ext.form.ComboBox({
		id: 'assLoc',
		fieldLabel: '核算部门',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: assLocDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择核算部门...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	assLocDs.on('beforeload', function(ds, o){
		//var unitDr=units.getValue();
		//alert(unitDr)
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.indeptsexe.csp?action=listInDept&searchField=shortcut&searchValue='+Ext.getCmp('assLoc').getRawValue()+'&unit='+units.getValue()+'&inDeptSetsId='+inDeptSetsId,method:'POST'});
	});
	
	// create form panel
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 70,
		items: [
			orderField,
			unitType,
			units,
			assLoc
		]
	});

	// define window and show it in desktop
	var window = new Ext.Window({
		title: '添加接口核算部门',
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
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: encodeURI(outDeptsUrl+'?action=add&order='+orderField.getValue()+'&inDeptId='+assLoc.getValue()+'&inDeptSetsId='+inDeptSetsId),
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								assLoc.setValue("");
								assLoc.setRawValue("");
								assLocDs.load({params:{start:0, limit:assLoc.pageSize}});
								dataStore.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize,inDeptSetsId:inDeptSetsId}});
							}
							else
							{
								var message = "";
								if(jsonData.info == 'RepOrder')
								{
									message = '输入的顺序已经存在!';
								}
								else if(jsonData.info == 'RepDept')
								{
									message = '输入的核算科室已经存在!';
								}
								else
								{	
									message = jsonData.info;
								}
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
			id:'saveAllButton',
			text: '保存全部科室',
			handler: function() {
				if (formPanel.form.isValid()) {
					Ext.Ajax.request({
						url: encodeURI(outDeptsUrl+'?action=addAll&order='+orderField.getValue()+'&unit='+units.getValue()+'&inDeptSetsId='+inDeptSetsId),
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:0, limit:inDeptsPagingToolbar.pageSize,inDeptSetsId:inDeptSetsId}});
							}
							else
							{
								var message = "";
								if(jsonData.info == 'RepOrder')
								{
									message = '输入的顺序已经存在!';
								}
								else if(jsonData.info == 'RepDept')
								{
									message = '输入的核算科室已经存在!';
								}
								else
								{	
									message = jsonData.info;
								}
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
				unitType.on("select",function(cmb,rec,id ){
					units.setRawValue("");
					units.setValue("");
					assLoc.setRawValue("");
					assLoc.setValue("");
					unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
					//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
				});
				units.on("select",function(cmb,rec,id ){
						type="";
						assLoc.setRawValue("");
						assLoc.setValue("");
						assLocDs.load({params:{start:0, limit:assLoc.pageSize,id:cmb.getValue()}});
				});
				window.show();
			};
			