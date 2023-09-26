editFun = function(userDr,outDs,OutGrid,outPagingToolbar){
	var rowObj = OutGrid.getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ��ڲ���¼!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return false;
	}else{
		var CodeField = new Ext.form.TextField({
			id:'CodeField',
			fieldLabel: '��Ա����',
			allowBlank: false,
			width:150,
			listWidth : 150,
			emptyText:'�ӿ���Ա����...',
			anchor: '90%',
			name:'code',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(CodeField.getValue()!=""){
							NameField.focus();
						}else{
							Handler = function(){CodeField.focus();}
							Ext.Msg.show({title:'����',msg:'�ӿ���Ա���벻��Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var NameField = new Ext.form.TextField({
			id:'NameField',
			fieldLabel: '��Ա����',
			allowBlank: false,
			width:180,
			listWidth : 180,
			emptyText:'�ӿ���Ա����...',
			anchor: '90%',
			name:'name',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(NameField.getValue()!=""){
							InterLocSetField.focus();
						}else{
							Handler = function(){NameField.focus();}
							Ext.Msg.show({title:'����',msg:'�ӿ���Ա���Ʋ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});

		var InterLocSetDs = new Ext.data.Store({
			autoLoad:true,
			proxy:"",
			reader:new Ext.data.JsonReader({totalProperty:'results',root:'rows'},['rowid','name'])
		});

		InterLocSetDs.on('beforeload', function(ds, o){
			ds.proxy=new Ext.data.HttpProxy({
				url:'dhc.pa.interpersonexe.csp?action=set&str='+Ext.getCmp('InterLocSetField').getRawValue(),method:'POST'})
		});

		var InterLocSetField = new Ext.form.ComboBox({
			id: 'InterLocSetField',
			fieldLabel: '�����ӿ���',
			width:213,
			listWidth : 213,
			allowBlank: false,
			store: InterLocSetDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			emptyText:'��ѡ��ӿ���...',
			valueNotFoundText:rowObj[0].get("LocSetName"),
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						if(InterLocSetField.getValue()!=""){
							RemarkField.focus();
						}else{
							Handler = function(){InterLocSetField.focus();}
							Ext.Msg.show({title:'����',msg:'�����ӿ��ײ���Ϊ��!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR,fn:Handler});
						}
					}
				}
			}
		});
		
		var RemarkField = new Ext.form.TextField({
			id:'RemarkField',
			fieldLabel: '��Ա��ע',
			allowBlank: true,
			width:150,
			listWidth : 150,
			emptyText:'��Ա��ע...',
			anchor: '90%',
			name:'remark',
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						activeField.focus();
					}
				}
			}
		});
	
		var activeField = new Ext.form.Checkbox({
			id: 'activeField',
			labelSeparator: '��Ч��־:',
			allowBlank: false,
			checked: (rowObj[0].data['active'])=='Y'?true:false,
			selectOnFocus:'true',
			listeners :{
				specialKey :function(field,e){
					if (e.getKey() == Ext.EventObject.ENTER){
						editButton.focus();
					}
				}
			}
		});
		
		var formPanel = new Ext.form.FormPanel({
			baseCls: 'x-plain',
			labelWidth:100,
			items: [
				CodeField,
				NameField,
				InterLocSetField,
				RemarkField,
				activeField
			]
		});
		
		formPanel.on('afterlayout', function(panel,layout) {
			this.getForm().loadRecord(rowObj[0]);
			InterLocSetField.setValue(rowObj[0].get('inLocSetDr'));
		});	
		
		var editButton = new Ext.Toolbar.Button({
			text:'�޸�'
		});
				
		//��Ӵ�����
		var editHandler = function(){
			var code = Ext.getCmp('CodeField').getValue();
			var name = Ext.getCmp('NameField').getValue();
			var interLocSetDr = Ext.getCmp('InterLocSetField').getValue();
			var remark = Ext.getCmp('RemarkField').getValue();
			var active = (activeField.getValue()==true)?'Y':'N';
			
			code=trim(code);
			var rowid=rowObj[0].get("rowid");
			
			Ext.Ajax.request({
				url:'dhc.pa.interpersonexe.csp?action=edit&inDr='+userDr+'&remark='+remark+'&code='+code+'&active='+active+'&rowid='+rowid+'&interLocSetDr='+interLocSetDr+'&name='+name,
				waitMsg:'�����..',
				failure: function(result, request){
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				success: function(result, request){
					var jsonData = Ext.util.JSON.decode( result.responseText );
					if (jsonData.success=='true'){
						Ext.Msg.show({title:'��ʾ',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
						outDs.load({params:{start:outPagingToolbar.cursor,limit:outPagingToolbar.pageSize,inDr:userDr,dir:'asc',sort:'rowid'}});
						win.close();
					}else{
						if(jsonData.info=='RepRecode'){
							Ext.Msg.show({title:'��ʾ',msg:'���ݼ�¼�ظ�!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
						if(jsonData.info=='rowidEmpt'){
							Ext.Msg.show({title:'��ʾ',msg:'��������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
						}
					}
				},
				scope: this
			});
		}

		//��Ӱ�ť����Ӧ�¼�
		editButton.addListener('click',editHandler,false);

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
			title: '�޸��ڲ���Ա',
			width: 380,
			height:200,
			minWidth: 380,
			minHeight: 200,
			layout:'fit',
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
		win.show();	
	}
}