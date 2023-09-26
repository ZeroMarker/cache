function trim(str){
  var tmp=str.replace(/(^\s*)|(\s*$)/g, "");
  return tmp;
}
addFun = function(userDr,outDs,outPagingToolbar){
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel: '��Ա����',
		allowBlank: false,
		width:150,
		listWidth : 150,
		emptyText:'�ӿ���Ա����...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(codeField.getValue()!=""){
						nameField.focus();
					}else{
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'����',msg:'�ӿ���Ա���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel: '��Ա����',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'�ӿ���Ա����...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(nameField.getValue()!=""){
						interLocSetField.focus();
					}else{
						Handler = function(){nameField.focus();}
						Ext.Msg.show({title:'����',msg:'�ӿ���Ա���Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});

	var interLocSetDs = new Ext.data.Store({
		autoLoad:true,
		proxy:"",
		reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
	});

	interLocSetDs.on('beforeload', function(ds, o){
		ds.proxy=new Ext.data.HttpProxy({
			url:'../csp/dhc.pa.interpersonexe.csp?action=set&str='+encodeURIComponent(Ext.getCmp('interLocSetField').getRawValue()),method:'POST'})
	});

	var interLocSetField = new Ext.form.ComboBox({
		id: 'interLocSetField',
		fieldLabel: '�����ӿ���',
		width:213,
		listWidth : 213,
        allowBlank: false,
		store: interLocSetDs,
		valueField: 'rowid',
		displayField: 'name',
		triggerAction: 'all',
		emptyText:'��ѡ��ӿ���...',
		name: 'interLocSetField',
		minChars: 1,
		pageSize: 10,
		selectOnFocus:true,
		forceSelection:'true',
		editable:true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(interLocSetField.getValue()!=""){
						remarkField.focus();
					}else{
						Handler = function(){interLocSetField.focus();}
						Ext.Msg.show({title:'����',msg:'�����ӿ��ײ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});
	
	var remarkField = new Ext.form.TextField({
		id:'remarkField',
		fieldLabel: '��Ա��ע',
		allowBlank: true,
		width:150,
		listWidth : 150,
		emptyText:'��Ա��ע...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					addButton.focus();
				}
			}
		}
	});
	
	var formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth:100,
		items: [
			codeField,
			nameField,
			interLocSetField,
			remarkField
		]
	});
	
	var addButton = new Ext.Toolbar.Button({
		text:'���'
	});
			
	//��Ӵ�����
	var addHandler = function(){
		var code = Ext.getCmp('codeField').getValue();
		var name = Ext.getCmp('nameField').getValue();
		var interLocSetDr = Ext.getCmp('interLocSetField').getValue();
		var remark = Ext.getCmp('remarkField').getValue();
		
		code=trim(code);
		if(code==""){
			Ext.Msg.show({title:'��ʾ',msg:'�ӿ���Ա����Ϊ��!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
			return false;
		}
		
		Ext.Ajax.request({
			url:'../csp/dhc.pa.interpersonexe.csp?action=add&inDr='+userDr+'&code='+code+'&name='+encodeURIComponent(name)+'&interLocSetDr='+interLocSetDr+'&remark='+encodeURIComponent(remark),
			waitMsg:'�����..',
			failure: function(result, request){
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
					outDs.load({params:{start:0, limit:outPagingToolbar.pageSize,inDr:userDr,dir:'asc',sort:'rowid'}});
				}else{
					if(jsonData.info=='RepRecode'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'��ʾ',msg:'���ݼ�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='NoUser'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'��ʾ',msg:'û���ڲ���Ա��¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
					}
					if(jsonData.info=='NoInterLocSetDr'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'��ʾ',msg:'û�нӿ���!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO,fn:Handler});
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
		title: '����ڲ���Ա',
		width: 380,
		height:200,
		minWidth: 380,
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