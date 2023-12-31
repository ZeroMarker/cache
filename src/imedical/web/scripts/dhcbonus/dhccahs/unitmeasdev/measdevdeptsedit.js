editMeasDevDeptsFun = function(dataStore,grid,pagingTool,unitMeasDevDr,unitDr,parRef) {
	
	Ext.QuickTips.init();

	var measDevDeptsUrl = 'dhc.ca.measdevdeptsexe.csp';
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	var measDevDeptsDr = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'注意',msg:'请选择需要修改的数据!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		measDevDeptsDr = rowObj[0].get("rowId");
		deptName = rowObj[0].get("deptName");
		deptShortCut = rowObj[0].get("deptShortCut");
	}
	
	var unitDeptsUrl = 'dhc.ca.unitdeptsexe.csp';
	
	var unitDeptsDs = new Ext.data.Store({
		proxy: '',
    reader: new Ext.data.JsonReader({
        root: 'rows',
        totalProperty: 'results'
        }, [
            'rowId',
						'code',
						'name',
						'shortcut',
						'address',
						'remark',
						{name:'startTime',type:'date',dateFormat:'Y-m-d'},
						{name:'stop',type:'date',dateFormat:'Y-m-d'},
						'unitDr',
						'propertyDr',
						'active'
		]),
    // turn on remote sorting
    remoteSort: true
	});

	unitDeptsDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:unitDeptsUrl + '?action=list&searchField=shortcut&unitDr='+unitDr+'&searchValue='+Ext.getCmp('unitDeptsSelecter').getRawValue(), method:'GET'});
		}
	);
  
  var unitDeptsSelecter = new Ext.form.ComboBox({
				id:'unitDeptsSelecter',
			  fieldLabel:'名称',
			  store: unitDeptsDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:150,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'选择单位部门...',
	      allowBlank: false,
			  name:'deptName',
			  selectOnFocus: true,
				forceSelection: true 
});

	var rateField = new Ext.form.TextField({
		id:'rateField',
    fieldLabel: '比例',
    allowBlank: false,
    emptyText:'计量表计部门比例...',
    name:'rate',
    anchor: '95%'
	});


	var inputPersonField = new Ext.form.TextField({
		id:'inputPersonField',
    fieldLabel: '录入人',
    allowBlank: true,
    emptyText:'计量表计部门录入人..',
    name:'inputPersonDr',
    anchor: '95%'
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    				unitDeptsSelecter,
    				rateField
            //inputPersonField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
		});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '修改计量表计部门',
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
      	
      		var unitDeptsDr = unitDeptsSelecter.getValue();
      		var rate = rateField.getValue();
      		
      		rate = rate.trim();
      		
      		if(rate=="")
      		{
      			Ext.Msg.show({title:'错误',msg:'比例为空',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};

        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: measDevDeptsUrl+'?action=edit&unitMeasDevDr='+unitMeasDevDr+'&id='+measDevDeptsDr+'&rate='+rate+'&inputPerson='+userId+'&unitDeptsDr='+unitDeptsDr,
							waitMsg:'保存中...',
							failure: function(result, request) {
								Ext.Msg.show({title:'错误',msg:'请检查网络连接!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'注意',msg:'修改成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
									
									Ext.Ajax.request({
										url: measDevDeptsUrl+'?action=percent&id='+parRef,
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
												if(jsonData.info=='RepDept') message='输入的代码已经存在!';
												Ext.Msg.show({title:'错误',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
									scope: this
									});
									
								}
								else
								{
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='RepDept') message='输入的部门已经存在!';
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