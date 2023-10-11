

srmdeptuserAddFun = function() {

//��ȡ��������
	var unitdeptDs = new Ext.data.Store({
		      autoLoad:true,
		      proxy : "",
		      reader : new Ext.data.JsonReader({
		                 totalProperty : 'results',
		                 root : 'rows'
		              }, ['rowid','name'])
     });


	unitdeptDs.on('beforeload', function(ds, o){

		     ds.proxy=new Ext.data.HttpProxy({
		               url: 'herp.srm.srmdeptuserexe.csp'+ '?action=caldept&str='+ encodeURIComponent(Ext.getCmp('unitdeptField').getRawValue()),
		               method:'POST'
		              });
     	});
     
	var unitdeptField = new Ext.form.ComboBox({
			id: 'unitdeptField',
			fieldLabel: '��������',
			width:200,
			listWidth : 250,
			allowBlank: false,
			store: unitdeptDs,
			displayField: 'name',
			valueField: 'rowid',
			triggerAction: 'all',
			typeAhead : true,
			triggerAction : 'all',
			//emptyText : '��ѡ���������...',
			name: 'unitdeptField',
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});
//��ȡ��Ա����
	var unituserDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
			           totalProperty:'results',
			           root:'rows'
			       },['rowid','name'])
     });
     
	unituserDs.on('beforeload', function(ds, o){
		   ds.proxy = new Ext.data.HttpProxy({
		   url : 'herp.srm.srmdeptuserexe.csp'+'?action=caluser&str='+encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),
		         method:'POST'
		       });
	});

	var unituserField = new Ext.form.ComboBox({
			id: 'unituserField',
			fieldLabel: '��Ա����',
			width:200,
			listWidth :250,
			allowBlank: false,
			store: unituserDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'��ѡ����Ա����...',
			name: 'unituserField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			labelSeparator:''
	});

//��ȡ�ϼ��쵼����
	var mngnameDs = new Ext.data.Store({
			autoLoad : true,
			proxy : "",
			reader : new Ext.data.JsonReader({
			           totalProperty:'results',
			           root:'rows'
			       },['rowid','name'])
	     });
     
	mngnameDs.on('beforeload', function(ds, o){
		   ds.proxy = new Ext.data.HttpProxy({
		   url : 'herp.srm.srmdeptuserexe.csp'+'?action=caluser&str='+encodeURIComponent(Ext.getCmp('mngnameField').getRawValue()),
		         method:'POST'
		       });
	});

	var mngnameField = new Ext.form.ComboBox({
			id: 'mngnameField',
			fieldLabel: '�ϼ��쵼',
			width:200,
			listWidth :250,
			//allowBlank: false,
			store: mngnameDs,
			valueField: 'rowid',
			displayField: 'name',
			triggerAction: 'all',
			//emptyText:'��ѡ����Ա����...',
			name: 'unituserField',
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			labelSeparator:''
	});

//�Ƿ������
	var IsDMStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['N', '��'], ['Y', '��']]
		});
	var IsDMField = new Ext.form.ComboBox({
            id : 'IsDMField',
			fieldLabel : '�Ƿ������',
			width : 200,
			listWidth : 200,
			store : IsDMStore,
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			mode : 'local', // ����ģʽ
			triggerAction: 'all',
			//emptyText:'��ѡ��...',
			selectOnFocus:true,
			forceSelection : true,
			labelSeparator:''
		});	
	
//�Ƿ������
	var IsSecretaryStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['N', '��'], ['Y', '��']]
		});
	var IsSecretaryField = new Ext.form.ComboBox({
            id : 'IsSecretaryField',
			fieldLabel : '�Ƿ������',
			width : 200,
			listWidth : 200,
			store : IsSecretaryStore,
			valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			mode : 'local', // ����ģʽ
			triggerAction: 'all',
			//emptyText:'��ѡ��...',
			selectOnFocus:true,
			forceSelection : true,
			labelSeparator:''
		});	
	
	var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			labelAlign: 'right',
			items : [unitdeptField, unituserField,IsDMField,mngnameField,IsSecretaryField]
		});
	
	var addWin = new Ext.Window({
		    
			title : '������֯��ϵ��Ϣ',
			iconCls: 'edit_add',
			width : 400,
			height : 260,
			layout : 'fit',
			plain : true,
			modal : true,
			bodyStyle : 'padding:5px;',
			buttonAlign : 'center',
			items : formPanel,
			buttons : [{		 
				text : '����',
				iconCls: 'save',
				handler : function() {
					if (formPanel.form.isValid()) {
					var deptdr = unitdeptField.getValue();
					var userdr = unituserField.getValue();
					var IsDirector = IsDMField.getValue();
					var mngdr = mngnameField.getValue();
					var IsSecretary = IsSecretaryField.getValue();
					
			
					Ext.Ajax.request({
					url:'herp.srm.srmdeptuserexe.csp?action=add&deptdr='+deptdr+'&userdr='+userdr
					+'&IsDirector='+IsDirector+'&mngdr='+mngdr+'&IsSecretary='+IsSecretary,
					waitMsg:'������...',
					failure: function(result, request){		
						Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
					},
					success: function(result, request){
						var jsonData = Ext.util.JSON.decode( result.responseText );
						if (jsonData.success=='true'){				
							Ext.Msg.show({title:'ע��',msg:'��ӳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});					
							itemGridDs.load({params:{start:0, limit:itemGridPagingToolbar.pageSize}});
						}
						else
						{
							var message=jsonData.info;
							if(message=="RepName"){
								Ext.Msg.show({title:'����',msg:'���������Ѵ��ڣ�',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
							if(message=="RepUser"){
								Ext.Msg.show({title:'����',msg:'���˵���֯��ϵ��ά����',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
							}
							
						}
					},
					scope: this			
				  });
				  addWin.close();
				} 
				}					
			},
			{
				text : '�ر�',
				iconCls : 'cancel',
				handler : function() {
					addWin.close();
				}
			}]
		});
		addWin.show();
	};
