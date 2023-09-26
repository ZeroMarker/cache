AddLocFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
	if(leaf)
	{
		Ext.Msg.show({title:'注意',msg:'您选择的节点,不能添加部门!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(repdr == "")
	{
		Ext.Msg.show({title:'注意',msg:'请选择分类!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(repdr == "roo")
	{
		Ext.Msg.show({title:'注意',msg:'此节点不能增加实体科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var unitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: '医院集团类别',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择医院集团类别...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:encodeURI('dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitType').getRawValue()),method:'GET'});
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
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'POST'});
	});
	
	//zjw 20160828  更换医院后刷新医院下的核算科室
		units.on("select",function(cmb,rec,id ){
		//alert("asdf");
		assLoc.setRawValue("");
		assLoc.setValue("");
		//assLocDs.proxy=new Ext.data.HttpProxy({url:'dhc.ca.deptlevelsetsexe.csp?action=listloc&recname='+Ext.getCmp('assLoc').getRawValue()+'&id='+units.getValue()+'&repdr='+repdr,method:'GET'});
		//assLocDs.load({params:{start:0, limit:cmb.pageSize}});
		assLocDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
	});
	//-------
	var assLocDs = new Ext.data.Store({
		proxy: "",                                                            
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','address','remark','startTime','stop','unitDr','propertyDr','active'])
	});
	var assLoc = new Ext.form.ComboBox({
		id: 'assLoc',
		fieldLabel: '核算科室',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: assLocDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择核算科室...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	assLocDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.deptlevelsetsexe.csp?action=listloc&id='+units.getValue()+'&repdr='+repdr,method:'POST'});
	});
	
	var recCostFlag = new Ext.form.Checkbox({
		id: 'recCostFlag',
		labelSeparator: '接受成本:',
		allowBlank: false,
		checked:true
	});
	var distCostFlag = new Ext.form.Checkbox({
		id: 'distCostFlag',
		labelSeparator: '分摊标记:',
		allowBlank: false,
		checked:true
	});
	var orderField = new Ext.form.NumberField({
		id:'orderField',
		fieldLabel: '顺序',
		selectOnFocus:true,
		allowBlank: false,
		name:'order',
		emptyText:'顺序...',
		anchor: '90%'
	});

	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
			orderField,
			unitType,
			units,
			assLoc,
			recCostFlag,
			distCostFlag
			
		]
	});
    
  // define window and show it in desktop
	var window = new Ext.Window({
		title: '添加部门分层',
		width: 400,
		height:300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '保存', 
			id:"saveButton",
			handler: function() {
				if (formPanel.form.isValid()) {
					var distCost=(distCostFlag.getValue()==true)?'Y':'N';
					var recCost=(recCostFlag.getValue()==true)?'Y':'N';
					var tmpDept=assLoc.getValue();
					if(tmpDept==""){
						Ext.Msg.show({title:'错误',msg:'请选择部门!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
						Ext.Ajax.request({
							url: encodeURI(deptLevelSetsUrl+'?action=addloc&locDr='+assLoc.getValue()+'&recCost='+recCost+'&distCost='+distCost+'&id='+repdr+'&order='+orderField.getValue()),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									assLoc.setValue("");
									assLocDs.load({params:{start:0, limit:assLoc.pageSize,id:units.getValue()}});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									Ext.getCmp('detailReport').getNodeById(repdr).reload();
									//window.close();
								}
								else
								{
									var message=jsonData.info;
									if(message=="roo")  message="部门不能添加此节点下!"
									else message="该部门已经在"+jsonData.info+"下添加!";
									//Ext.getCmp('detailReport').getNodeById(message).reload();
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
};