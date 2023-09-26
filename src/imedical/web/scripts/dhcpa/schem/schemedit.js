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
			width:230,
			listWidth : 230,
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

		var schemFlagField = new Ext.form.ComboBox({
			id:'schemFlagField',
			fieldLabel: '��������',
			width:230,
			listWidth : 230,
			editable:false,
			name:'schemFlag',
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			valueNotFoundText:rowObj[0].get('schemFlag'),
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['Y','�����ʾ�'],['N','һ�㷽��']]
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
			width:230,
			listWidth : 230,
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

var KPIIndexField = new Ext.ux.form.LovCombo({
    id: 'KPIIndexField',
    fieldLabel: '���ָ��',
    anchor: '90%',
    //allowBlank: false,
    store: KPIIndexDs,
    valueField: 'rowid',
    displayField: 'name',
    triggerAction: 'all',
    value:rowObj[0].get('KPIDr'),
   
   // mode			: "local",
  // hiddenName		: "KPIIndexField",
    name: 'KPIIndexField',
    minChars: 1,
    editable:false
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
 var computeTypeField = new Ext.form.ComboBox({
            id:'computeTypeField',
            fieldLabel: '����ʽ',
            editable:false,
            anchor: '90%',
            valueField: 'rowid',
            displayField:'name',
            mode:'local',
            triggerAction:'all',
            valueNotFoundText:rowObj[0].get('computeTypeName'),
            store:new Ext.data.SimpleStore({
                fields:['rowid','name'],
                data:[['1','���д���ʽ'],['2','���⴦��ʽ'],['3','����ʽ']]
            })          
        });
var isStopField = new Ext.form.Checkbox({  //2016-8-3 add cyl
		id: 'isStop',
		fieldLabel:'�Ƿ�ͣ��',
		allowBlank: false
	});
 ////////////////�ϼ�����////////////////////////

    
        var schemDs = new Ext.data.Store({
            proxy: "",
            reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows'},['rowid','code','name','desc'])
        });

        schemDs.on('beforeload', function(ds, o){
            ds.proxy=new Ext.data.HttpProxy({url:'dhc.pa.userschemauditexe.csp?action=schem&start=0&limit=10000',method:'GET'});
        });
    
        var upschemCombo = new Ext.ux.form.LovCombo({
            id:'upschemCombo',
            fieldLabel:'�ϼ�����',
            store: schemDs,
            displayField:'name',
            valueField:'rowid',
           
            name:'upschemCombo',
            triggerAction: 'all',
            value:rowObj[0].get('upschemDr'),
            //emptyText:'ѡ��...',
            listWidth : 230,
            //pageSize: 10,
            minChars: 1,
            anchor: '90%',
            editable:false
            //selectOnFocus:true
            
        });
	// create form panel
	var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
			codeField,
            nameField,
			monthField,
           // appSysField,
			KPIIndexField,
			computeTypeField,
			upschemCombo,
			//schemFlagField,
			isStopField
		]
	});

	formPanel.on('afterlayout', function(panel, layout) {
			this.getForm().loadRecord(rowObj[0]);
			
			appSysField.setValue(rowObj[0].get("appSys"));
			monthField.setValue(rowObj[0].get("quency"));
			
			KPIIndexField.setRawValue(rowObj[0].get("KPIName"));
			
			schemFlagField.setValue(rowObj[0].get("schemType"));
			computeTypeField.setValue(rowObj[0].get("computeTypeDr"));
			upschemCombo.setValue(rowObj[0].get("upschemDr"));
			upschemCombo.setRawValue(rowObj[0].get("upschemName"));
			isStopField.setValue(rowObj[0].get("isStop")=="N"?"on":"");
		});
  	
  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '�޸ļ�Ч����',
    width: 380,
    height:250,
    minWidth: 380,
    minHeight: 250,
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
			var schemFlag= schemFlagField.getValue();
			var isStop = (isStopField.getValue()==true)?'N':'Y';
			var computeType=computeTypeField.getValue();
			var upschem = upschemCombo.getValue();
      		code = code.trim();
			name = name.trim();
      		
        	var data = code+'^'+name+'^'+appSys+'^'+month+'^'+kpi+"^"+schemFlag+"^"+isStop+"^"+computeType+"^"+upschem;
     	if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.pa.schemexe.csp?action=edit&data='+encodeURIComponent(data)+'&rowid='+myRowid,
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