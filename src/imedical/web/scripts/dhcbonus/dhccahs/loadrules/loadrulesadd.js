addFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();
	
	/////�ӿڲ�����
	var deptSetDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['shortcut','rowid'])
	});
	
	deptSetDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listDeptSet&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('deptSetSelecter').getRawValue(), method:'GET'});
		}
	);
	
	var deptSetSelecter = new Ext.form.ComboBox({
		id:'deptSetSelecter',
		fieldLabel:'������',
		store: deptSetDs,
		valueField:'rowid',
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ��ӿڲ�����...',
		allowBlank: false,
		selectOnFocus: true,
		forceSelection: true
	});   
	
	/////�ӿ���Ŀ��
	var itemSetDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
	});
	
	itemSetDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listItemSet&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('itemSetSelecter').getRawValue(), method:'GET'});
		}
	);
	
	var itemSetSelecter = new Ext.form.ComboBox({
		id:'itemSetSelecter',
		fieldLabel:'��Ŀ��',
		store: itemSetDs,
		valueField:'rowId',
		
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ��ӿ���Ŀ��...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true
	});
	
 
	
	/////���������
	var itemTypeDs = new Ext.data.Store({
		autoLoad: true,
		proxy: '',
		reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowid'},['shortcut','rowid'])
	});
	
	itemTypeDs.on(
		'beforeload',
		function(ds, o){
			ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listItemType&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('itemTypeSelecter').getRawValue(), method:'GET'});
		}
	);
	
	var itemTypeSelecter = new Ext.form.ComboBox({
		id:'itemTypeSelecter',
		fieldLabel:'������',
		store: itemTypeDs,
		valueField:'rowid',
		disabled:true,
		displayField:'shortcut',
		typeAhead:true,
		pageSize:10,
		minChars:1,
		width:150,
		listWidth:250,
		triggerAction:'all',
		emptyText:'ѡ�����������...',
		allowBlank: true,
		selectOnFocus: true,
		forceSelection: true
	});
	

	///////
		
	var orderField = new Ext.form.NumberField({
		id:'orderField',
    fieldLabel: '˳��',
    allowBlank: false,
    emptyText:'˳��...',
    anchor: '95%'
	});

	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText:'����...',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '����',
    allowBlank: false,
    emptyText:'����...',
    anchor: '95%'
	});
	
	var itemSetRadio = new Ext.form.Radio({
		id: 'maleField',
		name:'Item',
		boxLabel: '��Ŀ��',
		value : 'Set', 
		checked: true
	});
	
	var itemTypeRadio = new Ext.form.Radio({
		id: 'femaleField',
		boxLabel: '������',
		name:'Item',
		value : 'Type', 
		checked: false
	});
	
	itemSetRadio.on(
		'check',
		function(radio,disabled){
			if(disabled==false){
				itemSetSelecter.setDisabled(true);
				itemSetSelecter.setValue('');
			}else{
				itemSetSelecter.setDisabled(false);
			}
		}
	);
	
	itemTypeRadio.on(
		'check',
		function(radio,disabled){
			if(disabled==false){
				itemTypeSelecter.setDisabled(true);
				itemTypeSelecter.setValue('');
			}else{
				itemTypeSelecter.setDisabled(false);
			}
		}
	);
	
	var flagPanel = new Ext.Panel({
		layout: 'table',
		border: true,
		isFormField: true,
		baseCls: 'x-plain',
		fieldLabel: '����',
		defaults: {
			border: false,
			baseCls: 'x-plain'
		},
		items: [
			{
				items: itemSetRadio
			},
			{
				items: itemTypeRadio
			}
		]
	});

	// create form panel
  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    	orderField,
    	codeField,
      nameField,
      
      deptSetSelecter,
      flagPanel,
      itemSetSelecter,
      itemTypeSelecter
		]
	});

  // define window and show it in desktop
  var window = new Ext.Window({
  	title: '���',
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
      	var order = orderField.getValue();
      	var code = codeField.getValue();
      	var name = nameField.getValue();
      	
      	code = code.trim();
      	name = name.trim();

        if (formPanel.form.isValid()) {
        	if((itemSetSelecter.getValue()=='')&(itemTypeSelecter.getValue()=='')){
        		Ext.Msg.show({title:'����',msg:'��Ŀ�׺��������ȫΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
        	}else{
        		Ext.Ajax.request({
							url: mainUrl+'?action=add&order='+order+'&code='+code+'&name='+name+'&deptSetDr='+deptSetSelecter.getValue()+'&itemSetDr='+itemSetSelecter.getValue()+'&itemTypeDr='+itemTypeSelecter.getValue(),
							waitMsg:'������...',
							failure: function(result, request) {
								Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							},
							success: function(result, request) {
								var jsonData = Ext.util.JSON.decode( result.responseText );
						  	if (jsonData.success=='true') {
						  		Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
									dataStore.load({params:{start:0, limit:pagingTool.pageSize}});
								}
								else
								{
									var message="SQLErr: "+jsonData.info;
									if(jsonData.info=='RepOrder') message='�����˳���Ѿ�����!';
									if(jsonData.info=='RepCode') message='����Ĵ����Ѿ�����!';
									if(jsonData.info=='RepName') message='����������Ѿ�����!';
								  Ext.Msg.show({title:'����',msg:message,buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
								}
							},
				  		scope: this
						});
        	}

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