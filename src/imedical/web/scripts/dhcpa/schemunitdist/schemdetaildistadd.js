addSchemDetailDistFun = function(dataStore,grid,pagingTool) {
if(schemedistField.getValue()==""){
  Ext.Msg.show({title:'ע��',msg:'��ѡ�񷽰�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
  return false;
}
if(extremum.getValue()==""){
  Ext.Msg.show({title:'ע��',msg:'��ѡ��ֵ!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
  return false;
}

if((extremum.getValue()=='H')||(extremum.getValue()=='L')){
var rangeDr = new Ext.form.ComboBox({
			id:'rangeDr',
			fieldLabel: '����',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['1','����1'],['2','����2'],['3','����3'],['4','����4']]
			})			
		});
}
else{
var rangeDr = new Ext.form.ComboBox({
			id:'rangeDr',
			fieldLabel: '����',
			editable:false,
			valueField: 'rowid',
			displayField:'name',
			mode:'local',
			triggerAction:'all',
			store:new Ext.data.SimpleStore({
				fields:['rowid','name'],
				data:[['1','����1'],['2','����2'],['3','����3'],['4','����4'],['5','����5'],['6','����6']]
			})			
		});
}	
	var SchemDetailDs = new Ext.data.Store({
	proxy:new Ext.data.HttpProxy({url:SchemUrl+'?action=schemdetail&&start=0&limit=25&schem='+schemedistField.getValue()+'&trend='+extremum.getValue()}),
	reader: new Ext.data.JsonReader({
		root: 'rows',
		totalProperty: 'results'
	}, [
            'rowid','name'
 
		]),
    remoteSort: true
	});
	SchemDetailDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({url:SchemUrl+'?action=schemdetail&&start=0&limit=25&schem='+schemedistField.getValue()+'&trend='+extremum.getValue()});
	});

	var SchemDetailDrField = new Ext.form.ComboBox({
		id: 'SchemDetailDrField',
		fieldLabel: '������ϸ',
		width:180,
		listWidth : 180,
		allowBlank: false,
		store: SchemDetailDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ�񷽰���ϸ...',
		name: 'SchemDetailDrField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});

	var scorelower = new Ext.form.TextField({
		id: 'scorelower',
		fieldLabel: '��ʼ��',
		allowBlank: true,
		emptyText:'�����ʼ��...',
		anchor: '90%'
	});
	
	var scoreup = new Ext.form.TextField({
		id: 'scoreup',
		fieldLabel: '��ֹ��',
		allowBlank: true,
		emptyText:'�����ֹ��...',
		anchor: '90%'
	});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 80,
    items: [
	        SchemDetailDrField,
			rangeDr,
			scorelower,
			scoreup			
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '��������',
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
      		
			var rangeId = rangeDr.getValue();
			var lower = scorelower.getValue();
			var up = scoreup.getValue();
			var SchemDetailDr= SchemDetailDrField.getValue();
		
      		rangeId = rangeId.trim();
			lower = lower.trim();
			up = up.trim();
			SchemDetailDr = SchemDetailDr.trim();
      		
        	var data = rangeId+'^'+lower+'^'+up+'^'+SchemDetailDr;

			if (formPanel.form.isValid()) {
						Ext.Ajax.request({
							url: 'dhc.pa.schemexe.csp?action=schemdetaildistadd&data='+data,
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
									if(jsonData.info=='RepRange') message='�����Ѵ���!';
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