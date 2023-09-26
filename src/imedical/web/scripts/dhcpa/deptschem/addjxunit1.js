function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
addJXUnitFun = function(schemGrid,jxUnitDs,jxUnitGrid,pagingToolbar){
	var userCode = session['LOGON.USERCODE'];
	
	var unitDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitShortCut'])
	});

	unitDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'../csp/dhc.pa.deptschemexe.csp?action=jxunit&userCode='+userCode+'&str='+Ext.getCmp('unitField').getRawValue(),method:'POST'})
	});

	var unitField = new Ext.form.ComboBox({
		id: 'unitField',
		fieldLabel: '��Ч��Ԫ',
		width:230,
		listWidth : 230,
		allowBlank: false,
		store: unitDs,
		valueField: 'jxUnitDr',
		displayField: 'jxUnitShortCut',
		triggerAction: 'all',
		emptyText:'��ѡ��Ч��Ԫ...',
		name: 'unitField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:60,
		items: [
			unitField
		]
	});
	
	var addButton = new Ext.Toolbar.Button({
		text:'���'
	});
			
	//��Ӵ�����
	var addHandler = function(){
		var jxunitdr = Ext.getCmp('unitField').getValue();
		jxunitdr = trim(jxunitdr);
		if(jxunitdr==""){
			Ext.Msg.show({title:'��ʾ',msg:'��Ч��ԪΪ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		var schemDr=schemGrid.getSelections()[0].get("rowid");
		schemDr = trim(schemDr);
		if(schemDr==""){
			Ext.Msg.show({title:'��ʾ',msg:'��Ч����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		Ext.Ajax.request({
			url:'../csp/dhc.pa.deptschemexe.csp?action=add&schemDr='+schemDr+'&jxunitdr='+jxunitdr,
			waitMsg:'�����..',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					jxUnitDs.load({params:{start:pagingToolbar.cursor, limit:pagingToolbar.pageSize,schemDr:schemGrid.getSelections()[0].get("rowid"),dir:'asc',sort:'rowid'}});
				}else{
					if(jsonData.info=='RepRecode'){
						Handler = function(){unitField.focus();}
						Ext.Msg.show({title:'��ʾ',msg:'���ݼ�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
				}
			},
			scope: this
		});
	}

	//��Ӱ�ť����Ӧ�¼�
	addButton.addListener('click',addHandler,false);

	//����ȡ����ť
	var cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});

	//ȡ��������
	var cancelHandler = function(){
		win.close();
	}

	//ȡ����ť����Ӧ�¼�
	cancelButton.addListener('click',cancelHandler,false);

	var win = new Ext.Window({
		title: '��Ӽ�Ч��Ԫ',
		width: 380,
		height:120,
		minWidth: 380,
		minHeight: 120,
		layout: 'fit',
		plain:true,
		modal:true,
		bodyStyle:'padding:5px;',
		buttonAlign:'center',
		items: formPanel,
		buttons: [
			addButton,
			cancelButton
		]
	});
	win.show();
}