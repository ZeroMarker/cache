var addFun = function(dataStore,grid,pagingTool) {
	//alert(userDr);
	if(monthDr==""){
		Ext.Msg.show({title:'错误',msg:'请选择核算区间再试!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	}
	//20160811 zhw 增加判断如果支出数据为空,不去判断处理标志

	var count=grid.getStore().getCount();
	
	if(count<1){ var winop=function(){window.open();}
		}
	else	 
	{
		var dealFlag=dataStore.getAt(1).get('dealFlag'); 
		
		
	  if (dealFlag=="Y")
	  {
		  
		  Ext.Msg.show({title:'错误',msg:'数据已处理，请求被拒绝!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
		  }
	}
	
	
	var debitField = new Ext.form.NumberField({
		id: 'debitField',
		fieldLabel: '借方',
		//allowDecimals:false,
		allowBlank: false,
		value:0,
		anchor: '90%'
	});
	
	var loansField = new Ext.form.NumberField({
		id: 'loansField',
		fieldLabel: '贷方',
		//allowDecimals:false,
		allowBlank: false,
		value:0,
		anchor: '90%'
	});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '备注',
		allowBlank: true,
		emptyText: '凭证数据备注...',
		anchor: '90%'
	});
	var itemTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','order','code','name','shortcut','remark','active'])
	});

	itemTypeDs.on('beforeload',function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.dataitemcorresexe.csp?action=listtype&searchField=shortcut&searchValue='+Ext.getCmp('itemTypes').getRawValue(), method:'GET'});
	});

	var itemTypes = new Ext.form.ComboBox({
		id:'itemTypes',
		fieldLabel:'项目类别',
		store: itemTypeDs,
		valueField:'rowid',
		displayField:'shortcut',
		typeAhead:true,
		pageSize: 12,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择数据项类别...',
		allowBlank: false,
		name:'itemTypes',
		selectOnFocus: true,
		forceSelection: true 
	});
	
	var itemsDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                                        
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','typeDr','typeName','typeShortCut','order','itemDr','itemCode','itemName','itemShortCut'])
	});

	itemsDs.on('beforeload',function(ds, o){           
		//ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=items&searchField=itemShortCut&searchValue='+Ext.getCmp('items').getRawValue()+'&id='+itemTypes.getValue(), method:'GET'});	zjw20160913屏蔽 避免用户误操作选其他分类
		ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=items&searchField=itemShortCut&searchValue='+Ext.getCmp('items').getRawValue()+'&id=2', method:'GET'});
	});

	var items = new Ext.form.ComboBox({
		id:'items',
		fieldLabel:'成本项目',
		store: itemsDs,
		valueField:'itemDr',
		displayField:'itemShortCut',
		typeAhead:true,
		pageSize: 12,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'选择数据项类别...',
		allowBlank: false,
		name:'items',
		selectOnFocus: true,
		forceSelection: true 
	});
	
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
		emptyText:'选择医院集团...',
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
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=units&searchValue='+Ext.getCmp('units').getRawValue()+'&id='+unitType.getValue(),method:'POST'});
	});
	
	var assLocDs = new Ext.data.Store({
		proxy: "",                                                            
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','address','remark','startTime','stop','unitDr','propertyDr','active'])
	});
	var assLoc = new Ext.form.ComboBox({
		id: 'assLoc',
		fieldLabel: '成本部门',
		anchor: '90%',
		listWidth : 260,
		allowBlank: true,
		store: assLocDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择成本部门...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});

	assLocDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.vouchdatasexe.csp?action=depts&searchField=shortcut&searchValue='+Ext.getCmp('assLoc').getRawValue()+'&unitsDr='+units.getValue(),method:'GET'});
	});
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 80,
		items: [
			unitType,
			units,
			assLoc,
			//itemTypes,  zjw20160913屏蔽 避免用户误操作选其他分类
			items,
			debitField,
			loansField,
			remarkField
		]        
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加凭证数据表',
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
			
			var deptDr = assLoc.getValue();
      		var itemsDr = items.getValue();
      		var remark = remarkField.getValue();
			var debit=debitField.getValue();
			var loans=loansField.getValue();
			
        	if (formPanel.form.isValid()) {
						//alert('action=add&deptDr='+deptDr+'&itemsDr='+itemsDr+'&remark='+remark+'&debit='+debit+'&loans='+loans+'&monthDr='+monthDr+'&userDr='+userDr);
						//return;
						Ext.Ajax.request({
							url: vouchDatasUrl+'?action=add&deptDr='+deptDr+'&itemsDr='+itemsDr+'&remark='+remark+'&debit='+debit+'&loans='+loans+'&monthDr='+monthDr+'&userDr='+userDr,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									vouchDatasDs.setDefaultSort('rowid', 'desc');
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,monthDr:monthDr}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyName') message='输入的名称为空!';
									if(jsonData.info=='EmptyOrder') message='输入的序号为空!';
									if(jsonData.info=='RepName') message='输入的名称已经存在!';
									if(jsonData.info=='RepOrder') message='输入的序号已经存在!';
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
		assLoc.setRawValue("");
		unitsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
	});
	units.on("select",function(cmb,rec,id ){
		assLoc.setValue("");
		assLoc.setRawValue("");
		assLocDs.load({params:{start:0, limit:assLoc.pageSize,id:cmb.getValue()}});
	});
	itemTypes.on("select",function(cmb,rec,id ){
		items.setRawValue("");
		items.setValue("");
		itemsDs.load({params:{start:0, limit:cmb.pageSize,id:cmb.getValue()}});
	});
    window.show();
};