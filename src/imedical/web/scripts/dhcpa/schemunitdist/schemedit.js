editSchemFun = function(dataStore,grid,pagingTool) {
	var rowObj = grid.getSelectionModel().getSelections();
	var len = rowObj.length;

	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		myRowid = rowObj[0].get("rowid");
	}

var monthField = new Ext.form.ComboBox({
			id:'monthField',
			fieldLabel: '����Ƶ��',
			editable:false,
			name:'frequency',
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			valueNotFoundText:rowObj[0].get('frequency'),
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['M','��'],['Q','��'],['H','����'],['Y','��']]
			})			
		});

var appSysDs = new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['1','ȫԺ'],['2','����'],['3','����'],['4','ҽ��'],['5','����']]
			});		
var appSysField = new Ext.form.ComboBox({
			id:'appSysField',
			fieldLabel: 'Ӧ��ϵͳ��',
			name:'appSysDr',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			forceSelection: true,
			valueNotFoundText:rowObj[0].get('appSysDr'),
			selectOnFocus: true,
			store:appSysDs	
		});

var KPIIndexDs = new Ext.data.Store({
	proxy:KPIIndexProxy,
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
});
KPIIndexDs.on('beforeload', function(ds, o){
	ds.proxy=new Ext.data.HttpProxy({url:KPIIndexUrl+'?action=kpi&&start=0&limit=25'});
});

var KPIIndexField = new Ext.form.ComboBox({
	id: 'KPIIndexField',
	fieldLabel: '���ָ��',
	width:180,
	listWidth : 180,
	allowBlank: false,
	store: KPIIndexDs,
	valueField: 'rowid',
	displayField: 'name',
	triggerAction: 'all',
	valueNotFoundText:rowObj[0].get('KPIName'),
	emptyText:'��ѡ��ָ��...',
	name: 'KPIName',
	minChars: 1,
	pageSize: 10,
	selectOnFocus:true,
	forceSelection:'true',
	editable:true
});

	var codeField = new Ext.form.TextField({
		id: 'codeField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '����...',
		name: 'code',
		anchor: '90%'
	});

	var nameField = new Ext.form.TextField({
		id: 'nameField',
		fieldLabel: '����',
		allowBlank: false,
		emptyText: '����...',
		name: 'name',
		anchor: '90%'
	});


	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			codeField,
            nameField,
			monthField,
            appSysField,
			KPIIndexField
		]
	});

	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			appSysField.setValue(rowObj[0].get("appSys"));
			monthField.setValue(rowObj[0].get("quency"));
			KPIIndexField.setValue(rowObj[0].get("KPIDr"));
		});
  
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸ļ�Ч����',
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
      		var code = codeField.getValue();
			var name = nameField.getValue();
			var appSys = appSysField.getValue();
			var month = monthField.getValue();
			var kpi = KPIIndexField.getValue();
		
		
      		code = code.trim();
			name = name.trim();
      		
        	var data = code+'^'+name+'^'+appSys+'^'+month+'^'+kpi;
     	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.pa.schemexe.csp?action=edit&data='+data+'&rowid='+myRowid,
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
								    dataStore.load({params:{start:pagingTool.cursor, limit:pagingTool.pageSize}});
									window.close();
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