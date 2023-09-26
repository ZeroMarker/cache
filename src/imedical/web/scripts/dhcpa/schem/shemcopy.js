copySchemFun = function(dataStore,grid,pagingTool) {
var StratagemTabUrl='dhc.pa.stratagemexe.csp'
var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var cycleField = new Ext.form.ComboBox({
	id: 'cycleField',
	fieldLabel: '��Դ���',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ����Ҫ�������...',
	name: 'cycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
	
	/////////////////////////////////////

var newcycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

newcycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('cycleField').getRawValue()+'&active=Y',method:'POST'})
});

var newcycleField = new Ext.form.ComboBox({
	id: 'newcycleField',
	fieldLabel: 'Ŀ�����',
	width:180,
	listWidth : 200,
	allowBlank: false,
	store: newcycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ���Ƶ������...',
	name: 'newcycleField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
	
	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
	        cycleField,
			newcycleField
			
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '���Ʒ��������׼',
    width: 320,
    height:150,
    minWidth: 320,
    minHeight: 150,
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
      		
			var cycleDr = cycleField.getValue();
			var newcycleDr = newcycleField.getValue();
			
      		cycleDr = cycleDr.trim();
			newcycleDr = newcycleDr.trim();
			
			
			//alert(upschem);
      		//alert(name);
            //alert(data);
			if (formPanel.form.isValid()) {
			
					if(cycleDr =="")
						{
							Ext.Msg.show({title:'��ʾ',msg:'��Դ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
					if(newcycleDr =="")
						{
							Ext.Msg.show({title:'��ʾ',msg:'Ŀ�����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
							return;
						}
					    //encodeURIComponent
							Ext.Ajax.request({
							url: 'dhc.pa.schemexe.csp?action=copy&cycleDr='+cycleDr+'&newcycleDr='+newcycleDr,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'���Ƴɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='NocurrStragem') message='��ѡ���û��ս�ԣ�';
									if(jsonData.info=='NoSchem') message='��ѡ���û�з�����';
									if(jsonData.info=='NoSchemDetail') message='��ѡ���û�з�����ϸ��';
									if(jsonData.info=='InsertStragemError') message='����ս��ʧ�ܣ�';
									if(jsonData.info=='InsertStragemFlase') message='����ս��ʧ�ܣ�';
									if(jsonData.info=='insertSchemError') message='���Ʒ���ʧ�ܣ�';
									if(jsonData.info=='insertSchemDetailError') message='���Ʒ�����ϸʧ�ܣ�';
									if(jsonData.info=='insertAddError') message='���Ƽӿ۷ֱ�׼ʧ�ܣ�';
									if(jsonData.info=='insertDistError') message='�������ַ���׼ʧ�ܣ�';
								 
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