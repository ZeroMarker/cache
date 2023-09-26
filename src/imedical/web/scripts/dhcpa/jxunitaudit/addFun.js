addFun = function(store,pagingToolbar){
	var jxUnitDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['jxUnitDr','jxUnitShortCut'])
	});

	

	var jxUnit = new Ext.ux.form.LovCombo({
		id:'jxUnit',
		fieldLabel:'��Ч��Ԫ',
		width:213,
		listWidth : 213,
		allowBlank:true,
		store:jxUnitDs,
		valueField:'jxUnitDr',
		displayField:'jxUnitShortCut',
		emptyText:'��ѡ��Ч��Ԫ...',
		triggerAction:'all',
		name: 'jxUnit',
		emptyText:'',
		minChars:1,
		//pageSize:10,
		//selectOnFocus:true,
		//forceSelection:'true',
		editable:false/*,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(jxUnit.getValue()!=""){
						userField.focus();
					}else{
						Handler = function(){jxUnit.focus();}
						Ext.Msg.show({title:'����',msg:'��Ч��Ԫ����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}*/
	});
	
	var userDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});

	userDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'../csp/dhc.pa.jxunitauditexe.csp?action=user&str='+encodeURIComponent(Ext.getCmp('userField').getRawValue()),method:'POST'})
	});

	var userField = new Ext.form.ComboBox({
		id: 'userField',
		fieldLabel: 'Ȩ���û�',
		width:213,
		listWidth : 213,
        allowBlank: false,
		store: userDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ��Ȩ���û�...',
		name: 'userField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(userField.getValue()!=""){
						isReadField.focus();
					}else{
						Handler = function(){userField.focus();}
						Ext.Msg.show({title:'����',msg:'Ȩ���û�����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var isReadField = new Ext.form.Checkbox({
		id: 'isRead',
		labelSeparator:'��Ȩ��',
		allowBlank: false,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					isWriteField.focus();
				}
			}
		}
	});
			
	var isWriteField = new Ext.form.Checkbox({
		id: 'isWrite',
		labelSeparator:'дȨ��',
		allowBlank: false,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					addButton.focus();
				}
			}
		}
	});
	
	jxUnitDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'dhc.pa.jxunitauditexe.csp?action=jxunit&str='+encodeURIComponent(Ext.getCmp('jxUnit').getRawValue())+"&userId="+Ext.getCmp('userField').getValue(),method:'POST'})
	});
	userField.on("select",function(cmb,rec,id ){
				jxUnitDs.proxy = new Ext.data.HttpProxy({
					url:'dhc.pa.jxunitauditexe.csp?action=jxunit&str='+encodeURIComponent(Ext.getCmp('jxUnit').getRawValue())+"&userId="+Ext.getCmp('userField').getValue(),method:'POST'})
				jxUnitDs.load({params:{userId:Ext.getCmp('userField').getValue()}});
			});
	formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:70,
		items: [
			
			userField,
			jxUnit,
			isReadField,
			isWriteField
		]
	});
	
	//������Ӱ�ť
	var addButton = new Ext.Toolbar.Button({
		text:'���'
	});
			
	//��Ӵ�����
	var addHandler = function(){
		var jxunitdr = Ext.getCmp('jxUnit').getValue();
		var userdr = Ext.getCmp('userField').getValue();
		var isRead = (isReadField.getValue()==true)?'Y':'N';
		var isWrite = (isWriteField.getValue()==true)?'Y':'N';
		userdr = trim(userdr);
		if(userdr==""){
			Ext.Msg.show({title:'��ʾ',msg:'�û�Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		var data = jxunitdr+"^"+userdr+"^"+isRead+"^"+isWrite;
		
		Ext.Ajax.request({
			url:'../csp/dhc.pa.jxunitauditexe.csp?action=add&data='+data,
			waitMsg:'�����..',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					store.load({params:{start:0, limit:pagingToolbar.pageSize,jxunitdr:jxunitdr,dir:'asc',sort:'rowid'}});
				}else{
					if(jsonData.info=='RepRecode'){
						Handler = function(){jxUnit.focus();}
						Ext.Msg.show({title:'��ʾ',msg:'���û��Ѿ�ӵ�иü�Ч��Ԫ��Ȩ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='dataEmpt'){
						Handler = function(){jxUnit.focus();}
						Ext.Msg.show({title:'����',msg:'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
		title: '��Ӽ�Ч��ԪȨ���û�',
		width: 350,
		height:200,
		minWidth: 350,
		minHeight: 200,
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