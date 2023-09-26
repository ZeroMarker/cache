addDeptFun = function(dataStore,grid,pagingTool,parRef) {
	
	var unitDr=units.getValue();
	
	var deptDs = new Ext.data.Store({
		proxy: "",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowId','code','name','shortcut','remark','flag','active'])
	});
	var dept = new Ext.form.ComboBox({
		id: 'dept',
		fieldLabel: '部门',
		anchor: '90%',
		listWidth : 260,
		allowBlank: false,
		store: deptDs,
		valueField: 'rowId',
		displayField: 'shortcut',
		triggerAction: 'all',
		emptyText:'选择部门...',
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true
	});
	deptDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:'dhc.ca.unitpersonsexe.csp?action=dept&searchValue='+Ext.getCmp('dept').getRawValue()+'&unitDr='+unitDr,method:'POST'});
	});
	
	var rateField = new Ext.form.NumberField({
		id: 'rateField',
		fieldLabel: '比率',
		value:100,
		allowBlank: false,
		emptyText: '部门所占比重...',
		anchor: '90%'
	});
	//----------------------------------
	Ext.Ajax.request({
		url: UnitPersonsUrl+'?action=checkOwn&parRef='+parRef,
		waitMsg:'保存中...',
		failure: function(result, request) {
			Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
		},
		success: function(result, request) {
			var jsonData = Ext.util.JSON.decode( result.responseText );
			var percent=jsonData.info;
			if (jsonData.success=='true') {
				ownField.disable(); 
			}else{
				ownField.setValue(true);
			}						
		},
		scope: this
	});
	//----------------------------------
	var ownField = new Ext.form.Checkbox({
		id: 'ownField',
		labelSeparator: '行政归属:',
		allowBlank: false,
		checked: false
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 60,
		items: [
			dept,
			rateField,
			ownField
			
		]        
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '添加单位人员部门',
    width: 400,
    height:200,
    layout: 'fit',
    plain:true,
    modal:true,
    bodyStyle:'padding:5px;',
    buttonAlign:'center',
    items: formPanel,
    buttons: [{
    	text: '保存', 
		handler: function() {
			var own = (ownField.getValue()==true)?'Y':'N';
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: encodeURI(UnitPersonsUrl+'?action=adddept&parRef='+parRef+'&dept='+dept.getValue()+'&rate='+rateField.getValue()+'&userId='+userId+'&own='+own),
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		//Ext.Msg.show({title:'注意',msg:'添加成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize,parRef:parRef}});
									ownField.disable(); 
									ownField.setValue(false);
									//___________________________________________________
									Ext.Ajax.request({
										url: UnitPersonsUrl+'?action=percent&id='+parRef,
										waitMsg:'保存中...',
										failure: function(result, request) {
											Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											var percent=jsonData.info;
											if (jsonData.success=='true') {
												if(percent!=100){
													Ext.Msg.show({title:'注意',msg:'比例不为100%请调整!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
												}
												
											}
											else
											{
												var message = "";
												message = "SQLErr: " + jsonData.info;
												if(jsonData.info=='RepDept') message='输入的部门已经存在!';
												Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
									scope: this
									});
									//___________________________________________________
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='RepDept') message='输入的代码已经存在!';
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