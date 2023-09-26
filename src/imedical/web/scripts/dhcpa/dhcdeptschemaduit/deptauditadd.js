addSchemFun = function(dataStore,grid,pagingTool) {
var userID = session['LOGON.USERID'];
var DeptIndexDs = new Ext.data.Store({
	proxy:DeptIndexProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
});

DeptIndexDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:DeptAuditUrl+'?action=name&str='+Ext.getCmp('DeptIndex').getValue()});
    });

var DeptIndex = new Ext.form.ComboBox({
			id:'DeptIndex',
			fieldLabel: '�Բ�����',
			valueField: 'rowid',
			displayField:'name',
			emptyText:'��ѡ���Բ�����...',
			triggerAction:'all',
			width:213,
			listWidth : 213,
			allowBlank: false,
			store:DeptIndexDs,
            minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true			
		});
		

   var userDs = new Ext.data.Store({
	proxy:"",
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
});
userDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({
		url:DeptAuditUrl+'?action=user&str='+encodeURIComponent(Ext.getCmp('user').getRawValue())});
});

var user = new Ext.form.ComboBox({
			id:'user',
			fieldLabel: '�û�����',
			valueField: 'rowid',
			displayField:'name',
			emptyText:'��ѡ���û�...',
			triggerAction:'all',
			width:213,
			listWidth : 213,
			allowBlank: false,
			store:userDs,
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
    
            user,
	        DeptIndex		
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '����Բ�Ȩ��',
    width: 400,
    height:200,
    minWidth: 200,
    minHeight: 100,
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
      		
			var Dept = DeptIndex.getValue();
		    var userDr = user.getValue();
      		
			if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: DeptAuditUrl+'?action=add&DschemDr='+Dept+'&DuserDr='+userDr,
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
									if(jsonData.info=='') message='���������Ϊ��!';
									
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