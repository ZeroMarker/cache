editMainFun = function(dataStore,grid,pagingTool) {
	Ext.QuickTips.init();

	var rowObj = grid.getSelections();
	var len = rowObj.length;
	var id = 0;
	var deptDr = '';
	var trigger = '';
	
	if(len < 1)
	{
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}
	else
	{
		id = rowObj[0].get("rowId");
		deptDr = rowObj[0].get("deptDr");
		trigger = rowObj[0].get("deptName");
	}
	
	var deptTrigger = new Ext.form.TriggerField({
		allowBlank:false,
		fieldLabel:'��������',
		name:'deptName',
		emptyText:'ѡ��λ����...'
	});
/////////////////////////////////////////////////	
	var deptSelectWindow = function(){
		
		var typeDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
		});
		
		typeDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listType&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('typeSelecter').getRawValue(), method:'GET'});
			}
		);
  	
		var typeSelecter = new Ext.form.ComboBox({
			id:'typeSelecter',
			fieldLabel:'�������',
			store: typeDs,
			valueField:'rowId',
			displayField:'shortcut',
			typeAhead:true,
			pageSize:10,
			minChars:1,
			width:150,
			listWidth:250,
			triggerAction:'all',
			emptyText:'ѡ��λ���...',
			allowBlank: false,
			selectOnFocus: true,
			forceSelection: true
		});
  	
		typeSelecter.on(
			"select",
			function(cmb,rec,id ){
				unitDs.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listUnit&active=Y&unitTypeDr='+cmb.getValue(), method:'GET'});		//zhw ȥ��ע�� 20160817
				unitDs.load({params:{start:0, limit:pagingTool.pageSize}});		//zhw ȥ��ע�� 20160817
  	  	unitSelecter.setValue('');
  	  	deptSelecter.setValue('');
			}
		);
  	
		var unitDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
		});
		
		unitDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listUnit&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('unitSelecter').getRawValue()+'&unitTypeDr='+typeSelecter.getValue(), method:'GET'});
			}
		);
  	
		var unitSelecter = new Ext.form.ComboBox({
			id:'unitSelecter',
			fieldLabel:'��λ����',
			store: unitDs,
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
			selectOnFocus: true,
			forceSelection: true
		});
  	
		unitSelecter.on(
			"select",
			function(cmb,rec,id){
				deptDs.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listDept&active=Y&unitDr='+cmb.getValue(), method:'GET'});		//zhw ȥ��ע�� 20160817
				deptDs.load({params:{start:0, limit:pagingTool.pageSize}});
				deptSelecter.setValue('');
			}
		);
  	
		var deptDs = new Ext.data.Store({
			autoLoad: true,
			proxy: '',
			reader: new Ext.data.JsonReader({totalProperty:"results",root:'rows',id: 'rowId'},['shortcut','rowId'])
		});
		
		deptDs.on(
			'beforeload',
			function(ds, o){
				ds.proxy = new Ext.data.HttpProxy({url:mainUrl+'?action=listDept&active=Y&searchField=shortcut&searchValue='+Ext.getCmp('deptSelecter').getRawValue()+'&unitDr='+unitSelecter.getValue(), method:'GET'});
			}
		);
  	
		var deptSelecter = new Ext.form.ComboBox({
			id:'deptSelecter',
			fieldLabel:'��������',
			store: deptDs,
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
			selectOnFocus: true,
			forceSelection: true
		});            
			
		var formPanel = new Ext.form.FormPanel({
  		baseCls: 'x-plain',
  	  labelWidth: 60,
  	  items: [
  	    typeSelecter,
  	    unitSelecter,
  	    deptSelecter
			]
		});
		
		var window = new Ext.Window({
  		title: '��ӵ�λ����',
  	  width: 300,
  	  height:200,
  	  layout: 'fit',
  	  plain:true,
  	  modal:true,
  	  bodyStyle:'padding:5px;',
  	  buttonAlign:'center',
  	  items: formPanel,
  	  buttons: [{
  	  	text: 'ȷ��',
  	    handler: function() {
  	    	deptDr = deptSelecter.getValue();
  	    	deptTrigger.setValue(Ext.get('deptSelecter').getValue());
  	    	window.close();
  	    }
  	  },
  	  {
				text: 'ȡ��',
  	    handler: function(){
  	    	window.close();
  	    }
  	  }]
		});
		window.show();
	};
//////////////////////////////////////////////////////////	
	deptTrigger.onTriggerClick = deptSelectWindow;
	
	var orderField = new Ext.form.NumberField({
		id:'orderField',
    fieldLabel: '��ɫ˳��',
    allowBlank: false,
    emptyText:'��ɫ˳��...',
    name:'order',
    anchor: '95%'
	});

	var codeField = new Ext.form.TextField({
		id:'codeField',
    fieldLabel: '��ɫ����',
    allowBlank: false,
    emptyText:'��ɫ����...',
    name:'code',
    anchor: '95%'
	});

	var nameField = new Ext.form.TextField({
		id:'nameField',
    fieldLabel: '��ɫ����',
    allowBlank: false,
    emptyText:'��ɫ����...',
    name:'name',
    anchor: '95%'
	});
	
	var pageField = new Ext.form.TextField({
		id:'pageField',
    fieldLabel: '��ɫҳ��',
    allowBlank: true,
    emptyText:'��ɫҳ��...',
    name:'page',
    anchor: '95%'
	});

	var remarkField = new Ext.form.TextField({
		id:'remarkField',
    fieldLabel: '��ע',
    allowBlank: true,
    emptyText:'��ɫ��ע...',
    name:'remark',
    anchor: '95%'
	});
	
	var activeField = new Ext.form.Checkbox({
		id: 'activeField',
		labelSeparator: '��Ч:',
    allowBlank: false,
		checked: (rowObj[0].data['active'])=='Y'?true:false
	});

  var formPanel = new Ext.form.FormPanel({
  	baseCls: 'x-plain',
    labelWidth: 60,
    items: [
    	orderField,
    	codeField,
      nameField,
      deptTrigger,
      pageField,
      remarkField,
      activeField
		]
	});
	
	formPanel.on('afterlayout', function(panel, layout) {
		this.getForm().loadRecord(rowObj[0]);
	});

  var window = new Ext.Window({
  	title: '�޸ĵ�λ',
    width: 400,
    height:300,
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
      	var page  = pageField.getValue();
        var remark  = remarkField.getValue();
      	var active = (activeField.getValue()==true)?'Y':'N';
      	
      	code = code.trim();
      	name = name.trim();
      	page = page.trim();
      	remark = remark.trim();
      	
        if(formPanel.form.isValid()){
					Ext.Ajax.request({
						url: mainUrl+'?action=edit&id='+id+'&order='+order+'&code='+code+'&name='+name+'&deptDr='+deptDr+'&page='+page+'&remark='+remark+'&active='+active,
						waitMsg:'������...',
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
        else{
					Ext.Msg.show({title:'����', msg:'������ҳ����ʾ�Ĵ�����ύ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				}             
	   	}
   	},
   	{
			text: 'ȡ��',
      handler: function(){
      	window.close();
      }
    }]
  });
  window.show();
};