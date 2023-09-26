inDataCardRuleAddFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
  // pre-define fields in the form
    
	var selectedRow = grid.getSelections();
	if (selectedRow.length < 1){
		Ext.MessageBox.show({title: '提示',msg: '请选择一条数据！',buttons: Ext.MessageBox.OK,icon: Ext.MessageBox.INFO});
		return;
	}
	var selectedRowid=selectedRow[0].get("rowid");
	var selectedCode=selectedRow[0].get("code");
	
	var formStore = new Ext.data.SimpleStore({//定义组合框中显示的数据源
		fields: ['type','rowid'],
		data : [['住院','I'],['门诊','O'],['体检','H'],['无','']]
	});
	var formComm = new Ext.form.ComboBox({
		id: 'formComm',
		fieldLabel: '收入类型',
		anchor: '70%',
		listWidth : 260,
		allowBlank: true,
		store: formStore,
		valueField: 'rowid',
		displayField: 'type',
		triggerAction: 'all',
		emptyText:'收入类型...',
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
        fieldLabel: '项目类别',
        store: itemTypeDs,
        valueField: 'rowid',
        displayField: 'shortcut',
        typeAhead: true,
        pageSize: 12,
        minChars: 1,
        anchor: '70%',
        listWidth: 260,
        triggerAction: 'all',
        emptyText: '选择数据项类别...',
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
        ds.proxy = new Ext.data.HttpProxy({ url: 'dhc.ca.dataitemcorresexe.csp?action=list&searchField=itemShortCut&searchValue=' + Ext.getCmp('itemsCommbo').getRawValue() + '&dataTypeDr=1', method: 'GET' });  //1--核算收入项DR
    
    });

    var itemsCommbo = new Ext.form.ComboBox({
        id: 'itemsCommbo',
        fieldLabel: '核算收入项',
        store: itemsDs,
        valueField: 'itemDr',
        displayField: 'itemShortCut',
        typeAhead: true,
        pageSize: 12,
        minChars: 1,
        anchor: '70%',
        listWidth: 260,
        triggerAction: 'all',
        emptyText: '选择数据项...',
        allowBlank: 'true',
        selectOnFocus: true,
        forceSelection: true,
        listeners:{
	        select:function(){
		        if(formComm.getValue()==""){
			        message="选核算收入项时需选出收入类型！";
			        Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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
		fieldLabel: '医院集团类别',
		anchor: '70%',
		listWidth : 260,
		allowBlank: false,
		store: unitTypeDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择医院集团...',
		pageSize: 12,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	unitTypeDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=unitType&searchValue='+Ext.getCmp('unitType').getRawValue(),method:'POST'});
	});
	
	//20160830  zjw  让医院、源科室和目标科室随着医院集团变化
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
		fieldLabel: '医院单元',
		anchor: '70%',
		listWidth : 260,
		allowBlank: false,
		store: unitsDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择医院单元...',
		pageSize: 12,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	unitsDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'POST'});
	    
	
	});
	//20160829  zjw  让源科室和目标科室随着医院变化
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
        fieldLabel: '源科室',
        anchor: '70%',
        listWidth: 260,
        allowBlank: false,
        store: srDeptDrCommboDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择源科室...',
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
        fieldLabel: '目标科室',
        anchor: '70%',
        listWidth: 260,
        allowBlank: false,
        store: deDeptDrCommboDs,
        valueField: 'rowId',
        displayField: 'shortcut',
        triggerAction: 'all',
        emptyText: '选择目标科室...',
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
  	title: '添加收入梳理规则',
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
    	text: '保存', 
      handler: function() {
      		// check form value
			var srDeptDr=srDeptDrCommbo.getValue();
			var deDeptDr=deDeptDrCommbo.getValue();
			var PatTypeDr=formComm.getValue();
			var itemDr=itemsCommbo.getValue();
			if(srDeptDr==deDeptDr)
      		{
      			Ext.Msg.show({title:'错误',msg:'目标科室与源科室相同，请修正后再试！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
			/*
			if((PatTypeDr=="")&&(itemDr>0))
      		{
      			Ext.Msg.show({title:'错误',msg:'选核算收入项时须选出收入类型！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};*/
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: busdingUrl+'?action=addCardRule&itemDr='+itemDr+'&deDeptDr='+deDeptDr+'&srDeptDr='+srDeptDr+'&parRef='+selectedRowid+'&PatTypeCode='+PatTypeDr,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,parRef:selectedRowid}});
									
								}
								else
								{
								
									var message=jsonData.info;
									//if((jsonData.info=='RepSrDept')||(jsonData.info=='RepSrDeptPatType')||(jsonData.info=='RepSrDeptPatTypeItem')) message='输入的规则已添加过!';
									
									if((jsonData.info=='SrDeptExist')||(jsonData.info=='PatTypeExist')||(jsonData.info=='ItemExist')){
										if(jsonData.info=='SrDeptExist') message='源科室已存在独立规则!';
										if(jsonData.info=='PatTypeExist') message='源科室已存在含有收入类型的规则!';
										//if(jsonData.info=='PatTypeNull') message='源科室已存在无收入类型的规则!';
										if(jsonData.info=='ItemExist') message='源科室已存在含有核算收入项的规则!';
										//if(jsonData.info=='ItemNull') message='源科室已存在无核算收入项的规则!';
									} else{ message='输入的规则已指向'+jsonData.info+'!';}
									
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