editLocFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var rowid = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	rowid=rowObj[0].get("rowid");
	
	var hospProxy = new Ext.data.HttpProxy({url:'dhc.ca.locsexe.csp?action=listhosp'});

	var hospDs = new Ext.data.Store({
			proxy: hospProxy,
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['Name','Rowid'])	
	});
	//--------------------------------------------------------------------------------
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
		valueNotFoundText:rowObj[0].get("unitTypeName"),
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择医院集团类别...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType',method:'POST'});
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
		valueNotFoundText:rowObj[0].get("unitName"),
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
		ds.proxy=new Ext.data.HttpProxy({url:encodeURI('dhc.ca.unitpersonsexe.csp?action=units'+'&id='+unitType.getValue()),method:'GET'});
	});
	
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
		valueNotFoundText:rowObj[0].get("deptName"),
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	assLocDs.on('beforeload', function(ds, o){
		//ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.deptlevelsetsexe.csp?action=listloc&recname='+Ext.getCmp('assLoc').getRawValue()+'&id='+units.getValue()+'&repdr='+repdr,method:'GET'});		zjw20160902  修改见下
	ds.proxy=new Ext.data.HttpProxy({url:encodeURI('dhc.ca.deptlevelsetsexe.csp?action=listloc&id='+units.getValue()+'&repdr='+repdr),method:'GET'});	
	});
	
	var recCostFlag = new Ext.form.Checkbox({
		id: 'recCostFlag',
		labelSeparator: '接受成本:',
		allowBlank: false,
		checked: (rowObj[0].data['recCost'])=='Y'?true:false
	});
	var distCostFlag = new Ext.form.Checkbox({
		id: 'distCostFlag',
		labelSeparator: '分摊标记:',
		checked: (rowObj[0].data['distCost'])=='Y'?true:false,
		allowBlank: false
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
	
	// create form panel
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
    
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		unitType.setValue(rowObj[0].get("unitTypeDr"));
		units.setValue(rowObj[0].get("unitDr"));
		assLoc.setValue(rowObj[0].get("deptDr"));
	});
	
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
				// check form value
				if (formPanel.form.isValid()) {
					var distCost=(distCostFlag.getValue()==true)?'Y':'N';
					var recCost=(recCostFlag.getValue()==true)?'Y':'N';
					var tmpDept=assLoc.getValue();
					if(tmpDept==""){
						Ext.Msg.show({title:'错误',msg:'请选择部门!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
						Ext.Ajax.request({
							url: encodeURI(deptLevelSetsUrl+'?action=editloc&locDr='+assLoc.getValue()+'&recCost='+recCost+'&distCost='+distCost+'&id='+rowid+"&subjdr="+repdr+'&order='+orderField.getValue()),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
								Ext.getCmp('detailReport').getNodeById(repdr).reload();
								window.close();
								}
								else
								{
									var message=jsonData.info;
									if(message=="roo")  message="部门不能添加此节点下!"
									else message="该部门已经在"+jsonData.info+"下添加!";
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
	
	    //units.setValue("");
	  	units.clearValue();
	    unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});	
		//assLoc.setValue('');
		assLoc.clearValue();
	    assLoc.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		//unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
	});
	units.on("select",function(cmb,rec,id ){
			type="";
			assLoc.clearValue();
			assLocDs.load({params:{start:0, limit:assLoc.pageSize,id:cmb.getValue()}});
	});
};