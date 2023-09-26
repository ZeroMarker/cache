editInDeptsFun = function(dataStore,grid,pagingTool) {
	
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	
	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		fieldLabel: '序号',
		name:'order',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '序号...',
		anchor: '90%'
	});
	
	var unitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: '单元类别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueNotFoundText: rowObj[0].get("unitTypeName"),
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择单元类别...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitType').getRawValue(),method:'GET'});
	});

	var unitsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var units = new Ext.form.ComboBox({
		id: 'units',
		fieldLabel: '单元',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueNotFoundText: rowObj[0].get("unitName"),
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择单元...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchField=shortcut&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'GET'});
	});
	
	var assLocDs = new Ext.data.Store({
		proxy: "",                                                            
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','address','remark','startTime','stop','unitDr','propertyDr','active'])
	});
	var assLoc = new Ext.form.ComboBox({
		id: 'assLoc',
		fieldLabel: '人员',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: assLocDs,
		valueField: 'rowId',
		valueNotFoundText: rowObj[0].get("deptName"),
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择人员...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	assLocDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.inpersonexe.csp?action=listInDept&searchField=shortcut&searchValue='+Ext.getCmp('assLoc').getRawValue()+'&unitDr='+units.getValue()+'&inDeptSetsId='+inDeptSetsId,method:'GET'});
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
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		unitType.setValue(rowObj[0].get("unitTypeDr"));
		units.setValue(rowObj[0].get("unitDr"));
		assLoc.setValue(rowObj[0].get("deptDr"));
	});
	// define window and show it in desktop
	var window = new Ext.Window({
		title: '添加接口核算人员',
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
						url: outDeptsUrl+'?action=edit&order='+orderField.getValue()+'&inDeptId='+assLoc.getValue()+'&id='+rowObj[0].get("rowid")+'&inDeptSetsId='+inDeptSetsId,
						waitMsg:'保存中...',
						failure: function(result, request) {
							Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						},
						success: function(result, request) {
							var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:pagingTool.cursor, limit:inDeptsPagingToolbar.pageSize,inDeptSetsId:inDeptSetsId}});
								window.close();
							}
							else
							{
								var message = "";
								if(jsonData.info == 'RepOrder')
								{
									message = '输入的序号已经存在!';
								}
								else if(jsonData.info == 'RepDept')
								{
									message = '输入的科室已经存在!';
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
					assLoc.setValue("");
					unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
					//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
				});
				units.on("select",function(cmb,rec,id ){
						type="";
						assLocDs.load({params:{start:0, limit:assLoc.pageSize,id:cmb.getValue()}});
				});
				window.show();
			};
			