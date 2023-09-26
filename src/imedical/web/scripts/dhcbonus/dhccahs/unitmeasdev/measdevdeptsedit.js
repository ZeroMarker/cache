editMeasDevDeptsFun = function(dataStore,grid,pagingTool,unitMeasDevDr,unitDr,parRef) {
	
	Ext.QuickTips.init();

	var measDevDeptsUrl = 'dhc.ca.measdevdeptsexe.csp';
	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	var measDevDeptsDr = "";

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
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
			  fieldLabel:'����',
			  store: unitDeptsDs,
			  valueField:'rowId',
			  displayField:'shortcut',
			  typeAhead:true,
			  pageSize:10,
			  minChars:1,
			  width:150,
			  listWidth:250,
			  triggerAction:'all',
			  emptyText:'ѡ��λ����...',
	      allowBlank: false,
			  name:'deptName',
			  selectOnFocus: true,
				forceSelection: true 
});

	var rateField = new Ext.form.TextField({
		id:'rateField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText:'������Ʋ��ű���...',
    name:'rate',
    anchor: '95%'
	});


	var inputPersonField = new Ext.form.TextField({
		id:'inputPersonField',
    fieldLabel: '¼����',
    allowBlank: true,
    emptyText:'������Ʋ���¼����..',
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
  	title: '�޸ļ�����Ʋ���',
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
    	text: '����', 
      handler: function() {
      	
      		var unitDeptsDr = unitDeptsSelecter.getValue();
      		var rate = rateField.getValue();
      		
      		rate = rate.trim();
      		
      		if(rate=="")
      		{
      			Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};

        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: measDevDeptsUrl+'?action=edit&unitMeasDevDr='+unitMeasDevDr+'&id='+measDevDeptsDr+'&rate='+rate+'&inputPerson='+userId+'&unitDeptsDr='+unitDeptsDr,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
									
									Ext.Ajax.request({
										url: measDevDeptsUrl+'?action=percent&id='+parRef,
										waitMsg:'������...',
										failure: function(result, request) {
											Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
										},
										success: function(result, request) {
											var jsonData = Ext.util.JSON.decode( result.responseText );
											var percent=jsonData.info;
											if (jsonData.success=='true') {
												if(percent!=100){
													Ext.Msg.show({title:'ע��',msg:'������Ϊ100%�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
												}
												
											}
											else
											{
												var message = "";
												message = "SQLErr: " + jsonData.info;
												if(jsonData.info=='RepDept') message='����Ĵ����Ѿ�����!';
												Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
											}
										},
									scope: this
									});
									
								}
								else
								{
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='RepDept') message='����Ĳ����Ѿ�����!';
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