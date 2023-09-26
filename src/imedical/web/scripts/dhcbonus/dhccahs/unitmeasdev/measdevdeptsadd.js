addMeasDevDeptsFun = function(dataStore,grid,pagingTool,unitMeasDevDr,unitDr,parRef) {
	Ext.QuickTips.init();
  // pre-define fields in the form
  
  var unitDeptsUrl = 'dhc.ca.unitdeptsexe.csp';
	var measDevDeptsUrl = 'dhc.ca.measdevdeptsexe.csp';
  
  
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
			  name:'unitDeptsSelecter',
			  selectOnFocus: true,
				forceSelection: true 
});

	var rateField = new Ext.form.TextField({
		id:'rateField',
    fieldLabel: '����',
    value:100,
    allowBlank: false,
    emptyText:'������Ʋ��ű���...',
    anchor: '95%'
	});


	var inputPersonField = new Ext.form.TextField({
		id:'inputPersonField',
    fieldLabel: '¼����',
    allowBlank: true,
    emptyText:'�绰����¼����..',
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
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��Ӽ�����Ʋ���',
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
							url: measDevDeptsUrl+'?action=add&unitMeasDevDr='+unitMeasDevDr+'&unitDeptsDr='+unitDeptsDr+'&rate='+rate+'&inputPerson='+userId,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									////////////////////////////////////////////////////////////////
									
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