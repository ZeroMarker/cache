inDataCardRuleAddFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
  // pre-define fields in the form
    
	var selectedRow = grid.getSelections();
	if (selectedRow.length < 1){
		Ext.MessageBox.show({title: '��ʾ',msg: '��ѡ��һ�����ݣ�',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.INFO});
		return;
	}
	var selectedRowid=selectedRow[0].get("rowid");
	var selectedCode=selectedRow[0].get("code");
	
	var formStore = new Ext.data.SimpleStore({//������Ͽ�����ʾ������Դ
		fields: ['type','rowid'],
		data : [['סԺ','I'],['����','O'],['���','H'],['��','']]
	});
	var formComm = new Ext.form.ComboBox({
		id: 'formComm',
		fieldLabel: '��������',
		anchor: '70%',
		listWidth : 260,
		allowBlank: true,
		store: formStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'��������...',
		mode: 'local',
		name:'Flag',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	
	
	var itemTypeDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'order', 'code', 'name', 'shortcut', 'remark', 'active'])
    });

    itemTypeDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.dataitemcorresexe.csp?action=listtype&searchField=shortcut&searchValue=' + Ext.getCmp('itemTypesCombo').getRawValue(), method: 'GET' });
    });

    var itemTypesCombo = new Ext.form.ComboBox({
        id: 'itemTypesCombo',
        fieldLabel: '��Ŀ���',
        store: itemTypeDs,
        valueField: 'rowid',
        displayField: 'shortcut',
        typeAhead: true,
        pageSize: 12,
        minChars: 1,
        anchor: '70%',
        listWidth: 260,
        triggerAction: 'all',
        emptyText: 'ѡ�����������...',
        allowBlank: true,
        selectOnFocus: true,
        forceSelection: true
    });
    
    var itemsDs = new Ext.data.Store({
        autoLoad: true,
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowid', 'typeDr', 'typeName', 'typeShortCut', 'order', 'itemDr', 'itemCode', 'itemName', 'itemShortCut'])
    });

    itemsDs.on('beforeload', function(ds, o) {
        //ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.dataitemcorresexe.csp?action=list&searchField=itemShortCut&searchValue=' + Ext.getCmp('itemsCommbo').getRawValue() + '&dataTypeDr=' + itemTypesCombo.getValue(), method: 'GET' });
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.dataitemcorresexe.csp?action=list&searchField=itemShortCut&searchValue=' + Ext.getCmp('itemsCommbo').getRawValue() + '&dataTypeDr=1', method: 'GET' });  //1--����������DR
    
    });

    var itemsCommbo = new Ext.form.ComboBox({
        id: 'itemsCommbo',
        fieldLabel: '����������',
        store: itemsDs,
        valueField: 'itemDr',
        displayField: 'itemShortCut',
        typeAhead: true,
        pageSize: 12,
        minChars: 1,
        anchor: '70%',
        listWidth: 260,
        triggerAction: 'all',
        emptyText: 'ѡ��������...',
        allowBlank: 'true',
        selectOnFocus: true,
        forceSelection: true,
        listeners:{
	        select:function(){
		        if(formComm.getValue()==""){
			        message="ѡ����������ʱ��ѡ���������ͣ�";
			        Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		        	itemsCommbo.setValue("");
		        	return
		        }
	        
		    }
	    }
	   
    });
	
	
	var unitTypeDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var unitType = new Ext.form.ComboBox({
		id: 'unitType',
		fieldLabel: 'ҽԺ�������',
		anchor: '70%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��ҽԺ����...',
		pageSize: 12,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitType').getRawValue(),method:'POST'});
	});
	
	//20160830  zjw  ��ҽԺ��Դ���Һ�Ŀ���������ҽԺ���ű仯
	//-----------------
		unitType.on("select",function(cmb,rec,id ){
		//srDeptDrCommbo.setRawValue("");
		units.setValue("");
		srDeptDrCommbo.setValue("");
		deDeptDrCommbo.setValue("");
		unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		srDeptDrCommboDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		deDeptDrCommboDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
	});
	//-----------------
	
	
	

	var unitsDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var units = new Ext.form.ComboBox({
		id: 'units',
		fieldLabel: 'ҽԺ��Ԫ',
		anchor: '70%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'ѡ��ҽԺ��Ԫ...',
		pageSize: 12,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'POST'});
	    
	
	});
	//20160829  zjw  ��Դ���Һ�Ŀ���������ҽԺ�仯
	//-----------------
		units.on("select",function(cmb,rec,id ){
		//srDeptDrCommbo.setRawValue("");
		srDeptDrCommbo.setValue("");
		deDeptDrCommbo.setValue("");
		srDeptDrCommboDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		deDeptDrCommboDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
		//UnitPersonsDs.load({params:{start:0, limit:0,id:cmb.getValue(),searchValue:"",type:type}});
	});
	//-----------------
	
	
	var srDeptDrCommboDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'address', 'remark', 'startTime', 'stop', 'unitDr', 'propertyDr', 'active'])
    });
    var srDeptDrCommbo = new Ext.form.ComboBox({
        id: 'srDeptDrCommbo',
        fieldLabel: 'Դ����',
        anchor: '70%',
        listWidth: 260,
        allowBlank: false,
        store: srDeptDrCommboDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ��Դ����...',
        pageSize: 12,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    srDeptDrCommboDs.on('beforeload', function(ds, o) {
      
        ds.proxy=  new Ext.data.HttpProxy({  url: 'dhc.ca.unitdeptsexe.csp?action=list&searchField=shortcut&searchValue=' + Ext.getCmp('srDeptDrCommbo').getRawValue() + '&unitDr=' + units.getValue(), method: 'GET' });
	});
	
	var deDeptDrCommboDs = new Ext.data.Store({
        proxy: "",
        reader: new Ext.data.JsonReader({ totalProperty: "results", root: 'rows' }, ['rowId', 'code', 'name', 'shortcut', 'address', 'remark', 'startTime', 'stop', 'unitDr', 'propertyDr', 'active'])
    });
    var deDeptDrCommbo = new Ext.form.ComboBox({
        id: 'deDeptDrCommbo',
        fieldLabel: 'Ŀ�����',
        anchor: '70%',
        listWidth: 260,
        allowBlank: false,
        store: deDeptDrCommboDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: 'ѡ��Ŀ�����...',
        pageSize: 12,
        minChars: 1,
        selectOnFocus: true,
        forceSelection: true
    });

    deDeptDrCommboDs.on('beforeload', function(ds, o) {
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.unitdeptsexe.csp?action=list&searchField=shortcut&searchValue=' + Ext.getCmp('deDeptDrCommbo').getRawValue() + '&unitDr=' + units.getValue(), method: 'GET' });
    });

  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80
	});
	if(selectedCode==RULEONE){
		formPanel.add(unitType);
		formPanel.add(units);
		formPanel.add(srDeptDrCommbo);
	}else if(selectedCode==RULETWO){
	
	   formPanel.add(unitType);
		formPanel.add(units);
		formPanel.add(srDeptDrCommbo);
		formPanel.add(formComm);
		formPanel.add(itemsCommbo);
		formPanel.add(deDeptDrCommbo);
	
	}else{
	    formPanel.add(itemTypesCombo);
		formPanel.add(itemsCommbo);
	    formPanel.add(unitType);
		formPanel.add(units);
		formPanel.add(deDeptDrCommbo);
		
	}
	
	
	
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��������������',
    width: 400,
    height:240,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
		id:'saveButton',
    	text: '����', 
      handler: function() {
      		// check form value
			var srDeptDr=srDeptDrCommbo.getValue();
			var deDeptDr=deDeptDrCommbo.getValue();
			var PatTypeDr=formComm.getValue();
			var itemDr=itemsCommbo.getValue();
			if(srDeptDr==deDeptDr)
      		{
      			Ext.Msg.show({title:'����',msg:'Ŀ�������Դ������ͬ�������������ԣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			/*
			if((PatTypeDr=="")&&(itemDr>0))
      		{
      			Ext.Msg.show({title:'����',msg:'ѡ����������ʱ��ѡ���������ͣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};*/
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: busdingUrl+'?action=addCardRule&itemDr='+itemDr+'&deDeptDr='+deDeptDr+'&srDeptDr='+srDeptDr+'&parRef='+selectedRowid+'&PatTypeCode='+PatTypeDr,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,parRef:selectedRowid}});
									
								}
								else
								{
								
									var message=jsonData.info;
									//if((jsonData.info=='RepSrDept')||(jsonData.info=='RepSrDeptPatType')||(jsonData.info=='RepSrDeptPatTypeItem')) message='����Ĺ�������ӹ�!';
									
									if((jsonData.info=='SrDeptExist')||(jsonData.info=='PatTypeExist')||(jsonData.info=='ItemExist')){
										if(jsonData.info=='SrDeptExist') message='Դ�����Ѵ��ڶ�������!';
										if(jsonData.info=='PatTypeExist') message='Դ�����Ѵ��ں����������͵Ĺ���!';
										//if(jsonData.info=='PatTypeNull') message='Դ�����Ѵ������������͵Ĺ���!';
										if(jsonData.info=='ItemExist') message='Դ�����Ѵ��ں��к���������Ĺ���!';
										//if(jsonData.info=='ItemNull') message='Դ�����Ѵ����޺���������Ĺ���!';
									} else{ message='����Ĺ�����ָ��'+jsonData.info+'!';}
									
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

};