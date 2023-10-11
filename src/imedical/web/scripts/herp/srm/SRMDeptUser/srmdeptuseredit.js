

srmdeptuserEditFun = function() {
	
    var rowObj=itemGrid.getSelectionModel().getSelections();
	var len = rowObj.length;
	if(len < 1){
		Ext.Msg.show({title:'ע��',msg:'��ѡ����Ҫ�޸ĵ�����!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return;
	}else{	
		var rowid = rowObj[0].get("rowid");
		var tmpdeptdr =rowObj[0].get("deptdr");
		var tmpuserdr =rowObj[0].get("userdr");
		var tmpIsDirector =rowObj[0].get("IsDirector");
		var tmpmngdr =rowObj[0].get("mngdr");
		var tmpIsSecretary =rowObj[0].get("IsSecretary");
	}
	
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
		               url: 'herp.srm.srmdeptuserexe.csp'
		                     + '?action=caldept&str='
		                     + encodeURIComponent(Ext.getCmp('unitdeptField').getRawValue()),
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
			value:tmpdeptdr,
			pageSize: 10,
			minChars: 1,
			forceSelection : true,
			selectOnFocus:true,
		    editable:true,
		    labelSeparator:''
	});

	/* unitdeptField.on('select',function(combo, record, index){
		tmpdeptdr = combo.getValue();
	}); */
	
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
		   url : 'herp.srm.srmdeptuserexe.csp'
		         +'?action=caluser&str='
		         +encodeURIComponent(Ext.getCmp('unituserField').getRawValue()),
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
			value:tmpuserdr,
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			labelSeparator:''
	});
	
	/* unituserField.on('select',function(combo, record, index){
		tmpuserdr = combo.getValue();
	}); */

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
		   url : 'herp.srm.srmdeptuserexe.csp'
		         +'?action=caluser&str='
		         +encodeURIComponent(Ext.getCmp('mngnameField').getRawValue()),
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
			name: 'mngnameField',
			value:tmpmngdr,
			minChars: 1,
			pageSize: 10,
			selectOnFocus:true,
			forceSelection:'true',
			editable:true,
			labelSeparator:''
	});
	
	/* mngnameField.on('select',function(combo, record, index){
		tmpmngdr = combo.getValue();
	}); */

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
				//valueNotFoundText : '',
				displayField : 'keyValue',
				valueField : 'key',
				value:tmpIsSecretary,
				mode : 'local', // ����ģʽ
				triggerAction: 'all',
				//emptyText:'��ѡ��...',
				selectOnFocus:true,
				forceSelection : true,
				labelSeparator:''
			});	
		
	        /* IsSecretaryField.on('select',function(combo, record, index){
			tmpIsSecretary = combo.getValue();
		}); */
//�Ƿ������
	var IsDirecterStore = new Ext.data.SimpleStore({
			fields : ['key', 'keyValue'],
			data : [['N', '��'], ['Y', '��']]
		});
	var IsDirecterField = new Ext.form.ComboBox({
            id : 'IsDirecterField',
			fieldLabel : '�Ƿ������',
			width : 200,
			listWidth : 200,
			store : IsDirecterStore,
			//valueNotFoundText : '',
			displayField : 'keyValue',
			valueField : 'key',
			mode : 'local', // ����ģʽ
			triggerAction: 'all',
			//name:'IsDMField',
			//emptyText:'��ѡ��...',
			value:tmpIsDirector,
			selectOnFocus:true,
			forceSelection : true,
			labelSeparator:''
		});	
	/* IsDirecterField.on('select',function(combo, record, index){
		tmpIsDirector = combo.getValue();
	}); */
	//���岢��ʼ�����
 var formPanel = new Ext.form.FormPanel({
			baseCls : 'x-plain',
			labelWidth : 100,
			labelAlign: 'right',
			items : [unitdeptField,unituserField,IsDirecterField,mngnameField,IsSecretaryField]
		});
				                                                                                            //
    //������
    formPanel.on('afterlayout', function(panel, layout) { 
                                                                                              //
			this.getForm().loadRecord(rowObj[0]);
			unitdeptField.setRawValue(rowObj[0].get("deptname"));	
			unituserField.setRawValue(rowObj[0].get("username"));	
			IsDirecterField.setRawValue(rowObj[0].get("IsDirectorlist"));
			mngnameField.setRawValue(rowObj[0].get("mngname"));
			IsSecretaryField.setRawValue(rowObj[0].get("IsSecretarylist"));		                                                                        //
    });   
    
	    //���岢��ʼ�������޸İ�ť
	    var editButton = new Ext.Toolbar.Button({
				text:'����',
				iconCls: 'save'
			});                                                                                                                                            //
                    
		        //�����޸İ�ť��Ӧ����
			    editHandler = function(){
		
		        var rowObj=itemGrid.getSelectionModel().getSelections();
		        var rowid = rowObj[0].get("rowid");          
				var deptdr = unitdeptField.getValue(); 
				var userdr = unituserField.getValue(); 
				var IsDirector = IsDirecterField.getValue(); 
                var mngdr = mngnameField.getValue(); 
                var IsSecretary = IsSecretaryField.getValue(); 
                Ext.Ajax.request({
				url:'herp.srm.srmdeptuserexe.csp?action=edit&rowid='+rowid+'&deptdr='+deptdr
				+'&userdr='+userdr+'&IsDirector='+IsDirector+'&mngdr='+mngdr+'&IsSecretary='+IsSecretary,
				
				waitMsg:'������...',
				failure: function(result, request) {
					Ext.Msg.show({title:'����',msg:'������������!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.ERROR});
				},
				
				success: function(result, request){
			   	var jsonData = Ext.util.JSON.decode( result.responseText );
				if (jsonData.success=='true'){
					Ext.Msg.show({title:'ע��',msg:'�޸ĳɹ�!',icon:Ext.MessageBox.INFO,buttons:Ext.Msg.OK});
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
					};
			},
				scope: this
			});
			editwin.close();
		};
		//��ӱ����޸İ�ť�ļ����¼�
		editButton.addListener('click',editHandler,false);
	
		//���岢��ʼ��ȡ���޸İ�ť
		var cancelButton = new Ext.Toolbar.Button({
			text:'�ر�',
			iconCls : 'cancel'
		});
	
		//����ȡ���޸İ�ť����Ӧ����
		cancelHandler = function(){
			editwin.close();
		};
	
		//���ȡ����ť�ļ����¼�
		cancelButton.addListener('click',cancelHandler,false);
	
		//���岢��ʼ������
		var editwin = new Ext.Window({
			title: '�޸���֯��ϵ��Ϣ',
			iconCls: 'pencil',
			width : 400,
			height : 260,    
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
	};
