editLocFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
	var rowObj = grid.getSelections();
	var len = rowObj.length;

	var rowid = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: '��Ԫ���',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueField: 'rowid',
		valueNotFoundText:rowObj[0].get("unitTypeName"),
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'ѡ��Ԫ���...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonusunittypeexe.csp?action=list&start=0&limit=10',method:'GET'});
	});

	var unitsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name'])
	});
	var units = new Ext.form.ComboBox({
		id: 'units',
		fieldLabel: '���㵥Ԫ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueNotFoundText:rowObj[0].get("unitName"),
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'ѡ��Ԫ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.bonus.bonusunittypeexe.csp?action=unittype&UnitType='+unitType.getValue(),method:'GET'});
	});
	
	var assLocDs = new Ext.data.Store({
		proxy: "",                                                            
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','address','remark','startTime','stop','unitDr','propertyDr','active'])
	});
	var assLoc = new Ext.form.ComboBox({
		id: 'assLoc',
		fieldLabel: '��Ԫ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: assLocDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��Ԫ...',
		valueNotFoundText:rowObj[0].get("deptName"),
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	assLocDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.deptlevelsetsexe.csp?action=listloc&recname='+Ext.getCmp('assLoc').getRawValue()+'&id='+units.getValue()+'&repdr='+repdr,method:'GET'});
	});
	
	var recCostFlag = new Ext.form.Checkbox({
		id: 'recCostFlag',
		labelSeparator: '���ܳɱ�:',
		allowBlank: false,
		checked: (rowObj[0].data['recCost'])=='Y'?true:false
	});
	var distCostFlag = new Ext.form.Checkbox({
		id: 'distCostFlag',
		labelSeparator: '��̯���:',
		checked: (rowObj[0].data['distCost'])=='Y'?true:false,
		allowBlank: false
	});
	
	var orderField = new Ext.form.NumberField({
		id:'orderField',
		fieldLabel: '˳��',
		selectOnFocus:true,
		allowBlank: false,
		name:'order',
		emptyText:'˳��...',
		anchor: '90%'
	});
	
	// create form panel
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
			orderField,
			unitType,
			units//,
			//assLoc,
			//recCostFlag,
			//distCostFlag
			
			]
	});
    
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
		unitType.setValue(rowObj[0].get("unitTypeDr"));//unitTypeDr
		units.setValue(rowObj[0].get("unitDr"));
		assLoc.setValue(rowObj[0].get("deptDr"));
	});
	
	var window = new Ext.Window({
		title: '�޸ĵ�Ԫ�ֲ�',
		width: 400,
		height:300,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [{
			text: '����', 
			id:"saveButton",
			handler: function() {
				// check form value
				if (formPanel.form.isValid()) {
					var distCost=(distCostFlag.getValue()==true)?'Y':'N';
					var recCost=(recCostFlag.getValue()==true)?'Y':'N';
					var tmpDept=units.getValue();
					if(tmpDept==""){
						Ext.Msg.show({title:'����',msg:'��ѡ��Ԫ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
					 
						Ext.Ajax.request({
							url: deptLevelSetsUrl+'?action=editloc&locDr='+units.getValue()+'&recCost='+recCost+'&distCost='+distCost+'&id='+rowid+"&subjdr="+repdr+'&order='+orderField.getValue(),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
							if (jsonData.success=='true') {
								Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
								Ext.getCmp('detailReport').getNodeById(repdr).reload();
								window.close();
								}
								else
								{
									var message=jsonData.info;
									if(message=="roo")  message="��Ԫ������Ӵ˽ڵ���!"
									else message="�õ�Ԫ�Ѿ���"+jsonData.info+"�����!";
									Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
							scope: this
						});
				}
				else{
					Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}             
			}
		},
		{
			text: 'ȡ��',
			handler: function(){window.close();}
		}]
	});
    window.show();
	unitType.on("select",function(cmb,rec,id ){
		units.setRawValue("");
		units.setValue("");
		assLoc.setValue("");
		unitsDs.load({params:{start:0, limit:cmb.pageSize,UnitType:cmb.getValue()}});
		//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
	});

};