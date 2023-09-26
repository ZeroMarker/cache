var addKPILvelFun = function(dataStore,grid,pagingTool) {
	
	
	var kpicomDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['KPIDr','shortCut'])
	});

	kpicomDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:KPILvelUrl+'?action=kpi&str='+Ext.getCmp('kpicom').getRawValue(),method:'POST'})
	});

	var kpicom = new Ext.form.ComboBox({
		id:'kpicom',
		fieldLabel:'KPI ָ��',
		width:250,
		listWidth : 250,
		allowBlank:true,
		store:kpicomDs,
		valueField:'KPIDr',
		displayField:'shortCut',
		triggerAction:'all',
		emptyText:'',
		minChars:1,
		pageSize:10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:false,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(kpicom.getValue()!=""){
						actualValueField.focus();
					}else{
						Handler = function(){kpicom.focus();}
						Ext.Msg.show({title:'����',msg:'KPI ָ�겻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});

	var LevelDs = new Ext.data.Store({
			proxy:'',
			reader: new Ext.data.JsonReader({
				root: 'rows',
				totalProperty: 'results'
			}, [
					'scoreLevel','shortCut'
		 
				]),
			remoteSort: true
		});
LevelDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:KPILvelUrl+'?action=level&start=0&limit=999'});
});

var LevelField = new Ext.ux.form.LovCombo({
	id: 'LevelField',
	fieldLabel: '���ָ��',
	width:250,
	listWidth : 250,
	//allowBlank: false,
	store: LevelDs,
	valueField: 'scoreLevel',
	displayField: 'shortCut',
	triggerAction: 'all',
	emptyText:'��ѡ��ָ��...',
	name: 'LevelField',
	minChars: 1,
	//pageSize: 10,
	//selectOnFocus:true,
	//forceSelection:true,
	editable:false
});	

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			kpicom,
            LevelField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��ӵȼ���',
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
    	text: '����',
		handler: function() {
      		// check form value
      		var code = kpicom.getValue();
      		var name = LevelField.getValue();
			
      		code = code.trim();
      		name = name.trim();
		
      		if(code=="")
      		{
      			Ext.Msg.show({title:'����',msg:'ָ�겻��Ϊ��Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
      		if(name=="")
      		{
      			Ext.Msg.show({title:'����',msg:'�ȼ�Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
      			return;
      		};
        	var data = code+'^'+name;
			if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: KPILvelUrl+'?action=add&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									//window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
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