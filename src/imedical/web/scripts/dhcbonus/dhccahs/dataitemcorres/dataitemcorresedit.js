editFun = function(dataStore,grid,pagingTool,hospDr) {
	
	Ext.QuickTips.init();
  // pre-define fields in the form

	var rowObj = grid.getSelections();
	var len = rowObj.length;
	
	var rowid = "";
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		rowid = rowObj[0].get("rowid");
	}

	var orderField = new Ext.form.NumberField({
		id: 'orderField',
		name:'order',
		fieldLabel: '���',
		allowDecimals:false,
		allowBlank: false,
		emptyText: '���...',
		anchor: '95%'
	});
	
	var dataItemDs = new Ext.data.Store({
		autoLoad: true,
		proxy:"",
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','order','code','name','shortcut','remark','active'])
	});

	dataItemDs.on('beforeload',function(ds, o){
		ds.proxy = new Ext.data.HttpProxy({url:dataItemCorresUrl+'?action=listitem&searchField=shortcut&searchValue='+Ext.getCmp('dataItemSelecter').getRawValue(), method:'GET'});
	});

	var dataItemSelecter = new Ext.form.ComboBox({
		id:'dataItemSelecter',
		fieldLabel:'����������',
		store: dataItemDs,
		valueField:'rowid',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		disabled:true, //20160829 zhw ����
		valueNotFoundText:rowObj[0].get("itemShortCut"),
		anchor: '95%',
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ��������...',
		allowBlank: false,
		name:'dataItemSelecter',
		selectOnFocus: true,
		forceSelection: true 
	});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
    		orderField,
            dataItemSelecter
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		dataItemSelecter.setValue(rowObj[0].get("itemDr"));
		this.getForm().loadRecord(rowObj[0]);
	});
    
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸��������Ӧ',
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
			// check form value
			var order = orderField.getValue();
      		var dataItemDr = dataItemSelecter.getValue();
      		
        	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: dataItemCorresUrl+'?action=edit&dataTypeDr='+dataTypeDr+'&order='+order+'&dataItemDr='+dataItemDr+'&id='+rowid,
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize,dataTypeDr:dataTypeDr}});
									window.close();
								}
								else
								{
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='EmptyType') message='��������������Ϊ��!';
									if(jsonData.info=='EmptyOrder') message='��������Ϊ��!';
									if(jsonData.info=='EmptyItem') message='������������Ѿ�����!';
									if(jsonData.info=='RepItem') message='������������Ѿ�����!';
									if(jsonData.info=='RepOrder') message='���������Ѿ�����!';
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