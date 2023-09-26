AddLocFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
	if(leaf)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ��Ľڵ�,������Ӳ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(repdr == "")
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	if(repdr == "roo")
	{
		Ext.Msg.show({title:'ע��',msg:'�˽ڵ㲻������ʵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	var unitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: 'ҽԺ�������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��ҽԺ�������...',
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
		fieldLabel: 'ҽԺ��Ԫ',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��ҽԺ��Ԫ...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'POST'});
	});
	
	//zjw 20160828  ����ҽԺ��ˢ��ҽԺ�µĺ������
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
		fieldLabel: '�������',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: assLocDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��������...',
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
		labelSeparator: '���ܳɱ�:',
		allowBlank: false,
		checked:true
	});
	var distCostFlag = new Ext.form.Checkbox({
		id: 'distCostFlag',
		labelSeparator: '��̯���:',
		allowBlank: false,
		checked:true
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
		title: '��Ӳ��ŷֲ�',
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
				if (formPanel.form.isValid()) {
					var distCost=(distCostFlag.getValue()==true)?'Y':'N';
					var recCost=(recCostFlag.getValue()==true)?'Y':'N';
					var tmpDept=assLoc.getValue();
					if(tmpDept==""){
						Ext.Msg.show({title:'����',msg:'��ѡ����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
						return;
					}
						Ext.Ajax.request({
							url: encodeURI(deptLevelSetsUrl+'?action=addloc&locDr='+assLoc.getValue()+'&recCost='+recCost+'&distCost='+distCost+'&id='+repdr+'&order='+orderField.getValue()),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
								if (jsonData.success=='true') {
									Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									assLoc.setValue("");
									assLocDs.load({params:{start:0, limit:assLoc.pageSize,id:units.getValue()}});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									Ext.getCmp('detailReport').getNodeById(repdr).reload();
									//window.close();
								}
								else
								{
									var message=jsonData.info;
									if(message=="roo")  message="���Ų�����Ӵ˽ڵ���!"
									else message="�ò����Ѿ���"+jsonData.info+"�����!";
									//Ext.getCmp('detailReport').getNodeById(message).reload();
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
		unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
	});
	units.on("select",function(cmb,rec,id ){
			type="";
			assLocDs.load({params:{start:0, limit:assLoc.pageSize,id:cmb.getValue()}});
	});
};