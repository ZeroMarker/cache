addFun = function(typeValue,ds,pagingToolbar){
	var codeField = new Ext.form.TextField({
		id:'codeField',
		fieldLabel: '�������',
		allowBlank: false,
		width:150,
		listWidth : 150,
		emptyText:'�������...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(codeField.getValue()!=""){
						nameField.focus();
					}else{
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'����',msg:'������벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}




	});
	

	var nameField = new Ext.form.TextField({
		id:'nameField',
		fieldLabel: '��������',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'��������...',
		anchor: '90%',
		selectOnFocus:'true',
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(nameField.getValue()!=""){
						isInputField.focus();
					}else{
						Handler = function(){nameField.focus();}
						Ext.Msg.show({title:'����',msg:'�������Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}




	});
	

	var TypeDs = new Ext.data.SimpleStore({
		fields: ['key','keyValue'],
		data : [['1','1-ָ��'],['2','2-��Ч��Ԫ']]
	});
	var TField = new Ext.form.ComboBox({
		id: 'TField',
		fieldLabel: '�������',
		//width : 280,
		//listWidth : 280,
		selectOnFocus: true,
		allowBlank: false,
		store: TypeDs,
		anchor: '90%',
		value:'1', //Ĭ��ֵ
		valueNotFoundText:'1-ָ��',
		displayField: 'keyValue',
		valueField: 'key',
		triggerAction: 'all',
		emptyText:'ѡ��������...',
		mode: 'local', //����ģʽ
		editable:false,
		pageSize: 10,
		minChars: 1,
		selectOnFocus: true,
		forceSelection: true,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(TField.getValue()!=""){
						descField.focus();
					}else{
						Handler = function(){TField.focus();}
						Ext.Msg.show({title:'����',msg:'���������Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}




	});
	

	IDSet = new Ext.form.TextArea({
		id:'IDSet',
		width:355,
		height:60,
		labelWidth:20,
		fieldLabel: 'ָ���Ч��Ԫ',
		readOnly:true,
		itemCls:'sex-female', //���󸡶�,����ؼ�����
		clearCls:'allow-float' //�������߸���

	});
	

	var editorbutton = new Ext.Toolbar.Button({
		text:'�༭',
		itemCls:'age-field',
		handler:function(){
			var type=Ext.getCmp('TField').getValue();
			selection(type);
		}

	});
	

//�Ƿ�¼��
    var IsInputDs = new Ext.data.SimpleStore({
        fields: ['key','keyValue'],
        data : [['0','��'],['1','��']]
    });

	var isInputField = new Ext.form.ComboBox({
		id:'isInputField',
		width : 180,
        listWidth : 180,
        fieldLabel:'�Ƿ�¼��',
        selectOnFocus: true,
        allowBlank: false,
        store: IsInputDs,
        emptyText:'�Ƿ�¼��...',
        anchor: '90%',

		value:'1', //Ĭ��ֵ
        valueNotFoundText : '��',
        displayField: 'keyValue',
        valueField: 'key',
        triggerAction: 'all',
        mode: 'local', //����ģʽ
        editable:false,
        pageSize: 10,
        minChars: 1,
        itemCls:'sex-male', //���󸡶�,����ؼ�����
        clearCls:'allow-float', //�������߸���









		selectOnFocus:true,
		forceSelection: true,
		//allowNegative:false,
		//allowDecimals:false,

		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(isInputField.getValue()!=""){
						//TypeField.focus();
						 descField.focus();
					}else{
						Handler = function(){isInputField.focus();}
						Ext.Msg.show({title:'����',msg:'�Ƿ�¼�벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}




	});
		
	
		


	var descField = new Ext.form.TextField({
		id:'descField',
		fieldLabel: '��������',
		allowBlank: false,
		width:180,
		listWidth : 180,
		emptyText:'��������...',
		anchor: '90%',
		selectOnFocus:'true',
		itemCls:'sex-male', //���󸡶�,����ؼ�����
        clearCls:'allow-float', //�������߸���

		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					addButton.focus();
				}
			}
		}



	});
		

	//��ʼ�����
	formPanel = new Ext.form.FormPanel({
		baseCls: 'x-plain',
		labelWidth: 100,

		items:[
			codeField,
			nameField,
			TField,
			IDSet,
			editorbutton,
			isInputField,
			descField
		]




















	});
		

	//��ʼ����Ӱ�ť
	addButton = new Ext.Toolbar.Button({
		text:'�� ��'
	});
		

	//������Ӱ�ť��Ӧ����
	addHandler = function(){
		var code = codeField.getValue();
		var name = nameField.getValue();
		var type = Ext.getCmp('TField').getValue();
		var IDSet="";
		if(type==1){
			IDSet=KPIDrStr;
		}else{
			IDSet=deptIDStr;
		}

		var isInput = Ext.getCmp('isInputField').getValue();//�Ƿ�¼��
		var desc = descField.getValue();
		code = trim(code);
		if(code==""){
			Ext.Msg.show({title:'����',msg:'�������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		name = trim(name);
		if(name==""){
			Ext.Msg.show({title:'����',msg:'��������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		type = trim(type);
		if(type==""){
			Ext.Msg.show({title:'����',msg:'�������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		var data = code+"^"+name+"^"+IDSet+"^"+isInput+"^"+type+"^"+desc;
		data = trim(data);
		if(data==""){
			Ext.Msg.show({title:'����',msg:'�������Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
			return false;
		};
		
		


		Ext.Ajax.request({
			url: '../csp/dhc.pa.jxgroupexe.csp?action=add&data='+data,
			waitMsg:'������...',
			failure: function(result, request){
				Handler = function(){codeField.focus();}
				Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
			},
			success: function(result, request){
				var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
					ds.load({params:{start:0,limit:pagingToolbar.pageSize,type:typeValue}});
				}else{
					if(jsonData.info=='RepCode'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'����',msg:'�˷�������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}

					if(jsonData.info=='RepName'){
						Handler = function(){nameField.focus();}
						Ext.Msg.show({title:'����',msg:'�˷��������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}


			},
			scope: this
		});
	}
	

	//��ӱ��水ť�ļ����¼�
	addButton.addListener('click',addHandler,false);
	

	//��ʼ��ȡ����ť
	cancelButton = new Ext.Toolbar.Button({
		text:'ȡ��'
	});
	

	//����ȡ����ť����Ӧ����
	cancelHandler = function(){
		addwin.close();
	}
	

	//���ȡ����ť�ļ����¼�
	cancelButton.addListener('click',cancelHandler,false);

	//��ʼ������
	addwin = new Ext.Window({
		title: '��ӷ����¼',
		width: 580,
        height:300,
		minWidth: 600, 
		minHeight: 290,
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
	

	//������ʾ
	addwin.show();
}