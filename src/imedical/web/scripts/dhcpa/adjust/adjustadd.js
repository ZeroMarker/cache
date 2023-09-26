addAdjustFun = function(dataStore,grid,pagingTool) {
var cycleDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','code','name','shortcut','desc','active'])
});

cycleDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:StratagemTabUrl+'?action=cycle&searchValue='+Ext.getCmp('yearField').getRawValue()+'&active=Y',method:'POST'})
});

var yearField = new Ext.form.ComboBox({
	id: 'yearField',
	fieldLabel: '��������',
	width:250,
	listWidth : 250,
	allowBlank: false,
	store: cycleDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ�񿼺�����...',
	name: 'yearField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

var stratagemDs = new Ext.data.Store({
	autoLoad:true,
	proxy:"",
	reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
});

stratagemDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:ParamUrl+'?action=stratagem&cycle='+Ext.getCmp('yearField').getValue()})
});

var planField = new Ext.form.ComboBox({
	id: 'planField',
	fieldLabel: 'ս��',
	width:250,
	listWidth : 250,
	allowBlank: false,
	store: stratagemDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	emptyText:'��ѡ��ս��...',
	name: 'planField',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});
	
	var remarkField = new Ext.form.TextField({
		id: 'remarkField',
		fieldLabel: '����˵��',
		allowBlank: true,
		emptyText:'��ӵ���˵��...',
		anchor: '90%'
	});

	remarkField.on('check', function(o, v){
		if(v==true)	inFlagField.setValue(false);
	});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
	        yearField,
			planField,
			remarkField
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��ӵ���',
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
      		var stratagem = Ext.getCmp('planField').getValue();
			var remark = remarkField.getValue();
		
      		stratagem = stratagem.trim();
			remark = remark.trim();
      		
        	var data = stratagem+'^'+userCode+'^'+remark;
			if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: ParamUrl+'?action=add&data='+data,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
									window.close();
								}
								else
								{
									var message = "";
									message = "SQLErr: " + jsonData.info;
									if(jsonData.info=='EmptyRecData') message='���������Ϊ��!';
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