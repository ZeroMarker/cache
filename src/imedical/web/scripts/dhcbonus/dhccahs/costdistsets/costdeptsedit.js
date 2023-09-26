editCostDeptsFun = function(dataStore,grid,pagingTool,parRef,type,costCombo,recCombo,layerDr,deptLevelSetsDr) {
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var myRowid="";
	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择成本分摊套修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid"); 
	}
	if(type=="")
	{
		Ext.Msg.show({title:'错误',msg:'请选择科室类型',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		return;
	};

	var itemsDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",                                                        
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['deptDr','deptDesc'])
	});

	itemsDs.on('beforeload',function(ds, o){
		if(type=="inc"){
			ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getBranchDepts&searchValue='+Ext.getCmp('items').getRawValue()+'&id='+parRef+'&layerDr='+layerDr+'&deptSet='+deptLevelSetsDr, method:'GET'});
		}if(type=="outc"){
			ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getCurrentLayerDepts&searchValue='+Ext.getCmp('items').getRawValue()+'&id='+parRef+'&layerDr='+layerDr+'&deptSet='+deptLevelSetsDr, method:'GET'});
		}if(type=="inr"){
			ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getBranchRecDepts&searchValue='+Ext.getCmp('items').getRawValue()+'&id='+parRef+'&layerDr='+layerDr+'&deptSet='+deptLevelSetsDr, method:'GET'});
		}if(type=="outr"){
			ds.proxy = new Ext.data.HttpProxy({url:'dhc.ca.costdistsetsexe.csp?action=getCurrentLayerRecDepts&searchValue='+Ext.getCmp('items').getRawValue()+'&id='+parRef+'&layerDr='+layerDr+'&deptSet='+deptLevelSetsDr, method:'GET'});
		}
	});
	
	var rateField = new Ext.form.NumberField({
		id: 'rateField',
		fieldLabel: '比率',
		allowDecimals:true,
		allowBlank: true,
		name:'rate',
		hidden:true,
		emptyText: '比率...',
		anchor: '90%'
	});
	if((type=="inr")||(type=="outr")){
		rateField.setVisible(true);
	}else{
		rateField.setVisible(false);
	}
	var items = new Ext.form.ComboBox({
		id:'items',
		fieldLabel:'部门',
		store: itemsDs,
		valueField:'deptDr',
		displayField:'deptDesc',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		anchor: '90%',
		listWidth:250,
		triggerAction:'all',
		valueNotFoundText: rowObj[0].get("deptName"),
		emptyText:'选择部门...',
		allowBlank: false,
		selectOnFocus: true,
		forceSelection: true 
	});
	
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			items,
			rateField
		]        
	});
	formPanel.on('afterlayout', function(panel, layout) {
		items.setValue(rowObj[0].get("deptDr"));
		this.getForm().loadRecord(rowObj[0]);
	});
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '成本科室修改',
    width: 400,
    height:200,
    minWidth: 400,
    minHeight: 200,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存', 
		handler: function() {
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: costDistSetsUrl+'?action=editCostDepts&id='+myRowid+'&deptDr='+items.getValue()+'&type='+type+'&rate='+rateField.getValue(),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									if((type=="inc")||(type=="outc")){
										costCombo.disable();
									}else{
										recCombo.disable();
									}
									items.setValue("");
									items.setRawValue("");
									itemsDs.load({params:{start:0, limit:items.pageSize}});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,id:parRef,type:type}});
									window.close();
									
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyCode') message='代码为空!';
									if(jsonData.info=='EmptyName') message='名称为空!';
									if(jsonData.info=='EmptyOrder') message='序号为空!';
									if(jsonData.info=='RepCode') message='代码已经存在!';
									if(jsonData.info=='RepName') message='名称已经存在!';
									if(jsonData.info=='RepPriority') message='优先级已经存在!';
								  Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
					  	scope: this
						});
        	}
        	else{
				Ext.Msg.show({title:'错误', msg:'请选择数据后提交。',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
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