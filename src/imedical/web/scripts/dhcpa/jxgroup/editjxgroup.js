editFun = function(typeValue,ds,grid,pagingToolbar){
	//���岢��ʼ���ж���
	var rowObj=grid.getSelections();
	//���岢��ʼ���ж��󳤶ȱ���
	var len = rowObj.length;
	//�ж��Ƿ�ѡ����Ҫ�޸ĵ�����
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		var rowid = rowObj[0].get("rowid");
		var CodeField = new Ext.form.TextField({
			id:'CodeField',
			fieldLabel: '�������',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'�������...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'code',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(CodeField.getValue()!=""){
							NameField.focus();
						}else{
							Handler = function(){CodeField.focus();}
							Ext.Msg.show({title:'����',msg:'������벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}




		});
		

		var NameField = new Ext.form.TextField({
			id:'NameField',
			fieldLabel: '��������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'��������...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'name',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(NameField.getValue()!=""){
							TYField.focus();
						}else{
							Handler = function(){NameField.focus();}
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
		var TYField = new Ext.form.ComboBox({
			id: 'TYField',
			fieldLabel: '�������',
			selectOnFocus: true,
			allowBlank: false,
			store: TypeDs,
			anchor: '90%',
			valueNotFoundText:rowObj[0].get("typeName"),
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
						if(TYField.getValue()!=""){
							IsInputField.focus();
						}else{
							Handler = function(){TYField.focus();}
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
			name:'NameStr',
			itemCls:'sex-female', //���󸡶�,����ؼ�����
			clearCls:'allow-float' //�������߸���
		});
		

		var editbutton = new Ext.Toolbar.Button({
			text:'�༭',
			itemCls:'age-field',
			handler:function(){
				var type=Ext.getCmp('TYField').getValue();
				selection(type);
			}

		});
		
		var IsInputDs = new Ext.data.SimpleStore({
            fields: ['key','keyValue'],
            data : [['0','��'],['1','��']]
       });





		 var IsInputField = new Ext.form.ComboBox({
			id:'IsInputField',
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
            selectOnFocus: true,
            forceSelection: true,
	
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(isInputField.getValue()!=""){
                            descField.focus();
                        }else{
                            Handler = function(){isInputField.focus();}
                            Ext.Msg.show({title:'����',msg:'�Ƿ�¼�벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
                        }
					}
				}
			}




		});
		
		


		var DescField = new Ext.form.TextField({
			id:'DescField',
			fieldLabel: '��������',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'��������...',
			anchor: '90%',
			selectOnFocus:'true',
			name:'desc',
			itemCls:'sex-male', //���󸡶�,����ؼ�����
            clearCls:'allow-float' ,//�������߸���

			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						addButton.focus();
					}
				}
			}



		});
		//���岢��ʼ�����
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth: 100,
			items: [
				CodeField,
				NameField,
				TYField,
				IDSet,
				editbutton,
				IsInputField,
				DescField
			]

		});
	

		//������
		formPanel.on('afterlayout', function(panel, layout){
			this.getForm().loadRecord(rowObj[0]);
			TYField.setValue(rowObj[0].get("type"));
			//IDSet.setValue(rowObj[0].get("IDSet"));
			idSet=rowObj[0].get("IDSet");
		});
		

		//���岢��ʼ�������޸İ�ť
		var editButton = new Ext.Toolbar.Button({
			text:'�����޸�'
		});
	

		//�����޸İ�ť��Ӧ����
		editHandler = function(){
			var code = CodeField.getValue();
			var name = NameField.getValue();
			var type = Ext.getCmp('TYField').getValue();
			var IDSet="";
			if(type==1){
				IDSet=KPIDrStr;
			}else{
				IDSet=deptIDStr;
			}

			var isInput = Ext.getCmp('IsInputField').getValue();//�Ƿ�¼��
			var desc = DescField.getValue();
			

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
				Ext.Msg.show({title:'����',msg:'����Ϊ��',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				return false;
			};
			

			Ext.Ajax.request({
				url: '../csp/dhc.pa.jxgroupexe.csp?action=edit&rowid='+rowid+'&data='+data,
				waitMsg:'������...',
				failure: function(result, request){
					Handler = function(){codeField.focus();}
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
				},

				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						ds.load({params:{start:0,limit:pagingToolbar.pageSize,type:typeValue}});
						editwin.close();
					}else{
						if(jsonData.info=='RepCode'){
							Handler = function(){CodeField.focus();}
							Ext.Msg.show({title:'����',msg:'��������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}

						if(jsonData.info=='RepName'){
							Handler = function(){NameField.focus();}
							Ext.Msg.show({title:'����',msg:'���������Ѿ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				},



				scope: this
			});
		}
	


		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	

		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'ȡ���޸�'
		});
	

		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		}
	


		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	

		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸ķ����¼',
			width: 580,
			height:300,
			minWidth: 600, 
			minHeight: 300,
			layout: 'fit',
			plain:true,
			modal:true,
			bodyStyle:'padding:5px;',
			buttonAlign:'center',
			items: formPanel,
			buttons: [
				editButton,
				cancelButton
			]

		});
	

		//������ʾ
		editwin.show();
	}
}