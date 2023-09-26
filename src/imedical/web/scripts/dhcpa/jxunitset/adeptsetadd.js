addFun = function(parent,dataStore,pagingTool){
    var codeField = new Ext.form.TextField({
			id:'codeField',
			fieldLabel: '����',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'����д����...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(codeField.getValue()!=""){
							nameField.focus();
						}else{
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'����',msg:'���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});

		var nameField = new Ext.form.TextField({
			id:'nameField',
			fieldLabel: '����',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'����д����...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(nameField.getValue()!=""){
							pyField.focus();
						}else{
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'����',msg:'���Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});

        var pyField = new Ext.form.TextField({
			id:'pyField',
			fieldLabel: 'ƴ��',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'����дƴ��...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						remarkField.focus();
					}
				}
			}
		});

		var remarkField = new Ext.form.TextField({
			id:'remarkField',
			fieldLabel: '��ע',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'����д��ע...',
			anchor: '90%',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						endField.focus();
					}
				}
			}
		});

    var endField = new Ext.form.Checkbox({
		id: 'endField',
		fieldLabel: 'ĩ�˱�־',
		allowBlank: false,
		//checked: (rowObj[0].data['end'])=='Y'?true:false,
        selectOnFocus:'true',
        listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					orderField.focus();
				}
			}
		}
	});

	var orderField = new Ext.form.NumberField({
		id:'orderField',
    	fieldLabel:'˳��',
    	allowBlank:false,
    	emptyText:'˳��...',
    	anchor:'90%',
		width:220,
		listWidth:220,
		selectOnFocus:true,
		allowNegative:false,
		allowDecimals:false,
		listeners :{
			specialKey :function(field,e){
				if (e.getKey() == Ext.EventObject.ENTER){
					if(orderField.getValue()!=""){
						addButton.focus();
					}else{
						Handler = function(){orderField.focus();}
						Ext.Msg.show({title:'����',msg:'˳����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
					}
				}
			}
		}
	});

		//���????
		formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				codeField,
				nameField,
                pyField,
                remarkField,
                endField,
                orderField
			]
		});

		//������Ӱ�ť
		var addButton = new Ext.Toolbar.Button({
			text:'���'
		});

		//��Ӵ�����
		var addHandler = function(){
			var code = codeField.getValue();
			var name = nameField.getValue();
            var py = pyField.getValue();
            var shortcut=code+"-"+name;
            var remark = remarkField.getValue();
            var endAction = (endField.getValue()==true)?'Y':'N';
            var order =  orderField.getValue();
            var flag = "";
            if (type=="0"){
				if(parent==0){flag="0";}
			}else{
				if(parent==0){flag="1";}
			}
			code = trim(code);
			name = trim(name);
			if(code==""){
				Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
			if(name==""){
				Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
			};
            var data=code+"^"+name+"^"+py+"^"+shortcut+"^"+remark+"^"+endAction+"^"+parent+"^"+order+"^"+flag;
            if(data==""){
                Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��,�������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return;
            }
			Ext.Ajax.request({
				url: deptSetUrl+'?action=add&data='+data,
				waitMsg:'�����..',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Handler = function(){codeField.focus();}
						Ext.Msg.show({title:'��ʾ',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK,fn:Handler});
                        Ext.getCmp('detailReport').getNodeById(repdr).reload();
						dataStore.load({params:{start:0, limit:pagingTool.pageSize,parent:parent,type:type,action:'gridlist',active:"",dir:'asc',sort:'order'}});
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'ͬ���´����ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
                        if(jsonData.info=='RepName'){
							Handler = function(){nameField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'ͬ���������ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='dataEmpt'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'����Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
						if(jsonData.info=='unParnet'){
							Handler = function(){codeField.focus();}
							Ext.Msg.show({title:'��ʾ',msg:'�ϼ��ڵ�Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
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
			title: '���'+rooText+'����',
			width: 400,
			height:250,
			minWidth: 400,
			minHeight: 250,
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
};